<%@ Page Language="C#" AutoEventWireup="true" CodeFile="UserAccount_Edit_MySelf.aspx.cs" Inherits="UserAccount_Edit" %>

<%

    string w = Request["w"];
    string r = Request["r"];
    string t = Request["t"];
    string ASID = Request["ASID"];
    string AgentVersion = EWinWeb.AgentVersion;
    Boolean AllowQRCodeShow = false;
    Boolean isLogIn = true;
    EWin.SpriteAgent.SpriteAgent api = new EWin.SpriteAgent.SpriteAgent();
    EWin.SpriteAgent.AgentSessionResult ASR = null;
    EWin.SpriteAgent.AgentSessionInfo ASI = null;

    ASR = api.GetAgentSessionByID(ASID);

    if (ASR.Result != EWin.SpriteAgent.enumResult.OK) {
        Response.Redirect("login.aspx");
    } else {
        ASI = ASR.AgentSessionInfo;
    }
    

%>
<%="" %>
<!doctype html>
<html lang="zh-Hant-TW" class="innerHtml">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <title>代理網</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="css/basic.min.css?<%:AgentVersion%>">
    <link rel="stylesheet" href="css/main2.css?<%:AgentVersion%>">
</head>
<script type="text/javascript" src="js/AgentCommon.js"></script>
<script type="text/javascript" src="/Scripts/Common.js?20191127"></script>
<script type="text/javascript" src="/Scripts/UIControl.js"></script>
<script type="text/javascript" src="Scripts/MultiLanguage.js"></script>
<script type="text/javascript" src="/Scripts/Math.uuid.js"></script>
<script type="text/javascript" src="/Scripts/bignumber.min.js"></script>
<script type="text/javascript" src="/Scripts/SelectItem.js"></script>
<script src="js/jquery-3.3.1.min.js"></script>
<script type="text/javascript">
    var c = new common();
    var ac = new AgentCommon();
    var ApiUrl = "UserAccount_Edit_MySelf.aspx";
    var w = "<%=w%>";
    var r = "<%=r%>";
    var mlp;
    var lang;
    var parentObj;
    var UserObj;
    var EWinInfo;
    var processing = false;

    function checkFormData() {
        var retValue = true;
        var form = document.forms[0];

        if (form.LoginPassword.value != "" || form.LoginPassword2.value != "") {
            if (form.LoginPassword.value != form.LoginPassword2.value) {
                window.parent.API_ShowMessageOK(mlp.getLanguageKey("錯誤"), mlp.getLanguageKey("登入密碼二次驗證失敗"));
                retValue = false;
            }
        }


        if (form.WalletPassword.value != "" || form.WalletPassword2.value != "") {
            if (form.WalletPassword.value != form.WalletPassword2.value) {
                window.parent.API_ShowMessageOK(mlp.getLanguageKey("錯誤"), mlp.getLanguageKey("錢包密碼二次驗證失敗"));
                retValue = false;
            }
        }


        if (retValue == true) {
            if (form.LoginPassword.value != "" || form.WalletPassword.value != "") {
                var idPasswordReCheck = document.getElementById("idPasswordReCheck");
                var idMessageText = document.getElementById("idMessageText");

                idMessageText.appendChild(idPasswordReCheck);
                idPasswordReCheck.style.display = "";

                showBox(mlp.getLanguageKey("驗證"), null, function () {
                    if (document.getElementById("LoginPasswordReCheck").value == "") {
                        window.parent.API_ShowMessageOK(mlp.getLanguageKey("錯誤"), mlp.getLanguageKey("請輸入目前登入密碼"));
                    }
                    else {
                        updateUserInfo();
                    }
                }, null);
            }
            else {
                updateUserInfo();
            }
        }
    }

    function updateUserInfo() {
        var form = document.forms[0];
        var userList = [];
        var postObj;

        var idPointList = document.getElementById("idPointList");
        var QBetLimitList = document.getElementById("QBetLimitList");
        var NBetLimitList = document.getElementById("NBetLimitList");

        if (processing == false) {
           

            // 建立用戶更新物件
            if ((form.LoginPassword.value != "") && (form.LoginPassword.value != null))
                userList[userList.length] = { Name: "LoginPassword", Value: form.LoginPassword.value };

            userList[userList.length] = { Name: "RealName", Value: form.RealName.value };

            //錢包密碼
            if ((form.WalletPassword.value != "") && (form.WalletPassword.value != null))
                userList[userList.length] = { Name: "WalletPassword", Value: form.WalletPassword.value };

            //目前密碼
            if (document.getElementById("LoginPasswordReCheck").value != "") {
                userList[userList.length] = { Name: "LoginPasswordReCheck", Value: document.getElementById("LoginPasswordReCheck").value };
                document.getElementById("LoginPasswordReCheck").value = "";
            }

            window.parent.API_ShowMessage(mlp.getLanguageKey("確認"), mlp.getLanguageKey("確認修改??"), function () {
                processing = true;

                postObj = {
                    AID: EWinInfo.ASID,
                    UserField: userList
                }
                window.parent.API_ShowLoading("Sending");
                c.callService(ApiUrl + "/UpdateUserInfo", postObj, function (success, o) {
                    if (success) {
                        var obj = c.getJSON(o);

                        if (obj.Result == 0) {
                            window.parent.API_ShowMessageOK(mlp.getLanguageKey("完成"), mlp.getLanguageKey("更新完成"), function () {
                                closePage();
                            });
                        } else {
                            window.parent.API_ShowMessageOK(mlp.getLanguageKey("錯誤"), mlp.getLanguageKey(obj.Message));
                            processing = false;
                        }
                    } else {
                        if (o == "Timeout") {
                            window.parent.API_ShowMessageOK(mlp.getLanguageKey("錯誤"), mlp.getLanguageKey("網路異常, 請稍後重新嘗試"));
                            processing = false;
                        } else {
                            window.parent.API_ShowMessageOK(mlp.getLanguageKey("錯誤"), o);
                            processing = false;
                        }
                    }

                    window.parent.API_CloseLoading();
                })

            }, null);
            
        }
        else {
            window.parent.API_ShowToastMessage(mlp.getLanguageKey("作業進行中"));
        }
    }

    function queryCurrentUserInfo() {
        var postObj;

        postObj = {
            AID: EWinInfo.ASID
        };

        c.callService(ApiUrl + "/QueryCurrentUserInfo", postObj, function (success, o) {
            if (success) {
                var obj = c.getJSON(o);

                if (obj.Result == 0) {
                    parentObj = obj;
                    updateBaseInfo(obj);
                } else {
                    window.parent.API_ShowMessageOK(mlp.getLanguageKey("錯誤"), obj.Message);
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


    function updateBaseInfo(o) {
        var idLendChipAccount = document.getElementById("idLendChipAccount");
        var IsLendChipAccount = document.getElementById("IsLendChipAccount");
        var AllowPayment = document.getElementById("AllowPayment");
        //var AllowBet = document.getElementById("AllowBet");
        var AllowServiceChat = document.getElementById("AllowServiceChat");
        var RealName = document.getElementById("RealName");

        if (o != null) {
            if (o.AllowPayment == 1)
                c.setElementText("idAllowPayment2", null, mlp.getLanguageKey("允許使用"));
            else
                c.setElementText("idAllowPayment2", null, mlp.getLanguageKey("不允許使用"));

            if (o.AllowServiceChat == 1)
                c.setElementText("idAllowServiceChat2", null, mlp.getLanguageKey("允許使用"));
            else
                c.setElementText("idAllowServiceChat2", null, mlp.getLanguageKey("不允許使用"));


            if (EWinInfo) {
                if (EWinInfo.CompanyInfo) {
                    if (EWinInfo.CompanyInfo.PaymentType == 2) {
                        if (o.AllowPayment == 1) {
                            document.getElementById("idAllowPayment").style.display = "";
                        }
                    }
                    if (EWinInfo.CompanyInfo.ServiceChatType == 1) {
                        if (o.AllowServiceChat == 1) {
                            document.getElementById("idAllowServiceChat").style.display = "";
                        }
                    }
                }
            }


            c.setElementText("idLoginAccount", null, o.LoginAccount);
            c.setElementText("idLoginAccount2", null, o.LoginAccount);
            //if (o.EthWalletAddress != "") {
            //    document.getElementById("divEthWalletAddress").style.display = "";
            //    c.setElementText("idEthWalletAddress", null, o.EthWalletAddress);
            //}
            //c.setElementText("ParentLoginAccount", null, o.ParentLoginAccount);
            //c.setElementText("idCompanyCode", null, o.CompanyCode);

            switch (o.UserAccountType) {
                case 0:
                    c.setElementText("idUserAccountType", null, mlp.getLanguageKey("一般帳戶"));
                    break;
                case 1:
                    c.setElementText("idUserAccountType", null, mlp.getLanguageKey("代理"));
                    break;
                case 2:
                    c.setElementText("idUserAccountType", null, mlp.getLanguageKey("股東"));
                    break;
            }


            if (o.IsLendChipAccount) {
                c.setElementText("IsLendChipAccount", null, mlp.getLanguageKey("此帳戶為配碼帳戶"));
                idLendChipAccount.style.display = "block";
            } else {
                idLendChipAccount.style.display = "none";
            }



            switch (o.AllowBet) {
                case 0:
                    c.setElementText("idAllowBet2", null, mlp.getLanguageKey("不允許投注"));
                    break;
                case 1:
                    c.setElementText("idAllowBet2", null, mlp.getLanguageKey("傳統電投"));
                    break;
                case 2:
                    c.setElementText("idAllowBet2", null, mlp.getLanguageKey("網投/快速"));
                    break;
                case 3:
                    c.setElementText("idAllowBet2", null, mlp.getLanguageKey("全部允許"));
                    break;
            }
            //SelectItem(AllowBet, o.AllowBet);

            RealName.value = o.RealName;

            //SelectItem(ContactPhonePrefix, o.ContactPhonePrefix);
            //ContactPhoneNumber.value = o.ContactPhoneNumber;
            if (o.ContactPhonePrefix != null && o.ContactPhoneNumber != null) {
                c.setElementText("idPhoneNumber", null, o.ContactPhonePrefix + "-" + o.ContactPhoneNumber);
            }

            if (o.WalletList != null) {
                var idPointList = document.getElementById("idPointList");

                c.clearChildren(idPointList);

                for (var i = 0; i < o.WalletList.length; i++) {
                    var w = o.WalletList[i];
                    if (w.PointState != -1) {
                        var t = c.getTemplate("templateWalletItem");

                        t.setAttribute("currencyType", w.CurrencyType);
                        c.setClassText(t, "PointCurrencyType", null, w.CurrencyType);

                        switch (w.PointState) {
                            case 0:
                                c.setClassText(t, "PointState", null, mlp.getLanguageKey("使用中"));
                                break;
                            case 1:
                                c.setClassText(t, "PointState", null, mlp.getLanguageKey("停用"));
                                break;
                        }

                        if (parseFloat(w.PointValue) < 0) {
                            t.getElementsByClassName("PointValue")[0].classList.add("num-negative");
                        }
                        c.setClassText(t, "PointValue", null, c.toCurrency(w.PointValue));


                        idPointList.appendChild(t);

                    }
                }
            }
        }
    }


    function init() {
        var idWalletTab;
        var promotionCode = document.getElementsByClassName("promotionCode");

        lang = window.localStorage.getItem("agent_lang");

        mlp = new multiLanguage();
        mlp.loadLanguage(lang, function () {
            EWinInfo = window.parent.EWinInfo;

            queryCurrentUserInfo();


            $('#QRCodeimg').attr("src", `/GetQRCode.aspx?QRCode=${EWinInfo.CompanyInfo.QRCodeURL}?PCode=${EWinInfo.UserInfo.PersonCode}&Download=2`);

            for (var i = 0; i < promotionCode.length; i++) {
                promotionCode[i].innerText = EWinInfo.UserInfo.PersonCode;
            }
            document.getElementsByClassName("account__member")[0].innerText = EWinInfo.UserInfo.LoginAccount;

            document.getElementsByClassName("spanUrlLink")[0].innerText = EWinInfo.CompanyInfo.QRCodeURL + "?PCode=" + EWinInfo.UserInfo.PersonCode;

            document.getElementById("btnQRCode").click();
        });

        if (w == 1) {
            idWalletTab = document.getElementById("idWalletTab");
            idWalletTab.click();
        }
    }

    window.onload = init;
</script>
<body class="innerBody">
    <main>
        <form method="post" onsubmit="return checkFormData(this)">
            <%--<div class="loginUserInfo">
                <div class="loginUserInfo__account heading-1" id="idLoginAccount">
                </div>
            </div>--%>

            <div id="idTabMainContent">
                <div class="topList-box box-shadow fixed">
                    <div class="container-fluid">
                        <h1 class="page__title "><span class="language_replace">會員中心</span></h1>
                        <ul class="tab-header nav-tabs-block nav nav-tabs tab-items-2 hidden-lg" role="tablist">
                            <li class="nav-item">
                                <a onclick="tabSwitch(this, 'idTabMainContent', 'nav-link', 'mainTabContent')" class="nav-link active" data-toggle="tab" href="#tab-profile" role="tab" aria-controls="tab-profile" aria-selected="true"><i class="icon icon-ewin-tab-account icon-s icon-before"></i><span class="language_replace">基本資料</span></a>
                            </li>
                            <li class="nav-item">
                                <a id="idWalletTab" onclick="tabSwitch(this, 'idTabMainContent', 'nav-link', 'mainTabContent')" class="nav-link" data-toggle="tab" href="#tab-wallet" role="tab" aria-controls="tab-wallet" aria-selected="false"><i class="icon icon-ewin-tab-wallet icon-s icon-before"></i><span class="language_replace">錢包資訊</span></a>
                            </li>
                            <li class="tab-slide"></li>
                        </ul>
                    </div>
                </div>
                <div id="" class="tab__contentBox show-xl">
                    <div class="container-fluid">
                        <div class="dataList tab-content row">
                            <!-- 基本資料 -->
                            <div id="tab-profile" class="col-12 col-lg-6  tab-pane fade show active mainTabContent">
                                <fieldset class="dataFieldset">
                                    <legend class="dataFieldset-title  hidden shown-lg"><i class="icon icon-ewin-tab-account icon-s icon-before"></i><span class="language_replace">基本資料</span></legend>

                                    <div class="row dataFieldset-content">
                                        <div class="col-12 col-sm-6 col-md-4 col-lg-6 form-group row no-gutters  data-item ">
                                            <div class="col-12 data-title">
                                                <label class="title"><span class="title_name"><i class="icon icon-ewin-default-account icon-s icon-before"></i><span class="language_replace">登入帳號</span></span></label>
                                            </div>
                
                                            <div class="col-12 data-content form-line">
                                                <div id="idLoginAccount" class="">
                                                </div>
                                            </div>
                                        </div>

                                        <div class="col-12 col-sm-6 col-md-4 col-lg-6 form-group row no-gutters  data-item ">
                                            <div class="col-12 data-title">
                                                <label class="title"><span class="title_name"><i class="icon icon-ewin-default-accountType icon-s icon-before"></i><span class="language_replace">帳戶類型</span></span></label> 
                                            </div>
                                            <div class="col-12 data-content form-line">
                                                <div id="idUserAccountType" class="">
                                                </div>
                                            </div>
                                        </div>
                                        <div class="col-12 form-group data-item" id="idLendChipAccount">
                                            <div class="col-12 data-title"> <label class="title"><span class="language_replace">配碼帳戶</span></label></div>
                                            <div class="col-12 data-content form-line">
                                                <span class="language_replace" id="IsLendChipAccount"></span>
                                            </div>
                                        </div>
                                        <div id="idAllowPayment" style="display: none" class="col-12 col-sm-6 col-md-4 col-lg-6 form-group row no-gutters data-item">
                                            <div class="col-12 data-title">
                                                <label class="title"><span class="title_name"><i class="icon icon-ewin-default-paymentSystem icon-s icon-before"></i><span class="language_replace">使用支付系統</span></span>                           </label> 
                                            </div>
                                            <div class="col-12 data-content form-line">
                                                <div id="idAllowPayment2" class="form-control-underline ">
                                                </div>
                                            </div>
                                        </div>
                                        <div id="idAllowServiceChat" style="display: none" class="col-12 col-sm-6 col-md-4 col-lg-6 form-group row no-gutters data-item">
                                            <div class="col-12 data-title">  <label class="title"><span class="title_name"><i class="icon icon-ewin-default-callCenter icon-s icon-before"></i><span class="language_replace">使用線上客服系統</span></span></label>
                                            </div>
                                            <div class="col-12 data-content form-line">
                                                <div id="idAllowServiceChat2" class="form-control-underline ">
                                                </div>
                                            </div>
                                        </div>
                                        <div id="idAllowBet" class="col-12 col-sm-6 col-md-4 col-lg-6 form-group row no-gutters data-item">
                                            <div class="col-12 data-title"> <label class="title"><span class="title_name"><i class="icon icon-ewin-default-betyType icon-s icon-before"></i><span class="language_replace">投注類型</span></span></label>
                                            </div>
                                            <div class="col-12 data-content form-line">
                                                <div id="idAllowBet2" class="form-control-underline ">
                                                </div>
                                            </div>
                                        </div>
                                        <div class="col-12 col-sm-12 col-smd-6 col-md-4 col-lg-6 form-group row no-gutters data-item">
                                            <div class="col-12 data-title">
                                                <label class="title"><span class="title_name"><i class="icon icon-ewin-default-accounCellphone icon-s icon-before"></i><span class="language_replace">電話</span></span></label>
                                            </div>
                                            <div class="col-12 data-content form-line">
                                                <div id="idPhoneNumber" class="form-control-underline ">
                                                </div>
                                            </div>
                                        </div>
                                        <div id="idMyQRCode" class="col-12 col-sm-12 col-smd-6 col-md-4 col-lg-6 form-group row no-gutters data-item">
                                            <div class="col-12 data-title">
                                                <div class="wrapper__title">
                                                    <label class="title"><span class="title_name"><i class="icon icon-ewin-default-myQrCode icon-s icon-before"></i><span class="language_replace">推廣碼</span></span></label>
                                                    <button id="btnQRCode" type="button" class="col-auto btnQRCode btn btn-s btn-full-main btnShow" data-toggle="popup" role="button" aria-haspopup="true"  data-target="#idPopUpMyQRCord" onclick="ac.dataTogglePopup(this)"><span class="language_replace">顯示二維碼</span></button>
                                                </div>
                                            </div>
                                            <div class="col-12 data-content form-line">
                                                <div class="wrapper__myPromotionCode userAccount_editMySelf">
                                                    <span class="promotionCode">--</span>
                                                    <div class="wrapper__toast">
                                                        <!-- 按下時，出現 Toast元件-->
                                                        <button type="button" class="btn btn-transparent btn-copy" onclick="toastShow('promotionCode',toastCopied)"><i class="icon icon-ewin-default-copy  icon-before"></i></button>
                                                        <!--Toast元件 要出現時 加入 class=> show -->
                                                        <div id="toastCopied" class="toastCopied">
                                                        <span class="language_replace">已複製</span>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        <div id="divEthWalletAddress" style="display: none" class="col-12 col-md-6 col-lg-12 form-group row no-gutters data-item">
                                            <div class="col-12 data-title">
                                                <label class="title"><span class="title_name"><i class="icon icon-ewin-default-cryptoWalletAdress icon-s icon-before"></i><span class="language_replace">區塊鏈錢包</span></span></label>
                                            </div>
                                            <div class="col-12 data-content form-line">
                                                <div id="idEthWalletAddress" class="text-break text-sm">
                                                </div>
                                            </div>
                                        </div>
                                        <div class="col-12 col-md-6  col-lg-12  form-group row no-gutters data-item">
                                            <div class="col-12 data-title">
                                                <label class="title"><span class="title_name"><i class="icon icon-ewin-default-accountNickname icon-s icon-before"></i><span class="language_replace">姓名</span></span></label></div>
                                                <div class="col-12 data-content">
                                                <div class="form-control-underline">
                                                    <input type="text" class="form-control" name="RealName" id="RealName" language_replace="placeholder" placeholder="請輸入姓名">
                                                    <label for="password" class="form-label "><span class="language_replace">請輸入姓名</span></label>
                                                </div>
                                            </div>
                                        </div>
                                        <!-- password input =============== -->
                                        <div class="col-12 form-group row no-gutters data-item ">
                                            <div class="col-12 data-title">           <label class="title">                <span class="title_name"><i class="icon icon-ewin-default-accountPassword icon-s icon-before"></i><span class="language_replace">登入密碼</span></span></label></div>
                                            <div class="col-12 data-content row no-gutters"> <div class="col-12 col-smd-6 pr-smd-1">
                                                <div class="form-control-underline">
                                                    <input type="password" class="form-control" name="LoginPassword" id="LoginPassword" language_replace="placeholder" placeholder="輸入密碼，如不需更改，請留空白">
                                                    <label for="password" class="form-label "><span class="language_replace">輸入密碼，如不需更改，請留空白</span></label>
                                                </div>
                                            </div>
                                            <div class="col-12 col-smd-6 mt-3 mt-smd-0 pl-smd-1">
                                                <div class="form-control-underline">
                                                    <input type="password" class="form-control" name="LoginPassword2" id="LoginPassword2" language_replace="placeholder" placeholder="確認密碼">
                                                    <label for="password" class="form-label "><span class="language_replace">確認密碼</span></label>
                                                </div>
                                            </div>
                                            
                                        </div>
                                           
           
                                        </div>
                                        <!-- select =============== -->
                                        <div id="idPasswordReCheck" style="display: none" class="col-12 form-group row no-gutters">
                                            <div class="col-12">
                                                <label class="title">
                                                    <span class="language_replace">目前登入密碼</span>
                                                </label>
                                            </div>
                                            <div class="col-12 col-smd-6 pr-smd-1">
                                                <div class="form-control-underline">
                                                    <input type="password" class="form-control" name="LoginPasswordReCheck" id="LoginPasswordReCheck" language_replace="placeholder" placeholder="目前登入密碼">
                                                    <label for="password" class="form-label "><span class="language_replace">目前登入密碼</span></label>
                                                </div>
                                            </div>  
                                        </div>

                                    </div>
                                </fieldset>
                            </div>
                            <!-- END OF 基本資料 -->

                            <!-- 錢包管理 -->
                            <div id="tab-wallet" class="col-12 col-lg-6 tab-pane fade mainTabContent">
                                <fieldset class="dataFieldset">
                                    <legend class="dataFieldset-title  hidden shown-lg"><i class="icon icon-ewin-tab-wallet icon-s icon-before"></i><span class="language_replace">錢包資訊</span></legend>

                                    <div class="row dataFieldset-content">
                                        <div class="col-12 form-group row no-gutters data-item">
                                            <div class="col-12 data-title">
                                                <label class="title"><span class="title_name"><i class="icon icon-ewin-default-walletPassword icon-s icon-before"></i><span class="language_replace">錢包密碼</span></span></label></div>
                                                <div class="col-12 data-content row no-gutters">
                                                    <div class="col-12 col-smd-6 pr-smd-1">
                                                        <div class="form-control-underline">
                                                            <input type="password" class="form-control" name="WalletPassword" id="WalletPassword" language_replace="placeholder" placeholder="輸入密碼，如不需更改，請留空白">
                                                            <label for="password" class="form-label "><span class="language_replace">輸入密碼，如不需更改，請留空白</span></label>
                                                        </div>
                                                    </div>
                                                    <div class="col-12 col-smd-6 mt-3 mt-smd-0 pl-smd-1">
                                                        <div class="form-control-underline">
                                                            <input type="password" class="form-control" name="WalletPassword2" id="WalletPassword2" language_replace="placeholder" placeholder="確認密碼">
                                                            <label for="password" class="form-label "><span class="language_replace">確認密碼</span></label>
                                                        </div>
                                                    </div>

                                                </div>
                                        
                                        </div>

                                       <!-- MT__table ======= -->
                                        <div class="col-12 form-group row no-gutters data-item">
                                            <div class="MT__tableDiv">
                                                <!-- 自訂表格 -->
                                                <div class="MT__table  MT__table--Sub table-col--3">
                                                    <!-- 標題項目  -->
                                                    <div class="thead">
                                                        <!--標題項目單行 -->
                                                        <div class="thead__tr">
                                                            <div class="thead__th">
                                                                <span class="language_replace">貨幣</span>
                                                            </div>
                                                            <div class="thead__th">
                                                                <span class="language_replace">狀態</span>
                                                            </div>
                                                            <div class="thead__th">
                                                                <span class="language_replace">可用餘額</span>
                                                            </div>
        
                                                        </div>
                                                    </div>
                                                    <!-- 表格上下滑動框 -->
                                                    <div id="templateWalletItem" style="display: none">
                                                        <!--表格內容單行 -->
                                                        <div class="tbody__tr td-non-underline-last-2">
                                                            <div class="tbody__td td-100 currencyType">
                                                                <span class="td__title"><i class="icon icon-ewin-default-coin-o"></i><span class="language_replace"></span></span>
                                                                <span class="td__content">
                                                                    <span class="language_replace PointCurrencyType"></span>
        
                                                                </span>
                                                            </div>
                                                            <div class="tbody__td td-3 td-vertical td-icon">
                                                                <span class="td__title"><i class="icon icon-ewin-default-betStatus icon-s icon-before"></i><span class="language_replace">狀態</span></span>
                                                                <span class="td__content">
                                                                    <span class="language_replace PointState"></span>
                                                                </span>
                                                            </div>
                                                            <div class="tbody__td td-3 td-number  td-vertical">
                                                                <span class="td__title"><i class="icon icon-ewin-default-balance icon-s icon-before"></i><span class="language_replace">可用餘額</span></span>
        
                                                                <span class="td__content">
                                                                    <span class="language_replace PointValue"></span>
        
                                                                </span>
                                                            </div>
        
                                                        </div>
                                                    </div>
                                                    <div class="tbody wallet_PointList userAccount_Edit_MySelf" id="idPointList">
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </fieldset>
                            </div>
                            <!-- END OF 錢包管理 -->
                            <div class="wrapper_center fixed-Bottom col-12 btn-group-lg">
                                <button type="button" class="btn btn-outline-main" onclick="closePage(this)"><i class="icon icon-before icon-ewin-default-cancel"></i><span class="language_replace">取消</span></button>
                                <button type="button" class="btn btn-full-main" onclick="checkFormData()"><i class="icon icon-before icon-ewin-default-submit"></i><span class="language_replace">送出</span></button>
                            </div>
                        </div>
                    </div>



                </div>
            </div>
        </form>
    </main>

    <!-- popUp MessageBOX -->
    <!-- 
        popUp 出現 => class 加入show
        ==========================================
        mask_overlay_popup 遮罩按下時 popup會消失
        ==========================================
     -->
    <div class="popUp" id="idMessageBox">
        <div class="popUpWrapper">
            <div class="popUp__title" id="idMessageTitle">[Title]</div>
            <div class="popUp__content" id="idMessageText">
            </div>
            <div class="popUp__footer">
                <div class="form-group-popupBtn">
                    <button id="idMessageButtonCancel" type="button" class="btn btn-outline-main btn-popup-cancel" ><span class="language_replace">Cancel</span></button>
                    <button id="idMessageButtonOK" type="button" class="btn btn-full-main btn-popup-confirm" ><span class="language_replace">OK</span></button>
                </div> 
            </div>
        </div>
        <!-- mask_overlay 半透明遮罩-->
        <div id="mask_overlay_popup" class="mask_overlay_popup" onclick="MaskPopUp(this)"></div>
    </div>
    <div class="popUp " id="idPopUpMyQRCord">
        <div class="popUpWrapper">
            <div class="popUp__close btn btn-close" onclick="ac.closePopUp(this)"></div>
            <div class="popUp__title"><span class="language_replace">我的二維碼</span></div>
            <div class="popUp__content">
                <div class="sectionMyQRCord">
                    <!-- 帳號 -->
                    <div class="account__memberID">
                        <i class="icon icon-ewin-default-downlineuser icon-before"></i>
                        <div class="account__member">--</div>
                    </div>
                    <!-- 二維碼 -->
                    <div class="account__qrcode">
                        <div class="Img_qrCode"><img id="QRCodeimg" alt=""></div>
                    </div>
                    <!-- 我的推廣碼 -->
                    <div class="wrapper__myPromotionCode">
                        <span class="title">
                            <span class="language_replace">推廣碼</span>
                            </span>
                        <div class="content">
                            <span class="promotionCode">--</span>
                        <div class="wrapper__toast">
                            <!-- 按下時，出現 Toast元件-->
                            <button type="button" class="btn btn-transparent btn-copy" onclick="toastShow('promotionCode',PopUPtoastCopied)"><i class="icon icon-ewin-default-copy  icon-before"></i></button>
                            <!--Toast元件 要出現時 加入 class=> show -->
                            <div id="PopUPtoastCopied" class="toastCopied">
                            <span class="language_replace">已複製</span>
                            </div>
                        </div>
                        </div>
                    </div> 
                    <!-- 推廣連結按鈕 -->
                    <div class="urlLinkDiv">
                        <span class="spanUrlLink"></span>
                    </div>
                    <div class="wrapper__myPromotionLink">
                        <div class="PromotionLinkBtn" onclick="toastShow('spanUrlLink',PopUPtoastCopied2)">
                            <img src="Images/icon_urlLink.svg" alt="copy link">
                            <span class="language_replace">複製推廣連結</span>
                            <!--Toast元件 要出現時 加入 class=> show -->
                            <div id="PopUPtoastCopied2" class="toastCopied">
                                <span class="language_replace">已複製</span>
                            </div>
                        </div>
                    </div>
               </div> 
            </div>
        </div>
        <!-- mask_overlay 半透明遮罩-->
        <div id="mask_overlay_popup" class="mask_overlay_popup opacityAdj" onclick="ac.MaskPopUp(this)"></div>
    </div>
    <script>
        //TAB FLOW
        //上一步
        function previousStep(e) {
            var idStepContent = document.getElementById("idStepContent");
            var idstepFlows = document.getElementById("stepFlows");
            var step__listItem = document.getElementsByClassName("step__listItem");
            var data_step = e.dataset.step; //get TAB data-step 
            var myIndex = 0;

            // GET EACH TAB item
            var stepFlowItems = idstepFlows.querySelectorAll('.step__flow');

            for (var i = 0; i < stepFlowItems.length; i++) {
                stepFlowItems[i].classList.remove('active');
                stepFlowItems[i].setAttribute("aria-checked", "checking");
            }

            myIndex = parseInt(data_step) - 1;
            stepFlowItems[myIndex].classList.add('active');
            idStepContent.className = "dataList step__list step-" + parseInt(data_step);

            window.setTimeout(function () {
                setScreenToTop();
            }, 100)

        }

        //下一步
        function nextStep(e) {
            var idStepContent = document.getElementById("idStepContent");
            var idstepFlows = document.getElementById("stepFlows");
            var step__listItem = document.getElementsByClassName("step__listItem");
            var data_step = e.dataset.stepfinish; //get TAB data-step 

            // GET EACH TAB item
            var stepFlowItems = idstepFlows.querySelectorAll('.step__flow');
            var myIndex = 0;

            for (var i = 0; i < stepFlowItems.length; i++) {
                stepFlowItems[i].classList.remove('active');
                stepFlowItems[i].setAttribute("aria-checked", "checked");
            }

            myIndex = parseInt(data_step);
            stepFlowItems[myIndex].classList.add('active');
            stepFlowItems[myIndex].setAttribute("aria-checked", "checking");

            idStepContent.className = "dataList step__list step-" + (myIndex + 1);

            window.setTimeout(function () {
                setScreenToTop();
            }, 100)
        }

        function setScreenToTop() {
            var stepContent;
            var scrollTop = 0;

            stepContent = document.getElementsByClassName("step__content")[0];
            stepContent.scrollTo(0, 0);
        }

        function closePage() {
            if (window.parent.windowList.length > 1) {
                window.parent.API_CloseWindow(true);
            }
            else {
                if (r == "transfer") {
                    window.parent.API_MainWindow("Main", "UserAccountWallet_Transfer.aspx");
                }
                else {
                    window.parent.API_MainWindow("Main", "home.aspx");
                }
            }
        }

        // tab 切換 ===================================
        function tabSwitch(e, tabMainContent, tabItem, tabContent) {
            var tabMainContent = document.getElementById(tabMainContent);
            var tabItem = tabMainContent.getElementsByClassName(tabItem);
            var tabContent = tabMainContent.getElementsByClassName(tabContent);

            var data_toggle = e.dataset.toggle;
            var data_target = e.getAttribute("aria-controls");

            window.event.stopPropagation();
            window.event.preventDefault();

            for (var i = 0; i < tabItem.length; i++) {
                tabItem[i].classList.remove('active');
                tabItem[i].parentNode.classList.remove('active');
                tabItem[i].setAttribute("aria-selected", "false");

            }

            e.parentNode.classList.add('active');
            e.classList.add('active');
            e.setAttribute("aria-selected", "true");

            //TAB 內容==========================================

            for (var i = 0; i < tabContent.length; i++) {
                tabContent[i].classList.remove('show', 'active');
            }

            document.getElementById(data_target).classList.add('show', 'active');


            return false;
        }

        function showBox(title, msg, cbOK, cbCancel) {
            var idMessageBox = document.getElementById("idMessageBox");
            var idMessageTitle = document.getElementById("idMessageTitle");
            var idMessageText = document.getElementById("idMessageText");
            var idMessageButtonOK = document.getElementById("idMessageButtonOK");
            var idMessageButtonCancel = document.getElementById("idMessageButtonCancel");

            var funcOK = function () {
                c.removeClassName(idMessageBox, "show");

                if (cbOK != null)
                    cbOK();
            }

            var funcCancel = function () {
                c.removeClassName(idMessageBox, "show");

                if (cbCancel != null)
                    cbCancel();
            }

            if (idMessageTitle != null)
                idMessageTitle.innerHTML = title;

            //if (idMessageText != null)
            //   idMessageText.innerHTML = msg;

            if (idMessageButtonOK != null) {
                idMessageButtonOK.style.display = "";
                idMessageButtonOK.onclick = funcOK;
            }

            if (idMessageButtonCancel != null) {
                idMessageButtonCancel.style.display = "";
                idMessageButtonCancel.onclick = funcCancel;
            }

            c.addClassName(idMessageBox, "show");
        }

        //PopUP半透明遮罩
        function MaskPopUp(obj) {
            idMessageBox.classList.remove("show");
        }
       
        function toastShow(className,idToastCopied) {
            var TextRange = document.createRange();
            var sel;

            TextRange.selectNode(document.getElementsByClassName(className)[0]);
            sel = window.getSelection();
            sel.removeAllRanges();
            sel.addRange(TextRange);
            document.execCommand("copy");
            sel.removeAllRanges();
        // alert(idToastCopied.className);

        // Add the "show" class to DIV
        // toastCopied.className = "show";
        idToastCopied.classList.add("show");

        setTimeout(function () { idToastCopied.classList.remove("show"); }, 3000);

        }

    </script>
</body>
</html>
