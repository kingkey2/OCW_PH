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
        int TotalPage = 0;

        strRedisData = RedisCache.Agent.GetPlayerTotalSummaryInfoByLoginAccount(LoginAccount, QueryBeginDate.ToString("yyyy-MM-dd"), QueryEndDate.ToString("yyyy-MM-dd"));

        if (!string.IsNullOrEmpty(TargetLoginAccount)) {
            if (string.IsNullOrEmpty(strRedisData)) {
                RetValue = api.GetTotalOrderSummary(AID, LoginAccount, QueryBeginDate, QueryEndDate, CurrencyType, TargetLoginAccount);
            } else {
                redisSaveData = JObject.Parse(strRedisData);

                if (redisSaveData["All"] != null) {
                    JArray arrSaveData = JArray.Parse((string)redisSaveData["All"]);
                    JObject searchData = null;

                    searchData = (JObject)arrSaveData.Where(x => (string)x["LoginAccount"] == TargetLoginAccount).Select(x => x).FirstOrDefault();

                    if (searchData == null) {
                        RetValue.Result = EWin.SpriteAgent.enumResult.OK;
                    } else {
                        RetValue.Result = EWin.SpriteAgent.enumResult.OK;
                        List<EWin.SpriteAgent.TotalSummary> kk = new List<EWin.SpriteAgent.TotalSummary>();
                        kk.Add(new EWin.SpriteAgent.TotalSummary() {
                            UserAccountID = (int)searchData["UserAccountID"],
                            CurrencyType = (string)searchData["CurrencyType"],
                            LoginAccount = (string)searchData["LoginAccount"],
                            ParentLoginAccount = (string)searchData["ParentLoginAccount"],
                            RewardValue = (decimal)searchData["RewardValue"],
                            ValidBetValue = (decimal)searchData["ValidBetValue"],
                            SelfRewardValue = (decimal)searchData["SelfRewardValue"],
                            SelfValidBetValue = (decimal)searchData["SelfValidBetValue"],
                            OrderCount = (int)searchData["OrderCount"],
                            SelfOrderCount = (int)searchData["SelfOrderCount"],
                            HasChild = (bool)searchData["HasChild"],
                            DealUserAccountSortKey = (string)searchData["DealUserAccountSortKey"],
                            DealUserAccountInsideLevel = (int)searchData["DealUserAccountInsideLevel"],
                            IsTarget = (bool)searchData["IsTarget"]
                        });
                        RetValue.SummaryList = kk.ToArray();
                        RetValue.HasNextPage = false;
                    }
                } else {
                    RetValue = api.GetTotalOrderSummary(AID, LoginAccount, QueryBeginDate, QueryEndDate, CurrencyType, TargetLoginAccount);
                }
            }
        } else {

            if (string.IsNullOrEmpty(strRedisData)) {
                RetValue = api.GetTotalOrderSummary(AID, LoginAccount, QueryBeginDate, QueryEndDate, CurrencyType, TargetLoginAccount);

                if (RetValue.Result == EWin.SpriteAgent.enumResult.OK) {
                    if (RetValue.SummaryList.Count() > 0) {
                        TotalPage = int.Parse(Math.Ceiling((double)RetValue.SummaryList.Count() / (double)RowsPage).ToString());

                        redisSaveData.Add("TotalPage", TotalPage);
                        redisSaveData.Add("All", JsonConvert.SerializeObject(RetValue.SummaryList));
                        ExpireTimeoutSeconds = 600;

                        for (int i = 0; i < TotalPage; i++) {
                            k = new EWin.SpriteAgent.TotalSummaryResult();
                            k.Result = EWin.SpriteAgent.enumResult.OK;
                            k.SummaryList = RetValue.SummaryList.Skip(i).Take(RowsPage).ToArray();

                            redisSaveData.Add((i + 1).ToString(), JsonConvert.SerializeObject(k));
                        }

                        if (TotalPage > 1) {
                            RetValue.HasNextPage = true;
                        } else {
                            RetValue.HasNextPage = false;
                        }

                        RedisCache.Agent.UpdatePlayerTotalSummaryByLoginAccount(JsonConvert.SerializeObject(redisSaveData), LoginAccount, QueryBeginDate.ToString("yyyy-MM-dd"), QueryEndDate.ToString("yyyy-MM-dd"));
                    }
                }

            } else {
                redisSaveData = JObject.Parse(strRedisData);

                if (redisSaveData["TotalPage"] != null) {
                    TotalPage = (int)redisSaveData["TotalPage"];
                }

                if (redisSaveData[PageNumber.ToString()] != null) {
                    RetValue = JsonConvert.DeserializeObject<EWin.SpriteAgent.TotalSummaryResult>((string)redisSaveData[PageNumber.ToString()]);

                    if (PageNumber >= TotalPage) {
                        RetValue.HasNextPage = false;
                    } else {
                        RetValue.HasNextPage = true;
                    }
                }
            }
        }

        return RetValue;
    }
}