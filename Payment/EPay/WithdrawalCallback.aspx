 <%@ Page Language="C#" AutoEventWireup="true" CodeFile="Common.cs" Inherits="Common" %>

<%
    string PostBody;
    string InIP;
    string OrderID = "";

    int FlowStatus = -1;
    using (System.IO.StreamReader reader = new System.IO.StreamReader(Request.InputStream)) {
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
                if (Common.CheckWithdrawalSign(RequestData))
                {
                    Newtonsoft.Json.Linq.JObject recordTime = new Newtonsoft.Json.Linq.JObject();
                    recordTime.Add("Type", "WithdrawCallback");
                    recordTime.Add("StartEwinPayRequestTime", DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss"));
                    PaymentOrderDT = EWinWebDB.UserAccountPayment.GetPaymentByPaymentSerial((string)RequestData.OrderID);

                    R.ResultState = APIResult.enumResultCode.ERR;
                    R.Message = (string)RequestData.OrderID;

                    if (PaymentOrderDT != null && PaymentOrderDT.Rows.Count > 0)
                    {
                        OrderID = (string)RequestData.OrderID;
                        FlowStatus = (int)PaymentOrderDT.Rows[0]["FlowStatus"];
                        if (FlowStatus == 1 || FlowStatus == 9)
                        {
                            EWin.Payment.PaymentAPI paymentAPI = new EWin.Payment.PaymentAPI();
                            if ((string)RequestData.WithdrawStatus == "0")
                            {
                                recordTime.Add("StartToEwinRequestTime", DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss"));
                                var finishResult = paymentAPI.FinishedPayment(EWinWeb.GetToken(), System.Guid.NewGuid().ToString(), (string)PaymentOrderDT.Rows[0]["PaymentSerial"], -1);
                                recordTime.Add("EndEwinRequestTime", DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss"));
                                if (finishResult.ResultStatus == EWin.Payment.enumResultStatus.OK)
                                {
                                    R.ResultState = APIResult.enumResultCode.OK;
                                    R.Message = "SUCCESS";
                                }
                                else
                                {
                                    R.ResultState = APIResult.enumResultCode.ERR;
                                    R.Message = "Finished Fail";
                                }
                            }
                            else if ((string)RequestData.WithdrawStatus == "1")
                            {

                                string Token;
                                int RValue;
                                Random random = new Random();
                                RValue = random.Next(100000, 9999999);
                                Token = EWinWeb.CreateToken(EWinWeb.PrivateKey, EWinWeb.APIKey, RValue.ToString());
                                recordTime.Add("StartToEwinRequestTime", DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss"));
                                paymentAPI.CancelPayment(Token, Guid.NewGuid().ToString(), (string)PaymentOrderDT.Rows[0]["PaymentSerial"],"");
                                recordTime.Add("EndEwinRequestTime", DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss"));
                                R.ResultState = APIResult.enumResultCode.OK;
                                R.Message = "SUCCESS";
                            }
                            else
                            {
                                R.ResultState = APIResult.enumResultCode.ERR;
                                R.Message = "UP Status Fail";
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

                    recordTime.Add("EndEwinPayRequestTime", DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss"));

                    string SS;
                    System.Data.SqlClient.SqlCommand DBCmd;
                    System.Data.DataTable DT;

                    SS = "INSERT INTO BulletinBoard (BulletinTitle, BulletinContent,State) " +
                                 "                VALUES (@BulletinTitle, @BulletinContent,1)";

                    DBCmd = new System.Data.SqlClient.SqlCommand();
                    DBCmd.CommandText = SS;
                    DBCmd.CommandType = System.Data.CommandType.Text;
                    DBCmd.Parameters.Add("@BulletinTitle", System.Data.SqlDbType.NVarChar).Value = OrderID;
                    DBCmd.Parameters.Add("@BulletinContent", System.Data.SqlDbType.NVarChar).Value = recordTime.ToString();
                    DBAccess.ExecuteDB(EWinWeb.DBConnStr, DBCmd);
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

