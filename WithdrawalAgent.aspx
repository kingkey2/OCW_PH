<%@ Page Language="C#" %>

<%
    string Version = EWinWeb.Version;
    string InOpenTime = EWinWeb.CheckInWithdrawalTime() ? "Y" : "N";
    string IsWithdrawlTemporaryMaintenance = EWinWeb.IsWithdrawlTemporaryMaintenance() ? "Y" : "N";
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Lucky Sprite</title>

    <link rel="stylesheet" href="Scripts/OutSrc/lib/bootstrap/css/bootstrap.min.css" type="text/css" />
    <link rel="stylesheet" href="css/icons.css?<%:Version%>" type="text/css" />
    <link rel="stylesheet" href="css/global.css?<%:Version%>" type="text/css" />
     <link rel="stylesheet" href="css/wallet.css?<%:Version%>" type="text/css" />
    <link href="css/footer-new.css" rel="stylesheet" />
       <style>
        .tempCard {
        cursor:pointer;
        }
        .comingSoon {
            position: absolute;
            top: 10px;
            left: 10px;
            z-index: 99999;
            height: calc(100% - 20px);
            width: calc(100% - 20px);
        }
    </style>
</head>
    
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
<script src="Scripts/OutSrc/js/wallet.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/4.6.2/js/bootstrap.min.js"></script>
<script type="text/javascript" src="/Scripts/Common.js"></script>
<script type="text/javascript" src="/Scripts/UIControl.js"></script>
<script type="text/javascript" src="/Scripts/MultiLanguage.js"></script>
<script type="text/javascript" src="/Scripts/libphonenumber.js"></script>
<script type="text/javascript" src="/Scripts/Math.uuid.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/bignumber.js/9.0.2/bignumber.min.js"></script>
<script>      
    if (self != top) {
        window.parent.API_LoadingStart();
    }
    var lang;
    var mlp;
    var v = "<%:Version%>";
    var IsOpenTime = "<%:InOpenTime%>";
    var IsWithdrawlTemporaryMaintenance = "<%:IsWithdrawlTemporaryMaintenance%>";
    var lobbyClient;
    var WebInfo;
    var TimeZone = 8;
    var userWithdrawPermissions = true;
    function init() {
        if (self == top) {
            window.parent.location.href = "index.aspx";
        }
        lobbyClient = window.parent.API_GetLobbyAPI();
        WebInfo = window.parent.API_GetWebInfo();
        lang = window.parent.API_GetLang();
        mlp = new multiLanguage(v);
        mlp.loadLanguage(lang, function () {
            window.parent.API_LoadingEnd();
            if (IsOpenTime == "N") {
                window.parent.API_NonCloseShowMessageOK(mlp.getLanguageKey("提示"), mlp.getLanguageKey("NotInOpenTime"), function () {
                    window.parent.API_Reload();
                });
            } else {
                if (IsWithdrawlTemporaryMaintenance == "Y") {
                    window.parent.API_NonCloseShowMessageOK(mlp.getLanguageKey("提示"), mlp.getLanguageKey("WithdrawlTemporaryMaintenance"), function () {
                        window.parent.API_Reload();
                    });
                } else {
                    checkWalletPassword();
                }
            }

            var Tag = WebInfo.UserInfo.Tag;
            if (Tag != null) {
                var jsonTag = JSON.parse(Tag);
                for (var i = 0; i < jsonTag.length; i++) {
                    if (jsonTag[i]["TagText"] == "黑名單" || jsonTag[i]["TagText"] == "數據延遲/異常" || jsonTag[i]["TagText"] == "技術排查中" || jsonTag[i]["TagText"] == "凍結出款") {
                        userWithdrawPermissions = false;
                    }
                }
            }

            if (!userWithdrawPermissions) {
                window.parent.API_NonCloseShowMessageOK(mlp.getLanguageKey("提示"), mlp.getLanguageKey("請聯繫客服"), function () {
                    window.parent.API_Reload();
                });
            }
       
        }, "PaymentAPI");

        GetListPaymentChannel();
    }

    function checkWalletPassword() {
        lobbyClient.GetUserAccountProperty(WebInfo.SID, Math.uuid(), "IsSetWalletPassword", function (success, o) {
            if (success) {
                console.log(o);
                if (o.Result != 0) {
                    if (o.Message=="NoExist") {
                        window.parent.showMessageOK(mlp.getLanguageKey("錯誤"), mlp.getLanguageKey("尚未設定錢包密碼"), function () {
                            window.parent.API_LoadPage("ForgotWalletPassword", "ForgotWalletPassword.aspx");
                        });
                    }
                }
            }
        });
    }

    function toCurrency(num) {

        num = parseFloat(Number(num).toFixed(2));
        var parts = num.toString().split('.');
        parts[0] = parts[0].replace(/\B(?=(\d{3})+(?!\d))/g, ',');
        return parts.join('.');
    }

    function GetListPaymentChannel() {
        lobbyClient.ListPaymentChannel(WebInfo.SID, Math.uuid(), 1, function (success, o) {
            if (success) {
                if (o.Result == 0) {
                    if (o.ChannelList && o.ChannelList.length > 0) {
                        o.ChannelList = o.ChannelList.filter(f => f.UserLevelIndex <= WebInfo.UserInfo.UserLevel)
                        for (var i = 0; i < o.ChannelList.length; i++) {
                            var channel = o.ChannelList[i];
                            //UserLevelIndex
                            if (channel.CurrencyType == WebInfo.MainCurrencyType) {
                                switch (channel.PaymentChannelCode) {
                                    case ".Withdrawal.BANK":
                                        var minAmount = "unlimited";
                                        var maxAmount = "unlimited";
                                        if (channel.AmountMin != 0) {
                                            minAmount = toCurrency(new BigNumber(Math.abs(channel.AmountMin)));
                                        }

                                        if (channel.AmountMax != 0) {
                                            maxAmount = toCurrency(new BigNumber(Math.abs(channel.AmountMax)));
                                        }

                                        $('#idWithdrawalBankCard').find('.limit').text(minAmount + "~" + maxAmount);

                                        var startTime = Date.parse("2022/12/19 " + channel.AvailableTime.StartTime);
                                        var endTime = Date.parse("2022/12/19 " + channel.AvailableTime.EndTime);
                                        startTime = startTime + (TimeZone * 60 * 60 * 1000);
                                        endTime = endTime + (TimeZone * 60 * 60 * 1000);

                                        startTimetext = new Date(startTime).toTimeString();
                                        startTimetext = startTimetext.split(' ')[0];
                                        endTimetext = new Date(endTime).toTimeString();
                                        endTimetext = endTimetext.split(' ')[0];
                                        if (compareDate(startTimetext, endTimetext)) {
                                            $('#idWithdrawalBankCard').show();
                                        }

                                        break;
                                    case ".Withdrawal.Gcash":
                                        var minAmount = "unlimited";
                                        var maxAmount = "unlimited";
                                        if (channel.AmountMin != 0) {
                                            minAmount = toCurrency(new BigNumber(Math.abs(channel.AmountMin)));
                                        }

                                        if (channel.AmountMax != 0) {
                                            maxAmount = toCurrency(new BigNumber(Math.abs(channel.AmountMax)));
                                        }

                                        $('#idWithdrawalGCASH').find('.limit').text(minAmount + "~" + maxAmount);

                                        var startTime = Date.parse("2022/12/19 " + channel.AvailableTime.StartTime);
                                        var endTime = Date.parse("2022/12/19 " + channel.AvailableTime.EndTime);
                                        startTime = startTime + (TimeZone * 60 * 60 * 1000);
                                        endTime = endTime + (TimeZone * 60 * 60 * 1000);

                                        startTimetext = new Date(startTime).toTimeString();
                                        startTimetext = startTimetext.split(' ')[0];
                                        endTimetext = new Date(endTime).toTimeString();
                                        endTimetext = endTimetext.split(' ')[0];
                                        if (compareDate(startTimetext, endTimetext)) {
                                            $('#idWithdrawalGCASH').show();
                                        }


                                        break;
                                    default:
                                }

                                if (channel.PaymentChannelCode.includes("BlockChain")) {
                                    var minAmount = "unlimited";
                                    var maxAmount = "unlimited";
                                    if (channel.AmountMin != 0) {
                                        minAmount = toCurrency(new BigNumber(Math.abs(channel.AmountMin)));
                                    }

                                    if (channel.AmountMax != 0) {
                                        maxAmount = toCurrency(new BigNumber(Math.abs(channel.AmountMax)));
                                    }

                                    $('#idWithdrawalCrypto').find('.limit').text(minAmount + "~" + maxAmount);


                                    var startTime = Date.parse("2022/12/19 " + channel.AvailableTime.StartTime);
                                    var endTime = Date.parse("2022/12/19 " + channel.AvailableTime.EndTime);
                                    startTime = startTime + (TimeZone * 60 * 60 * 1000);
                                    endTime = endTime + (TimeZone * 60 * 60 * 1000);

                                    startTimetext = new Date(startTime).toTimeString();
                                    startTimetext = startTimetext.split(' ')[0];
                                    endTimetext = new Date(endTime).toTimeString();
                                    endTimetext = endTimetext.split(' ')[0];
                                    if (compareDate(startTimetext, endTimetext)) {
                                        $('#idWithdrawalCrypto').show();
                                    }


                                }
                            }
                        }
                    }
                }
            }
        })
    }


    function compareDate(time1, time2) {
        var date = new Date();
        var nowdate = new Date();
        var a = time1.split(":");
        var b = time2.split(":");
        return date.setHours(a[0], a[1], a[2]) <= nowdate && nowdate <= date.setHours(b[0], b[1], b[2]);
    }

    function API_showMessageOK(title, message, cbOK) {
        if ($("#alertContact").attr("aria-hidden") == 'true') {
            var divMessageBox = document.getElementById("alertContact");
            var divMessageBoxCloseButton = divMessageBox.querySelector(".alertContact_Close");
            var divMessageBoxOKButton = divMessageBox.querySelector(".alertContact_OK");
            //var divMessageBoxTitle = divMessageBox.querySelector(".alertContact_Text");
            var divMessageBoxContent = divMessageBox.querySelector(".alertContact_Text");

            if (messageModal == null) {
                messageModal = new bootstrap.Modal(divMessageBox);
            }

            if (divMessageBox != null) {
                messageModal.show();

                if (divMessageBoxCloseButton != null) {
                    divMessageBoxCloseButton.classList.add("is-hide");
                }

                if (divMessageBoxOKButton != null) {
                    //divMessageBoxOKButton.style.display = "inline";

                    divMessageBoxOKButton.onclick = function () {
                        messageModal.hide();

                        if (cbOK != null)
                            cbOK();
                    }
                }

                //divMessageBoxTitle.innerHTML = title;
                divMessageBoxContent.innerHTML = message;
            }
        }
    }

    function EWinEventNotify(eventName, isDisplay, param) {
        switch (eventName) {
            case "LoginState":
                //updateBaseInfo();

                break;
            case "BalanceChange":
                break;
            case "SetLanguage":
                lang = param;

                mlp.loadLanguage(lang, function () {
                    window.parent.API_LoadingEnd(1);
                });
                break;
        }
    }

    function TempAlert() {
        window.parent.API_ShowMessageOK("", "<p style='font-size:2em;text-align:center;margin:auto'>" + mlp.getLanguageKey("近期開放") + "</p>");
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
                            <h3 class="title language_replace">出款</h3>
                        </div>
                    </div>
                </div>

                <!-- 步驟 -->
                <div class="progress-container progress-line">
                    <div class="progress-step cur">
                        <div class="progress-step-item"></div>
                          <span class="progressline-step language_replace">step1</span>
                    </div>
                    <div class="progress-step">
                        <div class="progress-step-item"></div>
                          <span class="progressline-step language_replace">step2</span>
                    </div>
                    <div class="progress-step">
                        <div class="progress-step-item"></div>
                          <span class="progressline-step language_replace">step3</span>
                    </div>
                    <div class="progress-step">
                        <div class="progress-step-item"></div>
                         <span class="progressline-step language_replace">Finish</span>
                    </div>
                </div>
                <div class="text-wrap progress-title">
                    <p class="language_replace">選擇出款管道</p>
                </div>

                <!-- 選擇出款管道  -->
                <div class="card-container">

                    <!-- PayPal -->
                    <%--                    <div class="card-item sd-08">
                        <a class="card-item-link" onclick="window.parent.API_LoadPage('DepositPayPal','DepositPayPal.aspx')">
                            <div class="card-item-inner">
                                <div class="title">
                                    <span class="language_replace">電子錢包</span>
                                    <!-- <span>Electronic Wallet</span>  -->
                                </div>
                                <div class="logo vertical-center">
                                    <img src="images/assets/card-surface/icon-logo-paypal-w.svg">
                                </div>
                            </div>
                            <img src="images/assets/card-surface/card-08.svg" class="card-item-bg">
                        </a>      

                    </div>--%>
                  
                    <!-- EPay -->
                    <div id="idWithdrawalBankCard" style="display:none;" class="card-item sd-04 tempCard" onclick="window.parent.API_LoadPage('WithdrawalBankAgent','WithdrawalBankAgent.aspx')">
                        <a class="card-item-link ">
                            <div class="card-item-inner">
                                <div class="title">
                                    <span class="language_replace"></span>
                                    <!-- <span>Electronic Wallet</span> -->
                                </div>
                                <div class="logo vertical-center text-center mt-4">
                                    <!-- <span class="text language_replace">銀行振込</span> -->
                                    <img src="images/assets/card-surface/icon-logo-bankcard.png">
                                </div>
                                  <div class="quota">
                                    <i class="language_replace">限額:</i>
                                    <span class="limit">100.00 ~ 10,000.00</span>
                                </div>
                            </div>
                        </a>
                           <%--<img class="comingSoon" src="../images/assets/card-surface/cs.png">--%>
                    </div>
                       <div id="idWithdrawalGCASH" style="display:none;" class="card-item sd-09 tempCard" onclick="window.parent.API_LoadPage('WithdrawalGCASHAgent','WithdrawalGCASHAgent.aspx')">
                        <a class="card-item-link ">
                            <div class="card-item-inner">
                                <div class="title">
                                    <span class="language_replace">GCASH</span>
                                    <!-- <span>Electronic Wallet</span>  -->
                                </div>
                                <div class="logo vertical-center text-center">
                                    <!-- <span class="text language_replace">銀行振込</span> -->
                                    <img src="images/assets/card-surface/icon-logo-GCash.svg">
                                </div>
                                    <div class="quota">
                                    <i class="language_replace">限額:</i>
                                    <span class="limit">100.00 ~ 10,000.00</span>
                                </div>
                            </div>
                        </a>
                           <%--<img class="comingSoon" src="../images/assets/card-surface/cs.png">--%>
                    </div>
                </div>
                <!-- 出款紀錄 -->
                <div class="notice-container mt-5">
                    <div class="notice-item">
                        <i class="icon-wallet"></i>
                        <div class="text-wrap">
                            <p class="title language_replace text-link" onclick="window.parent.API_LoadPage('record','record.aspx', true)">檢視出款紀錄</p>
                        </div>
                    </div>
                </div>
                <!-- 溫馨提醒 -->
                <div class="notice-container mt-5">
                    <div class="notice-item">
                        <i class="icon-info_circle_outline"></i>
                        <div class="text-wrap">
                            <p class="language_replace" style="text-indent: -1rem; margin-left: 1rem;">1. Using Lucky
                                Sprite's fully automated recharge and withdrawal channels, you'll enjoy the best gaming
                                experience, and your recharge and withdrawal will arrive within seconds!</p>

                            <p class="language_replace" style="text-indent: -1rem; margin-left: 1rem;">2. With regard to
                                withdrawal valid bet requirements<br><br>
                                GCASH · Main deposit channels = 1 times the deposit amount<br>
                                Paymaya · Main recharge channel = 1 times the deposit amount<br>
                                Online Banking · Main recharge channel = 1 times the deposit amount<br>
                                Grabpay · Main recharge channel = 1 times the deposit amount<br><br>
                                ※The withdrawal requirements rate will be increased when receiving/applying for
                                bonuses/events</p>
                            </div>
                            </div>
                </div>

            </section>


        </div>
    </div>
</body>
</html>
