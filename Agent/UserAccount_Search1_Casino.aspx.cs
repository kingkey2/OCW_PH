using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Script.Services;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Text.RegularExpressions;
using Newtonsoft.Json.Linq;
using Newtonsoft.Json;

public partial class UserAccount_Search1_Casino : System.Web.UI.Page {
    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static EWin.SpriteAgent.ChildUserInfoResult1 QueryChildUserInfo(string AID, string TargetLoginAccount, int RowsPage, int PageNumber, int MaxSearchUserAccountID) {
        EWin.SpriteAgent.SpriteAgent api = new EWin.SpriteAgent.SpriteAgent();
        EWin.SpriteAgent.ChildUserInfoResult1 RetValue = new EWin.SpriteAgent.ChildUserInfoResult1();

        RetValue = api.GetUserAccountByTargetLoginAccount(AID, TargetLoginAccount, RowsPage, PageNumber, MaxSearchUserAccountID);

        return RetValue;
    }
}