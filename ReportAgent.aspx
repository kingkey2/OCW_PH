<%@ Page Language="C#" %>

<%
    string Version = EWinWeb.Version;
%>

<!DOCTYPE html>

<html lang="zh-Hant-TW" class="innerHtml">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <title>Lucky Fanta</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="Scripts/vendor/swiper/css/swiper-bundle.min.css" rel="stylesheet" />
    <link rel="stylesheet" href="css/basic.min.css">
    <link rel="stylesheet" href="css/main.css">
    <link rel="stylesheet" href="css/record.css">
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+JP:wght@300;500&display=swap" rel="Prefetch" as="style" onload="this.rel = 'stylesheet'" />

    <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/4.6.2/js/bootstrap.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/Swiper/6.7.1/swiper-bundle.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/bignumber.js/9.0.2/bignumber.min.js"></script>
    <script type="text/javascript" src="/Scripts/Common.js"></script>
    <script type="text/javascript" src="/Scripts/UIControl.js"></script>
    <script type="text/javascript" src="/Scripts/MultiLanguage.js"></script>
    <script type="text/javascript" src="/Scripts/Math.uuid.js"></script>
    <script type="text/javascript" src="/Scripts/date.js"></script>
    <script type="text/javascript" src="Scripts/DateExtension.js"></script>
</head>
<script>
    if (self != top) {
        window.parent.API_LoadingStart();
    }

    var c = new common();
    var ui = new uiControl();
    var mlp;
    var lang;
    var WebInfo;
    var LobbyClient;
    var v = "<%:Version%>";

    function updateAccountingDetail() {
        var ParentMain = document.getElementById("divAgentReport_P");
        var ParentMain_M = document.getElementById("divAgentReport_M");
        ParentMain.innerHTML = "";
        ParentMain_M.innerHTML = "";
        document.getElementById("idNoGameData").style.display = "none";
        var startDate = $("#startDate").val();
        var endDate = $("#endDate").val();

        if (startDate == "") {
            window.parent.showMessageOK("", mlp.getLanguageKey("請輸入起始時間"));
            return;
        }

        if (endDate == "") {
            window.parent.showMessageOK("", mlp.getLanguageKey("請輸入結束時間"));
            return;
        }

        LobbyClient.GetAccountingDetailBySummaryDate(WebInfo.SID, Math.uuid(), startDate, endDate, function (success, o) {
            if (success) {
                if (o.ResultState == 0) {
                    if (o.AgentAccountingList.length > 0) {
                        for (var i = 0; i < o.AgentAccountingList.length; i++) {
                            var k = o.AgentAccountingList[i];
                            var RecordDom;
                            var RecordDom_M;

                            RecordDom = c.getTemplate("tmpAgentReport_P");

                            if (WebInfo.UserInfo.UserAccountType = 0) {
                                RecordDom_M = c.getTemplate("tmpAgentReport_M");
                            } else {
                                RecordDom_M = c.getTemplate("tmpAgentReport_M_Agent");
                            }

                            c.setClassText(RecordDom, "StartDate", null, k.StartDate);
                            c.setClassText(RecordDom, "EndDate", null, k.EndDate);
                            c.setClassText(RecordDom, "LoginAccount", null, k.LoginAccount);
                            c.setClassText(RecordDom, "AccountingName", null, k.AccountingName);
                            c.setClassText(RecordDom, "UserCommissionProfit", null, new BigNumber(k.UserCommissionProfit).toFixed(2));

                            c.setClassText(RecordDom_M, "StartDate_y", null, k.StartDate.split("-")[0]);
                            c.setClassText(RecordDom_M, "StartDate_m", null, k.StartDate.split("-")[1]);
                            c.setClassText(RecordDom_M, "StartDate_d", null, k.StartDate.split("-")[2]);
                            c.setClassText(RecordDom_M, "EndDate_y", null, k.EndDate.split("-")[0]);
                            c.setClassText(RecordDom_M, "EndDate_m", null, k.EndDate.split("-")[0]);
                            c.setClassText(RecordDom_M, "EndDate_d", null, k.EndDate.split("-")[0]);
                            c.setClassText(RecordDom_M, "LoginAccount", null, k.LoginAccount);
                            c.setClassText(RecordDom_M, "AccountingName", null, k.AccountingName);
                            c.setClassText(RecordDom_M, "UserCommissionProfit", null, new BigNumber(k.UserCommissionProfit).toFixed(2));

                            ParentMain.prepend(RecordDom);
                            ParentMain_M.prepend(RecordDom_M);
                        }

                        window.parent.API_CloseLoading();

                    } else {
                        document.getElementById("idNoGameData").style.display = "block";
                        //window.parent.showMessageOK(mlp.getLanguageKey("提示"), mlp.getLanguageKey("沒有資料"));
                        window.parent.API_CloseLoading();
                    }
                } else {
                    document.getElementById("idNoGameData").style.display = "block";
                    //window.parent.showMessageOK(mlp.getLanguageKey("提示"), mlp.getLanguageKey("取得資料失敗"));
                    window.parent.API_CloseLoading();
                }
            } else {
                window.parent.API_CloseLoading();
            }
        });
    }

    function getChildUserInfo() {
        var ParentMain = document.getElementById("divChildUser");
        ParentMain.innerHTML = "";
        LobbyClient.GetChildUserBySID(WebInfo.SID, Math.uuid(), function (success, o) {
            if (success) {
                if (o.ResultState == 0) {

                    var ChildUserList = JSON.parse(o.ChildUserList);

                    if (ChildUserList.length > 0) {
                        $("#childCount").text(ChildUserList.length);
                        for (var i = 0; i < ChildUserList.length; i++) {
                            var k = ChildUserList[i];
                            var RecordDom;
                            var UserAccountType = k.UserAccountType;

                            if (UserAccountType == 0) {
                                RecordDom = c.getTemplate("tmpChild");
                            } else {
                                RecordDom = c.getTemplate("tmpChild_Agent");
                            }
                            c.setClassText(RecordDom, "member-account", null, k.LoginAccount);

                            ParentMain.prepend(RecordDom);
                        }

                        window.parent.API_CloseLoading();

                    } else {
                        document.getElementById("idNoGameData").style.display = "block";
                        //window.parent.showMessageOK(mlp.getLanguageKey("提示"), mlp.getLanguageKey("沒有資料"));
                        window.parent.API_CloseLoading();
                    }

                } else {

                }
            } else {
                window.parent.API_CloseLoading();
            }
        });
    }

    function copyText(tag) {
        if (event) {
            event.stopPropagation();
        }

        var copyText = $(tag).parent().find('.inputPaymentSerial')[0];

        copyText.select();
        copyText.setSelectionRange(0, 99999);

        copyToClipboard(copyText.value).then(
            () => { window.parent.showMessageOK(mlp.getLanguageKey("提示"), mlp.getLanguageKey("複製成功")) },
            () => { window.parent.showMessageOK(mlp.getLanguageKey("提示"), mlp.getLanguageKey("複製失敗")) });
    }

    function copyToClipboard(textToCopy) {
        if (navigator.clipboard && window.isSecureContext) {
            return navigator.clipboard.writeText(textToCopy);
        } else {
            let textArea = document.createElement("textarea");
            textArea.value = textToCopy;
            textArea.style.position = "fixed";
            textArea.style.left = "-999999px";
            textArea.style.top = "-999999px";
            document.body.appendChild(textArea);
            textArea.focus();
            textArea.select();
            return new Promise((res, rej) => {
                document.execCommand('copy') ? res() : rej();
                textArea.remove();
            });
        }
    }

    function updateBaseInfo() {
        getChildUserInfo();
    }

    function EWinEventNotify(eventName, isDisplay, param) {
        switch (eventName) {
            case "LoginState":

                break;
            case "BalanceChange":
                break;

            case "SetLanguage":
                var lang = param;

                mlp.loadLanguage(lang, function () {

                    var gameDoms = document.querySelectorAll(".gameLangkey");

                    for (var i = 0; i < gameDoms.length; i++) {
                        var gameDom = gameDoms[i];

                        window.parent.API_GetGameLang(lang, gameDom.getAttribute("gameLangkey"), (function (langText) {
                            var gameDom = this;
                            gameDom.innerText = langText;
                        }).bind(gameDom));
                    }

                    window.parent.API_LoadingEnd(1);
                });
                break;
        }
    }

    function init() {
        if (self == top) {
            window.parent.location.href = "index.aspx";
        }

        WebInfo = window.parent.API_GetWebInfo();
        p = window.parent.API_GetPaymentAPI();
        LobbyClient = window.parent.API_GetLobbyAPI();
        lang = window.parent.API_GetLang();
        mlp = new multiLanguage(v);
        mlp.loadLanguage(lang, function () {
            window.parent.API_LoadingEnd();

            if (p != null) {

                if (WebInfo.DeviceType == 1) {
                    $("#divAgentReport_M").show();
                    $("#divAgentReport").hide();
                } else {
                    $("#divAgentReport_M").hide();
                    $("#divAgentReport").show();
                }

                $("#startDate").val(Date.today().moveToFirstDayOfMonth().toString("yyyy-MM-dd"));
                $("#endDate").val(Date.today().toString("yyyy-MM-dd"));

                updateBaseInfo();
            } else {
                window.parent.showMessageOK(mlp.getLanguageKey("錯誤"), mlp.getLanguageKey("網路錯誤"), function () {
                    window.parent.location.href = "index.aspx";
                });
            }
        });
    }

    window.onload = init;
</script>
<body class="innerBody">
    <main class="innerMain" id="top">
        <div class="page-content">
            <!-- 代理報表 TAB -->
            <div class="tab-wrapper sticky tab-report-wrapper">
                <div class="container">
                    <div class="tab-report tab-scroller tab-2 tab-primary">
                        <div class="tab-scroller__area">
                            <ul class="tab-scroller__content">
                                <li class="tab-item payment active" onclick="" id="tabRecordPayment">
                                    <a class="tab-item-link" href="#top"><span class="title"><span class="language_replace">會員管理</span></span>
                                    </a>
                                </li>
                                <li class="tab-item game" onclick="" id="tabRecordGame">
                                    <a class="tab-item-link" href="#idMemberReport"><span class="title"><span class="language_replace">代理報表</span></span>
                                    </a>
                                </li>
                                <div class="tab-slide"></div>
                            </ul>
                        </div>
                    </div>
                </div>
            </div>

            <section id="idMemberMange" class="section-wrap section-agentDownline-member">
                <div class="container">
                    <div class="sec-title-container sec-title-record sec-report-agentDownline">
                        <div class="sec-title-wrapper">
                            <h1 class="sec-title title-deco"><span class="language_replace">推廌會員管理</span></h1>
                        </div>
                        <div class="sec_link sec-number">
                            <span class="title language_replace">推廣人數</span>
                            <span class="data">
                                <span class="number" id="childCount">0</span>
                                <span class="unit language_replace">位</span>
                            </span>
                        </div>
                    </div>
                    <div class="agentDownline-member-wrapper">
                        <ul class="agentDownline-member-list" id="divChildUser">
   


                        </ul>
                    </div>
                </div>
            </section>


            <!-- 紀錄 - Table -->
            <section id="idMemberReport" class="section-wrap section-agentDownline-report">
                <div class="container">
                    <div class="sec-title-container sec-title-record sec-report-agentDownline">
                        <div class="sec-title-wrapper">
                            <h1 class="sec-title title-deco"><span class="language_replace">代理報表
                            </span></h1>
                        </div>
                        <div class="sec-input row">
                            <div class="form-group col-6 col-smd-4 col-md-auto">
                                <label class="form-title language_replace">起始日期</label>
                                <div class="input-group">
                                    <input id="startDate" type="date" name="" class="form-control custom-style">
                                </div>
                            </div>
                            <div class="form-group col-6 col-smd-4 col-md-auto">
                                <label class="form-title language_replace">結束日期</label>
                                <div class="input-group">
                                    <input id="endDate" type="date" name="" class="form-control custom-style">
                                </div>
                            </div>
                            <div class="form-group col-12 col-smd-4 col-md-auto">
                                <button type="button" class="btn btn-full-main btn-roundcorner btn-sm" onclick="updateAccountingDetail()">
                                    <span class="language_replace">搜尋</span>
                                </button>
                            </div>

                        </div>
                    </div>
                    <!-- PC 版 -->
                    <div class="MT__table table-RWD table-desktop table-agentDownline">
                        <!-- thead  -->
                        <div class="Thead">
                            <div class="thead__tr">
                                <div class="thead__th"><span class="language_replace">結算時間</span></div>
                                <div class="thead__th"><span class="language_replace">會員帳號</span></div>
                                <div class="thead__th"><span class="language_replace">結算計畫</span></div>
                                <div class="thead__th"><span class="language_replace">傭金</span></div>
                            </div>
                        </div>
                        <!-- tbody -->
                        <div class="Tbody" id="divAgentReport_P">
                        </div>
                    </div>

                    <!-- MOBILE 版-->
                    <div class="record-table-container">
                        <div class="record-table record-agentDownline">

                            <!-- 若 member為 agent => class=>agent -->
                            <div id="divAgentReport_M">
                            </div>

                            <div class="no-Data" id="idNoGameData" style="display: none;">
                                <div class="data">
                                    <span class="text language_replace">沒有資料</span>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </section>
        </div>
    </main>

    <!-- 推廌會員管理 -->


    <!-- 代理報表 -->


    <!-- 代理報表 手機-->

    <div id="tmpAgentReport_P" style="display: none">
        <div class="tbody__tr">
            <div class="tbody__td td-date">
                <span class="td__content">
                    <span class="date-period">
                        <span class="date-start StartDate">2022/10/4</span>~<span class="date-end EndDate">2022/10/30</span>
                    </span>
                </span>
            </div>
            <div class="tbody__td td-account">
                <span class="td__content"><span class="LoginAccount">Eddie1234@kingkey.com.tw</span></span>
            </div>

            <div class="tbody__td td-project">
                <span class="td__content">
                    <span class="AccountingName">9/20 結算測試</span></span>
            </div>
            <div class="tbody__td td-amount td-number">
                <span class="td__content"><span class="amount positive UserCommissionProfit">100000.00</span></span>
            </div>
        </div>
    </div>

    <div id="tmpAgentReport_M" style="display: none">
        <div class="record-table-item">
            <div class="record-table-tab">
                <!-- 日期 -->
                <div class="record-table-cell td-date">
                    <span class="date-period">
                        <span class="date-start">
                            <span class="year StartDate_y">2022</span>
                            <span class="month StartDate_m">06</span>
                            <span class="day StartDate_d">14</span>
                        </span>
                        <span class="date-end">
                            <span class="year EndDate_y">2022</span>
                            <span class="month EndDate_m">06</span>
                            <span class="day EndDate_d">14</span>
                        </span>
                    </span>
                </div>
                <div class="record-table-wrapper">
                    <!-- 帳號 -->
                    <div class="record-table-cell td-account">
                        <span class="title"><i class="icon icon-mask icon-people"></i></span>
                        <span class="data LoginAccount">Eddie1234@kingkey.com.tw</span>
                    </div>
                    <div class="td-wrapper">
                        <!-- 結算計畫 -->
                        <div class="record-table-cell td-project">
                            <span class="title"><i class="icon icon-mask icon-flag"></i></span>
                            <span class="data AccountingName">結算測試 project</span>
                        </div>
                        <!-- 結算計畫 -->
                        <div class="record-table-cell td-commission">
                            <span class="title">
                                <span class="text language_replace">傭金</span>
                            </span>
                            <span class="data number UserCommissionProfit">3000.00</span>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div id="tmpAgentReport_M_Agent" style="display: none">
        <div class="record-table-item agent">
            <div class="record-table-tab">
                <!-- 日期 -->
                <div class="record-table-cell td-date">
                    <span class="date-period">
                        <span class="date-start">
                            <span class="year">2022</span>
                            <span class="month">06</span>
                            <span class="day">14</span>
                        </span>
                        <span class="date-end">
                            <span class="year">2022</span>
                            <span class="month">06</span>
                            <span class="day">14</span>
                        </span>
                    </span>
                </div>
                <div class="record-table-wrapper">
                    <!-- 帳號 -->
                    <div class="record-table-cell td-account">
                        <span class="title"><i class="icon icon-mask icon-people"></i></span>
                        <span class="data LoginAccount">Eddie1234@kingkey.com.tw</span>
                    </div>
                    <div class="td-wrapper">
                        <!-- 結算計畫 -->
                        <div class="record-table-cell td-project">
                            <span class="title"><i class="icon icon-mask icon-flag"></i></span>
                            <span class="data AccountingName">結算測試 project</span>
                        </div>
                        <!-- 結算計畫 -->
                        <div class="record-table-cell td-commission">
                            <span class="title">
                                <span class="text language_replace">傭金</span>
                            </span>
                            <span class="data number UserCommissionProfit">3000.00</span>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div id="tmpChild" style="display: none">
        <li class="member-item">
            <span class="member-inner">
                <i class="icon icon-mask icon-people"></i>
                <span class="member-account"></span>
            </span>
        </li>
    </div>

    <div id="tmpChild_Agent" style="display: none">
        <li class="member-item agent">
            <span class="member-inner">
                <i class="icon icon-mask icon-people"></i>
                <span class="member-account"></span>
            </span>
        </li>
    </div>
</body>
</html>
