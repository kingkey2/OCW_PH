using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Script.Services;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Text.RegularExpressions;

public partial class GetPlayerTotalDepositSummary_Casino : System.Web.UI.Page
{

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static EWin.SpriteAgent.AgentTotalSummaryResult GetTotalOrderSummary(string AID, string LoginAccount, DateTime QueryBeginDate, DateTime QueryEndDate, string CurrencyType,string TargetLoginAccount) {
        EWin.SpriteAgent.SpriteAgent api = new EWin.SpriteAgent.SpriteAgent();
        EWin.SpriteAgent.AgentTotalSummaryResult RetValue = new EWin.SpriteAgent.AgentTotalSummaryResult();

        RetValue = api.GetPlayerTotalDepositSummary(AID, LoginAccount, QueryBeginDate, QueryEndDate, CurrencyType, TargetLoginAccount);
        return RetValue;
    }
    
}