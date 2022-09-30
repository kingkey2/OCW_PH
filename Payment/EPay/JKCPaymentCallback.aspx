<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Common.cs" Inherits="Common" %>

<%
    string PostBody;
    string InIP;
    string DetailData;
    string Filename;
    string PhoneNumber;
    decimal BeforeAmount = 0;
    decimal DelAmount;
    int dbReturn = -99;
    bool IsDeleteAmount = false;
    System.Collections.ArrayList iSyncRoot = new System.Collections.ArrayList();
    using (System.IO.StreamReader reader = new System.IO.StreamReader(Request.InputStream))
    {
        PostBody = reader.ReadToEnd();
    };

    System.Data.DataTable PaymentOrderDT;
    APIResult R = new APIResult() { ResultState = APIResult.enumResultCode.ERR };

    if (!string.IsNullOrEmpty(PostBody))
    {
        dynamic RequestData = Common.ParseData(PostBody);

        InIP = CodingControl.GetUserIP();
        if (RequestData != null)
        {
            if (Common.CheckInIP(InIP))
            {
                if (Common.CheckSign(RequestData))
                {
                    PaymentOrderDT = EWinWebDB.UserAccountPayment.GetPaymentByPaymentSerial((string)RequestData.OrderID);

                    R.ResultState = APIResult.enumResultCode.ERR;
                    R.Message = (string)RequestData.OrderID;
                    PhoneNumber = (string)RequestData.State;
                    if (PaymentOrderDT != null && PaymentOrderDT.Rows.Count > 0)
                    {
                        if ((string)RequestData.PayingStatus == "0")
                        {
                            if ((int)PaymentOrderDT.Rows[0]["FlowStatus"] == 1)
                            {
                                DetailData = (string)PaymentOrderDT.Rows[0]["DetailData"];
                                if (!string.IsNullOrEmpty(DetailData))
                                {
                                    var jsonDetailData = Newtonsoft.Json.JsonConvert.DeserializeObject<Newtonsoft.Json.Linq.JArray>(DetailData);
                                    Newtonsoft.Json.Linq.JObject jo = jsonDetailData.Children<Newtonsoft.Json.Linq.JObject>().FirstOrDefault(o => o["TokenCurrencyType"] != null && o["TokenCurrencyType"].ToString() == "JKC");
                                    DelAmount = (decimal)jo["ReceiveAmount"];
                                    EWin.Payment.PaymentAPI paymentAPI = new EWin.Payment.PaymentAPI();
                                    dbReturn = EWinWebDB.JKCDeposit.UpdateJKCDepositByContactPhoneNumber(PhoneNumber, DelAmount);
                                    if (dbReturn == 0)
                                    {
                                        var finishResult = paymentAPI.FinishedPayment(EWinWeb.GetToken(), System.Guid.NewGuid().ToString(), (string)PaymentOrderDT.Rows[0]["PaymentSerial"],-1);

                                        if (finishResult.ResultStatus == EWin.Payment.enumResultStatus.OK)
                                        {
                                            R.ResultState = APIResult.enumResultCode.OK;
                                            R.Message = "SUCCESS";
                                        }
                                        else
                                        {
                                            R.ResultState = APIResult.enumResultCode.ERR;
                                            R.Message = "Finished Fail"+finishResult;
                                        }
                                    }
                                    else
                                    {
                                        switch (dbReturn)
                                        {
                                            case -1:
                                                R.ResultState = APIResult.enumResultCode.ERR;
                                                R.Message = "UpdateDB LOCK Fail";
                                                break;
                                            case -2:
                                                R.ResultState = APIResult.enumResultCode.ERR;
                                                R.Message = "UpdateDB Amount Fail";
                                                break;
                                            case -3:
                                                R.ResultState = APIResult.enumResultCode.ERR;
                                                R.Message = "UpdateDB Amount Not Enough Fail";
                                                break;
                                            case -4:
                                                R.ResultState = APIResult.enumResultCode.ERR;
                                                R.Message = "UpdateDB PhoneNumber Fail";
                                                break;
                                            default:
                                                R.ResultState = APIResult.enumResultCode.ERR;
                                                R.Message = "UpdateDB OTHER Fail";
                                                break;
                                        }
                                    }

                                }
                                else
                                {
                                    R.ResultState = APIResult.enumResultCode.ERR;
                                    R.Message = "Get JKC Rate Fail";
                                }
                            }
                            else
                            {
                                R.ResultState = APIResult.enumResultCode.ERR;
                                R.Message = "FlowStatus Error";
                            }
                        }
                        else
                        {
                            R.ResultState = APIResult.enumResultCode.ERR;
                            R.Message = "Status Fail";
                        }
                    }
                    else
                    {
                        R.ResultState = APIResult.enumResultCode.ERR;
                        R.Message = "OtherOrderNumberNotFound";
                    }
                }
                else
                {
                    R.ResultState = APIResult.enumResultCode.ERR;
                    R.Message = "Sign Fail";
                }
            }
            else
            {
                R.ResultState = APIResult.enumResultCode.ERR;
                R.Message = "IP Fail:" + InIP;
            }


        }
        else
        {
            R.ResultState = APIResult.enumResultCode.ERR;
            R.Message = "Parse Data Fail";
        }

    }
    else
    {
        R.ResultState = APIResult.enumResultCode.ERR;
        R.Message = "No Data";
    }

    Response.Write(R.Message);
    Response.Flush();
    Response.End();
%>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta charset="UTF-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <meta http-equiv="cache-control" content="no-cache" />
    <meta http-equiv="pragma" content="no-cache" />
    <title></title>
</head>
<script>
<%--    var Url = "<%:RedirectUrl%>";

    if (self == top) {
        window.location.href = Url;
    } else {
        window.top.API_LoadPage("PayPal", Url);
    }--%>

</script>
<body>
    <form id="form1" runat="server">
        <div>
        </div>
    </form>
</body>
</html>


