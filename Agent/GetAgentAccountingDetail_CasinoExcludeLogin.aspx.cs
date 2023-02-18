using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Script.Services;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Text.RegularExpressions;

public partial class GetAgentAccountingDetail_CasinoExcludeLogin : System.Web.UI.Page {

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static EWin.SpriteAgent.AgentAccountingDetailResult GetAgentAccountingDetail(int AccountingID, string StartDate, string EndDate,string LoginAccount) {
        EWin.SpriteAgent.SpriteAgent api = new EWin.SpriteAgent.SpriteAgent();
        EWin.SpriteAgent.AgentAccountingDetailResult RetValue = new EWin.SpriteAgent.AgentAccountingDetailResult();
        string RedisTmp = string.Empty;

        RedisTmp = RedisCache.Agent.GetAccountDetailByLoginAccount(LoginAccount, AccountingID);

        if (string.IsNullOrEmpty(RedisTmp)) {
            RetValue = api.GetAgentAccountingDetailExcludeLogin(EWinWeb.CompanyCode, LoginAccount, EWinWeb.MainCurrencyType, AccountingID);

            RedisCache.Agent.UpdateAccountDetailByLoginAccount(Newtonsoft.Json.JsonConvert.SerializeObject(RetValue), LoginAccount, AccountingID);
        } else {
            RetValue = Newtonsoft.Json.JsonConvert.DeserializeObject<EWin.SpriteAgent.AgentAccountingDetailResult>(RedisTmp);
        }

        return RetValue;
    }
}