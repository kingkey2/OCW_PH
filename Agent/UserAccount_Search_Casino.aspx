<%@ Page Language="C#" AutoEventWireup="true" CodeFile="UserAccount_Search_Casino.aspx.cs" Inherits="Agent_UserAccount_Search_Casino" %>


<%
    string ASID = Request["ASID"];
    string Timezone = string.Empty;
    System.Data.DataTable AgentDT = null;

    RedisCache.AgentSession.AgentSessionInfo ASI = null;

    ASI = RedisCache.AgentSession.GetAgentSessionByID(ASID);
    if (ASI == null) {

    } else {
        AgentDT = RedisCache.UserAccount.GetUserAccountByID(ASI.UserAccountID);
    }
%>
<!doctype html>
<html lang="zh-Hant-TW" class="innerHtml">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <title>代理網</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="css/basic.min.css?<%=DateTime.Now.ToString("yyyyMMddHHmmss") %>">
    <link rel="stylesheet" href="css/main.css?<%=DateTime.Now.ToString("yyyyMMddHHmmss") %>">
    <link rel="stylesheet" href="css/downline.css?<%=DateTime.Now.ToString("yyyyMMddHHmmss") %>">
    <script type="text/javascript" src="js/AgentCommon.js?20210316"></script>
    <script type="text/javascript" src="/Scripts/Common.js"></script>
    <script type="text/javascript" src="/Scripts/bignumber.min.js"></script>
    <script type="text/javascript" src="/Scripts/Math.uuid.js"></script>
    <script type="text/javascript" src="Scripts/MultiLanguage.js"></script>
    <script type="text/javascript" src="js/AgentAPI.js"></script>
    <script type="text/javascript" src="js/date.js"></script>
    <script src="js/jquery-3.3.1.min.js"></script>
    <script type="text/javascript">
        var ApiUrl = "UserAccount_Search_Casino.aspx";
        var c = new common();
        var ac = new AgentCommon();
        var mlp;
        var EWinInfo;
        var api;
        var lang;

        function changeTab(type) {
            switch (type) {
                case 0:
                    $("#idAgentList").hide();
                    $("#idUserList").show();
                    $("#tab1").removeClass("active");
                    $("#tab0").addClass("active");
                    break;
                case 1:
                    $("#idUserList").hide();
                    $("#idAgentList").show();
                    $("#tab0").removeClass("active");
                    $("#tab1").addClass("active");
                    break;
            }
        }

        function searchUser() {
            let searchUser = $("#loginAccount").val();
            let postData;
            if (searchUser == "") {
                postData = {
                    AID: EWinInfo.ASID
                };
                c.callService(ApiUrl + "/QueryChildUserInfo", postData, function (success, obj) {
                    if (success) {
                        var o = c.getJSON(obj);

                        if (o.Result == 0) {
                            setItem(o.Datas);
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
            } else {
                postData = {
                    AID: EWinInfo.ASID,
                    LoginAccount: searchUser
                };
                c.callService(ApiUrl + "/QueryCurrentUserInfo", postData, function (success, obj) {
                    if (success) {
                        var o = c.getJSON(obj);

                        if (o.Result == 0) {
                            setItem(o.Datas);
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
            }

        }

        function setItem(item) {
            let idAgentList = $("#idAgentList");
            let idUserList = $("#idUserList");

            $(idAgentList).empty();
            $(idUserList).empty();

            for (var i = 0; i < item.length; i++) {
                let k = item[i];
                var temp = c.getTemplate("templateTableItem");
                
                c.setClassText(temp, "mtLoginAccount", null, k.LoginAccount);
                c.setClassText(temp, "mtRealName", null, k.RealName);

                mtUserAccountType = temp.getElementsByClassName("mtUserAccountType");
                if (mtUserAccountType) {
                    switch (k.UserAccountType) {
                        case 0:
                            c.setClassText(temp, "mtUserAccountType", null, mlp.getLanguageKey("一般帳戶"));
                            break;
                        case 1:
                            c.setClassText(temp, "mtUserAccountType", null, mlp.getLanguageKey("代理"));
                            break;
                        case 2:
                            c.setClassText(temp, "mtUserAccountType", null, mlp.getLanguageKey("股東"));
                            break;
                    }
                }

                mtUserAccountState = temp.getElementsByClassName("mtUserAccountState");
                if (mtUserAccountState) {
                    switch (k.UserAccountState) {
                        case 0:
                            c.setClassText(temp, "mtUserAccountState", null, mlp.getLanguageKey("正常"));
                            mtUserAccountState[0].parentNode.classList.add("status-active");
                            break;
                        case 1:
                            c.setClassText(temp, "mtUserAccountState", null, "<span>" + mlp.getLanguageKey("停用") + "</span>");
                            mtUserAccountState[0].parentNode.classList.add("status-deactive");
                            break;
                        case 2:
                            c.setClassText(temp, "mtUserAccountState", null, "<span>" + mlp.getLanguageKey("永久停用") + "</span>");
                            mtUserAccountState[0].parentNode.classList.add("status-deactive");
                            break;
                    }
                }

                for (var j = 0; j < k.WalletList.length; j++) {
                    if (k.WalletList[j].CurrencyType == EWinInfo.CurrencyType) {
                        c.setClassText(temp, "CurrencyType", null, k.WalletList[j].CurrencyType + mlp.getLanguageKey("可用餘額"));
                        c.setClassText(temp, "WalletBalance", null, c.toCurrency(k.WalletList[j].PointValue));
                    }
                }

                for (var l = 0; l < k.GameCodeList.length; l++) {
                    let kk = k.GameCodeList[l];
                    let t = c.getTemplate("tempGameAccountingCode");
                    
                    c.setClassText(t, "GameAccountingCode", null, kk.GameAccountingCode);
                    c.setClassText(t, "UserRate", null, c.toCurrency(kk.UserRate));
                    c.setClassText(t, "BuyChipRate", null, c.toCurrency(kk.BuyChipRate));

                    $(temp).children().find(".GameAccountingCodeList").append(t);
                }

                if (k.UserAccountType == 0) {
                    $("#idUserList").append(temp);
                } else {
                    $("#idAgentList").append(temp);
                }

            }
        }

        function init() {
            EWinInfo = window.parent.EWinInfo;
            api = window.parent.API_GetAgentAPI();

            lang = window.localStorage.getItem("agent_lang");
            mlp = new multiLanguage();
            mlp.loadLanguage(lang, function () {

                $("#idParentPath").text(EWinInfo.LoginAccount);
                window.parent.API_CloseLoading();

            });
        }

        window.onload = init;

    </script>
</head>
<body class="innerBody">
    <main class="innerMain">
        <div class="loginUserInfo">
            <div class="container-fluid">
                <div class="breadcrumb__userAccount row">
                    <div id="idParentPath" class="loginUserInfo__accountID heading-1 col">--</div>
                </div>

            </div>
        </div>

        <div id="WrapperFilterGame_UserAccountMaint" class="fixed Filter__Wrapper">
            <div class="container-fluid">
                <div class="row">
                    <div id="idSearchButton" class="col-12 col-md-2">
                        <div class="form-group form-group-s2 ">
                            <div class="title hidden shown-md"><span class="language_replace">帳號</span></div>
                            <div class="input-group form-control-underline iconCheckAnim placeholder-move-right zIndex_overMask_SafariFix">
                                <input type="text" class="form-control" id="loginAccount" value="">
                                <div class="input-group-append">
                                    <span onclick="searchUser()" class="input-group-text" style="cursor: pointer; color: #C9AE7F; background-color: #2d3244; border: none">搜尋</span>
                                </div>
                            </div>

                        </div>
                    </div>
                </div>
            </div>

            <div class="totalWalletList tab-scroller">
                <div class="tab-scroller__area">
                    <div id="idParentWalletList" class="tab-scroller__content">
                        <span class="tab-item walletList_item itemCurrencyType active" id="tab1" onclick="changeTab(1)">
                            <a class="language_replace mtCurrencyType">代理</a>
                        </span>
                        <span class="tab-item walletList_item itemCurrencyType" id="tab0" onclick="changeTab(0)">
                            <a class="language_replace mtCurrencyType">會員</a>
                        </span>
                        <div id="divTabSlide" class="tab-slide"></div>
                    </div>
                </div>
            </div>

        </div>

        <div class="MemberList MemberList__Downline">
            <div id="idAgentList" class="row MemberList__UserList">
            </div>
            <div id="idUserList" class="row MemberList__UserList" style="display: none">
            </div>
        </div>

    </main>

    <div id="templateTableItem" style="display: none">
        <div class="col-12 col-md-6 col-lg-6 col-gx-4 col-xl-4 div_UserAccountInfo">
            <div class="item">
                <div class="downline__overview">
                    <div class="tab-scroller" style="display: none">
                        <div class="downline__walletList tab-scroller__area">
                            <div class="tab-scroller__content mtWalletList">
                            </div>
                        </div>
                        <div class="mask"></div>
                    </div>
                    <div class="downline__header">
                        <span class="downline__account">
                            <i class="icon icon-ewin-default-downlineuser"></i>
                            <span class=" mtLoginAccount">--</span>
                        </span>
                    </div>
                    <div class="downline__info">
                        <div class="account">
                            <div class="role "><i class="icon icon-ewin-default-user-s"></i><span class="language_replace mtUserAccountType">股東</span></div>
                            <div class="name"><span class="language_replace mtRealName">帳戶姓名</span></div>
                        </div>

                        <!-- 帳戶啟用 狀態加入 class="status-active" -->
                        <div class="downline__accountStatus-s"><i class="icon icon-ewin-default-accountStatus"></i><span class="language_replace mtUserAccountState">啟用</span></div>
                    </div>
                    <div class="mtCurrencyDetailList">

                        <div class="downline__currencyDetail">

                            <div class="focusBox divWalletList">
                                <!-- 錢包停用， balance 加入 class=> wallet-deactive -->
                                <div class="balance">
                                    <span class="title-s"><span class="language_replace CurrencyType">可用餘額</span></span>
                                    <span class="data WalletBalance">0</span>
                                </div>
                            </div>

                        </div>

                        <div class="GameAccountingCodeList">
                        </div>


                    </div>
                </div>
            </div>
        </div>
    </div>

    <div id="tempGameAccountingCode" style="display: none">
        <div class="downline__currencyDetail" style="border-bottom: solid 1px rgba(227, 195, 141, 0.15)">
            <div class="detailItem">
                <span class="title-s"><span class="language_replace GameAccountingCode">期間上下數</span></span>
            </div>

            <div class="detailItem">
                <span class="title-s"><i class="icon icon-ewin-default-periodWinLose icon-s icon-before"></i><span class="language_replace">佔成率</span></span>
                <span class="data UserRate">0</span>
            </div>
            <div class="detailItem">
                <span class="title-s"><i class="icon icon-ewin-default-periodRolling icon-s icon-before"></i><span class="language_replace">返水率</span></span>
                <span class="data BuyChipRate">0</span>
            </div>
        </div>
    </div>

</body>
</html>
