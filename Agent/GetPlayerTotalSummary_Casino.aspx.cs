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

public partial class GetPlayerTotalSummary_Casino : System.Web.UI.Page
{
    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static EWin.SpriteAgent.TotalSummaryResult GetTotalOrderSummary(string AID, string LoginAccount, DateTime QueryBeginDate, DateTime QueryEndDate, string CurrencyType, string TargetLoginAccount, int RowsPage, int PageNumber) {
        EWin.SpriteAgent.SpriteAgent api = new EWin.SpriteAgent.SpriteAgent();
        EWin.SpriteAgent.TotalSummaryResult RetValue = new EWin.SpriteAgent.TotalSummaryResult();
        EWin.SpriteAgent.TotalSummaryResult k = new EWin.SpriteAgent.TotalSummaryResult();
        string strRedisData = string.Empty;
        JObject redisSaveData = new JObject();
        int ExpireTimeoutSeconds = 0;

        strRedisData = RedisCache.Agent.GetPlayerTotalSummaryInfoByLoginAccount(LoginAccount, QueryBeginDate.ToString("yyyy-MM-dd"), QueryEndDate.ToString("yyyy-MM-dd"));

        if (string.IsNullOrEmpty(strRedisData)) {
            RetValue = api.GetTotalOrderSummary(AID, LoginAccount, QueryBeginDate, QueryEndDate, CurrencyType, TargetLoginAccount);

            if (RetValue.Result == EWin.SpriteAgent.enumResult.OK) {
                if (RetValue.SummaryList.Count() > 0) {
                    int TotalPage = 0;
                    TotalPage = (int)Math.Ceiling(double.Parse((RetValue.SummaryList.Count() / RowsPage).ToString()));

                    redisSaveData.Add("TotalPage", TotalPage);
                    ExpireTimeoutSeconds = 600;
                    
                    for (int i = 0; i < TotalPage; i++) {
                        k = new EWin.SpriteAgent.TotalSummaryResult();
                        k.Result = EWin.SpriteAgent.enumResult.OK;
                        k.SummaryList = RetValue.SummaryList.Skip(i).Take(RowsPage).ToArray();

                        redisSaveData.Add(i++.ToString(), JsonConvert.SerializeObject(k));
                    }

                    RedisCache.Agent.UpdatePlayerTotalSummaryByLoginAccount(JsonConvert.SerializeObject(redisSaveData), LoginAccount, QueryBeginDate.ToString("yyyy-MM-dd"), QueryEndDate.ToString("yyyy-MM-dd"));
                }
            }
        } else {

        }
        
        return RetValue;
    }
}