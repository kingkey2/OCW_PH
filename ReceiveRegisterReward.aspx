<%@ Page Language="C#" %>

<%
    string LoginAccount = Request["LoginAccount"];
    //string Email = Request["Email"];

    string Token;
    string ErrMsg =string.Empty;
    int ReceiveStatus = 1;

    int RValue;
    Random R = new Random();
    RValue = R.Next(100000, 9999999);
    Token = EWinWeb.CreateToken(EWinWeb.PrivateKey, EWinWeb.APIKey, RValue.ToString());

    var GetRegisterResult = ActivityCore.GetRegisterResult(LoginAccount);

    if (GetRegisterResult.Result == ActivityCore.enumActResult.OK) {
        EWin.OCW.OCW ocwApi = new EWin.OCW.OCW();
        string transactionCode = LoginAccount + "_" + GetRegisterResult.Data[0].ActivityName;
        string description = "ReceiveRegisterReward, LoginAccount=" + LoginAccount;

        EWin.OCW.APIResult ocwResult = ocwApi.AddBonusValue(Token, System.Guid.NewGuid().ToString(), transactionCode, LoginAccount, EWinWeb.MainCurrencyType, GetRegisterResult.Data[0].BonusValue, GetRegisterResult.Data[0].ThresholdValue, description, description + ", BonusValue" + GetRegisterResult.Data[0].BonusValue.ToString());

        if (ocwResult.ResultState == EWin.OCW.enumResultState.OK) {
            EWinWebDB.UserAccountEventBonusHistory.InsertEventBonusHistory(LoginAccount, GetRegisterResult.Data[0].ActivityName, "", GetRegisterResult.Data[0].BonusRate, GetRegisterResult.Data[0].BonusValue, GetRegisterResult.Data[0].ThresholdRate, GetRegisterResult.Data[0].ThresholdValue, EWinWebDB.UserAccountEventBonusHistory.EventType.Register);
            ReceiveStatus = 1;
        } else {
            ReceiveStatus = 0;
            ErrMsg = GetRegisterResult.Message;
        }
    } else {
        ReceiveStatus = 0;
        ErrMsg = GetRegisterResult.Message;
    }

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
<!DOCTYPE html>

<html>

<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Lucky Sprite</title>

    <link rel="stylesheet" href="Scripts/OutSrc/lib/bootstrap/css/bootstrap.min.css" type="text/css" />
    <link rel="stylesheet" href="css/icons.css" type="text/css" />
    <link rel="stylesheet" href="css/global.css" type="text/css" />
    <link rel="stylesheet" href="css/wallet.css" type="text/css" />
    <script src="Scripts/OutSrc/lib/jquery/jquery.min.js"></script>
    <script type="text/javascript" src="/Scripts/MultiLanguage.js"></script>
    <script src="../src/lib/bootstrap/js/bootstrap.bundle.min.js"></script>
    <script src="../src/js/wallet.js"></script>

</head>
<script>
    var mlp;
    var lang;
    var ReceiveStatus = "<%=ReceiveStatus%>";
    var ErrMsg = "<%=ErrMsg%>";

    function init() {
        lang = "JPN";
        mlp = new multiLanguage();
        mlp.loadLanguage(lang, function () {

        }, "PaymentAPI");

        if (ReceiveStatus == "1") {
            $("#divSuccess").show();
        } else {
            $("#errmsg").text(mlp.getLanguageKey("既に受け取り済みです！引続きマハラジャをお楽しみください。"));
            $("#divFail").show();
        }
    }

    window.onload = init;
</script>
<body>
<div class="page-container">
        <!-- Heading-Top -->
        <div id="heading-top"></div>

        <div class="page-content">

            <section class="sec-wrap">
                <!-- 頁面標題 -->
                <div class="page-title-container">
                    <div class="page-title-wrap">
                        <div class="page-title-inner">
                            <h3 class="title language_replace">開設キャンペーン500 Ocoin</h3>
                        </div>
                    </div>
                </div>

                <%--<div class="progress-title text-wrap">
                    <!-- <p data-deposite="step2">輸入存款金額</p> -->
                    <p data-deposite="step2" class="language_replace">完成</p>
                </div>--%>

                <div class="split-layout-container" id="divSuccess" style="display:none">
                    <!-- 交易結果 -->
                    <div class="main-panel" data-deposite="">
                        <div class="form-content">
                            <!-- 1. 加入 class=> resultShow
                                 2. 加入 class=> success/fail
                            -->
                            <!-- 交易成功 -->
                            <div class="WrappertransactionResult resultShow success">
                                <div class="transactionResult ">
                                    <div class="transaction_resultShow">
                                        <div class="transaction_resultDisplay">
                                            <div class="icon-symbol"></div>
                                        </div>
                                        <p class="transaction_resultTitle"><span class="language_replace">成功</span></p>
                                        <p class="transaction_resultDesc"><span class="language_replace">引続きマハラジャをお楽しみください</span></p>
                                    </div>
                                </div>
                            </div>

                        </div>
                    </div>
                </div>

                <div class="split-layout-container" id="divFail" style="display:none">
                    <!-- 交易結果 -->
                    <div class="main-panel" data-deposite="">
                        <div class="form-content">

                            <!-- 1. 加入 class=> resultShow
                                 2. 加入 class=> success/fail
                            -->
                            <!-- 交易失敗 -->
                            <div class="WrappertransactionResult resultShow fail">
                                <div class="transactionResult ">
                                    <div class="transaction_resultShow">
                                        <div class="transaction_resultDisplay">
                                            <div class="icon-symbol"></div>
                                        </div>
                                        <p class="transaction_resultTitle"><span class="language_replace">失敗</span></p>
                                        <p class="transaction_resultDesc"><span class="language_replace" id="errmsg"></span></p>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </section>
        </div>
    </div>
</body>

</html>
