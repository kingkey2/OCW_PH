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

    function init() {
        var d = new Date();

        EWinInfo = window.parent.EWinInfo;
        api = window.parent.API_GetAgentAPI();
   
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

        <div class="popUp " id="idPopUpForgetPassWord">
        <div class="popUpWrapper">
            <div class="popUp__close btn btn-close" onclick="closeForgetPassWord()"></div>
            <div class="popUp__title"><span class="language_replace">忘記密碼</span></div>
            <div class="popUp__content">
                <div>
                    <div class="col-12 form-group row no-gutters data-item">
                        <div class="col-12 data-title">
                            <label class="title"><span class="title_name"><span class="language_replace" langkey="電話">電話</span></span></label>
                        </div>
                        <div class="col-12 data-content">
                            <div class="row no-gutters">
                                <div class="col-auto col-md-4 ">
                                    <div class="form-control-underline">
                                        <select name="ContactPhonePrefix" id="ContactPhonePrefix" class="custom-select">
                                            <option class="language_replace" value="+63" langkey="+63 菲律賓">+63 菲律賓</option>
                                            <option class="language_replace" value="+886" langkey="+886 台灣">+886 台灣</option>
                                        </select>
                                    </div>
                                </div>
                                <div class="col col-md-6 pl-2">
                                    <div class="form-control-underline">
                                        <input type="text" class="form-control" name="ContactPhoneNumber" id="ContactPhoneNumber" language_replace="placeholder" placeholder="請輸入手機號碼" langkey="請輸入手機號碼">
                                        <label for="password" class="form-label "><span class="language_replace" langkey="請輸入手機號碼">請輸入手機號碼</span></label>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="col-12 col-md-6  col-lg-12  form-group row no-gutters data-item">
                        <div class="col-12 data-title">
                            <div class="form-group form-group-btnLogin btn-group-lg" style="padding-top:0px !important">
                               <div class="btn btn-full-main" onclick="sendValidateCode()"><span class="language_replace">傳送驗證碼</span></div>
                            </div>
                        </div>
                    </div>

                    <div class="col-12 col-md-6  col-lg-12  form-group row no-gutters data-item">
                        <div class="col-12 data-title">
                            <label class="title"><span class="title_name"><span class="language_replace" langkey="帳號">帳號</span></span></label>
                        </div>
                        <div class="col-12 data-content">
                            <div class="form-control-underline">
                                <input type="text" class="form-control" name="LoginAccount" id="LoginAccount" language_replace="placeholder" placeholder="請輸入帳號" langkey="請輸入帳號">
                                <label for="password" class="form-label "><span class="language_replace" langkey="請輸入帳號">請輸入帳號</span></label>
                            </div>
                        </div>
                    </div>

                    <div class="col-12 form-group row no-gutters data-item ">
                        <div class="col-12 data-title">
                            <label class="title"><span class="title_name"><span class="language_replace" langkey="登入密碼">登入密碼</span></span></label>
                        </div>
                        <div class="col-12 data-content">
                            <div class="form-control-underline">
                                <input type="password" class="form-control" name="LoginPassword" id="LoginPassword" language_replace="placeholder" placeholder="請輸入密碼" langkey="請輸入密碼">
                                    <label for="password" class="form-label "><span class="language_replace" langkey="請輸入密碼">請輸入密碼</span></label>
                            </div>
                        </div>
                    </div>

                    <div class="col-12 col-md-6  col-lg-12  form-group row no-gutters data-item">
                        <div class="col-12 data-title">
                            <label class="title"><span class="title_name"><span class="language_replace" langkey="驗證碼">驗證碼</span></span></label>
                        </div>
                        <div class="col-12 data-content">
                            <div class="form-control-underline">
                                <input type="text" class="form-control" name="ValidateCode" id="ValidateCode" language_replace="placeholder" placeholder="請輸入驗證碼" langkey="請輸入驗證碼">
                                <label for="password" class="form-label "><span class="language_replace" langkey="請輸入驗證碼">請輸入驗證碼</span></label>
                            </div>
                        </div>
                    </div>

                    <div class="col-12 col-md-6  col-lg-12  form-group row no-gutters data-item">
                        <div class="col-12 data-title">
                            <div class="form-group form-group-btnLogin btn-group-lg" style="padding-top:0px !important">
                                <div class="btn btn-full-main" onclick="updatePassWord()"><span class="language_replace">修改密碼</span></div>
                            </div>
                        </div>
                    </div>

                </div>
            </div>
        </div>
        <!-- mask_overlay 半透明遮罩-->
        <div class="mask_overlay_popup mask_overlay_loading"></div>
    </div>
</body>
<script type="text/javascript">
    ac.listenScreenMove();

    function clickMask() {
        // document.getElementById("div_MaskSafariFix").style.display = "none";
        document.getElementById("div_MaskSafariFix").classList.remove("show");
    }
</script>
</html>
