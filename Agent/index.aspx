<%@ Page Language="C#" AutoEventWireup="true" CodeFile="index.aspx.cs" Inherits="index" %>

<%
    string DefaultCompany = Request["DefaultCompany"];
    string ASID = Request["ASID"];
    string LoginAccount = Request["LoginAccount"];
    string AgentURL = Request["AgentURL"];
    string Lang = Request["Lang"];
    string AgentVersion = EWinWeb.AgentVersion;
    string AlreadyHaveGameAccount = string.Empty;
    EWin.SpriteAgent.SpriteAgent api = new EWin.SpriteAgent.SpriteAgent();
    EWin.SpriteAgent.AgentSessionResult ASR = null;
    EWin.SpriteAgent.AgentSessionInfo ASI = null;
    EWin.SpriteAgent.UserAccountPropertyResult UPR = null;

    ASR = api.GetAgentSessionByID(ASID);

    if (ASR.Result !=  EWin.SpriteAgent.enumResult.OK) {
        if (string.IsNullOrEmpty(AgentURL) == true) {
            if (string.IsNullOrEmpty(DefaultCompany) == false) {
                Response.Redirect("login.aspx?C=" + DefaultCompany);
            } else {
                Response.Redirect("login.aspx");
            }
        } else {
            Response.Redirect(AgentURL);
        }
    } else {
        ASI = ASR.AgentSessionInfo;

        UPR = api.GetUserAccountProperty(ASID, System.Guid.NewGuid().ToString(), "AlreadyHaveGameAccount");

        if (UPR!=null && UPR.Result == EWin.SpriteAgent.enumResult.OK) {
            AlreadyHaveGameAccount = UPR.PropertyValue;
        }
    }
%>
<%="" %>
<!doctype html>
<html id="myHTML" lang="zh-Hant-TW" class="mainHtml">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <title>Lucky Sprite</title>
    <!-- <meta name="viewport" content="width=device-width, initial-scale=1.0, viewport-fit=cover"> -->
    <meta name="apple-mobile-web-app-capable" content="yes">
    <meta name="apple-touch-fullscreen" content="yes">
    <meta id="extViewportMeta" name="viewport" content="width=device-width, height=device-height, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no, viewport-fit=cover">

    <link rel="stylesheet" href="css/basic.min.css?<%:AgentVersion%>">
    <link rel="stylesheet" href="css/main2.css?<%:AgentVersion%>">

    <style type="text/css">
        :root {
            --sat: env(safe-area-inset-top);
            --sar: env(safe-area-inset-right);
            --sab: env(safe-area-inset-bottom);
            --sal: env(safe-area-inset-left);
        }
    </style>
</head>
<script type="text/javascript" src="/Scripts/Common.js"></script>
<script type="text/javascript" src="/Scripts/bignumber.min.js"></script>
<script type="text/javascript" src="/Scripts/Math.uuid.js"></script>
<script type="text/javascript" src="Scripts/MultiLanguage.js"></script>
<script type="text/javascript" src="/Scripts/qcode-decoder.min.js"></script>
<script type="text/javascript" src="/Scripts/qcode-decoder.min.js"></script>
<script type="text/javascript" src="js/AgentAPI.js"></script>
<script type="text/javascript" src="js/AppBridge.js"></script>
<script type="text/javascript" src="../Scripts/LobbyAPI.js"></script>
<script type="text/javascript" src="js/jquery-3.3.1.min.js"></script>
<script type="text/javascript">
    var AppBridge = new AppBridge("JsBridge", "iosJsBridge", "");
    var c = new common();
    var lang;
    var mlp;
    var qr = new QCodeDecoder();
    var api;
    var windowList = [];
    var apiUrl = "/API/AgentAPI.asmx";
    var qr = new QCodeDecoder();
    var firstLoad = true;
    var LastRequireWithdrawalID = 0;
    var oToastY;
    var toastTimer;
    var errCount = 0;
    var DeviceGUID = Math.uuid();
    var PushType = 0;
    var DeviceName = "";
    var DeviceKey = "";
    var DeviceType = "";
    var NotifyToken = "";
    var GPSPosition = "";
    var UserAgent = navigator.userAgent;
    var hasCryptoWallet = false;
    var AgentURL = "";
    var InAppMode = false;
    var AlreadyHaveGameAccount = "<%=AlreadyHaveGameAccount%>";
    var lobbyClient;

    var EWinInfo = {
        ASID: "<%=ASI.AgentSessionID%>",
        CompanyCode: "<%=ASI.CompanyCode%>",
        LoginType: <%=Convert.ToInt32(ASI.LoginType) %>,
        LoginAccount: "<%=ASI.LoginAccount%>",
        AgentAccount: "<%=ASI.AgentLoginAccount %>",
        MainCurrencyType: "<%=EWinWeb.MainCurrencyType %>",
        InAppMode: false,
        UserInfo: null,
        CompanyInfo: null,
        CurrencyType: null
    };

    function API_GetAgentAPI() {
        return api;
    }

    function API_GetLobbyAPI() {
        return lobbyClient;
    }

    function API_ShowMessage(title, msg, cbOK, cbCancel) {
        return showMessage(title, mlp.getLanguageKey(msg), cbOK, cbCancel);
    }

    function API_ShowMessageOK(title, msg, cbOK) {
        return showMessageOK(title, mlp.getLanguageKey(msg), cbOK);
    }

    function API_ShowToastMessage(msg) {
        return ShowToastMessage(mlp.getLanguageKey(msg));
    }

    function API_ShowLoading(showText) {
        return ShowLoading(mlp.getLanguageKey(showText));
    }

    function API_CloseLoading() {
        window.setTimeout(function () {
            return CloseLoading();
        }, 1000)
    }
    
    // 關閉最後一層視窗
    function API_CloseWindow(refreshLastWindow) {
        var o;
        var wc;

        if (windowList.length > 1) {
            wc = windowList[windowList.length - 1];
            o = wc.el;

            if (o) {
                document.getElementById("idPageMain").removeChild(o);
                delete o;
            }

            windowList.splice(windowList.length - 1, 1);
        }

        if (windowList.length > 1) {
            document.getElementById("idPreviousPage").style.display = "";
        }
        else {
            document.getElementById("idPreviousPage").style.display = "none";
        }

        refreshWindow(refreshLastWindow);
    }

    function API_CurrentWindow() {
        var o;
        var wc;

        if (windowList.length > 0) {
            if (windowList.length > 1) {
                wc = windowList[windowList.length - 1];
                o = wc.el;
            } else {
                wc = windowList[0];
                o = wc.el;
            }
        }

        return wc;
    }

    function API_NewWindow(title, src) {
        var wcExist = false;
        var btnDropDown;

        API_ShowLoading();
        function createInnerFrame(url) {
            var oDiv;
            var oDiv_InnerFrame;
            var idPageMain = document.getElementById("idPageMain");
            var rect;

            rect = idPageMain.getBoundingClientRect();

            oDiv = document.createElement("div");
            oDiv_InnerFrame = document.createElement("iframe");

            oDiv_InnerFrame.style.cssText = "overflow: auto; -webkit-overflow-scrolling:touch;";
            oDiv_InnerFrame.border = "0";
            oDiv_InnerFrame.frameBorder = "0";
            oDiv_InnerFrame.marginWidth = "0";
            oDiv_InnerFrame.marginHeight = "0";

            oDiv.appendChild(oDiv_InnerFrame);

            //oDiv.style.left = rect.left + "px";
            //oDiv.style.top = rect.top + "px";
            //oDiv.style.width = rect.width + "px";
            //oDiv.style.height = rect.height + "px";

            oDiv_InnerFrame.style.left = "0px";
            oDiv_InnerFrame.style.top = "0px";
            oDiv_InnerFrame.style.width = rect.width + "px";
            oDiv_InnerFrame.style.height = rect.height + "px";
            oDiv_InnerFrame.height = (document.body.clientHeight - 100) + "px"
            oDiv_InnerFrame.src = url;

            idPageMain.appendChild(oDiv);

            return oDiv;
        }

        if (windowList != null) {
            if (windowList.length > 0) {
                if (windowList[windowList.length - 1].title == title)
                    wcExist = true;
            }
        }

        if (wcExist == false) {
            // window not exist, create new
            var o = createInnerFrame(src);
            var windowClass = {
                title: title,
                el: o
            };
            windowList[windowList.length] = windowClass;
        }
        else {
            CloseLoading();
        }

        refreshWindow(false);

        //關閉DropDownBox
        btnDropDown = document.getElementsByClassName("btnDropDown");
        for (var i = 0; i < btnDropDown.length; i++) {
            if (btnDropDown[i].getAttribute("data-toggle") == "unDropDown") {
                dataToggleDropdown(btnDropDown[i]);
            }
        }

        if (windowList.length > 1) {
            document.getElementById("idPreviousPage").style.display = "";
        }
        else {
            document.getElementById("idPreviousPage").style.display = "none";
        }


    }

    // 改變主畫面url
    function API_MainWindow(title, url) {
        var o;
        var wc;
        var idPageMain = document.getElementById("idPageMain");
        var mask_overlay = document.getElementById("mask_overlay");

        API_ShowLoading();
        // 移除所有 Window
        if (windowList.length > 0) {
            for (var i = 0; i < windowList.length; i++) {
                wc = windowList[i];
                idPageMain.removeChild(wc.el);

                delete wc.el;
            }

            windowList.splice(0, windowList.length);
        }

        // 使用 NewWindow 產生主畫面
        API_NewWindow(title, url);

        //關閉側邊欄
        if (mask_overlay.classList.contains("open")) {
            maskOverlay(mask_overlay);
        }

    }

    function refreshWindow(reloadLastWindow) {
        var idPageMain = document.getElementById("idPageMain");
        var mainRect = idPageMain.getBoundingClientRect();

        for (i = 0; i < windowList.length; i++) {
            var wc = windowList[i];

            if (wc) {
                var d = getFrameDetail(wc);

                if (i == (windowList.length - 1)) {
                    title = wc.title;

                    if (d.div != null)
                        d.div.style.display = "block";

                    //d.div.style.left = mainRect.left + "px";
                    //d.div.style.top = mainRect.top + "px";
                    //d.div.style.width = mainRect.width + "px";
                    //d.div.style.height = mainRect.height + "px";


                    if (d.iframe != null) {
                        d.iframe.style.width = mainRect.width + "px";
                        d.iframe.style.height = mainRect.height + "px";

                        if (reloadLastWindow) {
                            d.iframe.contentWindow.location.reload(true);
                        } else {
                            if (d.iframe.contentWindow.EWinEventNotify) {
                                try { d.iframe.contentWindow.EWinEventNotify("WindowFocus", true, null); }
                                catch (ex) { }
                            }
                        }
                    }
                } else {
                    if (d.div != null) {
                        d.div.style.display = "none";
                    }
                }
            }
        }
    }

    function getFrameDetail(wc) {
        var ret = {
            div: null,
            iframe: null
        }

        if (wc != null) {
            if (wc.el != null) {
                var d = wc.el;

                if (d.tagName.toUpperCase() == "DIV") {
                    ret.div = d;

                    for (var i = 0; i < d.children.length; i++) {
                        if (d.children[i].tagName.toUpperCase() == "IFRAME") {
                            ret.iframe = d.children[i];
                            break;
                        }
                    }
                }
            }
        }

        return ret;
    }

    function notifyWindowEvent(eventName, o) {
        for (i = 0; i < windowList.length; i++) {
            var wc = windowList[i];

            if (wc) {
                var d = getFrameDetail(wc);

                if (d != null) {
                    if (d.iframe != null) {
                        if (d.iframe.contentWindow) {
                            if (d.iframe.contentWindow.EWinEventNotify) {
                                var isDisplay = false;

                                if (d.div.style.display == "block")
                                    isDisplay = true;

                                try { d.iframe.contentWindow.EWinEventNotify(eventName, isDisplay, o); }
                                catch (ex) { }
                            }
                        }
                    }
                }
            }
        }
    }

    function showMessage(title, msg, cbOK, cbCancel) {
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

        if (idMessageText != null)
            idMessageText.innerHTML = msg;

        if (idMessageButtonOK != null) {
            // idMessageButtonOK.style.display = "block";
            idMessageButtonOK.style.display = "";
            idMessageButtonOK.onclick = funcOK;
        }

        if (idMessageButtonCancel != null) {
            // idMessageButtonCancel.style.display = "block";
            idMessageButtonCancel.style.display = "";
            idMessageButtonCancel.onclick = funcCancel;
        }

        c.addClassName(idMessageBox, "show");
    }

    function ShowToastMessage(msg) {
        var toastProcessingDiv = document.getElementById("toastProcessingDiv");
        var toastMessage = c.getFirstClassElement(toastProcessingDiv, "toastMessage");

        toastMessage.innerHTML = msg;

        toastProcessingDiv.classList.add("show");
        toastProcessingDiv.ontouchstart = function (event) {
            oToastY = event.targetTouches[0].pageY;
        }
        toastProcessingDiv.ontouchmove = function (event) {
            var nToastY;

            nToastY = event.targetTouches[0].pageY;
            if (parseInt(nToastY) < parseInt(oToastY)) {
                toastProcessingDiv.classList.remove("show");
                toastProcessingDiv.classList.add("moveOut");

            }
        }

        window.setTimeout(function () {
            toastProcessingDiv.classList.remove("show");
            toastProcessingDiv.classList.add("moveOut");

        }, 5000);
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

    function showMessageOK(title, msg, cbOK) {
        var idMessageBox = document.getElementById("idMessageBox");
        var idMessageTitle = document.getElementById("idMessageTitle");
        var idMessageText = document.getElementById("idMessageText");
        var idMessageButtonOK = document.getElementById("idMessageButtonOK");
        var idMessageButtonCancel = document.getElementById("idMessageButtonCancel");

        //暫時找不到問題，先這樣處理

        if (msg) {
            var funcOK = function () {
                c.removeClassName(idMessageBox, "show");

                if (cbOK != null)
                    cbOK();
            }

            if (idMessageTitle != null)
                idMessageTitle.innerHTML = title;

            if (idMessageText != null)
                idMessageText.innerHTML = msg;

            if (idMessageButtonOK != null) {
                // idMessageButtonOK.style.display = "block";
                idMessageButtonOK.style.display = "";
                idMessageButtonOK.onclick = funcOK;
            }

            if (idMessageButtonCancel != null) {
                idMessageButtonCancel.style.display = "none";
            }

            c.addClassName(idMessageBox, "show");
        }
    }

    function getCompanyInfo(cb) {
        api.GetCompanyInfo(EWinInfo.ASID, Math.uuid(), function (success, o) {
            if (success) {
                if (o.ResultState == 0) {
                    EWinInfo.CompanyInfo = o;

                    if (cb != null)
                        cb(true);
                } else {
                    if (cb != null)
                        cb(false);
                }
            } else {
                if (cb != null)
                    cb(false);
            }
        });
    }

    function queryUserInfo(cb) {
        var toastDiv = document.getElementById("toastDiv");
        var CreateAccount = false;
        var CreateUserAccountAgent = false;
        var hasPay = false;
        var menuList = document.getElementById("idMenuList");
        var template;
        var menuItem;

        // 更入成功
        api.QueryUserInfo(EWinInfo.ASID, Math.uuid(), function (success, o) {

            if (success) {
                if (o.ResultState == 0) {
                    EWinInfo.UserInfo = o;

                    if (EWinInfo.UserInfo.WalletList) {
                        var removeArray = [];

                        for (var i = 0; i < EWinInfo.UserInfo.WalletList.length; i++) {
                            //if (EWinInfo.UserInfo.WalletList[i].PointState == 1 ) {
                            //    removeArray.push(i);
                            //}
                            if (EWinInfo.CompanyInfo.DefaultCurrencyType != EWinInfo.UserInfo.WalletList[i].CurrencyType) {
                                removeArray.push(i);
                            }
                        }

                        for (var i = 0; i < removeArray.length; i++) {
                            EWinInfo.UserInfo.WalletList.splice(removeArray[i], 1);
                        }
                    }

                    if (o.RequireWithdrawalCount > 0) {
                        //LastRequireWithdrawalID = 1;
                        if (LastRequireWithdrawalID != o.LastRequireWithdrawalID) {
                            LastRequireWithdrawalID = o.LastRequireWithdrawalID;
                            c.setClassText(toastDiv, "num", null, o.RequireWithdrawalCount);
                            toastDiv.classList.remove("moveOut");
                            toastDiv.classList.add("show");
                            toastDiv.ontouchstart = function (event) {
                                oToastY = event.targetTouches[0].pageY;
                                window.clearTimeout(toastTimer);
                            }
                            toastDiv.ontouchend = function () {
                                toastTimer = window.setTimeout(function () {
                                    toastDiv.classList.remove("show");
                                    toastDiv.classList.add("moveOut");
                                }, 5000);
                            }
                            toastDiv.ontouchmove = function (event) {
                                var nToastY;

                                nToastY = event.targetTouches[0].pageY;
                                if (parseInt(nToastY) < parseInt(oToastY)) {
                                    window.clearTimeout(toastTimer);
                                    toastDiv.classList.remove("show");
                                    toastDiv.classList.add("moveOut");

                                }
                            }
                            toastTimer = window.setTimeout(function () {
                                toastDiv.classList.remove("show");
                                toastDiv.classList.add("moveOut");
                            }, 5000);

                            //showMessageOK(mlp.getLanguageKey("提醒"), mlp.getLanguageKey("您有") + o.RequireWithdrawalCount + "個出款申請", function () {

                            //});

                        }

                    }
                    if (firstLoad == true) {
                        firstLoad = false;

                        //確認是否有區塊鏈錢包
                        if (o.WalletList) {
                            if (o.WalletList.length > 0) {
                                for (var i = 0; i < o.WalletList.length; i++) {
                                    if (o.WalletList[i].PointState == 0 && o.WalletList[i].ValueType == 2) {
                                        hasCryptoWallet = true;
                                        document.getElementById("idCryptoWallet").style.display = "";
                                        //document.getElementById("idCryptoWalletReport").style.display = "";

                                        break;
                                    }
                                }
                            }
                        }

                        //是否顯示推廣碼
                        switch (EWinInfo.UserInfo.UserAccountType) {
                            case 0:
                                if (EWinInfo.CompanyInfo.AllowQRCodeType0 == 1) {
                                    if (document.getElementById("idMyQRCode")) {
                                        document.getElementById("idMyQRCode").style.display = "";
                                    }

                                    if (document.getElementById("btnCreateAccount")) {
                                        document.getElementById("btnCreateAccount").style.display = "";
                                    }
                                }
                                break;
                            case 1:
                                if (EWinInfo.CompanyInfo.AllowQRCodeType1 == 1) {
                                    if (document.getElementById("idMyQRCode")) {
                                        document.getElementById("idMyQRCode").style.display = "";
                                    }

                                    if (document.getElementById("btnCreateAccount")) {
                                        document.getElementById("btnCreateAccount").style.display = "";
                                    }
                                }
                                break;
                            case 2:
                                if (EWinInfo.CompanyInfo.AllowQRCodeType2 == 1) {
                                    if (document.getElementById("idMyQRCode")) {
                                        document.getElementById("idMyQRCode").style.display = "";
                                    }

                                    if (document.getElementById("btnCreateAccount")) {
                                        document.getElementById("btnCreateAccount").style.display = "";
                                    }
                                }
                                break;
                        }

                        //確認是否為代理或股東
                        if (EWinInfo.UserInfo.UserAccountType == 1 || EWinInfo.UserInfo.UserAccountType == 2) {
                            if (document.getElementById("idCreateAccount")) {
                                if (EWinInfo.CompanyInfo.AgentCreateAccount == 1 || EWinInfo.CompanyInfo.AgentCreateAccount == 3) {
                                    if (document.getElementById("idCreateAccount")) {
                                        document.getElementById("idCreateAccount").style.display = "";
                                        CreateAccount = true;
                                    }
                                }
                            }

                            if (document.getElementById("idUserAccountAgent")) {
                                document.getElementById("idUserAccountAgent").style.display = "";
                            }

                            if (document.getElementById("idCreateUserAccountAgent")) {
                                document.getElementById("idCreateUserAccountAgent").style.display = "";
                                CreateUserAccountAgent = true;
                            }

                            //VIP 
                            //if (EWinInfo.UserInfo.CompanyClassID == 0) {
                            //if (document.getElementById("idAccountingByDate")) {
                            //    document.getElementById("idAccountingByDate").style.display = "";
                            //}

                            if (document.getElementById("idAgentAccounting")) {
                                document.getElementById("idAgentAccounting").style.display = "";
                            }

                            //}
                        }
                        else {
                            //階層
                            if (EWinInfo.UserInfo.CompanyClassID != 0) {
                                if (document.getElementById("idAccountingByDate")) {
                                    document.getElementById("idAccountingByDate").style.display = "";
                                }
                            }
                        }

                        if (CreateAccount == true || CreateUserAccountAgent == true) {
                            if (document.getElementById("btnCreateAccount")) {
                                document.getElementById("btnCreateAccount").style.display = "";
                            }
                        }

                        //動態報表
                        if (menuList) {
                            if (EWinInfo.CompanyInfo.ReportList) {
                                if (EWinInfo.CompanyInfo.ReportList.length > 0) {
                                    for (var i = 0; i < EWinInfo.CompanyInfo.ReportList.length; i++) {
                                        template = c.getTemplate("templateMenuItem");
                                        c.setClassText(template, "menuName", null, mlp.getLanguageKey(EWinInfo.CompanyInfo.ReportList[i].ReportName));

                                        menuItem = c.getFirstClassElement(template, "menuLink");
                                        menuItem.onclick = new Function("API_MainWindow(mlp.getLanguageKey('" + EWinInfo.CompanyInfo.ReportList[i].ReportName + "'), 'GetSQLReport.aspx?ReportName=" + encodeURIComponent(mlp.getLanguageKey(EWinInfo.CompanyInfo.ReportList[i].ReportName)) + "&ReportGUID=" + EWinInfo.CompanyInfo.ReportList[i].GUID + "');ItemClick(this);");

                                        menuList.appendChild(template);
                                    }
                                }
                            }
                        }                       
                    }

                }

                if (cb != null)
                    cb(true);
            } else {
                if (cb != null)
                    cb(false);
            }
        });
    }

    function updateBaseInfo() {

    }

    function searchInfo() {
        var idSearchInfo = document.getElementById("idSearchInfo");

        API_MainWindow(mlp.getLanguageKey('下線列表') + "_" + idSearchInfo.value, "UserAccount_Search_Casino.aspx");
    }
    
    function KeepAIDAndRefreshInfo(cb) {
        api.KeepAID(EWinInfo.ASID, Math.uuid(), function (success, o) {
            if (success == true) {
                if (o.ResultState == 0) {
                    getCompanyInfo(function (success) {
                        if (success) {
                            queryUserInfo(function (success) {
                                if (success) {
                                    if (cb != null) {
                                        cb(true);
                                    }
                                } else {
                                    if (cb != null) {
                                        cb(false);
                                    }
                                }
                            });
                        } else {
                            if (cb != null) {
                                cb(false);
                            }
                        }
                    });
                } else {
                    if (cb != null) {
                        cb(false);
                    }
                }
            }
        });
    }

    function LogOut() {
        API_ShowLoading("LogOut");
        EWinInfo = null;

        for (var i = 0; i < Object.keys(window.sessionStorage).length; i++) {
            var sessionStorageKeys = Object.keys(window.sessionStorage)[i];
            window.sessionStorage.removeItem(sessionStorageKeys);
        }

        window.top.location.href = "Refresh.aspx?login.aspx?C=<%=DefaultCompany%>";
    }

    function ItemClick(el) {
        var navitem = document.getElementsByClassName("nav-item");

        for (var i = 0; i < navitem.length; i++) {
            navitem[i].classList.remove("active");
        }

        el.parentNode.classList.add("active");
    }

    function CreateGameAccount() {
        var postObj;

        postObj = {
            AID: EWinInfo.ASID
        };

        c.callService("index.aspx/CreateGameAccount", postObj, function (success, o) {
            if (success) {
                var obj = c.getJSON(o);

                if (obj.Result == 0) {
                    API_ShowMessageOK(mlp.getLanguageKey("完成"), mlp.getLanguageKey("遊玩帳號")+" : "+obj.Message, function () {
                        $("#idCreateGameAccount").hide();
                        $("#liTrade").show();
                    })
                } else {
                    API_ShowMessageOK(mlp.getLanguageKey("錯誤"), obj.Message);
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

    function init() {
        lang = window.localStorage.getItem("agent_lang");

        mlp = new multiLanguage();

        mlp.loadLanguage(lang, function () {
            api = new AgentAPI(apiUrl);
            lobbyClient = new LobbyAPI("/API/LobbyAPI.asmx");
            
            getCompanyInfo(function (success) {
                if (success) {
                    queryUserInfo(function (success) {
                        if (success) {
                            API_MainWindow("Main", "home_Casino.aspx");
                        }                        
                    });                        
                 }
            });

            if (AlreadyHaveGameAccount == "") {
                $("#idCreateGameAccount").show();
                $("#liTrade").hide();
            } else {
                $("#idCreateGameAccount").hide();
                $("#liTrade").show();
            }

            window.setInterval(function () {
                if (EWinInfo.ASID != null && EWinInfo.ASID != "") {
                    getCompanyInfo(function (success) {
                        if (success) {
                            queryUserInfo(function (success) {
                                if (success) {

                                } else {
                                    window.top.location.href = "Refresh.aspx?login.aspx?C=<%=DefaultCompany%>";
                                }
                            });
                        } else {
                            window.top.location.href = "Refresh.aspx?login.aspx?C=<%=DefaultCompany%>";
                        }
                    });
                } else {
                    window.top.location.href = "Refresh.aspx?login.aspx?C=<%=DefaultCompany%>";
                }
            }, 60000);
            
            window.setInterval(function () {
                if (EWinInfo.ASID != null && EWinInfo.ASID != "") {
                    api.KeepAID(EWinInfo.ASID, Math.uuid(), function (success, o) {
                        if (success == true) {
                            if (o.ResultState == 0) {

                            } else {
                                window.top.location.href = "Refresh.aspx?login.aspx?C=<%=DefaultCompany%>";
                            }
                        }
                    });
                } else {
                    window.top.location.href = "Refresh.aspx?login.aspx?C=<%=DefaultCompany%>";
                }
            }, 10000);

            if (AppBridge) {
                if (AppBridge.config.inAPP == true) {
                    EWinInfo.InAppMode = true;
                    InAppMode = true;
                    AppBridge.SetDataByKey("CompanyCode", EWinInfo.CompanyCode);
                    AppBridge.getMobileInfo(function (deviceType, deviceName, systemInfo, ID, version) {
                        switch (systemInfo.split("_")[0].toUpperCase()) {
                            case "IOS":
                                DeviceType = "IOS";
                                break;
                            case "ANDROID":
                                DeviceType = "ANDROID";
                                break;
                            default:
                                DeviceType = "PC";
                                break;

                        }

                        resize();
                    })


                    AppBridge.getPhoneAllData(function (retInfo) {
                        DeviceName = retInfo.deviceName;
                        DeviceKey = retInfo.uuid;
                        NotifyToken = retInfo.token;
                        GPSPosition = retInfo.longitude + "," + retInfo.latitude;

                        //0 = None, 1 = FCM, 2 = JPush
                        PushType = 1;
                        if (retInfo.token == "") {
                            PushType = 2;
                        }

                        //0=未知/1=PC/2=Mobile

                        if (window.localStorage.getItem("UpdateDeviceInfo") == "false") {
                            api.UpdateDeviceInfo(EWinInfo.ASID, Math.uuid(), DeviceGUID, PushType, DeviceName, DeviceKey, 2, NotifyToken, GPSPosition, UserAgent, null);
                            window.localStorage.setItem("UpdateDeviceInfo", "true");
                        }
                    });
                }
                else {

                    if (window.localStorage.getItem("UpdateDeviceInfo") == "false") {
                        api.UpdateDeviceInfo(EWinInfo.ASID, Math.uuid(), DeviceGUID, PushType, DeviceName, DeviceKey, 1, NotifyToken, GPSPosition, UserAgent, null);
                        window.localStorage.setItem("UpdateDeviceInfo", "true");
                    }
                }
            }                     
        });

        resize();
    }

    function resize() {
        var idPageHeader = document.getElementById("idPageHeader");
        var idPageMain = document.getElementById("idPageMain");
        var scr;
        var sat;
        var sab;
        
        scr = c.getScreenSize();
        sat = getComputedStyle(document.documentElement).getPropertyValue("--sat");
        sab = getComputedStyle(document.documentElement).getPropertyValue("--sab");

        idPageMain.style.top = (idPageHeader.clientHeight + parseInt(sat)) + "px";
        idPageMain.style.height = (scr.height - idPageHeader.clientHeight - parseInt(sat) - parseInt(sab)) + "px";
        idPageMain.style.left = "0px";
        idPageMain.style.width = scr.width + "px";
        
        refreshWindow(false);
    }

    function showQRCode() {
        $('#QRCodeimg').attr("src", `/GetQRCode.aspx?QRCode=${EWinInfo.CompanyInfo.QRCodeURL}?PCode=${EWinInfo.UserInfo.PersonCode}&Download=2`);

        document.getElementsByClassName("account__member")[0].innerText = EWinInfo.UserInfo.LoginAccount
        document.getElementsByClassName("promotionCode")[0].innerText = EWinInfo.UserInfo.PersonCode;
        document.getElementsByClassName("spanUrlLink")[0].innerText = EWinInfo.CompanyInfo.QRCodeURL + "?PCode=" + EWinInfo.UserInfo.PersonCode;
        $("#idPopUpMyQRCord").addClass("show");
    }

    function closeQRCode() {
        $("#idPopUpMyQRCord").removeClass("show");
    }

    function toastShow(className, idToastCopied) {
        var TextRange = document.createRange();
        var sel;

        TextRange.selectNode(document.getElementsByClassName(className)[0]);
        sel = window.getSelection();
        sel.removeAllRanges();
        sel.addRange(TextRange);
        document.execCommand("copy");
        sel.removeAllRanges();

        idToastCopied.classList.add("show");

        setTimeout(function () { idToastCopied.classList.remove("show"); }, 3000);

    }

    window.onload = init;
    window.onresize = resize;
</script>

<body class="mainBody vertical-menu">
    <!--================Header Menu Area =================-->
    <header class="header_area" id="idPageHeader">
        <div class="main_menu">
            <nav class="navbar navbar-expand-xl">
                <!-- TOP Search-->
                <div class="container-fluid navbar__content">
                    <!-- ==========================================
                        當按下 MENU BUTTON 時 
                        1. aria-expanded="false" => aria-expanded="true""
                        2. Sidebar Menu 側邊選單  => class toggle "show" 
                        3. mask_overlay 黑色半透明遮罩 => class 加入 "open"，
                        當按下黑色半透明遮罩時 => class remove "open"
                        ==========================================
                    -->
                    <!--MENU BUTTON -->
                    <button onclick="dataToggleCollapse(this)" id="navbar_toggler" class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarMenu" aria-controls="navbarMenu" aria-expanded="false" aria-label="Toggle navigation">
                        <span class="icon-bar"></span>
                        <span class="icon-bar"></span>
                        <span class="icon-bar"></span>
                    </button>
                    <!-- Sidebar Menu 側邊選單-->
                    <div class="navbarMenu collapse navbar-menu navbar-collapse offset" id="navbarMenu">
                        <ul class="nav navbar-nav menu_nav no-gutters">
                            <li class="nav-item navbarMenu__catagory">
                                <span class="catagory-item"><span class="language_replace">團隊管理</span></span>
                                <ul class="catagory">
                                    <li class="nav-item submenu dropdown">
                                        <a class="nav-link" onclick="API_MainWindow(mlp.getLanguageKey('團隊會員'), 'UserAccount_Maint2_Casino.aspx');ItemClick(this);">
                                            <i class="icon icon-mask icon-ewin-user"></i>
                                            <span class="language_replace">會員</span></a>
                                    </li>
                                    <li class="nav-item submenu dropdown">
                                        <a class="nav-link" onclick="API_MainWindow(mlp.getLanguageKey('團隊代理'), 'UserAccountAgent_Maint2_Casino.aspx');ItemClick(this);">
                                            <i class="icon icon-mask icon-ewin-user"></i>
                                            <span class="language_replace">代理</span></a>
                                    </li>
                                    <li class="nav-item submenu dropdown">
                                        <a class="nav-link" onclick="API_MainWindow(mlp.getLanguageKey('下線列表'), 'UserAccount_Search_Casino.aspx?');ItemClick(this);">
                                            <i class="icon icon-mask icon-ewin-user"></i>
                                            <span class="language_replace">下線列表</span></a>
                                    </li>
                                </ul>
                            </li>
                            <li class="nav-item navbarMenu__catagory">
                                <span class="catagory-item"><span class="language_replace">數據查詢</span></span>
                                <ul class="catagory">
                                    <li class="nav-item submenu dropdown">
                                        <a class="nav-link" onclick="API_MainWindow(mlp.getLanguageKey('團隊投注數據'), 'GetAgentTotalSummary_Casino.aspx');ItemClick(this);">
                                            <i class="icon icon-mask icon-ewin-assisant"></i>
                                            <span class="language_replace">團隊投注數據</span></a>
                                    </li>
                                    <li class="nav-item submenu dropdown">
                                        <a class="nav-link" onclick="API_MainWindow(mlp.getLanguageKey('會員投注數據'), 'GetPlayerTotalSummary_Casino.aspx');ItemClick(this);">
                                            <i class="icon icon-mask icon-ewin-assisant"></i>
                                            <span class="language_replace">會員投注數據</span></a>
                                    </li>
                                    <li class="nav-item submenu dropdown">
                                        <a class="nav-link" onclick="API_MainWindow(mlp.getLanguageKey('團隊出入金數據'), 'GetAgentTotalDepositeSummary_Casino.aspx');ItemClick(this);">
                                            <i class="icon icon-mask icon-ewin-assisant"></i>
                                            <span class="language_replace">團隊出入金數據</span></a>
                                    </li>
                                    <li class="nav-item submenu dropdown">
                                        <a class="nav-link" onclick="API_MainWindow(mlp.getLanguageKey('會員出入金數據'), 'GetPlayerTotalDepositSummary_Casino.aspx');ItemClick(this);">
                                            <i class="icon icon-mask icon-ewin-assisant"></i>
                                            <span class="language_replace">會員出入金數據</span></a>
                                    </li>
                                </ul>
                            </li>
                            <li class="nav-item navbarMenu__catagory">
                                <span class="catagory-item"><span class="language_replace">結算查詢</span></span>
                                <ul class="catagory">
                                    <li class="nav-item submenu dropdown">
                                        <a class="nav-link" onclick="API_MainWindow(mlp.getLanguageKey('傭金結算查詢'), 'GetAgentAccounting_Casino.aspx');ItemClick(this);">
                                            <i class="icon icon-mask icon-ewin-assisant"></i>
                                            <span class="language_replace">傭金結算查詢</span></a>
                                    </li>
                                    <li class="nav-item submenu dropdown">
                                        <a class="nav-link" onclick="API_MainWindow(mlp.getLanguageKey('設定錢包密碼'), 'SetWalletPassword.aspx');ItemClick(this);">
                                            <i class="icon icon-mask icon-ewin-transfer"></i>
                                            <span class="language_replace">設定錢包密碼</span></a>
                                    </li>
                                      <li class="nav-item submenu dropdown">
                                        <a class="nav-link" onclick="API_MainWindow(mlp.getLanguageKey('設定出款卡'), 'BankCard_Maint.aspx');ItemClick(this);">
                                            <i class="icon icon-mask icon-ewin-transfer"></i>
                                            <span class="language_replace">設定出款卡</span></a>
                                    </li>
                                </ul>
                            </li>
                            <li class="nav-item navbarMenu__catagory" id="liTrade" style="display:none">
                                <span class="catagory-item"><span class="language_replace">交易</span></span>
                                <ul class="catagory">
                                    <li class="nav-item submenu dropdown" id="btnWithdrawal" style="display:none">
                                        <a class="nav-link"<%-- onclick="API_MainWindow(mlp.getLanguageKey('出款'), 'UserAccount_Maint2_Casino.aspx');ItemClick(this);"--%>>
                                            <i class="icon icon-mask icon-ewin-transfer"></i>
                                            <span class="language_replace">出款</span></a>
                                    </li>
                                    <li class="nav-item submenu dropdown" id="btnTransfer">
                                        <a class="nav-link" onclick="API_MainWindow(mlp.getLanguageKey('轉帳至遊戲帳戶'), 'UserAccountWallet_Transfer.aspx');ItemClick(this);">
                                            <i class="icon icon-mask icon-ewin-transfer"></i>
                                            <span class="language_replace">轉帳至遊戲帳戶</span></a>
                                    </li>
                                </ul>
                            </li>
                            <li class="nav-item submenu dropdown">
                                <a class="nav-link" onclick="LogOut()">
                                    <i class="icon icon-mask icon-ewin-logout"></i>
                                    <span class="language_replace">登出</span></a>
                            </li>
                        </ul>
                    </div>

                    <!-- 頂部 NavBar -->
                    <!-- <div class="collapse navbar-collapse"> -->
                    <div class="header_topNavBar">
                        <!-- Header 左上角-->
                        <div class="header_leftWrapper navbar-nav">
                            <div class="header_home">

                                <ul class="nav">
                                    <li id="idPreviousPage" class="navbar-prevpage nav-item submenu dropdown">
                                        <a onclick="API_CloseWindow(false)" class="icon icon2020-ico-goright btn btn-prevpage btn-round nav-link" role="button"></a>
                                    </li>
                                    <li class="navbar-home nav-item submenu dropdown">
                                        <a onclick="API_MainWindow('Main', 'home_Casino.aspx');" class="icon icon2020-home-o btn btn-home btn-round nav-link" role="button" target="mainiframe"></a>
                                    </li>
                                </ul>

                            </div>

                        </div>
                        <!-- Header 右上角-->
                        <div class="header_rightWrapper">
                            <!-- TOP RIGITSide BUTTON 右上按鈕群組-->
                            <div class="header_loginInUser">
                                <div class="offset">
                                    <ul class="nav">
                                        
                                        <li id="idSearchButton" class="navbar-search nav-item ">
                                            <a href="#" class="btn btn-search btn-round nav-link" role="button" onclick="API_NewWindow(mlp.getLanguageKey('下線列表'), 'UserAccount_Search_Casino.aspx?');"></a>
                                        </li>

                                        <li id="btnCreateAccount" class="navbar-member nav-item submenu dropdown" style="display: none">
                                            <!-- 下拉 MEMBER LINK -->
                                            <a href="#" onclick="dataToggleDropdown(this)" class="btn btn-user btn-round nav-link btnDropDown" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false" id=""></a>
                                            <!--下拉 dropdown-menu 選單 -->
                                            <ul class="dropdown-menu" aria-labelledby="navbar_Member">
                                                <li id="idCreateAccount" class="nav-item" style="display: none">
                                                    <a class="nav-link icon icon-ewin-default-n-user-add language_replace " onclick="API_NewWindow(mlp.getLanguageKey('新增下線'), 'UserAccount_Add_Casino.aspx')" target="mainiframe">新增下線</a>
                                                </li>
                                                <li id="idMyQRCode" class="nav-item">
                                                    <a class="nav-link icon icon-ewin-default-myQrCode language_replace" onclick="showQRCode()" target="mainiframe">我的推廣碼</a>
                                                </li>
                                                <li id="idCreateGameAccount" class="nav-item" style="display:none">
                                                    <a class="nav-link icon icon-ewin-default-myQrCode language_replace" onclick="CreateGameAccount()" target="mainiframe">新增遊玩帳號</a>
                                                </li>
                                            </ul>
                                        </li>
                                        <li class="navbar-notify nav-item" style="display: none;">
                                            <a href="#" class="btn btn-notify btn-round nav-link" role="button"></a>
                                            <!-- 數字顯示 -->
                                            <!-- <span class="notify-num">99</span> -->
                                            <!-- 小點點顯示 -->
                                            <span class="notify">
                                                <span class="notify-dot"></span>
                                            </span>
                                        </li>
                                    </ul>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </nav>
        </div>

        <!-- mask_overlay 黑色半透明遮罩-->
        <div id="mask_overlay" class="mask_overlay" onclick="maskOverlay(this)"></div>
    </header>
    <div class="main_area" id="idPageMain" style="position: fixed">
        <!-- <div class="main_area" id="idPageMain" style=""> -->
    </div>

    <div class="popUp " id="idPopUpMyQRCord">
        <div class="popUpWrapper">
            <div class="popUp__close btn btn-close" onclick="closeQRCode()"></div>
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

    <div id="templateMenuItem" style="display: none">
        <li class="nav-item submenu dropdown">
            <a class="nav-link menuLink" onclick="">
                <!-- <i class="icon icon2020-coin"></i> -->
                <i class="icon icon-mask icon-ewin-report-income-daily"></i>
                <span class="language_replace menuName">--</span></a>
        </li>
    </div>
    <div class="toast" id="toastProcessingDiv">
        <div class="toast__content">
            <span class="language_replace toastMessage"></span>
            <%--<span class="icon-go"><i class="icon icon-ewin-default-toast-arrow"></i></span>--%>
        </div>
    </div>

    <!-- popUp 下拉視窗 -->
    <!-- 
        popUp 出現 => class 加入show
        ==========================================
        mask_overlay_popup 遮罩按下時 popup會消失
        ==========================================
     -->
    
    <!-- 預設 radio button 樣式 ============-->
    <div class="popUp" id="divDropdownBox">
        <div id="templateDropdownBox" style="display: none">
            <div id="templateDropdownItem">
                <div class="form-group form-line">
                    <div class="custom-control custom-radioValue-check custom-control-inline">
                        <label class="custom-label">
                            <input type="radio" name="currencyexchange" class="custom-control-input-hidden inputRadio">
                            <div class="custom-input radio-button"><span class="currency title">HKT</span><span class="number desc">132,569</span></div>
                        </label>
                    </div>
                </div>
            </div>
        </div>
        <div class="popUpWrapper">
            <div class="popUp__close btn btn-close" id="divDropdownCancel"></div>
            <div class="popUp__title" id="divDropdownTitle">[Title]</div>
            <div class="popUp__content" id="divDropdownList">
            </div>
        </div>
        <div id="mask_overlay_popup" class="mask_overlay_popup" onclick="MaskPopUp(this)"></div>
    </div>

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
                [Msg]
            </div>
            <div class="popUp__footer">
                <div class="form-group-popupBtn">
                    <div class="btn btn-popup-cancel" id="idMessageButtonCancel">Cancel</div>
                    <div class="btn btn-popup-confirm" id="idMessageButtonOK">OK</div>
                </div>
            </div>

        </div>
        <!-- mask_overlay 半透明遮罩-->
        <div id="mask_overlay_popup" class="mask_overlay_popup"></div>
    </div>

    <!--===========JS========-->
    <script>
        var navbarMenu = document.getElementById("navbarMenu");
        var mask_overlay = document.getElementById("mask_overlay");
        var navbartoggler = document.getElementById("navbar_toggler");
        var data_toggle = null;
        var divDropdownBox = document.getElementById("divDropdownBox");
        var idMessageBox = document.getElementById("idMessageBox");

        // Collapse 摺疊切換 ======================== 
        function dataToggleCollapse(Obj) {

            data_toggle = Obj.dataset.toggle; //get data-toggle
            var data_target = Obj.dataset.target; //get data-target
            var aria_Expanded = Obj.getAttribute("aria-expanded");

            if (data_toggle == "collapse") {

                var data_targetRet = data_target.replace('#', '');

                // Target Content to collapse
                var collapseTargetContent = document.getElementById(data_targetRet);

                collapseTargetContent.classList.toggle("show");


                // Collapse Button Setting 
                if (aria_Expanded == 'false') {
                    Obj.setAttribute("aria-expanded", "true");
                }

                if (aria_Expanded == 'true') {
                    Obj.setAttribute("aria-expanded", "false");
                }


                //側邊選單切換
                if (data_targetRet == "navbarMenu") {

                    // navbartogglerToggle();
                    mask_overlay.classList.toggle("open");

                }

            }
            else {
                // console.log("no collapse");
            }

        }


        // 下拉選單切換
        function dataToggleDropdown(Obj) {

            var data_toggle = Obj.dataset.toggle;

            if (data_toggle == "dropdown") {

                // console.log(Obj.nextElementSibling.className);
                Obj.nextElementSibling.classList.toggle("show");
                mask_overlay.classList.toggle("open");
                Obj.dataset.toggle = "unDropDown";
            }
            else if (data_toggle == "unDropDown") {
                Obj.nextElementSibling.classList.remove("show");
                if (mask_overlay.classList.contains("open")) {
                    maskOverlay(mask_overlay);
                }
                Obj.dataset.toggle = "dropdown";
            }
            else {
                // console.log("no dropdown");
            }

        }

        // 黑色半透明遮罩
        function maskOverlay(obj) {
            var btnDropDown = document.getElementsByClassName("btnDropDown");

            if (obj.classList.contains("open")) {
                mask_overlay.classList.remove("open");
            }
            else {
                mask_overlay.classList.add("open");
            }

            //關閉側邊欄
            navbarMenu.classList.remove("show");
            navbartoggler.setAttribute("aria-expanded", "false");


            // 下拉選單關閉
            var els = document.querySelectorAll('.dropdown-menu.show');
            for (var i = 0; i < els.length; i++) {
                els[i].classList.remove('show');
                btnDropDown[i].setAttribute("data-toggle", "dropdown");
            }

        }

        //PopUP半透明遮罩
        function MaskPopUp(obj) {
            divDropdownBox.classList.remove("show");
            idMessageBox.classList.remove("show");
        }

        //Open FullSearch Bar
        function openFullSearch(e) {
            var header_SearchFull = document.getElementById("header_SearchFull");
            header_SearchFull.classList.add("open");
        }

        //Close FullSearch Bar
        function closeFullSearch(e) {
            var header_SearchFull = document.getElementById("header_SearchFull");
            if (header_SearchFull.classList.contains("open")) {
                header_SearchFull.classList.remove("open");
            }

        }
    </script>
</body>
</html>
