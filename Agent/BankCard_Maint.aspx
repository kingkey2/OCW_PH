<%@ Page Language="C#" AutoEventWireup="true" CodeFile="BankCard_Maint.aspx.cs" Inherits="BankCard_Maint" %>

<%
    string LoginAccount = Request["LoginAccount"];
    string ASID = Request["ASID"];
    EWin.SpriteAgent.SpriteAgent api = new EWin.SpriteAgent.SpriteAgent();
    EWin.SpriteAgent.AgentSessionResult ASR = null;
    EWin.SpriteAgent.AgentSessionInfo ASI = null;
    string AgentVersion = EWinWeb.AgentVersion;

    ASR = api.GetAgentSessionByID(ASID);

    if (ASR.Result != EWin.SpriteAgent.enumResult.OK) {
        Response.Redirect("login.aspx");
    } else {
        ASI = ASR.AgentSessionInfo;
    }

%>
<!doctype html>
<html lang="zh-Hant-TW" class="innerHtml">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <title>銀行卡設定</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="css/basic.min.css?<%:AgentVersion%>">
    <link rel="stylesheet" href="css/main2.css?<%:AgentVersion%>">
    <style>
        .tree-btn {
            padding: 0px 9px;
            border: none;
            display: inline-block;
            vertical-align: middle;
            overflow: hidden;
            text-decoration: none;
            color: inherit;
            background-color: inherit;
            text-align: center;
            cursor: pointer;
            white-space: nowrap;
            user-select: none;
            border-radius: 50%;
            font-size: 14px;
            font-weight: bold;
            border: 3px solid rgba(227, 195, 141, 0.8);
        }

        .agentPlus {
            padding: 0px 7px;
        }

        .tree-btn:hover {
            color: #fff;
            background-color: rgba(227, 195, 141, 0.8);
        }



        .MT2__table .tbody .tbody__tr:nth-child(2n) {
            /*background-color: rgba(0, 0, 0, 0.2);*/
        }

        .switch_tr {
            background-color: rgba(0, 0, 0, 0.2);
        }

        @keyframes searchTarget {
            0% {
                background-color: indianred;
            }

            50% {
                background-color: #607d8b;
            }

            100% {
                background-color: indianred;
            }
        }

        .searchTarget {
            background-color: indianred;
            animation-name: searchTarget;
            animation-duration: 4s;
            animation-delay: 2s;
            animation-iteration-count: infinite;
        }
    </style>
</head>
<!-- <script type="text/javascript" src="js/AgentCommon.js"></script> -->
<script type="text/javascript" src="js/AgentCommon.js"></script>
<script type="text/javascript" src="/Scripts/Common.js"></script>
<script type="text/javascript" src="/Scripts/bignumber.min.js"></script>
<script type="text/javascript" src="/Scripts/Math.uuid.js"></script>
<script type="text/javascript" src="Scripts/MultiLanguage.js"></script>
<script type="text/javascript" src="../Scripts/jquery-3.3.1.min.js"></script>
<script type="text/javascript" src="js/date.js"></script>
<script>
    var ApiUrl = "BankCard_Maint.aspx";
    var c = new common();
    var ac = new AgentCommon();
    var mlp;
    var EWinInfo;
    var api;
    var lang;
    var startDate;
    var endDate;
    var currencyType = "";
    var PageNumber = 1;
    //var hasDataExpand;

    function agentExpand(SortKey) {
        var expandBtn = event.currentTarget;
        if (expandBtn) {
            var exists = !(expandBtn.classList.toggle("agentPlus"));
            if (exists) {
                //s
                expandBtn.innerText = "-";
                checkParentLoginAccountExists(SortKey)
            } else {
                //c
                expandBtn.innerText = "+";
                hideChildAllRow(SortKey);
            }
        }
    }

    function checkParentLoginAccountExists(SortKey) {
        var doms = document.querySelectorAll(".row_s_" + SortKey);
        for (var ii = 0; ii < doms.length; ii++) {
            var dom = doms[ii];
            dom.style.display = "table-row";
        }
    }

    function hideChildAllRow(SortKey) {
        var doms = document.querySelectorAll(".row_c_" + SortKey);
        for (var i = 0; i < doms.length; i++) {
            var dom = doms[i];
            var btn = dom.querySelector('.Expand');

            dom.style.display = "none";
            if (btn) {
                btn.classList.add("agentPlus");
                btn.innerText = "+";
            }
        }
    }

    function toggleAllRow(isExpand) {
        var doms = document.querySelectorAll(".row_child");
        for (var i = 0; i < doms.length; i++) {
            var dom = doms[i];
            var btn = dom.querySelector('.Expand');

            if (isExpand) {
                dom.style.display = "table-row";

                if (btn) {
                    btn.classList.remove("agentPlus");
                    btn.innerText = "-";
                }
            } else {
                dom.style.display = "none";

                if (btn) {
                    btn.classList.add("agentPlus");
                    btn.innerText = "+";
                }
            }
        }

        doms = document.querySelectorAll(".row_top");

        for (var i = 0; i < doms.length; i++) {
            var dom = doms[i];
            var btn = dom.querySelector('.Expand');

            if (isExpand) {
                if (btn) {
                    btn.classList.remove("agentPlus");
                    btn.innerText = "-";
                }
            } else {
                if (btn) {
                    btn.classList.add("agentPlus");
                    btn.innerText = "+";
                }
            }
        }
    }

    function querySelfData() {
        var currencyTypeDom = "";
        PageNumber = 1;

        startDate = document.getElementById("startDate");
        endDate = document.getElementById("endDate");
        currencyTypeDom = document.getElementsByName("chkCurrencyType");

        if (currencyTypeDom) {
            if (currencyTypeDom.length > 0) {
                for (i = 0; i < currencyTypeDom.length; i++) {
                    if (currencyTypeDom[i].checked == true) {
                        currencyType = currencyTypeDom[i].value;
                        break;
                    }
                }
            }
        }

        queryData();
    }

    function queryData() {
        if (currencyType != "") {
            var LoginAccount = "";

            if (loginAccount.value.trim() != '') {
                LoginAccount = loginAccount.value;
            }

            var postData = {
                AID: EWinInfo.ASID,
                SearchLoginAccount: LoginAccount,
                LoginAccount: EWinInfo.UserInfo.LoginAccount,
                RowsPage: 50, //一頁顯示的比數
                PageNumber: PageNumber,
                CurrencyType: currencyType
            };
            window.parent.API_ShowLoading();
            c.callService(ApiUrl + "/GetUserAccountSummary", postData, function (success, o) {
                if (success) {
                    var obj = c.getJSON(o);

                    if (obj.Result == 0) {
                        updateList(obj);
                    } else {

                        window.parent.API_ShowMessageOK(mlp.getLanguageKey("錯誤"), mlp.getLanguageKey(obj.Message));
                    }
                } else {
                    if (o == "Timeout") {
                        window.parent.API_ShowMessageOK(mlp.getLanguageKey("錯誤"), mlp.getLanguageKey("網路異常, 請稍後重新嘗試"));
                    } else {
                        window.parent.API_ShowMessageOK(mlp.getLanguageKey("錯誤"), o);
                    }
                }

                window.parent.API_CloseLoading();
            });
        }
        else {
            window.parent.API_ShowMessageOK(mlp.getLanguageKey("提醒"), mlp.getLanguageKey("請至少選擇一個幣別!!"));
        }
    }

    function updateList(o) {
        var idList = document.getElementById("idList");

        if (o.SearchPageNumber == 1) {
            c.clearChildren(idList);
        }

        if (o.SummaryList && o.SummaryList.length > 0) {
            document.getElementById("idResultTable").classList.remove("MT_tableDiv__hasNoData");
            idList.classList.remove("tbody__hasNoData");
            for (var i = 0; i < o.SummaryList.length; i++) {
                var item = o.SummaryList[i];
                var t = c.getTemplate("templateTableItem");
                c.setClassText(t, "LoginAccount", null, item.LoginAccount);
                c.setClassText(t, "InsideLevel", null, item.DealUserAccountInsideLevel);
                c.setClassText(t, "ParentLoginAccount", null, item.ParentLoginAccount);
                c.setClassText(t, "CurrencyType", null, item.CurrencyType);
                c.setClassText(t, "PointValue", null, c.toCurrency(item.PointValue));

                var stateDom = t.querySelector(".UserAccountState");

                if (item.UserAccountState == 0) {
                    stateDom.innerText = mlp.getLanguageKey("正常");
                    stateDom.style.color = "aqua";
                } else {
                    stateDom.innerText = mlp.getLanguageKey("停用");
                    stateDom.style.color = "red";
                }
                c.setClassText(t, "LastLoginDate", null, item.LastLoginDate);
                c.setClassText(t, "CreateDate", null, item.CreateDate);

                idList.appendChild(t);
            }

            if (o.HasNextPage) {
                $("#btnShowNextData").show();
            } else {
                $("#btnShowNextData").hide();
            }

        } else {
            var div = document.createElement("DIV");

            div.id = "hasNoData_DIV"
            div.innerHTML = mlp.getLanguageKey("無數據");
            div.classList.add("td__content", "td__hasNoData");
            document.getElementById("idResultTable").classList.add("MT_tableDiv__hasNoData");
            idList.classList.add("tbody__hasNoData");
            idList.appendChild(div);

            window.parent.API_ShowMessageOK(mlp.getLanguageKey("提醒"), mlp.getLanguageKey("無數據"));
        }
    }

    function changeDateTab(e, type) {
        window.event.stopPropagation();
        window.event.preventDefault();
        var beginDate;
        var endDate;
        var tabMainContent = document.getElementById("idTabMainContent");
        var tabItem = tabMainContent.getElementsByClassName("nav-link");
        for (var i = 0; i < tabItem.length; i++) {
            tabItem[i].classList.remove('active');
            tabItem[i].parentNode.classList.remove('active');

            //tabItem[i].setAttribute("aria-selected", "false");

        }

        document.getElementById("sliderDate").style.display = "block";

        e.parentNode.classList.add('active');
        e.classList.add('active');
        //e.setAttribute("aria-selected", "true");
        switch (type) {
            case 0:
                //本日
                beginDate = Date.today().toString("yyyy-MM-dd");
                endDate = Date.today().toString("yyyy-MM-dd");
                document.getElementById("startDate").value = beginDate;
                document.getElementById("endDate").value = endDate;
                break;
            case 1:
                //昨日
                beginDate = Date.today().addDays(-1).toString("yyyy-MM-dd");
                endDate = Date.today().addDays(-1).toString("yyyy-MM-dd");
                document.getElementById("startDate").value = beginDate;
                document.getElementById("endDate").value = endDate;
                break;
            case 2:
                //本周
                beginDate = getFirstDayOfWeek(Date.today()).toString("yyyy-MM-dd");
                endDate = getLastDayOfWeek(Date.today()).toString("yyyy-MM-dd");
                document.getElementById("startDate").value = beginDate;
                document.getElementById("endDate").value = endDate;
                break;
            case 3:
                //上週  
                beginDate = getFirstDayOfWeek(Date.today().addDays(-7)).toString("yyyy-MM-dd");
                endDate = getLastDayOfWeek(Date.today().addDays(-7)).toString("yyyy-MM-dd");
                document.getElementById("startDate").value = beginDate;
                document.getElementById("endDate").value = endDate;
                break;
            case 4:
                //本月
                beginDate = Date.today().moveToFirstDayOfMonth().toString("yyyy-MM-dd");
                endDate = Date.today().moveToLastDayOfMonth().toString("yyyy-MM-dd");
                document.getElementById("startDate").value = beginDate;
                document.getElementById("endDate").value = endDate;
                break;
            case 5:
                //上月
                beginDate = Date.today().addMonths(-1).moveToFirstDayOfMonth().toString("yyyy-MM-dd");
                endDate = Date.today().addMonths(-1).moveToLastDayOfMonth().toString("yyyy-MM-dd");
                document.getElementById("startDate").value = beginDate;
                document.getElementById("endDate").value = endDate;
                break;
        }
    }

    function setSearchFrame() {
        var pi = null;
        var templateDiv;
        var CurrencyTypeDiv = document.getElementById("CurrencyTypeDiv");
        var tempCurrencyRadio;
        var tempCurrencyName;


        document.getElementById("startDate").value = getFirstDayOfWeek(Date.today()).toString("yyyy-MM-dd");
        document.getElementById("endDate").value = getLastDayOfWeek(Date.today()).toString("yyyy-MM-dd");

        if (EWinInfo.UserInfo != null) {
            if (EWinInfo.UserInfo.WalletList != null) {
                pi = EWinInfo.UserInfo.WalletList;
                if (pi.length > 0) {
                    for (var i = 0; i < pi.length; i++) {
                        templateDiv = c.getTemplate("templateDiv");

                        tempCurrencyRadio = c.getFirstClassElement(templateDiv, "tempRadio");
                        tempCurrencyName = c.getFirstClassElement(templateDiv, "tempName");
                        tempCurrencyRadio.value = pi[i].CurrencyType;
                        tempCurrencyRadio.name = "chkCurrencyType";
                        tempCurrencyName.innerText = pi[i].CurrencyType;

                        if (i == 0) {
                            tempCurrencyRadio.checked = true;
                        }

                        tempCurrencyRadio.classList.remove("tempRadio");
                        tempCurrencyName.classList.remove("tempName");

                        CurrencyTypeDiv.appendChild(templateDiv);
                    }
                }
            }
        }
    }

    function getFirstDayOfWeek(d) {
        let date = new Date(d);
        let day = date.getDay();

        let diff = date.getDate() - day + (day === 0 ? -6 : 1);

        return new Date(date.setDate(diff));
    }

    function getLastDayOfWeek(d) {
        let firstDay = getFirstDayOfWeek(d);
        let lastDay = new Date(firstDay);

        return new Date(lastDay.setDate(lastDay.getDate() + 6));
    }

    function disableDateSel() {
        var tabItem = document.getElementById("idTabMainContent").getElementsByClassName("nav-link");

        for (var i = 0; i < tabItem.length; i++) {
            //tabItem[i].classList.remove('active');
            tabItem[i].classList.remove('active');
            tabItem[i].parentNode.classList.remove('active');

            //tabItem[i].setAttribute("aria-selected", "false");
        }
        document.getElementById("sliderDate").style.display = "none";
    }

    function showNextData() {
        PageNumber = PageNumber + 1;
        queryData();
    }

    function init() {
        var d = new Date();

        EWinInfo = window.parent.EWinInfo;
        api = window.parent.API_GetAgentAPI();
        setSearchFrame();

        lang = window.localStorage.getItem("agent_lang");
        mlp = new multiLanguage();
        mlp.loadLanguage(lang, function () {
            //queryOrderSummary(qYear, qMon);
            window.parent.API_CloseLoading();
            //queryData(EWinInfo.UserInfo.LoginAccount);
            querySelfData();
            ac.dataToggleCollapseInit();
        });
    }

    function EWinEventNotify(eventName, isDisplay, param) {
        switch (eventName) {
            case "WindowFocus":
                //updateBaseInfo();
                ac.dataToggleCollapseInit();
                break;
        }
    }

    window.onload = init;
</script>
<body class="innerBody">
    <main>
        <div class="dataList dataList-box fixed top real-fixed">
            <div class="container-fluid">
                <div class="collapse-box">
                    <h2 class="collapse-header has-arrow zIndex_overMask_SafariFix" onclick="ac.dataToggleCollapse(this)" data-toggle="collapse" data-target="#searchList" aria-controls="searchList" aria-expanded="true" aria-label="searchList">
                        <span class="language_replace">卡片設定</span>
                        <i class="arrow"></i>
                    </h2>
                    <!-- collapse內容 由此開始 ========== -->
                    <div id="searchList" class="collapse-content collapse show">
                        <div id="divSearchContent" class="row searchListContent">
                            <div class="col-12">
                                <div class="form-group wrapper_center dataList-process">
                                    <button class="btn btn-full-main btn-roundcorner " onclick="queryData()"><i class="icon icon-before icon-ewin-input-submit"></i><span class="language_replace">確認</span></button>
                                </div>
                            </div>
                            <!-- iOS Safari Virtual Keyboard Fix--------------->
                            <div id="div_MaskSafariFix" class="mask_Input_Safari" onclick="clickMask()"></div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- 表格 由此開始 ========== -->
        <div class="container-fluid wrapper__TopCollapse orderHistory_userAccount">
            <div class="MT__tableDiv" id="idResultTable">
                <!-- 自訂表格 -->
                <div class="MT2__table table-col-8 w-200">
                    <div id="templateTableItem" style="display: none">
                        <div class="tbody__tr td-non-underline-last-2">
                            <div class="tbody__td date td-100 nonTitle">
                                <span class="td__title"><span class="language_replace">帳號</span></span>
                                <span class="td__content Space">
                                    <%--                                    <span class="noChild" style="padding: 0px 12px; display: none"></span>
                                    <button class="tree-btn Expand">+</button>--%>
                                    <span class="LoginAccount">CON5</span>
                                </span>
                            </div>
                            <div class="tbody__td td-3 nonTitle">
                                <span class="td__title"><span class="language_replace">層級</span></span>
                                <span class="td__content"><i class="icon icon-s icon-before"></i><span class="InsideLevel"></span></span>
                            </div>
                            <div class="tbody__td td-3 nonTitle">
                                <span class="td__title"><span class="language_replace">上線帳號</span></span>
                                <span class="td__content"><i class="icon icon-ewin-default-currencyType icon-s icon-before"></i><span class="ParentLoginAccount"></span></span>
                            </div>
                            <div class="tbody__td td-3 nonTitle">
                                <span class="td__title"><span class="language_replace">貨幣</span></span>
                                <span class="td__content"><i class="icon icon-ewin-default-currencyType icon-s icon-before"></i><span class="CurrencyType"></span></span>
                            </div>
                            <%--                            <div class="tbody__td td-number td-3 td-vertical">
                                <span class="td__title"><i class="icon icon-ewin-default-totalWinLose icon-s icon-before"></i><span class="language_replace">團隊代理數</span></span>
                                <span class="td__content"><span class="AgentCount"></span></span>
                            </div>
                            <div class="tbody__td td-number td-3 td-vertical">
                                <span class="td__title"><i class="icon icon-ewin-default-totalRolling icon-s icon-before"></i><span class="language_replace">團隊會員數</span></span>
                                <span class="td__content"><span class="PlayerCount"></span></span>
                            </div>
                            <div class="tbody__td td-number td-3 td-vertical">
                                <span class="td__title"><i class="icon icon-ewin-default-totalRolling icon-s icon-before"></i><span class="language_replace">期間團隊新增下線數</span></span>
                                <span class="td__content"><span class="NewUserCount">CON4</span></span>
                            </div>
                            <div class="tbody__td td-number td-3 td-vertical">
                                <span class="td__title"><i class="icon icon-ewin-default-accountWinLose icon-s icon-before"></i><span class="language_replace">期間個人新增會員數</span></span>
                                <span class="td__content"><span class="SelfNewUserCount">CON4</span></span>
                            </div>--%>
                            <div class="tbody__td td-number td-3 td-vertical">
                                <span class="td__title"><i class="icon icon-ewin-default-accountRolling icon-s icon-before"></i><span class="language_replace">錢包餘額</span></span>
                                <span class="td__content"><span class="PointValue">CON4</span></span>
                            </div>
                            <div class="tbody__td td-number td-3 td-vertical">
                                <span class="td__title"><i class="icon icon-ewin-default-accountRolling icon-s icon-before"></i><span class="language_replace">狀態</span></span>
                                <span class="td__content"><span class="UserAccountState">CON4</span></span>
                            </div>
                            <div class="tbody__td td-number td-3 td-vertical">
                                <span class="td__title"><i class="icon icon-ewin-default-accountRolling icon-s icon-before"></i><span class="language_replace">最後登入時間</span></span>
                                <span class="td__content"><span class="LastLoginDate">CON4</span></span>
                            </div>
                            <div class="tbody__td td-number td-3 td-vertical">
                                <span class="td__title"><i class="icon icon-ewin-default-accountRolling icon-s icon-before"></i><span class="language_replace">建立時間</span></span>
                                <span class="td__content"><span class="CreateDate">CON4</span></span>
                            </div>
                        </div>
                    </div>
                    <!-- 標題項目  -->
                    <div class="thead">
                        <!--標題項目單行 -->
                        <div class="thead__tr">
                            <div class="thead__th"><span class="language_replace">帳號</span></div>
                            <div class="thead__th"><span class="language_replace">層級</span></div>
                            <div class="thead__th"><span class="language_replace">上線帳號</span></div>
                            <div class="thead__th"><span class="language_replace">貨幣</span></div>
                            <%--                            <div class="thead__th"><span class="language_replace">團隊代理數</span></div>
                            <div class="thead__th"><span class="language_replace">團隊會員數</span></div>
                            <div class="thead__th"><span class="language_replace">期間團隊新增下線數</span></div>
                            <div class="thead__th"><span class="language_replace">期間個人新增會員數</span></div>--%>
                            <div class="thead__th"><span class="language_replace">錢包餘額</span></div>
                            <div class="thead__th"><span class="language_replace">狀態</span></div>
                            <div class="thead__th"><span class="language_replace">最後登入時間</span></div>
                            <div class="thead__th"><span class="language_replace">建立時間</span></div>
                        </div>
                    </div>
                    <!-- 表格上下滑動框 -->
                    <div class="tbody" id="idList">
                    </div>
                         <div class="row" style="position: absolute;left:0;right:0;margin:0 auto;padding-top: 40px;">
                    <div class="col-12" id="btnShowNextData" style="display:none;">
                        <div class="form-group wrapper_center dataList-process">
                            <button style="max-width: 30%;" class="btn btn-full-main btn-roundcorner " onclick="showNextData()"><i class="icon icon-before icon-ewin-input-submit"></i><span class="language_replace">查看更多</span></button>
                        </div>
                    </div>
                    </div>
                </div>
            </div>
        </div>
    </main>
</body>
<script type="text/javascript">
    ac.listenScreenMove();

    function clickMask() {
        // document.getElementById("div_MaskSafariFix").style.display = "none";
        document.getElementById("div_MaskSafariFix").classList.remove("show");
    }
</script>
</html>
