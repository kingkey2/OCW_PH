using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Script.Services;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Backend_ManualUserLevelAdjust : System.Web.UI.Page {

    protected void Page_Load(object sender, EventArgs e) {
       
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static APIResult ManualUserLevelAdjust(string LoginAccount, int NewUserLevelIndex,string ASID) {
        APIResult R = new APIResult() { Result = enumResult.ERR };

        if (!string.IsNullOrEmpty(ASID)) {
            //確認權限
            EWin.GlobalPermissionAPI.GlobalPermissionAPI GApi = new EWin.GlobalPermissionAPI.GlobalPermissionAPI();
            EWin.GlobalPermissionAPI.APIResult GR = new EWin.GlobalPermissionAPI.APIResult();

            GR = GApi.CheckPermission(ASID, EWinWeb.CompanyCode, "ManualUserLevelAdjust", "ManualUserLevelAdjust", "");

            if (GR.Result ==  EWin.GlobalPermissionAPI.enumResult.OK) {
                JObject VIPSetting;
                JArray VIPSettingDetail;
                int ActivityState = 1;
                int KeepLevelDays = 30;
                DateTime ActivityStartDate;
                DateTime ActivityEndDate;
                int UserLevelIndex_Now = 0;
                System.Data.DataTable UTSDT = new System.Data.DataTable();
                System.Data.DataTable DT = new System.Data.DataTable();
                System.Data.DataTable DT1 = new System.Data.DataTable();
                System.Data.DataTable UserLevDT = new System.Data.DataTable();
                decimal ValidBetValue = 0;
                decimal DeposiAmount = 0;

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
                                ValidBetValue = (decimal)DT.Rows[0]["ValidBetValue"];
                                DeposiAmount = (decimal)DT.Rows[0]["DepositAmount"];

                                if (UserLevelIndex_Now != NewUserLevelIndex) {
                                    updateEwinUserLevelInfo(LoginAccount, NewUserLevelIndex);
                                    EWinWebDB.UserAccount.UpdateUserAccountLevel(NewUserLevelIndex, LoginAccount, DateTime.Now.ToString("yyyy/MM/dd HH:mm:ss"));
                                    EWinWebDB.UserAccountLevelLog.InsertUserAccountLevelLog(LoginAccount, 1, UserLevelIndex_Now, NewUserLevelIndex, DeposiAmount, ValidBetValue, "ManualAdjustUserLevel");
                                    //發升級禮物
                                    if (NewUserLevelIndex > UserLevelIndex_Now) {
                                        for (int i = 1; i <= NewUserLevelIndex - UserLevelIndex_Now; i++) {
                                            SendUpgradeGiftByUserLevelIndex(LoginAccount, UserLevelIndex_Now + i);
                                        }
                                    }
                                }
                            }

                            RedisCache.UserAccount.UpdateUserAccountByLoginAccount(LoginAccount);
                            RedisCache.UserAccountVIPInfo.DeleteUserAccountVIPInfo(LoginAccount);

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
                return R;
            } else {
                SetResultException(R, "NoPermissions");
                return R;
            }

        } else {
            SetResultException(R, "NoPermissions");
            return R;
        }
    }

    private static void updateEwinUserLevelInfo(string LoginAccount, int UserLevelIndex) {
        updateEwinUserLevel(LoginAccount, UserLevelIndex);
        setUserAccountProperty(LoginAccount, System.Guid.NewGuid().ToString(), "UserLevelUpdateDate", DateTime.Now.ToString("yyyy/MM/dd"));
    }

    private static EWin.FANTA.APIResult updateEwinUserLevel(string LoginAccount, int UserLevelIndex) {
        EWin.FANTA.APIResult R = new EWin.FANTA.APIResult();
        EWin.FANTA.FANTA API = new EWin.FANTA.FANTA();

        R = API.UpdateUserLevel(GetToken(), LoginAccount, UserLevelIndex);

        return R;
    }

    private static EWin.Lobby.APIResult setUserAccountProperty(string LoginAccount, string GUID, string PropertyName, string PropertyValue) {
        EWin.Lobby.LobbyAPI lobbyAPI = new EWin.Lobby.LobbyAPI();
        EWin.Lobby.APIResult R = new EWin.Lobby.APIResult();

        R = lobbyAPI.SetUserAccountProperty(GetToken(), GUID, EWin.Lobby.enumUserTypeParam.ByLoginAccount, LoginAccount, PropertyName, PropertyValue);

        return R;
    }

    private static void SendUpgradeGiftByUserLevelIndex(string LoginAccount, int UserLevelIndex) {
        System.Data.DataTable DT;
        string ActivityName = string.Empty;
        JObject ActivityDetail;
        EWin.Lobby.LobbyAPI lobbyAPI = new EWin.Lobby.LobbyAPI();
        ActivityDetail = GetActivityDetail("/App_Data/ActivityDetail/VIPSetting/VIPLev" + UserLevelIndex + ".json");
        if (ActivityDetail != null) {
            ActivityName = (string)ActivityDetail["Name"];

            DT = RedisCache.UserAccountEventSummary.GetUserAccountEventSummaryByLoginAccountAndActivityName(LoginAccount, ActivityName);

            if (DT != null && DT.Rows.Count > 0) {

            } else {
                List<EWin.Lobby.PropertySet> PropertySets = new List<EWin.Lobby.PropertySet>();

                string description = ActivityDetail["Name"].ToString();
                decimal ThresholdValue = (decimal)ActivityDetail["ThresholdValue"];
                decimal BonusValue = (decimal)ActivityDetail["BonusValue"];
                string JoinActivityCycle = "1";
                string PromotionCode = "VIPLev";
                string PromotionCategoryCode = "";
                string CollectAreaType = ActivityDetail["CollectAreaType"].ToString() == null ? "2" : ActivityDetail["CollectAreaType"].ToString();

                PropertySets.Add(new EWin.Lobby.PropertySet { Name = "ThresholdValue", Value = ThresholdValue.ToString() });
                PropertySets.Add(new EWin.Lobby.PropertySet { Name = "PointValue", Value = BonusValue.ToString() });

                lobbyAPI.AddPromotionCollect(GetToken(), description + "_" + LoginAccount + "_UpgradeGift", LoginAccount, EWinWeb.MainCurrencyType, PromotionCode, PromotionCategoryCode, int.Parse(CollectAreaType), 90, description, PropertySets.ToArray());
                EWinWebDB.UserAccountEventSummary.UpdateUserAccountEventSummary(LoginAccount, description, JoinActivityCycle, 1, ThresholdValue, BonusValue);
            }
        }
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

    public static string GetToken() {
        string Token;
        int RValue;
        Random R = new Random();
        RValue = R.Next(100000, 9999999);
        Token = EWinWeb.CreateToken(EWinWeb.PrivateKey, EWinWeb.APIKey, RValue.ToString());

        return Token;
    }

    private static void SetResultException(APIResult R, string Msg) {
        if (R != null) {
            R.Result = enumResult.ERR;
            R.Message = Msg;
        }
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

}