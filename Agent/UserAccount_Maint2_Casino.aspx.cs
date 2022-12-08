using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Script.Services;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Text.RegularExpressions;

public partial class UserAccount_Maint2_Casino : System.Web.UI.Page {
    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static EWin.SpriteAgent.UserAccountSummaryResult GetUserAccountSummary(string AID, string LoginAccount, DateTime QueryBeginDate, DateTime QueryEndDate, string CurrencyType) {
        EWin.SpriteAgent.SpriteAgent api = new EWin.SpriteAgent.SpriteAgent();
        EWin.SpriteAgent.UserAccountSummaryResult RetValue = new EWin.SpriteAgent.UserAccountSummaryResult();

        RetValue = api.GetUserAccountSummary(AID, LoginAccount, QueryBeginDate, QueryEndDate, CurrencyType);

        return RetValue;
    }
}