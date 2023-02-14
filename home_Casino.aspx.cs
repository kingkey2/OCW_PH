using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Script.Services;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Text.RegularExpressions;
using System.Data;

public partial class home_Casino : System.Web.UI.Page { 

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static EWin.SpriteAgent.ChidUserData GetChildUserData(string AID) {
        EWin.SpriteAgent.SpriteAgent api = new EWin.SpriteAgent.SpriteAgent();
        EWin.SpriteAgent.ChidUserData RetValue = new EWin.SpriteAgent.ChidUserData();

        RetValue = api.GetChildUserData(AID);

        return RetValue;
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static EWin.SpriteAgent.TotalSummaryResult GetOrderSummary(string AID, string QueryBeginDate, string QueryEndDate, string CurrencyType) {
        EWin.SpriteAgent.TotalSummaryResult RetValue = null;
        EWin.SpriteAgent.SpriteAgent api = new EWin.SpriteAgent.SpriteAgent();

        RetValue = api.GetOrderSummary(AID, QueryBeginDate, QueryEndDate, CurrencyType);

        return RetValue;
    }
}