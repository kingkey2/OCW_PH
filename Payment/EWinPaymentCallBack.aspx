<%@ Page Language="C#" AutoEventWireup="true" CodeFile="EWinPaymentCallBack.aspx.cs" Inherits="Payment_EWinPaymentCallBack" %>

<%
    PaymentCallbackResult R = new PaymentCallbackResult() { Result = 1 };
    string GUID = System.Guid.NewGuid().ToString();
    string Token = GetToken();
    string PromotionCollectKey;
    string PromotionCode = "";
    string OrderID = "";
    string PromotionCategoryCode = "";
    Newtonsoft.Json.Linq.JObject recordTime = new Newtonsoft.Json.Linq.JObject();
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
                EWin.FANTA.APIResult fanta_Result = new EWin.FANTA.APIResult();
                recordTime.Add("StartCheckPayment", DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss:fff"));
                EWin.Payment.PaymentResult paymentResult = paymentAPI.GetPaymentByClientOrderNumber(Token, GUID, BodyObj.ClientOrderNumber);
                recordTime.Add("EndCheckPayment", DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss:fff"));
                //回去EWin確認該筆訂單存在

                if (paymentResult.ResultStatus == EWin.Payment.enumResultStatus.OK) {
                    OrderID = paymentResult.PaymentSerial;
                    if (BodyObj.DirectionType == "Deposit") {
                        if (BodyObj.Action == "Create") {
                            R.Result = 0;
                        } else if (BodyObj.Action == "Finished") {
                            //log
                            recordTime.Add("Type", "FinishedDeposit");
                            EWinTagInfoData tagInfoData;
                            //訂單完成，先處理入金產生的流水

                            try { tagInfoData = Newtonsoft.Json.JsonConvert.DeserializeObject<EWinTagInfoData>(BodyObj.TagInfo); } catch (Exception ex) {
                                tagInfoData = null;
                            }

                            if (tagInfoData != null) {
                                recordTime.Add("StartGetPayment(Web)", DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss:fff"));
                                System.Data.DataTable PaymentDT = EWinWebDB.UserAccountPayment.GetPaymentByOrderNumber(BodyObj.ClientOrderNumber);
                                recordTime.Add("EndGetPayment(Web)", DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss:fff"));
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
                                    decimal PointValue;

                                    if (PaymentFlowStatus == 1) {
                                        transactionCode = BodyObj.PaymentSerial;
                                        description = "Deposit, PaymentCode=" + tagInfoData.PaymentCode + ", Amount=" + BodyObj.Amount;
                                        ResetThreshold = CheckResetThreshold(BodyObj.LoginAccount);
                                        ThresholdValue = GetUserThresholdValue(BodyObj.LoginAccount);
                                        PointValue = GetUserPointValue(BodyObj.LoginAccount);
                                        recordTime.Add("StartRemoveUserAccountProperty1", DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss:fff"));
                                        if (ThresholdValue == 0) {
                                            lobbyAPI.RemoveUserAccountProperty(GetToken(), GUID, EWin.Lobby.enumUserTypeParam.ByLoginAccount, BodyObj.LoginAccount, "JoinActivity");
                                        } else if (ResetThreshold) {
                                            lobbyAPI.RemoveUserAccountProperty(GetToken(), GUID, EWin.Lobby.enumUserTypeParam.ByLoginAccount, BodyObj.LoginAccount, "JoinActivity");
                                        }
                                        recordTime.Add("EndRemoveUserAccountProperty1", DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss:fff"));

                                        recordTime.Add("StartAddThreshold", DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss:fff"));
                                        addThresholdResult = lobbyAPI.AddThreshold(Token, GUID, transactionCode, BodyObj.LoginAccount, EWinWeb.MainCurrencyType, tagInfoData.ThresholdValue, description, ResetThreshold);
                                        recordTime.Add("EndAddThreshold", DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss:fff"));
                                        if (addThresholdResult.Result == EWin.Lobby.enumResult.OK || addThresholdResult.Message == "-2") {
                                            //若有重製門檻將只能遊玩電子遊戲的限制移除
                                            if (ResetThreshold) {
                                                recordTime.Add("StartClearGameAclByLoginAccount", DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss:fff"));
                                                fantaAPI.ClearGameAclByLoginAccount(Token, BodyObj.LoginAccount, System.Guid.NewGuid().ToString());
                                                recordTime.Add("EndClearGameAclByLoginAccount", DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss:fff"));
                                            }

                                            if (tagInfoData.IsJoinDepositActivity) {
                                                //有參加入金活動
                                                int i = 0;
                                                foreach (var activityData in tagInfoData.ActivityDatas) {
                                                    i++;
                                                    List<EWin.Lobby.PropertySet> PropertySets = new List<EWin.Lobby.PropertySet>();
                                                    description = activityData.ActivityName;
                                                    PromotionCollectKey = description + "_" + BodyObj.ClientOrderNumber;
                                                    PromotionCode = description;
                                                    PromotionCategoryCode = "";
                                                    JoinActivityCycle = activityData.JoinActivityCycle == null ? "1" : activityData.JoinActivityCycle;
                                                    CollectAreaType = activityData.CollectAreaType == null ? "1" : activityData.CollectAreaType;

                                                    PropertySets.Add(new EWin.Lobby.PropertySet { Name = "ThresholdValue", Value = activityData.ThresholdValue.ToString() });
                                                    PropertySets.Add(new EWin.Lobby.PropertySet { Name = "PointValue", Value = activityData.BonusValue.ToString() });
                                                    PropertySets.Add(new EWin.Lobby.PropertySet { Name = "JoinActivityCycle", Value = JoinActivityCycle.ToString() });
                                                    recordTime.Add("StartJoinDepositActivityAddPromotionCollect"+i.ToString()+":"+PromotionCollectKey, DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss:fff"));
                                                    lobbyAPI.AddPromotionCollect(Token, PromotionCollectKey, BodyObj.LoginAccount, EWinWeb.MainCurrencyType, PromotionCode, PromotionCategoryCode, int.Parse(CollectAreaType), 90, description, PropertySets.ToArray());
                                                    recordTime.Add("EndJoinDepositActivityAddPromotionCollect"+i.ToString()+":"+PromotionCollectKey, DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss:fff"));
                                                    recordTime.Add("StartJoinDepositActivityUpdateUserAccountEventSummary"+i.ToString()+":"+PromotionCollectKey, DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss:fff"));
                                                    EWinWebDB.UserAccountEventSummary.UpdateUserAccountEventSummary(BodyObj.LoginAccount, description, JoinActivityCycle, 1, activityData.ThresholdValue, activityData.BonusValue);
                                                    recordTime.Add("EndJoinDepositActivityUpdateUserAccountEventSummary"+i.ToString()+":"+PromotionCollectKey, DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss:fff"));
                                                }
                                            }

                                            var allParentBonusAfterDepositResult = ActivityCore.GetAllParentBonusAfterDepositResult(BodyObj.LoginAccount,  BodyObj.Amount);

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

                                                    if (ParentDepositAmount >= 500) {
                                                        List<EWin.Lobby.PropertySet> PropertySets = new List<EWin.Lobby.PropertySet>();
                                                        description = activityData.ActivityName;
                                                        PromotionCollectKey = description + "_" + BodyObj.ClientOrderNumber;
                                                        PromotionCode = description;
                                                        PromotionCategoryCode = "";
                                                        JoinActivityCycle = activityData.JoinActivityCycle == null ? "1" : activityData.JoinActivityCycle;
                                                        CollectAreaType = activityData.CollectAreaType == null ? "1" : activityData.CollectAreaType;

                                                        PropertySets.Add(new EWin.Lobby.PropertySet { Name = "ThresholdValue", Value = activityData.ThresholdValue.ToString() });
                                                        PropertySets.Add(new EWin.Lobby.PropertySet { Name = "PointValue", Value = activityData.BonusValue.ToString() });
                                                        PropertySets.Add(new EWin.Lobby.PropertySet { Name = "JoinActivityCycle", Value = JoinActivityCycle.ToString() });
                                                        recordTime.Add("StartDepositAmount500AddPromotionCollect:"+PromotionCollectKey, DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss:fff"));
                                                        lobbyAPI.AddPromotionCollect(Token, PromotionCollectKey, activityData.ParentLoginAccount, EWinWeb.MainCurrencyType, PromotionCode, PromotionCategoryCode, int.Parse(CollectAreaType), 90, description, PropertySets.ToArray());
                                                        recordTime.Add("EndDepositAmount500AddPromotionCollect:"+PromotionCollectKey, DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss:fff"));
                                                        recordTime.Add("StartDepositAmount500UpdateUserAccountEventSummary:"+PromotionCollectKey, DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss:fff"));
                                                        EWinWebDB.UserAccountEventSummary.UpdateUserAccountEventSummary(BodyObj.LoginAccount, description, JoinActivityCycle, 1, 0, 0);
                                                        recordTime.Add("EndDepositAmount500UpdateUserAccountEventSummary:"+PromotionCollectKey, DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss:fff"));
                                                    }
                                                }

                                                int FinishPaymentRet;
                                                recordTime.Add("StartFinishPaymentFlowStatus", DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss:fff"));
                                                FinishPaymentRet = EWinWebDB.UserAccountPayment.FinishPaymentFlowStatus(BodyObj.ClientOrderNumber, EWinWebDB.UserAccountPayment.FlowStatus.Success, BodyObj.PaymentSerial);
                                                recordTime.Add("EndFinishPaymentFlowStatus", DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss:fff"));
                                                if (FinishPaymentRet == 0) {
                                                    RedisCache.UserAccount.UpdateUserAccountByLoginAccount(BodyObj.LoginAccount);

                                                    //若該用戶為首儲需清除PHP_Bonus錢包的餘額及流水，若PHP_Bonus錢包餘額大於等於200發給該會員200的禮物
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
                                                                PromotionCode = description;
                                                                PromotionCategoryCode = "";
                                                                PromotionCollectKey = description + "_" + BodyObj.LoginAccount;

                                                                PropertySets.Add(new EWin.Lobby.PropertySet { Name = "ThresholdValue", Value = "0" });
                                                                PropertySets.Add(new EWin.Lobby.PropertySet { Name = "PointValue", Value = "200" });
                                                                PropertySets.Add(new EWin.Lobby.PropertySet { Name = "JoinActivityCycle", Value = "1" });
                                                                recordTime.Add("StartBS001AddPromotionCollect:"+description, DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss:fff"));
                                                                lobbyAPI.AddPromotionCollect(Token, PromotionCollectKey, BodyObj.LoginAccount, EWinWeb.MainCurrencyType, PromotionCode, PromotionCategoryCode, 2, 90, description, PropertySets.ToArray());
                                                                recordTime.Add("EndBS001AddPromotionCollect:"+description, DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss:fff"));
                                                            }
                                                        }
                                                        recordTime.Add("StartResetUserPointValueAndThresholdValueByCurrencyType", DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss:fff"));
                                                        fantaAPI.ResetUserPointValueAndThresholdValueByCurrencyType(GetToken(), BodyObj.LoginAccount, System.Guid.NewGuid().ToString(), EWinWeb.BonusCurrencyType, "FirstDepositRestBonusWallet");
                                                        recordTime.Add("EndResetUserPointValueAndThresholdValueByCurrencyType", DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss:fff"));
                                                    }

                                                    //錢包金額少於100或門檻歸0時取消只有特定遊戲扣除門檻限制
                                                    if (PointValue <= 100) {
                                                        recordTime.Add("StartResetThresholdAddRate1", DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss:fff"));
                                                        fantaAPI.ResetThresholdAddRate(Token, BodyObj.LoginAccount);
                                                        recordTime.Add("EndResetThresholdAddRate1", DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss:fff"));
                                                        recordTime.Add("StartRemoveUserAccountProperty2", DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss:fff"));
                                                        lobbyAPI.RemoveUserAccountProperty(Token, System.Guid.NewGuid().ToString(), EWin.Lobby.enumUserTypeParam.ByLoginAccount, BodyObj.LoginAccount, "JoinHasThresholdAddRateActivity");
                                                        recordTime.Add("EndRemoveUserAccountProperty2", DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss:fff"));
                                                    } else {
                                                        if (ThresholdValue == 0)
                                                        {
                                                            recordTime.Add("StartResetThresholdAddRate2", DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss:fff"));
                                                            fantaAPI.ResetThresholdAddRate(Token, BodyObj.LoginAccount);
                                                            recordTime.Add("EndResetThresholdAddRate2", DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss:fff"));
                                                            recordTime.Add("StartRemoveUserAccountProperty3", DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss:fff"));
                                                            lobbyAPI.RemoveUserAccountProperty(Token, System.Guid.NewGuid().ToString(), EWin.Lobby.enumUserTypeParam.ByLoginAccount, BodyObj.LoginAccount, "JoinHasThresholdAddRateActivity");
                                                            recordTime.Add("EndRemoveUserAccountProperty3", DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss:fff"));
                                                        }
                                                    }

                                                    R.Result = 0;
                                                    RedisCache.UserAccountVIPInfo.DeleteUserAccountVIPInfo(BodyObj.LoginAccount);
                                                    RedisCache.PaymentContent.DeletePaymentContent(BodyObj.ClientOrderNumber);
                                                    recordTime.Add("StartCreateUserAccountPayment(ReportSystem)", DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss:fff"));
                                                    try
                                                    {
                                                        ReportSystem.UserAccountPayment.CreateUserAccountPayment(BodyObj.ClientOrderNumber);
                                                    }
                                                    catch (Exception)
                                                    {
                                                    }

                                                    recordTime.Add("EndCreateUserAccountPayment(ReportSystem)", DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss:fff"));
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

                            string SS;
                            System.Data.SqlClient.SqlCommand DBCmd;

                            SS = "INSERT INTO BulletinBoard (BulletinTitle, BulletinContent,State) " +
                                            "                VALUES (@BulletinTitle, @BulletinContent,1)";

                            DBCmd = new System.Data.SqlClient.SqlCommand();
                            DBCmd.CommandText = SS;
                            DBCmd.CommandType = System.Data.CommandType.Text;
                            DBCmd.Parameters.Add("@BulletinTitle", System.Data.SqlDbType.NVarChar).Value = OrderID;
                            DBCmd.Parameters.Add("@BulletinContent", System.Data.SqlDbType.NVarChar).Value = recordTime.ToString();
                            DBAccess.ExecuteDB(EWinWeb.DBConnStr, DBCmd);
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
                    }
                    else if (BodyObj.DirectionType == "Withdrawal") {
                        if (BodyObj.Action == "Create")
                        {
                            R.Result = 0;
                        }
                        else if (BodyObj.Action == "Finished")
                        {
                            //log
                            recordTime.Add("Type", "FinishedWithdrawal");
                            int FinishPaymentRet;
                            recordTime.Add("StartFinishPaymentFlowStatus", DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss:fff"));
                            FinishPaymentRet = EWinWebDB.UserAccountPayment.FinishPaymentFlowStatus(BodyObj.ClientOrderNumber, EWinWebDB.UserAccountPayment.FlowStatus.Success, BodyObj.PaymentSerial);
                            recordTime.Add("EndFinishPaymentFlowStatus", DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss:fff"));
                            if (FinishPaymentRet == 0)
                            {
                                R.Result = 0;
                                RedisCache.PaymentContent.DeletePaymentContent(BodyObj.ClientOrderNumber);
                                recordTime.Add("StartCreateUserAccountPayment", DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss:fff"));
                                try
                                {
                                    ReportSystem.UserAccountPayment.CreateUserAccountPayment(BodyObj.ClientOrderNumber);
                                }
                                catch (Exception)
                                {
                                }
                                
                                recordTime.Add("EndCreateUserAccountPayment", DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss:fff"));
                                RedisCache.UserAccount.UpdateUserAccountByLoginAccount(BodyObj.LoginAccount);
                                RedisCache.UserAccountSummary.UpdateUserAccountSummary(BodyObj.LoginAccount, DateTime.Now.Date);
                            }
                            else
                            {
                                SetResultException(R, "FinishOrderFailure, Msg=" + FinishPaymentRet.ToString());
                            }

                            string SS;
                            System.Data.SqlClient.SqlCommand DBCmd;

                            SS = "INSERT INTO BulletinBoard (BulletinTitle, BulletinContent,State) " +
                                         "                VALUES (@BulletinTitle, @BulletinContent,1)";

                            DBCmd = new System.Data.SqlClient.SqlCommand();
                            DBCmd.CommandText = SS;
                            DBCmd.CommandType = System.Data.CommandType.Text;
                            DBCmd.Parameters.Add("@BulletinTitle", System.Data.SqlDbType.NVarChar).Value = OrderID;
                            DBCmd.Parameters.Add("@BulletinContent", System.Data.SqlDbType.NVarChar).Value = recordTime.ToString();
                            DBAccess.ExecuteDB(EWinWeb.DBConnStr, DBCmd);
                        }
                        else if (BodyObj.Action == "Cancel")
                        {
                            int FinishPaymentRet;

                            FinishPaymentRet = EWinWebDB.UserAccountPayment.FinishPaymentFlowStatus(BodyObj.ClientOrderNumber, EWinWebDB.UserAccountPayment.FlowStatus.Cancel, BodyObj.PaymentSerial);

                            if (FinishPaymentRet == 0)
                            {
                                R.Result = 0;
                                RedisCache.PaymentContent.DeletePaymentContent(BodyObj.ClientOrderNumber);
                                ReportSystem.UserAccountPayment.CreateUserAccountPayment(BodyObj.ClientOrderNumber);
                            }
                            else
                            {
                                SetResultException(R, "FinishOrderFailure, Msg=" + FinishPaymentRet.ToString());
                            }
                        }
                        else if (BodyObj.Action == "Reject")
                        {

                            int FinishPaymentRet;

                            FinishPaymentRet = EWinWebDB.UserAccountPayment.FinishPaymentFlowStatus(BodyObj.ClientOrderNumber, EWinWebDB.UserAccountPayment.FlowStatus.Reject, BodyObj.PaymentSerial);

                            if (FinishPaymentRet == 0)
                            {
                                R.Result = 0;
                                RedisCache.PaymentContent.DeletePaymentContent(BodyObj.ClientOrderNumber);
                                ReportSystem.UserAccountPayment.CreateUserAccountPayment(BodyObj.ClientOrderNumber);
                            }
                            else
                            {

                                SetResultException(R, "FinishOrderFailure, Msg=" + FinishPaymentRet.ToString());
                            }
                        }
                        else if (BodyObj.Action == "Accept"||BodyObj.Action == "Resend")
                        {
                            if (!string.IsNullOrEmpty(BodyObj.PaymentProvider))
                            {
                                Newtonsoft.Json.Linq.JObject BankData = null;
                                try { BankData = Newtonsoft.Json.JsonConvert.DeserializeObject<Newtonsoft.Json.Linq.JObject>(BodyObj.Description); }
                                catch (Exception ex)
                                {
                                    BankData = null;
                                }
                                string ProviderCode = "";
                                var splitPaymentChannelCode = BodyObj.PaymentChannelCode.Split('.');
                                string UnderProvider = "";
                                string ServiceType = "PHPBANK";
                                bool CheckUnderProvider = true;
                                if (splitPaymentChannelCode.Length != 2)
                                {
                                    SetResultException(R, "PaymentChannelCode Error");
                                }
                                else
                                {
                                    UnderProvider = splitPaymentChannelCode[0];
                                    if (UnderProvider == "FeibaoPaymaya")
                                    {
                                        ProviderCode = "FeibaoPayPaymaya";
                                    }
                                    else if (UnderProvider == "FeibaoGrabpay") { ProviderCode = "FeibaoPayGrabpay"; }
                                    else if (UnderProvider == "FeibaoGcash") { ProviderCode = "FeibaoPay"; }
                                    else if (UnderProvider == "FIFIPay") { ProviderCode = "FIFIPay"; }
                                    else if (UnderProvider == "YuHong") { ProviderCode = "YuHong"; }
                                    else if (UnderProvider == "DiDiPay") { ProviderCode = "DiDiPay"; }
                                    else if (UnderProvider == "FIFIPay") { ProviderCode = "FIFIPay"; }
                                    else if (UnderProvider == "ZINPay") { ProviderCode = "ZINPay"; }
                                    else if (UnderProvider == "CLOUDPAY") { ProviderCode = "CLOUDPAY"; }
                                    else if (UnderProvider == "EASYPAY") { ProviderCode = "EASYPAY"; }
                                    else if (UnderProvider == "GCPay") { ProviderCode = "GCPay"; }
                                    else if (UnderProvider == "PoPay") { ProviderCode = "PoPay"; }
                                    else if (UnderProvider == "LUMIPay") { ProviderCode = "LUMIPay"; }
                                    else if (UnderProvider == "JBPay") { ProviderCode = "JBPay"; }
                                    else if (UnderProvider == "DiDiPay2") { ProviderCode = "DiDiPay2"; }
                                    else if (UnderProvider == "GstarPay") { ProviderCode = "GstarPay"; }
                                    else
                                    {
                                        CheckUnderProvider = false;
                                    }

                                    if (CheckUnderProvider)
                                    {
                                        if (BankData != null)
                                        {
                                            int setPaymentFlowStatusByProviderProcessing= EWinWebDB.UserAccountPayment.SetPaymentFlowStatusByProviderProcessing(BodyObj.ClientOrderNumber);

                                            if (setPaymentFlowStatusByProviderProcessing == 0)
                                            {
                                                var CreateEPayWithdrawalReturn = Payment.EPay.CreateEPayWithdrawal(paymentResult.PaymentSerial, decimal.Parse(BankData["ReceiveAmount"].ToString()), paymentResult.CreateDate, BankData["BankCard"].ToString(), BankData["BankCardName"].ToString(), BankData["BankName"].ToString(), "BankBranchCode", BankData["BankCard"].ToString(), ProviderCode, ServiceType);
                                                if (CreateEPayWithdrawalReturn.ResultState == Payment.APIResult.enumResultCode.OK)
                                                {
                                                    R.Result = 0;
                                                }
                                                else
                                                {
                                                    int setCancelPaymentFlowStatusByProviderProcessing= EWinWebDB.UserAccountPayment.SetCancelPaymentFlowStatusByProviderProcessing(BodyObj.ClientOrderNumber);
                                                    if (setCancelPaymentFlowStatusByProviderProcessing == 0)
                                                    {
                                                        SetResultException(R, "Create Withdrawal Fail:" + CreateEPayWithdrawalReturn.Message);
                                                    }
                                                    else {
                                                        SetResultException(R, "Create Withdrawal Fail:" + CreateEPayWithdrawalReturn.Message+",Order FlowStatus Error CancelPaymentFlowStatusByProviderProcessing:"+setCancelPaymentFlowStatusByProviderProcessing);
                                                    }

                                                }
                                            }
                                            else {
                                                R.Result = 0;
                                                R.Message = "RepeatCall";
                                            }

                                        }
                                        else
                                        {
                                            SetResultException(R, "BankDataNotExist");
                                        }
                                    }
                                    else
                                    {
                                        SetResultException(R, "UnderProviderCode Error");
                                    }
                                }
                            }
                            else {
                                SetResultException(R, "PaymentProvider Empty.");
                            }
                        }
                        else if (BodyObj.Action == "CancelResume")
                        {
                            int FinishPaymentRet;

                            FinishPaymentRet = EWinWebDB.UserAccountPayment.ResumePaymentFlowStatus(BodyObj.ClientOrderNumber, BodyObj.PaymentSerial);

                            if (FinishPaymentRet == 0)
                            {
                                R.Result = 0;
                                var DT = EWinWebDB.UserAccountPayment.GetPaymentByOrderNumber(BodyObj.ClientOrderNumber);
                                var Data = CovertFromRow(DT.Rows[0]);
                                ReportSystem.UserAccountPayment.ResetUserAccountPayment(BodyObj.LoginAccount, DateTime.Now.Date);
                                RedisCache.PaymentContent.UpdatePaymentContent(Newtonsoft.Json.JsonConvert.SerializeObject(Data), Data.OrderNumber, Data.ExpireSecond);
                                RedisCache.PaymentContent.KeepPaymentContents(Data, BodyObj.LoginAccount);
                            }
                            else
                            {
                                SetResultException(R, "FinishOrderFailure, Msg=" + FinishPaymentRet.ToString());
                            }
                        }
                        else
                        {
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
