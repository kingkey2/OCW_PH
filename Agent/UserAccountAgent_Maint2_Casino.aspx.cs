﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Script.Services;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Text.RegularExpressions;

public partial class UserAccountAgent_Maint2_Casino : System.Web.UI.Page {
    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static EWin.SpriteAgent.GroupAgentResult GetUserAccountSummary(string AID, int TargetUserAccountID, DateTime QueryBeginDate, DateTime QueryEndDate, string CurrencyType, int Page) {
        EWin.SpriteAgent.SpriteAgent api = new EWin.SpriteAgent.SpriteAgent();
        return api.GetGroupAgent(AID, TargetUserAccountID, QueryBeginDate, QueryEndDate, CurrencyType, Page);
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static EWin.SpriteAgent.GroupAgentResult GetUserAccountSummaryBySearch(string AID, string TargetLoginAccount, DateTime QueryBeginDate, DateTime QueryEndDate, string CurrencyType)
    {
        EWin.SpriteAgent.SpriteAgent api = new EWin.SpriteAgent.SpriteAgent();
        return api.GetGroupBySearch(AID, TargetLoginAccount, QueryBeginDate, QueryEndDate, CurrencyType);
    }
}