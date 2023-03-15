using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Script.Services;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Text.RegularExpressions;

public partial class GetAgentTotalDepositeSummary_CasinoExcludeLogin : System.Web.UI.Page
{
    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static EWin.SpriteAgent.DepositeSummaryResult GetAgentTotalDepositeSummary(string LoginAccount, int TargetUserAccountID, DateTime QueryBeginDate, DateTime QueryEndDate, string CurrencyType)
    {
        EWin.SpriteAgent.SpriteAgent api = new EWin.SpriteAgent.SpriteAgent();
        EWin.SpriteAgent.DepositeSummaryResult RetValue = new EWin.SpriteAgent.DepositeSummaryResult();

        RetValue = api.GetAgentTotalDepositeSummaryExcludeLogin(EWinWeb.CompanyCode, LoginAccount, TargetUserAccountID, QueryBeginDate, QueryEndDate, CurrencyType);
        return RetValue;
    }

    
    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static EWin.SpriteAgent.DepositeSummaryResult GetAgentTotalDepositeSummaryBySearch(string LoginAccount, string TargetLoginAccount, DateTime QueryBeginDate, DateTime QueryEndDate, string CurrencyType)
    {
        EWin.SpriteAgent.SpriteAgent api = new EWin.SpriteAgent.SpriteAgent();
        EWin.SpriteAgent.DepositeSummaryResult RetValue = new EWin.SpriteAgent.DepositeSummaryResult();

        RetValue = api.GetSearchAgentTotalDepositSummaryExcludeLogin(EWinWeb.CompanyCode, LoginAccount, TargetLoginAccount, QueryBeginDate, QueryEndDate, CurrencyType);

        return RetValue;
    }
}