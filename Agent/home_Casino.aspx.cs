using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Script.Services;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Text.RegularExpressions;
using System.Data;

public partial class home_Casino : System.Web.UI.Page { 

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static EWin.SpriteAgent.ChidUserData GetChildUserData(string AID) {
        EWin.SpriteAgent.SpriteAgent api = new EWin.SpriteAgent.SpriteAgent();
        EWin.SpriteAgent.ChidUserData RetValue = new EWin.SpriteAgent.ChidUserData();

        RetValue = api.GetChildUserData(AID);

        return RetValue;
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static EWin.SpriteAgent.OrderSummaryResult GetOrderSummary(string AID, string QueryBeginDate, string QueryEndDate, string CurrencyType, string LoginAccount) {
        EWin.SpriteAgent.OrderSummaryResult RetValue = null;
        EWin.SpriteAgent.SpriteAgent api = new EWin.SpriteAgent.SpriteAgent();
        string RedisTmp = string.Empty;

        RedisTmp = RedisCache.Agent.GetHomeAccountDetailByLoginAccount(LoginAccount, QueryBeginDate, QueryEndDate);

        if (string.IsNullOrEmpty(RedisTmp)) {
            RetValue = api.GetOrderSummary(AID, QueryBeginDate, QueryEndDate, CurrencyType);

            RedisCache.Agent.UpdateHomeAccountDetailByLoginAccount(Newtonsoft.Json.JsonConvert.SerializeObject(RetValue), LoginAccount, QueryBeginDate, QueryEndDate);
        } else {
            RetValue = Newtonsoft.Json.JsonConvert.DeserializeObject<EWin.SpriteAgent.OrderSummaryResult>(RedisTmp);

            if (RetValue.Result == EWin.SpriteAgent.enumResult.ERR) {
                RetValue = api.GetOrderSummary(AID, QueryBeginDate, QueryEndDate, CurrencyType);

                RedisCache.Agent.UpdateHomeAccountDetailByLoginAccount(Newtonsoft.Json.JsonConvert.SerializeObject(RetValue), LoginAccount, QueryBeginDate, QueryEndDate);
            }
        }
        
        return RetValue;
    }
}