using System;
using System.Collections.Generic;
using System.Data;
using System.Dynamic;
using System.IO;
using System.Linq;
using System.Security.Cryptography;
using System.Text;
using System.Web;
using System.Web.Routing;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;

public partial class Common : System.Web.UI.Page
{
    public static string GameBrand = "YB";

    public static class Wallet
    {
        public static string GetBase32GameAccount(EWinGameCode.GameAccountId GA)
        {
            int MixComCash = (GA.CompanyID * 10 + (int)GA.CashUnit);
            string RetValue = null;

            RetValue = GA.CurrencyType + Base32.ToBase32String(BitConverter.GetBytes(GA.UserAccountID)) + (new string('0', 3 - MixComCash.ToString("x").Length) + MixComCash.ToString("x"));

            return RetValue;
        }

        public static EWinGameCode.GameAccountId ParsingFromBase32GameAccount(string GameAccountString)
        {
            EWinGameCode.GameAccountId GA = null;

            if (GameAccountString.Length >= 13)
            {
                string Base32UserAccount;
                string MixComString;
                string CurrencyType;
                int MixComValue;
                int CompanyID;
                int UserAccountID;

                EWinGameCode.GameAccountId.enumCashUnit CashUnit;

                MixComString = GameAccountString.Substring(GameAccountString.Length - 3, 3);
                Base32UserAccount = GameAccountString.Substring(GameAccountString.Length - 10, 7).ToUpper();
                CurrencyType = GameAccountString.Substring(0, GameAccountString.Length - 10).ToUpper();
                MixComValue = System.Int32.Parse(MixComString, System.Globalization.NumberStyles.AllowHexSpecifier);

                CompanyID = MixComValue / 10;
                CashUnit = (EWinGameCode.GameAccountId.enumCashUnit)(MixComValue % 10);

                UserAccountID = BitConverter.ToInt32(Base32.FromBase32String(Base32UserAccount), 0);

                GA = EWinGameCode.GameAccountId.FromUserAccountID(CurrencyType, UserAccountID);
            }

            return GA;
        }

        public static UserIsOnlineResult GetUserIsOnline(EWinGameCode.GameKey EGK, EWinGameCode.GameAccountId GA)
        {
            UserIsOnlineResult Ret = new UserIsOnlineResult() { ResultCode = 1 };
            string ResponseStr;
            JObject ResponseJObj = null;
            JObject GameKeyJSON = EGK.ToJSONObject();
            Dictionary<string, dynamic> SendData = new Dictionary<string, dynamic>();
            Dictionary<string, dynamic> SendData2 = new Dictionary<string, dynamic>();

            SendData2.Add("action", 52);
            SendData2.Add("ts", DateTimeOffset.UtcNow.ToUnixTimeMilliseconds());
            SendData2.Add("parent", GameKeyJSON["parent"].ToString());
            SendData2.Add("uid", GetBase32GameAccount(GA));

            string signStr = AESEncryptToString(JsonConvert.SerializeObject(SendData2), GameKeyJSON["aes_key"].ToString(), GameKeyJSON["aes_iv"].ToString());
            SendData.Add("dc", GameKeyJSON["dc"].ToString());
            SendData.Add("x", signStr);


            ResponseStr = GetApiResult(GameKeyJSON, "", "POST", SendData);

            if (string.IsNullOrEmpty(ResponseStr) == false)
            {
                try
                {
                    ResponseJObj = JObject.Parse(ResponseStr);

                    if (ResponseJObj != null)
                    {
                            if ((string)ResponseJObj["status"] == "0000")
                            {
                                Ret.LoginStatus = true;
                                Ret.ResultCode = 0;
                            }
                            else
                            {
                                Ret.ResultCode = 1;
                                Ret.Message = "PrdouctError Msg=" + (string)ResponseJObj["err_text"];
                            }
                    }
                    else
                    {
                        Ret.ResultCode = 1;
                        Ret.Message = "DeserializeFail";
                    }
                }
                catch (Exception ex)
                {
                    Ret.ResultCode = 1;
                    Ret.Message = ex.Message;
                }
            }
            else
            {
                Ret.ResultCode = 1;
                Ret.Message = "RequestFail";
            }

            return Ret;
        }

        public static bool CreatePlayer(EWinGameCode.GameKey EGK, EWinGameCode.GameAccountId GA)
        {
            bool Ret = false;
            string ResponseStr;
            JObject ResponseJObj = null;
            JObject GameKeyJSON = EGK.ToJSONObject();
            Dictionary<string, dynamic> SendData = new Dictionary<string, dynamic>(); 
            Dictionary<string, dynamic> SendData2 = new Dictionary<string, dynamic>();

            SendData2.Add("action",12);
            SendData2.Add("ts", DateTimeOffset.UtcNow.ToUnixTimeMilliseconds());
            SendData2.Add("parent", GameKeyJSON["parent"].ToString());
            SendData2.Add("uid", GetBase32GameAccount(GA));
            SendData2.Add("name", GetBase32GameAccount(GA));

            string signStr = AESEncryptToString(JsonConvert.SerializeObject(SendData2), GameKeyJSON["aes_key"].ToString(), GameKeyJSON["aes_iv"].ToString());
            SendData.Add("dc", GameKeyJSON["dc"].ToString());
            SendData.Add("x", signStr);

            ResponseStr = GetApiResult(GameKeyJSON, "", "POST", SendData);

            if (string.IsNullOrEmpty(ResponseStr) == false)
            {
                try
                {
                    ResponseJObj = JObject.Parse(ResponseStr);

                    if (ResponseJObj != null)
                    {
                        if (ResponseJObj["status"].ToString() == "0000")
                        {
                            Ret = true;
                        }else if (ResponseJObj["status"].ToString() == "7602") {
                            Ret = true;
                        }
                    }
                }
                catch (Exception ex)
                {

                }
            }

            return Ret;
        }

        public static GameLinkResult UserLogin(EWinGameCode.GameKey EGK, EWinGameCode.GameAccountId GA, string GameName, string EWinLang, EWin.enumUserDeviceType UDT, string HomeUrl = null)
        {
            GameLinkResult Ret = new GameLinkResult() { ResultCode = 1 };
            string ResponseStr;
            JObject ResponseJObj = null;
            JObject GameKeyJSON = EGK.ToJSONObject();
            System.Data.DataTable GameCodeDT;
            Dictionary<string, dynamic> SendData = new Dictionary<string, dynamic>();
            Dictionary<string, dynamic> SendData2 = new Dictionary<string, dynamic>();

            GameCodeDT = RedisCache.GameCode.GetGameCode(GameBrand + "." + GameName);
 
            SendData2.Add("action", 11);
            SendData2.Add("uid", GetBase32GameAccount(GA));
            SendData2.Add("ts", DateTimeOffset.UtcNow.ToUnixTimeMilliseconds());
            SendData2.Add("lang", ConvertLanguageCode(EWinLang));
            SendData2.Add("gType", (string)GameCodeDT.Rows[0]["ProviderCode"]);
            SendData2.Add("mType", GameName);
            SendData2.Add("moreGame", 0);
            SendData2.Add("isShowDollarSign", false);

            string signStr = AESEncryptToString(JsonConvert.SerializeObject(SendData2), GameKeyJSON["aes_key"].ToString(), GameKeyJSON["aes_iv"].ToString());
            SendData.Add("dc", GameKeyJSON["dc"].ToString());
            SendData.Add("x", signStr);

            ResponseStr = GetApiResult(GameKeyJSON, "", "POST", SendData);

            if (string.IsNullOrEmpty(ResponseStr) == false)
            {
                try
                {
                    ResponseJObj = JObject.Parse(ResponseStr);

                    if (ResponseJObj != null)
                    {
                        if ((string)ResponseJObj["status"] == "0000")
                        {
                                Ret.Url = (string)ResponseJObj["path"];
                                Ret.ResultCode = 0;
                        }
                        else
                        {
                            Ret.ResultCode = 1;
                            Ret.Message = (string)ResponseJObj["err_text"];
                        }
                    }
                    else
                    {
                        Ret.ResultCode = 1;
                        Ret.Message = "DeserializeFail";
                    }
                }
                catch (Exception ex)
                {
                    Ret.ResultCode = 1;
                    Ret.Message = ex.Message;
                }
            }
            else
            {
                Ret.ResultCode = 1;
                Ret.Message = "RequestFail";
            }

            return Ret;
        }

        public static GameLinkResult DemoLogin(EWinGameCode.GameKey EGK, string GameName, string EWinLang, EWin.enumUserDeviceType UDT, string HomeUrl = null)
        {
            GameLinkResult Ret = new GameLinkResult() { ResultCode = 1 };
            string ResponseStr;
            JObject ResponseJObj = null;
            JObject GameKeyJSON = EGK.ToJSONObject();
            System.Data.DataTable GameCodeDT;
            Dictionary<string, dynamic> SendData = new Dictionary<string, dynamic>();
            Dictionary<string, dynamic> SendData2 = new Dictionary<string, dynamic>();

            GameCodeDT = RedisCache.GameCode.GetGameCode(GameBrand + "." + GameName);

            SendData2.Add("action", 47);
            SendData2.Add("ts", DateTimeOffset.UtcNow.ToUnixTimeMilliseconds());
            SendData2.Add("lang", ConvertLanguageCode(EWinLang));
            SendData2.Add("gType", (string)GameCodeDT.Rows[0]["ProviderCode"]);
            SendData2.Add("mType", GameName);
            SendData2.Add("moreGame", 0);
            SendData2.Add("isShowDollarSign", false);

            string signStr = AESEncryptToString(JsonConvert.SerializeObject(SendData2), GameKeyJSON["aes_key"].ToString(), GameKeyJSON["aes_iv"].ToString());
            SendData.Add("dc", GameKeyJSON["dc"].ToString());
            SendData.Add("x", signStr);

            ResponseStr = GetApiResult(GameKeyJSON, "", "POST", SendData);

            if (string.IsNullOrEmpty(ResponseStr) == false)
            {
                try
                {
                    ResponseJObj = JObject.Parse(ResponseStr);

                    if (ResponseJObj != null)
                    {
                        if ((string)ResponseJObj["status"] == "0000")
                        {
                            Ret.Url = (string)ResponseJObj["path"];
                            Ret.ResultCode = 0;
                        }
                        else
                        {
                            Ret.ResultCode = 1;
                            Ret.Message = (string)ResponseJObj["err_text"];
                        }
                    }
                    else
                    {
                        Ret.ResultCode = 1;
                        Ret.Message = "DeserializeFail";
                    }
                }
                catch (Exception ex)
                {
                    Ret.ResultCode = 1;
                    Ret.Message = ex.Message;
                }
            }
            else
            {
                Ret.ResultCode = 1;
                Ret.Message = "RequestFail";
            }

            return Ret;
        }

        public static void UserLogout(EWinGameCode.GameKey EGK, EWinGameCode.GameAccountId GA)
        {
            JObject GameKeyJSON = EGK.ToJSONObject();
            Dictionary<string, dynamic> SendData = new Dictionary<string, dynamic>();
            Dictionary<string, dynamic> SendData2 = new Dictionary<string, dynamic>();

            SendData2.Add("action", 17);
            SendData2.Add("ts", DateTimeOffset.UtcNow.ToUnixTimeMilliseconds());
            SendData2.Add("uid", GetBase32GameAccount(GA));
            SendData2.Add("parent", GameKeyJSON["parent"].ToString());

            string signStr = AESEncryptToString(JsonConvert.SerializeObject(SendData2), GameKeyJSON["aes_key"].ToString(), GameKeyJSON["aes_iv"].ToString());
            SendData.Add("dc", GameKeyJSON["dc"].ToString());
            SendData.Add("x", signStr);

            GetApiResult(GameKeyJSON, "", "POST", SendData);
        }

        public static GetBalanceResult GetBalance(EWinGameCode.GameKey EGK, EWinGameCode.GameAccountId GA)
        {
            GetBalanceResult Ret = new GetBalanceResult() { ResultCode = 1 };
            string ResponseStr;
            JObject ResponseJObj = null;
            JObject GameKeyJSON = EGK.ToJSONObject();
            Dictionary<string, dynamic> SendData = new Dictionary<string, dynamic>();
            Dictionary<string, dynamic> SendData2 = new Dictionary<string, dynamic>();
            System.Data.DataTable TransDT;
            string EGameCode = string.Empty;
            RedisCache.Company.CompanyGameCodeExchange GCRate;

            TransDT = EWinDB.GameCodeTrans.GetGameCodeTrans(GA.UserAccountID, GA.CurrencyType, GameBrand);

            if (TransDT != null && TransDT.Rows.Count > 0)
            {
                EGameCode = (string)TransDT.Rows[0]["GameCode"];
            }
            else
            {
                EGameCode = "*";
            }

            GCRate = EWinGameCode.GameCodeWallet.GetExchangeByEWin(GA.CompanyID, GameBrand, EGameCode, GA.CurrencyType);

            SendData2.Add("action", 15);
            SendData2.Add("ts", DateTimeOffset.UtcNow.ToUnixTimeMilliseconds());
            SendData2.Add("parent", GameKeyJSON["parent"].ToString());
            SendData2.Add("uid", GetBase32GameAccount(GA));

            string signStr = AESEncryptToString(JsonConvert.SerializeObject(SendData2), GameKeyJSON["aes_key"].ToString(), GameKeyJSON["aes_iv"].ToString());
            SendData.Add("dc", GameKeyJSON["dc"].ToString());
            SendData.Add("x", signStr);

            ResponseStr = GetApiResult(GameKeyJSON, "", "POST", SendData);

            if (string.IsNullOrEmpty(ResponseStr) == false)
            {
                try
                {
                    ResponseJObj = JObject.Parse(ResponseStr);

                    if (ResponseJObj != null)
                    {
                        if ((string)ResponseJObj["status"] == "0000")
                        {
                            Ret.GameBalance = (decimal)ResponseJObj["data"][0]["balance"];
                            Ret.Balance = EWin.DecimalUnit(Ret.GameBalance, 2, (int)GA.CashUnit) / GCRate.CurrencyRate;
                            Ret.CurrencyType = GA.CurrencyType;
                            Ret.ResultCode = 0;
                        }
                        else
                        {
                            Ret.ResultCode = 1;
                            Ret.Message = (string)ResponseJObj["err_text"];
                        }
                    }
                    else
                    {
                        Ret.ResultCode = 1;
                        Ret.Message = "DeserializeFail";
                    }
                }
                catch (Exception ex)
                {
                    Ret.ResultCode = 1;
                    Ret.Message = ex.Message;
                }
            }
            else
            {
                Ret.ResultCode = 1;
                Ret.Message = "RequestFail";
            }

            return Ret;
        }

        /// <summary>
        /// 相同 QueryTransferStatus, 直接傳回交易結果 true/false 方便判斷
        /// </summary>
        /// <param name="EGK"></param>
        /// <param name="transfer_no"></param>
        /// <returns></returns>
        public static bool CheckTransferSuccess(EWinGameCode.GameKey EGK, string transfer_no, EWinGameCode.GameAccountId GA)
        {
            bool Ret = false;
            string ResponseStr;
            JObject ResponseJObj = null;
            JObject GameKeyJSON = EGK.ToJSONObject();
            Dictionary<string, dynamic> SendData = new Dictionary<string, dynamic>();
            Dictionary<string, dynamic> SendData2 = new Dictionary<string, dynamic>();

            SendData2.Add("action", 55);
            SendData2.Add("ts", DateTimeOffset.UtcNow.ToUnixTimeMilliseconds());
            SendData2.Add("parent", GameKeyJSON["parent"].ToString());
            SendData2.Add("serialNo", transfer_no);

            string signStr = AESEncryptToString(JsonConvert.SerializeObject(SendData2), GameKeyJSON["aes_key"].ToString(), GameKeyJSON["aes_iv"].ToString());
            SendData.Add("dc", GameKeyJSON["dc"].ToString());
            SendData.Add("x", signStr);

            ResponseStr = GetApiResult(GameKeyJSON, "", "POST", SendData);

            if (string.IsNullOrEmpty(ResponseStr) == false)
            {
                try
                {
                    ResponseJObj = JObject.Parse(ResponseStr);

                    if (ResponseJObj != null)
                    {
                        if ((string)ResponseJObj["status"] == "0000")
                        {
                            Ret = true;
                        }
                    }
                }
                catch (Exception ex)
                {

                }
            }

            return Ret;
        }

        public static TransferAPIResult TransferIn(EWinGameCode.GameKey EGK, EWinGameCode.GameAccountId GA, string transfer_no, decimal amount)
        {
            TransferAPIResult Ret = new TransferAPIResult() { ResultCode = 1 };
            string ResponseStr;
            JObject ResponseJObj = null;
            JObject GameKeyJSON = EGK.ToJSONObject();
            Dictionary<string, dynamic> SendData = new Dictionary<string, dynamic>();
            Dictionary<string, dynamic> SendData2 = new Dictionary<string, dynamic>();

            SendData2.Add("action", 19);
            SendData2.Add("ts", DateTimeOffset.UtcNow.ToUnixTimeMilliseconds());
            SendData2.Add("parent", GameKeyJSON["parent"].ToString());
            SendData2.Add("uid", GetBase32GameAccount(GA));
            SendData2.Add("serialNo", transfer_no);
            SendData2.Add("allCashOutFlag", "0");
            SendData2.Add("amount", amount);
      
            string signStr = AESEncryptToString(JsonConvert.SerializeObject(SendData2), GameKeyJSON["aes_key"].ToString(), GameKeyJSON["aes_iv"].ToString());
            SendData.Add("dc", GameKeyJSON["dc"].ToString());
            SendData.Add("x", signStr);

            ResponseStr = GetApiResult(GameKeyJSON, "", "POST", SendData);

            if (string.IsNullOrEmpty(ResponseStr) == false)
            {
                try
                {
                    ResponseJObj = JObject.Parse(ResponseStr);

                    if (ResponseJObj != null)
                    {
                        if ((string)ResponseJObj["status"] == "0000")
                        {
                            Ret.ResultCode = 0;
                            Ret.TransferAmount = amount;
                            Ret.Transfer_No = transfer_no;
                            Ret.GameCurrency = (string)GameKeyJSON["GameCurrencyType"];
                        }
                        else
                        {
                            Ret.ResultCode = 1;
                            Ret.Message = (string)ResponseJObj["err_text"];
                        }
                    }
                    else
                    {
                        Ret.ResultCode = 1;
                        Ret.Message = "DeserializeFail";
                    }
                }
                catch (Exception ex)
                {
                    Ret.ResultCode = 1;
                    Ret.Message = ex.Message;
                }
            }
            else
            {
                Ret.ResultCode = 1;
                Ret.Message = "RequestFail";
            }

            return Ret;         
        }

        public static TransferAPIResult TransferOut(EWinGameCode.GameKey EGK, EWinGameCode.GameAccountId GA, string transfer_no, decimal amount)
        {
            TransferAPIResult Ret = new TransferAPIResult() { ResultCode = 1 };
            string ResponseStr;
            JObject ResponseJObj = null;
            JObject GameKeyJSON = EGK.ToJSONObject();
            Dictionary<string, dynamic> SendData = new Dictionary<string, dynamic>();
            Dictionary<string, dynamic> SendData2 = new Dictionary<string, dynamic>();

            SendData2.Add("action", 19);
            SendData2.Add("ts", DateTimeOffset.UtcNow.ToUnixTimeMilliseconds());
            SendData2.Add("parent", GameKeyJSON["parent"].ToString());
            SendData2.Add("uid", GetBase32GameAccount(GA));
            SendData2.Add("serialNo", transfer_no);
            SendData2.Add("allCashOutFlag", "1");
            SendData2.Add("amount", amount*-1);

            string signStr = AESEncryptToString(JsonConvert.SerializeObject(SendData2), GameKeyJSON["aes_key"].ToString(), GameKeyJSON["aes_iv"].ToString());
            SendData.Add("dc", GameKeyJSON["dc"].ToString());
            SendData.Add("x", signStr);

            ResponseStr = GetApiResult(GameKeyJSON, "", "POST", SendData);

            if (string.IsNullOrEmpty(ResponseStr) == false)
            {
                try
                {
                    ResponseJObj = JObject.Parse(ResponseStr);

                    if (ResponseJObj != null)
                    {
                        if ((string)ResponseJObj["status"] == "0000")
                        {
                            Ret.ResultCode = 0;
                            Ret.TransferAmount = amount;
                            Ret.Transfer_No = transfer_no;
                            Ret.GameCurrency = (string)GameKeyJSON["GameCurrencyType"];
                        }
                        else
                        {
                            Ret.ResultCode = 1;
                            Ret.Message = (string)ResponseJObj["err_text"];
                        }
                    }
                    else
                    {
                        Ret.ResultCode = 1;
                        Ret.Message = "DeserializeFail";
                    }
                }
                catch (Exception ex)
                {
                    Ret.ResultCode = 1;
                    Ret.Message = ex.Message;
                }
            }
            else
            {
                Ret.ResultCode = 1;
                Ret.Message = "RequestFail";
            }

            return Ret;
        }

        public static string ConvertLanguageCode(string Lang)
        {
            string GameLang;

            switch (Lang)
            {
                case "ENG":
                    GameLang = "en";
                    break;
                case "CHT":
                    GameLang = "zh";
                    break;
                case "CHS":
                    GameLang = "zh";
                    break;
                case "JPN":
                    GameLang = "en";
                    break;
                case "KOR":
                    GameLang = "en";
                    break;
                case "THAI":
                    GameLang = "en";
                    break;
                case "VIET":
                    GameLang = "en";
                    break;
                case "IND":
                    //印尼
                    GameLang = "en";
                    break;
                case "HIND":
                    //印度
                    GameLang = "en";
                    break;
                case "TAM":
                    //坦米爾
                    GameLang = "en";
                    break;
                default:
                    GameLang = "en";
                    break;
            }

            return GameLang;
        }

        public static string CreateTransferNo()
        {
            /*
            由平台⽅⾃⾏產⽣的唯⼀單號
            「格式規範」
            timestamp＋「長度為3的隨機字串」
            e.g. 1604459259Ae5
            */
            string RndStr = CodingControl.RandomPassword(R, 3, "1234567890abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ");

            return GetTimestamp(System.DateTime.Now) + RndStr;
        }

        public static string GetApiResult(JObject GameKeyJSON, string ApiPath, string Method, Dictionary<string, dynamic> SendData)
        {
            string Ret;
            string ParamsStr = "";


            foreach (var item in SendData)
            {
                if (string.IsNullOrEmpty(ParamsStr))
                {
                    ParamsStr +=  item.Key + "=" + item.Value.ToString();
                }
                else
                {
                    ParamsStr += "&" + item.Key + "=" + item.Value.ToString();
                }
            }


            switch (Method.ToUpper())
            {
                case "POST":
                    Ret = CodingControl.GetWebTextContent(
                              URL: GameKeyJSON["APIUrl"].ToString() + ApiPath,
                              Method: "POST",
                              SendData: ParamsStr,
                              ContentType: "application/x-www-form-urlencoded"
                         );

                    break;
                case "GET":
                    ParamsStr = "?" + ParamsStr;

                    Ret = CodingControl.GetWebTextContent(
                     URL: GameKeyJSON["APIUrl"].ToString() + ApiPath + ParamsStr,
                     Method: "GET",
                     ContentType: "application/x-www-form-urlencoded"
                     );

                    break;
                default:
                    Ret = string.Empty;

                    break;
            }

            return Ret;
        }

        public static string GetOrderHistory(Newtonsoft.Json.Linq.JObject GameKeyJSON, string starttime,string endtime)
        {
            string Ret = "";
            Dictionary<string, dynamic> SendData = new Dictionary<string, dynamic>();
            Dictionary<string, dynamic> SendData2 = new Dictionary<string, dynamic>();

            SendData2.Add("action", 64);
            SendData2.Add("ts", DateTimeOffset.UtcNow.ToUnixTimeMilliseconds());
            SendData2.Add("parent", GameKeyJSON["parent"].ToString());
            SendData2.Add("endtime", endtime);
            SendData2.Add("starttime", starttime);

            string signStr = AESEncryptToString(JsonConvert.SerializeObject(SendData2), GameKeyJSON["aes_key"].ToString(), GameKeyJSON["aes_iv"].ToString());
            SendData.Add("dc", GameKeyJSON["dc"].ToString());
            SendData.Add("x", signStr);


            for (int _i = 0; _i < 3; _i++)
            {
                try
                {
                    Ret = GetApiResult(GameKeyJSON, "", "POST", SendData);
                }
                catch (Exception ex)
                {
                }

                if (string.IsNullOrEmpty(Ret) == false)
                {
                    break;
                }
            }

            return Ret;
        }

        public static string GetToken(Newtonsoft.Json.Linq.JObject GameKeyJSON)
        {
            string Ret = "";
            string ParamsStr = "";
            string ResponseStr;
            JObject ResponseJObj = null;


            Dictionary<string, string> SendData = new Dictionary<string, string>();
            SendData.Add("client_id", GameKeyJSON["client_id"].ToString());
            SendData.Add("client_secret", GameKeyJSON["client_secret"].ToString());
            SendData.Add("grant_type", GameKeyJSON["grant_type"].ToString());

            foreach (var item in SendData)
            {
                if (string.IsNullOrEmpty(ParamsStr))
                {
                    ParamsStr += item.Key + "=" + item.Value.ToString();
                }
                else
                {
                    ParamsStr += "&" + item.Key + "=" + item.Value.ToString();
                }
            }

            ResponseStr = CodingControl.GetWebTextContent(
                     URL: GameKeyJSON["TokenUrl"].ToString(),
                     Method: "POST",
                     SendData: ParamsStr,
                     ContentType: "application/x-www-form-urlencoded"
                     );

            if (string.IsNullOrEmpty(ResponseStr) == false)
            {
                try
                {
                    ResponseJObj = JObject.Parse(ResponseStr);

                    if (ResponseJObj != null)
                    {
                        Ret = ResponseJObj["token_type"].ToString() + " " + ResponseJObj["access_token"].ToString();
                    }

                }
                catch (Exception ex)
                {

                }
            }


            return Ret;
        }

    }

    #region Common

    public static ProviderSetting GetProverderSettingData(string ProviderCode)
    {
        ProviderSetting RetValue;
        //初始化設定檔資料
        string path = Pay.ProviderSettingPath + "\\" + (Pay.IsTestSite ? "Test" : "Official") + "\\" + ProviderCode + ".json";
        string jsonContent;
        using (FileStream stream = new FileStream(path, FileMode.Open, FileAccess.Read, FileShare.Read))
        {
            using (StreamReader sr = new StreamReader(stream))
            {
                jsonContent = sr.ReadToEnd();
            }
        }

        RetValue = JsonConvert.DeserializeObject<GatewayCommon.ProviderSetting>(jsonContent);
        return RetValue;
    }

    private static Random R = new Random();

    public static DateTime GetDateTimeFromTimestamp(long UnixTimestamp)
    {
        // Unix timestamp is seconds past epoch
        DateTime DT = new DateTime(1970, 1, 1, 0, 0, 0, 0, DateTimeKind.Utc);

        DT = DT.AddSeconds(UnixTimestamp).ToLocalTime();

        return DT;
    }

    public static long GetTimestamp(DateTime DT)
    {
        return Convert.ToInt64(DT.ToUniversalTime().Subtract(new System.DateTime(1970, 1, 1, 0, 0, 0, DateTimeKind.Utc)).TotalSeconds);
    }

    public static bool IsMobile(string RequestUserAgent)
    {
        string[] MobileDeviceAgent = new string[] { "iphone", "ipad", "ipod", "android" };
        bool isMobile = false;

        foreach (string eachKey in MobileDeviceAgent)
        {
            if (RequestUserAgent.ToUpper().IndexOf(eachKey.ToUpper()) != -1)
            {
                isMobile = true;
                break;
            }
        }

        return isMobile;
    }

    public static decimal GetDecimal(decimal v, int point)
    {
        string[] val = v.ToString().Split('.');
        return decimal.Round(Convert.ToDecimal(val[0] + "." + val[1].Substring(0, point)), point);
    }

    /// <summary>解密</summary>
    public static string AESEncryptToString(string JsonString, string key, string iv)
    {
        char[] padding = { '=' };
        var AESEncryptBytes = AESEncrypt(JsonString,key,iv);
        var URL_Safe_AESEncrypt_String = Convert.ToBase64String(AESEncryptBytes).TrimEnd(padding).Replace('+', '-').Replace('/','_');
        return URL_Safe_AESEncrypt_String;
    }

    private static byte[] AESEncrypt(string plainText,string key,string iv) {
        using (SymmetricAlgorithm des=Rijndael.Create())
        {
            byte[] inputByteArray = Encoding.UTF8.GetBytes(plainText);
            des.Key = Encoding.UTF8.GetBytes(key);
            des.IV= Encoding.UTF8.GetBytes(iv);
            var encrypter = des.CreateEncryptor();
            byte[] cipherBytes = encrypter.TransformFinalBlock(inputByteArray,0,inputByteArray.Length);

            return cipherBytes;
        }
    }

    public static string AESDecryptBase64(string sourceStr,string keyStr,string ivStr) {
        string decrypt = "";
        try
        {
            AesCryptoServiceProvider aes = new AesCryptoServiceProvider();
            aes.BlockSize = 128;
            aes.Mode = CipherMode.CBC;
            aes.Padding = PaddingMode.None;
            byte[] key = Encoding.UTF8.GetBytes(keyStr);
            byte[] iv = Encoding.UTF8.GetBytes(ivStr);
            aes.Key = key;
            aes.IV = iv;
            string source=sourceStr.Replace('-','+').Replace('_', '/');
            int addPaddingCounts = (4 - (source.Length % 4)) % 4;
            for (int i = 0; i < addPaddingCounts; i++)
            {
                source += "=";
            }
            byte[] dataByteArray = Convert.FromBase64String(source);
            using (MemoryStream ms=new MemoryStream())
            {
                using (CryptoStream cs= new CryptoStream(ms,aes.CreateDecryptor(),CryptoStreamMode.Write))
                {
                    cs.Write(dataByteArray, 0, dataByteArray.Length);
                    cs.FlushFinalBlock();
                    decrypt = Encoding.UTF8.GetString(ms.ToArray());
                }
            }
        }
        catch (Exception e)
        {
            throw;
        }
        return decrypt;
    }
    #endregion

    #region Model

    public class Provider
    {
        public string ProviderCode { get; set; }
        public string ProviderName { get; set; }
        public string Introducer { get; set; }
        public string ProviderUrl { get; set; }
        public int ProviderAPIType { get; set; }
        public int CollectType { get; set; }
        public string MerchantCode { get; set; }
        public string MerchantKey { get; set; }
        public string NotifyAsyncUrl { get; set; }
        public string WithdrawNotifyAsyncUrl { get; set; }
        public string NotifySyncUrl { get; set; }
        public int ProviderState { get; set; }

    }

    public class ProviderSetting : Provider
    {
        public string QueryOrderUrl { get; set; }
        public List<string> ProviderIP { get; set; }
        public string NotifyAsyncIP { get; set; }
        public string QueryBalanceUrl { get; set; }
        public string WithdrawUrl { get; set; }
        public string QueryWithdrawUrl { get; set; }
        public string RequestWithdrawIP { get; set; }
        public string ProviderPublicKey { get; set; }
        public string Charset { get; set; }
        public string CallBackUrl { get; set; }
        public ProviderRequestType RequestType { get; set; }
        public List<ServiceSetting> ServiceSettings { get; set; }
        public List<BankCodeSetting> CityCodeSettings { get; set; }
        public List<BankCodeSetting> ProvinceCodeSettings { get; set; }
        public List<BankCodeSetting> BankCodeSettings { get; set; }
        public List<CurrencyTypeSetting> CurrencyTypeSettings { get; set; }
        public List<string> OtherDatas { get; set; }
    }

    public enum ProviderRequestType
    {
        FormData = 0,
        Json = 1,
        RedirectUrl = 2
    }

    public class ServiceSetting
    {
        public string ServiceType { get; set; }
        public string TradeType { get; set; }
        public string UrlType { get; set; }
    }

    public class BankCodeSetting
    {
        public string BankCode { get; set; }
        public string ProviderBankCode { get; set; }
    }

    public class CurrencyTypeSetting
    {
        public string CurrencyType { get; set; }
        public string ProviderCurrencyType { get; set; }
    }

    public class APIResult
    {
        public int ResultCode { get; set; }
        public string Message { get; set; }
    }

    public class GameLinkResult : APIResult
    {
        public string Url { get; set; }
    }

    public class GetBalanceResult : APIResult
    {
        public string CurrencyType { get; set; }
        public decimal Balance { get; set; }
        public decimal GameBalance { get; set; }
    }

    public class UserIsOnlineResult : APIResult
    {
        public bool LoginStatus { get; set; }
    }

    public class TransferAPIResult : APIResult
    {
        public string Transfer_No { get; set; }
        public string GameCurrency { get; set; }
        public decimal TransferAmount { get; set; }
    }

    public class TransferResult : APIResult
    {
        public string CurrencyType { get; set; }
        public decimal Amount { get; set; }
    }

    #endregion

}
// end of public partial class Common
