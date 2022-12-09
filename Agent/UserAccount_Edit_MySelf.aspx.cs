using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Script.Services;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class UserAccount_Edit : System.Web.UI.Page {

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static EWin.SpriteAgent.APIResult UpdateUserInfo(string AID, EWin.SpriteAgent.PropertySet[] UserField) {
        EWin.SpriteAgent.SpriteAgent api = new EWin.SpriteAgent.SpriteAgent();
        EWin.SpriteAgent.APIResult RetValue = new EWin.SpriteAgent.APIResult();

        RetValue = api.UpdateUserInfo(AID, UserField);

        return RetValue;
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static EWin.SpriteAgent.APIResult QueryCurrentUserInfo(string AID) {
        EWin.SpriteAgent.SpriteAgent api = new EWin.SpriteAgent.SpriteAgent();
        EWin.SpriteAgent.APIResult RetValue = new EWin.SpriteAgent.APIResult();

        RetValue = api.QueryCurrentUserInfoForUserEditPage(AID);

        return RetValue;
    }
}