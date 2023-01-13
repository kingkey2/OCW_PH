using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Script.Services;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web;

/// <summary>
/// index 的摘要描述
/// </summary>
public partial class index : System.Web.UI.Page {
    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static EWin.SpriteAgent.APIResult CreateGameAccount(string AID) {
        EWin.SpriteAgent.SpriteAgent api = new EWin.SpriteAgent.SpriteAgent();
        EWin.SpriteAgent.APIResult RetValue = new EWin.SpriteAgent.APIResult();

        RetValue = api.CreateGameAccount(AID);

        return RetValue;
    }
}