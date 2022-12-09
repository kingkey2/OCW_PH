using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Script.Services;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Text.RegularExpressions;

public partial class Agent_UserAccount_Search_Casino : System.Web.UI.Page {

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static EWin.SpriteAgent.ChildUserInfoResult QueryChildUserInfo(string AID) {
        EWin.SpriteAgent.SpriteAgent api = new EWin.SpriteAgent.SpriteAgent();
        EWin.SpriteAgent.ChildUserInfoResult RetValue = new EWin.SpriteAgent.ChildUserInfoResult();

        RetValue = api.QueryChildUserInfo(AID);

        return RetValue;
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static EWin.SpriteAgent.ChildUserInfoResult QueryCurrentUserInfo(string AID, string LoginAccount) {
        EWin.SpriteAgent.SpriteAgent api = new EWin.SpriteAgent.SpriteAgent();
        EWin.SpriteAgent.ChildUserInfoResult RetValue = new EWin.SpriteAgent.ChildUserInfoResult();

        RetValue = api.QueryCurrentUserInfoForSearchPage(AID, LoginAccount);

        return RetValue;
    }
}