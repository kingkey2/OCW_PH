using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Script.Services;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Backend_ForegroundOperation : System.Web.UI.Page {
    protected void Page_Load(object sender, EventArgs e) {

    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static EWin.Lobby.APIResult UpdateCompanyCategory() {
        EWin.Lobby.APIResult R = new EWin.Lobby.APIResult() { Result = EWin.Lobby.enumResult.ERR };
        EWin.Lobby.CompanyGameCodeResult companyGameCodeResult;
        EWin.Lobby.CompanyCategoryResult companyCategoryResult;
        EWin.Lobby.CompanyCategoryResult OCWcompanyCategoryResult = new EWin.Lobby.CompanyCategoryResult();
        EWin.Lobby.CompanyCategoryResult OCWcompanyStatisticsCategoryResult = new EWin.Lobby.CompanyCategoryResult();
        EWin.Lobby.LobbyAPI lobbyAPI = new EWin.Lobby.LobbyAPI();
        EWin.Lobby.GameCodeRTPResult gameCodeRTPResult;
        List<EWin.Lobby.GameCodeRTP> day3_gameCodeRTP;
        List<EWin.Lobby.GameCodeRTP> month1_gameCodeRTP;
        List<EWin.Lobby.GameCodeRTP> day7_gameCodeRTP;
        List<EWin.Lobby.GameCodeRTP> yesterday_gameCodeRTP;
        int SlotMaxBetCount3DayCategoryID = 0;
        int SlotMaxBetCount30DayCategoryID = 0;
        int SlotMaxWinValue7DayCategoryID = 0;
        int SlotMaxWinValueYesterdayCategoryID = 0;
        int SlotMaxWinRate7DayCategoryID = 0;
        int SlotMaxWinRateYesterdayCategoryID = 0;
        int SlotMaxRTPYesterdayCategoryID = 0;
        Newtonsoft.Json.Linq.JObject SettingData;
        long UpdateTimestamp = 0;
        int GameID = 0;
        string GameCode = "";
        int SortIndex;
        System.Data.DataTable CompanyCategoryDT = null;
        System.Data.DataRow[] CustomizeCompanyCategoryRows = null;
        int InsertCompanyCategoryReturn;
        int CompanyCategoryID = 0;
        string[] companyCategoryTags;
        System.Data.DataRow[] CompanyCategoryRow;
        string Location = "";
        List<OcwCompanyGameCode> AllGameCodeData = new List<OcwCompanyGameCode>();
        int ShowType = 0;
        List<CompanyCategoryByStatistics> SlotMaxBetCount3DayResult = new List<CompanyCategoryByStatistics>();
        List<CompanyCategoryByStatistics> SlotMaxBetCount30DayResult = new List<CompanyCategoryByStatistics>();
        List<CompanyCategoryByStatistics> SlotMaxWinValue7DayResult = new List<CompanyCategoryByStatistics>();
        List<CompanyCategoryByStatistics> SlotMaxWinValueYesterdayResult = new List<CompanyCategoryByStatistics>();
        List<CompanyCategoryByStatistics> SlotMaxWinRate7DayResult = new List<CompanyCategoryByStatistics>();
        List<CompanyCategoryByStatistics> SlotMaxWinRateYesterdayResult = new List<CompanyCategoryByStatistics>();
        List<CompanyCategoryByStatistics> SlotMaxRTPYesterdayResult = new List<CompanyCategoryByStatistics>();
        Dictionary<int, int> CategoryGameCodeCount = new Dictionary<int, int>();

        SettingData = EWinWeb.GetCompanyGameCodeSettingJObj();
        //if (true) {
        CompanyCategoryDT = RedisCache.CompanyCategory.GetCompanyCategory();

        #region 統計值
        if (SettingData["LastSyncStatisticsByDay"].ToString() != DateTime.Now.ToString("yyyy/MM/dd")) {
            SettingData["LastSyncStatisticsByDay"] = DateTime.Now.ToString("yyyy/MM/dd");
            Location = "GameList_Slot";
            ShowType = 0;

            OCWcompanyStatisticsCategoryResult.CategoryList = new EWin.Lobby.CompanyCategory[] { new EWin.Lobby.CompanyCategory() {
        CategoryName = "SlotMaxBetCount3Day",CompanyCategoryID = 0,SortIndex = 77
        },new EWin.Lobby.CompanyCategory() {
        CategoryName = "SlotMaxBetCount30Day",CompanyCategoryID = 0,SortIndex = 75
        },new EWin.Lobby.CompanyCategory() {
        CategoryName = "SlotMaxWinValue7Day",CompanyCategoryID = 0,SortIndex =74
        },new EWin.Lobby.CompanyCategory() {
        CategoryName = "SlotMaxWinValueYesterday",CompanyCategoryID = 0,SortIndex = 71
        },new EWin.Lobby.CompanyCategory() {
        CategoryName = "SlotMaxWinRate7Day",CompanyCategoryID = 0,SortIndex = 73
        },new EWin.Lobby.CompanyCategory() {
        CategoryName = "SlotMaxWinRateYesterday",CompanyCategoryID = 0,SortIndex = 70
        },new EWin.Lobby.CompanyCategory() {
        CategoryName = "SlotMaxRTPYesterday",CompanyCategoryID = 0,SortIndex = 69
        }};

            for (int i = 0; i < OCWcompanyStatisticsCategoryResult.CategoryList.Length; i++) {
                var StatisticsCategoryDT = CompanyCategoryDT.Select("CategoryName='" + OCWcompanyStatisticsCategoryResult.CategoryList[i].CategoryName + "' And CategoryType=1");
                if (StatisticsCategoryDT.Length == 0) {
                    InsertCompanyCategoryReturn = EWinWebDB.CompanyCategory.InsertOcwCompanyCategory(OCWcompanyStatisticsCategoryResult.CategoryList[i].CompanyCategoryID, 1, OCWcompanyStatisticsCategoryResult.CategoryList[i].CategoryName, OCWcompanyStatisticsCategoryResult.CategoryList[i].SortIndex, 0, Location, ShowType);
                    if (InsertCompanyCategoryReturn > 0) {
                        CompanyCategoryDT = RedisCache.CompanyCategory.GetCompanyCategory();
                    }
                } else {
                    InsertCompanyCategoryReturn = EWinWebDB.CompanyCategory.UpdateOcwCompanyCategory((int)StatisticsCategoryDT.FirstOrDefault()["CompanyCategoryID"], 1, OCWcompanyStatisticsCategoryResult.CategoryList[i].CategoryName, OCWcompanyStatisticsCategoryResult.CategoryList[i].SortIndex, 0, Location, ShowType);
                    if (InsertCompanyCategoryReturn > 0) {
                        CompanyCategoryDT = RedisCache.CompanyCategory.GetCompanyCategory();
                    }
                }
            }

            SlotMaxBetCount3DayCategoryID = (int)CompanyCategoryDT.Select("CategoryName='" + "SlotMaxBetCount3Day" + "' And CategoryType=1")[0]["CompanyCategoryID"];
            SlotMaxBetCount30DayCategoryID = (int)CompanyCategoryDT.Select("CategoryName='" + "SlotMaxBetCount30Day" + "' And CategoryType=1")[0]["CompanyCategoryID"];
            SlotMaxWinValue7DayCategoryID = (int)CompanyCategoryDT.Select("CategoryName='" + "SlotMaxWinValue7Day" + "' And CategoryType=1")[0]["CompanyCategoryID"];
            SlotMaxWinValueYesterdayCategoryID = (int)CompanyCategoryDT.Select("CategoryName='" + "SlotMaxWinValueYesterday" + "' And CategoryType=1")[0]["CompanyCategoryID"];
            SlotMaxWinRate7DayCategoryID = (int)CompanyCategoryDT.Select("CategoryName='" + "SlotMaxWinRate7Day" + "' And CategoryType=1")[0]["CompanyCategoryID"];
            SlotMaxWinRateYesterdayCategoryID = (int)CompanyCategoryDT.Select("CategoryName='" + "SlotMaxWinRateYesterday" + "' And CategoryType=1")[0]["CompanyCategoryID"];
            SlotMaxRTPYesterdayCategoryID = (int)CompanyCategoryDT.Select("CategoryName='" + "SlotMaxRTPYesterday" + "' And CategoryType=1")[0]["CompanyCategoryID"];

            gameCodeRTPResult = lobbyAPI.GetGameCodeRTP(GetToken(), Guid.NewGuid().ToString(), DateTime.Now.AddDays(-30).ToString("yyyy-MM-dd"), DateTime.Now.ToString("yyyy-MM-dd"));

            if (gameCodeRTPResult != null && gameCodeRTPResult.RTPList.Length > 0) {
                month1_gameCodeRTP = gameCodeRTPResult.RTPList.Where(w => w.GameCategoryCode == "Slot").ToList();
                day7_gameCodeRTP = month1_gameCodeRTP.Where(w => Convert.ToDateTime(w.SummaryDate) <= Convert.ToDateTime(DateTime.Now.AddDays(-1).ToString("yyyy-MM-dd")) && Convert.ToDateTime(w.SummaryDate) >= Convert.ToDateTime(DateTime.Now.AddDays(-7).ToString("yyyy-MM-dd"))).ToList();
                day3_gameCodeRTP = day7_gameCodeRTP.Where(w => Convert.ToDateTime(w.SummaryDate) <= Convert.ToDateTime(DateTime.Now.AddDays(-1).ToString("yyyy-MM-dd")) && Convert.ToDateTime(w.SummaryDate) >= Convert.ToDateTime(DateTime.Now.AddDays(-3).ToString("yyyy-MM-dd"))).ToList();
                yesterday_gameCodeRTP = day3_gameCodeRTP.Where(w => w.SummaryDate == DateTime.Now.AddDays(-2).ToString("yyyy-MM-dd")).ToList();

                //老虎機最多轉72hour
                SlotMaxBetCount3DayResult = (from p in day3_gameCodeRTP
                                             group p by new { p.GameCode } into g
                                             select new CompanyCategoryByStatistics { GameCode = g.Key.GameCode, QTY = g.Sum(p => p.BetCount) }).OrderByDescending(o => o.QTY).Take(10).ToList();

                EWinWebDB.CompanyCategoryGameCode.DeleteCompanyCategoryGameCodeByCategoryID(SlotMaxBetCount3DayCategoryID);
                for (int i = 0; i < SlotMaxBetCount3DayResult.Count; i++) {
                    var data = SlotMaxBetCount3DayResult[i];
                    EWinWebDB.CompanyCategoryGameCode.InsertCompanyCategoryGameCode(SlotMaxBetCount3DayCategoryID, data.GameCode, 0);
                }
                //maharaja最多轉30day
                SlotMaxBetCount30DayResult = (from p in month1_gameCodeRTP
                                              group p by new { p.GameCode } into g
                                              select new CompanyCategoryByStatistics { GameCode = g.Key.GameCode, QTY = g.Sum(p => p.BetCount) }).OrderByDescending(o => o.QTY).Take(10).ToList();

                EWinWebDB.CompanyCategoryGameCode.DeleteCompanyCategoryGameCodeByCategoryID(SlotMaxBetCount30DayCategoryID);
                for (int i = 0; i < SlotMaxBetCount30DayResult.Count; i++) {
                    var data = SlotMaxBetCount30DayResult[i];
                    EWinWebDB.CompanyCategoryGameCode.InsertCompanyCategoryGameCode(SlotMaxBetCount30DayCategoryID, data.GameCode, 0);
                }
                //7天內最大開獎
                SlotMaxWinValue7DayResult = (from p in day7_gameCodeRTP
                                             group p by new { p.GameCode } into g
                                             select new CompanyCategoryByStatistics { GameCode = g.Key.GameCode, QTY = g.Max(m => m.MaxWinValue) }).OrderByDescending(o => o.QTY).Take(10).ToList();

                EWinWebDB.CompanyCategoryGameCode.DeleteCompanyCategoryGameCodeByCategoryID(SlotMaxWinValue7DayCategoryID);
                for (int i = 0; i < SlotMaxWinValue7DayResult.Count; i++) {
                    var data = SlotMaxWinValue7DayResult[i];
                    EWinWebDB.CompanyCategoryGameCode.InsertCompanyCategoryGameCode(SlotMaxWinValue7DayCategoryID, data.GameCode, 0);
                }
                //前天最大開獎
                SlotMaxWinValueYesterdayResult = (from p in yesterday_gameCodeRTP
                                                  group p by new { p.GameCode } into g
                                                  select new CompanyCategoryByStatistics { GameCode = g.Key.GameCode, QTY = g.Max(m => m.MaxWinValue) }).OrderByDescending(o => o.QTY).Take(10).ToList();

                EWinWebDB.CompanyCategoryGameCode.DeleteCompanyCategoryGameCodeByCategoryID(SlotMaxWinValueYesterdayCategoryID);
                for (int i = 0; i < SlotMaxWinValueYesterdayResult.Count; i++) {
                    var data = SlotMaxWinValueYesterdayResult[i];
                    EWinWebDB.CompanyCategoryGameCode.InsertCompanyCategoryGameCode(SlotMaxWinValueYesterdayCategoryID, data.GameCode, 0);
                }
                //7天內最大倍率
                SlotMaxWinRate7DayResult = (from p in day7_gameCodeRTP
                                            group p by new { p.GameCode } into g
                                            select new CompanyCategoryByStatistics { GameCode = g.Key.GameCode, QTY = g.Max(m => m.MaxWinRate) }).OrderByDescending(o => o.QTY).Take(10).ToList();

                EWinWebDB.CompanyCategoryGameCode.DeleteCompanyCategoryGameCodeByCategoryID(SlotMaxWinRate7DayCategoryID);
                for (int i = 0; i < SlotMaxWinRate7DayResult.Count; i++) {
                    var data = SlotMaxWinRate7DayResult[i];
                    EWinWebDB.CompanyCategoryGameCode.InsertCompanyCategoryGameCode(SlotMaxWinRate7DayCategoryID, data.GameCode, 0);
                }
                //前天最大倍率
                SlotMaxWinRateYesterdayResult = (from p in yesterday_gameCodeRTP
                                                 group p by new { p.GameCode } into g
                                                 select new CompanyCategoryByStatistics { GameCode = g.Key.GameCode, QTY = g.Max(m => m.MaxWinRate) }).OrderByDescending(o => o.QTY).Take(10).ToList();

                EWinWebDB.CompanyCategoryGameCode.DeleteCompanyCategoryGameCodeByCategoryID(SlotMaxWinRateYesterdayCategoryID);
                for (int i = 0; i < SlotMaxWinRateYesterdayResult.Count; i++) {
                    var data = SlotMaxWinRateYesterdayResult[i];
                    EWinWebDB.CompanyCategoryGameCode.InsertCompanyCategoryGameCode(SlotMaxWinRateYesterdayCategoryID, data.GameCode, 0);
                }
                //前天最高RTP
                SlotMaxRTPYesterdayResult = (from p in yesterday_gameCodeRTP
                                             select new CompanyCategoryByStatistics { GameCode = p.GameCode, QTY = (p.OrderValue == 0 ? 0 : (1 + (p.RewardValue / p.OrderValue)) * 100) }).OrderByDescending(o => o.QTY).Take(10).ToList();

                EWinWebDB.CompanyCategoryGameCode.DeleteCompanyCategoryGameCodeByCategoryID(SlotMaxRTPYesterdayCategoryID);
                for (int i = 0; i < SlotMaxRTPYesterdayResult.Count; i++) {
                    var data = SlotMaxRTPYesterdayResult[i];
                    EWinWebDB.CompanyCategoryGameCode.InsertCompanyCategoryGameCode(SlotMaxRTPYesterdayCategoryID, data.GameCode, 0);
                }
            }
        }

        #endregion


        companyCategoryResult = lobbyAPI.GetCompanyCategory(GetToken(), Guid.NewGuid().ToString());
        if (companyCategoryResult.Result == EWin.Lobby.enumResult.OK) {
            if (companyCategoryResult.CategoryList.Length > 0) {

                #region 當Ocw存在 Category,EWIN不存在Category(從Ocw刪除)
                if (CompanyCategoryDT != null && CompanyCategoryDT.Rows.Count > 0) {
                    CustomizeCompanyCategoryRows = CompanyCategoryDT.Select("CategoryType=0");
                    if (CustomizeCompanyCategoryRows.Length > 0) {
                        for (int i = 0; i < CustomizeCompanyCategoryRows.Length; i++) {
                            //OCW存在EWIN不存在)
                            if (companyCategoryResult.CategoryList.Where(w => w.CompanyCategoryID == (int)CustomizeCompanyCategoryRows[i]["EwinCompanyCategoryID"]).FirstOrDefault() == null) {
                                //刪除Category
                                if (EWinWebDB.CompanyCategory.DeleteCompanyCategoryByCompanyCategoryID2((int)CustomizeCompanyCategoryRows[i]["CompanyCategoryID"]) > 0) {  //刪除Category底下的GameCode
                                    EWinWebDB.CompanyCategoryGameCode.DeleteCompanyCategoryGameCodeByCategoryID((int)CustomizeCompanyCategoryRows[i]["CompanyCategoryID"]);
                                }
                            }
                        }
                    }
                }
                #endregion

                CompanyCategoryDT = RedisCache.CompanyCategory.GetCompanyCategory();
                for (int i = 0; i < companyCategoryResult.CategoryList.Length; i++) {
                    //@隱性分類不顯示,故不處理
                    if (!companyCategoryResult.CategoryList[i].CategoryName.Contains("@")) {
                        if (companyCategoryResult.CategoryList[i].Tag.Length == 4) {
                            Location = ParseLocation(companyCategoryResult.CategoryList[i].Tag.Substring(0, 2));
                            ShowType = ParseShowType(companyCategoryResult.CategoryList[i].Tag.Substring(2, 2));

                            if (CompanyCategoryDT.Select("EwinCompanyCategoryID='" + companyCategoryResult.CategoryList[i].CompanyCategoryID + "' And CategoryType=0").Length == 0) {
                                EWinWebDB.CompanyCategory.InsertCompanyCategory(companyCategoryResult.CategoryList[i].CompanyCategoryID, 0, companyCategoryResult.CategoryList[i].CategoryName, companyCategoryResult.CategoryList[i].SortIndex, 0, Location, ShowType);
                            } else {
                                EWinWebDB.CompanyCategory.UpdateCompanyCategory(companyCategoryResult.CategoryList[i].CompanyCategoryID, 0, companyCategoryResult.CategoryList[i].CategoryName, companyCategoryResult.CategoryList[i].SortIndex, 0, Location, ShowType);
                            }
                        }
                    }

                }

                CompanyCategoryDT = RedisCache.CompanyCategory.GetCompanyCategory();

                if (CompanyCategoryDT != null && CompanyCategoryDT.Rows.Count > 0) {

                    if (SettingData != null) {
                        UpdateTimestamp = int.Parse(SettingData["UpdateTimestamp"].ToString());
                        GameID = int.Parse(SettingData["GameID"].ToString());
                    }

                    while (true) {
                        companyGameCodeResult = lobbyAPI.GetCompanyGameCodeByUpdateTimestamp(GetToken(), Guid.NewGuid().ToString(), UpdateTimestamp, GameID);

                        if (companyGameCodeResult.Result == EWin.Lobby.enumResult.OK && companyGameCodeResult.GameCodeList != null && companyGameCodeResult.GameCodeList.Length > 0) {
                            for (int i = 0; i < companyGameCodeResult.GameCodeList.Length; i++) {   //建立全部GameCode資料
                                var data = companyGameCodeResult.GameCodeList[i];
                                GameID = data.GameID;
                                UpdateTimestamp = data.UpdateTimestamp;
                                GameCode = data.GameCode;
                                SettingData["UpdateTimestamp"] = UpdateTimestamp;
                                SettingData["GameID"] = GameID;

                                EWinWebDB.CompanyGameCode.InsertCompanyGameCode(GameCode, GameID, data.GameName, data.GameCategoryCode, data.GameCategorySubCode, data.AllowDemoPlay, data.RTPInfo, data.IsHot, data.IsNew, data.Tag == null ? "" : Newtonsoft.Json.JsonConvert.SerializeObject(data.Tag), data.SortIndex, data.BrandCode, Newtonsoft.Json.JsonConvert.SerializeObject(data.Language), data.UpdateTimestamp, data.CompanyCategoryTag, data.GameAccountingCode, Newtonsoft.Json.JsonConvert.SerializeObject(data.GameCodeCategory), (int)companyGameCodeResult.GameCodeList[i].GameStatus);

                                if (companyGameCodeResult.GameCodeList[i].GameStatus == EWin.Lobby.enumGameCodeStatus.GameOpen) {
                                    EWinWebDB.CompanyCategoryGameCode.DeleteCompanyCategoryGameCodeByGameCodeByCategoryType0(GameCode);
                                    if (!string.IsNullOrEmpty(companyGameCodeResult.GameCodeList[i].CompanyCategoryTag)) {
                                        companyCategoryTags = companyGameCodeResult.GameCodeList[i].CompanyCategoryTag.Split(',');
                                        if (companyCategoryTags.Length > 0) {
                                            foreach (var companyCategoryTag in companyCategoryTags) {
                                                //@隱性分類不顯示,故不處理
                                                if (!companyCategoryTag.Trim().Contains("@")) {
                                                    SortIndex = 0;
                                                    CompanyCategoryRow = CompanyCategoryDT.Select("CategoryName='" + companyCategoryTag.Trim() + "'");
                                                    if (CompanyCategoryRow.Length > 0) {
                                                        var GameCodeCategoryData = companyGameCodeResult.GameCodeList[i].GameCodeCategory.Where(w => w.CategoryName == companyCategoryTag.Trim()).FirstOrDefault();
                                                        if (GameCodeCategoryData != null) {
                                                            SortIndex = GameCodeCategoryData.SortIndex;
                                                        }
                                                        CompanyCategoryID = (int)CompanyCategoryRow[0]["CompanyCategoryID"];

                                                        EWinWebDB.CompanyCategoryGameCode.InsertCompanyCategoryGameCode(CompanyCategoryID, GameCode, SortIndex);

                                                    }
                                                }

                                            }
                                        }
                                    }
                                } else {
                                    EWinWebDB.CompanyCategoryGameCode.DeleteCompanyCategoryGameCodeByGameCode(GameCode);
                                }

                            }
                        } else {
                            string Filename = HttpContext.Current.Server.MapPath("/App_Data/CompanyGameCodeSetting.json");

                            WriteAllText(Filename, SettingData.ToString());
                            RedisCache.CompanyCategoryGameCode.UpdateCompanyGameCode();
                            break;
                        }
                    }
                } else {
                    R.Message = "InsertCompanyGameCode Error CompanyCategoryID=" + CompanyCategoryID;
                }

            } else {
                R.Message = "Get CompanyCategoryResult Count=0";
            }
            R.Result = EWin.Lobby.enumResult.OK;
        } else {
            R.Message = "Get CompanyCategoryResult Error";
        }

        return R;
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static APIResult OpenSite() {
        APIResult R = new APIResult() { Result = enumResult.ERR };

        dynamic o = null;
        string Filename;

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
        return R;
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static APIResult MaintainSite(string Message) {
        APIResult R = new APIResult() { Result = enumResult.ERR };

        dynamic o = null;
        string Filename;

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

        return R;
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

    private static string ParseLocation(string LocationCode) {
        string ret = "Close";
        switch (LocationCode) {
            case "01":
                ret = "GameList_Hot";
                break;
            case "02":
                ret = "GameList_Favo";
                break;
            case "03":
                ret = "GameList_Live";
                break;
            case "04":
                ret = "GameList_Slot";
                break;
            case "05":
                ret = "GameList_Other";
                break;
            case "06":
                ret = "GameList_Brand";
                break;
            case "07":
                ret = "Home";
                break;
            default:
                break;
        }
        return ret;
    }

    private static int ParseShowType(string ShowType) {
        int ret = -1;
        switch (ShowType) {
            case "01"://01 => 基本版型
                ret = 0;
                break;
            case "02"://02 => 排行版型
                ret = 1;
                break;
            case "03"://03 => 隨機推薦版型
                ret = 2;
                break;
            default:
                ret = -1;
                break;
        }
        return ret;
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

    public class CompanyCategoryByStatistics {
        public string GameCode { get; set; }
        public decimal QTY { get; set; }
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
}