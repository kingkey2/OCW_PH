<%@ Page Language="C#" %>

<%
    string Version = EWinWeb.Version;
    string PaymentChannelCode="";

     if (string.IsNullOrEmpty(Request["PaymentChannelCode"]) == false)
        PaymentChannelCode = Request["PaymentChannelCode"];
%>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta charset="UTF-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <meta http-equiv="cache-control" content="no-cache" />
    <meta http-equiv="pragma" content="no-cache" />
    <title>Lucky Sprite</title>

    <link rel="stylesheet" href="Scripts/OutSrc/lib/bootstrap/css/bootstrap.min.css" type="text/css" />
    <link rel="stylesheet" href="css/icons.css?<%:Version%>" type="text/css" />
    <link rel="stylesheet" href="css/global.css?<%:Version%>" type="text/css" />
    <link rel="stylesheet" href="css/wallet.css?<%:Version%>" type="text/css" />
    <link href="css/footer-new.css" rel="stylesheet" />
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+JP:wght@300;500&display=swap" rel="Prefetch" as="style" onload="this.rel = 'stylesheet'" />
   
</head>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/4.6.2/js/bootstrap.min.js"></script>
<script type="text/javascript" src="/Scripts/Common.js"></script>
<script type="text/javascript" src="/Scripts/UIControl.js"></script>
<script type="text/javascript" src="/Scripts/MultiLanguage.js"></script>
<script type="text/javascript" src="/Scripts/bignumber.min.js"></script>
<script type="text/javascript" src="/Scripts/libphonenumber.js"></script>
<script type="text/javascript" src="/Scripts/Math.uuid.js"></script>
<script type="text/javascript" src="/Scripts/DateExtension.js"></script>
<script src="Scripts/OutSrc/js/wallet.js"></script>
<script>
    if (self != top) {
        window.parent.API_LoadingStart();
    }
    var WebInfo;
    var mlp;
    var lang;
    var c = new common();
    var v = "<%:Version%>";
    var PaymentChannelCode = "<%:PaymentChannelCode%>";
    var PaymentClient;
    var ActivityNames = [];
    var OrderNumber = "";
    var ExpireSecond = 0;
    var lobbyClient;

    function init() {
        if (self == top) {
            window.parent.location.href = "index.aspx";
        }

        WebInfo = window.parent.API_GetWebInfo();
        lang = window.parent.API_GetLang();
        PaymentClient = window.parent.API_GetPaymentAPI();
        lobbyClient = window.parent.API_GetLobbyAPI();
        mlp = new multiLanguage(v);
        mlp.loadLanguage(lang, function () {
            window.parent.API_LoadingEnd();
        }, "PaymentAPI");
        btn_NextStep();

        //Date.prototype.addSecs = function (s) {
        //    this.setTime(this.getTime() + (s * 1000));
        //    return this;
        //}

        GetPaymentMethod();

        $('#form').on('keyup keypress', function (e) {
            var keyCode = e.keyCode || e.which;
            if (keyCode === 13) {
                e.preventDefault();
                return false;
            }
        });
    }

    function CoinBtn_Click() {
        var seleAmount = parseInt($(event.currentTarget).data("val"));
        $("#amount").val(seleAmount);
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

    function setAmount() {
        $("input[name=amount]").prop("checked", false);
        var amount = $("#amount").val().replace(/[^\-?\d.]/g, '');
        amount = amount.replace('.', '');
        $("#amount").val(amount);

    }

    function btn_NextStep() {
        var Step3 = $('[data-deposite="step3"]');

        Step3.hide();

        $('button[data-deposite="step2"]').click(function () {
            window.parent.API_LoadingStart();
            //建立訂單/活動
            CreatePayPalDeposit();
        });
        $('button[data-deposite="step3"]').click(function () {
            window.parent.API_LoadingStart();
            //加入參加的活動
            setActivityNames();
        });
    }

    function CheckPaymentChannelAmount(amount, paymentChannelCode, cb) {
        lobbyClient.CheckPaymentChannelAmount(WebInfo.SID, Math.uuid(), WebInfo.MainCurrencyType, 0, amount, paymentChannelCode, function (success, o) {
            if (success) {
                if (o.Result == 0) {
                    cb(true, '');
                } else {
                    cb(false, o.Message);
                }
            }
        })
    }

    function GetPaymentMethod() {
        var splitPaymentChannelCode= PaymentChannelCode.split('.');
        if (splitPaymentChannelCode.length != 2) {
            window.parent.showMessageOK(mlp.getLanguageKey("錯誤"), mlp.getLanguageKey("貨幣未設定匯率"), function () {
                window.parent.location.href = "index.aspx"
            });
        } else {
            var serivce = splitPaymentChannelCode[1];
            var providerCode = splitPaymentChannelCode[0];
            var serivceName = PaymentChannelCode;

            if (serivce.includes('Gcash')) {
                $('#GCashPic').show();
                $('#GCashPic').find('.serivceName').text(serivceName);
            } else if (serivce.includes('Grabpay')) {
                $('#GrabPayPic').show();
                $('#GrabPayPic').find('.serivceName').text(serivceName);
            } else if (serivce.includes('Paymaya') || serivce.includes('QRPH')) {
                $('#PayMayaPic').show();
                $('#PayMayaPic').find('.serivceName').text(serivceName);
            }

            if (providerCode.includes("Feibao")) {
                providerCode = "Feibao";
            }

            PaymentClient.GetPaymentMethodByPaymentCodeFilterPaymentChannel(WebInfo.SID, Math.uuid(), providerCode, 0, PaymentChannelCode, WebInfo.UserInfo.UserLevel,0, function (success, o) {
                if (success) {
                    if (o.Result == 0) {
                        if (o.PaymentMethodResults.length > 0) {
                            PaymentMethod = o.PaymentMethodResults;
                            for (var i = 0; i < PaymentMethod.length; i++) {
                                if (PaymentMethod[i]["ExtraData"]) {
                                    PaymentMethod[i]["ExtraData"] = JSON.parse(PaymentMethod[i]["ExtraData"]);
                                }
                            }
                        } else {
                            window.parent.showMessageOK(mlp.getLanguageKey("錯誤"), mlp.getLanguageKey("貨幣未設定匯率"), function () {
                                window.parent.location.href = "index.aspx"
                            });
                        }
                    } else {
                        window.parent.showMessageOK(mlp.getLanguageKey("錯誤"), mlp.getLanguageKey("貨幣未設定匯率"), function () {
                            window.parent.location.href = "index.aspx"
                        });
                    }
                }
                else {
                    window.parent.showMessageOK(mlp.getLanguageKey("錯誤"), mlp.getLanguageKey("服務器異常, 請稍後再嘗試一次"), function () {
                        window.parent.location.href = "index.aspx"
                    });
                }

            })
        }

        
    }

    //建立訂單
    function CreatePayPalDeposit() {
        diabledBtn("btnStep2");
        if ($("#amount").val() != '') {
            var amount = parseFloat($("#amount").val());
            var paymentID = PaymentMethod[0]["PaymentMethodID"];
            CheckPaymentChannelAmount(amount, PaymentMethod[0]["PaymentCode"], function (s, message) {
                if (s) {
                    PaymentClient.CreateEPayDeposit(WebInfo.SID, Math.uuid(), amount, paymentID, '', function (success, o) {
                        if (success) {
                            let data = o.Data;
                            if (o.Result == 0) {
                                //$("#depositdetail .DepositName").text(data.ToInfo);
                                $("#depositdetail .Amount").text(new BigNumber(data.Amount).toFormat());
                                $("#depositdetail .TotalAmount").text(new BigNumber(data.Amount).toFormat());
                                $("#depositdetail .OrderNumber").text(data.OrderNumber);
                                $("#depositdetail .PaymentMethodName").text(data.PaymentMethodName);
                                $("#depositdetail .ThresholdValue").text(new BigNumber(data.ThresholdValue).toFormat());
                                ExpireSecond = data.ExpireSecond;

                                var depositdetail = document.getElementsByClassName("Collectionitem")[0];
                                var CollectionitemDom = c.getTemplate("templateCollectionitem");
                                c.setClassText(CollectionitemDom, "currency", null, data.ReceiveCurrencyType);
                                c.setClassText(CollectionitemDom, "val", null, new BigNumber(data.ReceiveTotalAmount).toFormat());
                                depositdetail.appendChild(CollectionitemDom);

                                OrderNumber = data.OrderNumber;
                                GetDepositActivityInfoByOrderNumber(OrderNumber);
                            } else {
                                window.parent.API_LoadingEnd(1);
                                window.parent.showMessageOK(mlp.getLanguageKey("錯誤"), mlp.getLanguageKey(o.Message), function () {

                                });
                            }

                        }
                        else {
                            window.parent.API_LoadingEnd(1);
                            $("#btnStep2").removeAttr("disabled");
                            window.parent.showMessageOK(mlp.getLanguageKey("錯誤"), mlp.getLanguageKey("訂單建立失敗"), function () {

                            });
                        }
                    })
                } else {
                    window.parent.API_LoadingEnd(1);
                    $("#btnStep2").removeAttr("disabled");
                    window.parent.showMessageOK(mlp.getLanguageKey("錯誤"), mlp.getLanguageKey(message));
                }
            });

        } else {
            window.parent.API_LoadingEnd(1);
            window.parent.showMessageOK(mlp.getLanguageKey("錯誤"), mlp.getLanguageKey("請輸入購買金額"), function () {
                $("#btnStep2").removeAttr("disabled");
            });
        }
    }

    function check_pKatakana(word) {

        if (word.match(/[^ァ-ヶ|ー]/)) {
            return true;
        } else {
            return false;
        }
    }
    //根據訂單編號取得可參加活動
    function GetDepositActivityInfoByOrderNumber(OrderNum) {
        PaymentClient.GetDepositActivityInfoByOrderNumber(WebInfo.SID, Math.uuid(), OrderNum, function (success, o) {
            if (success) {
                if (o.Data != null) {
                    if (o.Data.length > 0) {
                        var ThresholdValue = 0
                        for (var i = 0; i < o.Data.length; i++) {
                            setActivity(o.Data[i]["Title"], o.Data[i]["SubTitle"], o.Data[i]["ActivityName"], o.Data[i]["ThresholdValue"], o.Data[i]["BonusValue"], o.Data[i]["CollectAreaType"]);
                        }
                    }
                }

                var Step2 = $('[data-deposite="step2"]');
                var Step3 = $('[data-deposite="step3"]');
                Step2.hide();
                Step3.fadeIn();
                $('.progress-step:nth-child(3)').addClass('cur');
                window.parent.API_LoadingEnd(1);
            }
            else {
                window.parent.API_LoadingEnd(1);
                window.parent.showMessageOK(mlp.getLanguageKey("錯誤"), mlp.getLanguageKey("取得可參加活動失敗"), function () {

                });
            }
        })
    }

    //建立可選活動
    function setActivity(ActivityTitle, ActivitySubTitle, ActivityName, ThresholdValue, BonusValue, CollectAreaType) {
        var ParentActivity = document.getElementsByClassName("ActivityMain")[0];
        var ActivityCount = ParentActivity.children.length + 1;

        var ActivityDom = c.getTemplate("templateActivity");
        c.setClassText(ActivityDom, "ActivityTitle", null, ActivityTitle);
        c.setClassText(ActivityDom, "ActivitySubTitle", null, ActivitySubTitle);
        //ActivityDom.getElementsByClassName("ActivityCheckBox")[0].setAttribute("data-checked", "true");
        ActivityDom.getElementsByClassName("ActivityCheckBox")[0].setAttribute("data-ActivityName", ActivityName);
        ActivityDom.getElementsByClassName("ActivityCheckBox")[0].setAttribute("data-ThresholdValue", ThresholdValue);
        ActivityDom.getElementsByClassName("ActivityCheckBox")[0].setAttribute("data-bonusvalue", BonusValue);
        ActivityDom.getElementsByClassName("ActivityCheckBox")[0].setAttribute("data-collectareatype", CollectAreaType);
        ActivityDom.getElementsByClassName("ActivityCheckBox")[0].id = "award-bonus" + ActivityCount;
       // ActivityDom.getElementsByClassName("ActivityCheckBox")[0].setAttribute("checked", "true");
        ActivityDom.getElementsByClassName("custom-control-label")[0].setAttribute("for", "award-bonus" + ActivityCount);

        //$(".ThresholdValue_" + CollectAreaType).text(FormatNumber(ReFormatNumber($(".ThresholdValue_" + CollectAreaType).text()) + ThresholdValue));
        //$("#idBonusValue").text(FormatNumber(ReFormatNumber($("#idBonusValue").text()) + BonusValue));
        //$("#idTotalReceiveValue").text(new BigNumber(ReFormatNumber($("#idTotalReceiveValue").text())).plus(BonusValue).toString());

        ActivityDom.getElementsByClassName("ActivityCheckBox")[0].addEventListener("change", function (e) {
            let THV = $(e.target).data("thresholdvalue");
            let BV = $(e.target).data("bonusvalue");
            let CAT = $(e.target).data("collectareatype");
            let activityname = $(e.target).data("activityname");
            if ($(e.target).data("checked")) {
                //取消參加活動
                $(e.target).data("checked", false);
                $(".ThresholdValue_" + CAT).text(FormatNumber(ReFormatNumber($(".ThresholdValue_" + CAT).text()) - THV));
                $("#idBonusValue").text(FormatNumber(ReFormatNumber($("#idBonusValue").text()) - BV));
                $("#idTotalReceiveValue").text(FormatNumber(ReFormatNumber($("#idTotalReceiveValue").text()) - BV));
            } else {
                //參加活動
                $(e.target).data("checked", true);
                $(".ThresholdValue_" + CAT).text(FormatNumber(ReFormatNumber($(".ThresholdValue_" + CAT).text()) + THV));
                $("#idBonusValue").text(FormatNumber(ReFormatNumber($("#idBonusValue").text()) + BV));
                $("#idTotalReceiveValue").text(FormatNumber(ReFormatNumber($("#idTotalReceiveValue").text()) + BV));
            }
        });
        ParentActivity.appendChild(ActivityDom);
    }

    function ReFormatNumber(x) {
        return Number(x.toString().replace(/,/g, ''));
    }

    function FormatNumber(x) {
        return new BigNumber(x).toFormat();
    }

    function setActivityNames() {
        ActivityNames = [];
        for (var i = 0; i < $(".ActivityMain .ActivityCheckBox").length; i++) {
            if ($(".ActivityMain .ActivityCheckBox").eq(i).data("checked")) {
                ActivityNames.push($(".ActivityMain .ActivityCheckBox").eq(i).data("activityname"));
            }
        }
        ConfirmPayPalDeposit();
    }

    function ConfirmPayPalDeposit() {
        diabledBtn("btnStep3");
        PaymentClient.ConfirmEPayDeposit(WebInfo.SID, Math.uuid(), OrderNumber, ActivityNames, lang, "EPay", 0, function (success, o) {
            window.parent.API_LoadingEnd(1);
            if (success) {
                if (o.Result == 0) {
                    window.parent.showMessageOK(mlp.getLanguageKey("成功"), mlp.getLanguageKey("前往付款"), function () {
                        window.open(o.Message);
                    });

                    setExpireSecond();
                    let Step3 = $('button[data-deposite="step3"]');
                    //let Step4 = $('[data-deposite="step4"]');
                    Step3.hide();
                    $(".activity-container").hide();
                    //Step4.fadeIn();
                    $("#depositdetail").show();
                    $('.progress-step:nth-child(4)').addClass('cur');
                } else {
                    window.parent.showMessageOK(mlp.getLanguageKey("錯誤"), mlp.getLanguageKey(o.Message), function () {

                    });
                }
            }
            else {
                window.parent.showMessageOK(mlp.getLanguageKey("錯誤"), mlp.getLanguageKey("服務器異常, 請稍後再嘗試一次"), function () {

                });
            }
        })
    }

    function setExpireSecond() {
        var nowDate = new Date();
        nowDate.addSeconds(ExpireSecond);
        nowDate.addHours(1);
        $(".ExpireSecond").text(format(nowDate, "-"));
        $(".ExpireSecond").parent().show();
    }

    function format(Date, str) {
        var obj = {
            Y: Date.getFullYear(),
            M: Date.getMonth() + 1,
            D: Date.getDate(),
            H: Date.getHours(),
            Mi: Date.getMinutes(),
            S: Date.getSeconds()
        }
        // 拼接时间 hh:mm:ss
        var time = ' ' + supplement(obj.H) + ':' + supplement(obj.Mi) + ':' + supplement(obj.S);
        // yyyy-mm-dd
        if (str.indexOf('-') > -1) {
            return obj.Y + '-' + supplement(obj.M) + '-' + supplement(obj.D) + time;
        }
        // yyyy/mm/dd
        if (str.indexOf('/') > -1) {
            return obj.Y + '/' + supplement(obj.M) + '/' + supplement(obj.D) + time;
        }
    }

    function supplement(nn) {
        return nn = nn < 10 ? '0' + nn : nn;
    }

    function diabledBtn(btnid) {
        $("#" + btnid).attr("disabled", "true");

        setTimeout(() => {
            $("#" + btnid).removeAttr("disabled");
        }, "3000");
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
                    <div class="progress-step cur">
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

                <div class="progress-title text-wrap">
                    <p data-deposite="step2" class="language_replace">輸入存款金額</p>
                    <!--<p data-deposite="step3" class="language_replace" style="display: none">完成</p>
                     <p data-deposite="step4">支付</p> -->
                </div>

                <div class="split-layout-container">
                    <div class="aside-panel" data-deposite="step2">
                        <!-- PayPal -->
                        <div class="card-item sd-09" id="GCashPic" style="display:none;">
                            <div class="card-item-link">
                                <div class="card-item-inner">
                                    <div class="title">
                                        <span class="language_replace serviceName">GCash</span>
                                        <!-- <span>Electronic Wallet</span>  -->
                                    </div>                                   
                                    <div class="logo vertical-center text-center">
                                        <!-- <span class="text language_replace">銀行振込</span>   -->
                                          <img src="images/assets/card-surface/icon-logo-GCash.svg">                                 
                                    </div>
                                </div>
                                <img src="images/assets/card-surface/card-03.svg" class="card-item-bg" />
                            </div>
                        </div>
                        <div class="card-item sd-10"  id="GrabPayPic" style="display:none;">
                            <div class="card-item-link">
                                <div class="card-item-inner">
                                    <div class="title">
                                        <span class="language_replace serviceName">Grabpay</span>
                                        <!-- <span>Electronic Wallet</span>  -->
                                    </div>                                   
                                    <div class="logo vertical-center text-center">
                                        <!-- <span class="text language_replace">銀行振込</span>   -->
                                          <img src="images/assets/card-surface/icon-logo-GrabPay.svg">                                 
                                    </div>
                                </div>
                                <img src="images/assets/card-surface/card-10.svg" class="card-item-bg" />
                            </div>
                        </div>
                        <div class="card-item sd-11" id="PayMayaPic" style="display:none;">
                            <div class="card-item-link">
                                <div class="card-item-inner">
                                    <div class="title">
                                        <span class="language_replace serviceName">Paymaya</span>
                                        <!-- <span>Electronic Wallet</span>  -->
                                    </div>                                   
                                    <div class="logo vertical-center text-center">
                                        <!-- <span class="text language_replace">銀行振込</span>   -->
                                          <img src="images/assets/card-surface/icon-logo-PayMaya.svg">                                 
                                    </div>
                                </div>
                                <img src="images/assets/card-surface/card-11.svg" class="card-item-bg" />
                            </div>
                        </div>

                        <div class="text-wrap payment-change" style="display: none">
                            <a href="deposit.html" class="text-link c-blk">
                                <i class="icon-transfer"></i>
                                <span class="language_replace">切換</span>
                            </a>
                        </div>
                        <div class="form-content">
                            <!-- 存款提示 -->
                            <div class="form-group text-wrap desc mt-2 mt-md-4">
                                <!-- <h5 class="language_replace">便捷金額存款</h5> -->
                                <p class="text-s language_replace">請從下方金額選擇您要的金額，或是自行填入想要存款的金額。兩種方式擇一即可。</p>
                            </div>
                            <form id="form">
                                <div class="form-group">
                                    <div class="btn-wrap btn-radio-wrap btn-radio-payment">
                                        <div class="btn-radio btn-radio-coinType">
                                            <input type="radio" name="amount" id="amount2" />
                                            <label class="btn btn-outline-primary" for="amount2" data-val="5000" onclick="CoinBtn_Click()">
                                                <span class="coinType gameCoin">
                                                    <%-- <span class="coinType-title language_replace">遊戲幣</span>--%>
                                                    <span class="coinType-title">PHP</span>
                                                    <span class="coinType-amount OcoinAmount">5,000</span>
                                                </span>
                                            </label>
                                        </div>
                                        <div class="btn-radio btn-radio-coinType" >
                                            <input type="radio" name="amount" id="amount1" />
                                            <label class="btn btn-outline-primary" for="amount1" data-val="10000" onclick="CoinBtn_Click()">
                                                <span class="coinType gameCoin">
                                                    <%-- <span class="coinType-title language_replace">遊戲幣</span>--%>
                                                    <span class="coinType-title">PHP</span>
                                                    <span class="coinType-amount OcoinAmount">10,000</span>
                                                </span>
                                            </label>
                                        </div>

                                        <div class="btn-radio btn-radio-coinType">
                                            <input type="radio" name="amount" id="amount3" />
                                            <label class="btn btn-outline-primary" for="amount3" data-val="20000" onclick="CoinBtn_Click()">
                                                <span class="coinType gameCoin">
                                                    <%--<span class="coinType-title language_replace">遊戲幣</span>--%>
                                                    <span class="coinType-name">PHP</span>
                                                    <span class="coinType-amount OcoinAmount">20,000</span>
                                                </span>
                                            </label>
                                        </div>
                                    </div>
                                </div>

                                <!-- 輸入金額(美元) -->
                                <div class="form-group language_replace">
                                    <label class="form-title language_replace">輸入金額</label>
                                    <div class="input-group">
                                        <input type="text" class="form-control custom-style" id="amount" language_replace="placeholder" placeholder="請輸入金額" onkeyup="setAmount()" />
                                        <div class="form-notice-aside unit" id="OrderCurrencyType">PHP</div>
                                        <div class="invalid-feedback language_replace">提示</div>
                                    </div>
                                </div>
                             <%--   <div class="form-group depositLastName mb-2">
                                    <label class="form-title language_replace" >請正確填寫存款人之姓名</label>
                                    <div class="input-group">                                       
                                        <input type="text" class="form-control custom-style" id="bankCardNameFirst" language_replace="placeholder" placeholder="請填寫片假名的姓">
                                    </div>                            
                                </div>
                                <div class="form-group depositFirstName">
                                    <div class="input-group">
                                        <input type="text" class="form-control custom-style" id="bankCardNameSecond" language_replace="placeholder" placeholder="請填寫片假名的名">
                                    </div>                            
                                </div>--%>
                              

                            </form>
                          <%--   <div class="form-group text-wrap desc mt-2 mt-md-4">
                                <!-- <h5 class="language_replace">便捷金額存款</h5> -->
                                <p class="text-s language_replace">※存款金額為2,000ocoin至500,000ocoin。</p>
                                <p class="text-s language_replace">※OCoin必須在款項到帳後才會反映，如果過了1個銀行營業日也沒反映請聯絡客服。</p>
                                <p class="text-s language_replace">※此處填寫的全名必須與銀行的匯款人名稱（片假名）完全相同，敬請見諒。</p>
                                <p class="text-s language_replace">※訂單申請後請於20分鐘內匯款，若超過20分鐘未進行交易，請另提交易申請，以利交易順利進行。</p>
                            </div>--%>
                        </div>
                    </div>
                    <!-- 虛擬錢包 step4 -->
                    <div class="main-panel" data-deposite="step4">

                        <div class="crypto-info-coantainer">

                            <h4 class="mt-2 mt-md-4 cryoto-address language_replace">請盡速完成交易</h4>

                        </div>
                    </div>

                    <!-- 虛擬錢包 step3 - 入金確認頁-->
                    <div class="deposit-confirm " data-deposite="step3" id="depositdetail">
                        <div class="aside-panel">
                            <div class="deposit-calc">
                                <div class="deposit-crypto">
                                    <h5 class="subject-title language_replace">收款項目</h5>
                                    <ul class="deposit-crypto-list Collectionitem">
                                    </ul>
                                </div>
                                <div class="deposit-total">
                                    <div class="item subtotal">
                                        <div class="title">
                                            <h5 class="name language_replace">存入金額</h5>
                                        </div>
                                        <div class="data">
                                            <span class="name PaymentCode">PHP</span>
                                            <span class="count Amount"></span>
                                        </div>
                                    </div>
                                    <div class="item subtotal">
                                        <div class="title">
                                            <h5 class="name language_replace">活動獎勵</h5>
                                        </div>
                                        <div class="data">
                                            <span class="name">PHP</span>
                                            <span class="count" id="idBonusValue">0</span>
                                        </div>
                                    </div>
                                    <div class="item total">
                                        <div class="title">
                                            <h5 class="name language_replace">可得總額</h5>
                                        </div>
                                        <div class="data">
                                            <span class="name">PHP</span>
                                            <span class="count TotalAmount" id="idTotalReceiveValue"></span>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="main-panel">
                            <div class="deposit-list">
                                <h5 class="subject-title language_replace">存款細項</h5>
                                <ul class="deposit-detail">
                                    <li class="item" style="display: none">
                                        <h6 class="title language_replace">訂單號碼</h6>
                                        <span class="data OrderNumber"></span>
                                    </li>
                                 <%--   <li class="item">
                                        <h6 class="title language_replace">匯款人姓名</h6>
                                        <span class="data DepositName"></span>
                                    </li>--%>
                                    <li class="item">
                                        <h6 class="title language_replace">支付方式</h6>
                                        <span class="data PaymentMethodName"></span>
                                    </li>

                                    <li class="item " style="display: none">
                                        <h6 class="title language_replace">交易限制時間</h6>
                                        <span class="data text-primary ExpireSecond"></span>
                                    </li>

                                    <li class="item no-border mt-4">
                                        <h6 class="title language_replace">出金條件</h6>
                                        <ul class="deposit-detail-sub">
                                            <li class="sub-item">
                                                <span class="title language_replace">入金部份</span>
                                                <span class="data ThresholdValue">0</span>
                                            </li>
                                            <li class="sub-item">
                                                <span class="title language_replace">獎金部份</span>
                                                <span class="data ThresholdValue_1">0</span>
                                            </li>
                                            <li class="sub-item">
                                                <span class="title language_replace">禮金部份</span>
                                                <span class="data ThresholdValue_2">0</span>
                                            </li>
                                        </ul>
                                        <p class="text-note text-primary language_replace">*獎金和禮金的出金流水在BOUNS箱領取後才會追加</p>
                                    </li>

                                </ul>
                            </div>
                        </div>
                        <div class="activity-container">
                            <div class="activity-item">
                                <h5 class="subject-title language_replace">熱門活動</h5>
                                <!-- 存款獎勵 -->
                                <div class="text-wrap award-content">
                                    <ul class="deposit-award-list ActivityMain">
                                    </ul>
                                </div>
                            </div>
                        </div>
                    </div>

                </div>
                <!-- 溫馨提醒 -->
              <%--  <div class="notice-container" data-deposite="step3" style="margin-bottom:10px">
                    <div class="notice-item">
                        <i class="icon-info_circle_outline"></i>
                       <div class="text-wrap">
                            <p class="title language_replace">注意事項</p>
                            <ul class="list-style-decimal">
                                <li><span class="language_replace">點擊 下一步，會顯示收款人信息。</span></li>
                                <li><span class="language_replace">匯款人的名義請務必與轉賬時用的名義相同（片假名）。</span></li>
                                <li><span class="language_replace">若有差異的話，可能需要一些時間反映。也有可能無法反映，請注意。</span></li>
                                <li><span class="language_replace">根據不同的金融機構，若轉賬於銀行營業時間以外進行的話，將在下一個營業日才能確認匯款。</span></li>
                                <li><span class="language_replace">訂單申請後請於20分鐘內匯款，若超過20分鐘未進行交易，請另提交易申請，以利交易順利進行。</span></li>
                            </ul>
                        </div>
                    </div>
                </div>--%>

                <div class="btn-container">
                    <button class="btn btn-primary" data-deposite="step2" id="btnStep2">
                        <span class="language_replace">下一步</span>
                    </button>
                    <button class="btn btn-primary" data-deposite="step3" id="btnStep3">
                        <span class="language_replace">下一步</span>
                    </button>
                    <%--<button class="btn btn-outline-primary" data-deposite="step4" onclick="goBack()" style="display: none">
                        <span class="language_replace">取消</span>
                    </button>--%>
                </div>


            </section>
        </div>
    </div>



    <!-- Modal 有溫馨提醒-->
    <div class="modal fade" tabindex="-1" role="dialog" aria-labelledby="depositSucc" aria-hidden="true" id="depositSucc">
        <div class="modal-dialog modal-dialog-centered" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true"><i class="icon-close-small"></i></span>
                    </button>
                </div>
                <div class="modal-body">
                    <div class="modal-body-content">
                        <i class="icon-circle-check green"></i>
                        <div class="text-wrap">
                            <h6 class="language_replace">存款成功 !</h6>
                            <p class="language_replace">您可進入遊戲確認您本次的入金，以及對應的 Bouns 獎勵。</p>
                        </div>
                    </div>
                    <div class="modal-body-content">
                        <i class="icon-info_circle_outline"></i>
                        <div class="text-wrap">
                            <h6 class="language_replace">溫馨提醒</h6>
                            <p class="language_replace">不同的存款管道可能影響存款金額到達玩家錢包的時間。最遲一個營業日為合理的範圍。</p>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                </div>
            </div>
        </div>
    </div>

    <div id="templateCollectionitem" style="display: none">
        <li class="item">
            <div class="title">
                <h6 class="name currency"></h6>
            </div>
            <span class="data val"></span>
        </li>
    </div>
    <div id="templateActivity" style="display: none">
        <li class="item">
            <div class="custom-control custom-checkbox chkbox-item">
                <input class="custom-control-input-hidden ActivityCheckBox" type="checkbox" name="payment-crypto">
                <label class="custom-control-label">
                    <div class="detail">
                        <h6 class="title language_replace ActivityTitle"></h6>
                        <p class="desc language_replace ActivitySubTitle"></p>
                    </div>
                </label>
            </div>
        </li>
    </div>
</body>
</html>
