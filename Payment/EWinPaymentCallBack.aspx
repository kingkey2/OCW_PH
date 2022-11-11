<%@ Page Language="C#" AutoEventWireup="true" CodeFile="EWinPaymentCallBack.aspx.cs" Inherits="Payment_EWinPaymentCallBack" %>

<%
    PaymentCallbackResult R = new PaymentCallbackResult() { Result = 1 };
    string GUID = System.Guid.NewGuid().ToString();
    string Token = GetToken();
    string PromotionCollectKey;

    if (CodingControl.FormSubmit()) {
        string PostBody = String.Empty;
        PaymentCallbackInfo BodyObj = new PaymentCallbackInfo();


        using (System.IO.StreamReader reader = new System.IO.StreamReader(Request.InputStream)) {
            PostBody = reader.ReadToEnd();
        };

        if (string.IsNullOrEmpty(PostBody) == false) {
            try { BodyObj = Newtonsoft.Json.JsonConvert.DeserializeObject<PaymentCallbackInfo>(PostBody); } catch (Exception ex) {
                BodyObj = null;
            }

            if (BodyObj != null) {

                EWin.Payment.PaymentAPI paymentAPI = new EWin.Payment.PaymentAPI();
                EWin.FANTA.FANTA fantaAPI = new EWin.FANTA.FANTA();
                EWin.OCW.OCW ocwAPI = new EWin.OCW.OCW();

                EWin.Payment.PaymentResult paymentResult = paymentAPI.GetPaymentByClientOrderNumber(Token, GUID, BodyObj.ClientOrderNumber);
                //回去EWin確認該筆訂單存在

                if (paymentResult.ResultStatus == EWin.Payment.enumResultStatus.OK) {
                    if (BodyObj.DirectionType == "Deposit") {
                        if (BodyObj.Action == "Create") {
                            R.Result = 0;
                        } else if (BodyObj.Action == "Finished") {
                            EWinTagInfoData tagInfoData;
                            //訂單完成，先處理入金產生的門檻

                            try { tagInfoData = Newtonsoft.Json.JsonConvert.DeserializeObject<EWinTagInfoData>(BodyObj.TagInfo); } catch (Exception ex) {
                                tagInfoData = null;
                            }

                            if (tagInfoData != null) {

                                System.Data.DataTable PaymentDT = EWinWebDB.UserAccountPayment.GetPaymentByOrderNumber(BodyObj.ClientOrderNumber);

                                if (PaymentDT != null && PaymentDT.Rows.Count > 0) {
                                    EWin.Lobby.LobbyAPI lobbyAPI = new EWin.Lobby.LobbyAPI();
                                    EWin.Lobby.APIResult addThresholdResult;
                                    string description;
                                    string JoinActivityCycle;
                                    string transactionCode;
                                    string CollectAreaType;
                                    int PaymentFlowStatus = (int)PaymentDT.Rows[0]["FlowStatus"];
                                    bool ResetThreshold = false;
                                    decimal ThresholdValue;

                                    if (PaymentFlowStatus == 1) {
                                        transactionCode = BodyObj.PaymentSerial;
                                        description = "Deposit, PaymentCode=" + tagInfoData.PaymentCode + ", Amount=" + BodyObj.Amount;
                                        ResetThreshold = CheckResetThreshold(BodyObj.LoginAccount);
                                        ThresholdValue = GetUserThresholdValue(BodyObj.LoginAccount);

                                        if (ThresholdValue == 0) {
                                            lobbyAPI.RemoveUserAccountProperty(GetToken(), GUID, EWin.Lobby.enumUserTypeParam.ByLoginAccount, BodyObj.LoginAccount, "JoinActivity");
                                        }

                                        addThresholdResult = lobbyAPI.AddThreshold(Token, GUID, transactionCode, BodyObj.LoginAccount, EWinWeb.MainCurrencyType, tagInfoData.ThresholdValue, description, ResetThreshold);

                                        if (addThresholdResult.Result == EWin.Lobby.enumResult.OK || addThresholdResult.Message == "-2") {

                                            if (tagInfoData.IsJoinDepositActivity) {
                                                //有參加入金活動
                                                foreach (var activityData in tagInfoData.ActivityDatas) {
                                                    List<EWin.Lobby.PropertySet> PropertySets = new List<EWin.Lobby.PropertySet>();
                                                    description = activityData.ActivityName;
                                                    PromotionCollectKey = description + "_" + BodyObj.ClientOrderNumber;
                                                    JoinActivityCycle = activityData.JoinActivityCycle == null ? "1" : activityData.JoinActivityCycle;
                                                    CollectAreaType = activityData.CollectAreaType == null ? "1" : activityData.CollectAreaType;

                                                    PropertySets.Add(new EWin.Lobby.PropertySet { Name = "ThresholdValue", Value = activityData.ThresholdValue.ToString() });
                                                    PropertySets.Add(new EWin.Lobby.PropertySet { Name = "PointValue", Value = activityData.BonusValue.ToString() });
                                                    PropertySets.Add(new EWin.Lobby.PropertySet { Name = "JoinActivityCycle", Value = JoinActivityCycle.ToString() });

                                                    lobbyAPI.AddPromotionCollect(Token, PromotionCollectKey, BodyObj.LoginAccount, EWinWeb.MainCurrencyType, int.Parse(CollectAreaType), 90, description, PropertySets.ToArray());
                                                    EWinWebDB.UserAccountEventSummary.UpdateUserAccountEventSummary(BodyObj.LoginAccount, description, JoinActivityCycle, 1, activityData.ThresholdValue, activityData.BonusValue);
                                                }
                                            }

                                            var allParentBonusAfterDepositResult = ActivityCore.GetAllParentBonusAfterDepositResult(BodyObj.LoginAccount);

                                            if (allParentBonusAfterDepositResult.Result == ActivityCore.enumActResult.OK) {
                                                System.Data.DataTable ParentPaymentDT = null;
                                                decimal ParentDepositAmount = 0;

                                                foreach (var activityData in allParentBonusAfterDepositResult.Data) {

                                                    if (ParentPaymentDT == null) {
                                                        ParentPaymentDT =  RedisCache.UserAccount.GetUserAccountByLoginAccount(activityData.ParentLoginAccount);
                                                        if (ParentPaymentDT != null) {
                                                            if (ParentPaymentDT.Rows.Count > 0) {
                                                                ParentDepositAmount = (decimal)ParentPaymentDT.Rows[0]["DepositAmount"];
                                                            }
                                                        }
                                                    }

                                                    if (ParentDepositAmount > 500) {
                                                        List<EWin.Lobby.PropertySet> PropertySets = new List<EWin.Lobby.PropertySet>();
                                                        description = activityData.ActivityName;
                                                        PromotionCollectKey = description + "_" + BodyObj.ClientOrderNumber;
                                                        JoinActivityCycle = activityData.JoinActivityCycle == null ? "1" : activityData.JoinActivityCycle;
                                                        CollectAreaType = activityData.CollectAreaType == null ? "1" : activityData.CollectAreaType;

                                                        PropertySets.Add(new EWin.Lobby.PropertySet { Name = "ThresholdValue", Value = activityData.ThresholdValue.ToString() });
                                                        PropertySets.Add(new EWin.Lobby.PropertySet { Name = "PointValue", Value = activityData.BonusValue.ToString() });
                                                        PropertySets.Add(new EWin.Lobby.PropertySet { Name = "JoinActivityCycle", Value = JoinActivityCycle.ToString() });

                                                        lobbyAPI.AddPromotionCollect(Token, PromotionCollectKey, activityData.ParentLoginAccount, EWinWeb.MainCurrencyType, int.Parse(CollectAreaType), 90, description, PropertySets.ToArray());
                                                        EWinWebDB.UserAccountEventSummary.UpdateUserAccountEventSummary(BodyObj.LoginAccount, description, JoinActivityCycle, 1, 0, 0);
                                                    }
                                                }

                                                int FinishPaymentRet;

                                                FinishPaymentRet = EWinWebDB.UserAccountPayment.FinishPaymentFlowStatus(BodyObj.ClientOrderNumber, EWinWebDB.UserAccountPayment.FlowStatus.Success, BodyObj.PaymentSerial);

                                                if (FinishPaymentRet == 0) {

                                                    //若該用戶為首儲需清除PHP_Bonus錢包的餘額及門檻，若PHP_Bonus錢包餘額大於等於200發給該會員200的禮物
                                                    System.Data.DataTable UserPaymentDT = null;
                                                    int UserDepositCount = 0;
                                                    UserPaymentDT =  RedisCache.UserAccount.GetUserAccountByLoginAccount(BodyObj.LoginAccount);
                                                    if (UserPaymentDT != null) {
                                                        if (UserPaymentDT.Rows.Count > 0) {
                                                            UserDepositCount = (int)UserPaymentDT.Rows[0]["DepositCount"];
                                                        }
                                                    }

                                                    if (UserDepositCount == 1) {
                                                        EWin.OCW.APIResult PointValueRet = ocwAPI.GetUserPointValue(GetToken(), System.Guid.NewGuid().ToString(), BodyObj.LoginAccount, EWinWeb.BonusCurrencyType);

                                                        if (PointValueRet.ResultState == EWin.OCW.enumResultState.OK) {
                                                            decimal UserPointVal = decimal.Parse(PointValueRet.Message);

                                                            if (UserPointVal >= 200) {
                                                                List<EWin.Lobby.PropertySet> PropertySets = new List<EWin.Lobby.PropertySet>();
                                                                description = "BS001";
                                                                PromotionCollectKey = description + "_" + BodyObj.LoginAccount;

                                                                PropertySets.Add(new EWin.Lobby.PropertySet { Name = "ThresholdValue", Value = "0" });
                                                                PropertySets.Add(new EWin.Lobby.PropertySet { Name = "PointValue", Value = "200" });
                                                                PropertySets.Add(new EWin.Lobby.PropertySet { Name = "JoinActivityCycle", Value = "1" });

                                                                lobbyAPI.AddPromotionCollect(Token, PromotionCollectKey, BodyObj.LoginAccount, EWinWeb.MainCurrencyType, 2, 90, description, PropertySets.ToArray());
                                                            }
                                                        }

                                                        fantaAPI.ResetUserPointValueAndThresholdValueByCurrencyType(GetToken(), BodyObj.LoginAccount, System.Guid.NewGuid().ToString(), EWinWeb.BonusCurrencyType, "FirstDepositRestBonusWallet");
                                                    }

                                                    R.Result = 0;
                                                    RedisCache.PaymentContent.DeletePaymentContent(BodyObj.ClientOrderNumber);
                                                    ReportSystem.UserAccountPayment.CreateUserAccountPayment(BodyObj.ClientOrderNumber);
                                                    RedisCache.UserAccount.UpdateUserAccountByLoginAccount(BodyObj.LoginAccount);
                                                    RedisCache.UserAccountSummary.UpdateUserAccountSummary(BodyObj.LoginAccount, DateTime.Now.Date);
                                                } else {
                                                    SetResultException(R, "FinishOrderFailure, Msg=" + FinishPaymentRet.ToString());
                                                }
                                            } else {
                                                SetResultException(R, "AllParentBonusAfterDepositResultError,Msg=" + allParentBonusAfterDepositResult.Message);
                                            }
                                        } else {
                                            SetResultException(R, "AddThresholdError,Msg=" + addThresholdResult.Message);
                                        }
                                    } else {
                                        SetResultException(R, "PaymentFlowStatusError,Msg=" + BodyObj.ClientOrderNumber + ";PaymentFlowStatus = " + PaymentFlowStatus);
                                    }

                                } else {
                                    SetResultException(R, "GetPaymentByOrderNumberError");
                                }

                            } else {
                                SetResultException(R, "TagInfoFormatError");
                            }
                        } else if (BodyObj.Action == "Cancel") {
                            int FinishPaymentRet;

                            FinishPaymentRet = EWinWebDB.UserAccountPayment.FinishPaymentFlowStatus(BodyObj.ClientOrderNumber, EWinWebDB.UserAccountPayment.FlowStatus.Cancel, BodyObj.PaymentSerial);

                            if (FinishPaymentRet == 0) {
                                R.Result = 0;
                                RedisCache.PaymentContent.DeletePaymentContent(BodyObj.ClientOrderNumber);
                                ReportSystem.UserAccountPayment.CreateUserAccountPayment(BodyObj.ClientOrderNumber);
                            } else {
                                SetResultException(R, "FinishOrderFailure, Msg=" + FinishPaymentRet.ToString());
                            }
                        } else if (BodyObj.Action == "Reject") {

                            int FinishPaymentRet;

                            FinishPaymentRet = EWinWebDB.UserAccountPayment.FinishPaymentFlowStatus(BodyObj.ClientOrderNumber, EWinWebDB.UserAccountPayment.FlowStatus.Reject, BodyObj.PaymentSerial);

                            if (FinishPaymentRet == 0) {
                                R.Result = 0;
                                RedisCache.PaymentContent.DeletePaymentContent(BodyObj.ClientOrderNumber);
                                ReportSystem.UserAccountPayment.CreateUserAccountPayment(BodyObj.ClientOrderNumber);
                            } else {
                                SetResultException(R, "FinishOrderFailure, Msg=" + FinishPaymentRet.ToString());
                            }
                        } else if (BodyObj.Action == "Accept") {
                            R.Result = 0;

                            //int FinishPaymentRet;

                            //FinishPaymentRet = EWinWebDB.UserAccountPayment.FinishPaymentFlowStatus(BodyObj.ClientOrderNumber, EWinWebDB.UserAccountPayment.FlowStatus.Accept, BodyObj.PaymentSerial);

                            //if (FinishPaymentRet == 0) {
                            //    R.Result = 0;
                            //} else {
                            //    SetResultException(R, "FinishOrderFailure, Msg=" + FinishPaymentRet.ToString());
                            //}
                        } else if (BodyObj.Action == "CancelResume") {
                            int FinishPaymentRet;

                            FinishPaymentRet = EWinWebDB.UserAccountPayment.ResumePaymentFlowStatus(BodyObj.ClientOrderNumber, BodyObj.PaymentSerial);


                            if (FinishPaymentRet == 0) {
                                R.Result = 0;
                                var DT = EWinWebDB.UserAccountPayment.GetPaymentByOrderNumber(BodyObj.ClientOrderNumber);
                                var Data = CovertFromRow(DT.Rows[0]);
                                ReportSystem.UserAccountPayment.ResetUserAccountPayment(BodyObj.LoginAccount, DateTime.Now.Date);
                                RedisCache.PaymentContent.UpdatePaymentContent(Newtonsoft.Json.JsonConvert.SerializeObject(Data), Data.OrderNumber, Data.ExpireSecond);
                                RedisCache.PaymentContent.KeepPaymentContents(Data, BodyObj.LoginAccount);
                            } else {
                                SetResultException(R, "FinishOrderFailure, Msg=" + FinishPaymentRet.ToString());
                            }
                        } else {
                            SetResultException(R, "UnknownAction");
                        }
                    } else if (BodyObj.DirectionType == "Withdrawal") {
                        if (BodyObj.Action == "Create") {
                            R.Result = 0;
                        } else if (BodyObj.Action == "Finished") {
                            int FinishPaymentRet;

                            FinishPaymentRet = EWinWebDB.UserAccountPayment.FinishPaymentFlowStatus(BodyObj.ClientOrderNumber, EWinWebDB.UserAccountPayment.FlowStatus.Success, BodyObj.PaymentSerial);

                            if (FinishPaymentRet == 0) {
                                R.Result = 0;
                                RedisCache.PaymentContent.DeletePaymentContent(BodyObj.ClientOrderNumber);
                                ReportSystem.UserAccountPayment.CreateUserAccountPayment(BodyObj.ClientOrderNumber);
                                RedisCache.UserAccount.UpdateUserAccountByLoginAccount(BodyObj.LoginAccount);
                                RedisCache.UserAccountSummary.UpdateUserAccountSummary(BodyObj.LoginAccount, DateTime.Now.Date);
                            } else {
                                SetResultException(R, "FinishOrderFailure, Msg=" + FinishPaymentRet.ToString());
                            }
                        } else if (BodyObj.Action == "Cancel") {
                            int FinishPaymentRet;

                            FinishPaymentRet = EWinWebDB.UserAccountPayment.FinishPaymentFlowStatus(BodyObj.ClientOrderNumber, EWinWebDB.UserAccountPayment.FlowStatus.Cancel, BodyObj.PaymentSerial);

                            if (FinishPaymentRet == 0) {
                                R.Result = 0;
                                RedisCache.PaymentContent.DeletePaymentContent(BodyObj.ClientOrderNumber);
                                ReportSystem.UserAccountPayment.CreateUserAccountPayment(BodyObj.ClientOrderNumber);
                            } else {
                                SetResultException(R, "FinishOrderFailure, Msg=" + FinishPaymentRet.ToString());
                            }
                        } else if (BodyObj.Action == "Reject") {

                            int FinishPaymentRet;

                            FinishPaymentRet = EWinWebDB.UserAccountPayment.FinishPaymentFlowStatus(BodyObj.ClientOrderNumber, EWinWebDB.UserAccountPayment.FlowStatus.Reject, BodyObj.PaymentSerial);

                            if (FinishPaymentRet == 0) {
                                R.Result = 0;
                                RedisCache.PaymentContent.DeletePaymentContent(BodyObj.ClientOrderNumber);
                                ReportSystem.UserAccountPayment.CreateUserAccountPayment(BodyObj.ClientOrderNumber);
                            } else {
                                SetResultException(R, "FinishOrderFailure, Msg=" + FinishPaymentRet.ToString());
                            }
                        } else if (BodyObj.Action == "Accept") {
                            R.Result = 0;
                            //int FinishPaymentRet;

                            //FinishPaymentRet = EWinWebDB.UserAccountPayment.FinishPaymentFlowStatus(BodyObj.ClientOrderNumber, EWinWebDB.UserAccountPayment.FlowStatus.Accept, BodyObj.PaymentSerial);

                            //if (FinishPaymentRet == 0) {
                            //    R.Result = 0;
                            //} else {
                            //    SetResultException(R, "FinishOrderFailure, Msg=" + FinishPaymentRet.ToString());
                            //}
                        } else if (BodyObj.Action == "CancelResume") {
                            int FinishPaymentRet;

                            FinishPaymentRet = EWinWebDB.UserAccountPayment.ResumePaymentFlowStatus(BodyObj.ClientOrderNumber, BodyObj.PaymentSerial);


                            if (FinishPaymentRet == 0) {
                                R.Result = 0;
                                var DT = EWinWebDB.UserAccountPayment.GetPaymentByOrderNumber(BodyObj.ClientOrderNumber);
                                var Data = CovertFromRow(DT.Rows[0]);
                                ReportSystem.UserAccountPayment.ResetUserAccountPayment(BodyObj.LoginAccount, DateTime.Now.Date);
                                RedisCache.PaymentContent.UpdatePaymentContent(Newtonsoft.Json.JsonConvert.SerializeObject(Data), Data.OrderNumber, Data.ExpireSecond);
                                RedisCache.PaymentContent.KeepPaymentContents(Data, BodyObj.LoginAccount);
                            } else {
                                SetResultException(R, "FinishOrderFailure, Msg=" + FinishPaymentRet.ToString());
                            }
                        } else {
                            SetResultException(R, "UnknownAction");
                        }
                    } else {
                        SetResultException(R, "UnknownDirectionType");
                    }
                } else {
                    SetResultException(R, "NoExist");
                }


            } else {
                SetResultException(R, "BodyFormatError");
            }
        } else {
            SetResultException(R, "NoBody");
        }
    } else {
        SetResultException(R, "NotPost");
    }


    if (R != null) {
        Response.Write(Newtonsoft.Json.JsonConvert.SerializeObject(R));
        Response.ContentType = "application/json";
        Response.Flush();
        Response.End();
    }
%>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title></title>
</head>
<body>
</body>
</html>
