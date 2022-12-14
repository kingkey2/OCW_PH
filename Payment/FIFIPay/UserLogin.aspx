<%--<%@ Page Language="C#" EnableSessionState="False" CodeFile="Common.cs" Inherits="Common" %>

<%
    /*
    Request Param:
        SID
        CurrencyType
        GameName (啟動的遊戲名稱)
        Language (optional)
        DemoPlay [0|1] (optional)
        HomeUrl  (optional)
    */
    string SID = Request["SID"];
    string CurrencyType = Request["CurrencyType"];
    string GameName = Request["GameName"];
    string Language; //= Request["Language"];
    int DemoPlay = 0; // Request["DemoPlay"];
    string HomeUrl = string.Empty; // = Request["HomeUrl"];
    RedisCache.SessionContext.SIDInfo SI;
    EWin.enumUserDeviceType UDT = EWin.GetUserDeviceType(Request.UserAgent);
    EWinGameCode.GameKey EGK = null;

    SI = RedisCache.SessionContext.GetSIDInfo(SID);
    if (SI != null)
    {
        if (string.IsNullOrEmpty(Request["HomeUrl"]) == false)
            HomeUrl = Request["HomeUrl"];

        if (string.IsNullOrEmpty(Request["DemoPlay"]) == false)
            DemoPlay = Convert.ToInt32(Request["DemoPlay"]);

        if (string.IsNullOrEmpty(Request["Language"]) == false)
            Language = Request["Language"];
        else
            Language = SI.Language;


        // 取得指定錢包的 ApiKey
        EGK = EWinGameCode.GameKey.LoadGameKey(SI.CompanyID, GameBrand, CurrencyType);
        if (EGK != null)
        {
            string GameCode = GameBrand + "." + GameName;
            string ApiUrl = EGK.ApiUrl;
            EWinGameCode.GameAccountId GA = EWinGameCode.GameAccountId.FromSID(CurrencyType, SID);
            EWinWallet.WalletResult WR;
            RedisCache.Company.CompanyGameCodeExchange GCRate;
            string transfer_no = string.Empty;
            GameLinkResult GR;
            TransferAPIResult TR;
            string GameUrl;

            if (DemoPlay == 0)
            {
                GCRate = EWinGameCode.GameCodeWallet.GetExchangeByEWin(GA.CompanyID, GameBrand, GameCode, GA.CurrencyType);

                if (Wallet.CreatePlayer(EGK, GA))
                {
                    // 取得遊戲登入網址
                    GR = Wallet.UserLogin(EGK, GA, GameName, Language, UDT, HomeUrl);

                    if (GR.ResultCode == 0)
                    {
                        GameUrl = GR.Url;

                        if (string.IsNullOrEmpty(GameUrl) == false)
                        {
                            RedisCache.GetLocker("LockWallet-" + SI.UserAccountID, 30, () =>
                            {
                                decimal GamePoint = 0;
                                decimal EWinWalletPoint = 0;
                                bool TransferSuccess = false;
                                int DBRet;

                                //做一次額度刷新，避免額度錯亂
                                RedisCache.UserAccountPoint.UpdateUserAccountPointByID(GA.UserAccountID);

                                // 轉入所有額度
                                // 查詢用戶目前餘額
                                WR = EWinWallet.WalletQuery(SI.UserAccountID, CurrencyType);
                                if (WR.WalletList.Length > 0)
                                {
                                    if (WR.WalletList[0].PointValue > 0)
                                    {
                                        // 轉換成遊戲點數(元)
                                        EWinWalletPoint = WR.WalletList[0].PointValue;
                                        GamePoint = GetDecimal(EWin.DecimalUnit(EWinWalletPoint, (int)GA.CashUnit, 2) * GCRate.CurrencyRate, 2);
                                        EWinWalletPoint = EWin.DecimalUnit(GamePoint, 2, (int)GA.CashUnit);

                                        transfer_no = Wallet.CreateTransferNo();

                                        DBRet = EWinDB.UserAccount.UserAccountGameTransferIn(SI.UserAccountID, GameBrand, GameCode, transfer_no, CurrencyType, EWinWalletPoint, CodingControl.GetUserIP());
                                        if (DBRet > 0)

                                        {
                                            // 轉入額度
                                            TR = Wallet.TransferIn(EGK, GA, transfer_no, GamePoint);
                                            if (TR != null)
                                            {
                                                if ((int)TR.ResultCode == 0)
                                                    TransferSuccess = true;
                                            }

                                            // 查詢交易狀況
                                            if (TransferSuccess == false)
                                            {
                                                if (Wallet.CheckTransferSuccess(EGK, transfer_no, GA))
                                                {
                                                    // 交易完成
                                                    TransferSuccess = true;
                                                }
                                            }

                                            if (TransferSuccess)
                                            {
                                                //EWinGameCode.GameCodeWallet.WalletOP(GameBrand, GameCode, "TIN-" + transfer_no, GA, EWinWallet.enumOPType.Withdrawal, (0 - TransferInValue), "login-" + GameCode, false, null);
                                                DBRet = EWinDB.UserAccount.UserAccountGameTransferInConfirm(SI.UserAccountID, GameBrand, GameCode, transfer_no, CurrencyType, EWinWalletPoint);
                                                if (DBRet != 0)
                                                {
                                                    // 轉入確認失敗, 回收遊戲點數
                                                    string cancel_no;

                                                    cancel_no = Wallet.CreateTransferNo();
                                                    Wallet.TransferOut(EGK, GA, cancel_no, GamePoint);

                                                    Response.Write("WithdrawalConfirm failure, ret=" + DBRet + ", TxID=" + transfer_no + ", amount=" + EWinWalletPoint + ", CT=" + CurrencyType);
                                                    Response.Flush();
                                                    Response.End();
                                                }
                                            }

                                            RedisCache.UserAccountPoint.UpdateUserAccountPointByID(GA.UserAccountID);
                                        }
                                    }
                                }

                                //GameCodeTrans CurrencyType=EWinCurrencyType
                                EWinDB.GameCodeTrans.GameCodeTransLogin(SI.UserAccountID, CurrencyType, GameCode, EWinWalletPoint, transfer_no);
                            });

                            Response.Redirect(GameUrl);
                        }
                        else
                        {
                            Response.Write("Game Entry Url empty!");
                            Response.Flush();
                            Response.End();
                        }
                    }
                    else
                    {
                        Response.Write("Return code:" + GR.Message);
                        Response.Flush();
                        Response.End();
                    }
                }
                else
                {
                    Response.Write("Create User failure");
                    Response.Flush();
                    Response.End();
                }
            }
            else { 
                GR = Wallet.DemoLogin(EGK, GameName, Language, UDT, HomeUrl);

                 if (GR.ResultCode == 0)
                    {
                        GameUrl = GR.Url;

                        if (string.IsNullOrEmpty(GameUrl) == false)
                        {
                            Response.Redirect(GameUrl);
                        }
                        else
                        {
                            Response.Write("Game Entry Url empty!");
                            Response.Flush();
                            Response.End();
                        }
                    }
                    else
                    {
                        Response.Write("Return code:" + GR.Message);
                        Response.Flush();
                        Response.End();
                    }
            }
        }
        else
        {
            Response.Write("Key load failure, CT=" + CurrencyType + ", CID=" + SI.CompanyID);
            Response.Flush();
            Response.End();
        }
    }
    else
    {
        Response.Write("InvalidSID");
        Response.Flush();
        Response.End();
    }
%>
<html>

<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
    <meta http-equiv="Content-Language" content="zh-cn">
    <meta http-equiv="cache-control" content="no-cache" />
    <meta http-equiv="pragma" content="no-cache" />
</head>
<body style="width: 100%">
</body>
</html>--%>
