﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Script.Services;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Text.RegularExpressions;
using System.Data;

public partial class home_CasinoExcludeLogin : System.Web.UI.Page { 

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static EWin.SpriteAgent.ChidUserData GetChildUserData(string LoginAccount) {
        EWin.SpriteAgent.SpriteAgent api = new EWin.SpriteAgent.SpriteAgent();
        EWin.SpriteAgent.ChidUserData RetValue = new EWin.SpriteAgent.ChidUserData();
        string RedisTmp = string.Empty;

        RedisTmp = RedisCache.Agent.GetHomeChildDetailByLoginAccount(LoginAccount);

        if (string.IsNullOrEmpty(RedisTmp)) {
            RetValue = api.GetChildUserDataExcludeLogin(EWinWeb.CompanyCode, LoginAccount);

            RedisCache.Agent.UpdateHomeChildDetailByLoginAccount(Newtonsoft.Json.JsonConvert.SerializeObject(RetValue), LoginAccount);
        } else {
            RetValue = Newtonsoft.Json.JsonConvert.DeserializeObject<EWin.SpriteAgent.ChidUserData>(RedisTmp);

            if (RetValue.Result == EWin.SpriteAgent.enumResult.ERR) {
                RetValue = api.GetChildUserDataExcludeLogin(EWinWeb.CompanyCode, LoginAccount);

                RedisCache.Agent.UpdateHomeChildDetailByLoginAccount(Newtonsoft.Json.JsonConvert.SerializeObject(RetValue), LoginAccount);
            }
        }

        return RetValue;
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static EWin.SpriteAgent.TotalSummaryResult GetOrderSummary(string QueryBeginDate, string QueryEndDate, string CurrencyType, string LoginAccount) {
        EWin.SpriteAgent.TotalSummaryResult RetValue = null;
        EWin.SpriteAgent.SpriteAgent api = new EWin.SpriteAgent.SpriteAgent();
        string RedisTmp = string.Empty;

        RedisTmp = RedisCache.Agent.GetHomeAccountDetailByLoginAccount(LoginAccount, QueryBeginDate, QueryEndDate);

        if (string.IsNullOrEmpty(RedisTmp)) {
            RetValue = api.GetOrderSummaryExcludeLogin(EWinWeb.CompanyCode, LoginAccount, QueryBeginDate, QueryEndDate, CurrencyType);

            RedisCache.Agent.UpdateHomeAccountDetailByLoginAccount(Newtonsoft.Json.JsonConvert.SerializeObject(RetValue), LoginAccount, QueryBeginDate, QueryEndDate);
        } else {
            RetValue = Newtonsoft.Json.JsonConvert.DeserializeObject<EWin.SpriteAgent.TotalSummaryResult>(RedisTmp);

            if (RetValue.Result == EWin.SpriteAgent.enumResult.ERR) {
                RetValue = api.GetOrderSummaryExcludeLogin(EWinWeb.CompanyCode, LoginAccount, QueryBeginDate, QueryEndDate, CurrencyType);

                RedisCache.Agent.UpdateHomeAccountDetailByLoginAccount(Newtonsoft.Json.JsonConvert.SerializeObject(RetValue), LoginAccount, QueryBeginDate, QueryEndDate);
            }
        }
        
        return RetValue;
    }


    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static EWin.SpriteAgent.UserInfoResult2 QueryUserInfo(string LoginAccount)
    {
        EWin.SpriteAgent.UserInfoResult2 R;
        EWin.SpriteAgent.SpriteAgent api = new EWin.SpriteAgent.SpriteAgent();

        R = api.QueryUserInfoExcludeLogin(EWinWeb.CompanyCode, LoginAccount);

        return R;
    }
}