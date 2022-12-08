using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Script.Services;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Text.RegularExpressions;

public partial class GetAgentAccounting_Casino : System.Web.UI.Page {
    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static EWin.SpriteAgent.AccountingResult GetAccountingItem(string AID, string StartDate,string EndDate,string CurrencyType) {
        EWin.SpriteAgent.SpriteAgent api = new EWin.SpriteAgent.SpriteAgent();
        EWin.SpriteAgent.AccountingResult RetValue = new EWin.SpriteAgent.AccountingResult();

        RetValue = api.GetAccountingItem(AID, StartDate, EndDate, CurrencyType);

        return RetValue;
    }
}