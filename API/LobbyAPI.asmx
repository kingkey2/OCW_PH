<%@ WebService Language="C#" Class="LobbyAPI" %>

using System;
using System.Web;
using System.Web.Services;
using System.Web.Services.Protocols;
using System.Collections;
using System.Collections.Generic;
using System.Web.Script.Services;
using System.Web.Script.Serialization;
using System.Linq;

[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// 若要允許使用 ASP.NET AJAX 從指令碼呼叫此 Web 服務，請取消註解下列一行。
// [System.Web.Script.Services.ScriptService]
[System.ComponentModel.ToolboxItem(false)]
[System.Web.Script.Services.ScriptService]
public class LobbyAPI : System.Web.Services.WebService {



    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public EWin.Lobby.APIResult HeartBeat(string GUID, string Echo) {
        EWin.Lobby.LobbyAPI lobbyAPI = new EWin.Lobby.LobbyAPI();
        //TEST
        return lobbyAPI.HeartBeat(GUID, Echo);
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public EWin.Lobby.APIResult AddUserBankCard(string WebSID, string GUID, string CurrencyType, int PaymentMethod, string BankName, string BranchName, string BankNumber, string AccountName, string BankProvince, string BankCity, string Description) {
        EWin.Lobby.LobbyAPI lobbyAPI = new EWin.Lobby.LobbyAPI();
        RedisCache.SessionContext.SIDInfo SI;

        SI = RedisCache.SessionContext.GetSIDInfo(WebSID);

        if (SI != null && !string.IsNullOrEmpty(SI.EWinSID)) {
            return lobbyAPI.AddUserBankCard(GetToken(), SI.EWinSID, GUID, CurrencyType, PaymentMethod, BankName, BranchName, BankNumber, AccountName, BankProvince, BankCity, Description);
        } else {
            var R = new EWin.Lobby.APIResult() {
                Result = EWin.Lobby.enumResult.ERR,
                Message = "InvalidWebSID",
                GUID = GUID
            };

            return R;
        }
    }


    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public EWin.Lobby.APIResult SetUserBankCardState(string WebSID, string GUID, string BankCardGUID, int BankCardState) {
        EWin.Lobby.LobbyAPI lobbyAPI = new EWin.Lobby.LobbyAPI();
        RedisCache.SessionContext.SIDInfo SI;

        SI = RedisCache.SessionContext.GetSIDInfo(WebSID);

        if (SI != null && !string.IsNullOrEmpty(SI.EWinSID)) {
            return lobbyAPI.SetUserBankCardState(GetToken(), SI.EWinSID, GUID, BankCardGUID, BankCardState);
        } else {
            var R = new EWin.Lobby.APIResult() {
                Result = EWin.Lobby.enumResult.ERR,
                Message = "InvalidWebSID",
                GUID = GUID
            };

            return R;
        }
    }


    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public EWin.Lobby.APIResult UserAccountTransfer(string WebSID, string GUID, string DstLoginAccount, string DstCurrencyType, string SrcCurrencyType, decimal TransOutValue, string WalletPassword, string Description) {
        EWin.Lobby.LobbyAPI lobbyAPI = new EWin.Lobby.LobbyAPI();
        RedisCache.SessionContext.SIDInfo SI;

        SI = RedisCache.SessionContext.GetSIDInfo(WebSID);

        if (SI != null && !string.IsNullOrEmpty(SI.EWinSID)) {
            return lobbyAPI.UserAccountTransfer(GetToken(), SI.EWinSID, GUID, DstLoginAccount, DstCurrencyType, SrcCurrencyType, TransOutValue, WalletPassword, Description);
        } else {
            var R = new EWin.Lobby.APIResult() {
                Result = EWin.Lobby.enumResult.ERR,
                Message = "InvalidWebSID",
                GUID = GUID
            };

            return R;
        }
    }


    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public EWin.Lobby.APIResult ConfirmUserAccountTransfer(string WebSID, string GUID, string TransferGUID) {
        EWin.Lobby.LobbyAPI lobbyAPI = new EWin.Lobby.LobbyAPI();
        RedisCache.SessionContext.SIDInfo SI;

        SI = RedisCache.SessionContext.GetSIDInfo(WebSID);

        if (SI != null && !string.IsNullOrEmpty(SI.EWinSID)) {
            return lobbyAPI.ConfirmUserAccountTransfer(GetToken(), SI.EWinSID, GUID, TransferGUID);
        } else {
            var R = new EWin.Lobby.APIResult() {
                Result = EWin.Lobby.enumResult.ERR,
                Message = "InvalidWebSID",
                GUID = GUID
            };

            return R;
        }
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public EWin.Lobby.TransferHistoryResult GetTransferHistory(string WebSID, string GUID, string BeginDate, string EndDate) {
        EWin.Lobby.LobbyAPI lobbyAPI = new EWin.Lobby.LobbyAPI();
        RedisCache.SessionContext.SIDInfo SI;

        SI = RedisCache.SessionContext.GetSIDInfo(WebSID);

        if (SI != null && !string.IsNullOrEmpty(SI.EWinSID)) {
            return lobbyAPI.GetTransferHistory(GetToken(), SI.EWinSID, GUID, BeginDate, EndDate);
        } else {
            var R = new EWin.Lobby.TransferHistoryResult() {
                Result = EWin.Lobby.enumResult.ERR,
                Message = "InvalidWebSID",
                GUID = GUID
            };

            return R;
        }
    }


    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public EWin.Lobby.UserAccountPropertyResult GetUserAccountProperty(string WebSID, string GUID, string PropertyName) {
        EWin.Lobby.LobbyAPI lobbyAPI = new EWin.Lobby.LobbyAPI();
        RedisCache.SessionContext.SIDInfo SI;

        SI = RedisCache.SessionContext.GetSIDInfo(WebSID);

        if (SI != null && !string.IsNullOrEmpty(SI.EWinSID)) {
            return lobbyAPI.GetUserAccountProperty(GetToken(),GUID, EWin.Lobby.enumUserTypeParam.BySID,SI.EWinSID,PropertyName);
        } else {
            var R = new EWin.Lobby.UserAccountPropertyResult() {
                Result = EWin.Lobby.enumResult.ERR,
                Message = "InvalidWebSID",
                GUID = GUID
            };

            return R;
        }
    }


    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public EWin.Lobby.GameCodeOnlineListResult GetUserAccountGameCodeOnlineList(string WebSID, string GUID) {
        EWin.Lobby.LobbyAPI lobbyAPI = new EWin.Lobby.LobbyAPI();
        RedisCache.SessionContext.SIDInfo SI;
        EWin.Lobby.GameCodeOnlineListResult Result;
        SI = RedisCache.SessionContext.GetSIDInfo(WebSID);

        if (SI != null && !string.IsNullOrEmpty(SI.EWinSID)) {
            Result= lobbyAPI.GetUserAccountGameCodeOnlineList(GetToken(),SI.EWinSID,GUID);
            Result.Message = SI.EWinSID;
            return Result;
        } else {
            var R = new EWin.Lobby.GameCodeOnlineListResult() {
                Result = EWin.Lobby.enumResult.ERR,
                Message = "InvalidWebSID",
                GUID = GUID
            };

            return R;
        }
    }


    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public EWin.Lobby.APIResult SetUserAccountProperty(string WebSID, string GUID, string PropertyName,string PropertyValue) {
        EWin.Lobby.LobbyAPI lobbyAPI = new EWin.Lobby.LobbyAPI();
        RedisCache.SessionContext.SIDInfo SI;

        SI = RedisCache.SessionContext.GetSIDInfo(WebSID);

        if (SI != null && !string.IsNullOrEmpty(SI.EWinSID)) {
            return lobbyAPI.SetUserAccountProperty(GetToken(),GUID, EWin.Lobby.enumUserTypeParam.BySID,SI.EWinSID,PropertyName,PropertyValue);
        } else {
            var R = new EWin.Lobby.APIResult() {
                Result = EWin.Lobby.enumResult.ERR,
                Message = "InvalidWebSID",
                GUID = GUID
            };

            return R;
        }
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public EWin.Lobby.APIResult RemoveUserBankCard(string WebSID, string GUID, string BankCardGUID) {
        EWin.Lobby.LobbyAPI lobbyAPI = new EWin.Lobby.LobbyAPI();
        RedisCache.SessionContext.SIDInfo SI;

        SI = RedisCache.SessionContext.GetSIDInfo(WebSID);

        if (SI != null && !string.IsNullOrEmpty(SI.EWinSID)) {
            return lobbyAPI.RemoveUserBankCard(GetToken(), SI.EWinSID, GUID, BankCardGUID);
        } else {
            var R = new EWin.Lobby.APIResult() {
                Result = EWin.Lobby.enumResult.ERR,
                Message = "InvalidWebSID",
                GUID = GUID
            };

            return R;
        }
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public EWin.Lobby.APIResult UpdateUserBankCard(string WebSID, string GUID, string BankCardGUID, string CurrencyType, int PaymentMethod, string BankName, string BranchName, string BankNumber, string AccountName, string BankProvince, string BankCity, string Description) {
        EWin.Lobby.LobbyAPI lobbyAPI = new EWin.Lobby.LobbyAPI();
        RedisCache.SessionContext.SIDInfo SI;

        SI = RedisCache.SessionContext.GetSIDInfo(WebSID);

        if (SI != null && !string.IsNullOrEmpty(SI.EWinSID)) {
            return lobbyAPI.UpdateUserBankCard(GetToken(), SI.EWinSID, GUID, BankCardGUID, CurrencyType, PaymentMethod, BankName, BranchName, BankNumber, AccountName, BankProvince, BankCity, Description);
        } else {
            var R = new EWin.Lobby.APIResult() {
                Result = EWin.Lobby.enumResult.ERR,
                Message = "InvalidWebSID",
                GUID = GUID
            };

            return R;
        }
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public EWin.Lobby.UserBankCardListResult GetUserBankCard(string WebSID, string GUID) {
        EWin.Lobby.LobbyAPI lobbyAPI = new EWin.Lobby.LobbyAPI();
        RedisCache.SessionContext.SIDInfo SI;

        SI = RedisCache.SessionContext.GetSIDInfo(WebSID);

        if (SI != null && !string.IsNullOrEmpty(SI.EWinSID)) {
            return lobbyAPI.GetUserBankCard(GetToken(), SI.EWinSID, GUID);
        } else {
            var R = new EWin.Lobby.UserBankCardListResult() {
                Result = EWin.Lobby.enumResult.ERR,
                Message = "InvalidWebSID",
                GUID = GUID
            };

            return R;
        }
    }


    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public UserAccountEventSummaryResult GetUserAccountEventSummary(string WebSID, string GUID) {
        UserAccountEventSummaryResult R = new UserAccountEventSummaryResult() { Result = EWin.Lobby.enumResult.ERR };
        List<UserAccountEventSummary> Datas = new List<UserAccountEventSummary>();
        RedisCache.SessionContext.SIDInfo SI;
        System.Data.DataTable DT;
        SI = RedisCache.SessionContext.GetSIDInfo(WebSID);

        if (SI != null && !string.IsNullOrEmpty(SI.EWinSID)) {
            DT = RedisCache.UserAccountEventSummary.GetUserAccountEventSummaryByLoginAccount(SI.LoginAccount);
            if (DT != null && DT.Rows.Count > 0) {
                for (int i = 0; i < DT.Rows.Count; i++) {
                    var Data = new UserAccountEventSummary();
                    Data.ActivityName = (string)DT.Rows[i]["ActivityName"];
                    Data.BonusValue = (decimal)DT.Rows[i]["BonusValue"];
                    Data.CollectCount = (int)DT.Rows[i]["CollectCount"];
                    Data.JoinCount = (int)DT.Rows[i]["JoinCount"];
                    Data.LoginAccount = (string)DT.Rows[i]["LoginAccount"];
                    Data.ThresholdValue = (decimal)DT.Rows[i]["ThresholdValue"];
                    Datas.Add(Data);

                }
                R.Datas = Datas;
                R.Result = EWin.Lobby.enumResult.OK;
            }
        }
        return R;
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public EWin.Lobby.APIResult GetSIDParam(string WebSID, string GUID, string ParamName) {
        EWin.Lobby.LobbyAPI lobbyAPI = new EWin.Lobby.LobbyAPI();
        RedisCache.SessionContext.SIDInfo SI;

        SI = RedisCache.SessionContext.GetSIDInfo(WebSID);

        if (SI != null && !string.IsNullOrEmpty(SI.EWinSID)) {
            return lobbyAPI.GetSIDParam(GetToken(), SI.EWinSID, GUID, ParamName);
        } else {
            var R = new EWin.Lobby.APIResult() {
                Result = EWin.Lobby.enumResult.ERR,
                Message = "InvalidWebSID",
                GUID = GUID
            };
            return R;
        }
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public EWin.Lobby.APIResult SetSIDParam(string WebSID, string GUID, string ParamName, string ParamValue) {
        EWin.Lobby.LobbyAPI lobbyAPI = new EWin.Lobby.LobbyAPI();
        RedisCache.SessionContext.SIDInfo SI;

        SI = RedisCache.SessionContext.GetSIDInfo(WebSID);

        if (SI != null && !string.IsNullOrEmpty(SI.EWinSID)) {
            return lobbyAPI.SetSIDParam(GetToken(), SI.EWinSID, GUID, ParamName, ParamValue);
        } else {
            var R = new EWin.Lobby.APIResult() {
                Result = EWin.Lobby.enumResult.ERR,
                Message = "InvalidWebSID",
                GUID = GUID
            };
            return R;
        }
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public EWin.Lobby.APIResult KeepSID(string WebSID, string GUID) {
        EWin.Lobby.LobbyAPI lobbyAPI = new EWin.Lobby.LobbyAPI();
        EWin.Lobby.APIResult lobbyAPI_ret = new EWin.Lobby.APIResult();
        EWin.Lobby.APIResult R = new EWin.Lobby.APIResult();
        RedisCache.SessionContext.SIDInfo SI;

        SI = RedisCache.SessionContext.GetSIDInfo(WebSID);

        if (SI != null && !string.IsNullOrEmpty(SI.EWinSID)) {
            lobbyAPI_ret = lobbyAPI.KeepSID(GetToken(), SI.EWinSID, GUID);

            if (lobbyAPI_ret.Result == EWin.Lobby.enumResult.OK) {
                if (RedisCache.SessionContext.RefreshSID(WebSID) == true) {
                    R.Result = EWin.Lobby.enumResult.OK;
                } else {
                    R.Result = EWin.Lobby.enumResult.ERR;
                    R.Message = "InvalidWebSID";
                    R.GUID = GUID;
                }
            } else {
                RedisCache.SessionContext.ExpireSID(WebSID);

                R.Result = EWin.Lobby.enumResult.ERR;
                R.Message = "InvalidWebSID";
                R.GUID = GUID;
            }
        } else {
            R.Result = EWin.Lobby.enumResult.ERR;
            R.Message = "InvalidWebSID";
            R.GUID = GUID;
        }

        return R;
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public EWin.Lobby.APIResult CheckAccountExist(string GUID, string LoginAccount) {
        EWin.Lobby.LobbyAPI lobbyAPI = new EWin.Lobby.LobbyAPI();
        return lobbyAPI.CheckAccountExist(GetToken(), GUID, LoginAccount);
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public EWin.Lobby.APIResult CheckAccountExistEx(string GUID, string LoginAccount, string PhonePrefix, string PhoneNumber, string EMail) {
        EWin.Lobby.LobbyAPI lobbyAPI = new EWin.Lobby.LobbyAPI();
        var a = GetToken();
        return lobbyAPI.CheckAccountExistEx(GetToken(), GUID, LoginAccount, PhonePrefix, PhoneNumber, EMail);
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public EWin.Lobby.APIResult CheckAccountExistByContactPhoneNumber(string GUID, string PhonePrefix, string PhoneNumber) {
        EWin.Lobby.LobbyAPI lobbyAPI = new EWin.Lobby.LobbyAPI();
        return lobbyAPI.CheckAccountExistByContactPhoneNumber(GetToken(), GUID, PhonePrefix, PhoneNumber);
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public EWin.Lobby.APIResult RequireRegister(string GUID, string ParentPersonCode, EWin.Lobby.PropertySet[] PS, EWin.Lobby.UserBankCard[] UBC) {
        EWin.Lobby.LobbyAPI lobbyAPI = new EWin.Lobby.LobbyAPI();
        return lobbyAPI.RequireRegister(GetToken(), GUID, ParentPersonCode, PS, UBC);
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public EWin.Lobby.APIResult CreateAccount(string GUID, string LoginAccount, string LoginPassword, string ParentPersonCode, string CurrencyList, EWin.Lobby.PropertySet[] PS) {
        EWin.Lobby.LobbyAPI lobbyAPI = new EWin.Lobby.LobbyAPI();
        EWin.OCW.OCW ocwAPI = new EWin.OCW.OCW();
        EWin.Lobby.APIResult R = new EWin.Lobby.APIResult();
        EWin.OCW.ParentUserAccountInfoResult Parent = new EWin.OCW.ParentUserAccountInfoResult();
        System.Data.DataTable DT = null;
        string ParentLoginAccount = string.Empty;
        string CollectAreaType;

        R = lobbyAPI.CreateAccount(GetToken(), GUID, LoginAccount, LoginPassword, ParentPersonCode, CurrencyList, PS);

        if (R.Result == EWin.Lobby.enumResult.OK) {
            //建立會員等級資料
            EWinWebDB.UserAccountLevel.InsertUserAccountLevel(0, LoginAccount, DateTime.Now.ToString("yyyy/MM/dd"));

            var GetRegisterResult = ActivityCore.GetRegisterResult(LoginAccount);

            if (GetRegisterResult.Result == ActivityCore.enumActResult.OK) {
                List<EWin.Lobby.PropertySet> PropertySets = new List<EWin.Lobby.PropertySet>();
                foreach (var activityData in GetRegisterResult.Data) {

                    string description = activityData.ActivityName;
                    string JoinActivityCycle = activityData.JoinActivityCycle == null ? "1" : activityData.JoinActivityCycle;
                    CollectAreaType = activityData.CollectAreaType == null ? "2" : activityData.CollectAreaType;

                    PropertySets.Add(new EWin.Lobby.PropertySet { Name = "ThresholdValue", Value = activityData.ThresholdValue.ToString() });
                    PropertySets.Add(new EWin.Lobby.PropertySet { Name = "PointValue", Value = activityData.BonusValue.ToString() });
                    PropertySets.Add(new EWin.Lobby.PropertySet { Name = "JoinActivityCycle", Value = JoinActivityCycle.ToString() });

                    lobbyAPI.AddPromotionCollect(GetToken(), description + "_" + LoginAccount, LoginAccount, EWinWeb.BonusCurrencyType, int.Parse(CollectAreaType), 90, description, PropertySets.ToArray());
                    EWinWebDB.UserAccountEventSummary.UpdateUserAccountEventSummary(LoginAccount, description, JoinActivityCycle, 1, activityData.ThresholdValue, activityData.BonusValue);
                }
            }

            var GetRegisterToParentResult = ActivityCore.GetRegisterToParentResult();

            if (GetRegisterToParentResult.Result == ActivityCore.enumActResult.OK) {
                List<EWin.Lobby.PropertySet> PropertySets = new List<EWin.Lobby.PropertySet>();

                Parent = ocwAPI.GetParentUserAccountInfo(GetToken(), LoginAccount);

                if (Parent.ResultState == EWin.OCW.enumResultState.OK) {
                    ParentLoginAccount = Parent.ParentLoginAccount;
                }

                DT = RedisCache.UserAccountTotalSummary.GetUserAccountTotalSummaryByLoginAccount(ParentLoginAccount);

                if (DT != null) {
                    if (DT.Rows.Count > 0) {
                        decimal DepositAmount = (decimal)DT.Rows[0]["DepositAmount"];

                        if (DepositAmount > 500) {
                            PropertySets = new List<EWin.Lobby.PropertySet>();

                            foreach (var activityData in GetRegisterToParentResult.Data) {
                                string description = activityData.ActivityName;
                                string JoinActivityCycle = activityData.JoinActivityCycle == null ? "1" : activityData.JoinActivityCycle;
                                CollectAreaType = activityData.CollectAreaType == null ? "2" : activityData.CollectAreaType;

                                PropertySets.Add(new EWin.Lobby.PropertySet { Name = "ThresholdValue", Value = activityData.ThresholdValue.ToString() });
                                PropertySets.Add(new EWin.Lobby.PropertySet { Name = "PointValue", Value = activityData.BonusValue.ToString() });
                                PropertySets.Add(new EWin.Lobby.PropertySet { Name = "JoinActivityCycle", Value = JoinActivityCycle.ToString() });

                                lobbyAPI.AddPromotionCollect(GetToken(), description + "_" + ParentLoginAccount + "_From_" + LoginAccount, ParentLoginAccount, EWinWeb.MainCurrencyType, int.Parse(CollectAreaType), 90, description, PropertySets.ToArray());
                                EWinWebDB.UserAccountEventSummary.UpdateUserAccountEventSummary(ParentLoginAccount, description, JoinActivityCycle, 1, activityData.ThresholdValue, activityData.BonusValue);
                            }
                        }
                    }
                }
            }
        }

        return R;
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public EWin.Lobby.APIResult GetLoginAccount(string GUID, string PhonePrefix, string PhoneNumber) {
        EWin.Lobby.APIResult R = new EWin.Lobby.APIResult() {
            Result = EWin.Lobby.enumResult.ERR
        };

        TelPhoneNormalize telPhoneNormalize = new TelPhoneNormalize(PhonePrefix, PhoneNumber);

        if (telPhoneNormalize.PhoneIsValid) {
            R.Result = EWin.Lobby.enumResult.OK;
            R.Message = telPhoneNormalize.PhonePrefix + telPhoneNormalize.PhoneNumber;

        } else {
            R.Result = EWin.Lobby.enumResult.ERR;
            R.Message = "NormalizeError";
        }

        return R;
    }



    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public EWin.Lobby.CompanySiteResult GetCompanySite(string GUID) {
        EWin.Lobby.LobbyAPI lobbyAPI = new EWin.Lobby.LobbyAPI();
        return lobbyAPI.GetCompanySite(GetToken(), GUID);
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public OcwLoginMessageResult GetLoginMessage(string WebSID, string GUID) {
        RedisCache.SessionContext.SIDInfo SI;
        OcwLoginMessageResult R = new OcwLoginMessageResult() { Result = EWin.Lobby.enumResult.ERR };
        Newtonsoft.Json.Linq.JObject SettingData;
        SI = RedisCache.SessionContext.GetSIDInfo(WebSID);

        if (SI != null && !string.IsNullOrEmpty(SI.EWinSID)) {
            SettingData = EWinWeb.GetSettingJObj();
            if (SettingData != null) {
                if (SettingData["LoginMessage"] != null) {
                    R.Title = SettingData["LoginMessage"]["Title"] == null ? "" : SettingData["LoginMessage"]["Title"].ToString();
                    R.Message = SettingData["LoginMessage"]["Message"].ToString();
                    R.Version = SettingData["LoginMessage"]["Version"].ToString();
                    R.Result = EWin.Lobby.enumResult.OK;
                } else {
                    R.Result = EWin.Lobby.enumResult.ERR;
                    R.Message = "NoData";
                }
            } else {
                R.Result = EWin.Lobby.enumResult.ERR;
                R.Message = "NoData";
            }
        } else {
            R.Result = EWin.Lobby.enumResult.ERR;
            R.Message = "InvalidWebSID";
        }

        return R;
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public EWin.Lobby.CompanyGameCodeExchangeResult GetCompanyGameCodeExchange(string GUID, string CurrencyType, string GameBrand, string GameCode) {
        EWin.Lobby.LobbyAPI lobbyAPI = new EWin.Lobby.LobbyAPI();
        var aa = GetToken();
        return lobbyAPI.GetCompanyGameCodeExchange(GetToken(), GUID, CurrencyType, GameBrand, GameCode);
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public EWin.Lobby.UserInfoResult GetUserInfo(string WebSID, string GUID) {
        EWin.Lobby.LobbyAPI lobbyAPI = new EWin.Lobby.LobbyAPI();
        RedisCache.SessionContext.SIDInfo SI;

        SI = RedisCache.SessionContext.GetSIDInfo(WebSID);

        if (SI != null && !string.IsNullOrEmpty(SI.EWinSID)) {
            return lobbyAPI.GetUserInfo(GetToken(), SI.EWinSID, GUID);
        } else {
            var R = new EWin.Lobby.UserInfoResult() {
                Result = EWin.Lobby.enumResult.ERR,
                Message = "InvalidWebSID",
                GUID = GUID
            };
            return R;
        }
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public EWin.Lobby.UserBalanceResult GetUserBalance(string WebSID, string GUID) {
        EWin.Lobby.LobbyAPI lobbyAPI = new EWin.Lobby.LobbyAPI();
        RedisCache.SessionContext.SIDInfo SI;

        SI = RedisCache.SessionContext.GetSIDInfo(WebSID);

        if (SI != null && !string.IsNullOrEmpty(SI.EWinSID)) {
            return lobbyAPI.GetUserBalance(GetToken(), SI.EWinSID, GUID);
        } else {
            var R = new EWin.Lobby.UserBalanceResult() {
                Result = EWin.Lobby.enumResult.ERR,
                Message = "InvalidWebSID",
                GUID = GUID
            };
            return R;
        }
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public CompanyGameCodeResult GetCompanyGameCode(string GUID, string GameCode)
    {
        CompanyGameCodeResult R = new CompanyGameCodeResult() { Result = EWin.Lobby.enumResult.ERR };
        System.Data.DataTable DT;

        DT = RedisCache.CompanyGameCode.GetCompanyGameCode(GameCode.Split('.').First(), GameCode);
        if (DT != null && DT.Rows.Count > 0)
        {
            R.Result = EWin.Lobby.enumResult.OK;
            R.Data = DT.ToList<CompanyGameCode>().First();
        }

        return R;
    }


    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public EWin.Lobby.CompanyGameCodeResult GetCompanyGameCodeByUpdateTimestamp(string GUID, long UpdateTimestamp, int GameID)
    {

        EWin.Lobby.LobbyAPI lobbyAPI = new EWin.Lobby.LobbyAPI();
        return lobbyAPI.GetCompanyGameCodeByUpdateTimestamp(GetToken(), GUID, UpdateTimestamp, GameID);

    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public OcwCompanyCategoryGameCodeResult GetCompanyGameCodeThree(string GUID,string Location)
    {
        OcwCompanyCategoryGameCodeResult Ret = new OcwCompanyCategoryGameCodeResult() { LobbyGameList = new List<GroupOcwCompanyCategoryGameCode>() };
        System.Data.DataTable CompanyCategoryDT;
        System.Data.DataTable CompanyGameCodeDT;
        List<GroupOcwCompanyCategoryGameCode> LobbyGameList = new List<GroupOcwCompanyCategoryGameCode>();
        int CompanyCategoryID;
        CompanyCategoryDT = RedisCache.CompanyCategory.GetCompanyCategory();
        try
        {
            if (CompanyCategoryDT != null && CompanyCategoryDT.Rows.Count > 0)
            {
                for (int i = 0; i < CompanyCategoryDT.Rows.Count; i++)
                {
                    if (((string)CompanyCategoryDT.Rows[i]["Location"]).Contains(Location))
                    {
                        if ((int)CompanyCategoryDT.Rows[i]["State"] == 0)
                        {
                            CompanyCategoryID = (int)CompanyCategoryDT.Rows[i]["CompanyCategoryID"];
                            CompanyGameCodeDT = RedisCache.CompanyCategoryGameCode.GetCompanyCategoryGameCodeByID(CompanyCategoryID);

                            var companyCategoryData = new OcwCompanyCategorysGameCode();
                            companyCategoryData.CompanyCategoryID = CompanyCategoryID;
                            companyCategoryData.CategoryName = (string)CompanyCategoryDT.Rows[i]["CategoryName"];
                            companyCategoryData.SortIndex = (int)CompanyCategoryDT.Rows[i]["SortIndex"];
                            companyCategoryData.State = (int)CompanyCategoryDT.Rows[i]["State"];
                            companyCategoryData.Location = (string)CompanyCategoryDT.Rows[i]["Location"];
                            companyCategoryData.ShowType = (int)CompanyCategoryDT.Rows[i]["ShowType"];
                            companyCategoryData.Datas = new List<OcwCompanyCategoryGameCode>();


                            if (CompanyGameCodeDT != null && CompanyGameCodeDT.Rows.Count > 0)
                            {
                                for (int k = 0; k < CompanyGameCodeDT.Rows.Count; k++)
                                {
                                    var data = new OcwCompanyCategoryGameCode();
                                    data.forCompanyCategoryID = (int)CompanyGameCodeDT.Rows[k]["forCompanyCategoryID"];
                                    data.GameCode = (string)CompanyGameCodeDT.Rows[k]["GameCode"];
                                    data.SortIndex = (int)CompanyGameCodeDT.Rows[k]["SortIndex"];
                                    companyCategoryData.Datas.Add(data);
                                }
                            }
                            if (LobbyGameList.Where(w => w.Location == companyCategoryData.Location).Count() > 0)
                            {
                                LobbyGameList.Find(w => w.Location == companyCategoryData.Location).Categories.Add(companyCategoryData);
                            }
                            else
                            {
                                LobbyGameList.Add(new GroupOcwCompanyCategoryGameCode() { Categories = new List<OcwCompanyCategorysGameCode>() { companyCategoryData }, Location = companyCategoryData.Location });
                            }
                        }
                    }
                }

                if (LobbyGameList.Count > 0)
                {
                    Ret.LobbyGameList = LobbyGameList;
                    Ret.Result = EWin.Lobby.enumResult.OK;
                }
                else
                {
                    Ret.Result = EWin.Lobby.enumResult.ERR;
                }
            }
            else
            {
                Ret.Result = EWin.Lobby.enumResult.ERR;
            }
        }
        catch (Exception ex)
        {
            var a = ex;
            throw;
        }


        return Ret;

    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public OcwCompanyGameCodeResult GetCompanyCategoryID(string GUID, string Location) {
        System.Data.DataTable CompanyCategoryDT;
        int CompanyCategoryID;
        CompanyCategoryDT = RedisCache.CompanyCategory.GetCompanyCategory();
        OcwCompanyGameCodeResult Ret = new OcwCompanyGameCodeResult() { CompanyCategoryDatas = new List<OcwCompanyCategory>() };
        if (CompanyCategoryDT != null && CompanyCategoryDT.Rows.Count > 0) {
            for (int i = 0; i < CompanyCategoryDT.Rows.Count; i++) {
                if ((string)CompanyCategoryDT.Rows[i]["Location"] == Location) {
                    if ((int)CompanyCategoryDT.Rows[i]["State"] == 0) {
                        CompanyCategoryID = (int)CompanyCategoryDT.Rows[i]["CompanyCategoryID"];

                        var companyCategoryData = new OcwCompanyCategory();
                        companyCategoryData.CompanyCategoryID = CompanyCategoryID;
                        companyCategoryData.CategoryName = (string)CompanyCategoryDT.Rows[i]["CategoryName"];
                        companyCategoryData.SortIndex = (int)CompanyCategoryDT.Rows[i]["SortIndex"];
                        companyCategoryData.State = (int)CompanyCategoryDT.Rows[i]["State"];
                        companyCategoryData.Location = (string)CompanyCategoryDT.Rows[i]["Location"];
                        companyCategoryData.ShowType = (int)CompanyCategoryDT.Rows[i]["ShowType"];
                        companyCategoryData.Datas = null;

                        Ret.CompanyCategoryDatas.Add(companyCategoryData);
                    }
                }
            }

            Ret.Result = EWin.Lobby.enumResult.OK;
        } else {
            Ret.Result = EWin.Lobby.enumResult.ERR;
        }
        return Ret;

    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public EWin.Lobby.APIResult GetCompanyMarqueeText(string GUID) {
        EWin.Lobby.LobbyAPI lobbyAPI = new EWin.Lobby.LobbyAPI();
        return lobbyAPI.GetCompanyMarqueeText(GetToken(), GUID);
    }


    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public EWin.Lobby.GameOrderDetailListResult GetGameOrderDetailHistoryBySummaryDate(string WebSID, string GUID, string QueryDate) {
        EWin.Lobby.LobbyAPI lobbyAPI = new EWin.Lobby.LobbyAPI();
        RedisCache.SessionContext.SIDInfo SI;

        SI = RedisCache.SessionContext.GetSIDInfo(WebSID);

        if (SI != null && !string.IsNullOrEmpty(SI.EWinSID)) {
            return lobbyAPI.GetGameOrderDetailHistoryBySummaryDate(GetToken(), SI.EWinSID, GUID, QueryDate);
        } else {
            var R = new EWin.Lobby.GameOrderDetailListResult() {
                Result = EWin.Lobby.enumResult.ERR,
                Message = "InvalidWebSID",
                GUID = GUID
            };
            return R;
        }
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public EWin.Lobby.GameOrderDetailListResult GetGameOrderHistoryBySummaryDateAndGameCode(string WebSID, string GUID, string QueryDate) {
        EWin.Lobby.LobbyAPI lobbyAPI = new EWin.Lobby.LobbyAPI();
        EWin.Lobby.GameOrderDetailListResult callResult = new EWin.Lobby.GameOrderDetailListResult();
        EWin.Lobby.GameOrderDetailListResult R;
        RedisCache.SessionContext.SIDInfo SI;

        SI = RedisCache.SessionContext.GetSIDInfo(WebSID);

        if (SI != null && !string.IsNullOrEmpty(SI.EWinSID)) {
            callResult = lobbyAPI.GetGameOrderDetailHistoryBySummaryDate(GetToken(), SI.EWinSID, GUID, QueryDate);
            if (callResult.Result == EWin.Lobby.enumResult.OK) {
                R = new EWin.Lobby.GameOrderDetailListResult() {
                    Result = EWin.Lobby.enumResult.OK,
                    GUID = GUID
                };

                R.DetailList = callResult.DetailList.GroupBy(x => new { x.GameCode, x.CurrencyType, x.SummaryDate }, x => x, (key, detail) => new EWin.Lobby.GameOrderDetail {
                    GameCode = key.GameCode,
                    ValidBetValue = detail.Sum(y => y.ValidBetValue),
                    BuyChipValue = detail.Sum(y => y.BuyChipValue),
                    RewardValue = detail.Sum(y => y.RewardValue),
                    OrderValue = detail.Sum(y => y.OrderValue),
                    SummaryType = detail.FirstOrDefault().SummaryType,
                    GameAccountingCode = detail.FirstOrDefault().GameAccountingCode,
                    CurrencyType = key.CurrencyType,
                    LoginAccount = detail.FirstOrDefault().LoginAccount,
                    RealName = detail.FirstOrDefault().RealName,
                    SummaryDate = key.SummaryDate
                }).ToArray();

            } else {
                R = callResult;
            }
        } else {
            R = new EWin.Lobby.GameOrderDetailListResult() {
                Result = EWin.Lobby.enumResult.ERR,
                Message = "InvalidWebSID",
                GUID = GUID
            };
        }

        return R;
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public EWin.Lobby.OrderSummaryResult GetGameOrderSummaryHistoryGroupGameCode(string WebSID, string GUID, string QueryBeginDate, string QueryEndDate) {
        EWin.Lobby.LobbyAPI lobbyAPI = new EWin.Lobby.LobbyAPI();
        EWin.Lobby.OrderSummaryResult callResult = new EWin.Lobby.OrderSummaryResult();
        EWin.Lobby.OrderSummaryResult R;
        RedisCache.SessionContext.SIDInfo SI;

        SI = RedisCache.SessionContext.GetSIDInfo(WebSID);

        if (SI != null && !string.IsNullOrEmpty(SI.EWinSID)) {
            callResult = lobbyAPI.GetGameOrderSummaryHistory(GetToken(), SI.EWinSID, GUID, QueryBeginDate, QueryEndDate);
            if (callResult.Result == EWin.Lobby.enumResult.OK) {
                R = new EWin.Lobby.OrderSummaryResult() {
                    Result = EWin.Lobby.enumResult.OK,
                    GUID = GUID
                };

                R.SummaryList = callResult.SummaryList.Where(x=>x.OrderValue > 0).GroupBy(x => new { x.CurrencyType, x.SummaryDate }, x => x, (key, sum) => new EWin.Lobby.OrderSummary {
                    ValidBetValue = sum.Sum(y => y.ValidBetValue),
                    RewardValue = sum.Sum(y => y.RewardValue),
                    OrderValue = sum.Sum(y => y.OrderValue),
                    TotalValidBetValue = sum.Sum(y => y.TotalValidBetValue),
                    TotalRewardValue = sum.Sum(y => y.TotalRewardValue),
                    TotalOrderValue = sum.Sum(y => y.TotalOrderValue),
                    CurrencyType = key.CurrencyType,
                    LoginAccount = sum.FirstOrDefault().LoginAccount,
                    SummaryDate = key.SummaryDate
                }).ToArray();

            } else {
                R = callResult;
            }
        } else {
            R = new EWin.Lobby.OrderSummaryResult() {
                Result = EWin.Lobby.enumResult.ERR,
                Message = "InvalidWebSID",
                GUID = GUID
            };
        }

        return R;
    }


    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public EWin.Lobby.OrderSummaryResult GetGameOrderSummaryHistory(string WebSID, string GUID, string QueryBeginDate, string QueryEndDate) {
        EWin.Lobby.LobbyAPI lobbyAPI = new EWin.Lobby.LobbyAPI();
        RedisCache.SessionContext.SIDInfo SI;

        SI = RedisCache.SessionContext.GetSIDInfo(WebSID);

        if (SI != null && !string.IsNullOrEmpty(SI.EWinSID)) {
            return lobbyAPI.GetGameOrderSummaryHistory(GetToken(), SI.EWinSID, GUID, QueryBeginDate, QueryEndDate);
        } else {
            var R = new EWin.Lobby.OrderSummaryResult() {
                Result = EWin.Lobby.enumResult.ERR,
                Message = "InvalidWebSID",
                GUID = GUID
            };
            return R;
        }
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public EWin.Lobby.APIResult SetWalletPassword(string WebSID, string GUID, string LoginPassword, string NewWalletPassword) {
        EWin.Lobby.LobbyAPI lobbyAPI = new EWin.Lobby.LobbyAPI();
        RedisCache.SessionContext.SIDInfo SI;

        SI = RedisCache.SessionContext.GetSIDInfo(WebSID);

        if (SI != null && !string.IsNullOrEmpty(SI.EWinSID)) {
            return lobbyAPI.SetWalletPassword(GetToken(), SI.EWinSID, GUID, LoginPassword, NewWalletPassword);
        } else {
            var R = new EWin.Lobby.APIResult() {
                Result = EWin.Lobby.enumResult.ERR,
                Message = "InvalidWebSID",
                GUID = GUID
            };
            return R;
        }
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public EWin.Lobby.APIResult SetUserPassword(string WebSID, string GUID, string OldPassword, string NewPassword) {
        EWin.Lobby.LobbyAPI lobbyAPI = new EWin.Lobby.LobbyAPI();
        RedisCache.SessionContext.SIDInfo SI;

        SI = RedisCache.SessionContext.GetSIDInfo(WebSID);

        if (SI != null && !string.IsNullOrEmpty(SI.EWinSID)) {
            return lobbyAPI.SetUserPassword(GetToken(), SI.EWinSID, GUID, OldPassword, NewPassword);
        } else {
            var R = new EWin.Lobby.APIResult() {
                Result = EWin.Lobby.enumResult.ERR,
                Message = "InvalidWebSID",
                GUID = GUID
            };
            return R;
        }
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public UserAccountThisWeekTotalValidBetValueResult GetUserAccountThisWeekTotalValidBetValueResult(string WebSID, string GUID) {
        UserAccountThisWeekTotalValidBetValueResult R;
        EWin.Lobby.LobbyAPI lobbyAPI = new EWin.Lobby.LobbyAPI();
        EWin.Lobby.OrderSummaryResult callResult = new EWin.Lobby.OrderSummaryResult();
        List<UserAccountThisWeekTotalValidBetValue> k = new List<UserAccountThisWeekTotalValidBetValue>();
        RedisCache.SessionContext.SIDInfo SI;

        SI = RedisCache.SessionContext.GetSIDInfo(WebSID);

        if (SI != null && !string.IsNullOrEmpty(SI.EWinSID)) {
            DateTime currentTime = DateTime.UtcNow.AddHours(09);
            int week = Convert.ToInt32(currentTime.DayOfWeek);
            week = week == 0 ? 7 : week;
            DateTime start;
            DateTime end;

            if (week > 4) {
                start = currentTime.AddDays(5 - week);        //這禮拜5
                end = currentTime.AddDays(4 - week + 7);
            } else {
                start = currentTime.AddDays(5 - week - 7); //上禮拜5
                end = currentTime.AddDays(4 - week);  //這禮拜4
            }


            TimeSpan ts = end.Subtract(start); //兩時間天數相減

            int dayCount = ts.Days + 1; //相距天數

            for (int i = 0; i < dayCount; i++) {
                UserAccountThisWeekTotalValidBetValue d = new UserAccountThisWeekTotalValidBetValue();
                d.Date = start.AddDays(i).ToString("yyyy-MM-dd");
                d.TotalValidBetValue = 0;
                d.Status = 0;
                k.Add(d);
            }

            callResult = lobbyAPI.GetGameOrderSummaryHistory(GetToken(), SI.EWinSID, System.Guid.NewGuid().ToString(), start.ToString("yyyy-MM-dd 00:00:00"), end.ToString("yyyy-MM-dd 00:00:00"));

            if (callResult.Result == EWin.Lobby.enumResult.OK) {

                var GameOrderList = callResult.SummaryList.GroupBy(x => new { x.CurrencyType, x.SummaryDate }, x => x, (key, sum) => new EWin.Lobby.OrderSummary {
                    TotalValidBetValue = sum.Sum(y => y.ValidBetValue),
                    CurrencyType = key.CurrencyType,
                    SummaryDate = key.SummaryDate
                }).ToList();

                for (int i = 0; i < k.Count; i++) {
                    for (int j = 0; j < GameOrderList.Count; j++) {
                        if (k[i].Date == GameOrderList[j].SummaryDate) {
                            k[i].TotalValidBetValue = GameOrderList[j].TotalValidBetValue;
                            if (GameOrderList[j].TotalValidBetValue > 20000 || GameOrderList[j].TotalValidBetValue == 20000) {
                                k[i].Status = 1;
                            }
                        }
                    }
                }

                R = new UserAccountThisWeekTotalValidBetValueResult() {
                    Result = EWin.Lobby.enumResult.OK,
                    Datas = k,
                    GUID = GUID
                };
            } else {
                R = new UserAccountThisWeekTotalValidBetValueResult() {
                    Result = EWin.Lobby.enumResult.ERR,
                    Message = "NotEligible",
                    GUID = GUID
                };
            }
        } else {
            R = new UserAccountThisWeekTotalValidBetValueResult() {
                Result = EWin.Lobby.enumResult.ERR,
                Message = "EMailNotFind",
                GUID = GUID
            };
        }

        return R;
    }

    //[WebMethod]
    //[ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    //public EWin.Lobby.APIResult SendCSMail(string WebSID, string GUID, string EMail, string Topic, string SendBody)
    //{
    //    EWin.Lobby.APIResult R;

    //    RedisCache.SessionContext.SIDInfo SI;

    //    SI = RedisCache.SessionContext.GetSIDInfo(WebSID);

    //    if (SI != null && !string.IsNullOrEmpty(SI.EWinSID) || string.IsNullOrEmpty(EMail) == false)
    //    {
    //        if (string.IsNullOrEmpty(Topic) == false && string.IsNullOrEmpty(SendBody) == false)
    //        {
    //            string returnMail = string.IsNullOrEmpty(EMail) ? SI.LoginAccount : EMail;
    //            string returnLoginAccount = string.IsNullOrEmpty(SI.LoginAccount) ? "" : SI.LoginAccount;
    //            //string subjectString = String.Format("問題分類：{0},回覆信箱：{1}", Topic, returnMail);
    //            //string bodyString = String.Format("問題分類：{0}\r\n"
    //            //                        + "問題內容：{1}\r\n"
    //            //                        + "回覆信箱：{2}\r\n"
    //            //                        + "相關帳號：{3}\r\n"
    //            //                        + "詢問時間：{4}\r\n"
    //            //                        , Topic, SendBody, returnMail, returnLoginAccount, DateTime.Now);
    //            string subjectString = String.Format("お問い合わせ類型：{0},お返事のメールアドレス：{1}", Topic, returnMail);
    //            string bodyString = String.Format("お問い合わせ類型：{0}\r\n"
    //                                    + "お問い合わせ内容：{1}\r\n"
    //                                    + "お返事のメールアドレス：{2}\r\n"
    //                                    + "アカウント：{3}\r\n"
    //                                    + "お問い合わせ時間：{4}\r\n"
    //                                    , Topic, SendBody, returnMail, returnLoginAccount, DateTime.Now);

    //            /*
    //            お問い合わせ類型:
    //            お問い合わせ内容:
    //            お返事のメールアドレス:
    //            アカウント:
    //            お問い合わせ時間:
    //            */
    //            CodingControl.SendMail("smtp.gmail.com", new System.Net.Mail.MailAddress("Service <edm@casino-maharaja.com>"), new System.Net.Mail.MailAddress("edm@casino-maharaja.com"), subjectString, bodyString, "edm@casino-maharaja.com", "wjggvbkjosunoilx", "utf-8", true);

    //            R = new EWin.Lobby.APIResult()
    //            {
    //                Result = EWin.Lobby.enumResult.OK,
    //                Message = "",
    //                GUID = GUID
    //            };
    //        }
    //        else
    //        {
    //            R = new EWin.Lobby.APIResult()
    //            {
    //                Result = EWin.Lobby.enumResult.ERR,
    //                Message = "SubjectOrSendBodyIsEmpty",
    //                GUID = GUID
    //            };
    //        }
    //    }
    //    else
    //    {
    //        R = new EWin.Lobby.APIResult()
    //        {
    //            Result = EWin.Lobby.enumResult.ERR,
    //            Message = "EMailNotFind",
    //            GUID = GUID
    //        };
    //    }

    //    return R;
    //}

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public EWin.Lobby.APIResult SendCSMail(string GUID, string EMail, string Topic, string SendBody) {
        EWin.Lobby.APIResult R;

        if (string.IsNullOrEmpty(Topic) == false && string.IsNullOrEmpty(SendBody) == false) {
            string returnMail = EMail;
            string returnLoginAccount = EMail;
            string apiURL = "https://mail.surenotifyapi.com/v1/messages";
            string apiKey = "NDAyODgxNDM4MGJiZTViMjAxODBkYjZjMmRjYzA3NDgtMTY1NDE0Mzc1NC0x";
            //string subjectString = String.Format("問題分類：{0},回覆信箱：{1}", Topic, returnMail);
            //string bodyString = String.Format("問題分類：{0}\r\n"
            //                        + "問題內容：{1}\r\n"
            //                        + "回覆信箱：{2}\r\n"
            //                        + "相關帳號：{3}\r\n"
            //                        + "詢問時間：{4}\r\n"
            //                        , Topic, SendBody, returnMail, returnLoginAccount, DateTime.Now);
            string subjectString = String.Format("お問い合わせ類型：{0},お返事のメールアドレス：{1}", Topic, returnMail);
            string bodyString = String.Format("お問い合わせ類型：{0}\r\n"
                                    + "お問い合わせ内容：{1}\r\n"
                                    + "お返事のメールアドレス：{2}\r\n"
                                    + "アカウント：{3}\r\n"
                                    + "お問い合わせ時間：{4}\r\n"
                                    , Topic, SendBody, returnMail, returnLoginAccount, DateTime.Now);

            /*
            お問い合わせ類型:
            お問い合わせ内容:
            お返事のメールアドレス:
            アカウント:
            お問い合わせ時間:
            */

            Newtonsoft.Json.Linq.JObject objBody = new Newtonsoft.Json.Linq.JObject();
            Newtonsoft.Json.Linq.JObject objRecipients = new Newtonsoft.Json.Linq.JObject();
            Newtonsoft.Json.Linq.JArray aryRecipients = new Newtonsoft.Json.Linq.JArray();

            objBody.Add("subject", subjectString);
            objBody.Add("fromName", "マハラジャ");
            objBody.Add("fromAddress", "edm@casino-maharaja.com");
            objBody.Add("content", bodyString);

            objRecipients.Add("name", "service@casino-maharaja.com");
            objRecipients.Add("address", "service@casino-maharaja.com");
            aryRecipients.Add(objRecipients);

            objBody.Add("recipients", aryRecipients);

            CodingControl.GetWebTextContent(apiURL, "POST", objBody.ToString(), "x-api-key:" + apiKey, "application/json", System.Text.Encoding.UTF8);

            R = new EWin.Lobby.APIResult() {
                Result = EWin.Lobby.enumResult.OK,
                Message = "",
                GUID = GUID
            };
        } else {
            R = new EWin.Lobby.APIResult() {
                Result = EWin.Lobby.enumResult.ERR,
                Message = "SubjectOrSendBodyIsEmpty",
                GUID = GUID
            };
        }

        return R;
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public EWin.Lobby.APIResult SetUserPasswordByValidateCode(string GUID, EWin.Lobby.enumValidateType ValidateType, string EMail, string ContactPhonePrefix, string ContactPhoneNumber, string ValidateCode, string NewPassword) {
        EWin.Lobby.LobbyAPI lobbyAPI = new EWin.Lobby.LobbyAPI();
        return lobbyAPI.SetUserPasswordByValidateCode(GetToken(), GUID, ValidateType, EMail, ContactPhonePrefix, ContactPhoneNumber, ValidateCode, NewPassword);
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public EWin.Lobby.ValidateCodeResult SetValidateCode(string GUID, EWin.Lobby.enumValidateType ValidateType, string EMail, string ContactPhonePrefix, string ContactPhoneNumber) {
        EWin.Lobby.LobbyAPI lobbyAPI = new EWin.Lobby.LobbyAPI();
        return lobbyAPI.SetValidateCodeOnlyNumber(GetToken(), GUID, ValidateType, EMail, ContactPhonePrefix, ContactPhoneNumber);
    }



    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public EWin.Lobby.APIResult SetValidateCodeByMail(string GUID, EWin.Lobby.enumValidateType ValidateType, string EMail, string ContactPhonePrefix, string ContactPhoneNumber, CodingControl.enumSendMailType SendMailType) {
        EWin.Lobby.LobbyAPI lobbyAPI = new EWin.Lobby.LobbyAPI();
        EWin.Lobby.ValidateCodeResult validateCodeResult;
        EWin.Lobby.APIResult R = new EWin.Lobby.APIResult() { GUID = GUID, Result = EWin.Lobby.enumResult.ERR };

        validateCodeResult = lobbyAPI.SetValidateCodeOnlyNumber(GetToken(), GUID, ValidateType, EMail, ContactPhonePrefix, ContactPhoneNumber);

        if (validateCodeResult.Result == EWin.Lobby.enumResult.OK) {
            R = SendMail(EMail, validateCodeResult.ValidateCode, R, SendMailType);
        } else {
            R.Result = validateCodeResult.Result;
            R.Message = validateCodeResult.Message;
        }

        return R;
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public EWin.Lobby.APIResult CheckValidateCode(string GUID, EWin.Lobby.enumValidateType ValidateType, string EMail, string ContactPhonePrefix, string ContactPhoneNumber, string ValidateCode) {
        EWin.Lobby.LobbyAPI lobbyAPI = new EWin.Lobby.LobbyAPI();
        return lobbyAPI.CheckValidateCode(GetToken(), GUID, ValidateType, EMail, ContactPhonePrefix, ContactPhoneNumber, ValidateCode);
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public EWin.Lobby.PaymentResult GetPaymentHistory(string WebSID, string GUID, string BeginDate, string EndDate) {
        EWin.Lobby.LobbyAPI lobbyAPI = new EWin.Lobby.LobbyAPI();
        RedisCache.SessionContext.SIDInfo SI;

        SI = RedisCache.SessionContext.GetSIDInfo(WebSID);

        if (SI != null && !string.IsNullOrEmpty(SI.EWinSID)) {
            return lobbyAPI.GetPaymentHistory(GetToken(), SI.EWinSID, GUID, BeginDate, EndDate);
        } else {
            var R = new EWin.Lobby.PaymentResult() {
                Result = EWin.Lobby.enumResult.ERR,
                Message = "InvalidWebSID",
                GUID = GUID
            };
            return R;
        }
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public EWin.Lobby.CompanyExchangeResult GetCompanyExchange(string GUID) {
        EWin.Lobby.LobbyAPI lobbyAPI = new EWin.Lobby.LobbyAPI();
        return lobbyAPI.GetCompanyExchange(GetToken(), GUID);
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public EWin.Lobby.APIResult GetWebSiteMaintainStatus() {
        EWin.Lobby.APIResult R = new EWin.Lobby.APIResult();
        R.Result = EWin.Lobby.enumResult.OK;
        R.Message = "0";
        string Filename;

        Filename = HttpContext.Current.Server.MapPath("/App_Data/Setting.json");

        if (System.IO.File.Exists(Filename)) {
            string SettingContent;

            SettingContent = System.IO.File.ReadAllText(Filename);

            if (string.IsNullOrEmpty(SettingContent) == false) {
                try {
                    Newtonsoft.Json.Linq.JObject o = Newtonsoft.Json.Linq.JObject.Parse(SettingContent);
                    int mainTain = (int)o["InMaintenance"];

                    if (mainTain == 1) {
                        R.Message = "1";
                    }
                } catch (Exception ex) { }
            }
        }

        return R;
    }

    //private EWin.Lobby.APIResult SendMail(string EMail, string ValidateCode, EWin.Lobby.APIResult result, CodingControl.enumSendMailType SendMailType)
    //{
    //    string Subject = string.Empty;
    //    string SendBody = string.Empty;
    //    Subject = "Verify Code";

    //    SendBody = CodingControl.GetEmailTemp(EMail, ValidateCode, SendMailType);

    //    try
    //    {
    //        //CodingControl.SendMail("smtp.gmail.com", new System.Net.Mail.MailAddress("Service <service@OCW888.com>"), new System.Net.Mail.MailAddress(EMail), Subject, SendBody, "service@OCW888.com", "koajejksxfyiwixx", "utf-8", true);
    //        CodingControl.SendMail("smtp.gmail.com", new System.Net.Mail.MailAddress("Service <edm@casino-maharaja.com>"), new System.Net.Mail.MailAddress(EMail), Subject, SendBody, "edm@casino-maharaja.com", "eanrbmhmqflaqzac", "utf-8", true);
    //        result.Result = EWin.Lobby.enumResult.OK;
    //        result.Message = "";

    //    }
    //    catch (Exception ex)
    //    {
    //        result.Result = EWin.Lobby.enumResult.ERR;
    //        result.Message = "";
    //    }
    //    return result;
    //}

    //private EWin.Lobby.APIResult SendRegisterReceiveRewardMail(string EMail, EWin.Lobby.APIResult result, string ReceiveRegisterRewardURL)
    //{
    //    string Subject = string.Empty;
    //    string SendBody = string.Empty;
    //    Subject = "RegisterReceiveReward";

    //    SendBody = CodingControl.GetRegisterReceiveRewardEmailTemp(EMail, ReceiveRegisterRewardURL);

    //    try
    //    {
    //        CodingControl.SendMail("smtp.gmail.com", new System.Net.Mail.MailAddress("Service <edm@casino-maharaja.com>"), new System.Net.Mail.MailAddress(EMail), Subject, SendBody, "edm@casino-maharaja.com", "eanrbmhmqflaqzac", "utf-8", true);
    //        result.Result = EWin.Lobby.enumResult.OK;
    //        result.Message = "";

    //    }
    //    catch (Exception ex)
    //    {
    //        result.Result = EWin.Lobby.enumResult.ERR;
    //        result.Message = "";
    //    }
    //    return result;
    //}

    private EWin.Lobby.APIResult SendMail(string EMail, string ValidateCode, EWin.Lobby.APIResult result, CodingControl.enumSendMailType SendMailType) {
        string Subject = string.Empty;
        string SendBody = string.Empty;
        string apiURL = "https://mail.surenotifyapi.com/v1/messages";
        string apiKey = "NDAyODgxNDM4MGJiZTViMjAxODBkYjZjMmRjYzA3NDgtMTY1NDE0Mzc1NC0x";
        Subject = "Verify Code";

        SendBody = CodingControl.GetEmailTemp(EMail, ValidateCode, SendMailType);

        try {
            Newtonsoft.Json.Linq.JObject objBody = new Newtonsoft.Json.Linq.JObject();
            Newtonsoft.Json.Linq.JObject objRecipients = new Newtonsoft.Json.Linq.JObject();
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
            result.Result = EWin.Lobby.enumResult.OK;
            result.Message = "";

        } catch (Exception ex) {
            result.Result = EWin.Lobby.enumResult.ERR;
            result.Message = "";
        }
        return result;
    }

    private EWin.Lobby.APIResult SendRegisterReceiveRewardMail(string EMail, EWin.Lobby.APIResult result, string ReceiveRegisterRewardURL) {
        string Subject = string.Empty;
        string SendBody = string.Empty;
        string apiURL = "https://mail.surenotifyapi.com/v1/messages";
        string apiKey = "NDAyODgxNDM4MGJiZTViMjAxODBkYjZjMmRjYzA3NDgtMTY1NDE0Mzc1NC0x";
        Subject = "RegisterReceiveReward";

        SendBody = CodingControl.GetRegisterReceiveRewardEmailTemp(EMail, ReceiveRegisterRewardURL);

        try {

            Newtonsoft.Json.Linq.JObject objBody = new Newtonsoft.Json.Linq.JObject();
            Newtonsoft.Json.Linq.JObject objRecipients = new Newtonsoft.Json.Linq.JObject();
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
            result.Result = EWin.Lobby.enumResult.OK;
            result.Message = "";

        } catch (Exception ex) {
            result.Result = EWin.Lobby.enumResult.ERR;
            result.Message = "";
        }
        return result;
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public EWin.Lobby.APIResult SetUserMail(string GUID, EWin.Lobby.enumValidateType ValidateType, CodingControl.enumSendMailType SendMailType, string EMail, string ContactPhonePrefix, string ContactPhoneNumber, string ReceiveRegisterRewardURL) {
        EWin.Lobby.LobbyAPI lobbyAPI = new EWin.Lobby.LobbyAPI();
        EWin.Lobby.ValidateCodeResult validateCodeResult;
        EWin.Lobby.APIResult R = new EWin.Lobby.APIResult() { GUID = GUID, Result = EWin.Lobby.enumResult.ERR };
        string ValidateCode = string.Empty;
        TelPhoneNormalize telPhoneNormalize = new TelPhoneNormalize(ContactPhonePrefix, ContactPhoneNumber);
        if (telPhoneNormalize != null) {
            ContactPhonePrefix = telPhoneNormalize.PhonePrefix;
            ContactPhoneNumber = telPhoneNormalize.PhoneNumber;
        }

        switch (SendMailType) {
            case CodingControl.enumSendMailType.Register:
                validateCodeResult = lobbyAPI.SetValidateCodeOnlyNumber(GetToken(), GUID, ValidateType, EMail, ContactPhonePrefix, ContactPhoneNumber);
                if (validateCodeResult.Result == EWin.Lobby.enumResult.OK) {
                    ValidateCode = validateCodeResult.ValidateCode;
                }
                break;
            case CodingControl.enumSendMailType.ForgetPassword:
                validateCodeResult = lobbyAPI.SetValidateCodeOnlyNumber(GetToken(), GUID, ValidateType, EMail, ContactPhonePrefix, ContactPhoneNumber);
                if (validateCodeResult.Result == EWin.Lobby.enumResult.OK) {
                    ValidateCode = validateCodeResult.ValidateCode;
                }
                break;
            case CodingControl.enumSendMailType.ThanksLetter:

                break;
        }

        switch (ValidateType) {
            case EWin.Lobby.enumValidateType.EMail:
                if (SendMailType == CodingControl.enumSendMailType.RegisterReceiveReward) {
                    R = SendRegisterReceiveRewardMail(EMail, R, ReceiveRegisterRewardURL);
                } else {
                    R = SendMail(EMail, ValidateCode, R, SendMailType);
                }
                break;
            case EWin.Lobby.enumValidateType.PhoneNumber:
                string smsContent = "Welcome to LUCKY FANTA !"+"\r\n"+"Your OTP code is " + ValidateCode +  "\r\n" + "Thanks for joining LUCKY FANTA!";
                R = SendSMS(GUID, "0", 0, ContactPhonePrefix + ContactPhoneNumber, smsContent);
                break;
            default:
                break;
        }

        return R;
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public EWin.Lobby.APIResult SendSMS(string GUID, string SMSTypeCode, int RecvUserAccountID, string ContactNumber, string SendContent) {
        EWin.Lobby.LobbyAPI lobbyAPI = new EWin.Lobby.LobbyAPI();
        EWin.Lobby.APIResult R = new EWin.Lobby.APIResult() { GUID = GUID, Result = EWin.Lobby.enumResult.ERR };
        string ValidateCode = string.Empty;

        R = lobbyAPI.SendSMS(GetToken(), GUID, SMSTypeCode, RecvUserAccountID,"LuckyFanta" ,ContactNumber, SendContent);

        return R;
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public EWin.Lobby.PaymentResult CreatePayment(string WebSID, string GUID, decimal Value, int PaymentMethodID) {
        EWin.Lobby.LobbyAPI lobbyAPI = new EWin.Lobby.LobbyAPI();
        RedisCache.SessionContext.SIDInfo SI;

        SI = RedisCache.SessionContext.GetSIDInfo(WebSID);

        if (SI != null && !string.IsNullOrEmpty(SI.EWinSID)) {
            return null;
        } else {
            var R = new EWin.Lobby.PaymentResult() {
                Result = EWin.Lobby.enumResult.ERR,
                Message = "InvalidWebSID",
                GUID = GUID
            };
            return R;
        }
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public OcwBulletinBoardResult GetBulletinBoard(string GUID) {

        OcwBulletinBoardResult R = new OcwBulletinBoardResult() { Datas = new List<OcwBulletinBoard>(), Result = EWin.Lobby.enumResult.ERR };
        System.Data.DataTable DT;
        RedisCache.SessionContext.SIDInfo SI;

        DT = RedisCache.BulletinBoard.GetBulletinBoard();
        if (DT != null && DT.Rows.Count > 0) {
            for (int i = 0; i < DT.Rows.Count; i++) {
                var data = new OcwBulletinBoard();
                if ((int)DT.Rows[i]["State"] == 0) {
                    data.BulletinBoardID = (int)DT.Rows[i]["BulletinBoardID"];
                    data.BulletinTitle = (string)DT.Rows[i]["BulletinTitle"];
                    data.BulletinContent = (string)DT.Rows[i]["BulletinContent"];
                    data.CreateDate = (DateTime)DT.Rows[i]["CreateDate"];
                    data.State = (int)DT.Rows[i]["State"];
                    R.Datas.Add(data);
                }
            }

            if (R.Datas.Count > 0) {
                R.Result = (int)EWin.Lobby.enumResult.OK;
                R.Datas = R.Datas.OrderByDescending(x => x.CreateDate).ToList();
            } else {
                R.Result = EWin.Lobby.enumResult.ERR;
                R.Message = "NoData";
            }
        } else {
            R.Result = EWin.Lobby.enumResult.ERR;
            R.Message = "NoData";
        }


        return R;
    }


    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public EWin.Lobby.APIResult CreateBigEagle(string LoginAccount) {
        EWin.OCW.OCW OCWAPI = new EWin.OCW.OCW();
        EWin.OCW.APIResult OcwAPIResult = OCWAPI.CreateBigEagle(LoginAccount);
        EWin.Lobby.APIResult result = new EWin.Lobby.APIResult();

        if (OcwAPIResult.ResultState == EWin.OCW.enumResultState.OK) {
            result.Result = EWin.Lobby.enumResult.OK;
        } else {
            result.Result = EWin.Lobby.enumResult.ERR;
            result.Message = OcwAPIResult.Message;
        }

        return result;
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public EWin.Lobby.APIResult UpdateUserAccount(string WebSID, string GUID, EWin.OCW.UserAccount UserInfo) {
        EWin.Lobby.APIResult R = new EWin.Lobby.APIResult();
        EWin.OCW.APIResult OcwAPIResult = new EWin.OCW.APIResult();
        EWin.OCW.OCW OCWAPI = new EWin.OCW.OCW();
        RedisCache.SessionContext.SIDInfo SI;

        SI = RedisCache.SessionContext.GetSIDInfo(WebSID);

        if (SI != null && !string.IsNullOrEmpty(SI.EWinSID)) {
            OcwAPIResult = OCWAPI.UpdateUserAccount(GetToken(), SI.EWinSID, GUID, UserInfo);

            if (OcwAPIResult.ResultState == EWin.OCW.enumResultState.OK) {
                R.Result = EWin.Lobby.enumResult.OK;
            } else {
                R.Message = OcwAPIResult.Message;
                R.Result = EWin.Lobby.enumResult.ERR;
            }
        } else {
            R.Message = "InvalidWebSID";
            R.Result = EWin.Lobby.enumResult.ERR;
        }
        return R;
    }

    #region 領取專區

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public EWin.Lobby.APIResult CollectUserAccountPromotion(string WebSID, string GUID, int CollectID) {
        EWin.Lobby.LobbyAPI lobbyAPI = new EWin.Lobby.LobbyAPI();
        RedisCache.SessionContext.SIDInfo SI;
        EWin.Lobby.APIResult R = new EWin.Lobby.APIResult() { Result = EWin.Lobby.enumResult.ERR };
        string Token = GetToken();
        int CollectLimit = 100;

        SI = RedisCache.SessionContext.GetSIDInfo(WebSID);

        if (SI != null && !string.IsNullOrEmpty(SI.EWinSID)) {
            var PromotionCollectResult = lobbyAPI.GetPromotionCollectAvailable(Token, SI.EWinSID, GUID);

            if (PromotionCollectResult.Result == EWin.Lobby.enumResult.OK) {
                var Collect = PromotionCollectResult.CollectList.Where(x => x.CollectID == CollectID).FirstOrDefault();
                var UserInfoResult = lobbyAPI.GetUserInfo(Token, SI.EWinSID, GUID);
                if (UserInfoResult.Result == EWin.Lobby.enumResult.OK) {
                    var Wallet = UserInfoResult.WalletList.Where(x => x.CurrencyType == EWinWeb.MainCurrencyType).FirstOrDefault();

                    decimal OldThresholdValue = 0.0M;
                    if (UserInfoResult.ThresholdInfo.Length > 0) {
                        OldThresholdValue = UserInfoResult.ThresholdInfo[0].ThresholdValue;
                    }

                    if (Collect != null) {
                        EWin.Lobby.APIResult CollecResult;

                        if (Collect.CollectAreaType == 2) {

                            if (Wallet.PointValue < CollectLimit) {
                                ReportSystem.UserAccountPromotionCollect.CreateUserAccountPromotionCollect(Token, SI.LoginAccount, EWinWeb.MainCurrencyType, "ResetCollettPromotion. CollectID=" + CollectID.ToString());
                                var ResetResult = lobbyAPI.AddThreshold(Token, GUID, System.Guid.NewGuid().ToString(), SI.LoginAccount, EWinWeb.MainCurrencyType, 0, "ResetCollettPromotion. CollectID=" + CollectID.ToString(), true);

                                if (ResetResult.Result == EWin.Lobby.enumResult.OK) {

                                } else {
                                    R.Result = EWin.Lobby.enumResult.ERR;
                                    R.Message = "Reset Failure : " + ResetResult.Message;

                                    ReportSystem.UserAccountPromotionCollect.CreateUserAccountPromotionCollect(Token, SI.LoginAccount, EWinWeb.MainCurrencyType, R.Message);
                                }
                            }

                            CollecResult = lobbyAPI.CollectUserAccountPromotion(Token, SI.EWinSID, GUID, CollectID);

                            if (CollecResult.Result == EWin.Lobby.enumResult.OK) {

                                string JoinActivityCycle = "1";
                                Newtonsoft.Json.Linq.JObject actioncontent = Newtonsoft.Json.Linq.JObject.Parse(Collect.ActionContent);

                                if (actioncontent["ActionList"] != null) {
                                    Newtonsoft.Json.Linq.JArray actionlist = Newtonsoft.Json.Linq.JArray.Parse(actioncontent["ActionList"].ToString());

                                    foreach (var item in actionlist) {
                                        if (item["Field"].ToString() == "JoinActivityCycle") {
                                            JoinActivityCycle = item["Value"].ToString();
                                        }
                                    }
                                }

                                EWinWebDB.UserAccountEventSummary.UpdateUserAccountEventSummary(SI.LoginAccount, Collect.Description, JoinActivityCycle, 0, 0, 0);
                                R.Result = EWin.Lobby.enumResult.OK;
                            } else {
                                lobbyAPI.AddThreshold(Token, GUID, System.Guid.NewGuid().ToString(), SI.LoginAccount, EWinWeb.MainCurrencyType, OldThresholdValue, "Undo ResetCollectPromotion. CollectID=" + CollectID.ToString(), true);
                                R.Result = EWin.Lobby.enumResult.ERR;
                                R.Message = "Collect Failure";
                            }
                        } else {
                            if (Wallet.PointValue < CollectLimit) {
                                ReportSystem.UserAccountPromotionCollect.CreateUserAccountPromotionCollect(Token, SI.LoginAccount, EWinWeb.MainCurrencyType, "ResetCollettPromotion. CollectID=" + CollectID.ToString());
                                var ResetResult = lobbyAPI.AddThreshold(Token, GUID, System.Guid.NewGuid().ToString(), SI.LoginAccount, EWinWeb.MainCurrencyType, 0, "ResetCollettPromotion. CollectID=" + CollectID.ToString(), true);

                                if (ResetResult.Result == EWin.Lobby.enumResult.OK) {
                                    CollecResult = lobbyAPI.CollectUserAccountPromotion(Token, SI.EWinSID, GUID, CollectID);

                                    if (CollecResult.Result == EWin.Lobby.enumResult.OK) {

                                        string JoinActivityCycle = "1";
                                        Newtonsoft.Json.Linq.JObject actioncontent = Newtonsoft.Json.Linq.JObject.Parse(Collect.ActionContent);

                                        if (actioncontent["ActionList"] != null) {
                                            Newtonsoft.Json.Linq.JArray actionlist = Newtonsoft.Json.Linq.JArray.Parse(actioncontent["ActionList"].ToString());

                                            foreach (var item in actionlist) {
                                                if (item["Field"].ToString() == "JoinActivityCycle") {
                                                    JoinActivityCycle = item["Value"].ToString();
                                                }
                                            }
                                        }

                                        EWinWebDB.UserAccountEventSummary.UpdateUserAccountEventSummary(SI.LoginAccount, Collect.Description, JoinActivityCycle, 0, 0, 0);
                                        R.Result = EWin.Lobby.enumResult.OK;
                                    } else {
                                        lobbyAPI.AddThreshold(Token, GUID, System.Guid.NewGuid().ToString(), SI.LoginAccount, EWinWeb.MainCurrencyType, OldThresholdValue, "Undo ResetCollectPromotion. CollectID=" + CollectID.ToString(), true);
                                        R.Result = EWin.Lobby.enumResult.ERR;
                                        R.Message = "Collect Failure";

                                        ReportSystem.UserAccountPromotionCollect.CreateUserAccountPromotionCollect(Token, SI.LoginAccount, EWinWeb.MainCurrencyType, R.Message);
                                    }
                                } else {
                                    R.Result = EWin.Lobby.enumResult.ERR;
                                    R.Message = "Reset Failure : " + ResetResult.Message;

                                    ReportSystem.UserAccountPromotionCollect.CreateUserAccountPromotionCollect(Token, SI.LoginAccount, EWinWeb.MainCurrencyType, R.Message);
                                }
                            } else {
                                R.Result = EWin.Lobby.enumResult.ERR;
                                R.Message = "PointLimit";

                                ReportSystem.UserAccountPromotionCollect.CreateUserAccountPromotionCollect(Token, SI.LoginAccount, EWinWeb.MainCurrencyType, R.Message);
                            }

                        }
                    } else {
                        R.Message = "Not Search CollectID";
                        R.Result = EWin.Lobby.enumResult.ERR;
                    }

                } else {
                    R.Result = EWin.Lobby.enumResult.ERR;
                    R.Message = UserInfoResult.Message;

                    ReportSystem.UserAccountPromotionCollect.CreateUserAccountPromotionCollect(Token, SI.LoginAccount, EWinWeb.MainCurrencyType, R.Message);
                }
            } else {
                R.Message = "Not Search CollectID";
                R.Result = EWin.Lobby.enumResult.ERR;
            }
        } else {
            R.Message = "InvalidWebSID";
            R.Result = EWin.Lobby.enumResult.ERR;
        }
        return R;
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public OcwPromotionCollectHistoryResult GetPromotionCollectHistory(string WebSID, string GUID, string BeginDate, string EndDate) {
        EWin.Lobby.LobbyAPI lobbyAPI = new EWin.Lobby.LobbyAPI();
        RedisCache.SessionContext.SIDInfo SI;
        OcwPromotionCollectHistoryResult R = new OcwPromotionCollectHistoryResult() { CollectList = null, QueryBeginDate = BeginDate, QueryEndDate = EndDate, Result = EWin.Lobby.enumResult.ERR };

        SI = RedisCache.SessionContext.GetSIDInfo(WebSID);

        if (SI != null && !string.IsNullOrEmpty(SI.EWinSID)) {
            EWin.Lobby.PromotionCollectHistoryResult EWinReturn = lobbyAPI.GetPromotionCollectHistory(GetToken(), SI.EWinSID, GUID, DateTime.Parse(BeginDate), DateTime.Parse(EndDate));

            if (EWinReturn.Result == EWin.Lobby.enumResult.OK) {
                List<OcwPromotionCollect> collectList = new List<OcwPromotionCollect>();

                foreach (var item in EWinReturn.CollectList) {
                    OcwPromotionCollect PC = new OcwPromotionCollect() {

                        CollectID = item.CollectID,
                        CurrencyType = item.CurrencyType,
                        PromotionID = item.PromotionID,
                        PromotionDetailID = item.PromotionDetailID,
                        CollectAreaType = item.CollectAreaType,
                        Status = (OcwPromotionCollect.OcwEnumStatus)item.Status,
                        Description = item.Description,
                        ActionContent = item.ActionContent,
                        ExpireDate = item.ExpireDate,
                        CollectDate = item.CollectDate,
                        CreateDate = item.CreateDate
                    };

                    if (!string.IsNullOrEmpty(PC.ActionContent)) {
                        var obj_ActionContent = Newtonsoft.Json.Linq.JObject.Parse(PC.ActionContent);

                        List<OcwActionContentSet> actions = Newtonsoft.Json.JsonConvert.DeserializeObject<List<OcwActionContentSet>>(obj_ActionContent["ActionList"].ToString());

                        PC.PointValue = 0;

                        for (int i = 0; i < actions.Count; i++) {
                            if (actions[i].Field == "PointValue") {
                                PC.PointValue = decimal.Parse(actions[i].Value);
                            }
                        }
                    }

                    if (!string.IsNullOrEmpty(PC.Description)) {
                        var getTitleResult = ActivityCore.GetActInfo(PC.Description);

                        if (getTitleResult.Result == ActivityCore.enumActResult.OK) {
                            PC.PromotionTitle = getTitleResult.Data.Title;
                        }

                        //if (string.IsNullOrEmpty(PC.PromotionTitle)) {
                        //        PC.PromotionTitle = PC.Description;
                        //}
                    }

                    collectList.Add(PC);

                }

                R.Result = EWin.Lobby.enumResult.OK;
                R.CollectList = collectList.ToArray();

            } else {
                R.Result = EWin.Lobby.enumResult.ERR;
                R.Message = "NoData";
            }
        } else {
            R.Result = EWin.Lobby.enumResult.ERR;
            R.Message = "InvalidWebSID";
        }

        return R;
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public OcwPromotionCollectResult GetPromotionCollectAvailable(string WebSID, string GUID) {

        EWin.Lobby.LobbyAPI lobbyAPI = new EWin.Lobby.LobbyAPI();
        RedisCache.SessionContext.SIDInfo SI;
        OcwPromotionCollectResult R = new OcwPromotionCollectResult() { CollectList = null, Result = EWin.Lobby.enumResult.ERR };

        SI = RedisCache.SessionContext.GetSIDInfo(WebSID);

        if (SI != null && !string.IsNullOrEmpty(SI.EWinSID)) {
            EWin.Lobby.PromotionCollectResult EWinReturn = lobbyAPI.GetPromotionCollectAvailable(GetToken(), SI.EWinSID, GUID);

            if (EWinReturn.Result == EWin.Lobby.enumResult.OK) {
                List<OcwPromotionCollect> collectList = new List<OcwPromotionCollect>();

                foreach (var item in EWinReturn.CollectList) {
                    OcwPromotionCollect PC = new OcwPromotionCollect() {

                        CollectID = item.CollectID,
                        CurrencyType = item.CurrencyType,
                        PromotionID = item.PromotionID,
                        PromotionDetailID = item.PromotionDetailID,
                        CollectAreaType = item.CollectAreaType,
                        Status = (OcwPromotionCollect.OcwEnumStatus)item.Status,
                        Description = item.Description,
                        ActionContent = item.ActionContent,
                        ExpireDate = item.ExpireDate,
                        CollectDate = item.CollectDate,
                        CreateDate = item.CreateDate
                    };

                    if (!string.IsNullOrEmpty(PC.ActionContent)) {
                        var obj_ActionContent = Newtonsoft.Json.Linq.JObject.Parse(PC.ActionContent);

                        List<OcwActionContentSet> actions = Newtonsoft.Json.JsonConvert.DeserializeObject<List<OcwActionContentSet>>(obj_ActionContent["ActionList"].ToString());

                        PC.PointValue = 0;

                        for (int i = 0; i < actions.Count; i++) {
                            if (actions[i].Field == "PointValue") {
                                PC.PointValue = decimal.Parse(actions[i].Value);
                            }
                        }
                    }

                    if (!string.IsNullOrEmpty(PC.Description)) {
                        var getTitleResult = ActivityCore.GetActInfo(PC.Description);

                        if (getTitleResult.Result == ActivityCore.enumActResult.OK) {
                            PC.PromotionTitle = getTitleResult.Data.Title;
                        }

                        //if (string.IsNullOrEmpty(PC.PromotionTitle)) {
                        //    PC.PromotionTitle = PC.Description;
                        //}
                    }

                    collectList.Add(PC);

                }

                R.Result = EWin.Lobby.enumResult.OK;
                R.CollectList = collectList.OrderByDescending(o=>o.CreateDate).ToArray();

            } else {
                R.Result = EWin.Lobby.enumResult.ERR;
                R.Message = "NoData";
            }
        } else {
            R.Result = EWin.Lobby.enumResult.ERR;
            R.Message = "InvalidWebSID";
        }

        return R;
    }

    #endregion

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public UserTwoMonthSummaryResult GetUserTwoMonthSummaryData(string WebSID, string GUID) {
        EWin.OCW.OCW OCWAPI = new EWin.OCW.OCW();
        EWin.Lobby.LobbyAPI lobbyAPI = new EWin.Lobby.LobbyAPI();
        RedisCache.SessionContext.SIDInfo SI;
        UserTwoMonthSummaryResult R = new UserTwoMonthSummaryResult() { PaymentResult = null, GameResult = null, Result = EWin.Lobby.enumResult.ERR };
        System.Data.DataTable PaymentDT;
        EWin.Lobby.OrderSummaryResult GameRet = new EWin.Lobby.OrderSummaryResult();
        List<UserTwoMonthSummaryResult.Payment> PaymentResult = new List<UserTwoMonthSummaryResult.Payment>();
        UserTwoMonthSummaryResult.Payment P = new UserTwoMonthSummaryResult.Payment();
        List<UserTwoMonthSummaryResult.Game> GameResult = new List<UserTwoMonthSummaryResult.Game>();
        UserTwoMonthSummaryResult.Game G = new UserTwoMonthSummaryResult.Game();

        SI = RedisCache.SessionContext.GetSIDInfo(WebSID);

        if (SI != null && !string.IsNullOrEmpty(SI.EWinSID)) {
            var pre = DateTime.Now.AddMonths(-1).ToString("yyyy-MM") + "-01";
            var now = DateTime.Now.ToString("yyyy-MM") + "-01";
            var next = DateTime.Now.AddMonths(1).ToString("yyyy-MM") + "-01";

            for (int i = 0; i < 2; i++) {
                PaymentDT = null;
                GameRet = new EWin.Lobby.OrderSummaryResult();
                if (i == 0) {
                    PaymentDT = EWinWebDB.UserAccountSummary.GetUserAccountPaymentSummaryData(SI.LoginAccount, pre, now);
                    GameRet = lobbyAPI.GetGameOrderSummaryHistory(GetToken(), SI.EWinSID, GUID, pre, now);
                } else {
                    PaymentDT = EWinWebDB.UserAccountSummary.GetUserAccountPaymentSummaryData(SI.LoginAccount, now, next);
                    GameRet = lobbyAPI.GetGameOrderSummaryHistory(GetToken(), SI.EWinSID, GUID, now, next);
                }

                if (PaymentDT != null) {
                    if (PaymentDT.Rows.Count > 0) {
                        P = new UserTwoMonthSummaryResult.Payment();
                        P.SortIndex = i;
                        P.DepositAmount = (decimal)PaymentDT.Rows[0]["DepositAmount"];
                        P.WithdrawalAmount = (decimal)PaymentDT.Rows[0]["WithdrawalAmount"];
                    } else {
                        P = new UserTwoMonthSummaryResult.Payment();
                        P.SortIndex = i;
                        P.DepositAmount = 0;
                        P.WithdrawalAmount = 0;
                    }
                } else {
                    P = new UserTwoMonthSummaryResult.Payment();
                    P.SortIndex = i;
                    P.DepositAmount = 0;
                    P.WithdrawalAmount = 0;
                }

                PaymentResult.Add(P);

                if (GameRet.Result == EWin.Lobby.enumResult.OK) {
                    if (GameRet.SummaryList.Length > 0) {
                        G = GameRet.SummaryList.GroupBy(x => new { x.CurrencyType }, x => x, (key, sum) => new UserTwoMonthSummaryResult.Game {
                            ValidBetValue = sum.Sum(y => y.ValidBetValue),
                            RewardValue = sum.Sum(y => y.RewardValue),
                            OrderValue = sum.Sum(y => y.OrderValue),
                            SortIndex = i
                        }).ToList().FirstOrDefault();
                    } else {
                        G = new UserTwoMonthSummaryResult.Game();
                        G.SortIndex = i;
                        G.OrderValue = 0;
                        G.ValidBetValue = 0;
                        G.RewardValue = 0;
                    }
                } else {
                    G = new UserTwoMonthSummaryResult.Game();
                    G.SortIndex = i;
                    G.OrderValue = 0;
                    G.ValidBetValue = 0;
                    G.RewardValue = 0;
                }
                GameResult.Add(G);
            }

            R.Result = EWin.Lobby.enumResult.OK;
            R.PaymentResult = PaymentResult;
            R.GameResult = GameResult;
        } else {
            R.Result = EWin.Lobby.enumResult.ERR;
            R.Message = "InvalidWebSID";
        }

        return R;
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public EWin.Lobby.GameBrandResult GetGameBrand(string GUID) {
        EWin.Lobby.LobbyAPI lobbyAPI = new EWin.Lobby.LobbyAPI();
        var a = lobbyAPI.GetGameBrand(GetToken(), GUID);
        return a;
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public EWin.Lobby.DocumentListResult CheckDocumentByTagName(string GUID,string TagName) {
        EWin.Lobby.LobbyAPI lobbyAPI = new EWin.Lobby.LobbyAPI();
        var a = lobbyAPI.CheckDocumentByTagName(GetToken(), GUID,TagName);
        return a;
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public EWin.FANTA.AgentAccountingResult GetAccountingDetailBySummaryDate(string WebSID, string GUID, string StartDate, string EndDate) {
        EWin.FANTA.FANTA fantaAPI = new EWin.FANTA.FANTA();
        EWin.FANTA.AgentAccountingResult callResult = new EWin.FANTA.AgentAccountingResult();
        EWin.FANTA.AgentAccountingResult R;
        RedisCache.SessionContext.SIDInfo SI;

        SI = RedisCache.SessionContext.GetSIDInfo(WebSID);

        if (SI != null && !string.IsNullOrEmpty(SI.EWinSID)) {
            R = fantaAPI.GetAccountingDetailBySummaryDate(GetToken(), SI.EWinSID, GUID, StartDate, EndDate);

        } else {
            R = new EWin.FANTA.AgentAccountingResult() {
                ResultState = EWin.FANTA.enumResultState.ERR,
                Message = "InvalidWebSID"
            };
        }

        return R;
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public EWin.FANTA.ChildUserResult GetChildUserBySID(string WebSID, string GUID) {
        EWin.FANTA.FANTA fantaAPI = new EWin.FANTA.FANTA();
        EWin.FANTA.ChildUserResult callResult = new EWin.FANTA.ChildUserResult();
        EWin.FANTA.ChildUserResult R = new EWin.FANTA.ChildUserResult() {
            ResultState =  EWin.FANTA.enumResultState.ERR
        };
        RedisCache.SessionContext.SIDInfo SI;
        string strUserAccountChild = string.Empty;

        SI = RedisCache.SessionContext.GetSIDInfo(WebSID);

        if (SI != null && !string.IsNullOrEmpty(SI.EWinSID)) {

            strUserAccountChild = RedisCache.UserAccountChild.GetUserAccountChildByLoginAccount(SI.LoginAccount);

            if (string.IsNullOrEmpty(strUserAccountChild)) {
                R = fantaAPI.GetChildUserBySID(GetToken(), SI.EWinSID, GUID);
                RedisCache.UserAccountChild.UpdateUserAccountChild(R.ChildUserList, SI.LoginAccount);
            } else {
                R.ResultState = EWin.FANTA.enumResultState.OK;
                R.ChildUserList = strUserAccountChild;
            }

        } else {
            R = new EWin.FANTA.ChildUserResult() {
                ResultState = EWin.FANTA.enumResultState.ERR,
                Message = "InvalidWebSID"
            };
        }

        return R;
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public UserAccountTotalSummaryResult GetTotalSummaryBySID(string WebSID, string GUID) {
        UserAccountTotalSummaryResult R = new UserAccountTotalSummaryResult() { Datas = new List<UserAccountTotalSummary>(), Result = EWin.Lobby.enumResult.ERR , GUID = GUID };
        System.Data.DataTable DT;
        RedisCache.SessionContext.SIDInfo SI;

        SI = RedisCache.SessionContext.GetSIDInfo(WebSID);

        if (SI != null && !string.IsNullOrEmpty(SI.EWinSID)) {

            DT = RedisCache.UserAccountTotalSummary.GetUserAccountTotalSummaryByLoginAccount(SI.LoginAccount);

            if (DT != null && DT.Rows.Count > 0) {
                for (int i = 0; i < DT.Rows.Count; i++) {
                    var data = new UserAccountTotalSummary();

                    data.LoginAccount = (string)DT.Rows[i]["LoginAccount"];
                    data.DepositCount = (int)DT.Rows[i]["DepositCount"];
                    data.DepositRealAmount = (decimal)DT.Rows[i]["DepositRealAmount"];
                    data.DepositAmount = (decimal)DT.Rows[i]["DepositAmount"];
                    data.WithdrawalCount = (int)DT.Rows[i]["WithdrawalCount"];
                    data.WithdrawalRealAmount = (decimal)DT.Rows[i]["WithdrawalRealAmount"];
                    data.WithdrawalAmount = (decimal)DT.Rows[i]["WithdrawalAmount"];
                    data.LastDepositDate = (DateTime)DT.Rows[i]["LastDepositDate"];
                    data.LastWithdrawalDate = (DateTime)DT.Rows[i]["LastWithdrawalDate"];
                    data.FingerPrints = (string)DT.Rows[i]["FingerPrints"];
                    R.Datas.Add(data);

                }
            }

            if (R.Datas.Count > 0) {
                R.Result = (int)EWin.Lobby.enumResult.OK;
            } else {
                R.Result = EWin.Lobby.enumResult.ERR;
                R.Message = "NoData";
            }
        } else {
            R.Result = EWin.Lobby.enumResult.ERR;
            R.Message = "InvalidWebSID";
        }

        return R;
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public UserVIPResult GetUserVIPData(string WebSID, string GUID) {
        UserVIPResult R = new UserVIPResult() { Result = EWin.Lobby.enumResult.ERR, Data = new UserVIPResult.UserVIPInfo() };
        UserVIPResult.UserVIPInfo k = new UserVIPResult.UserVIPInfo();
        RedisCache.SessionContext.SIDInfo SI;
        System.Data.DataTable UserLevDT = new System.Data.DataTable();
        System.Data.DataTable DT = new System.Data.DataTable();
        Newtonsoft.Json.Linq.JObject VIPSetting;
        Newtonsoft.Json.Linq.JArray VIPSettingDetail;
        int UserLevelIndex = 0;
        int UserNextLevelIndex = 0;
        int KeepLevelDays = 30;
        int Setting_UserLevelIndex = 0;
        decimal DeposiAmount = 0;
        decimal ValidBetValue = 0;
        DateTime UserLevelUpdateDate = DateTime.Now;
        string RedisVIPInfo = string.Empty;

        SI = RedisCache.SessionContext.GetSIDInfo(WebSID);

        if (SI != null && !string.IsNullOrEmpty(SI.EWinSID)) {

            RedisVIPInfo = RedisCache.UserAccountVIPInfo.GetUserAccountVIPInfo(SI.LoginAccount);

            if (string.IsNullOrEmpty(RedisVIPInfo)) {
                VIPSetting = GetActivityDetail("../App_Data/VIPSetting.json");

                if (VIPSetting != null) {
                    VIPSettingDetail = Newtonsoft.Json.Linq.JArray.Parse(VIPSetting["VIPSetting"].ToString());
                    KeepLevelDays = (int)VIPSetting["KeepLevelDays"];

                    UserLevDT = RedisCache.UserAccountLevel.GetUserAccountLevelByLoginAccount(SI.LoginAccount);
                    if (UserLevDT != null) {
                        if (UserLevDT.Rows.Count > 0) {
                            UserLevelIndex = (int)UserLevDT.Rows[0]["UserLevelIndex"];
                            UserLevelUpdateDate = (DateTime)UserLevDT.Rows[0]["UserLevelUpdateDate"];
                        }
                    }

                    UserNextLevelIndex = UserLevelIndex + 1;

                    for (int i = UserLevelIndex; i < VIPSettingDetail.Count; i++) {
                        Setting_UserLevelIndex = (int)VIPSettingDetail[i]["UserLevelIndex"];

                        //當前等級資訊
                        if (UserLevelIndex == Setting_UserLevelIndex) {
                            k.VIPDescription = (string)VIPSettingDetail[i]["Description"];
                            k.DepositMaxValue = (decimal)VIPSettingDetail[i]["DepositMaxValue"];
                            k.KeepValidBetValue = (decimal)VIPSettingDetail[i]["KeepValidBetValue"];
                            k.ValidBetMaxValue = (decimal)VIPSettingDetail[i]["ValidBetMaxValue"];
                        }

                        if (UserNextLevelIndex == Setting_UserLevelIndex) {
                            k.NextVIPDescription = (string)VIPSettingDetail[i]["Description"];
                        }
                        //已達到最高等級
                        if (UserNextLevelIndex == VIPSettingDetail.Count - 1) {
                            k.NextVIPDescription = (string)VIPSettingDetail[i]["Description"];
                        }
                    }

                    DT = EWinWebDB.UserAccountSummary.GetUserAccountTotalValueSummaryData(SI.LoginAccount, UserLevelUpdateDate.ToString("yyyy/MM/dd"), UserLevelUpdateDate.AddDays(KeepLevelDays).ToString("yyyy/MM/dd"));
                    if (DT != null) {
                        if (DT.Rows.Count > 0) {
                            ValidBetValue = (decimal)DT.Rows[0]["ValidBetValue"];
                            DeposiAmount = (decimal)DT.Rows[0]["DepositAmount"];
                        }
                    }

                    double UserLevelUpdatedays = DateTime.Now.Date.Subtract(UserLevelUpdateDate).TotalDays;

                    k.UserLevelIndex = UserLevelIndex;
                    k.KeepLevelDays = KeepLevelDays;
                    k.ValidBetValue = ValidBetValue;
                    k.DepositValue = DeposiAmount;
                    k.ElapsedDays = (int)UserLevelUpdatedays;

                    R.Data = k;
                    R.Result = EWin.Lobby.enumResult.OK;

                    RedisCache.UserAccountVIPInfo.UpdateUserAccountVIPInfo(Newtonsoft.Json.JsonConvert.SerializeObject(k), SI.LoginAccount);
                } else {
                    R.Result = EWin.Lobby.enumResult.ERR;
                    R.Message = "InvalidVIPSetting";
                }
            } else {
                R.Data = Newtonsoft.Json.JsonConvert.DeserializeObject<UserVIPResult.UserVIPInfo>(RedisVIPInfo);
                R.Result = EWin.Lobby.enumResult.OK;
            }
        } else {
            R.Result = EWin.Lobby.enumResult.ERR;
            R.Message = "InvalidWebSID";
        }
        return R;
    }

    private static Newtonsoft.Json.Linq.JObject GetActivityDetail(string Path) {
        Newtonsoft.Json.Linq.JObject o = null;
        string Filename;

        Filename = HttpContext.Current.Server.MapPath(Path);

        if (System.IO.File.Exists(Filename)) {
            string SettingContent;

            SettingContent = System.IO.File.ReadAllText(Filename);

            if (string.IsNullOrEmpty(SettingContent) == false) {
                try { o = Newtonsoft.Json.Linq.JObject.Parse(SettingContent); } catch (Exception ex) { }
            }
        }

        return o;
    }

    public class UserTwoMonthSummaryResult : EWin.Lobby.APIResult {
        public List<Payment> PaymentResult { get; set; }
        public List<Game> GameResult { get; set; }

        public class Payment {
            public int SortIndex { get; set; }
            public decimal DepositAmount { get; set; }
            public decimal WithdrawalAmount { get; set; }
        }

        public class Game {
            public int SortIndex { get; set; }
            public decimal OrderValue { get; set; }
            public decimal ValidBetValue { get; set; }
            public decimal RewardValue { get; set; }
        }
    }


    private string GetToken() {
        string Token;
        int RValue;
        Random R = new Random();
        RValue = R.Next(100000, 9999999);
        Token = EWinWeb.CreateToken(EWinWeb.PrivateKey, EWinWeb.APIKey, RValue.ToString());

        return Token;
    }

    public class OcwBulletinBoardResult : EWin.Lobby.APIResult {
        public List<OcwBulletinBoard> Datas { get; set; }
    }

    public class OcwBulletinBoard {
        public int BulletinBoardID { get; set; }
        public string BulletinTitle { get; set; }
        public string BulletinContent { get; set; }
        public DateTime CreateDate { get; set; }
        public int State { get; set; }
    }

    public class OcwCompanyGameCodeResult : EWin.Lobby.APIResult {
        public int MaxGameID { get; set; }
        public long TimeStamp { get; set; }
        public List<OcwCompanyCategory> CompanyCategoryDatas { get; set; }
    }

    public class OcwCompanyCategoryGameCodeResult : EWin.Lobby.APIResult {
        public List<GroupOcwCompanyCategoryGameCode> LobbyGameList { get; set; }
    }

    public class GroupOcwCompanyCategoryGameCode {
        public List<OcwCompanyCategorysGameCode> Categories { get; set; }
        public string Location { get; set; }
    }

    public class OcwAllCompanyGameCodeResult : EWin.Lobby.APIResult {
        public List<OcwCompanyGameCode> Datas { get; set; }
        public int MaxGameID { get; set; }
        public long TimeStamp { get; set; }
    }

    public class OcwCompanyCategorysGameCode {
        public int CompanyCategoryID { get; set; }
        public int State { get; set; }
        public int SortIndex { get; set; }
        public string CategoryName { get; set; }
        public string Location { get; set; }
        public int ShowType { get; set; }
        public List<OcwCompanyCategoryGameCode> Datas { get; set; }
    }

    public class OcwCompanyCategoryGameCode
    {
        public int forCompanyCategoryID { get; set; }
        public string GameCode { get; set; }
        public int SortIndex { get; set; }
    }

    public class OcwCompanyCategory {
        public int CompanyCategoryID { get; set; }
        public int State { get; set; }
        public int SortIndex { get; set; }
        public string CategoryName { get; set; }
        public string Location { get; set; }
        public int ShowType { get; set; }
        public List<OcwCompanyGameCode> Datas { get; set; }
    }

    public class OcwCompanyGameCode {
        public int forCompanyCategoryID { get; set; }
        public int GameID { get; set; }
        public string GameCode { get; set; }
        public string GameBrand { get; set; }
        public string GameName { get; set; }
        public string GameCategoryCode { get; set; }
        public string GameCategorySubCode { get; set; }
        public int AllowDemoPlay { get; set; }
        public string RTPInfo { get; set; }
        public string Info { get; set; }
        public int IsHot { get; set; }
        public int IsNew { get; set; }
        public int SortIndex { get; set; }
        public string Tag { get; set; }
    }

    public class OcwLoginMessageResult : EWin.Lobby.APIResult {
        public string Title { get; set; }
        public string Version { get; set; }
    }

    public class OcwPromotionCollectHistoryResult : EWin.Lobby.APIResult {
        public string QueryBeginDate { get; set; }
        public string QueryEndDate { get; set; }
        public OcwPromotionCollect[] CollectList { get; set; }
    }

    public class OcwPromotionCollectResult : EWin.Lobby.APIResult {
        public OcwPromotionCollect[] CollectList { get; set; }
    }

    public class OcwPromotionCollect {
        //0=尚未領取/1=已領取/2=已過期
        public enum OcwEnumStatus {
            None = 0,
            Taked = 1,
            Expire = 2
        }

        public int CollectID { get; set; }
        public string CurrencyType { get; set; }
        public int PromotionID { get; set; }
        public int PromotionDetailID { get; set; }
        public int CollectAreaType { get; set; }
        public OcwEnumStatus Status { get; set; }
        public string Description { get; set; }
        public string ActionContent { get; set; }
        public string ExpireDate { get; set; }
        public string CollectDate { get; set; }
        public string CreateDate { get; set; }
        public decimal PointValue { get; set; }
        public string PromotionTitle { get; set; }
    }

    public class CompanyGameCodeResult : EWin.Lobby.APIResult {
        public CompanyGameCode Data{ get; set; }
    }

    public class CompanyGameCode
    {
        public string GameCode { get; set; }
        public int SortIndex { get; set; }
        public int GameID { get; set; }
        public string GameBrand { get; set; }
        public string GameName { get; set; }
        public string GameCategoryCode { get; set; }
        public string GameCategorySubCode { get; set; }
        public int AllowDemoPlay { get; set; }
        public string RTPInfo { get; set; }
        public int IsNew { get; set; }
        public int IsHot { get; set; }
        public string Tags { get; set; }
        public string Language { get; set; }
        public string GameAccountingCode { get; set; }
        public int GameStatus{ get; set; }

    }

    public class OcwPropertySet {
        public string Name { get; set; }
        public string Value { get; set; }
    }

    public class OcwActionContentSet {
        public string Field { get; set; }
        public string Value { get; set; }
    }

    public class UserAccountEventSummaryResult : EWin.Lobby.APIResult {
        public List<UserAccountEventSummary> Datas { get; set; }
    }

    public class UserAccountEventSummary {
        public string LoginAccount { get; set; }
        public string ActivityName { get; set; }
        public int CollectCount { get; set; }
        public int JoinCount { get; set; }
        public decimal ThresholdValue { get; set; }
        public decimal BonusValue { get; set; }
    }

    public class UserAccountThisWeekTotalValidBetValueResult : EWin.Lobby.APIResult {
        public List<UserAccountThisWeekTotalValidBetValue> Datas { get; set; }
    }

    public class UserAccountThisWeekTotalValidBetValue {
        public string Date { get; set; }
        public decimal TotalValidBetValue { get; set; }
        public int Status { get; set; }
    }

    public class UserAccountTotalSummaryResult : EWin.Lobby.APIResult {
        public List<UserAccountTotalSummary> Datas { get; set; }
    }

    public class UserAccountTotalSummary {
        public string LoginAccount { get; set; }
        public int DepositCount { get; set; }
        public decimal DepositRealAmount { get; set; }
        public decimal DepositAmount { get; set; }
        public int WithdrawalCount { get; set; }
        public decimal WithdrawalRealAmount { get; set; }
        public decimal WithdrawalAmount { get; set; }
        public DateTime LastDepositDate { get; set; }
        public DateTime LastWithdrawalDate { get; set; }
        public string FingerPrints { get; set; }
    }

    public class UserVIPResult : EWin.Lobby.APIResult {
        public UserVIPInfo Data { get; set; }

        public class UserVIPInfo {
            public int UserLevelIndex { get; set; }
            public string VIPDescription { get; set; }
            public string NextVIPDescription { get; set; }
            public int ElapsedDays { get; set; } //保級流水計算時間 (10/30天) => 10
            public int KeepLevelDays { get; set; } //保級流水計算時間 (10/30天) => 30
            public decimal DepositValue { get; set; }
            public decimal DepositMaxValue { get; set; }
            public decimal ValidBetValue { get; set; }
            public decimal ValidBetMaxValue { get; set; }
            public decimal KeepValidBetValue { get; set; }
        }
    }
}