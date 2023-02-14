using System;
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
        EWin.SpriteAgent.GroupAgentResult RetValue;
        string tempKey = "GetGroupAgent_" + TargetUserAccountID.ToString() + "_" + QueryBeginDate.ToString("yyyy-MM-dd") + "_" + QueryEndDate.ToString("yyyy-MM-dd") + "_" + Page.ToString();
        var tempResult = RedisCache.Temprory.CheckCacheOnceByJson<EWin.SpriteAgent.GroupAgentResult>(tempKey, 600, () =>{
            var newResult = api.GetGroupAgent(AID, TargetUserAccountID, QueryBeginDate, QueryEndDate, CurrencyType, Page);

            if (newResult.Result == EWin.SpriteAgent.enumResult.OK)
            {
                return newResult;
            }
            else {
                return null;
            }            
        });


        if (tempResult != null)
        {
            RetValue = tempResult;
        }
        else {
            RetValue = new EWin.SpriteAgent.GroupAgentResult
            {
                Result = EWin.SpriteAgent.enumResult.ERR,
                Message = "Error"
            };
        }

        return RetValue;
    }
}