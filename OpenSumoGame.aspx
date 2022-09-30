<%@ Page Language="C#" %>

<%

    RedisCache.SessionContext.SIDInfo SI;
        string SID = "";
        string Lang = "JPN";
        string CurrencyType = EWinWeb.MainCurrencyType;
    if (Request.Cookies["SID"] != null)
    {
         SID = Request.Cookies["SID"].Value;
    }

      string userLang = CodingControl.GetDefaultLanguage();

        if (userLang.ToUpper() == "zh-TW".ToUpper())
        {
            Lang = "CHT";
        }
        else if (userLang.ToUpper() == "zh-HK".ToUpper())
        {
            Lang = "CHT";
        }
        else if (userLang.ToUpper() == "zh-MO".ToUpper())
        {
            Lang = "CHT";
        }
        else if (userLang.ToUpper() == "zh-CHT".ToUpper())
        {
            Lang = "CHT";
        }
        else if (userLang.ToUpper() == "zh-CHS".ToUpper())
        {
            Lang = "CHT";
        }
        else if (userLang.ToUpper() == "zh-SG".ToUpper())
        {
            Lang = "CHT";
        }
        else if (userLang.ToUpper() == "zh-CN".ToUpper())
        {
            Lang = "CHT";
        }
        else if (userLang.ToUpper() == "zh".ToUpper())
        {
            Lang = "CHT";
        }
        else if (userLang.ToUpper() == "en-US".ToUpper())
        {
            Lang = "JPN";
        }
        else if (userLang.ToUpper() == "en-CA".ToUpper())
        {
            Lang = "JPN";
        }
        else if (userLang.ToUpper() == "en-PH".ToUpper())
        {
            Lang = "JPN";
        }
        else if (userLang.ToUpper() == "en".ToUpper())
        {
            Lang = "JPN";
        }
        else if (userLang.ToUpper() == "ko-KR".ToUpper())
        {
            Lang = "JPN";
        }
        else if (userLang.ToUpper() == "ko-KP".ToUpper())
        {
            Lang = "JPN";
        }
        else if (userLang.ToUpper() == "ko".ToUpper())
        {
            Lang = "JPN";
        }
        else if (userLang.ToUpper() == "ja".ToUpper())
        {
            Lang = "JPN";
        }
        else { Lang = "JPN"; }


    string GameBrand = "YS";
    string GameName ="Sumo";
    string HomeUrl = EWinWeb.CasinoWorldUrl+"/CloseGame.aspx";
    string DemoPlay = string.IsNullOrEmpty(Request["DemoPlay"]) ? "0" : Request["DemoPlay"]; //不支援DEMO直接最外層判斷

    SI = RedisCache.SessionContext.GetSIDInfo(SID);

    if (SI != null && !string.IsNullOrEmpty(SI.EWinSID)) {
            Response.Redirect(EWinWeb.EWinUrl + "/API/GamePlatformAPI/" + GameBrand + "/UserLogin.aspx?SID=" + SI.EWinSID + "&Language=" + Lang + "&CurrencyType=" + CurrencyType + "&GameName=" + GameName + "&HomeUrl=" + HomeUrl);
    } else {
            Response.Redirect(EWinWeb.CasinoWorldUrl + "/index.aspx?PageType=OpenSumo");
    }
%>
<!doctype html>
<html>
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Maharaja</title>
</head>

<body>
    <div class="loader-container">
        <div class="loader-box">
            <div class="loader-spinner">
                <div></div>
            </div>
            <div class="loader-text">Loading...</div>
        </div>
        <div class="loader-backdrop"></div>
    </div>
</body>
</html>
