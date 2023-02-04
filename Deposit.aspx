<%@ Page Language="C#" %>

<%
    string Version = EWinWeb.Version;
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
    var WebInfo;
    var lang;
    var mlp;
    var v = "<%:Version%>";
    var lobby;
    var isAddedCrypto = false;
    var TimeZone = 8;
    function init() {

        if (self == top) {
            window.parent.location.href = "index.aspx";
        }

        WebInfo = window.parent.API_GetWebInfo();
        lobby = window.parent.API_GetLobbyAPI();
        lang = window.parent.API_GetLang();
        mlp = new multiLanguage(v);
        mlp.loadLanguage(lang, function () {
            window.parent.API_LoadingEnd();
        }, "PaymentAPI");

        GetListPaymentChannel();
    }

    function GetListPaymentChannel() {
        lobby.ListPaymentChannel(WebInfo.SID, Math.uuid(),0 ,function (success, o) {
            if (success) {
                if (o.Result == 0) {
                    if (o.ChannelList && o.ChannelList.length > 0) {
                        o.ChannelList = o.ChannelList.filter(f => f.UserLevelIndex <= WebInfo.UserInfo.UserLevel)
                        for (var i = 0; i < o.ChannelList.length; i++) {
                            var channel = o.ChannelList[i];
                            //UserLevelIndex
                            if (channel.CurrencyType == WebInfo.MainCurrencyType) {
                                var doc = "";
                                var PaymentChannelCode = channel.PaymentChannelCode;
                                if (channel.PaymentProvider != '') {
                                    PaymentChannelCode = PaymentChannelCode.substring(0, PaymentChannelCode.length - 1);
                                }
                                switch (PaymentChannelCode) {
                                    case "FeibaoGcash.Gcash":
                                    case "FIFIPay.GcashDirect":
                                    case "DiDiPay.GcashQRcode":
                                    case "YuHong.GcashQRcode":
                                    case "YuHong.GcashH5_":
                                    case "DiDiPay.Gcash":
                                    case "GCPay.GcashDirect":
                                    case "ZINPay.GcashDirect":
                                    case "ZINPay.GcashQRcode":
                                    case "CLOUDPAY.GcashDirect":
                                    case "EASYPAY.Gcash":
                                        var minAmount = "unlimited";
                                        var maxAmount = "unlimited";
                                        if (channel.AmountMin!=0) {
                                            minAmount = toCurrency(new BigNumber(Math.abs(channel.AmountMin)));
                                        }
                                      
                                        if (channel.AmountMax != 0) {
                                            maxAmount = toCurrency(new BigNumber(Math.abs(channel.AmountMax)));
                                        }

                                    doc = ` <div class="card-item sd-09">
                                            <a class="card-item-link" onclick="OpenPage('DepositEPay','DepositEPay.aspx?PaymentChannelCode=${channel.PaymentChannelCode}')">
                                                <div class="card-item-inner">
                                                    <div class="title">
                                                        <span class="language_replace">${channel.PaymentName}</span>
                                                    </div>
                                                    <div class="logo vertical-center text-center">
                                                        <img src="images/assets/card-surface/icon-logo-GCash.svg">
                                                    </div>
                                                    <div class="quota">
                                                        <i class="language_replace">${mlp.getLanguageKey("限額:")}</i>
                                                        <span class="limit">${minAmount} ~ ${maxAmount}</span>
                                                    </div>
                                                </div>
                                                <img src="images/assets/card-surface/card-09.svg" class="card-item-bg">
                                            </a>
                                        </div>`;
                                        break; 
                                    case "FeibaoGrabpay.Grabpay":
                                        var minAmount = "unlimited";
                                        var maxAmount = "unlimited";
                                        if (channel.AmountMin != 0) {
                                            minAmount = toCurrency(new BigNumber(Math.abs(channel.AmountMin)));
                                        }

                                        if (channel.AmountMax != 0) {
                                            maxAmount = toCurrency(new BigNumber(Math.abs(channel.AmountMax)));
                                        }

                                        doc = ` <div class="card-item sd-10">
                                            <a class="card-item-link" onclick="OpenPage('DepositEPay','DepositEPay.aspx?PaymentChannelCode=${channel.PaymentChannelCode}')">
                                                <div class="card-item-inner">
                                                    <div class="title">
                                                        <span class="language_replace">${channel.PaymentName}</span>
                                                    </div>
                                                    <div class="logo vertical-center text-center">
                                                         <img src="images/assets/card-surface/icon-logo-GrabPay.svg">
                                                    </div>
                                                    <div class="quota">
                                                        <i class="language_replace">${mlp.getLanguageKey("限額:")}</i>
                                                        <span class="limit">${minAmount} ~ ${maxAmount}</span>
                                                    </div>
                                                </div>
                                                 <img src="images/assets/card-surface/card-09.svg" class="card-item-bg">
                                            </a>
                                        </div>`;
                                        break;
                                    case "FeibaoPaymaya.Paymaya":
                                    case "YuHong.QRPH":
                                        var minAmount = "unlimited";
                                        var maxAmount = "unlimited";
                                        if (channel.AmountMin != 0) {
                                            minAmount = toCurrency(new BigNumber(Math.abs(channel.AmountMin)));
                                        }

                                        if (channel.AmountMax != 0) {
                                            maxAmount = toCurrency(new BigNumber(Math.abs(channel.AmountMax)));
                                        }

                                        doc = ` <div class="card-item sd-11">
                                            <a class="card-item-link" onclick="OpenPage('DepositEPay','DepositEPay.aspx?PaymentChannelCode=${channel.PaymentChannelCode}')">
                                                <div class="card-item-inner">
                                                    <div class="title">
                                                        <span class="language_replace">${channel.PaymentName}</span>
                                                    </div>
                                                    <div class="logo vertical-center text-center">
                                                        <img src="images/assets/card-surface/icon-logo-PayMaya.svg">
                                                    </div>
                                                    <div class="quota">
                                                        <i class="language_replace">${mlp.getLanguageKey("限額:")}</i>
                                                        <span class="limit">${minAmount} ~ ${maxAmount}</span>
                                                    </div>
                                                </div>
                                                 <img src="images/assets/card-surface/card-09.svg" class="card-item-bg">
                                            </a>
                                        </div>`;
                                        break;
                                    case "FeibaoBank.Bank":
                                        var minAmount = "unlimited";
                                        var maxAmount = "unlimited";
                                        if (channel.AmountMin != 0) {
                                            minAmount = toCurrency(new BigNumber(Math.abs(channel.AmountMin)));
                                        }

                                        if (channel.AmountMax != 0) {
                                            maxAmount = toCurrency(new BigNumber(Math.abs(channel.AmountMax)));
                                        }


                                        doc = ` <div class="card-item sd-03">
                                            <a class="card-item-link" onclick="OpenPage('DepositEPay','DepositEPay.aspx?PaymentChannelCode=${channel.PaymentChannelCode}')">
                                                <div class="card-item-inner">
                                                    <div class="title">
                                                        <span class="language_replace">${channel.PaymentName}</span>
                                                    </div>
                                                    <div class="logo vertical-center text-center">
                                                        <img src="images/assets/card-surface/icon-logo-bankcard.png">
                                                    </div>
                                                    <div class="quota">
                                                        <i class="language_replace">${mlp.getLanguageKey("限額:")}</i>
                                                        <span class="limit">${minAmount} ~ ${maxAmount}</span>
                                                    </div>
                                                </div>
                                                 <img src="images/assets/card-surface/card-09.svg" class="card-item-bg">
                                            </a>
                                        </div>`;
                                        break;
                                    default:

                                }


                                if (!isAddedCrypto) {
                                    if (channel.PaymentChannelCode == ".ERC-HLN" || channel.PaymentChannelCode == ".ERC-ETH" ||channel.PaymentChannelCode == ".BTC-BTC" || channel.PaymentChannelCode == ".ERC-USDC" || channel.PaymentChannelCode == ".ERC-USDT" || channel.PaymentChannelCode == ".TRC-USDC" || channel.PaymentChannelCode == ".TRC-USDT" || channel.PaymentChannelCode == ".XRP-XRP") {
                                        isAddedCrypto = true;
                                        var minAmount = "unlimited";
                                        var maxAmount = "unlimited";
                                        if (channel.AmountMin != 0) {
                                            minAmount = toCurrency(new BigNumber(Math.abs(channel.AmountMin)));
                                        }

                                        if (channel.AmountMax != 0) {
                                            maxAmount = toCurrency(new BigNumber(Math.abs(channel.AmountMax)));
                                        }

                                        doc = `<div class="card-item sd-02">
                                            <a class="card-item-link" onclick="OpenPage('DepositCrypto','DepositCrypto.aspx')">
                                                <div class="card-item-inner">
                                                    <div class="title">
                                                        <span>Crypto Wallet</span>
                                                    </div>
                                                    <div class="title vertical-center">
                                                        <span class="language_replace">${mlp.getLanguageKey("虛擬貨幣")}</span>
                                                    </div>
                                                    <!-- <div class="desc">
                                                        <b>30</b> € -  <b>5,000</b> € No Fee
                                                    </div> -->
                                                    <div class="logo">
                                                        <i class="icon-logo-usdt"></i>
                                                        <!-- <i class="icon-logo-eth-o"></i> -->
                                                        <!-- <i class="icon-logo-nissin"></i> -->
                                                        <i class="icon-logo-eth"></i>
                                                        <i class="icon-logo-btc"></i>

                                                        <!-- <i class="icon-logo-doge"></i> -->
                                                        <!-- <i class="icon-logo-tron"></i> -->
                                                    </div>
                                                    <div class="quota">
                                                        <i class="language_replace">${mlp.getLanguageKey("限額:")}</i>
                                                        <span class="limit">${minAmount} ~ ${maxAmount}</span>
                                                    </div>
                                                </div>
                                                <img src="images/assets/card-surface/card-02.svg" class="card-item-bg">
                                            </a>
                                        </div>`;
                                    }
                                }
                              
                                if (doc != "") {

                                    var startTime= Date.parse("2022/12/19 " + channel.AvailableTime.StartTime);
                                    var endTime = Date.parse("2022/12/19 " + channel.AvailableTime.EndTime);
                                    startTime = startTime+ (TimeZone * 60 * 60 * 1000);
                                    endTime = endTime + (TimeZone * 60 * 60 * 1000);

                                    startTimetext = new Date(startTime).toTimeString();
                                    startTimetext = startTimetext.split(' ')[0];
                                    endTimetext = new Date(endTime).toTimeString();
                                    endTimetext = endTimetext.split(' ')[0];
                                    if (compareDate(startTimetext, endTimetext)) {
                                        $('#card-container').append(doc);
                                    }    
                                }
                            }

                        
                        }
                    }
                } 
            }
        })
    }

    function compareDate(time1,time2) {
        var date = new Date();
        var nowdate = new Date();
        var a = time1.split(":");
        var b = time2.split(":");
        return date.setHours(a[0], a[1], a[2]) <= nowdate && nowdate <= date.setHours(b[0], b[1], b[2]);
    }

    function toCurrency(num) {

        num = parseFloat(Number(num).toFixed(2));
        var parts = num.toString().split('.');
        parts[0] = parts[0].replace(/\B(?=(\d{3})+(?!\d))/g, ',');
        return parts.join('.');
    }

    function OpenPage(title, url) {
        window.parent.API_LoadPage(title, url);
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
        window.parent.API_ShowMessageOK("", "<p style='font-size:2em;text-align:center;margin:auto'>" +  mlp.getLanguageKey("近期開放") + "</p>");
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
                            <h3 class="title language_replace">存款</h3>
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
                    <p class="language_replace">選擇存款管道</p>
                </div>

                <!-- 選擇存款管道  -->
                <div id="card-container" class="card-container">
      
                </div>
                <!-- 存款紀錄 -->
                <div class="notice-container mt-5">
                    <div class="notice-item">
                        <i class="icon-wallet"></i>
                        <div class="text-wrap">
                            <p class="title language_replace text-link" onclick="window.parent.API_LoadPage('record','record.aspx', true)">檢視存款紀錄</p>
                        </div>
                    </div>
                </div>
              <%--  <div class="notice-container mt-5">
                    <div class="notice-item">
                        <i class="icon-info_circle_outline"></i>
                        <div class="text-wrap">
                            <p class="title language_replace" style="cursor:pointer" onclick="window.parent.API_LoadPage('record','Article/guide_CashQa_jp.html', true)">各入金方法の手順説明</p>
                        </div>
                    </div>
                </div>--%>
                <!-- 溫馨提醒 -->
                <div class="notice-container mt-5">
                    <div class="notice-item">
                        <i class="icon-info_circle_outline"></i>
                        <div class="text-wrap">
                            <p class="title language_replace">溫馨提醒</p>
                            <!-- <p class="language_replace">1.OCOIN是客人在マハラジャ遊玩的幣別總稱</p>
                            <p class="language_replace">2.不同的存款管道可能影響存款金額到達玩家錢包的時間。最遲一個營業日為合理的範圍。</p>
                            <p class="language_replace">3.關於出金流水倍率</p>
                            <p class="language_replace">PayPal・主要加密貨幣＝入金額の1.5倍</p>
                            <p class="language_replace">JKCETH・JKC現金＝入金額の8倍​ ボーナス＝20倍</p>
                            <p class="language_replace">（計算範例）</p>
                            <p class="language_replace">PayPal　10,000+獎金10,000的情況</p>
                            <p class="language_replace">10,000×1.5倍+10,000×20倍=215,000​</p>
                            <p class="language_replace">關於出金流水的詳細說明於</p>
                            <p class="language_replace">4.持有的OCoin在100以下時入金，或是領取領獎中心的OCoin即可解除原有的出金流水。</p> -->

                            <p class="language_replace" style="text-indent: -1rem; margin-left: 1rem;">1. Using Lucky Sprite's fully automated recharge and withdrawal channels, you'll enjoy the best gaming experience, and your recharge and withdrawal will arrive within seconds!</p>

                            <p class="language_replace" style="text-indent: -1rem; margin-left: 1rem;">2. With regard to withdrawal valid bet requirements<br><br>
GCASH · Main deposit channels = 1 times the deposit amount<br>
Paymaya · Main recharge channel = 1 times the deposit amount<br>
Online Banking · Main recharge channel = 1 times the deposit amount<br>
Grabpay · Main recharge channel = 1 times the deposit amount<br><br>
※The withdrawal requirements rate will be increased when receiving/applying for bonuses/events</p>
                        </div>
                    </div>
                </div>

            </section>


        </div>
    </div>
</body>
</html>
