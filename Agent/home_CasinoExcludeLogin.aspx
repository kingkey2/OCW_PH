<%@ Page Language="C#" AutoEventWireup="true" CodeFile="home_CasinoExcludeLogin.aspx.cs" Inherits="home_CasinoExcludeLogin" %>

<%
    string DefaultCompany = "";
    string DefaultCurrencyType = "";
    string AgentVersion = EWinWeb.AgentVersion;

    DefaultCompany = EWinWeb.CompanyCode;
    DefaultCurrencyType = EWinWeb.MainCurrencyType;
%>
<!doctype html>
<html lang="zh-Hant-TW" class="innerHtml">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <title>Home 測試頁</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="css/basic.min.css?<%=AgentVersion %>">
    <link rel="stylesheet" href="css/main2.css?<%=AgentVersion %>">
    <link rel="stylesheet" href="css/index.css?<%=AgentVersion %>">
    <style>
        .data {
            color: rgba(255, 238, 210, 0.8);
        }
    </style>
    <script type="text/javascript" src="/Scripts/Common.js"></script>
    <script type="text/javascript" src="/Scripts/bignumber.min.js"></script>
    <script type="text/javascript" src="/Scripts/Math.uuid.js"></script>
    <script type="text/javascript" src="Scripts/MultiLanguage.js"></script>
    <script type="text/javascript" src="js/jquery-3.3.1.min.js"></script>
    <script type="text/javascript" src="js/AgentAPI.js"></script>
    <script type="text/javascript" src="js/AgentCommon.js"></script>
    <script type="text/javascript" src="js/date.js"></script>
    <script type="text/javascript">
        var ApiUrl = "home_CasinoExcludeLogin.aspx";
        var c = new common();
        var ac = new AgentCommon();
        var mlp;
        var EWinInfo = null;
        var api;
        var lang;
        var parentLoginAccount = "";
        var startDate = Date.today().toString("yyyy-MM-dd");
        var endDate = Date.today().toString("yyyy-MM-dd");
        var DefaultCurrencyType = "<%=DefaultCurrencyType%>";
        var MsgText = " Group Profit - DownLine Total Profit = Pesonal Profit,<br/>"
            + " NGR * Share (at that time) = Group Profit,<br/>"
            + " Valid Bet * Rebate (at that time) = Group Profit,<br/>"
            + "<br/>"
            + "「Win/Loss」, 「NGR」, 「Valid Bet」 are group statistics.<br/>"
            + "<br/>"
            + "Numbers are trial calculations.<br/>"
            + "Don't represent final results.<br/>"
            + "They are for reference only.";

        function queryUserInfo(cb) {
            var idUserInfo = document.getElementById("idUserInfo");
            var idParentPath = document.getElementById("idParentPath");
            var idRealName = document.getElementById("idRealName");
            var idUserAccountType = document.getElementById("idUserAccountType");
            var idUserAccountState = document.getElementById("idUserAccountState");
            var idUserWalletInfo = document.getElementById("idUserWalletInfo");
            var LoginAccount = $('#loginAccount').val();
            var postData = {
                "LoginAccount": LoginAccount
            }

            c.callService(ApiUrl + "/QueryUserInfo", postData, function (success, obj) {
                if (success) {
                    var o = c.getJSON(obj);
                    if (o.Result == 0) {
                        idParentPath.innerHTML = LoginAccount;
                        idRealName.innerHTML = o.RealName;

                        userAccountType = o.UserAccountType;
                        switch (o.UserAccountType) {
                            case 0:
                                idUserAccountType.innerHTML = "會員";
                                break;
                            case 1:
                                idUserAccountType.innerHTML = "代理";
                                break;
                            case 2:
                                idUserAccountType.innerHTML = "股東";
                                break;
                        }

                        switch (o.UserAccountState) {
                            case 0:
                                idUserAccountState.innerHTML = "正常";
                                break;
                            case 1:
                                idUserAccountState.innerHTML = "停用";
                                break;
                            case 2:
                                idUserAccountState.innerHTML ="永久停用";
                                break;
                        }

                        // build wallet list
                        if (o.WalletList != null) {
                            $("#idUserWalletInfo").empty();
                            for (var i = 0; i < o.WalletList.length; i++) {
                                var temp = c.getTemplate("templateWalletInfo");
                                var w = o.WalletList[i];
                                if (w.CurrencyType != DefaultCurrencyType) {
                                    continue;
                                }

                                if (temp != null) {
                                    temp.classList.add("divCurrencyType");
                                    temp.setAttribute("CurrencyType", w.CurrencyType);

                                    c.setClassText(temp, "CurrencyType", null, w.CurrencyType);

                                    temp.getElementsByClassName("WalletBalance")[0].classList.remove("num-negative");
                                    if (parseFloat(w.PointValue) < 0) {
                                        temp.getElementsByClassName("WalletBalance")[0].classList.add("num-negative");
                                    }

                                    if (w.PointValue.toString().includes("e")) {
                                        c.setClassText(temp, "WalletBalance", null, BigNumber(roundDown(w.PointValue, 2)).toFormat());
                                    } else {
                                        c.setClassText(temp, "WalletBalance", null, Number(BigNumber(roundDown(w.PointValue, 2))));
                                    }

                                    templateRateInfo = c.getTemplate("templateRateInfo");
                                    c.setClassText(templateRateInfo, "UserRate", null, w.UserRate);
                                    c.setClassText(templateRateInfo, "BuyChipRate", null, w.BuyChipRate);

                                    templateRateInfo.setAttribute("itemtype", "eWinBAC");
                                    c.getFirstClassElement(temp, "divWalletList").appendChild(templateRateInfo);

                                    if (o.CompanyClassID != 0) {
                                        //階層
                                        templateRateInfo.getElementsByClassName("spanUserRate")[0].style.display = "none";
                                        templateRateInfo.getElementsByClassName("spanUserRate")[0].parentNode.classList.add("UserRate_hidden");
                                        templateRateInfo.getElementsByClassName("spanBuyChipRate")[0].style.display = "none";
                                        templateRateInfo.getElementsByClassName("spanBuyChipRate")[0].parentNode.classList.add("BuyChipRate_hidden");

                                    }

                                    //一般用戶
                                    if (o.UserAccountType == 0) {
                                        if (w.UserRate <= 0) {
                                            templateRateInfo.getElementsByClassName("spanUserRate")[0].style.display = "none";
                                            templateRateInfo.getElementsByClassName("spanUserRate")[0].parentNode.classList.add("UserRate_hidden");
                                        }

                                        if (w.BuyChipRate <= 0) {
                                            templateRateInfo.getElementsByClassName("spanBuyChipRate")[0].style.display = "none";
                                            templateRateInfo.getElementsByClassName("spanBuyChipRate")[0].parentNode.classList.add("BuyChipRate_hidden");
                                        }
                                    }

                                    mtWalletState = temp.getElementsByClassName("mtWalletState");
                                    switch (w.PointState) {
                                        case 0:
                                            c.setClassText(temp, "mtWalletState", null, mlp.getLanguageKey("正常"));
                                            mtWalletState[0].parentNode.classList.add("status-active");
                                            mtWalletState[0].parentNode.style.display = "none";
                                            break;
                                        case 1:
                                            c.setClassText(temp, "mtWalletState", null, mlp.getLanguageKey("停用"));
                                            mtWalletState[0].parentNode.classList.add("status-deactive");
                                            mtWalletState[0].parentNode.style.display = "";
                                            break;
                                    }

                                    if (o.CompanyClassID != 0) {
                                        //階層
                                        temp.getElementsByClassName("spanUserRate")[0].style.display = "none";
                                        temp.getElementsByClassName("spanUserRate")[0].parentNode.classList.add("UserRate_hidden");
                                        temp.getElementsByClassName("spanBuyChipRate")[0].style.display = "none";
                                        temp.getElementsByClassName("spanBuyChipRate")[0].parentNode.classList.add("BuyChipRate_hidden");

                                    }
                                    //一般用戶
                                    if (o.UserAccountType == 0) {
                                        if (w.UserRate <= 0) {
                                            temp.getElementsByClassName("spanUserRate")[0].style.display = "none";
                                            temp.getElementsByClassName("spanUserRate")[0].parentNode.classList.add("UserRate_hidden");
                                        }

                                        if (w.BuyChipRate <= 0) {
                                            temp.getElementsByClassName("spanBuyChipRate")[0].style.display = "none";

                                            temp.getElementsByClassName("spanBuyChipRate")[0].parentNode.classList.add("BuyChipRate_hidden");
                                        }
                                    }

                                    try {
                                        if (w.CurrencyType.toUpperCase() == DefaultCurrencyType.toUpperCase()) {
                                            //公司預設錢包會插在最上面
                                            idUserWalletInfo.insertAdjacentElement("afterbegin", temp);
                                        }
                                        else {
                                            idUserWalletInfo.appendChild(temp);
                                        }
                                    }
                                    catch (e) {

                                    }

                                }
                            }

                        }

                        if (o.GameCodeList != null) {
                            for (var l = 0; l < o.GameCodeList.length; l++) {
                                let kk = o.GameCodeList[l];
                                if (kk.CurrencyType == DefaultCurrencyType) {
                                    let t = c.getTemplate("tempGameAccountingCode");

                                    c.setClassText(t, "GameAccountingCode", null, mlp.getLanguageKey(kk.GameAccountingCode));
                                    c.setClassText(t, "UserRate", null, c.toCurrency(kk.UserRate));
                                    c.setClassText(t, "BuyChipRate", null, c.toCurrency(kk.BuyChipRate));

                                    $(".GameAccountingCodeList").append(t);
                                }
                            }

                            $('.btnOpen').click(function () {
                                $(".GameAccountingCodeList").show();
                            });

                            $('.btnClose').click(function () {
                                $(".GameAccountingCodeList").hide();
                            });
                        } else {
                            $('.btnOpen').hide();
                            $('.btnClose').hide();
                        }

                        if ($("#idUserWalletInfo .GameAccountingCodeList").children().length == 0) {
                            $('.btnOpen').hide();
                            $('.btnClose').hide();
                        }

                        queryAccountingData();

                        if (cb)
                            cb(true);
                    CloseLoading();
                    } else {
                        window.parent.API_ShowMessageOK(mlp.getLanguageKey("錯誤"), mlp.getLanguageKey(o.Message));

                        if (cb)
                            cb(false);
                    CloseLoading();
                    }
                } else {
                    if (o == "Timeout") {
                        window.parent.API_ShowMessageOK(mlp.getLanguageKey("錯誤"), mlp.getLanguageKey("網路異常, 請稍後重新嘗試"));
                    } else {
                        window.parent.API_ShowMessageOK(mlp.getLanguageKey("錯誤"), o);
                    }
                }

            });
        }
        //小數點後兩位無條件捨去
        function roundDown(num, decimal) {
            return Math.floor((num + Number.EPSILON) * Math.pow(10, decimal)) / Math.pow(10, decimal);
        }

        function callService(URL, postObject, cb) {
            var xmlHttp = new XMLHttpRequest;
            var postData;

            if (postObject)
                postData = JSON.stringify(postObject);

            xmlHttp.open("POST", URL, true);
            xmlHttp.onreadystatechange = function () {
                if (this.readyState == 4) {
                    var contentText = this.responseText;

                    if (this.status == "200") {
                        if (cb) {
                            cb(true, contentText);
                        }
                    } else {
                        cb(false, contentText);
                    }
                }
            };

            xmlHttp.timeout = 110000;  // 30s
            xmlHttp.ontimeout = function () {
                if (cb)
                    cb(false, "Timeout");
            };

            xmlHttp.setRequestHeader("Content-Type", "application/json; charset=utf-8");
            xmlHttp.send(postData);
        };

        function queryAccountingData() {
            var postData;
            $(".TotalValidBetValue").text(0);
            $(".TotalRewardValue").text(0);
            $(".UserRebate").text(0);
            $(".PaidOPValue").text(0);
            $(".TotalNGR").text(0);
            $(".ComissionValue").text(0);
            $(".TotalLineRebate").text(0);
            $(".TotalChildLineRebate").text(0);
            $(".TotalOrderCount").text(0);
            $(".NewUserCount").text(0);
            $(".WithdrawalValue").text(0);
            $(".WithdrawalCount").text(0);
            $(".DepositValue").text(0);
            $(".DepositCount").text(0);
            $(".FirstDepositValue").text(0);
            $(".FirstDepositCount").text(0);
            $(".RewardValue").text(0);
            $(".NotFirstDepositCount").text(0);
            $(".PreferentialCost").text(0);
            $(".FailureCondition").text("");
            $(".UserRebateUserRate").text(0);
            $(".UserRebateCommission").text(0);
            $(".TotalLineRebateUserRate").text(0);
            $(".TotalChildLineRebateUserRate").text(0);
            $(".TotalLineRebateCommission").text(0);
            $(".TotalChildLineRebateCommission").text(0);
            $(".ActiveUser").text(0);
            MsgText = " Group Profit - DownLine Total Profit = Pesonal Profit,<br/>"
            + " NGR * Share (at that time) = Group Profit,<br/>"
            + " Valid Bet * Rebate (at that time) = Group Profit,<br/>"
            + "<br/>"
            + "「Win/Loss」, 「NGR」, 「Valid Bet」 are group statistics.<br/>"
            + "<br/>"
            + "Numbers are trial calculations.<br/>"
            + "Don't represent final results.<br/>"
            + "They are for reference only.<br/>";
            var LoginAccount = $('#loginAccount').val();

            if (LoginAccount=='') {
                alert('尚未輸入帳號');
                return;
            }
            
            postData = {
                QueryBeginDate: startDate,
                QueryEndDate: endDate,
                CurrencyType: DefaultCurrencyType,
                LoginAccount: LoginAccount
            };
            
            ShowLoading();

            c.callService(ApiUrl + "/GetOrderSummary", postData, function (success, obj) {
                if (success) {
                    CloseLoading();
                    var o = c.getJSON(obj);

                    let TotalValidBetValue = 0;
                    let UserRebateUserRate = 0;
                    let TotalLineRebate = 0;
                    let TotalNGR = 0;
                    let PaidOPValue = 0;
                    let RewardValue = 0;
                    let PreferentialCost = 0;
                    let TotalOrderCount = 0;
                    let NewUserCount = 0;
                    let WithdrawalValue = 0;
                    let WithdrawalCount = 0;
                    let DepositValue = 0;
                    let DepositCount = 0;
                    let FirstDepositValue = 0;
                    let UserRebateCommission = 0;
                    let ActiveUser = 0;
                    let TotalLineRebateUserRate = 0;
                    let TotalLineRebateCommission = 0;

                    if (o.Result == 0) {
                        $(".FirstDepositCount").text(toCurrency(o.FirstDepositCount));
                        $(".NotFirstDepositCount").text(toCurrency(o.NextDepositCount));
                        if (o.CanReceiveUserRebateUserRate == 0) {
                            let strFailureCondition = "";

                            if (o.FailureCondition != null) {
                                if (o.FailureCondition.indexOf(";") > 0) {
                                    let FailureConditions = o.FailureCondition.split(";");

                                    for (var i = 0; i < FailureConditions.length; i++) {
                                        switch (FailureConditions[i]) {
                                            case "AgentMinActiveUserCount":
                                                strFailureCondition += " Valid members is less than " + o.AgentMinActiveUserCount + "; ";
                                                break;
                                            case "RebateAmountMin":
                                                strFailureCondition += " Personal Profit is less than " + toCurrency(o.RebateAmountMin) + "; ";
                                                break;
                                        }
                                    }
                                }
                            }

                            $(".FailureCondition").text(strFailureCondition);

                        }

                        MsgText += ` Minimum Available Personal Profit = ${toCurrency(o.RebateAmountMin)} <br/>`;
                        MsgText += ` Valid Member Count = ${o.AgentMinActiveUserCount} <br/>`;

                        if (o.AgentItemList.length > 0) {
                            for (var i = 0; i < o.AgentItemList.length; i++) {
                                let data = o.AgentItemList[i];
                                TotalValidBetValue = TotalValidBetValue + data.TotalValidBetValue;
                                UserRebateUserRate = UserRebateUserRate + data.UserRebateUserRate;
                                PaidOPValue = PaidOPValue + data.PaidOPValue;
                                TotalNGR = TotalNGR + data.TotalNGR;
                                UserRebateCommission = UserRebateCommission + data.UserRebateCommission;
                                RewardValue = RewardValue + data.TotalRewardValue;
                                PreferentialCost = PreferentialCost + data.BonusPointValue;
                                TotalOrderCount = TotalOrderCount + data.TotalOrderCount;
                                ActiveUser = ActiveUser + data.ActiveUser;
                                NewUserCount = NewUserCount + data.NewUserCount + data.NewAgentCount;
                                WithdrawalValue = WithdrawalValue + data.WithdrawalValue;
                                WithdrawalCount = WithdrawalCount + data.WithdrawalCount;
                                DepositValue = DepositValue + data.DepositValue;
                                DepositCount = DepositCount + data.DepositCount;
                                FirstDepositValue = FirstDepositValue + data.FirstDepositValue;
                                TotalLineRebateUserRate = TotalLineRebateUserRate + data.TotalLineRebateUserRate;
                                TotalLineRebateCommission = TotalLineRebateCommission + data.TotalLineRebateCommission;
                            }

                            $(".TotalValidBetValue").text(toCurrency(TotalValidBetValue));
                            $(".UserRebateUserRate").text(toCurrency(UserRebateUserRate));
                            $(".PaidOPValue").text(toCurrency(PaidOPValue));
                            $(".TotalNGR").text(toCurrency(TotalNGR));
                            $(".UserRebateCommission").text(toCurrency(UserRebateCommission));
                            $(".TotalLineRebateUserRate").text(toCurrency(TotalLineRebateUserRate));
                            $(".TotalChildLineRebateUserRate").text(toCurrency(TotalLineRebateUserRate - UserRebateUserRate));
                            $(".TotalLineRebateCommission").text(toCurrency(TotalLineRebateCommission));
                            $(".TotalChildLineRebateCommission").text(toCurrency(TotalLineRebateCommission - UserRebateCommission));
                            $(".TotalRewardValue").text(toCurrency(RewardValue));
                            $(".PreferentialCost").text(toCurrency(PreferentialCost));
                            $(".TotalOrderCount").text(toCurrency(TotalOrderCount));
                            $(".ActiveUser").text(toCurrency(ActiveUser));
                            $(".NewUserCount").text(toCurrency(NewUserCount));
                            $(".WithdrawalValue").text(toCurrency(WithdrawalValue));
                            $(".WithdrawalCount").text(toCurrency(WithdrawalCount));
                            $(".DepositValue").text(toCurrency(DepositValue));
                            $(".DepositCount").text(toCurrency(DepositCount));
                            $(".FirstDepositValue").text(toCurrency(FirstDepositValue));
                        }
                    } else {
                        window.parent.API_ShowMessageOK(mlp.getLanguageKey("錯誤"), mlp.getLanguageKey(obj.Message));
                    }
                } else {
                    CloseLoading();
                    if (o == "Timeout") {
                        window.parent.API_ShowMessageOK(mlp.getLanguageKey("錯誤"), mlp.getLanguageKey("網路異常, 請稍後重新嘗試"));
                    } else {
                        window.parent.API_ShowMessageOK(mlp.getLanguageKey("錯誤"), o);
                    }
                }

            });

        }

        function ShowLoading(showText) {
            var idShowLoading = document.getElementById("idShowLoading");

            if (showText == "" || showText == null) {
                showText = "Loading";
            }
            document.getElementsByClassName("loading_text")[0].innerText = showText;
            c.addClassName(idShowLoading, "show");
        }

        function CloseLoading() {
            var idShowLoading = document.getElementById("idShowLoading");

            c.removeClassName(idShowLoading, "show");
        }

        function getChildUserData() {
            var postData;
            var LoginAccount = $('#loginAccount').val();

            postData = {
                LoginAccount: LoginAccount
            };

            c.callService(ApiUrl + "/GetChildUserData", postData, function (success, obj) {
                if (success) {
                    var o = c.getJSON(obj);
                    if (o.Result == 0) {
                        $(".AgentCount").text(toCurrency(o.AgentCount));
                        $(".AgentCount_Under").text(toCurrency(o.AgentCount_Under));
                        $(".AgentCount_Other").text(toCurrency(o.AgentCount - o.AgentCount_Under));
                        $(".UserCount").text(toCurrency(o.UserCount));
                        $(".UserCount_Under").text(toCurrency(o.UserCount_Under));
                        $(".UserCount_Other").text(toCurrency(o.UserCount - o.UserCount_Under));
                    }
                } else {
                    if (o == "Timeout") {
                        window.parent.API_ShowMessageOK(mlp.getLanguageKey("錯誤"), mlp.getLanguageKey("網路異常, 請稍後重新嘗試"));
                    } else {
                        window.parent.API_ShowMessageOK(mlp.getLanguageKey("錯誤"), o);
                    }
                }

            });

        CloseLoading();
        }

        function changeDateTab(e, type) {
            window.event.stopPropagation();
            window.event.preventDefault();

            var tabMainContent = document.getElementById("idTabMainContent");
            var tabItem = tabMainContent.getElementsByClassName("nav-link");
            for (var i = 0; i < tabItem.length; i++) {
                tabItem[i].classList.remove('active');
                tabItem[i].parentNode.classList.remove('active');

                tabItem[i].setAttribute("aria-selected", "false");

            }

            e.parentNode.classList.add('active');
            e.classList.add('active');
            e.setAttribute("aria-selected", "true");
            switch (type) {
                case 0:
                    startDate = Date.today().toString("yyyy-MM-dd");
                    endDate = Date.today().toString("yyyy-MM-dd");
                    queryAccountingData();
                    break;
                case 1:
                    startDate = Date.today().addDays(-1).toString("yyyy-MM-dd");
                    endDate = Date.today().addDays(-1).toString("yyyy-MM-dd");
                    queryAccountingData();
                    break;
                case 2:
                    startDate = getFirstDayOfWeek(Date.today()).toString("yyyy-MM-dd");
                    endDate = getLastDayOfWeek(Date.today()).toString("yyyy-MM-dd");
                    queryAccountingData();
                    break;
                case 3:
                    startDate = getFirstDayOfWeek(Date.today().addDays(-7)).toString("yyyy-MM-dd");
                    endDate = getLastDayOfWeek(Date.today().addDays(-7)).toString("yyyy-MM-dd");
                    queryAccountingData();
                    break;
                case 4:
                    startDate = Date.today().moveToFirstDayOfMonth().toString("yyyy-MM-dd");
                    endDate = Date.today().moveToLastDayOfMonth().toString("yyyy-MM-dd");
                    queryAccountingData();
                    break;
                case 5:
                    startDate = Date.today().addMonths(-1).moveToFirstDayOfMonth().toString("yyyy-MM-dd");
                    endDate = Date.today().addMonths(-1).moveToLastDayOfMonth().toString("yyyy-MM-dd");
                    queryAccountingData();
                    break;
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

        function toCurrency(num) {

            num = parseFloat(Number(num).toFixed(2));
            var parts = num.toString().split('.');
            parts[0] = parts[0].replace(/\B(?=(\d{3})+(?!\d))/g, ',');
            return parts.join('.');
        }

        function searchBtn() {
            var LoginAccount = $('#loginAccount').val();

            if (LoginAccount.trim() == '') {
                alert("尚未輸入帳號");
                return;
            }

            queryUserInfo();
            getChildUserData();
        }

        function init() {
            lang = window.localStorage.getItem("agent_lang");
            mlp = new multiLanguage();
            mlp.loadLanguage(lang, function () {
        
            });
        }

        function API_ShowMessageOK(title,message) {
            alert(title + "," + message);
        }

        window.onload = init;
    </script>
</head>
<body class="innerBody" style="background-color:darkslategrey;">
    <main>
        <div class="loginUserInfo">
            <div class="container-fluid">
                <div id="idParentPath" class="loginUserInfo__accountID heading-1">--</div>
                <div class="row">
                    <div class="col-6 col-sm-6 col-md-auto col-lg-auto">
                        <div class="loginUserInfo__accountRole">
                            <span class="title-s"><span><span class="language_replace">類型</span>:</span></span>
                            <span id="idUserAccountType" class="data">--</span>
                        </div>
                    </div>
                    <div class="col-6 col-sm-6 col-md-auto col-lg-auto">
                        <div class="loginUserInfo__accountStatus">
                            <span class="item">
                                <span class="title-s"><span><span class="language_replace">狀態</span>:</span></span>
                                <span id="idUserAccountState" class="data">--</span>
                            </span>
                        </div>
                    </div>
                    <div class="col-12 col-md-auto col-lg-auto">
                        <div class="loginUserInfo__accountName">
                            <span class="title-s"><span><span class="language_replace">姓名</span>:</span></span>
                            <span id="idRealName" class="data">--</span>
                        </div>
                    </div>
                </div>

            </div>
        </div>

        <div id="WrapperFilterGame_Home" class="fixed Filter__Wrapper">
            <div class="container-fluid ">
                  <div id="idSearchButton" class="col-12 col-md-6 col-lg-4 col-xl-auto">
                        <div class="form-group form-group-s2 ">
                            <div class="title hidden shown-md"><span class="language_replace">帳號</span></div>
                            <div class="input-group form-control-underline iconCheckAnim placeholder-move-right zIndex_overMask_SafariFix">
                                <input type="text" class="form-control" id="loginAccount" value="">
                                <div class="input-group-append">
                                    <span onclick="searchBtn()" class="input-group-text language_replace" style="cursor: pointer; color: #C9AE7F; background-color: #2d3244; border: none">搜尋</span>
                                </div>
                            </div>

                        </div>
                    </div>
                <div class="row">
                    <div id="idTabMainContent" class="tab__Wrapper col-12 col-md">
                        <ul class="nav-tabs-block nav nav-tabs tab-items-6" role="tablist">
                            <li class="nav-item active">
                                <a onclick="changeDateTab(this,0)" class="nav-link active language_replace" data-toggle="tab" href="" role="tab" aria-selected="true">本日</a>
                            </li>
                            <li class="nav-item">
                                <a onclick="changeDateTab(this,1)" class="nav-link language_replace" data-toggle="tab" href="" role="tab" aria-selected="true">昨天</a>
                            </li>
                            <li class="nav-item">
                                <a onclick="changeDateTab(this,2)" class="nav-link language_replace" data-toggle="tab" href="" role="tab" aria-selected="true">本週</a>
                            </li>
                            <li class="nav-item">
                                <a onclick="changeDateTab(this,3)" class="nav-link language_replace" data-toggle="tab" href="" role="tab" aria-selected="true">上週</a>
                            </li>
                            <li class="nav-item">
                                <a onclick="changeDateTab(this,4)" class="nav-link language_replace" data-toggle="tab" href="" role="tab" aria-selected="true">本月</a>
                            </li>
                            <li class="nav-item">
                                <a onclick="changeDateTab(this,5)" class="nav-link language_replace" data-toggle="tab" href="" role="tab" aria-selected="true">上月</a>
                            </li>
                            <li class="tab-slide"></li>
                        </ul>
                    </div>
                </div>
            </div>
        </div>

        <div class="currencyWalletList" style="margin-top: 5px">
            <div class="container-fluid">
                <div id="idUserInfo" class="row">


                    <div class="col-12 col-md-12 col-lg-6 col-gx-6 col-xl-6">
                        <div class="item">
                            <div class="currencyWallet__type">
                                <div class="wallet__type">
                                    <span class="currency language_replace">Personal Profit</span><btn style="font-size: 10px; /* right: 5px; */position: absolute; border: 2px solid; width: 20px; text-align: center; border-radius: 10px; color: #bba480; cursor: pointer; margin-left: 5px;" onclick="showCalcMsg()">!</btn>
                                </div>
                                <div class="settleAccount__type" style="">
                                    <span class="language_replace UserRebateUserRate data">0</span>
                                </div>
                            </div>
                            <div class="wrapper_revenueAmount">
                                <div class="detailItem">
                                    <span class="title-s"><span class="language_replace"></span></span>
                                    <span class="data FailureCondition" style="color: #FF4D00"></span>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="col-12 col-md-12 col-lg-6 col-gx-6 col-xl-6">
                        <div class="item">
                            <div class="currencyWallet__type">
                                <div class="wallet__type">
                                    <span class="currency language_replace">返水佣金</span>
                                </div>
                                <div class="settleAccount__type" style="">
                                    <span class="language_replace UserRebateCommission data">0</span>
                                </div>
                            </div>
                            <div class="wrapper_revenueAmount">
                                <div class="detailItem">
                                    <span class="title-s"><span class="language_replace"></span></span>
                                    <span class="data"></span>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-12 col-md-6 col-lg-4 col-gx-3 col-xl-3">
                        <div class="item">
                            <div class="currencyWallet__type">
                                <div class="wallet__type">
                                    <span class="currency language_replace">總線佔成佣金</span>
                                </div>
                                <div class="settleAccount__type" style="">
                                    <span class="language_replace TotalLineRebateUserRate data">0</span>
                                </div>
                            </div>
                            <div class="wrapper_revenueAmount">
                                <div class="detailItem">
                                    <span class="title-s"><span class="language_replace"></span></span>
                                    <span class="data"></span>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-12 col-md-6 col-lg-4 col-gx-3 col-xl-3">
                        <div class="item">
                            <div class="currencyWallet__type">
                                <div class="wallet__type">
                                    <span class="currency language_replace">下線總線佔成佣金總計</span>
                                </div>
                                <div class="settleAccount__type" style="">
                                    <span class="language_replace TotalChildLineRebateUserRate data">0</span>
                                </div>
                            </div>
                            <div class="wrapper_revenueAmount">
                                <div class="detailItem">
                                    <span class="title-s"><span class="language_replace"></span></span>
                                    <span class="data"></span>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-12 col-md-6 col-lg-4 col-gx-3 col-xl-3">
                        <div class="item">
                            <div class="currencyWallet__type">
                                <div class="wallet__type">
                                    <span class="currency language_replace">總線返水佣金</span>
                                </div>
                                <div class="settleAccount__type" style="">
                                    <span class="language_replace TotalLineRebateCommission data">0</span>
                                </div>
                            </div>
                            <div class="wrapper_revenueAmount">
                                <div class="detailItem">
                                    <span class="title-s"><span class="language_replace"></span></span>
                                    <span class="data"></span>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-12 col-md-6 col-lg-4 col-gx-3 col-xl-3">
                        <div class="item">
                            <div class="currencyWallet__type">
                                <div class="wallet__type">
                                    <span class="currency language_replace">下線總線返水佣金總計</span>
                                </div>
                                <div class="settleAccount__type" style="">
                                    <span class="language_replace TotalChildLineRebateCommission data">0</span>
                                </div>
                            </div>
                            <div class="wrapper_revenueAmount">
                                <div class="detailItem">
                                    <span class="title-s"><span class="language_replace"></span></span>
                                    <span class="data"></span>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-12 col-md-6 col-lg-4 col-gx-3 col-xl-3">
                        <div class="item">
                            <div class="currencyWallet__type">
                                <div class="wallet__type">
                                    <span class="currency language_replace">會員輸贏</span>
                                </div>
                                <div class="settleAccount__type" style="">
                                    <span class="language_replace TotalRewardValue data">0</span>
                                </div>
                            </div>
                            <div class="wrapper_revenueAmount">
                                <div class="detailItem">
                                    <span class="title-s"><span class="language_replace"></span></span>
                                    <span class="data"></span>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-12 col-md-6 col-lg-4 col-gx-3 col-xl-3">
                        <div class="item">
                            <div class="currencyWallet__type">
                                <div class="wallet__type">
                                    <span class="currency language_replace">有效投注</span>
                                </div>
                                <div class="settleAccount__type" style="">
                                    <span class="language_replace TotalValidBetValue data">0</span>
                                </div>
                            </div>
                            <div class="wrapper_revenueAmount">
                                <div class="detailItem">
                                    <span class="title-s"><span class="language_replace"></span></span>
                                    <span class="data"></span>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-12 col-md-6 col-lg-4 col-gx-3 col-xl-3">
                        <div class="item">
                            <div class="currencyWallet__type">
                                <div class="wallet__type">
                                    <span class="currency language_replace">新用戶數</span>
                                </div>
                                <div class="settleAccount__type" style="">
                                    <span class="language_replace NewUserCount data">0</span>
                                </div>
                            </div>
                            <div class="wrapper_revenueAmount">
                                <div class="detailItem">
                                    <span class="title-s"><span class="language_replace"></span></span>
                                    <span class="data"></span>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-12 col-md-6 col-lg-4 col-gx-3 col-xl-3">
                        <div class="item">
                            <div class="currencyWallet__type">
                                <div class="wallet__type">
                                    <span class="currency language_replace">提現金額</span>
                                </div>
                                <div class="settleAccount__type" style="">
                                    <span class="language_replace WithdrawalValue data">0</span>
                                </div>
                            </div>
                            <div class="wrapper_revenueAmount">
                                <%--<div class="detailItem" style="width: 50%; display: inline-block;">
                                    <span class="title-s"><span class="language_replace">人數</span></span>
                                    <span class="data rewardValue">9999</span>
                                </div>
                                <div class="detailItem" style="width: 50%; display: inline-block; float: left">
                                    <span class="title-s"><span class="language_replace">筆數</span></span>
                                    <span class="data validBetValue WithdrawalCount">0</span>
                                </div>--%>
                                <div class="detailItem">
                                    <span class="title-s"><span class="language_replace">筆數</span></span>
                                    <span class="data WithdrawalCount">0</span>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-12 col-md-6 col-lg-4 col-gx-3 col-xl-3">
                        <div class="item">
                            <div class="currencyWallet__type">
                                <div class="wallet__type">
                                    <span class="currency language_replace">優惠成本</span>
                                </div>
                                <div class="settleAccount__type" style="">
                                    <span class="language_replace PreferentialCost data">0</span>
                                </div>
                            </div>
                            <div class="wrapper_revenueAmount">
                                <div class="detailItem">
                                    <span class="title-s"><span class="language_replace"></span></span>
                                    <span class="data"></span>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-12 col-md-6 col-lg-4 col-gx-3 col-xl-3">
                        <div class="item">
                            <div class="currencyWallet__type">
                                <div class="wallet__type">
                                    <span class="currency language_replace">淨收益 NGR</span>
                                </div>
                                <div class="settleAccount__type" style="">
                                    <span class="language_replace TotalNGR data">0</span>
                                </div>
                            </div>
                            <div class="wrapper_revenueAmount">
                                <div class="detailItem">
                                    <span class="title-s"><span class="language_replace"></span></span>
                                    <span class="data"></span>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-12 col-md-6 col-lg-4 col-gx-3 col-xl-3">
                        <div class="item">
                            <div class="currencyWallet__type">
                                <div class="wallet__type">
                                    <span class="currency language_replace">首存人數</span>
                                </div>
                                <div class="settleAccount__type" style="">
                                    <span class="language_replace FirstDepositCount data">0</span>
                                </div>
                            </div>
                            <div class="wrapper_revenueAmount">
                                <div class="detailItem">
                                    <span class="title-s"><span class="language_replace"></span></span>
                                    <span class="data"></span>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-12 col-md-6 col-lg-4 col-gx-3 col-xl-3">
                        <div class="item">
                            <div class="currencyWallet__type">
                                <div class="wallet__type">
                                    <span class="currency language_replace">複存人數</span>
                                </div>
                                <div class="settleAccount__type" style="">
                                    <span class="language_replace NotFirstDepositCount data">0</span>
                                </div>
                            </div>
                            <div class="wrapper_revenueAmount">
                                <div class="detailItem">
                                    <span class="title-s"><span class="language_replace"></span></span>
                                    <span class="data"></span>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-12 col-md-6 col-lg-4 col-gx-3 col-xl-3">
                        <div class="item">
                            <div class="currencyWallet__type">
                                <div class="wallet__type">
                                    <span class="currency language_replace">投注筆數</span>
                                </div>
                                <div class="settleAccount__type" style="">
                                    <span class="language_replace TotalOrderCount data">0</span>
                                </div>
                            </div>
                            <div class="wrapper_revenueAmount">
                                <div class="detailItem">
                                    <span class="title-s"><span class="language_replace"></span></span>
                                    <span class="data"></span>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-12 col-md-6 col-lg-4 col-gx-3 col-xl-3">
                        <div class="item">
                            <div class="currencyWallet__type">
                                <div class="wallet__type">
                                    <span class="currency language_replace">有效會員數</span>
                                </div>
                                <div class="settleAccount__type" style="">
                                    <span class="language_replace ActiveUser data">0</span>
                                </div>
                            </div>
                            <div class="wrapper_revenueAmount">
                                <div class="detailItem">
                                    <span class="title-s"><span class="language_replace"></span></span>
                                    <span class="data"></span>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-12 col-md-6 col-lg-4 col-gx-3 col-xl-3">
                        <div class="item">
                            <div class="currencyWallet__type">
                                <div class="wallet__type">
                                    <span class="currency language_replace">首存金額</span>
                                </div>
                                <div class="settleAccount__type" style="">
                                    <span class="language_replace FirstDepositValue data">0</span>
                                </div>
                            </div>
                            <div class="wrapper_revenueAmount">
                                <div class="detailItem">
                                    <span class="title-s"><span class="language_replace">筆數</span></span>
                                    <span class="data FirstDepositCount">0</span>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-12 col-md-6 col-lg-4 col-gx-3 col-xl-3">
                        <div class="item">
                            <div class="currencyWallet__type">
                                <div class="wallet__type">
                                    <span class="currency language_replace">充值金額</span>
                                </div>
                                <div class="settleAccount__type" style="">
                                    <span class="language_replace DepositValue data">0</span>
                                </div>
                            </div>
                            <div class="wrapper_revenueAmount">
                                <div class="detailItem">
                                    <span class="title-s"><span class="language_replace">筆數</span></span>
                                    <span class="data DepositCount">0</span>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-12 col-md-6 col-lg-4 col-gx-3 col-xl-3" style="display:none">
                        <div class="item">
                            <div class="currencyWallet__type">
                                <div class="wallet__type">
                                    <span class="currency language_replace">已付佣金</span>
                                </div>
                                <div class="settleAccount__type" style="">
                                    <span class="language_replace PaidOPValue data">0</span>
                                </div>
                            </div>
                            <div class="wrapper_revenueAmount">
                                <div class="detailItem">
                                    <span class="title-s"><span class="language_replace"></span></span>
                                    <span class="data"></span>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-12 col-md-6 col-lg-4 col-gx-3 col-xl-3" style="display:none">
                        <div class="item">
                            <div class="currencyWallet__type">
                                <div class="wallet__type">
                                    <span class="currency language_replace">最低派發佣金</span>
                                </div>
                                <div class="settleAccount__type" style="">
                                    <span class="language_replace RebateAmountMin data">0</span>
                                </div>
                            </div>
                            <div class="wrapper_revenueAmount">
                                <div class="detailItem">
                                    <span class="title-s"><span class="language_replace"></span></span>
                                    <span class="data "></span>
                                </div>
                            </div>
                        </div>
                    </div>


                    <div class="col-6 col-md-6 col-lg-6 col-gx-6 col-xl-6" style="display: none">
                        <div class="item">
                            <div class="currencyWallet__type">
                                <div class="wallet__type">
                                    <span class="currency language_replace">總返水</span>
                                </div>
                                <div class="settleAccount__type" style="">
                                    <span class="language_replace data">0</span>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="col-12 col-md-6 col-lg-4 col-gx-3 col-xl-3" style="display: none">
                        <div class="item">
                            <div class="currencyWallet__type">
                                <div class="wallet__type">
                                    <span class="currency language_replace">總佔成</span>
                                </div>
                                <div class="settleAccount__type" style="">
                                    <span class="language_replace data ">0</span>
                                </div>
                            </div>
                        </div>
                    </div>

                </div>
            </div>
        </div>

        <div class="currencyWalletList" style="margin-top: 20px">
            <div class="container-fluid">
                <div class="row">
                    <div class="col-12 col-md-12 col-lg-6 col-gx-6 col-xl-6">
                        <div id="idUserWalletInfo">
                        </div>
                        <div class="row">
                            <div class="col-12 col-md-6 col-lg-6 col-gx-6 col-xl-6">
                                <div>
                                    <div class="item">
                                        <div class="currencyWallet__type">
                                            <div class="wallet__type">
                                                <span class="currency CurrencyType language_replace">代理</span>
                                            </div>
                                        </div>
                                        <div class="currencyWallet__currencyFocus" style="border-bottom: none">
                                            <div class="balance1">
                                                <span class="title-s"><span class="language_replace">總數</span></span>
                                                <span class="data AgentCount">0</span>
                                            </div>
                                            <div class="balance1">
                                                <span class="title-s"><span class="language_replace">直屬</span></span>
                                                <span class="data AgentCount_Under">0</span>
                                            </div>
                                            <div class="balance1">
                                                <span class="title-s"><span class="language_replace">下線</span></span>
                                                <span class="data AgentCount_Other">0</span>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="col-12 col-md-6 col-lg-6 col-gx-6 col-xl-6">
                                <div>
                                    <div class="item">
                                        <div class="currencyWallet__type">
                                            <div class="wallet__type">
                                                <span class="currency CurrencyType language_replace">會員</span>
                                            </div>
                                        </div>
                                        <div class="currencyWallet__currencyFocus" style="border-bottom: none">
                                            <div class="balance1">
                                                <span class="title-s"><span class="language_replace">總數</span></span>
                                                <span class="data UserCount">0</span>
                                            </div>
                                            <div class="balance1">
                                                <span class="title-s"><span class="language_replace">直屬</span></span>
                                                <span class="data UserCount_Under">0</span>
                                            </div>
                                            <div class="balance1">
                                                <span class="title-s"><span class="language_replace">下線</span></span>
                                                <span class="data UserCount_Other">0</span>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="col-12 col-md-12 col-lg-6 col-gx-6 col-xl-6 GameAccountingCodeList">
                    </div>

                </div>
            </div>
        </div>

        <div id="templateWalletInfo" style="display: none">
            <div>
                <div class="currencyWallet__type">
                    <div class="wallet__type">
                        <span class="title"><i class="icon icon2020-ico-coin-o"></i><span class="language_replace"></span></span>
                        <span class="currency CurrencyType">CNY</span>
                    </div>
                    <!-- 錢包啟用 狀態加入 class="status-active" -->
                    <div class="wallet__status status-active" style="display: none">
                        <i class="icon icon-ewin-default-walletStatus"></i>
                        <span class="language_replace mtWalletState">啟用</span>
                    </div>
                </div>
                <div class="currencyWallet__currencyFocus divWalletList">
                    <div class="balance1">
                        <span class="title-s"><span class="language_replace">可用餘額</span></span>
                        <span class="data WalletBalance">0</span>
                    </div>
                </div>
            </div>
        </div>

        <div id="templateRateInfo" style="display: none">
            <div class="balance1">
                <span class="share spanUserRate">
                    <span class="title-s"><span class="language_replace">佔成率</span></span>
                    <span class="data"><span class="data UserRate">0</span>%</span>
                </span>
                <span class="commission spanBuyChipRate">
                    <span class="title-s"><span class="language_replace">轉碼率</span></span>
                    <span class="data"><span class="data BuyChipRate">0</span>%</span>
                </span>
            </div>
        </div>

        <div id="tempGameAccountingCode" style="display: none">
            <div class="downline__currencyDetail" style="border-bottom: solid 1px rgba(227, 195, 141, 0.15); width: 98%; float: left; padding-left: 10px">

                <div class="currencyWallet__type">
                    <div class="wallet__type">
                        <span class="currency GameAccountingCode language_replace"></span>
                    </div>
                </div>

                <div class="detailItem">
                    <span class="title-s">
                        <i class="icon icon-ewin-default-periodWinLose icon-s icon-before"></i>
                        <span class="language_replace">佔成率</span>
                    </span>
                    <span class="title-s" style="float: right">
                        <span class="data UserRate">0</span>
                        <span style="color: rgba(200, 219, 234, 0.8);">%</span>
                    </span>
                </div>
                <div class="detailItem">
                    <span class="title-s">
                        <i class="icon icon-ewin-default-periodRolling icon-s icon-before"></i>
                        <span class="language_replace">轉碼率</span>
                    </span>
                    <span class="title-s" style="float: right">
                        <span class="data BuyChipRate">0</span>
                        <span style="color: rgba(200, 219, 234, 0.8);">%</span>
                    </span>
                </div>
            </div>
        </div>

    </main>
        <!-- Loading PopUp 要放在 message 及 toast 前面  -->
    <div class="popUp loading" id="idShowLoading">
        <div class="global__loading">
            <!-- <div class="logo"><img src="Images/theme/dark/img/logo_eWin.svg" alt=""></div> -->
            <div class="gooey">
                <span class="dot"></span>
                <div class="dots">
                    <span></span>
                    <span></span>
                    <span></span>
                </div>
            </div>
            <div class="loading_text">Loading</div>
        </div>
        <div id="mask_overlay_popup" class="mask_overlay_popup mask_overlay_loading"></div>
    </div>
</body>
</html>
