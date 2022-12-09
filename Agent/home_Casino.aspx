<%@ Page Language="C#" AutoEventWireup="true" CodeFile="home_Casino.aspx.cs" Inherits="home_Casino" %>

<%
    string ASID = Request["ASID"];
    string DefaultCompany = "";
    string DefaultCurrencyType = "";
    int UserAccountID = 0;
    string Version = EWinWeb.Version;
    EWin.SpriteAgent.SpriteAgent api = new EWin.SpriteAgent.SpriteAgent();
    EWin.SpriteAgent.AgentSessionResult ASR = null;
    EWin.SpriteAgent.AgentSessionInfo ASI = null;

    ASR = api.GetAgentSessionByID(ASID);

    if (ASR.Result != EWin.SpriteAgent.enumResult.OK) {
        if (string.IsNullOrEmpty(DefaultCompany) == false) {
            Response.Redirect("login.aspx?C=" + DefaultCompany);
        } else {
            Response.Redirect("login.aspx");
        }
    } else {
        ASI = ASR.AgentSessionInfo;
        DefaultCompany = EWinWeb.CompanyCode;
        DefaultCurrencyType = EWinWeb.MainCurrencyType;
        UserAccountID = ASI.UserAccountID;
    }

%>
<!doctype html>
<html lang="zh-Hant-TW" class="innerHtml">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <title>代理網</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="css/basic.min.css?<%=Version %>">
    <link rel="stylesheet" href="css/main.css?<%=Version %>">
    <link rel="stylesheet" href="css/index.css?<%=Version %>">
    <link rel="stylesheet" href="css/config/config_<%=DefaultCompany %>.css?<%=Version %>">
    <script type="text/javascript" src="/Scripts/Common.js"></script>
    <script type="text/javascript" src="/Scripts/bignumber.min.js"></script>
    <script type="text/javascript" src="/Scripts/Math.uuid.js"></script>
    <script type="text/javascript" src="Scripts/MultiLanguage.js"></script>
    <script type="text/javascript" src="js/jquery-3.3.1.min.js"></script>
    <script type="text/javascript" src="js/AgentAPI.js"></script>
    <script type="text/javascript" src="js/AgentCommon.js"></script>
    <script type="text/javascript" src="js/date.js"></script>
    <script type="text/javascript">
        var ApiUrl = "home_Casino.aspx";
        var c = new common();
        var ac = new AgentCommon();
        var mlp;
        var EWinInfo = null;
        var api;
        var lang;
        var parentLoginAccount = "";
        var startDate = Date.today().toString("yyyy-MM-dd");
        var endDate = Date.today().toString("yyyy-MM-dd");
        var UserAccountID = "<%=UserAccountID%>";
        var DefaultCurrencyType = "<%=DefaultCurrencyType%>";

        function queryUserInfo(cb) {
            var idUserInfo = document.getElementById("idUserInfo");
            var idParentPath = document.getElementById("idParentPath");
            var idRealName = document.getElementById("idRealName");
            var idUserAccountType = document.getElementById("idUserAccountType");
            var idUserAccountState = document.getElementById("idUserAccountState");
            var idUserWalletInfo = document.getElementById("idUserWalletInfo");

            api.QueryUserInfo(EWinInfo.ASID, Math.uuid(), function (success, o) {
                if (success) {
                    if (o.ResultState == 0) {

                        idParentPath.innerHTML = EWinInfo.LoginAccount;
                        idRealName.innerHTML = o.RealName;

                        userAccountType = o.UserAccountType;
                        switch (o.UserAccountType) {
                            case 0:
                                idUserAccountType.innerHTML = mlp.getLanguageKey("會員");
                                break;
                            case 1:
                                idUserAccountType.innerHTML = mlp.getLanguageKey("代理");
                                break;
                            case 2:
                                idUserAccountType.innerHTML = mlp.getLanguageKey("股東");
                                break;
                        }

                        switch (o.UserAccountState) {
                            case 0:
                                idUserAccountState.innerHTML = mlp.getLanguageKey("正常");
                                break;
                            case 1:
                                idUserAccountState.innerHTML = mlp.getLanguageKey("停用");
                                break;
                            case 2:
                                idUserAccountState.innerHTML = mlp.getLanguageKey("永久停用");
                                break;
                        }


                        // build wallet list
                        if (o.WalletList != null) {
                            $("#idUserWalletInfo").empty();
                            for (var i = 0; i < o.WalletList.length; i++) {
                                var temp = c.getTemplate("templateWalletInfo");
                                var w = o.WalletList[i];
                                if (w.CurrencyType != EWinInfo.MainCurrencyType) {
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
                                        c.setClassText(temp, "WalletBalance", null, BigNumber(w.PointValue).toFormat());
                                    } else {
                                        c.setClassText(temp, "WalletBalance", null, Number(BigNumber(w.PointValue).toFixed(12)));
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
                                        if (w.CurrencyType.toUpperCase() ==  EWinInfo.MainCurrencyType.toUpperCase()) {
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

                        queryAccountingData();

                        if (cb)
                            cb(true);
                        window.parent.API_CloseLoading();
                    } else {
                        window.parent.API_ShowMessageOK(mlp.getLanguageKey("錯誤"), mlp.getLanguageKey(o.Message));

                        if (cb)
                            cb(false);
                        window.parent.API_CloseLoading();
                    }
                } else {
                    if (o == "Timeout") {
                        window.parent.API_ShowMessageOK(mlp.getLanguageKey("錯誤"), mlp.getLanguageKey("網路異常, 請稍後再嘗試"));
                    } else {
                        window.parent.API_ShowMessageOK(mlp.getLanguageKey("錯誤"), mlp.getLanguageKey(o));
                    }

                    if (cb) {
                        cb(false);
                    }
                    window.parent.API_CloseLoading();
                }
            });
        }

        function queryAccountingData() {
            var postData;
            $(".TotalValidBetValue").text(0);
            $(".RewardValue").text(0);
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
            
            postData = {
                AID: EWinInfo.ASID,
                QueryBeginDate: startDate,
                QueryEndDate: endDate,
                CurrencyType: DefaultCurrencyType
            };

            window.parent.API_ShowLoading();

            c.callService(ApiUrl + "/GetOrderSummary", postData, function (success, obj) {
                if (success) {
                    var o = c.getJSON(obj);

                    if (o.Result == 0) {
                        if (o.AgentItemList.length > 0) {
                            let data = o.AgentItemList[0].Summary;
                            $(".TotalValidBetValue").text(toCurrency(data.TotalValidBetValue));
                            $(".UserRebate").text(toCurrency(data.UserRebate));
                            $(".RewardValue").text(toCurrency(data.TotalRewardValue - data.SelfRewardValue));
                            $(".PreferentialCost").text(toCurrency(data.BonusPointValue + data.CostValue));
                            $(".TotalOrderCount").text(toCurrency(data.TotalOrderCount));
                            if (data.NewUserCount > 0) {
                                $(".NewUserCount").text(toCurrency(data.NewUserCount - 1));
                            } else {
                                $(".NewUserCount").text(0);
                            }
                            $(".WithdrawalValue").text(toCurrency(data.WithdrawalValue));
                            $(".WithdrawalCount").text(toCurrency(data.WithdrawalCount));
                            $(".DepositValue").text(toCurrency(data.DepositValue));
                            $(".DepositCount").text(toCurrency(data.DepositCount));
                            $(".FirstDepositValue").text(toCurrency(data.FirstDepositValue));
                            $(".FirstDepositCount").text(toCurrency(data.FirstDepositCount));
                            $(".NotFirstDepositCount").text(toCurrency(data.DepositCount - data.FirstDepositCount));
                        }
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

            });

            window.parent.API_CloseLoading();
        }

        function getChildUserData() {
            var postData;

            postData = {
                AID: EWinInfo.ASID
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

            window.parent.API_CloseLoading();
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

        function init() {
            EWinInfo = window.parent.EWinInfo;
            if (EWinInfo) {
                api = window.parent.API_GetAgentAPI();

                lang = window.localStorage.getItem("agent_lang");
                mlp = new multiLanguage();
                mlp.loadLanguage(lang, function () {
                    queryUserInfo();
                    getChildUserData();
                });
            }
        }

        window.onload = init;

    </script>
</head>
<body class="innerBody">
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

        <div class="currencyWalletList">
            <div class="container-fluid">
                <div id="idUserWalletInfo" class="row">
                </div>
            </div>
        </div>

        <div class="currencyWalletList" >
            <div class="container-fluid">
                <div class="row">
                    <div class="col-12 col-md-6 col-lg-6 col-gx-4 col-xl-4 divCurrencyType">
                        <div class="item">
                            <div class="currencyWallet__type">
                                <div class="wallet__type">
                                    <span class="currency CurrencyType language_replace" >代理</span>
                                </div>
                            </div>
                            <div class="currencyWallet__currencyFocus">
                                <div class="">
                                    <span class="title-s"><span class="language_replace">總數</span></span>
                                    <span class="data WalletBalance AgentCount">0</span>
                                </div>
                            </div>
                            <div class="currencyWallet__detail">
                                <div class="wrapper_revenueAmount">
                                    <div class="detailItem">
                                        <span class="title-s"><i class="icon icon-ewin-default-periodWinLose icon-s icon-before"></i><span class="language_replace">直屬</span></span>
                                        <span class="data rewardValue AgentCount_Under">0</span>
                                    </div>
                                    <div class="detailItem">
                                        <span class="title-s"><i class="icon icon-ewin-default-periodRolling icon-s icon-before"></i><span class="language_replace">下線</span></span>
                                        <span class="data validBetValue AgentCount_Other">0</span>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-12 col-md-6 col-lg-6 col-gx-4 col-xl-4 divCurrencyType">
                        <div class="item">
                            <div class="currencyWallet__type">
                                <div class="wallet__type">
                                    <span class="currency CurrencyType language_replace">會員</span>
                                </div>
                            </div>
                            <div class="currencyWallet__currencyFocus">
                                <div class="">
                                    <span class="title-s"><span class="language_replace">總數</span></span>
                                    <span class="data WalletBalance UserCount">0</span>
                                </div>
                            </div>
                            <div class="currencyWallet__detail">
                                <div class="wrapper_revenueAmount">
                                    <div class="detailItem">
                                        <span class="title-s"><i class="icon icon-ewin-default-periodWinLose icon-s icon-before"></i><span class="language_replace">直屬</span></span>
                                        <span class="data rewardValue UserCount_Under">0</span>
                                    </div>
                                    <div class="detailItem">
                                        <span class="title-s"><i class="icon icon-ewin-default-periodRolling icon-s icon-before"></i><span class="language_replace">下線</span></span>
                                        <span class="data validBetValue UserCount_Other">0</span>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="currencyWalletList" >
            <div class="container-fluid">
                <div id="idUserInfo" class="row">

                    <div class="col-12 col-md-6 col-lg-6 col-gx-6 col-xl-6" style="display: none">
                        <div class="item">
                            <div class="currencyWallet__type">
                                <div class="wallet__type">
                                    <span class="currency language_replace">總返水</span>
                                </div>
                                <div class="settleAccount__type" style="">
                                    <span class="language_replace" style="font-weight:bold">9999</span>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <div class="col-12 col-md-3 col-lg-3 col-gx-2 col-xl-2">
                        <div class="item">
                            <div class="currencyWallet__type">
                                <div class="wallet__type">
                                    <span class="currency language_replace">總收益</span>
                                </div>
                                <div class="settleAccount__type" style="">
                                    <span class="language_replace UserRebate" style="font-weight:bold">0</span>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="col-12 col-md-3 col-lg-3 col-gx-2 col-xl-2">
                        <div class="item">
                            <div class="currencyWallet__type">
                                <div class="wallet__type">
                                    <span class="currency language_replace">有效投注</span>
                                </div>
                                <div class="settleAccount__type" style="">
                                    <span class="language_replace TotalValidBetValue" style="font-weight:bold">9999</span>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="col-12 col-md-3 col-lg-3 col-gx-2 col-xl-2">
                        <div class="item">
                            <div class="currencyWallet__type">
                                <div class="wallet__type">
                                    <span class="currency language_replace">會員輸贏</span>
                                </div>
                                <div class="settleAccount__type" style="">
                                    <span class="language_replace RewardValue" style="font-weight:bold">9999</span>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="col-12 col-md-3 col-lg-3 col-gx-2 col-xl-2" style="display: none">
                        <div class="item">
                            <div class="currencyWallet__type">
                                <div class="wallet__type">
                                    <span class="currency language_replace">總佔成</span>
                                </div>
                                <div class="settleAccount__type" style="">
                                    <span class="language_replace " style="font-weight:bold">9999</span>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="col-12 col-md-3 col-lg-3 col-gx-2 col-xl-2">
                        <div class="item">
                            <div class="currencyWallet__type">
                                <div class="wallet__type">
                                    <span class="currency language_replace">優惠成本</span>
                                </div>
                                <div class="settleAccount__type" style="">
                                    <span class="language_replace PreferentialCost" style="font-weight:bold">0</span>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="col-12 col-md-3 col-lg-3 col-gx-2 col-xl-2">
                        <div class="item">
                            <div class="currencyWallet__type">
                                <div class="wallet__type">
                                    <span class="currency language_replace">投注筆數</span>
                                </div>
                                <div class="settleAccount__type" style="">
                                    <span class="language_replace TotalOrderCount" style="font-weight:bold">0</span>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="col-12 col-md-3 col-lg-3 col-gx-2 col-xl-2">
                        <div class="item">
                            <div class="currencyWallet__type">
                                <div class="wallet__type">
                                    <span class="currency language_replace">新用戶數</span>
                                </div>
                                <div class="settleAccount__type" style="">
                                    <span class="language_replace NewUserCount" style="font-weight:bold">0</span>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="col-12 col-md-3 col-lg-3 col-gx-2 col-xl-2">
                        <div class="item">
                            <div class="currencyWallet__type">
                                <div class="wallet__type">
                                    <span class="currency language_replace">首存人數</span>
                                </div>
                                <div class="settleAccount__type" style="">
                                    <span class="language_replace FirstDepositCount" style="font-weight:bold">0</span>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="col-12 col-md-3 col-lg-3 col-gx-2 col-xl-2">
                        <div class="item">
                            <div class="currencyWallet__type">
                                <div class="wallet__type">
                                    <span class="currency language_replace">複存人數</span>
                                </div>
                                <div class="settleAccount__type" style="">
                                    <span class="language_replace NotFirstDepositCount" style="font-weight:bold">0</span>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="col-12 col-md-3 col-lg-3 col-gx-2 col-xl-2">
                        <div class="item">
                            <div class="currencyWallet__type">
                                <div class="wallet__type">
                                    <span class="currency language_replace">提現金額</span>
                                </div>
                                <div class="settleAccount__type" style="">
                                    <span class="language_replace WithdrawalValue" style="font-weight:bold">0</span>
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
                                    <span class="data validBetValue WithdrawalCount">0</span>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="col-12 col-md-3 col-lg-3 col-gx-2 col-xl-2">
                        <div class="item">
                            <div class="currencyWallet__type">
                                <div class="wallet__type">
                                    <span class="currency language_replace">充值金額</span>
                                </div>
                                <div class="settleAccount__type" style="">
                                    <span class="language_replace DepositValue" style="font-weight:bold">0</span>
                                </div>
                            </div>
                            <div class="wrapper_revenueAmount">
                                <div class="detailItem">
                                    <span class="title-s"><span class="language_replace">筆數</span></span>
                                    <span class="data validBetValue DepositCount">0</span>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="col-12 col-md-3 col-lg-3 col-gx-2 col-xl-2">
                        <div class="item">
                            <div class="currencyWallet__type">
                                <div class="wallet__type">
                                    <span class="currency language_replace">首存金額</span>
                                </div>
                                <div class="settleAccount__type" style="">
                                    <span class="language_replace FirstDepositValue" style="font-weight:bold">0</span>
                                </div>
                            </div>
                            <div class="wrapper_revenueAmount">
                                <div class="detailItem">
                                    <span class="title-s"><span class="language_replace">筆數</span></span>
                                    <span class="data validBetValue FirstDepositCount">0</span>
                                </div>
                            </div>
                        </div>
                    </div>

                </div>
            </div>
        </div>

        <div id="templateWalletInfo" style="display: none">
            <div class="col-12 col-md-6 col-lg-6 col-gx-4 col-xl-4">
                <div class="item">
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
                    <div class="currencyWallet__currencyFocus divWalletList" style="border-bottom: none">
                        <div class="balance">
                            <span class="title-s"><span class="language_replace">可用餘額</span></span>
                            <span class="data WalletBalance">0</span>
                        </div>
                       
                    </div>
                </div>
            </div>
        </div>

        <div id="templateRateInfo" style="display: none">
            <div class="revenue">
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

    </main>
</body>
</html>
