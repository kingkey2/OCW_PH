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

public partial class GetPlayerTotalDepositSummary_Casino : System.Web.UI.Page
{

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static EWin.SpriteAgent.AgentTotalSummaryResult GetTotalOrderSummary(string AID, string LoginAccount, DateTime QueryBeginDate, DateTime QueryEndDate, string CurrencyType,string TargetLoginAccount, int RowsPage, int PageNumber) {
        EWin.SpriteAgent.SpriteAgent api = new EWin.SpriteAgent.SpriteAgent();
        EWin.SpriteAgent.AgentTotalSummaryResult RetValue = new EWin.SpriteAgent.AgentTotalSummaryResult();
        List<EWin.SpriteAgent.AgentTotalSummary> tmpRetValue = new List<EWin.SpriteAgent.AgentTotalSummary>();
        List<EWin.SpriteAgent.AgentTotalSummary> tmpAgentTotalSummaryResult = null;
        int tmpPageNumber =0;
        string strRedisData = string.Empty;
        JObject redisSaveData = new JObject();
        int ExpireTimeoutSeconds = 600;
        
        if (string.IsNullOrEmpty(TargetLoginAccount))
        {
            strRedisData = RedisCache.Agent.GetPlayerTotalDepositSummaryByLoginAccount(LoginAccount,QueryBeginDate, QueryEndDate);
            //沒有redis資料一律將PageNumber改為1，避免用戶在該頁面放置到Redis已消失的狀態，最大會員編號已失效資料的數量會有問題
            if (string.IsNullOrEmpty(strRedisData))
            {
                RetValue = api.GetPlayerTotalDepositSummary(AID, LoginAccount, QueryBeginDate, QueryEndDate, CurrencyType, TargetLoginAccount);

                if (RetValue.Result == EWin.SpriteAgent.enumResult.OK&& RetValue.SummaryList.Length>0)
                {
           
                    tmpPageNumber = 1;
                    tmpAgentTotalSummaryResult = new List<EWin.SpriteAgent.AgentTotalSummary>();
                   
                    for (int i = 0; i < RetValue.SummaryList.Length; i++)
                    {
                        tmpAgentTotalSummaryResult.Add(RetValue.SummaryList[i]);
                        if ((i+1)%RowsPage==0)
                        {
                            redisSaveData.Add(tmpPageNumber.ToString(), JsonConvert.SerializeObject(tmpAgentTotalSummaryResult));
                            tmpPageNumber++;
                            tmpAgentTotalSummaryResult = new List<EWin.SpriteAgent.AgentTotalSummary>();
                        }

                        if (RetValue.SummaryList.Length==i+1)
                        {
                            redisSaveData.Add(tmpPageNumber.ToString(), JsonConvert.SerializeObject(tmpAgentTotalSummaryResult));
                        }
                    }

                    RedisCache.Agent.UpdatePlayerTotalDepositSummaryByLoginAccount(JsonConvert.SerializeObject(redisSaveData), QueryBeginDate, QueryEndDate, LoginAccount, ExpireTimeoutSeconds);
                    tmpRetValue = JsonConvert.DeserializeObject<List<EWin.SpriteAgent.AgentTotalSummary>>((string)redisSaveData[PageNumber.ToString()]);
                    if (redisSaveData[(PageNumber + 1).ToString()] != null)
                    {
                        RetValue.Message = "HasNextPage";
                    }

                    RetValue.SummaryList = tmpRetValue.ToArray();
                    RetValue.Result = EWin.SpriteAgent.enumResult.OK;

                }
            }
            else
            {
                redisSaveData = JObject.Parse(strRedisData);
                //有該頁面的資料
                if (redisSaveData[PageNumber.ToString()] != null)
                {
                    tmpRetValue = JsonConvert.DeserializeObject<List<EWin.SpriteAgent.AgentTotalSummary>>((string)redisSaveData[PageNumber.ToString()]);
                    if (redisSaveData[(PageNumber + 1).ToString()] != null)
                    {
                        RetValue.Message = "HasNextPage";
                    }

                    RetValue.SummaryList = tmpRetValue.ToArray();
                    RetValue.Result = EWin.SpriteAgent.enumResult.OK;
                }
                else
                {
                    RetValue.SummaryList = null;
                    RetValue.Result = EWin.SpriteAgent.enumResult.ERR;
                    RetValue.Message = "NoData";
                }

            }
        }
        else {
            RetValue = api.GetPlayerTotalDepositSummary(AID, LoginAccount, QueryBeginDate, QueryEndDate, CurrencyType, TargetLoginAccount);
        }
         
        return RetValue;
    }

}