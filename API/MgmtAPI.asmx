<%@ WebService Language="C#" Class="MgmtAPI" %>

using System;
using System.Web;
using System.Web.Services;
using System.Web.Services.Protocols;
using System.Collections;
using System.Collections.Generic;
using System.Web.Script.Services;
using System.Web.Script.Serialization;
using System.Linq;
using System.Threading.Tasks;
//using SendGrid;
//using SendGrid.Helpers.Mail;
using System.Threading.Tasks;
using Newtonsoft.Json.Linq;

[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// 若要允許使用 ASP.NET AJAX 從指令碼呼叫此 Web 服務，請取消註解下列一行。
// [System.Web.Script.Services.ScriptService]
[System.ComponentModel.ToolboxItem(false)]
[System.Web.Script.Services.ScriptService]
public class MgmtAPI : System.Web.Services.WebService {

    //[WebMethod]
    //[ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    //public string GetUserAccountSummary2(string a) {    
    //    return EWinWeb.GetToken();
    //}

    [WebMethod]
    public void RefreshRedis(string password) {
        if (CheckPassword(password)) {
            System.Data.DataTable DT;
            RedisCache.PaymentCategory.UpdatePaymentCategory();
            RedisCache.PaymentMethod.UpdatePaymentMethodByCategory("Paypal");
            RedisCache.PaymentMethod.UpdatePaymentMethodByCategory("Crypto");

            DT = EWinWebDB.PaymentMethod.GetPaymentMethod();

            if (DT != null) {
                if (DT.Rows.Count > 0) {
                    for (int i = 0; i < DT.Rows.Count; i++) {
                        RedisCache.PaymentMethod.UpdatePaymentMethodByID((int)DT.Rows[i]["PaymentMethodID"]);
                    }
                }
            }


            EWin.Lobby.LobbyAPI lobbyAPI = new EWin.Lobby.LobbyAPI();
            var R = lobbyAPI.GetCompanyGameCode(EWinWeb.GetToken(), System.Guid.NewGuid().ToString());
            RedisCache.Company.UpdateCompanyGameCode(Newtonsoft.Json.JsonConvert.SerializeObject(R.GameCodeList));
        }
    }

    [WebMethod]
    public UserAccountSummaryResult GetUserAccountSummary(string password, string LoginAccount, DateTime SummaryDate) {

        UserAccountSummaryResult R = new UserAccountSummaryResult() { Result = enumResult.ERR };
        System.Data.DataTable DT;
        if (CheckPassword(password)) {
            DT = RedisCache.UserAccountSummary.GetUserAccountSummary(LoginAccount, SummaryDate);
            if (DT != null && DT.Rows.Count > 0) {
                R.SummaryGUID = (string)DT.Rows[0]["SummaryGUID"];
                R.SummaryDate = (DateTime)DT.Rows[0]["SummaryDate"];
                R.LoginAccount = (string)DT.Rows[0]["LoginAccount"];
                R.DepositCount = (int)DT.Rows[0]["DepositCount"];
                R.DepositRealAmount = (decimal)DT.Rows[0]["DepositRealAmount"];
                R.DepositAmount = (decimal)DT.Rows[0]["DepositAmount"];
                R.WithdrawalCount = (int)DT.Rows[0]["WithdrawalCount"];
                R.WithdrawalRealAmount = (decimal)DT.Rows[0]["WithdrawalRealAmount"];
                R.WithdrawalAmount = (decimal)DT.Rows[0]["WithdrawalAmount"];
                R.Result = enumResult.OK;
            } else {
                SetResultException(R, "NoData");
            }
        } else {
            SetResultException(R, "InvalidPassword");
        }

        return R;
    }

    [WebMethod]
    public UserAccountTotalSummaryResult GetUserAccountTotalSummary(string password, string LoginAccount) {

        UserAccountTotalSummaryResult R = new UserAccountTotalSummaryResult() { Result = enumResult.ERR };
        System.Data.DataTable DT;
        if (CheckPassword(password)) {
            DT = RedisCache.UserAccount.GetUserAccountByLoginAccount(LoginAccount);
            if (DT != null && DT.Rows.Count > 0) {
                R.LoginAccount = (string)DT.Rows[0]["LoginAccount"];
                R.LastDepositDate = (DateTime)DT.Rows[0]["LastDepositDate"];
                R.LastWithdrawalDate = (DateTime)DT.Rows[0]["LastWithdrawalDate"];
                R.LoginAccount = (string)DT.Rows[0]["LoginAccount"];
                R.DepositCount = (int)DT.Rows[0]["DepositCount"];
                R.DepositRealAmount = (decimal)DT.Rows[0]["DepositRealAmount"];
                R.DepositAmount = (decimal)DT.Rows[0]["DepositAmount"];
                R.WithdrawalCount = (int)DT.Rows[0]["WithdrawalCount"];
                R.WithdrawalRealAmount = (decimal)DT.Rows[0]["WithdrawalRealAmount"];
                R.WithdrawalAmount = (decimal)DT.Rows[0]["WithdrawalAmount"];
                R.FingerPrint = (string)DT.Rows[0]["FingerPrint"];
                R.Result = enumResult.OK;
            } else {
                SetResultException(R, "NoData");
            }
        } else {
            SetResultException(R, "InvalidPassword");
        }

        return R;
    }

    [WebMethod]
    public APIResult GetSummaryByDateFromEwin(string password, string BeginDate, string EndDate) {
        EWin.OCW.OCW ocwApi = new EWin.OCW.OCW();
        EWin.OCW.OrderSummaryResult callResult = new EWin.OCW.OrderSummaryResult();
        System.Data.DataTable DT = new System.Data.DataTable();
        System.Data.DataTable UserAccountSummaryDT = new System.Data.DataTable();
        APIResult R = new APIResult() { Result = enumResult.ERR };

        if (CheckPassword(password)) {
            callResult = ocwApi.GetGameOrderSummaryHistory(GetToken(), System.Guid.NewGuid().ToString(), BeginDate, EndDate);

            if (callResult.ResultState == EWin.OCW.enumResultState.OK) {
                string LoginAccount;
                decimal ValidBetValue;
                string SearchStartDate;
                string SearchEndDate;
                bool IsDBHasData1 = false;
                string SummaryGUID = string.Empty;

                var GameOrderList = callResult.SummaryList.Where(x => x.ValidBetValue > 0 && x.CurrencyType == EWinWeb.MainCurrencyType).GroupBy(x => new { x.CurrencyType, x.LoginAccount, x.SummaryDate }, x => x, (key, sum) => new EWin.Lobby.OrderSummary {
                    TotalValidBetValue = sum.Sum(y => y.ValidBetValue),
                    CurrencyType = key.CurrencyType,
                    LoginAccount = key.LoginAccount,
                    SummaryDate = key.SummaryDate
                }).ToList();

                for (int i = 0; i < GameOrderList.Count; i++) {
                    LoginAccount = GameOrderList[i].LoginAccount;
                    ValidBetValue = GameOrderList[i].TotalValidBetValue;
                    SearchStartDate = string.Empty;
                    SearchEndDate = string.Empty;
                    IsDBHasData1 = false;
                    SummaryGUID = string.Empty;
                    DT = new System.Data.DataTable();
                    UserAccountSummaryDT = new System.Data.DataTable();

                    if (ValidBetValue != 0) {
                        SearchStartDate = DateTime.Parse(GameOrderList[i].SummaryDate).ToString("yyyy-MM-dd");
                        SearchEndDate = DateTime.Parse(GameOrderList[i].SummaryDate).AddDays(1).ToString("yyyy-MM-dd");
                        //確認當天是否已經有因為出入金寫入資料
                        UserAccountSummaryDT = EWinWebDB.UserAccountSummary.GetUserAccountSummaryData(LoginAccount, SearchStartDate, SearchEndDate);

                        if (UserAccountSummaryDT != null) {
                            if (UserAccountSummaryDT.Rows.Count > 0) {
                                IsDBHasData1 = true;
                                SummaryGUID = (string)UserAccountSummaryDT.Rows[0]["SummaryGUID"];
                            }
                        }

                        if (IsDBHasData1) {
                            EWinWebDB.UserAccountSummary.UpdateValidBetValueBySummaryGUID(ValidBetValue, SummaryGUID);
                        } else {
                            EWinWebDB.UserAccountSummary.InsertValidBetValue(ValidBetValue, LoginAccount, SearchStartDate, 0, 0, 0, 0, 0, 0);
                        }

                        EWinWebDB.UserAccount.UpdateUserAccountValidBetValue(LoginAccount, ValidBetValue);
                    }
                }

                R.Result = enumResult.OK;
            } else {
                SetResultException(R, callResult.Message);
            }

        } else {
            SetResultException(R, "InvalidPassword");
        }

        return R;
    }

    /// <summary>
    /// 會員VIP降級及發放返水
    /// </summary>
    /// <returns></returns>
    [WebMethod]
    public APIResult UserPromotion(string password, string BeginDate, string EndDate) {
        APIResult R = new APIResult() { Result = enumResult.ERR };
        JObject VIPSetting;
        JArray VIPSettingDetail;
        int ActivityState = 1;
        int KeepLevelDays = 30;
        DateTime ActivityStartDate;
        DateTime ActivityEndDate;
        System.Data.DataTable UTSDT = new System.Data.DataTable();
        System.Data.DataTable DT = new System.Data.DataTable();
        System.Data.DataTable UserLevDT = new System.Data.DataTable();

        if (CheckPassword(password)) {
            VIPSetting = GetActivityDetail("../App_Data/VIPSetting.json");

            if (VIPSetting != null) {
                ActivityState = (int)VIPSetting["State"];
                ActivityStartDate = DateTime.Parse(VIPSetting["StartDate"].ToString());
                ActivityEndDate = DateTime.Parse(VIPSetting["EndDate"].ToString());
                VIPSettingDetail = JArray.Parse(VIPSetting["VIPSetting"].ToString());
                KeepLevelDays = (int)VIPSetting["KeepLevelDays"];

                if (ActivityState == 0) {
                    if (DateTime.Now >= ActivityStartDate && DateTime.Now < ActivityEndDate) {
                        //取UserAccountTotalSummary資料 
                        UTSDT = EWinWebDB.UserAccount.GetUserAccountNeedCheckPromotion(BeginDate, EndDate);

                        if (UTSDT != null) {
                            if (UTSDT.Rows.Count > 0) {
                                string LoginAccount;
                                decimal DeposiAmount = 0;
                                decimal ValidBetValue = 0;
                                int UserLevelIndex = 0;
                                int NewUserLevelIndex = 0;
                                DateTime UserLevelUpdateDate = DateTime.Now;

                                foreach (System.Data.DataRow dr in UTSDT.Rows) {
                                    LoginAccount = (string)dr["LoginAccount"];
                                    DeposiAmount = 0;
                                    ValidBetValue = 0;

                                    //取當下會員等級
                                    UserLevDT = RedisCache.UserAccount.GetUserAccountByLoginAccount(LoginAccount);
                                    if (UserLevDT != null) {
                                        if (UserLevDT.Rows.Count > 0) {
                                            UserLevelIndex = (int)UserLevDT.Rows[0]["UserLevelIndex"];
                                            UserLevelUpdateDate = (DateTime)UserLevDT.Rows[0]["UserLevelUpdateDate"];
                                            DeposiAmount = (decimal)UserLevDT.Rows[0]["UserLevelAccumulationDepositAmount"];
                                            ValidBetValue = (decimal)UserLevDT.Rows[0]["UserLevelAccumulationValidBetValue"];

                                        }
                                    }

                                    if (UserLevelIndex == 0) {

                                    } else {
                                        //會員等級變更時間超過1個月 
                                        double UserLevelUpdatedays = DateTime.Now.Date.Subtract(UserLevelUpdateDate).TotalDays;
                                        //等級變動時間超過30天，檢查保級
                                        if (UserLevelUpdatedays >= KeepLevelDays) {
                                            //保級失敗
                                            if (!CheckUserLevelDowngrade(LoginAccount, UserLevelIndex, ValidBetValue, VIPSettingDetail)) {
                                                NewUserLevelIndex = UserLevelIndex - 1;

                                                try {
                                                    updateEwinUserLevelInfo(LoginAccount, NewUserLevelIndex);
                                                } catch (Exception ex) { }

                                                EWinWebDB.UserAccount.UserAccountLevelIndexChange(LoginAccount, 0, UserLevelIndex, NewUserLevelIndex, DeposiAmount, ValidBetValue, 0, 0, "SystemAutoCheckUserLevel", DateTime.Now.ToString("yyyy/MM/dd HH:mm:ss"));

                                            } else { //保級成功時間重新計算
                                                     //更新會員等級資料
                                                EWinWebDB.UserAccount.RelegationUserAccountLevelSuccess(UserLevelIndex, LoginAccount, DateTime.Now.ToString("yyyy/MM/dd HH:mm:ss"));
                                            }
                                        }
                                    }

                                    RedisCache.UserAccount.UpdateUserAccountByLoginAccount(LoginAccount);
                                    RedisCache.UserAccountVIPInfo.DeleteUserAccountVIPInfo(LoginAccount);
                                }
                            }
                        }

                        //發放每日返水
                        sendBuyChipGift(VIPSettingDetail);

                        R.Result = enumResult.OK;

                    } else {
                        SetResultException(R, "ActivityIsExpired");
                    }
                } else {
                    SetResultException(R, "ActivityIsExpired");
                }

            } else {
                SetResultException(R, "ActivityIsExpired");
            }
        } else {
            SetResultException(R, "InvalidPassword");
        }

        return R;
    }

    private int CheckUserLevelUpgrade(int UserLevelIndex, decimal DeposiAmount, decimal ValidBetValue, JArray VIPSettingDetail) {
        int UserLevel = 0;
        int Setting_UserLevelIndex = 0;
        decimal Setting_DepositMinValue = 0;
        decimal Setting_DepositMaxValue = 0;
        decimal Setting_ValidBetMinValue = 0;
        decimal Setting_ValidBetMaxValue = 0;
        decimal Setting_KeepValidBetValue = 0;
        int NextUserLevelIndex = UserLevelIndex + 1;
        bool IsMaxLevel = false;
        bool CheckDeposit = true;
        bool CheckValidBet = true;
        int DepositLevel = 0;    //儲值符合等級
        int ValidBetLevel = 0;   //流水符合等級

        //for (int i = UserLevelIndex; i < VIPSettingDetail.Count; i++) {
        //    Setting_UserLevelIndex = (int)VIPSettingDetail[i]["UserLevelIndex"];
        //    Setting_DepositMinValue = (decimal)VIPSettingDetail[i]["DepositMinValue"];
        //    Setting_DepositMaxValue = (decimal)VIPSettingDetail[i]["DepositMaxValue"];
        //    Setting_ValidBetMinValue = (decimal)VIPSettingDetail[i]["ValidBetMinValue"];
        //    Setting_ValidBetMaxValue = (decimal)VIPSettingDetail[i]["ValidBetMaxValue"];
        //    Setting_KeepValidBetValue = (decimal)VIPSettingDetail[i]["KeepValidBetValue"];

        //    if (CheckDeposit) {
        //        //最高等級
        //        if (Setting_UserLevelIndex == VIPSettingDetail.Count - 1) {
        //            if (DeposiAmount >= Setting_DepositMinValue) {
        //                DepositLevel = Setting_UserLevelIndex;
        //                CheckDeposit = false;
        //            }
        //        } else {
        //            if (DeposiAmount < Setting_DepositMaxValue) {
        //                if (DeposiAmount >= Setting_DepositMinValue) {
        //                    DepositLevel = Setting_UserLevelIndex;
        //                    CheckDeposit = false;
        //                }
        //            }
        //        }

        //    }

        //    if (CheckValidBet) {
        //        //最高等級
        //        if (Setting_UserLevelIndex == VIPSettingDetail.Count - 1) {
        //            if (ValidBetValue >= Setting_ValidBetMinValue) {
        //                ValidBetLevel = Setting_UserLevelIndex;
        //                CheckValidBet = false;
        //            }
        //        } else {
        //            if (ValidBetValue < Setting_ValidBetMaxValue) {
        //                if (ValidBetValue >= Setting_ValidBetMinValue) {
        //                    ValidBetLevel = Setting_UserLevelIndex;
        //                    CheckValidBet = false;
        //                }
        //            }
        //        }
        //    }

        //}

        //if (DepositLevel == ValidBetLevel) {
        //    UserLevel = DepositLevel;
        //} else if (DepositLevel < ValidBetLevel) {
        //    UserLevel = DepositLevel;
        //} else {
        //    UserLevel = ValidBetLevel;
        //}

        //最高等級
        if (UserLevelIndex == VIPSettingDetail.Count - 1) {
            return UserLevelIndex;
        } else {
            Setting_UserLevelIndex = (int)VIPSettingDetail[NextUserLevelIndex]["UserLevelIndex"];
            Setting_DepositMinValue = (decimal)VIPSettingDetail[NextUserLevelIndex]["DepositMinValue"];
            Setting_DepositMaxValue = (decimal)VIPSettingDetail[NextUserLevelIndex]["DepositMaxValue"];
            Setting_ValidBetMinValue = (decimal)VIPSettingDetail[NextUserLevelIndex]["ValidBetMinValue"];
            Setting_ValidBetMaxValue = (decimal)VIPSettingDetail[NextUserLevelIndex]["ValidBetMaxValue"];
            Setting_KeepValidBetValue = (decimal)VIPSettingDetail[NextUserLevelIndex]["KeepValidBetValue"];

            if (DeposiAmount >= Setting_DepositMinValue) {
                DepositLevel = Setting_UserLevelIndex;
            } else {
                DepositLevel = UserLevelIndex;
            }

            if (ValidBetValue >= Setting_ValidBetMinValue) {
                ValidBetLevel = Setting_UserLevelIndex;
            } else {
                ValidBetLevel = UserLevelIndex;
            }

            if (DepositLevel == ValidBetLevel) {
                UserLevel = DepositLevel;
            } else if (DepositLevel < ValidBetLevel) {
                UserLevel = DepositLevel;
            } else {
                UserLevel = ValidBetLevel;
            }
        }

        return UserLevel;
    }

    private bool CheckUserLevelDowngrade(string LoginAccount, int UserLevelIndex, decimal ValidBetValue, JArray VIPSettingDetail) {
        decimal Setting_KeepValidBetValue = 0;
        bool KeepLevelSucc = false;
        System.Data.DataTable DT = new System.Data.DataTable();

        if (VIPSettingDetail.Count >= UserLevelIndex) {
            Setting_KeepValidBetValue = (decimal)VIPSettingDetail[UserLevelIndex]["KeepValidBetValue"];
            if (ValidBetValue >= Setting_KeepValidBetValue) {
                KeepLevelSucc = true;
            }

        }

        return KeepLevelSucc;
    }

    private void SendUpgradeGift(string LoginAccount) {
        var UpgradeBonusResult = ActivityCore.GetVIPUpgradeBonusResult(LoginAccount);

        if (UpgradeBonusResult.Result == ActivityCore.enumActResult.OK) {
            EWin.Lobby.LobbyAPI lobbyAPI = new EWin.Lobby.LobbyAPI();
            List<EWin.Lobby.PropertySet> PropertySets = new List<EWin.Lobby.PropertySet>();
            string CollectAreaType;

            foreach (var activityData in UpgradeBonusResult.Data) {

                string description = activityData.ActivityName;
                string JoinActivityCycle = activityData.JoinActivityCycle == null ? "1" : activityData.JoinActivityCycle;
                string PromotionCode = "VIPLev";
                string PromotionCategoryCode = "";
                CollectAreaType = activityData.CollectAreaType == null ? "2" : activityData.CollectAreaType;

                PropertySets.Add(new EWin.Lobby.PropertySet { Name = "ThresholdValue", Value = activityData.ThresholdValue.ToString() });
                PropertySets.Add(new EWin.Lobby.PropertySet { Name = "PointValue", Value = activityData.BonusValue.ToString() });
                PropertySets.Add(new EWin.Lobby.PropertySet { Name = "JoinActivityCycle", Value = JoinActivityCycle.ToString() });

                lobbyAPI.AddPromotionCollect(GetToken(), description + "_" + LoginAccount + "_UpgradeGift", LoginAccount, EWinWeb.MainCurrencyType, PromotionCode, PromotionCategoryCode, int.Parse(CollectAreaType), 90, description, PropertySets.ToArray());
                EWinWebDB.UserAccountEventSummary.UpdateUserAccountEventSummary(LoginAccount, description, JoinActivityCycle, 1, activityData.ThresholdValue, activityData.BonusValue);
            }
        }
    }

    private void SendUpgradeGiftByUserLevelIndex(string LoginAccount, int UserLevelIndex) {
        System.Data.DataTable DT;
        string ActivityName = string.Empty;
        EWin.Lobby.LobbyAPI lobbyAPI = new EWin.Lobby.LobbyAPI();
        decimal t = 0;
        decimal b = 0;
        bool hasgift = false;
        bool ActivityIsAlreadyJoin = false;

        switch (UserLevelIndex) {
            case 3:
                ActivityName = "VIPLev3";
                t = 2500;
                b = 500;
                hasgift = true;
                break;
            case 4:
                ActivityName = "VIPLev4";
                t = 5000;
                b = 1000;
                hasgift = true;
                break;
            case 5:
                ActivityName = "VIPLev5";
                t = 25000;
                b = 5000;
                hasgift = true;
                break;
            case 6:
                ActivityName = "VIPLev6";
                t = 35000;
                b = 7000;
                hasgift = true;
                break;
            case 7:
                ActivityName = "VIPLev7";
                t = 50000;
                b = 10000;
                hasgift = true;
                break;
            case 8:
                ActivityName = "VIPLev8";
                t = 60000;
                b = 12000;
                hasgift = true;
                break;
            case 9:
                ActivityName = "VIPLev9";
                t = 250000;
                b = 50000;
                hasgift = true;
                break;
            case 10:
                ActivityName = "VIPLev10";
                t = 500000;
                b = 100000;
                hasgift = true;
                break;
        }

        if (hasgift) {
            DT = RedisCache.UserAccountEventSummary.GetUserAccountEventSummaryByLoginAccount(LoginAccount);

            if (DT != null && DT.Rows.Count > 0) {
                for (int i = 0; i < DT.Rows.Count; i++) {
                    if ((string)DT.Rows[i]["ActivityName"] == ActivityName) {
                        ActivityIsAlreadyJoin = true;
                    }
                }
            }

            if (ActivityIsAlreadyJoin) {

            } else {
                List<EWin.Lobby.PropertySet> PropertySets = new List<EWin.Lobby.PropertySet>();

                string description = ActivityName;
                decimal ThresholdValue = t;
                decimal BonusValue = b;
                string PromotionCode = "VIPLev";
                string PromotionCategoryCode = "";
                string JoinActivityCycle = "1";
                string CollectAreaType = "2";

                PropertySets.Add(new EWin.Lobby.PropertySet { Name = "ThresholdValue", Value = ThresholdValue.ToString() });
                PropertySets.Add(new EWin.Lobby.PropertySet { Name = "PointValue", Value = BonusValue.ToString() });

                lobbyAPI.AddPromotionCollect(GetToken(), description + "_" + LoginAccount + "_UpgradeGift", LoginAccount, EWinWeb.MainCurrencyType, PromotionCode, PromotionCategoryCode, int.Parse(CollectAreaType), 90, description, PropertySets.ToArray());
                EWinWebDB.UserAccountEventSummary.UpdateUserAccountEventSummary(LoginAccount, description, JoinActivityCycle, 1, ThresholdValue, BonusValue);
            }
        }
    }

    [WebMethod]
    public APIResult SendVIPMonthGift(string password) {
        APIResult R = new APIResult();
        JObject ActivityDetail;
        System.Data.DataTable DT = new System.Data.DataTable();
        decimal BonusValue = 0;
        decimal ThresholdValue = 0;
        int UserLevelIndex = 0;
        int MinLevelIndex = 0;   //最低可取得月禮物的等級
        bool IsUserLevelIndexSupport = false;
        string LoginAccount;
        string PromotionCode = "";
        string PromotionCategoryCode = "";
        List<EWin.Lobby.PropertySet> PropertySets = new List<EWin.Lobby.PropertySet>();
        EWin.Lobby.LobbyAPI lobbyAPI = new EWin.Lobby.LobbyAPI();

        if (CheckPassword(password)) {
            ActivityDetail = ActivityCore.GetActivityDetailByCategoryAndName("VIPMonthGift", "VIPMonthGift");

            if (ActivityDetail != null) {
                DateTime StartDate = DateTime.Parse(ActivityDetail["StartDate"].ToString());
                DateTime EndDate = DateTime.Parse(ActivityDetail["EndDate"].ToString());
                MinLevelIndex = int.Parse(ActivityDetail["MinLevelIndex"].ToString());

                if ((int)ActivityDetail["State"] == 0) {
                    if (DateTime.Now >= StartDate && DateTime.Now < EndDate) {

                        DT = EWinWebDB.UserAccount.GetUserAccount();

                        if (DT != null && DT.Rows.Count > 0) {
                            foreach (System.Data.DataRow dr in DT.Rows) {
                                IsUserLevelIndexSupport = false;
                                BonusValue = 0;
                                ThresholdValue = 0;
                                UserLevelIndex = (int)dr["UserLevelIndex"];
                                LoginAccount = (string)dr["LoginAccount"];
                                PropertySets = new List<EWin.Lobby.PropertySet>();

                                if (UserLevelIndex >= MinLevelIndex) {
                                    foreach (var item in ActivityDetail["VIP"]) {
                                        if ((int)item["UserLevelIndex"] == UserLevelIndex) {
                                            IsUserLevelIndexSupport = true;
                                            BonusValue = (decimal)item["BonusValue"];
                                            ThresholdValue = (decimal)item["ThresholdValue"];
                                            break;
                                        }
                                    }

                                    if (IsUserLevelIndexSupport) {
                                        string description = (string)ActivityDetail["Name"];
                                        PromotionCode = description;
                                        string JoinActivityCycle = "1";
                                        string CollectAreaType = ActivityDetail["CollectAreaType"].ToString() == null ? "2" : ActivityDetail["CollectAreaType"].ToString();

                                        PropertySets.Add(new EWin.Lobby.PropertySet { Name = "ThresholdValue", Value = ThresholdValue.ToString() });
                                        PropertySets.Add(new EWin.Lobby.PropertySet { Name = "PointValue", Value = BonusValue.ToString() });
                                        PropertySets.Add(new EWin.Lobby.PropertySet { Name = "JoinActivityCycle", Value = JoinActivityCycle.ToString() });

                                        lobbyAPI.AddPromotionCollect(GetToken(), description + "_" + LoginAccount + "_" + System.Guid.NewGuid().ToString(), LoginAccount, EWinWeb.MainCurrencyType, PromotionCode, PromotionCategoryCode, int.Parse(CollectAreaType), 90, description, PropertySets.ToArray());
                                        EWinWebDB.UserAccountEventSummary.UpdateUserAccountEventSummary(LoginAccount, description, JoinActivityCycle, 1, ThresholdValue, BonusValue);

                                    }
                                }
                            }
                        }

                        R.Result = enumResult.OK;
                    } else {
                        SetResultException(R, "ActivityIsExpired");
                    }
                } else {
                    SetResultException(R, "ActivityIsExpired");
                }
            } else {
                SetResultException(R, "ActivityNotExist");
            }
        } else {
            SetResultException(R, "InvalidPassword");
        }
        return R;
    }

    [WebMethod]
    public APIResult SendVIPBirthdayGift(string password, string searchMonth) {
        APIResult R = new APIResult();
        JObject ActivityDetail;
        System.Data.DataTable DT = new System.Data.DataTable();
        decimal BonusValue = 0;
        decimal ThresholdValue = 0;
        int UserLevelIndex = 0;
        int MinLevelIndex = 0;   //最低可取得月禮物的等級
        bool IsUserLevelIndexSupport = false;
        string LoginAccount;
        string PromotionCode = "";
        string PromotionCategoryCode = "";
        List<EWin.Lobby.PropertySet> PropertySets = new List<EWin.Lobby.PropertySet>();
        EWin.Lobby.LobbyAPI lobbyAPI = new EWin.Lobby.LobbyAPI();

        if (CheckPassword(password)) {
            ActivityDetail = ActivityCore.GetActivityDetailByCategoryAndName("VIPMonthGift", "VIPBirthdayGift");

            if (ActivityDetail != null) {
                DateTime StartDate = DateTime.Parse(ActivityDetail["StartDate"].ToString());
                DateTime EndDate = DateTime.Parse(ActivityDetail["EndDate"].ToString());
                MinLevelIndex = int.Parse(ActivityDetail["MinLevelIndex"].ToString());

                if ((int)ActivityDetail["State"] == 0) {
                    if (DateTime.Now >= StartDate && DateTime.Now < EndDate) {

                        DT = EWinWebDB.UserAccount.GetBirthdayOfTheMonth(searchMonth);

                        if (DT != null && DT.Rows.Count > 0) {
                            foreach (System.Data.DataRow dr in DT.Rows) {
                                IsUserLevelIndexSupport = false;
                                BonusValue = 0;
                                ThresholdValue = 0;
                                UserLevelIndex = (int)dr["UserLevelIndex"];
                                LoginAccount = (string)dr["LoginAccount"];
                                PropertySets = new List<EWin.Lobby.PropertySet>();

                                if (UserLevelIndex >= MinLevelIndex) {
                                    foreach (var item in ActivityDetail["VIP"]) {
                                        if ((int)item["UserLevelIndex"] == UserLevelIndex) {
                                            IsUserLevelIndexSupport = true;
                                            BonusValue = (decimal)item["BonusValue"];
                                            ThresholdValue = (decimal)item["ThresholdValue"];
                                            break;
                                        }
                                    }

                                    if (IsUserLevelIndexSupport) {
                                        string description = (string)ActivityDetail["Name"];
                                        PromotionCode = description;
                                        string JoinActivityCycle = "1";
                                        string CollectAreaType = ActivityDetail["CollectAreaType"].ToString() == null ? "2" : ActivityDetail["CollectAreaType"].ToString();

                                        PropertySets.Add(new EWin.Lobby.PropertySet { Name = "ThresholdValue", Value = ThresholdValue.ToString() });
                                        PropertySets.Add(new EWin.Lobby.PropertySet { Name = "PointValue", Value = BonusValue.ToString() });
                                        PropertySets.Add(new EWin.Lobby.PropertySet { Name = "JoinActivityCycle", Value = JoinActivityCycle.ToString() });

                                        lobbyAPI.AddPromotionCollect(GetToken(), description + "_" + LoginAccount + "_" + System.Guid.NewGuid().ToString(), LoginAccount, EWinWeb.MainCurrencyType, PromotionCode, PromotionCategoryCode, int.Parse(CollectAreaType), 90, description, PropertySets.ToArray());
                                        EWinWebDB.UserAccountEventSummary.UpdateUserAccountEventSummary(LoginAccount, description, JoinActivityCycle, 1, ThresholdValue, BonusValue);

                                    }
                                }
                            }
                        }

                        R.Result = enumResult.OK;
                    } else {
                        SetResultException(R, "ActivityIsExpired");
                    }
                } else {
                    SetResultException(R, "ActivityIsExpired");
                }
            } else {
                SetResultException(R, "ActivityNotExist");
            }
        } else {
            SetResultException(R, "InvalidPassword");
        }
        return R;
    }

    [WebMethod]
    public APIResult ManualUserLevelAdjust(string Password, string LoginAccount, int NewUserLevelIndex) {
        APIResult R = new APIResult() { Result = enumResult.ERR };
        JObject VIPSetting;
        JArray VIPSettingDetail;
        int ActivityState = 1;
        int KeepLevelDays = 30;
        DateTime ActivityStartDate;
        DateTime ActivityEndDate;
        int UserLevelIndex_Now = 0;
        System.Data.DataTable UTSDT = new System.Data.DataTable();
        System.Data.DataTable DT = new System.Data.DataTable();
        System.Data.DataTable UserLevDT = new System.Data.DataTable();

        if (CheckPassword(Password)) {
            VIPSetting = GetActivityDetail("../App_Data/VIPSetting.json");

            if (VIPSetting != null) {
                ActivityState = (int)VIPSetting["State"];
                ActivityStartDate = DateTime.Parse(VIPSetting["StartDate"].ToString());
                ActivityEndDate = DateTime.Parse(VIPSetting["EndDate"].ToString());
                VIPSettingDetail = JArray.Parse(VIPSetting["VIPSetting"].ToString());
                KeepLevelDays = (int)VIPSetting["KeepLevelDays"];

                if (ActivityState == 0) {
                    if (DateTime.Now >= ActivityStartDate && DateTime.Now < ActivityEndDate) {
                        //取UserAccountTotalSummary資料 
                        DT = EWinWebDB.UserAccount.GetUserAccount(LoginAccount);

                        if (DT != null && DT.Rows.Count > 0) {
                            UserLevelIndex_Now = (int)DT.Rows[0]["UserLevelIndex"];

                            if (UserLevelIndex_Now != NewUserLevelIndex) {
                                try {
                                    updateEwinUserLevelInfo(LoginAccount, NewUserLevelIndex);
                                } catch (Exception ex) { }
                                EWinWebDB.UserAccount.UpdateUserAccountLevel(NewUserLevelIndex, LoginAccount, DateTime.Now.ToString("yyyy/MM/dd HH:mm:ss"));
                                //發升級禮物
                                if (NewUserLevelIndex > UserLevelIndex_Now) {
                                    for (int i = 1; i <= NewUserLevelIndex - UserLevelIndex_Now; i++) {
                                        SendUpgradeGiftByUserLevelIndex(LoginAccount, UserLevelIndex_Now + i);
                                    }
                                }
                                RedisCache.UserAccount.UpdateUserAccountByLoginAccount(LoginAccount);
                                RedisCache.UserAccountVIPInfo.DeleteUserAccountVIPInfo(LoginAccount);
                            }
                        }

                        R.Result = enumResult.OK;

                    } else {
                        SetResultException(R, "ActivityIsExpired");
                    }
                } else {
                    SetResultException(R, "ActivityIsExpired");
                }

            } else {
                SetResultException(R, "ActivityIsExpired");
            }
        } else {
            SetResultException(R, "InvalidPassword");
        }
        return R;
    }

    [WebMethod]
    public APIResult ImmediateUpgradeUserLevelInfo(string Password) {
        APIResult R = new APIResult() { Result = enumResult.ERR };
        EWin.FANTA.FANTA api = new EWin.FANTA.FANTA();
        EWin.FANTA.SelfValidBetResult callResult = new EWin.FANTA.SelfValidBetResult();
        JObject SettingData;
        System.Data.DataTable DT = new System.Data.DataTable();
        System.Data.DataTable UserDT = new System.Data.DataTable();
        string SearchStartDate;
        string SearchEndDate = DateTime.Now.ToString("yyyy/MM/dd HH:mm:ss");
        decimal ValidBetValueFromSummary = 0;

        if (CheckPassword(Password)) {
            //同步Ewin的有效投注(LastUpdateDate,現在時間)
            //UserAccountTable裡的ValidBetValueFromSummary，若有差額將差額加入UserLevelAccumulationValidBetValue並將該資料加入DB中的Summary
            SettingData = EWinWeb.GetCheckVIPUpgradeSettingJObj();

            if (SettingData.ContainsKey("LastUpdateDate")) {
                SearchStartDate = SettingData["LastUpdateDate"].ToString();
            } else {
                SearchStartDate = DateTime.Now.ToString("yyyy/MM/dd 00:00:00");
            }

            callResult = api.GetUserSelfValidBetValueFromSummaryByDate(GetToken(), System.Guid.NewGuid().ToString(), EWinWeb.MainCurrencyType, SearchStartDate, SearchEndDate);

            if (callResult.ResultState == EWin.FANTA.enumResultState.OK) {
                string LoginAccount;
                decimal ValidBetValue;
                string SummaryDate = string.Empty;
                DateTime LastValidBetValueSummaryDate;

                var SummaryList = callResult.SelfValidBetList.GroupBy(x => new { x.SummaryDate, x.LoginAccount }, x => x, (key, sum) => new EWin.Lobby.OrderSummary {
                    TotalValidBetValue = sum.Sum(y => y.SelfValidBetValue),
                    LoginAccount = key.LoginAccount,
                    SummaryDate = key.SummaryDate
                }).OrderBy(x => x.SummaryDate).ToList();

                for (int i = 0; i < SummaryList.Count; i++) {
                    LoginAccount = SummaryList[i].LoginAccount;
                    ValidBetValue = SummaryList[i].TotalValidBetValue;
                    SummaryDate = DateTime.Parse(SummaryList[i].SummaryDate).ToString("yyyy/MM/dd 00:00:00");
                    UserDT = RedisCache.UserAccount.GetUserAccountByLoginAccount(LoginAccount);
                    ValidBetValueFromSummary = 0;

                    if (UserDT != null && UserDT.Rows.Count > 0) {
                        //最新同步有效投注
                        ValidBetValueFromSummary = (decimal)UserDT.Rows[0]["ValidBetValueFromSummary"];
                        //最新同步時間
                        LastValidBetValueSummaryDate = (DateTime)UserDT.Rows[0]["LastValidBetValueSummaryDate"];

                        //跨日資料，ValidBetValueFromSummary = ValidBetValue，UserLevelAccumulationValidBetValue = UserLevelAccumulationValidBetValue + ValidBetValue
                        //非跨日資料，若 ValidBetValue == ValidBetValueFromSummary => 資料沒異動 Break
                        //                        若 ValidBetValue != ValidBetValueFromSummary  => ValidBetValueFromSummary = ValidBetValue，UserLevelAccumulationValidBetValue = UserLevelAccumulationValidBetValue + (ValidBetValue - ValidBetValueFromSummary)

                        if (DateTime.Parse(LastValidBetValueSummaryDate.ToString("yyyy/MM/dd 00:00:00")) == DateTime.Parse(SummaryDate)) {
                            if (ValidBetValueFromSummary != ValidBetValue) {
                                EWinWebDB.UserAccount.UpdateUserVipValidBetValueInfo(LoginAccount, ValidBetValue, ValidBetValue - ValidBetValueFromSummary, DateTime.Parse(SummaryDate));
                            }
                        } else if (DateTime.Parse(LastValidBetValueSummaryDate.ToString("yyyy/MM/dd 00:00:00")) < DateTime.Parse(SummaryDate)) {
                            EWinWebDB.UserAccount.UpdateUserVipValidBetValueInfo(LoginAccount, ValidBetValue, ValidBetValue, DateTime.Parse(SummaryDate));
                        }

                        RedisCache.UserAccount.UpdateUserAccountByLoginAccount(LoginAccount);
                        RedisCache.UserAccountVIPInfo.DeleteUserAccountVIPInfo(LoginAccount);
                    }
                }

                ImmediateUpgradeUserLevel();
                R.Result = enumResult.OK;
            } else {
                SetResultException(R, callResult.Message);
            }

            SettingData["LastUpdateDate"] = DateTime.Parse(SearchEndDate).ToString("yyyy/MM/dd 00:00:00");
            string Filename = HttpContext.Current.Server.MapPath("/App_Data/CheckVIPUpgradeSetting.json");

            WriteAllText(Filename, SettingData.ToString());
        } else {
            SetResultException(R, "InvalidPassword");
        }
        return R;
    }

    private APIResult ImmediateUpgradeUserLevel() {
        APIResult R = new APIResult() { Result = enumResult.ERR };
        System.Data.DataTable DT = new System.Data.DataTable();
        System.Data.DataTable UserDT = new System.Data.DataTable();
        JObject VIPSetting;
        JArray VIPSettingDetail;
        int UserLevelIndex = 0;
        int NewUserLevelIndex = 0;
        string LoginAccount = string.Empty;
        decimal UserLevelAccumulationDepositAmount = 0; //下一級累積入金金額(若有晉級，當前累積要扣除升級所需條件，再更新至資料表中讓使用者繼續累積下一等級)
        decimal UserLevelAccumulationValidBetValue = 0;    //下一級累積有效投注(若有晉級，當前累積要扣除升級所需條件，再更新至資料表中讓使用者繼續累積下一等級)
        decimal DeposiAmount = 0;
        decimal ValidBetValue = 0;
        int Setting_UserLevelIndex = 0;
        decimal Setting_DepositMinValue = 0;
        decimal Setting_DepositMaxValue = 0;
        decimal Setting_ValidBetMinValue = 0;
        decimal Setting_ValidBetMaxValue = 0;
        int DepositLevel = 0;    //儲值符合等級
        int ValidBetLevel = 0;   //流水符合等級
        bool CheckDeposit = true;
        bool CheckValidBet = true;
        List<UserLevelUpgradeTempData> UserLevelUpgradeTempDatas = new List<UserLevelUpgradeTempData>();

        VIPSetting = GetActivityDetail("../App_Data/VIPSetting.json");
        if (VIPSetting != null) {
            UserDT = EWinWebDB.UserAccount.GetNeedCheckVipUpgradeUser(DateTime.Now.AddMinutes(-5));

            if (UserDT != null && UserDT.Rows.Count > 0) {
                VIPSettingDetail = JArray.Parse(VIPSetting["VIPSetting"].ToString());
                foreach (System.Data.DataRow dr in UserDT.Rows) {
                    UserLevelIndex = (int)dr["UserLevelIndex"];
                    LoginAccount = (string)dr["LoginAccount"];
                    UserLevelAccumulationDepositAmount = (decimal)dr["UserLevelAccumulationDepositAmount"];
                    UserLevelAccumulationValidBetValue = (decimal)dr["UserLevelAccumulationValidBetValue"];
                    DeposiAmount = UserLevelAccumulationDepositAmount;
                    ValidBetValue = UserLevelAccumulationValidBetValue;
                    DepositLevel = UserLevelIndex;
                    ValidBetLevel = UserLevelIndex;
                    Setting_DepositMinValue = 0;
                    Setting_DepositMaxValue = 0;
                    Setting_ValidBetMinValue = 0;
                    Setting_ValidBetMaxValue = 0;
                    CheckDeposit = true;
                    CheckValidBet = true;

                    //最高等時不處理
                    if (UserLevelIndex != VIPSettingDetail.Count - 1) {
                        for (int i = UserLevelIndex + 1; i < VIPSettingDetail.Count; i++) {
                            Setting_UserLevelIndex = (int)VIPSettingDetail[i]["UserLevelIndex"];
                            Setting_DepositMinValue += (decimal)VIPSettingDetail[i]["DepositMinValue"];
                            Setting_DepositMaxValue += (decimal)VIPSettingDetail[i]["DepositMaxValue"];
                            Setting_ValidBetMinValue += (decimal)VIPSettingDetail[i]["ValidBetMinValue"];
                            Setting_ValidBetMaxValue += (decimal)VIPSettingDetail[i]["ValidBetMaxValue"];

                            UserLevelUpgradeTempData k = new UserLevelUpgradeTempData() {
                                NewLevelIndex = Setting_UserLevelIndex,
                                DepositMinValue = Setting_DepositMinValue,
                                ValidBetMinValue = Setting_ValidBetMinValue
                            };

                            UserLevelUpgradeTempDatas.Add(k);

                            if (CheckDeposit) {
                                if (DeposiAmount >= Setting_DepositMinValue) {
                                    if (DeposiAmount < Setting_DepositMaxValue) {
                                        DepositLevel = Setting_UserLevelIndex;
                                        CheckDeposit = false;
                                    } else {
                                        DepositLevel = Setting_UserLevelIndex;
                                    }
                                } else {
                                    CheckDeposit = false;
                                }
                            }

                            if (CheckValidBet) {
                                if (ValidBetValue >= Setting_ValidBetMinValue) {
                                    if (ValidBetValue < Setting_ValidBetMaxValue) {
                                        ValidBetLevel = Setting_UserLevelIndex;
                                        CheckValidBet = false;
                                    } else {
                                        ValidBetLevel = Setting_UserLevelIndex;
                                    }
                                } else {
                                    CheckValidBet = false;
                                }
                            }
                        }

                        if (DepositLevel == ValidBetLevel) {
                            NewUserLevelIndex = DepositLevel;
                        } else if (DepositLevel < ValidBetLevel) {
                            NewUserLevelIndex = DepositLevel;
                        } else {
                            NewUserLevelIndex = ValidBetLevel;
                        }

                        //等級有變動再處裡
                        if (NewUserLevelIndex > UserLevelIndex) {

                            foreach (var item in UserLevelUpgradeTempDatas) {
                                if (item.NewLevelIndex == NewUserLevelIndex) {
                                    UserLevelAccumulationDepositAmount = UserLevelAccumulationDepositAmount - item.DepositMinValue;
                                    UserLevelAccumulationValidBetValue = UserLevelAccumulationValidBetValue - item.ValidBetMinValue;
                                }
                            }

                            //發升級禮物
                            for (int i = 1; i <= NewUserLevelIndex - UserLevelIndex; i++) {
                                SendUpgradeGiftByUserLevelIndex(LoginAccount, UserLevelIndex + i);
                            }

                            try {
                                updateEwinUserLevelInfo(LoginAccount, NewUserLevelIndex);
                            } catch (Exception ex) { }

                            EWinWebDB.UserAccount.UserAccountLevelIndexChange(LoginAccount, 1, UserLevelIndex, NewUserLevelIndex, DeposiAmount, ValidBetValue, UserLevelAccumulationDepositAmount, UserLevelAccumulationValidBetValue, "SystemAutoCheckUserLevel", DateTime.Now.ToString("yyyy/MM/dd HH:mm:ss"));

                            RedisCache.UserAccount.UpdateUserAccountByLoginAccount(LoginAccount);
                            RedisCache.UserAccountVIPInfo.DeleteUserAccountVIPInfo(LoginAccount);
                        }
                    }
                }
            }
        }

        return R;
    }

    public void updateEwinUserLevelInfo(string LoginAccount, int UserLevelIndex) {
        updateEwinUserLevel(LoginAccount, UserLevelIndex);
        setUserAccountProperty(LoginAccount, System.Guid.NewGuid().ToString(), "UserLevelUpdateDate", DateTime.Now.ToString("yyyy/MM/dd"));
    }

    private EWin.FANTA.APIResult updateEwinUserLevel(string LoginAccount, int UserLevelIndex) {
        EWin.FANTA.APIResult R = new EWin.FANTA.APIResult();
        EWin.FANTA.FANTA API = new EWin.FANTA.FANTA();

        R = API.UpdateUserLevel(GetToken(), LoginAccount, UserLevelIndex);

        return R;
    }

    private EWin.FANTA.APIResult sendBuyChipGift(JArray VIPSettingDetail) {
        EWin.FANTA.APIResult R = new EWin.FANTA.APIResult();
        EWin.FANTA.FANTA API = new EWin.FANTA.FANTA();
        string ActivityName;
        int UserLevelIndex = 0;
        DateTime n = DateTime.Parse(DateTime.Now.AddDays(-1).ToString("yyyy/MM/dd 00:00:00"));
        string CurrencyType = EWinWeb.MainCurrencyType;

        for (int i = 0; i < VIPSettingDetail.Count; i++) {
            var k = VIPSettingDetail[i];
            List<EWin.FANTA.VipBuyChipRateSetting> BuyChipAddRate = Newtonsoft.Json.JsonConvert.DeserializeObject<List<EWin.FANTA.VipBuyChipRateSetting>>(k["BuyChipAddRate"].ToString());

            if (BuyChipAddRate.Count > 0) {
                UserLevelIndex = (int)k["UserLevelIndex"];
                ActivityName = "Vip" + UserLevelIndex + "BuyChipGift";
                R = API.AddUserLevelBuyChip(GetToken(), ActivityName, UserLevelIndex, CurrencyType, n, BuyChipAddRate.ToArray());
            }
        }

        return R;
    }

    private EWin.Lobby.APIResult setUserAccountProperty(string LoginAccount, string GUID, string PropertyName, string PropertyValue) {
        EWin.Lobby.LobbyAPI lobbyAPI = new EWin.Lobby.LobbyAPI();
        EWin.Lobby.APIResult R = new EWin.Lobby.APIResult();

        R = lobbyAPI.SetUserAccountProperty(GetToken(), GUID, EWin.Lobby.enumUserTypeParam.ByLoginAccount, LoginAccount, PropertyName, PropertyValue);

        return R;
    }

    [WebMethod]
    public APIResult OpenSite(string Password) {
        APIResult R = new APIResult() { Result = enumResult.ERR };

        dynamic o = null;
        string Filename;

        if (CheckPassword(Password)) {
            Filename = HttpContext.Current.Server.MapPath("/App_Data/Setting.json");

            if (System.IO.File.Exists(Filename)) {
                string SettingContent;

                SettingContent = System.IO.File.ReadAllText(Filename);

                if (string.IsNullOrEmpty(SettingContent) == false) {
                    try {
                        o = Newtonsoft.Json.JsonConvert.DeserializeObject(SettingContent);
                        o.InMaintenance = 0;

                        System.IO.File.WriteAllText(Filename, Newtonsoft.Json.JsonConvert.SerializeObject(o));
                        R.Result = enumResult.OK;
                    } catch (Exception ex) { }
                }
            }

        } else {
            SetResultException(R, "InvalidPassword");
        }

        return R;
    }

    [WebMethod]
    public APIResult MaintainSite(string Password, string Message) {
        APIResult R = new APIResult() { Result = enumResult.ERR };

        dynamic o = null;
        string Filename;

        if (CheckPassword(Password)) {
            Filename = HttpContext.Current.Server.MapPath("/App_Data/Setting.json");

            if (System.IO.File.Exists(Filename)) {
                string SettingContent;

                SettingContent = System.IO.File.ReadAllText(Filename);

                if (string.IsNullOrEmpty(SettingContent) == false) {
                    try {
                        o = Newtonsoft.Json.JsonConvert.DeserializeObject(SettingContent);
                        o.InMaintenance = 1;

                        if (string.IsNullOrEmpty(Message) == false) {
                            o.MaintainMessage = Message;
                        }

                        System.IO.File.WriteAllText(Filename, Newtonsoft.Json.JsonConvert.SerializeObject(o));

                        var allSID = RedisCache.SessionContext.ListAllSID();
                        foreach (var item in allSID) {
                            RedisCache.SessionContext.ExpireSID(item);
                        }

                        R.Result = enumResult.OK;
                    } catch (Exception ex) { }
                }
            }

        } else {
            SetResultException(R, "InvalidPassword");
        }

        return R;
    }

    [WebMethod]
    public APIResult EnableWithdrawlTemporaryMaintenance(string Password) {
        APIResult R = new APIResult() { Result = enumResult.ERR };

        dynamic o = null;
        string Filename;

        if (CheckPassword(Password)) {
            Filename = HttpContext.Current.Server.MapPath("/App_Data/Setting.json");

            if (System.IO.File.Exists(Filename)) {
                string SettingContent;

                SettingContent = System.IO.File.ReadAllText(Filename);

                if (string.IsNullOrEmpty(SettingContent) == false) {
                    try {
                        o = Newtonsoft.Json.JsonConvert.DeserializeObject(SettingContent);
                        o.WithdrawlTemporaryMaintenance = 1;

                        System.IO.File.WriteAllText(Filename, Newtonsoft.Json.JsonConvert.SerializeObject(o));
                        R.Result = enumResult.OK;
                    } catch (Exception ex) { }
                }
            }

        } else {
            SetResultException(R, "InvalidPassword");
        }

        return R;
    }

    [WebMethod]
    public APIResult DisableWithdrawlTemporaryMaintenance(string Password) {
        APIResult R = new APIResult() { Result = enumResult.ERR };

        dynamic o = null;
        string Filename;

        if (CheckPassword(Password)) {
            Filename = HttpContext.Current.Server.MapPath("/App_Data/Setting.json");

            if (System.IO.File.Exists(Filename)) {
                string SettingContent;

                SettingContent = System.IO.File.ReadAllText(Filename);

                if (string.IsNullOrEmpty(SettingContent) == false) {
                    try {
                        o = Newtonsoft.Json.JsonConvert.DeserializeObject(SettingContent);
                        o.WithdrawlTemporaryMaintenance = 0;

                        System.IO.File.WriteAllText(Filename, Newtonsoft.Json.JsonConvert.SerializeObject(o));
                        R.Result = enumResult.OK;
                    } catch (Exception ex) { }
                }
            }

        } else {
            SetResultException(R, "InvalidPassword");
        }

        return R;
    }

    [WebMethod]
    public APIResult UpdateAnnouncement(string Password, string Title, string Announcement) {
        APIResult R = new APIResult() { Result = enumResult.ERR };

        dynamic o = null;
        string Filename;

        if (CheckPassword(Password)) {
            Filename = HttpContext.Current.Server.MapPath("/App_Data/Setting.json");

            if (System.IO.File.Exists(Filename)) {
                string SettingContent;

                SettingContent = System.IO.File.ReadAllText(Filename);

                if (string.IsNullOrEmpty(SettingContent) == false) {
                    try {
                        o = Newtonsoft.Json.JsonConvert.DeserializeObject(SettingContent);
                        o.LoginMessage["Title"] = Title;
                        o.LoginMessage["Message"] = Announcement;
                        o.LoginMessage["Version"] = (decimal)o.LoginMessage["Version"] + 1;

                        System.IO.File.WriteAllText(Filename, Newtonsoft.Json.JsonConvert.SerializeObject(o));
                        R.Result = enumResult.OK;
                    } catch (Exception ex) { }
                }
            }

        } else {
            SetResultException(R, "InvalidPassword");
        }

        return R;
    }

    [WebMethod]
    public PaymentValueReslut CalculatePaymentValue(string Password, string PaymentSerial) {
        PaymentValueReslut R = new PaymentValueReslut() { Result = enumResult.ERR };

        if (CheckPassword(Password)) {
            System.Data.DataTable DT = EWinWebDB.UserAccountPayment.GetPaymentByPaymentSerial(PaymentSerial);


            if (DT != null && DT.Rows.Count > 0) {
                var row = DT.Rows[0];

                if ((int)row["FlowStatus"] != 0) {
                    decimal totalThresholdValue = 0;
                    decimal totalPointValue = 0;
                    string paymentDesc = "";
                    List<string> activityStrs = new List<string>();
                    string activityDataStr = (string)row["ActivityData"];

                    if (!string.IsNullOrEmpty(activityDataStr)) {
                        Newtonsoft.Json.Linq.JArray activityDatas = Newtonsoft.Json.Linq.JArray.Parse(activityDataStr);

                        foreach (var item in activityDatas) {
                            string desc = item["ActivityName"].ToString() + "_BnousValue_" + ((decimal)item["BonusValue"]).ToString() + "_ThresholdValue_" + ((decimal)item["ThresholdValue"]).ToString();
                            totalThresholdValue += (decimal)item["ThresholdValue"];
                            //totalPointValue += (decimal)item["BonusValue"];
                            activityStrs.Add(desc);
                        }
                    }



                    paymentDesc = "ThresholdValue=" + ((decimal)row["ThresholdValue"]).ToString() + ",ThresholdRate=" + ((decimal)row["ThresholdRate"]).ToString();

                    totalThresholdValue += (decimal)row["ThresholdValue"];
                    totalPointValue = (decimal)row["PointValue"];

                    R.TotalThresholdValue = totalThresholdValue;
                    R.TotalPointValue = totalPointValue;
                    R.LoginAccount = (string)row["LoginAccount"];
                    R.Amount = (decimal)row["Amount"];
                    R.PaymentSerial = (string)row["PaymentSerial"];
                    R.PaymentCode = (string)row["PaymentCode"];
                    R.PaymentDescription = paymentDesc;
                    R.ActivityDescription = activityStrs;
                    R.Result = enumResult.OK;
                } else {
                    SetResultException(R, "StatusError");
                }
            } else {
                SetResultException(R, "NoData");
            }
        } else {
            SetResultException(R, "InvalidPassword");
        }

        return R;
    }

    [WebMethod]
    public APIResult UpdateBulletinBoardState(string Password, int BulletinBoardID, int State) {
        APIResult R = new APIResult() { Result = enumResult.ERR };
        string SS;
        System.Data.SqlClient.SqlCommand DBCmd;
        int RetValue = 0;

        if (CheckPassword(Password)) {

            SS = " UPDATE BulletinBoard WITH (ROWLOCK) SET State=@State " +
                      " WHERE BulletinBoardID=@BulletinBoardID";
            DBCmd = new System.Data.SqlClient.SqlCommand();
            DBCmd.CommandText = SS;
            DBCmd.CommandType = System.Data.CommandType.Text;
            DBCmd.Parameters.Add("@State", System.Data.SqlDbType.Int).Value = State;
            DBCmd.Parameters.Add("@BulletinBoardID", System.Data.SqlDbType.Int).Value = BulletinBoardID;
            RetValue = DBAccess.ExecuteDB(EWinWeb.DBConnStr, DBCmd);

            if (RetValue > 0) {
                RedisCache.BulletinBoard.UpdateBulletinBoard();
                R.Result = enumResult.OK;
            }
        } else {
            SetResultException(R, "InvalidPassword");
        }

        return R;
    }

    [WebMethod]
    public APIResult InsertBulletinBoard(string Password, string BulletinTitle, string BulletinContent) {
        APIResult R = new APIResult() { Result = enumResult.ERR };
        string SS;
        System.Data.SqlClient.SqlCommand DBCmd;
        int RetValue = 0;

        if (CheckPassword(Password)) {

            SS = " INSERT INTO BulletinBoard (BulletinTitle, BulletinContent) " +
                      " VALUES (@BulletinTitle, @BulletinContent) ";
            DBCmd = new System.Data.SqlClient.SqlCommand();
            DBCmd.CommandText = SS;
            DBCmd.CommandType = System.Data.CommandType.Text;
            DBCmd.Parameters.Add("@BulletinTitle", System.Data.SqlDbType.NVarChar).Value = BulletinTitle;
            DBCmd.Parameters.Add("@BulletinContent", System.Data.SqlDbType.NVarChar).Value = BulletinContent;
            RetValue = DBAccess.ExecuteDB(EWinWeb.DBConnStr, DBCmd);

            if (RetValue > 0) {
                RedisCache.BulletinBoard.UpdateBulletinBoard();
                R.Result = enumResult.OK;
            }
        } else {
            SetResultException(R, "InvalidPassword");
        }

        return R;
    }

    [WebMethod]
    public APIResult InsertUserAccountNotify(string Password, string LoginAccount, string Title, string NotifyContent, string URL) {
        APIResult R = new APIResult() { Result = enumResult.ERR };
        string SS;
        System.Data.SqlClient.SqlCommand DBCmd;
        int RetValue = 0;
        int NotifyMsgID = 0;

        if (CheckPassword(Password)) {

            NotifyMsgID = EWinWebDB.NotifyMsg.InsertNotifyMsg(Title, NotifyContent, URL);

            if (NotifyMsgID != 0) {
                RetValue = EWinWebDB.UserAccountNotifyMsg.InsertUserAccountNotifyMsg(NotifyMsgID, 0, LoginAccount);

                if (RetValue > 0) {
                    R.Result = enumResult.OK;
                }
            } else {
                SetResultException(R, "InsertNotifyMsgErr");
            }

        } else {
            SetResultException(R, "InvalidPassword");
        }

        return R;
    }

    [WebMethod]
    public System.Data.DataTable GetCompanyCategory(string password) {

        System.Data.DataTable DT = new System.Data.DataTable();
        if (CheckPassword(password)) {
            DT = RedisCache.CompanyCategory.GetCompanyCategory();
        }
        return DT;
    }

    [WebMethod]
    public APIResult UpdateCompanyCategoryState(string Password, int CompanyCategoryID, int State) {
        APIResult R = new APIResult() { Result = enumResult.ERR };
        string SS;
        System.Data.SqlClient.SqlCommand DBCmd;
        int RetValue = 0;

        if (CheckPassword(Password)) {

            SS = " UPDATE CompanyCategory WITH (ROWLOCK) SET State=@State " +
                      " WHERE CompanyCategoryID=@CompanyCategoryID";
            DBCmd = new System.Data.SqlClient.SqlCommand();
            DBCmd.CommandText = SS;
            DBCmd.CommandType = System.Data.CommandType.Text;
            DBCmd.Parameters.Add("@State", System.Data.SqlDbType.Int).Value = State;
            DBCmd.Parameters.Add("@CompanyCategoryID", System.Data.SqlDbType.Int).Value = CompanyCategoryID;
            RetValue = DBAccess.ExecuteDB(EWinWeb.DBConnStr, DBCmd);

            if (RetValue > 0) {
                RedisCache.CompanyCategory.UpdateCompanyCategory();
                R.Result = enumResult.OK;
            }
        } else {
            SetResultException(R, "InvalidPassword");
        }

        return R;
    }

    [WebMethod]
    public APIResult SetSevenDateBonusForConsole(string password) {
        APIResult R = new APIResult() { Result = enumResult.ERR };
        if (CheckPassword(password)) {
            EWin.OCW.OCW OCWAPI = new EWin.OCW.OCW();
            EWin.Lobby.LobbyAPI lobbyAPI = new EWin.Lobby.LobbyAPI();
            EWin.OCW.SeventDateBonusResult ret = new EWin.OCW.SeventDateBonusResult();
            EWin.Lobby.APIResult ret_AddPromotionCollect = new EWin.Lobby.APIResult();
            List<EWin.Lobby.PropertySet> PropertySets = new List<EWin.Lobby.PropertySet>();
            string description;
            string LoginAccount;
            string JoinActivityCycle;
            string PromotionCollectKey;
            string strReport;
            DateTime currentTime = DateTime.Now;
            DateTime start;
            DateTime end;
            decimal BonusValue = 0;
            decimal ThresholdValue = 0;
            decimal OneBonus = 1000;
            decimal AttendanceBonus = 3000;
            string PromotionCode = "";
            string PromotionCategoryCode = "";

            start = currentTime.AddDays(-7); //上禮拜5
            end = currentTime;

            JoinActivityCycle = start.ToString("yyyy/MM/dd") + "-" + end.ToString("yyyy/MM/dd");
            description = "Act003";
            PromotionCode = description;
            ret = OCWAPI.GetSummaryDateByDateForSeventDateBonus(GetToken(), start.ToString("yyyy/MM/dd"), end.ToString("yyyy/MM/dd"));

            if (ret.ResultState == EWin.OCW.enumResultState.OK) {
                foreach (var item in ret.SeventDateBonusList) {
                    BonusValue = 0;
                    if (item.Count > 0) {
                        PropertySets = new List<EWin.Lobby.PropertySet>();
                        ret_AddPromotionCollect = new EWin.Lobby.APIResult();
                        strReport = string.Empty;

                        LoginAccount = item.LoginAccount;
                        PromotionCollectKey = description + "_" + LoginAccount + "_" + start.ToString("yyyy/MM/dd") + "_" + end.ToString("yyyy/MM/dd");

                        BonusValue = item.Count * OneBonus;

                        if (item.Count == 7) {
                            BonusValue += AttendanceBonus;
                        }

                        ThresholdValue = BonusValue * 20;

                        PropertySets.Add(new EWin.Lobby.PropertySet { Name = "ThresholdValue", Value = ThresholdValue.ToString() });
                        PropertySets.Add(new EWin.Lobby.PropertySet { Name = "PointValue", Value = BonusValue.ToString() });

                        ret_AddPromotionCollect = lobbyAPI.AddPromotionCollect(GetToken(), PromotionCollectKey, LoginAccount, EWinWeb.MainCurrencyType, PromotionCode, PromotionCategoryCode, 2, 90, description, PropertySets.ToArray());

                        if (ret_AddPromotionCollect.Result == EWin.Lobby.enumResult.OK) {
                            R.Result = enumResult.OK;
                            strReport = "LoginAccount : " + LoginAccount + ",Action : AddPromotionCollect Succ \r\n";
                            ReportSystem.SevenDateBonusForConsole.CreateSevenDateBonusForConsoleHistory(currentTime.ToString("yyyy-MM-dd"), strReport);

                            EWinWebDB.UserAccountEventSummary.UpdateUserAccountEventSummary(LoginAccount, description, JoinActivityCycle, 1, ThresholdValue, BonusValue);
                        } else {
                            strReport = "LoginAccount : " + LoginAccount + ",Action : AddPromotionCollect Err, ErrMessage : " + ret_AddPromotionCollect.Message + " \r\n";
                            ReportSystem.SevenDateBonusForConsole.CreateSevenDateBonusForConsoleHistory(currentTime.ToString("yyyy-MM-dd"), strReport);
                        }

                    }
                }
            } else {
                strReport = "Action : GetSummaryDateByDateForSeventDateBonus Err, ErrMessage : " + ret.Message + " \r\n";
                ReportSystem.SevenDateBonusForConsole.CreateSevenDateBonusForConsoleHistory(currentTime.ToString("yyyy-MM-dd"), strReport);
            }

        } else {
            SetResultException(R, "InvalidPassword");
        }

        return R;

    }

    [WebMethod]
    public void AddUserAccountPromotionCollect(string password, string LoginAccount, string ThresholdValue, string BonusValue, string ActivityName, int CollectAreaType) {

        //if (CheckPassword(password)) {
        EWin.Lobby.LobbyAPI lobbyAPI = new EWin.Lobby.LobbyAPI();
        List<EWin.Lobby.PropertySet> PropertySets = new List<EWin.Lobby.PropertySet>();
        string description = ActivityName;
        string GUID = System.Guid.NewGuid().ToString();
        string PromotionCode = description;
        string PromotionCategoryCode = "";

        PropertySets.Add(new EWin.Lobby.PropertySet { Name = "ThresholdValue", Value = ThresholdValue.ToString() });
        PropertySets.Add(new EWin.Lobby.PropertySet { Name = "PointValue", Value = BonusValue.ToString() });

        lobbyAPI.AddPromotionCollect(GetToken(), GUID, LoginAccount, EWinWeb.MainCurrencyType, PromotionCode, PromotionCategoryCode, CollectAreaType, 90, description, PropertySets.ToArray());
        //EWinWebDB.UserAccountEventSummary.UpdateUserAccountEventSummary(LoginAccount, description, 1, decimal.Parse(ThresholdValue), decimal.Parse(BonusValue));
        //}
    }

    public string GetToken() {
        string Token;
        int RValue;
        Random R = new Random();
        RValue = R.Next(100000, 9999999);
        Token = EWinWeb.CreateToken(EWinWeb.PrivateKey, EWinWeb.APIKey, RValue.ToString());

        return Token;
    }

    //[WebMethod]
    //public void SendMail() {
    //    //string Subject = string.Empty;
    //    //string SendBody = string.Empty;
    //    //string EMail = string.Empty;
    //    //var f = "['oidon.s+maharaja@gmail.com','renya1979@icloud.com','mammothkoh3zoh3@yahoo.co.jp','grow7002@gmail.com','o8026370695@gmail.com','usako.to.chibiusa.2@gmail.com','shimiyan84@gmail.com','shinkigyo@gmail.com','yomachi8810@gmail.com','nana.yo.0909@gmail.com','catmineko@gmail.com','taira4119a@gmail.com','volvo.960.1981@gmail.com','sakayumi2014@gmail.com','nsys81118@gmail.com','ma9satoru25ko@gmail.com','kuniaki.tsukamoto.0107@gmail.com','hana.3.3@icloud.com','wsr.goto@gmail.com','makuri3713@gmail.com','emi_miyakita@yahoo.co.jp','youko1212tide526@gmail.com','t.t.toshiki@gmail.com','kayoko1904@icloud.com','panorama.19791115@gmail.com','Kurumaya.hisa@gmail.com','tomo16yuka24@gmail.com','dasmarudas@gmail.com','junko51716@gmail.com','trust.358@water.ocn.ne.jp','yaeko847@gmail.com','michiko.hana.2615@gmail.com','kaitai7647@gmail.com','a9725051@gmail.com','xingyilangguao@gmail.com','hibiki20020117@au.com','ehp55te@yahoo.co.jp','yasu-abu9@docomo.ne.jp','fumie.ema@gmail.com','good6700jp@gmail.com','Wakka0902@yahoo.co.jp','s-_-t.2003-1214@docomo.ne.jp','oi.michie@icloud.com','soratsuba.11@gmal.com','usuk.0830.mycn18@gmail.com','marrrrbe@yahoo.co.jp','enjya.sy@gmail.com','qcktj741@gmail.com','etarnity3450ctm@gmail.com','kaori4901@outlook.jp','corp.jandj3588@gmail.com','civic5557788@gmail.com','yujipost@gmail.com','manataro.0208@gmail.com','mior.vkmz@gmail.com','q9epade5u10j7an6qvz0@docomo.ne.jp','tkurodamail@gmail.com','yuuji.37.16@gmail.com','yuuji.37.16+3@gmail.com','atsumouri0303@gmail.com','mikiyuki.1234.mikiyuki@gmail.com','maeda4837@au.com','kaizinnopera@gmail.com','jeffmasutaka@gmail.com','tatsuo1234515@gmail.com','Erictse44@gmail.com','zard111jp@gmail.com','sumibi410@gmail.com','take.take.sasaki10@gmail.com','takkumi333@icloud.com','irifune1950m@gmail.com','cockroach0723@gmail.com','jun71106.21@gmail.com','fuji2811k@gmail.com','rabuyuma@gmail.com','tamariba.mochiken@gmail.com','nasu.oneoff@gmail.com','navy511058@gmail.com','luna_uf@yahoo.co.jp','katsuya0319@icloud.com','mba.realization2020@gmail.com','aigold.8376@gmail.com','mineko.3166@gmail.com','akimichu1005@yahoo.co.jp','asa1127@me.com','otsuka@akimitsu.tokyo','bangkok9z.pc@gmail.com','kyasarin20160411@gmail.com','yu.ryo.mo@icioud.com','mizuharu.8282@gmail.com','luxurious.cat@gmail.com','Harufu7788@gmail.com','risette.no2@gmail.com','t.marimari0321@gmail.com','sakamaki0130@gmail.com','Seitatakuya@gmail.com','shuji5hama@gmail.com','akamine888@gmail.com','yamaha-hatsujo-ki.4d9@i.softbank.jp','nongsnk81@gmail.com','yasuhiro.tamatsu@ezweb.ne.jp','ksoda.mobile@gmail.com','kazukino.adoresu@i.softbank.jp','soratsuba.11@gmail.com','bigtreeokinawa@gmail.com','noboru.1323@gmail.com','kimiko126ja@gmail.com','hiron.f3810@gmail.com','hirokazu.nakanishi@gmail.com','hamamatsu.aikido@gmail.com','yamamotoseitai@gmail.com','kakkonntou_nomisugi@yahoo.co.jp','fivefourkato@gmail.com','uchihiko48@gmail.com','termkh1874@gmail.com','goldjackal777@gmail.com','queenkellys8448@gmail.com','0825tomiko@gmail.com','sgr-s11g88@i.softbank.jp','kuritaku.tigers.4123@gmail.com','moppy77777@gmail.com','h4506h0423@gmail.com','ryou1213@yahoo.com','nagaoka.t1169@gmail.com','imc88@dolphin.ocn.ne.jp','service@99play.com','handmade_rin1977@yahoo.co.jp','yuyamam31@gmail.com','ian@kingkey.com.tw','koala19580928@gmail.com','sky3100604@gmail.com','enh6nsa6pm@i.softbank.jp','y.s-todo1.12@i.softbank.jp','ichita724@gmail.com','syan88@hotmail.co.jp','astus391@gmail.com','rsimacddmi@yahoo.co.jp','ganesha.ayur@gmail.com','nobu49774977@gmail.com','superogihara@yahoo.co.jp','p.man8p.man8@icloud.com','kumstaka@gmail.com','Zhengxingbaomu77@gmail.com','jdabc-destiny7@ezweb.ne.jp','kazukoku0@gmail.com','yoshiko@fushiki-arch.jp','hatsumi0011@i.softbank.jp','shunpei.yaguchi0326@gmail.com','qq3682sd@yahoo.co.jp','eikou1236@gmail.com','1703.1214.akr47@gmail.com','yunamaeda@gmail.com','0406yamamoto@mtc.biglobe.ne.jp','michikomining622@gmail.com','kazuie6677suzuki@gmail.com','youis5720@gmail.com','aikoinagaki1899@gmail.com','saitou19700929@gmail.com','ichikawa296@gmail.com','exile610@icloud.com','case4418@gmail.com','mimori_japan@yahoo.co.jp','nishigaki@global-invest.jp','toshiko10450921@gmail.com','n7321ri@gmail.com','toshie2741@gmail.com','rurumeru1102@gmail.com','n.sho19920523@gmail.com','yo.zi.0201@gmail.com','watagumomura15@gmail.com','miyaoka.8879@gmail.com','rinns1990@gmail.com','souwa.shimizu.kazutaka@gmail.com','krgn000@gmail.com','ko.ko1127@icloud.com','kimiyama72@gmail.com','shion.omijya@gmail.com','sin509a@gmail.com','odaiba0825@gmail.com','hiro2sweet2@gmail.com','skks.rh@gmail.com','o8019047617@gmail.com','superbookers@gmail.com','y.takeya0506@gmail.com','harada@dorisapo.jp','kekusafe-amam@yahoo.co.jp','mizukei1201@icloud.com','toriton0714@softbank.ne.jp','laetitia21shanke@gmail.com','ktu56tkhr@gmail.com','kanarie7@yahoo.co.jp','highaverage5@gmail.com','kojikibi2@yahoo.co.jp','husark@nifty.com','kazumasakagawa@gmail.com','an0825m@gmail.com','tiphareth2020@gmail.com','shigekatsu2038@gmail.com','ai.h.k314@gmail.com','momo-ryu-ura@simaenaga.com','atlifekochi@yahoo.co.jp','masa05221001@gmail.com','reichan1717.0717@gmail.com','Yo.chi.shyu.mama1109@gmail.com','nagatonoken@yahoo.co.jp','takemoto12201220@gmail.com','yu.haya.19982001@icloud.com','canzunori@gmail.com','fujinomiya.kobayashi@docomo.ne.jp','sachi-0416@docomo.ne.jp','subciety5@ezweb.ne.jp','akito1abcde1@gmail.com','bit.premium2020@gmail.com','tsuyoshi.k.hamamatsu@docomo.ne.jp','kozman2372@gmail.com','yuji0914gs@yahoo.co.jp','nobu461@gmail.com','mediagive@gaia.eonet.ne.jp','ishii@erwzs.com','gotojun2365@yahoo.co.jp','kimodo@i.softbank.jp','lovesan358@gmail.com','beatnikalk@icloud.com','taka.achan5@gmail.com','wind8tao@gmail.com','ken-zi428@docomo.ne.jp','satellite696@gmail.com','daisuke2804@gmail.com','fujimailaddress@yahoo.co.jp','tamtam10jp@yahoo.co.jp','m.sakaguchi@hotmail.co.jp','iwakumajj505050@gmail.com','info@qolmedia.online','tynoyk57@gmail.com','info@meike-home.com','pcdos2006@gmail.com','mizuhiro68@gmail.com','shinobu125125@gmail.com','hidekazuhata@gmail.com','gin43166@gmail.com','murofushi1124@docomo.ne.jp','kusunoki626@gmail.com','essencefimin@gmail.com','matsumura.9614@gmail.com','akemi.sumita@icloud.com','bunta0929ah@gmail.com','naokisonic85@gmail.com','test0328@gmail.com','Test5678@gmail.com','yachie1997@icloud.com','kabukimono_info@yahoo.co.jp','eve441211@gmail.com','livmitueasanosanpo@docomo.ne.jp','aoboshi32@gmail.com','rira3588@gmail.com','hikaru.wkym@gmail.com','xmasakix0001@icloud.com','pl.gakuen.60@gmail.com','yuchaco88628@i.softbank.jp','akirada0126@gamil.com','kimi0520.kimi@gmail.com','yellowsun0582@gmail.com','soulmate.marian@gmail.com']";
    //    //Newtonsoft.Json.Linq.JArray gg = Newtonsoft.Json.Linq.JArray.Parse(f);
    //    //SendBody = CodingControl.GetEmailTemp1();
    //    //Subject = "カジノマハラジャ、プレオープンから 4週間での衝撃発表!!!!";

    //    //for (int i = 0; i < gg.Count; i++) {
    //    //    EMail = (string)gg[i];
    //    //    SendMail(EMail, "1234", CodingControl.enumSendMailType.Register);
    //    //}

    //    for (int i = 0; i < 1000; i++) {
    //        SendMail("kevin@kingkey.com.tw", "1234", CodingControl.enumSendMailType.Register);
    //    }
    //}

    [WebMethod]
    public void SendMail(string EMail, string Subject) {
        if (!string.IsNullOrEmpty(EMail)) {
            string SendBody = string.Empty;
            string apiURL = "https://mail.surenotifyapi.com/v1/messages";
            string apiKey = "NDAyODgxNDM4MGJiZTViMjAxODBkYjZjMmRjYzA3NDgtMTY1NDE0Mzc1NC0x";

            SendBody = CodingControl.GetEmailTemp2();

            Newtonsoft.Json.Linq.JObject objBody = new Newtonsoft.Json.Linq.JObject();
            Newtonsoft.Json.Linq.JObject objRecipients = new Newtonsoft.Json.Linq.JObject();
            Newtonsoft.Json.Linq.JObject objVariables = new Newtonsoft.Json.Linq.JObject();
            Newtonsoft.Json.Linq.JArray aryRecipients = new Newtonsoft.Json.Linq.JArray();

            objBody.Add("subject", Subject);
            objBody.Add("fromName", "マハラジャ");
            objBody.Add("fromAddress", "edm@casino-maharaja.com");
            objBody.Add("content", SendBody);

            objRecipients.Add("name", EMail);
            objRecipients.Add("address", EMail);
            aryRecipients.Add(objRecipients);

            objBody.Add("recipients", aryRecipients);

            CodingControl.GetWebTextContent(apiURL, "POST", objBody.ToString(), "x-api-key:" + apiKey, "application/json", System.Text.Encoding.UTF8);
        }
    }

    [WebMethod]
    public void SendMailMult(string JsonStrEmail, string Subject) {
        if (!string.IsNullOrEmpty(JsonStrEmail)) {
            string SendBody = string.Empty;
            string apiURL = "https://mail.surenotifyapi.com/v1/messages";
            string apiKey = "NDAyODgxNDM4MGJiZTViMjAxODBkYjZjMmRjYzA3NDgtMTY1NDE0Mzc1NC0x";

            SendBody = CodingControl.GetEmailTemp2();

            Newtonsoft.Json.Linq.JObject objBody = new Newtonsoft.Json.Linq.JObject();
            Newtonsoft.Json.Linq.JObject objRecipients = new Newtonsoft.Json.Linq.JObject();
            Newtonsoft.Json.Linq.JObject objVariables = new Newtonsoft.Json.Linq.JObject();
            Newtonsoft.Json.Linq.JArray aryRecipients = new Newtonsoft.Json.Linq.JArray();

            objBody.Add("subject", Subject);
            objBody.Add("fromName", "マハラジャ");
            objBody.Add("fromAddress", "edm@casino-maharaja.com");
            objBody.Add("content", SendBody);

            //var f = "['kevin@kingkey.com.tw','tony800517@hotmail.com']";
            var f = JsonStrEmail;
            Newtonsoft.Json.Linq.JArray gg = Newtonsoft.Json.Linq.JArray.Parse(f);

            for (int i = 0; i < gg.Count; i++) {
                objRecipients = new Newtonsoft.Json.Linq.JObject();
                //objVariables = new Newtonsoft.Json.Linq.JObject();

                objRecipients.Add("name", (string)gg[i]);
                objRecipients.Add("address", (string)gg[i]);
                //寄信範本中使用 {{account}}，下列方式可在範本中做替換
                //objVariables.Add("account", (string)gg[i]);
                //objRecipients.Add("variables", objVariables);

                aryRecipients.Add(objRecipients);
            }

            objBody.Add("recipients", aryRecipients);

            CodingControl.GetWebTextContent(apiURL, "POST", objBody.ToString(), "x-api-key:" + apiKey, "application/json", System.Text.Encoding.UTF8);
        }
    }

    private bool CheckPassword(string Hash) {
        string key = EWinWeb.PrivateKey;

        bool Ret = false;
        int index = Hash.IndexOf('_');
        string tempStr1 = Hash.Substring(0, index);
        string tempStr2 = Hash.Substring(index + 1);
        string checkHash = "";
        DateTime CreateTime;
        DateTime TargetTime;
        if (index > 0) {
            if (DateTime.TryParse(tempStr1, out CreateTime)) {
                if (CreateTime.AddMinutes(15) >= DateTime.Now.AddSeconds(1)) {
                    TargetTime = RoundUp(CreateTime, TimeSpan.FromMinutes(15));
                    checkHash = CodingControl.GetMD5(TargetTime.ToString("yyyy/MM/dd HH:mm:ss") + key, false).ToLower();
                    if (checkHash.ToLower() == tempStr2) {
                        Ret = true;
                    }
                }
            }
        }

        return Ret;

    }

    private static JObject GetActivityDetail(string Path) {
        JObject o = null;
        string Filename;

        Filename = HttpContext.Current.Server.MapPath(Path);

        if (System.IO.File.Exists(Filename)) {
            string SettingContent;

            SettingContent = System.IO.File.ReadAllText(Filename);

            if (string.IsNullOrEmpty(SettingContent) == false) {
                try { o = JObject.Parse(SettingContent); } catch (Exception ex) { }
            }
        }

        return o;
    }

    private DateTime RoundUp(DateTime dt, TimeSpan d) {
        return new DateTime((dt.Ticks + d.Ticks - 1) / d.Ticks * d.Ticks, dt.Kind);
    }

    private void SetResultException(APIResult R, string Msg) {
        if (R != null) {
            R.Result = enumResult.ERR;
            R.Message = Msg;
        }
    }

    static System.Collections.ArrayList iSyncRoot = new System.Collections.ArrayList();
    private static void WriteAllText(string Filename, string Content) {
        byte[] ContentArray = System.Text.Encoding.UTF8.GetBytes(Content);
        Exception throwEx = null;

        for (var i = 0; i < 3; i++) {
            lock (iSyncRoot) {
                try {
                    System.IO.File.WriteAllText(Filename, Content);
                    throwEx = null;
                    break;
                } catch (Exception ex) {
                    throwEx = ex;
                }
            }

            System.Threading.Thread.Sleep(100);
        }

        if (throwEx != null)
            throw new Exception(throwEx.ToString() + "\r\n" + "  Filename:" + Filename);
    }

    public class APIResult {
        public enumResult Result { get; set; }
        public string GUID { get; set; }
        public string Message { get; set; }
    }

    public enum enumResult {
        OK = 0,
        ERR = 1
    }

    public class PaymentValueReslut : APIResult {
        public string LoginAccount { get; set; }
        public string PaymentCode { get; set; }
        public string PaymentSerial { get; set; }
        public decimal Amount { get; set; }
        public decimal TotalPointValue { get; set; }
        public decimal TotalThresholdValue { get; set; }
        public List<string> ActivityDescription { get; set; }
        public string PaymentDescription { get; set; }
    }

    public class UserAccountSummaryResult : APIResult {
        public string SummaryGUID { get; set; }
        public DateTime SummaryDate { get; set; }
        public string LoginAccount { get; set; }
        public int DepositCount { get; set; }
        public decimal DepositRealAmount { get; set; }
        public decimal DepositAmount { get; set; }
        public int WithdrawalCount { get; set; }
        public decimal WithdrawalRealAmount { get; set; }
        public decimal WithdrawalAmount { get; set; }
    }

    public class UserAccountTotalSummaryResult : APIResult {
        public string LoginAccount { get; set; }
        public int DepositCount { get; set; }
        public decimal DepositRealAmount { get; set; }
        public decimal DepositAmount { get; set; }
        public int WithdrawalCount { get; set; }
        public decimal WithdrawalRealAmount { get; set; }
        public decimal WithdrawalAmount { get; set; }
        public DateTime LastDepositDate { get; set; }
        public DateTime LastWithdrawalDate { get; set; }
        public string FingerPrint { get; set; }
    }

    public class BulletinBoardResult : APIResult {
        public int BulletinBoardID { get; set; }
        public string BulletinTitle { get; set; }
        public string BulletinContent { get; set; }
        public DateTime CreateDate { get; set; }
        public int State { get; set; }

    }

    public class CompanyCategoryResult : APIResult {
        public int CompanyCategoryID { get; set; }
        public int CategoryType { get; set; }
        public string CategoryName { get; set; }
        public int SortIndex { get; set; }
        public int State { get; set; }
    }

    public class UserLevelUpgradeTempData {
        public int NewLevelIndex { get; set; }
        public decimal DepositMinValue { get; set; }
        public decimal ValidBetMinValue { get; set; }
    }
}