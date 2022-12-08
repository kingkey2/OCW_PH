using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Script.Services;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Text.RegularExpressions;

public partial class GetAgentAccountingDetail_Casino : System.Web.UI.Page {
   
    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static EWin.SpriteAgent.AgentAccountingDetailResult GetAgentAccountingDetail(string AID, string CurrencyType, int AccountingID) {
        EWin.SpriteAgent.SpriteAgent api = new EWin.SpriteAgent.SpriteAgent();
        EWin.SpriteAgent.AgentAccountingDetailResult RetValue = new EWin.SpriteAgent.AgentAccountingDetailResult();

        RetValue = api.GetAgentAccountingDetail(AID, CurrencyType, AccountingID);

        return RetValue;
    }
}