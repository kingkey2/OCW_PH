using Microsoft.CSharp.RuntimeBinder;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Web;

/// <summary>
/// Payment 的摘要描述
/// </summary>
public class Payment
{
    public Payment()
    {
        //
        // TODO: 在這裡新增建構函式邏輯
        //
    }

    public static class EPay
    {
        public static string SettingFile = "EPaySetting.json";
        public static APIResult CreateEPayWithdrawal(string OrderID, decimal OrderAmount, DateTime OrderDateTime, string BankCard, string BankCardName, string BankName, string BankBranchCode, string PhoneNumber, string ProviderCode, string ServiceType)
        {
            APIResult R = new APIResult() { ResultState = APIResult.enumResultCode.ERR };
            JObject sendData = new JObject();
            string URL;
            string ReturnURL;
            string Path;
            string CompanyCode;
            string CurrencyType;
            string CompanyKey;
            string Sign;
            string result = "";
            string token = EWinWeb.EPayToken;
            dynamic EPAYSetting = null;
            JObject returnResult;

            if (EWinWeb.IsTestSite)
            {
                Path = HttpContext.Current.Server.MapPath("/App_Data/EPay/Test_" + SettingFile);
            }
            else
            {
                Path = HttpContext.Current.Server.MapPath("/App_Data/EPay/Formal_" + SettingFile);
            }

            if (System.IO.File.Exists(Path))
            {
                string SettingContent;

                SettingContent = System.IO.File.ReadAllText(Path);

                if (string.IsNullOrEmpty(SettingContent) == false)
                {
                    try { EPAYSetting = Newtonsoft.Json.JsonConvert.DeserializeObject(SettingContent); } catch (Exception ex) { }
                }
            }

            if (EPAYSetting == null)
            {
                R.Message = "Get EPaySetting Fail";
                return R;
            }

            URL = (string)EPAYSetting.ApiUrl + "RequireWithdraw3";
            ReturnURL = EWinWeb.CasinoWorldUrl2 + "/Payment/EPay/WithdrawalCallback.aspx";
            CompanyCode = (string)EPAYSetting.CompanyCode;
            CurrencyType = (string)EPAYSetting.CyrrencyType;
            CompanyKey = (string)EPAYSetting.ApiKey;

            Sign = GetEPayWithdrawSign(OrderID, OrderAmount, OrderDateTime, CurrencyType, CompanyCode, CompanyKey);

            if (BankName.ToUpper() == "GCASH")
            {
                sendData.Add("BankCard", PhoneNumber);
                sendData.Add("BankCardName", "BankCardName");
                sendData.Add("BankComponentName", "BankBranchCode");
            }
            else
            {
                sendData.Add("BankCardName", BankCardName);
                sendData.Add("BankComponentName", "BankBranchCode");
                sendData.Add("BankCard", BankCard);
            }
            sendData.Add("ManageCode", CompanyCode);
            sendData.Add("Currency", CurrencyType);
            sendData.Add("OrderAmount", OrderAmount);
            sendData.Add("BankName", BankName);
            sendData.Add("ProviderCode", ProviderCode);
            sendData.Add("ServiceType", ServiceType);
            sendData.Add("OwnProvince", "OwnProvince");
            sendData.Add("OwnCity", "OwnCity");
            sendData.Add("OrderID", OrderID);
            sendData.Add("OrderDate", OrderDateTime.ToString("yyyy-MM-dd HH:mm:ss"));
            sendData.Add("RevolveUrl", ReturnURL);
            sendData.Add("ClientIP", CodingControl.GetUserIP());
            sendData.Add("Sign", Sign);

            using (HttpClientHandler handler = new HttpClientHandler())
            {
                using (HttpClient client = new HttpClient(handler))
                {
                    try
                    {
                        #region 呼叫遠端 Web API

                        HttpRequestMessage request = new HttpRequestMessage(HttpMethod.Post, URL);
                        HttpResponseMessage response = null;

                        #region  設定相關網址內容

                        // Accept 用於宣告客戶端要求服務端回應的文件型態 (底下兩種方法皆可任選其一來使用)
                        //client.DefaultRequestHeaders.Accept.TryParseAdd("application/json");
                        client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
                        client.DefaultRequestHeaders.TryAddWithoutValidation("token", token);
                        // Content-Type 用於宣告遞送給對方的文件型態
                        //client.DefaultRequestHeaders.TryAddWithoutValidation("Content-Type", "application/json");


                        // 將 data 轉為 json
                        string json = sendData.ToString();
                        request.Content = new StringContent(json, System.Text.Encoding.UTF8, "application/json");
                        response = client.SendAsync(request).GetAwaiter().GetResult();

                        #endregion
                        #endregion

                        #region 處理呼叫完成 Web API 之後的回報結果
                        if (response != null)
                        {
                            if (response.IsSuccessStatusCode == true)
                            {
                                // 取得呼叫完成 API 後的回報內容
                                result = response.Content.ReadAsStringAsync().GetAwaiter().GetResult();

                            }
                            else
                            {
                                result = response.Content.ReadAsStringAsync().GetAwaiter().GetResult();

                            }
                        }
                        else
                        {
                            R.Message = result;
                            return R;
                        }
                        #endregion

                    }
                    catch (Exception ex)
                    {
                        R.Message = "Create Order Fail:" + ex.Message;
                        return R;
                    }
                }
            }

            if (!string.IsNullOrEmpty(result))
            {
                returnResult = Newtonsoft.Json.JsonConvert.DeserializeObject<Newtonsoft.Json.Linq.JObject>(result);
                if (returnResult["Status"].ToString() == "0")
                {
                    R.ResultState = APIResult.enumResultCode.OK;
                    return R;
                }
                else
                {
                    R.Message = returnResult["Message"].ToString();
                    return R;
                }
            }
            else
            {
                R.Message = "Send to EPay Fail";
                return R;
            }
        }

        public static EPayDepositPaymentResult CreateEPayDeposite(string OrderID, decimal OrderAmount, string Type, string UserName, string ContactPhoneNumber, string ServiceType, string ProviderCode)
        {
            EPayDepositPaymentResult R = new EPayDepositPaymentResult() { ResultState = APIResult.enumResultCode.ERR };
            JObject sendData = new JObject();
            string URL;
            string ReturnURL;
            string Path;
            string CompanyCode;
            string CurrencyType;
            string CompanyKey;
            DateTime OrderDate = DateTime.Now;
            string Sign;
            string result = "";
            System.Data.DataTable DT = new System.Data.DataTable();
            string token = EWinWeb.EPayToken;
            decimal JPYRate = 0;
            dynamic EPAYSetting = null;
            JObject returnResult;

            if (ProviderCode == "Feibao")
            {
                if (ServiceType == "PHP01")
                {
                    ProviderCode = "FeibaoPay";
                }
                else if (ServiceType == "PHP02")
                {
                    ProviderCode = "FeibaoPayGrabpay";
                }
                else if (ServiceType == "PHP03")
                {
                    ProviderCode = "FeibaoPayPaymaya";
                }
                else if (ServiceType == "PHP08")
                {
                    ProviderCode = "FeibaoPayBank";
                }
            }

            if (EWinWeb.IsTestSite)
            {
                Path = HttpContext.Current.Server.MapPath("/App_Data/EPay/Test_" + SettingFile);
            }
            else
            {
                Path = HttpContext.Current.Server.MapPath("/App_Data/EPay/Formal_" + SettingFile);
            }

            if (System.IO.File.Exists(Path))
            {
                string SettingContent;

                SettingContent = System.IO.File.ReadAllText(Path);

                if (string.IsNullOrEmpty(SettingContent) == false)
                {
                    try { EPAYSetting = Newtonsoft.Json.JsonConvert.DeserializeObject(SettingContent); } catch (Exception ex) { }
                }
            }

            if (EPAYSetting == null)
            {
                R.Message = "Get EPaySetting Fail";
                return R;
            }

            URL = (string)EPAYSetting.ApiUrl + "RequirePayingReturnUrl2";

            ReturnURL = EWinWeb.CasinoWorldUrl2 + "/Payment/EPay/PaymentCallback.aspx";

            CompanyCode = (string)EPAYSetting.CompanyCode;
            CurrencyType = (string)EPAYSetting.CyrrencyType;
            CompanyKey = (string)EPAYSetting.ApiKey;
            sendData.Add("ManageCode", CompanyCode);
            sendData.Add("Currency", CurrencyType);
            sendData.Add("Service", ServiceType);
            sendData.Add("CustomerIP", CodingControl.GetUserIP());
            sendData.Add("OrderID", OrderID);
            sendData.Add("OrderDate", OrderDate.ToString("yyyy-MM-dd HH:mm:ss"));
            Sign = GetEPayDepositSign(OrderID, OrderAmount, OrderDate, ServiceType, CurrencyType, CompanyCode, CompanyKey);
            sendData.Add("OrderAmount", OrderAmount.ToString("#.##"));
            sendData.Add("ProviderCode", ProviderCode);
            sendData.Add("RevolveURL", ReturnURL);
            sendData.Add("UserName", UserName);
            sendData.Add("State", ContactPhoneNumber);
            sendData.Add("Sign", Sign);

            using (HttpClientHandler handler = new HttpClientHandler())
            {
                using (HttpClient client = new HttpClient(handler))
                {
                    try
                    {
                        #region 呼叫遠端 Web API

                        HttpRequestMessage request = new HttpRequestMessage(HttpMethod.Post, URL);
                        HttpResponseMessage response = null;

                        #region  設定相關網址內容

                        // Accept 用於宣告客戶端要求服務端回應的文件型態 (底下兩種方法皆可任選其一來使用)
                        //client.DefaultRequestHeaders.Accept.TryParseAdd("application/json");
                        client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
                        client.DefaultRequestHeaders.TryAddWithoutValidation("token", token);
                        // Content-Type 用於宣告遞送給對方的文件型態
                        //client.DefaultRequestHeaders.TryAddWithoutValidation("Content-Type", "application/json");


                        // 將 data 轉為 json
                        string json = sendData.ToString();
                        request.Content = new StringContent(json, System.Text.Encoding.UTF8, "application/json");
                        response = client.SendAsync(request).GetAwaiter().GetResult();

                        #endregion
                        #endregion

                        #region 處理呼叫完成 Web API 之後的回報結果
                        if (response != null)
                        {
                            if (response.IsSuccessStatusCode == true)
                            {
                                // 取得呼叫完成 API 後的回報內容
                                result = response.Content.ReadAsStringAsync().GetAwaiter().GetResult();
                            }
                            else
                            {
                                result = response.Content.ReadAsStringAsync().GetAwaiter().GetResult();
                            }
                        }
                        else
                        {
                            R.Message = result;
                            return R;
                        }
                        #endregion

                    }
                    catch (Exception ex)
                    {
                        R.Message = "Create Order Fail:" + ex.Message;
                        return R;
                    }
                }
            }

            if (!string.IsNullOrEmpty(result))
            {
                returnResult = Newtonsoft.Json.JsonConvert.DeserializeObject<Newtonsoft.Json.Linq.JObject>(result);
                if (returnResult["Status"].ToString() == "0")
                {
                    R.ResultState = APIResult.enumResultCode.OK;
                    R.Message = returnResult["Message"].ToString();
                    R.ProviderCode = returnResult["Code"].ToString();
                    return R;
                }
                else
                {
                    R.Message = returnResult["Message"].ToString();
                    return R;
                }
            }
            else
            {
                R.Message = "Send to EPay Fail";
                return R;
            }
        }

        public static string GetEPayDepositSign(string OrderID, decimal OrderAmount, DateTime OrderDateTime, string ServiceType, string CurrencyType, string CompanyCode, string CompanyKey)
        {
            string sign;
            string signStr = "ManageCode=" + CompanyCode;
            signStr += "&Currency=" + CurrencyType;
            signStr += "&Service=" + ServiceType;
            signStr += "&OrderID=" + OrderID;
            signStr += "&OrderAmount=" + OrderAmount.ToString("#.##");
            signStr += "&OrderDate=" + OrderDateTime.ToString("yyyy-MM-dd HH:mm:ss");
            signStr += "&CompanyKey=" + CompanyKey;

            sign = CodingControl.GetSHA256(signStr, false).ToUpper();

            return sign;
        }

        private static string GetEPayWithdrawSign(string OrderID, decimal OrderAmount, DateTime OrderDateTime, string CurrencyType, string CompanyCode, string CompanyKey)
        {
            string sign;
            string signStr = "ManageCode=" + CompanyCode;
            signStr += "&Currency=" + CurrencyType;
            signStr += "&OrderID=" + OrderID;
            signStr += "&OrderAmount=" + OrderAmount.ToString("#.##");
            signStr += "&OrderDate=" + OrderDateTime.ToString("yyyy-MM-dd HH:mm:ss");
            signStr += "&CompanyKey=" + CompanyKey;

            sign = CodingControl.GetSHA256(signStr, false);
            return sign.ToUpper();
        }

    }
    public static class FIFIPAY
    {
        public static string SettingFile = "FIFIPay.json";

        public static EPayDepositPaymentResult CreateDeposite(string OrderID, decimal OrderAmount, string UserName, string ContactPhoneNumber, string ServiceType)
        {
            Common.ProviderSetting SettingData = Common.GetProverderSetting(SettingFile);
            EPayDepositPaymentResult R = new EPayDepositPaymentResult() { ResultState = APIResult.enumResultCode.ERR };
            string result;
            string sign;
            string signStr = "";
            Dictionary<string, string> sendDic = new Dictionary<string, string>();
            Int32 unixTimestamp = (int)DateTime.UtcNow.Subtract(new DateTime(1970, 1, 1)).TotalSeconds;

            sendDic.Add("pay_customer_id", SettingData.MerchantCode);//
            sendDic.Add("pay_apply_date", unixTimestamp.ToString());//
            sendDic.Add("pay_order_id", OrderID);//
            sendDic.Add("pay_notify_url", SettingData.NotifyAsyncUrl);//
            sendDic.Add("pay_amount", OrderAmount.ToString("#.##"));//
            sendDic.Add("pay_channel_id", "1889");//

            sendDic = Common.AsciiDictionary(sendDic);

            foreach (KeyValuePair<string, string> item in sendDic)
            {
                signStr += item.Key + "=" + item.Value + "&";
            }

            signStr = signStr + "key=" + SettingData.MerchantKey;

            sign = CodingControl.GetMD5(signStr, false).ToUpper();

            sendDic.Add("pay_md5_sign", sign);

            Common.InsertPaymentTransferLog("(充值單)建立訂單:" + JsonConvert.SerializeObject(sendDic), SettingData.ProviderCode, OrderID);

            using (HttpClientHandler handler = new HttpClientHandler())
            {
                using (HttpClient client = new HttpClient(handler))
                {
                    try
                    {
                        #region 呼叫遠端 Web API

                        HttpRequestMessage request = new HttpRequestMessage(HttpMethod.Post, SettingData.ProviderUrl);
                        HttpResponseMessage response = null;

                        #region  設定相關網址內容

                        // Accept 用於宣告客戶端要求服務端回應的文件型態 (底下兩種方法皆可任選其一來使用)
                        //client.DefaultRequestHeaders.Accept.TryParseAdd("application/json");
                        client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
                        // Content-Type 用於宣告遞送給對方的文件型態
                        //client.DefaultRequestHeaders.TryAddWithoutValidation("Content-Type", "application/json");


                        // 將 data 轉為 json
                        string json = JsonConvert.SerializeObject(sendDic);
                        request.Content = new StringContent(json, System.Text.Encoding.UTF8, "application/json");
                        response = client.SendAsync(request).GetAwaiter().GetResult();

                        #endregion
                        #endregion

                        #region 處理呼叫完成 Web API 之後的回報結果
                        if (response != null)
                        {
                            if (response.IsSuccessStatusCode == true)
                            {
                                // 取得呼叫完成 API 後的回報內容
                                result = response.Content.ReadAsStringAsync().GetAwaiter().GetResult();
                            }
                            else
                            {
                                result = response.Content.ReadAsStringAsync().GetAwaiter().GetResult();
                            }
                        }
                        else
                        {
                            R.Message = "Create Order Fail";
                            Common.InsertPaymentTransferLog("(充值單)供應商回傳為空值", SettingData.ProviderCode, OrderID);
                            return R;
                        }
                        #endregion

                    }
                    catch (Exception ex)
                    {
                        R.Message = "Create Order Fail";
                        Common.InsertPaymentTransferLog("(充值單)呼叫供應商API失敗:" + ex.Message, SettingData.ProviderCode, OrderID);
                        return R;
                    }
                }
            }

            try
            {
                if (!string.IsNullOrEmpty(result))
                {
                    JObject revjsonObj = JObject.Parse(result);

                    if (revjsonObj != null && revjsonObj["code"].ToString() == "0" && revjsonObj["message"].ToString().ToLower() == "success")
                    {
                        R.ResultState = APIResult.enumResultCode.OK;
                        R.Message = revjsonObj["data"]["view_url"].ToString().Replace("\\", "");
                        R.ProviderCode = SettingData.ProviderCode;

                        Common.InsertPaymentTransferLog("(充值單)申請完成:" + result, SettingData.ProviderCode, OrderID);
                        return R;
                    }
                    else
                    {
                        Common.InsertPaymentTransferLog("(充值單)供應商回傳有誤:" + result, SettingData.ProviderCode, OrderID);
                        return R;
                    }
                }
                else
                {
                    return R;
                }
            }
            catch (Exception ex)
            {
                Common.InsertPaymentTransferLog("(充值單)系統錯誤:" + ex.Message, SettingData.ProviderCode, OrderID);
                return R;
            }
        }

        public static Common.PaymentByProvider QueryPayment(string OrderID)
        {
            Common.ProviderSetting SettingData = Common.GetProverderSetting(SettingFile);

            Common.PaymentByProvider Ret = new Common.PaymentByProvider() { IsQuerySuccess = false, IsPaymentSuccess = false, ProviderCode = SettingData.ProviderCode };

            string sign;
            string result;
            string signStr = "";
            Int32 unixTimestamp = (int)DateTime.UtcNow.Subtract(new DateTime(1970, 1, 1)).TotalSeconds;
            Dictionary<string, string> sendDic = new Dictionary<string, string>();

            sendDic.Add("pay_customer_id", SettingData.MerchantCode);//
            sendDic.Add("pay_apply_date", unixTimestamp.ToString());//
            sendDic.Add("pay_order_id", OrderID);//

            sendDic = Common.AsciiDictionary(sendDic);

            foreach (KeyValuePair<string, string> item in sendDic)
            {
                signStr += item.Key + "=" + item.Value + "&";
            }

            signStr = signStr + "key=" + SettingData.MerchantKey;

            sign = CodingControl.GetMD5(signStr, false).ToUpper();

            sendDic.Add("pay_md5_sign", sign);

            using (HttpClientHandler handler = new HttpClientHandler())
            {
                using (HttpClient client = new HttpClient(handler))
                {
                    try
                    {
                        #region 呼叫遠端 Web API

                        HttpRequestMessage request = new HttpRequestMessage(HttpMethod.Post, SettingData.QueryOrderUrl);
                        HttpResponseMessage response = null;

                        #region  設定相關網址內容

                        // Accept 用於宣告客戶端要求服務端回應的文件型態 (底下兩種方法皆可任選其一來使用)
                        //client.DefaultRequestHeaders.Accept.TryParseAdd("application/json");
                        client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
                        // Content-Type 用於宣告遞送給對方的文件型態
                        //client.DefaultRequestHeaders.TryAddWithoutValidation("Content-Type", "application/json");


                        // 將 data 轉為 json
                        string json = JsonConvert.SerializeObject(sendDic);
                        request.Content = new StringContent(json, System.Text.Encoding.UTF8, "application/json");
                        response = client.SendAsync(request).GetAwaiter().GetResult();

                        #endregion
                        #endregion

                        #region 處理呼叫完成 Web API 之後的回報結果
                        if (response != null)
                        {
                            if (response.IsSuccessStatusCode == true)
                            {
                                // 取得呼叫完成 API 後的回報內容
                                result = response.Content.ReadAsStringAsync().GetAwaiter().GetResult();
                                Ret.IsQuerySuccess = true;
                            }
                            else
                            {
                                result = response.Content.ReadAsStringAsync().GetAwaiter().GetResult();
                            }
                        }
                        else
                        {

                            Common.InsertPaymentTransferLog("(充值單查詢)供應商回傳為空值", SettingData.ProviderCode, OrderID);
                            return Ret;
                        }
                        #endregion

                    }
                    catch (Exception ex)
                    {
                        Common.InsertPaymentTransferLog("(充值單查詢)呼叫供應商API失敗:" + ex.Message, SettingData.ProviderCode, OrderID);
                        return Ret;
                    }
                }
            }

            try
            {
                if (!string.IsNullOrEmpty(result))
                {
                    JObject revjsonObj = JObject.Parse(result);

                    if (revjsonObj != null && revjsonObj["code"].ToString() == "0" && revjsonObj["message"].ToString().ToLower() == "success")
                    {
                        if (revjsonObj["data"]["status"].ToString().ToUpper() == "1" || revjsonObj["data"]["status"].ToString().ToUpper() == "2")
                        {
                            Common.InsertPaymentTransferLog("(充值單查詢)成功", SettingData.ProviderCode, OrderID);
                            Ret.IsPaymentSuccess = true;
                        }
                        else
                        {
                            Common.InsertPaymentTransferLog("(充值單查詢)處理中", SettingData.ProviderCode, OrderID);
                            Ret.IsPaymentSuccess = false;
                        }

                        return Ret;

                    }
                    else
                    {
                        Common.InsertPaymentTransferLog("(充值單查詢)訂單狀態不符:" + result, SettingData.ProviderCode, OrderID);
                        Ret.IsPaymentSuccess = false;
                        return Ret;
                    }
                }
                else
                {
                    Common.InsertPaymentTransferLog("(充值單查詢)回傳為空值", SettingData.ProviderCode, OrderID);
                    Ret.IsPaymentSuccess = false;
                    return Ret;
                }
            }
            catch (Exception ex)
            {
                Common.InsertPaymentTransferLog("(充值單查詢)系統錯誤:" + ex.Message, SettingData.ProviderCode, OrderID);
                Ret.IsPaymentSuccess = false;
                return Ret;
            }
        }

        public static Common.ReturnWithdrawByProvider CreateWithdrawal(string OrderID, decimal OrderAmount, DateTime OrderDateTime, string BankCard, string BankCardName, string BankName, string BankBranchCode, string PhoneNumber, string ProviderCode, string ServiceType)
        {
            Common.ProviderSetting SettingData = Common.GetProverderSetting(SettingFile);
            Common.ReturnWithdrawByProvider R = new Common.ReturnWithdrawByProvider() { ReturnResult = "", UpOrderID = "", SendStatus = 0 };
            Dictionary<string, string> sendDic = new Dictionary<string, string>();
            string result;
            string sign;
            string signStr = "";
            Int32 unixTimestamp = (int)DateTime.UtcNow.Subtract(new DateTime(1970, 1, 1)).TotalSeconds;
            try
            {
                sendDic.Add("pay_customer_id", SettingData.MerchantCode);//
                sendDic.Add("pay_apply_date", unixTimestamp.ToString());//
                sendDic.Add("pay_order_id", OrderID);//
                sendDic.Add("pay_notify_url", SettingData.WithdrawNotifyAsyncUrl);//
                sendDic.Add("pay_amount", OrderAmount.ToString("#.##"));//
                sendDic.Add("pay_account_name", BankCardName);//
                sendDic.Add("pay_card_no", BankCard);//
                sendDic.Add("pay_bank_name", BankName);//

                sendDic = Common.AsciiDictionary(sendDic);

                foreach (KeyValuePair<string, string> item in sendDic)
                {
                    signStr += item.Key + "=" + item.Value + "&";
                }

                signStr = signStr + "key=" + SettingData.MerchantKey;

                sign = CodingControl.GetMD5(signStr, false).ToUpper();

                sendDic.Add("pay_md5_sign", sign);


                Common.InsertPaymentTransferLog("(提現單)建立訂單:" + JsonConvert.SerializeObject(sendDic), SettingData.ProviderCode, OrderID);

                using (HttpClientHandler handler = new HttpClientHandler())
                {
                    using (HttpClient client = new HttpClient(handler))
                    {
                        try
                        {
                            #region 呼叫遠端 Web API

                            HttpRequestMessage request = new HttpRequestMessage(HttpMethod.Post, SettingData.WithdrawUrl);
                            HttpResponseMessage response = null;

                            #region  設定相關網址內容

                            // Accept 用於宣告客戶端要求服務端回應的文件型態 (底下兩種方法皆可任選其一來使用)
                            //client.DefaultRequestHeaders.Accept.TryParseAdd("application/json");
                            client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
                            // Content-Type 用於宣告遞送給對方的文件型態
                            //client.DefaultRequestHeaders.TryAddWithoutValidation("Content-Type", "application/json");


                            // 將 data 轉為 json
                            string json = JsonConvert.SerializeObject(sendDic);
                            request.Content = new StringContent(json, System.Text.Encoding.UTF8, "application/json");
                            response = client.SendAsync(request).GetAwaiter().GetResult();

                            #endregion
                            #endregion

                            #region 處理呼叫完成 Web API 之後的回報結果
                            if (response != null)
                            {
                                if (response.IsSuccessStatusCode == true)
                                {
                                    // 取得呼叫完成 API 後的回報內容
                                    result = response.Content.ReadAsStringAsync().GetAwaiter().GetResult();
                                }
                                else
                                {
                                    result = response.Content.ReadAsStringAsync().GetAwaiter().GetResult();
                                }
                            }
                            else
                            {
                                Common.InsertPaymentTransferLog("(提現單)供應商回傳為空值", SettingData.ProviderCode, OrderID);
                                return R;
                            }
                            #endregion

                        }
                        catch (Exception ex)
                        {
                            Common.InsertPaymentTransferLog("(提現單)呼叫供應商API失敗:" + ex.Message, SettingData.ProviderCode, OrderID);
                            return R;
                        }
                    }
                }

                if (!string.IsNullOrEmpty(result))
                {

                    JObject revjsonObj = JObject.Parse(result);
                    if (revjsonObj != null && revjsonObj["code"].ToString() == "0" && revjsonObj["message"].ToString().ToLower() == "success")
                    {
                        R.SendStatus = 1;
                        R.UpOrderID = "";
                        R.WithdrawSerial = OrderID;
                        R.ReturnResult = result;
                        Common.InsertPaymentTransferLog("(提現單)申請完成:" + result, SettingData.ProviderCode, OrderID);
                    }
                    else
                    {

                        Common.InsertPaymentTransferLog("(提現單)回傳有誤:" + result, SettingData.ProviderCode, OrderID);
                        R.ReturnResult = result;
                        R.SendStatus = 0;
                    }

                }
                else
                {

                    Common.InsertPaymentTransferLog("(提現單)回傳為空值", SettingData.ProviderCode, OrderID);
                    R.ReturnResult = "";
                    R.SendStatus = 0;
                }
            }
            catch (Exception ex)
            {
                Common.InsertPaymentTransferLog("(提現單)系統錯誤:" + ex.Message, SettingData.ProviderCode, OrderID);
                R.ReturnResult = ex.Message;
                R.SendStatus = 0;
            }
            return R;
        }

    }

    public static class PayPal
    {
        public static string SettingFile = "PayPalSetting.json";

        public static dynamic PayPalSetting;
        public static dynamic ExchangeRateSetting;

        public static APIResult CreatePayPalPayment(string CurrencyType, decimal Amount, string Lang, string OrderNumber)
        {
            PayPalSetting = LoadSetting();
            APIResult result = new APIResult();
            APIResult result_token = new APIResult();
            string PayPalToken;

            result_token = GetToken();

            if (result_token.ResultState == APIResult.enumResultCode.OK)
            {
                PayPalToken = result_token.Message;
                result = CreatePayment(CurrencyType, Amount, PayPalToken, Lang, OrderNumber);
            }
            else
            {
                result.ResultState = APIResult.enumResultCode.ERR;
                result.Message = result_token.Message;
            }

            return result;
        }

        private static APIResult GetToken()
        {
            PayPalSetting = LoadSetting();
            APIResult result = new APIResult();
            Newtonsoft.Json.Linq.JObject returnResult;
            JObject jsonContent = new JObject();
            string GetTokenURL = PayPalSetting.ApiUrl + "/v1/oauth2/token";

            jsonContent.Add("grant_type", "client_credentials");

            returnResult = CodingControl.GetWebJSONContent(GetTokenURL, "POST", "grant_type=client_credentials", GetTokenHeaderString(PayPalSetting.Username.ToString(), PayPalSetting.Password.ToString()), "application/x-www-form-urlencoded");

            try
            {
                if (returnResult["access_token"] != null)
                {
                    result.ResultState = APIResult.enumResultCode.OK;
                    result.Message = returnResult["access_token"].ToString();
                }
                else
                {
                    result.ResultState = APIResult.enumResultCode.ERR;
                    result.Message = "No token";
                }
            }
            catch (RuntimeBinderException)
            {

                result.ResultState = APIResult.enumResultCode.ERR;
                result.Message = "GetToken Error";
            }

            return result;
        }

        private static APIResult CreatePayment(string CurrencyType, decimal Amount, string PaypalToken, string Lang, string OrderNumber)
        {
            PayPalSetting = LoadSetting();
            APIResult result = new APIResult() { ResultState = APIResult.enumResultCode.ERR };
            JObject returnResult;
            JObject jsonContent = new JObject();
            JObject application_context = new JObject();
            JArray purchase_units = new JArray();
            JObject amount = new JObject();
            JObject amount1 = new JObject();
            JObject returnMsg = new JObject();
            string PayPalLang;

            switch (Lang)
            {
                case "CHT":
                    PayPalLang = "zh-TW";
                    break;
                case "CHS":
                    PayPalLang = "zh-CN";
                    break;
                case "JPN":
                    PayPalLang = "ja-JP";
                    break;
                default:
                    PayPalLang = "ja-JP";
                    break;
            }

            string GetTokenURL = PayPalSetting.ApiUrl + "/v2/checkout/orders";

            amount1.Add("currency_code", CurrencyType);
            amount1.Add("value", (int)(Math.Ceiling(Amount)));
            amount.Add("amount", amount1);
            purchase_units.Add(amount);

            application_context.Add("locale", PayPalLang);
            application_context.Add("landing_page", "BILLING");
            application_context.Add("user_action", "CONTINUE");
            application_context.Add("return_url", EWinWeb.CasinoWorldUrl + "/Payment/PayPal/PaymentSuccessCallback.aspx?OrderNumber=" + OrderNumber);
            application_context.Add("cancel_url", EWinWeb.CasinoWorldUrl + "/Payment/PayPal/PaymentCancelCallback.aspx?OrderNumber=" + OrderNumber);

            jsonContent.Add("intent", "CAPTURE");
            jsonContent.Add("purchase_units", purchase_units);
            jsonContent.Add("application_context", application_context);

            returnResult = CodingControl.GetWebJSONContent(GetTokenURL, "POST", jsonContent.ToString(), GetHeaderString(PaypalToken));

            try
            {
                if (returnResult["id"] != null)
                {
                    string TransactionID = returnResult["id"].ToString();
                    var ret_jobject = JObject.Parse(returnResult.ToString());

                    if (ret_jobject["links"] != null)
                    {

                        var link_jarray = JArray.FromObject(ret_jobject["links"]);

                        for (int i = 0; i < link_jarray.Count; i++)
                        {
                            if (link_jarray[i]["rel"].ToString() == "approve")
                            {
                                result.ResultState = APIResult.enumResultCode.OK;
                                returnMsg["PayPalTransactionID"] = TransactionID;
                                returnMsg["href"] = link_jarray[i]["href"].ToString();
                                result.Message = returnMsg.ToString();
                            }
                        }

                    }
                    else
                    {
                        result.ResultState = APIResult.enumResultCode.ERR;
                        result.Message = "CreatePayment Return Data err";
                    }

                }
                else
                {
                    result.ResultState = APIResult.enumResultCode.ERR;
                    result.Message = "No id";
                }
            }
            catch (RuntimeBinderException)
            {

                result.ResultState = APIResult.enumResultCode.ERR;
                result.Message = "CreatePayment Error";
            }

            return result;
        }

        public static APIResult CheckPaymentState(string PayPalOrderID, string PaypalToken)
        {
            APIResult result = new APIResult();
            APIResult ConfirmEWinPaymentresult = new APIResult();
            Newtonsoft.Json.Linq.JObject returnResult;
            string GetTokenURL = PayPalSetting.ApiUrl + "/v2/checkout/orders/" + PayPalOrderID;

            returnResult = CodingControl.GetWebJSONContent(GetTokenURL, "GET", "", GetHeaderString(PaypalToken));

            try
            {
                if (returnResult["id"] != null)
                {
                    string TransactionID = returnResult["id"].ToString();

                    if (TransactionID == PayPalOrderID)
                    {
                        result.ResultState = APIResult.enumResultCode.OK;
                        result.Message = returnResult.ToString();
                    }
                    else
                    {
                        result.ResultState = APIResult.enumResultCode.ERR;
                        result.Message = "PayPalOrderID err";
                    }
                }
                else
                {
                    result.ResultState = APIResult.enumResultCode.ERR;
                    result.Message = "No id";
                }
            }
            catch (RuntimeBinderException)
            {

                result.ResultState = APIResult.enumResultCode.ERR;
                result.Message = "CheckPaymentState Error";
            }

            return result;
        }

        public static APIResult CapturePayment(string PayPalOrderID, string PaypalToken)
        {
            APIResult result = new APIResult();
            APIResult ConfirmEWinPaymentresult = new APIResult();
            Newtonsoft.Json.Linq.JObject returnResult;
            string GetTokenURL = PayPalSetting.ApiUrl + "/v2/checkout/orders/" + PayPalOrderID + "/capture";

            returnResult = CodingControl.GetWebJSONContent(GetTokenURL, "POST", "", GetHeaderString(PaypalToken));

            try
            {
                if (returnResult["id"] != null)
                {
                    string TransactionID = returnResult["id"].ToString();

                    if (TransactionID == PayPalOrderID)
                    {

                        if (returnResult["status"].ToString() == "COMPLETED")
                        {
                            result.ResultState = APIResult.enumResultCode.OK;
                            result.Message = returnResult.ToString();
                        }
                        else
                        {
                            result.ResultState = APIResult.enumResultCode.ERR;
                            result.Message = "用戶未付款";
                        }
                    }
                    else
                    {
                        result.ResultState = APIResult.enumResultCode.ERR;
                        result.Message = "PayPalOrderID err";
                    }
                }
                else
                {
                    result.ResultState = APIResult.enumResultCode.ERR;
                    result.Message = "No id";
                }
            }
            catch (RuntimeBinderException)
            {

                result.ResultState = APIResult.enumResultCode.ERR;
                result.Message = "CheckPaymentState Error";
            }

            return result;
        }

        private static string GetTokenHeaderString(string Username, string Password)
        {
            string Ret;
            string HeaderStr = CodingControl.Base64URLEncode(Username + ":" + Password);

            Ret = "Authorization:Basic " + HeaderStr;
            return Ret;
        }

        private static string GetHeaderString(string HeaderStr)
        {
            string Ret;

            Ret = "Authorization:Bearer " + HeaderStr;
            return Ret;
        }

        private static dynamic LoadSetting()
        {
            dynamic o = null;
            string Filename;

            if (EWinWeb.IsTestSite)
            {
                Filename = HttpContext.Current.Server.MapPath("/App_Data/PayPal/Test_" + SettingFile);
            }
            else
            {
                Filename = HttpContext.Current.Server.MapPath("/App_Data/PayPal/Formal_" + SettingFile);
            }

            if (System.IO.File.Exists(Filename))
            {
                string SettingContent;

                SettingContent = System.IO.File.ReadAllText(Filename);

                if (string.IsNullOrEmpty(SettingContent) == false)
                {
                    try { o = Newtonsoft.Json.JsonConvert.DeserializeObject(SettingContent); } catch (Exception ex) { }
                }
            }

            return o;
        }

    }

    public static class Common
    {
        public static ProviderSetting GetProverderSetting(string SettingFile)
        {
            ProviderSetting RetValue;
            //初始化設定檔資料
            string Path;


            if (EWinWeb.IsTestSite)
            {
                Path = HttpContext.Current.Server.MapPath("/App_Data/ProviderSetting/Test/" + SettingFile);
            }
            else
            {
                Path = HttpContext.Current.Server.MapPath("/App_Data/ProviderSetting/Official/" + SettingFile);
            }

            string jsonContent;
            using (FileStream stream = new FileStream(Path, FileMode.Open, FileAccess.Read, FileShare.Read))
            {
                using (StreamReader sr = new StreamReader(stream))
                {
                    jsonContent = sr.ReadToEnd();
                }
            }

            RetValue = JsonConvert.DeserializeObject<ProviderSetting>(jsonContent);
            return RetValue;
        }

        public static void InsertPaymentTransferLog(string Content, string ProviderCode, string OrderID)
        {
            ReportSystem.CreatePaymentContent(Content, ProviderCode, OrderID);

        }

        public static Dictionary<string, string> AsciiDictionary(Dictionary<string, string> sArray)
        {
            Dictionary<string, string> asciiDic = new Dictionary<string, string>();
            string[] arrKeys = sArray.Keys.ToArray();
            Array.Sort(arrKeys, string.CompareOrdinal);
            foreach (var key in arrKeys)
            {
                string value = sArray[key];
                asciiDic.Add(key, value);
            }
            return asciiDic;
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

            public enum ProviderRequestType
            {
                FormData = 0,
                Json = 1,
                RedirectUrl = 2
            }

        }

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

        public class PaymentByProvider
        {
            public string ProviderCode { get; set; }
            public string ProviderReturn { get; set; }
            public decimal OrderAmount { get; set; }
            public bool IsPaymentSuccess { get; set; }
            public bool IsQuerySuccess { get; set; }
        }

        public class ReturnWithdrawByProvider
        {

            public string UpOrderID;
            public int SendStatus;//0=申請失敗/1=申請成功/2=交易已完成
            public decimal DidAmount;
            public decimal Balance;
            public string WithdrawSerial;
            public string ReturnResult;
        }
    }

    public class APIResult
    {
        public enum enumResultCode
        {
            OK = 0,
            ERR = 1
        }

        public enumResultCode ResultState { get; set; }
        public string GUID { get; set; }
        public string Message { get; set; }
    }

    public class EPayDepositPaymentResult : APIResult
    {
        public string ProviderCode { get; set; }
    }
}