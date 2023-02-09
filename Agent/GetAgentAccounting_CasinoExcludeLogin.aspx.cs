using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Script.Services;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Text.RegularExpressions;

public partial class GetAgentAccounting_CasinoExcludeLogin : System.Web.UI.Page {
    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static EWin.SpriteAgent.AccountingResult GetAccountingItem(string StartDate,string EndDate,string LoginAccount) {
        EWin.SpriteAgent.SpriteAgent api = new EWin.SpriteAgent.SpriteAgent();
        EWin.SpriteAgent.AccountingResult RetValue = new EWin.SpriteAgent.AccountingResult();
        string CurrencyType = EWinWeb.MainCurrencyType;
        RetValue = api.GetAccountingItemExcludeLogin(EWinWeb.CompanyCode, LoginAccount, StartDate, EndDate, CurrencyType);

        return RetValue;
    }
}