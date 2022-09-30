<%@ Page Language="C#" %>

<%

    string Token;
    int RValue;
    Random R = new Random();
    string Lang = "CHT";
    string SID = string.Empty;
    string CT = string.Empty;
    int RegisterType;
    int RegisterParentPersonCode;
    string Version = EWinWeb.Version;

    if (string.IsNullOrEmpty(Request["SID"]) == false)
    {
        SID = Request["SID"];
    }


    if (string.IsNullOrEmpty(Request["CT"]) == false)
        CT = Request["CT"];

    EWin.Lobby.LobbyAPI lobbyAPI = new EWin.Lobby.LobbyAPI();

    RValue = R.Next(100000, 9999999);
    Token = EWinWeb.CreateToken(EWinWeb.PrivateKey, EWinWeb.APIKey, RValue.ToString());
    var CompanySite = lobbyAPI.GetCompanySite(Token, Guid.NewGuid().ToString());

    RegisterType = CompanySite.RegisterType;
    RegisterParentPersonCode = CompanySite.RegisterParentPersonCode;
    if (string.IsNullOrEmpty(Request["Lang"]))
    {
        string userLang = CodingControl.GetDefaultLanguage();

        if (userLang.ToUpper() == "zh-TW".ToUpper())
        {
            Lang = "CHT";
        }
        else if (userLang.ToUpper() == "zh-HK".ToUpper())
        {
            Lang = "CHT";
        }
        else if (userLang.ToUpper() == "zh-MO".ToUpper())
        {
            Lang = "CHT";
        }
        else if (userLang.ToUpper() == "zh-CHT".ToUpper())
        {
            Lang = "CHT";
        }
        else if (userLang.ToUpper() == "zh-CHS".ToUpper())
        {
            Lang = "CHT";
        }
        else if (userLang.ToUpper() == "zh-SG".ToUpper())
        {
            Lang = "CHT";
        }
        else if (userLang.ToUpper() == "zh-CN".ToUpper())
        {
            Lang = "CHT";
        }
        else if (userLang.ToUpper() == "zh".ToUpper())
        {
            Lang = "CHT";
        }
        else if (userLang.ToUpper() == "en-US".ToUpper())
        {
            Lang = "JPN";
        }
        else if (userLang.ToUpper() == "en-CA".ToUpper())
        {
            Lang = "JPN";
        }
        else if (userLang.ToUpper() == "en-PH".ToUpper())
        {
            Lang = "JPN";
        }
        else if (userLang.ToUpper() == "en".ToUpper())
        {
            Lang = "JPN";
        }
        else if (userLang.ToUpper() == "ko-KR".ToUpper())
        {
            Lang = "JPN";
        }
        else if (userLang.ToUpper() == "ko-KP".ToUpper())
        {
            Lang = "JPN";
        }
        else if (userLang.ToUpper() == "ko".ToUpper())
        {
            Lang = "JPN";
        }
        else if (userLang.ToUpper() == "ja".ToUpper())
        {
            Lang = "JPN";
        }
        else { Lang = "JPN"; }
    }
    else
    {
        Lang = Request["Lang"];
    }

%>
<!doctype html>
<html id="myHTML" lang="zh-Hant-TW" class="mainHtml">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=0">

    <title>マハラジャ - 一番人気なオンラインカジノアミューズメント</title>
    <%--<title>Maharaja，The most popular online casino amusement.</title>--%>

    <meta name='keywords' content="カジノ、スロット、アミューズメント、ゲーム、ギャンブル" />
    <meta name='description' content="知名なオンラインゲームブランドを提携し、信頼価値もあるし、それにすぐ遊べることができます。お金の無駄遣いをせずに、今すぐサイトを登録して、ゲーム開始！" />
    <%--<meta name='keywords' content="Casino、Slot、Amusement、Game" />
    <meta name='description' content="We have partnered with well-known online game brands, and they are reliable and ready to play. Register your site now and start the game without wasting money!" />--%>

    <meta property="og:site_name" content="マハラジャ" />
    <%--<meta property="og:site_name" content="Maharaja" />--%>

    <meta property="og:title" content="一番人気なオンラインカジノアミューズメント - マハラジャ" />
    <meta property="og:Keyword" content="カジノ、スロット、アミューズメント、ゲーム、ギャンブル" />
    <meta property="og:description" content="知名なオンラインゲームブランドを提携し、信頼価値もあるし、それにすぐ遊べることができます。お金の無駄遣いをせずに、今すぐサイトを登録して、ゲーム開始！" />
    <%--<meta property="og:title" content="The most popular online casino amusement." />
    <meta property="og:Keyword" content="Casino、Slot、Amusement、Game" />
    <meta property="og:description" content="We have partnered with well-known online game brands, and they are reliable and ready to play. Register your site now and start the game without wasting money!" />--%>

    <meta property="og:url" content="https://casino-maharaja.com/" />
    <!--日文圖片-->
    <meta property="og:image" content="https://casino-maharaja.com/images/share_pic.png" />
    <!--英文圖片-->
    <%--<meta property="og:image" content="https://casino-maharaja.com/images/share_pic_en.png" />--%>
    <meta property="og:type" content="website" />
    <!-- Share image -->
    <!--日文圖片-->
    <link rel="image_src" href="https://casino-maharaja.com/images/share_pic.png">
    <!--英文圖片-->
    <%--<link rel="image_src" href="https://casino-maharaja.com/images/share_pic_en.png">--%>
    <link rel="shortcut icon" href="images/share_pic.png">
    <link rel="stylesheet" href="css/basic.min.css">
    <link rel="stylesheet" href="css/main.css?20220627">
    <link rel="alternate" hreflang="ja" href="https://casino-maharaja.com/index.aspx?Lang=JPN">
    <link rel="alternate" hreflang="ja-jp" href="https://casino-maharaja.com/index.aspx?Lang=JPN">
    <link rel="alternate" hreflang="zh-cn" href="https://casino-maharaja.com/index.aspx?Lang=CHT">
    <link rel="alternate" hreflang="zh-tw" href="https://casino-maharaja.com/index.aspx?Lang=CHT">
    <link rel="alternate" hreflang="zh" href="https://casino-maharaja.com/index.aspx?Lang=CHT">
    <link rel="alternate" hreflang="zh-hk" href="https://casino-maharaja.com/index.aspx?Lang=CHT">
    <style>
        .s-btn-more {
            border-radius: 20px;
            border: 1px solid #c0c0c0;
            padding: 10px 50px;
            width: fit-content;
            font-size: 14px;
            color: #666;
            text-decoration: none;
            cursor: pointer;
            margin: 20px auto;
        }
            .s-btn-more:hover {
                background-color: #ddd;
                border: 1px solid #666;
            }
            .s-btn-more:active {
                background-color: #ddd;
                border: 1px solid #666;
            }
            .s-btn-more:visited {
                background-color: #ddd;
                border: 1px solid #666;
                color: #777;
            }
    </style>
</head>
<% if (EWinWeb.IsTestSite == false)
    { %>
<!-- Global site tag (gtag.js) - Google Analytics -->
<script async src="https://www.googletagmanager.com/gtag/js?id=G-WRNSR38PQ7"></script>
<script>
    window.dataLayer = window.dataLayer || [];
    function gtag() { dataLayer.push(arguments); }
    gtag('js', new Date());

    gtag('config', 'G-097DC2GB6H');
</script>
<% } %>
<script
    src="https://code.jquery.com/jquery-2.2.4.js"
    integrity="sha256-iT6Q9iMJYuQiMWNd9lDyBUStIq/8PuOW33aOqmvFpqI="
    crossorigin="anonymous"></script>
<script type="text/javascript" src="/Scripts/PaymentAPI.js?<%:Version%>"></script>
<script type="text/javascript" src="Scripts/popper.min.js"></script>
<script type="text/javascript" src="/Scripts/LobbyAPI.js?<%:Version%>"></script>
<script src="Scripts/jquery-3.3.1.min.js"></script>
<script src="Scripts/vendor/bootstrap/bootstrap.min.js"></script>
<script type="text/javascript" src="/Scripts/Common.js"></script>
<script type="text/javascript" src="/Scripts/UIControl.js"></script>
<script type="text/javascript" src="/Scripts/MultiLanguage.js"></script>
<script type="text/javascript" src="/Scripts/Math.uuid.js"></script>
<script src="Scripts/vendor/swiper/js/swiper-bundle.min.js"></script>
<script type="text/javascript" src="/Scripts/bignumber.min.js"></script>
<script type="text/javascript" src="/Scripts/GameCodeBridge.js"></script>
<script type="text/javascript" src="/Scripts/NoSleep.js"></script>
<script src="Scripts/lozad.min.js"></script>
<script type="text/javascript">
    //if (self != top) {
    //    window.parent.API_LoadingStart();
    //}
    var c = new common();
    var mlp;
    var mlpByGameCode;
    var mlpByGameBrand;
    var lobbyClient;
    var paymentClient;
    var needCheckLogin = false;
    var lastWalletList = null; // 記錄最後一次同步的錢包, 用來分析是否錢包有變動    
    var EWinWebInfo = {
        EWinUrl: "<%=EWinWeb.EWinUrl %>",
        EWinGameUrl: "<%=EWinWeb.EWinGameUrl %>",
        MainCurrencyType: "<%=EWinWeb.MainCurrencyType %>",
        RegisterCurrencyType: "<%=EWinWeb.RegisterCurrencyType %>",
        SID: "<%=SID%>",
        CT: "<%=CT%>",
        UserLogined: false,
        FirstLoaded: false,
        Lang: "<%=Lang%>",
        UserInfo: null,
        RegisterType: "<%=RegisterType%>",
        RegisterParentPersonCode: "<%=RegisterParentPersonCode%>",
        DeviceType: /Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.test(navigator.userAgent) ? 1 : 0,
        IsOpenGame: false
    };

    var noSleep;
    var selectedWallet = null;
    var v = "<%=Version%>";
    var GCB;
    var GameInfoModal;
    var MessageModal;
    var gameWindow;
    var LobbyGameList = {};
    var UserThisWeekTotalValidBetValueData = [];
    var SearchControll;

    //#region TOP API
    function API_GetGCB() {
        return GCB;
    }

    function API_GetWebInfo() {
        return EWinWebInfo;
    }

    function API_GetLang() {
        return EWinWebInfo.Lang;
    }

    function API_GetLobbyAPI() {
        return lobbyClient;
    }

    function API_SearchGameByBrand(gameBrand) {
        return SearchControll.searchGameByBrand(gameBrand);
    }

    function API_GetPaymentAPI() {
        return paymentClient;
    }


    function API_GetCurrency() {
        var selectedCurrency;

        if (selectedWallet) {
            selectedCurrency = selectedWallet.CurrencyType;
        } else {
            selectedCurrency = "";
        }

        return selectedCurrency;
    }

    // type = 0 , data = gameCode ;  type = 1 , data = gameBrand 
    function API_GetGameLang(lang, GameCode, cb) {
        GCB.GetByGameCode(GameCode, (GameCodeItem) => {
            var langText = null;

            if (GameCodeItem) {
                langText = GameCodeItem.Language.find(x => x.LanguageCode == lang) ? GameCodeItem.Language.find(x => x.LanguageCode == lang).DisplayText : "";
            }

            cb(langText);
        })
    }

    //打開熱門文章
    function API_OpenHotArticle() {
        openHotArticle();
    }

    function API_SetLogin(_SID, cb) {
        var sourceLogined = EWinWebInfo.UserLogined;
        checkUserLogin(_SID, function (logined) {
            updateBaseInfo();

            if (cb) {
                cb(logined);
            }

            if (sourceLogined == logined) {
                notifyWindowEvent("LoginState", logined);
            }
        });
    }

    // 強制登出
    function API_Logout(isRefresh) {
        EWinWebInfo.UserInfo = null;
        EWinWebInfo.UserLogined = false;
        window.sessionStorage.clear();
        delCookie("RecoverToken");
        delCookie("LoginAccount");
        delCookie("CT");
        delCookie("SID");

        if (isRefresh) {
            window.location.href = "Refresh.aspx?index.aspx";
        }
    }

    function API_RefreshUserInfo(cb) {
        checkUserLogin(EWinWebInfo.SID, function (logined) {
            updateBaseInfo();

            notifyWindowEvent("LoginState", logined);

            if (cb != null)
                cb();
        });
    }

    function API_RefreshPersonalFavo(gameCode, isAdded) {
        notifyWindowEvent("RefreshPersonalFavo", { GameCode: gameCode, IsAdded: isAdded });
    }

    function API_RefreshPersonalPlayed(gameCode, isAdded) {
        notifyWindowEvent("RefreshPersonalPlayed", { GameCode: gameCode, IsAdded: isAdded });
    }

    function API_LoadingStart() {
        $('.loader-container').show();
        $('.loader-backdrop').removeClass('is-show');
    }

    function API_LoadingEnd(type) {
        if ($('.loader-container').is(':visible')) {
            var iframeDom = document.getElementById("IFramePage").contentDocument;
            if (iframeDom) {
                if (type && type == 1) {

                } else {
                    var footerDom = c.getTemplate("footer");
                    var target = document.getElementById("IFramePage").contentDocument.body;
                    if (!target.querySelector("footer")) {
                        document.getElementById("IFramePage").contentDocument.body.appendChild(footerDom);
                    }                
                }
            }
            $('.loader-backdrop').addClass('is-show');
            $('.loader-container').fadeOut(250, function () {
                $('.iframe-container').addClass('is-show');
            });
        }
        
        //resize();
    }

    function API_LoadPage(title, url, checkLogined) {

        if (EWinWebInfo.IsOpenGame) {
            EWinWebInfo.IsOpenGame = false;
            var IFramePage = document.getElementById("GameIFramePage");
            IFramePage.src = "";

            //非滿版遊戲介面
            // $('#headerGameDetailContent').hide();
            // $('#GameIFramePage').hide();
            //非滿版遊戲介面 end

            //滿版遊戲介面
            $('#divGameFrame').css('display', 'none');
            //滿版遊戲介面 end
        }

        if ($('.header_menu').hasClass("show")) {
            $('.vertical-menu').toggleClass('navbar-show');
            $('.header_menu').toggleClass('show');
            $('#navbarMenu').collapse('hide');
            //$('.navbar-toggler').attr("aria-expanded", "false");
        }

        if (checkLogined) {
            if (!EWinWebInfo.UserLogined) {
                showMessageOK(mlp.getLanguageKey("尚未登入"), mlp.getLanguageKey("請先登入"), function () {
                    GameInfoModal.hide();
                    window.sessionStorage.setItem("SrcPage", url);
                    API_LoadPage("Login", "Login.aspx");
                });
                return;
            }
        }

        var IFramePage = document.getElementById("IFramePage");

        if (IFramePage != null) {

            // if (IFramePage.children.length > 0) {
            //var ifrm = IFramePage.children[0];

            if (IFramePage.tagName.toUpperCase() == "IFRAME".toUpperCase()) {
                //loadingStart();
                //上一頁針對iframe的問題，只能將loading的function都放於頁面中
                //API_LoadingStart(); 
                //IFramePage.style.height = "0px";
                IFramePage.src = url;
                IFramePage.onload = null;


                //IFramePage.
            }

        }
    }

    function API_Home() {
        //Game
        API_LoadPage("Home", "Home.aspx");
    }

    function API_Reload() {
        //Game
        window.location.reload();
    }

    function API_GetGameList(location) {
        return LobbyGameList;
    }

    function API_ShowMessage(title, msg, cbOK, cbCancel) {
        return showMessage(title, msg, cbOK, cbCancel);
    }

    function API_ShowMessageOK(title, msg, cbOK) {
        return showMessageOK(title, msg, cbOK);
    }

    function API_ShowSearchGameModel() {
        $('#alertSearch').modal('show');
    }

    function API_MobileDeviceGameInfo(brandName, RTP, gameName, GameID,GameLangName,GameCategoryCode) {
        return showMobileDeviceGameInfo(brandName, RTP, gameName, GameID,GameLangName,GameCategoryCode);
    }

    function API_ShowPartialHtml(title, pathName, isNeedLang, cbOK) {
        //return window.open(pathName);
        return showPartialHtml(title, pathName, isNeedLang, cbOK);
    }

    function API_changeAvatarImg(avatar) {
        if (avatar) {
            document.getElementById("idAvatarImg").src = "images/assets/avatar/" + avatar + ".jpg"
        }
    }

    function API_SendSerivceMail(subject, body, email) {
        lobbyClient.SendCSMail(EWinWebInfo.SID, Math.uuid(), email, subject, body, function (success, o) {
            if (success) {
                if (o.Result == 0) {
                    window.parent.showMessageOK(mlp.getLanguageKey("成功"), mlp.getLanguageKey("已成功通知客服，將回信至您輸入或註冊的信箱"));
                } else {
                    window.parent.showMessageOK(mlp.getLanguageKey("錯誤"), mlp.getLanguageKey(o.Message));
                }
            } else {
                if (o == "Timeout") {
                    window.parent.showMessageOK(mlp.getLanguageKey("錯誤"), mlp.getLanguageKey("網路異常, 請重新嘗試"));
                } else {
                    window.parent.showMessageOK(mlp.getLanguageKey("錯誤"), o);
                }
            }
        });
    }

    function API_ShowLoading() {
        $('.loader-container').show();
        $('.loader-backdrop').removeClass('is-show');
    }

    function API_CloseLoading() {
        $('.loader-backdrop').addClass('is-show');
        $('.loader-container').fadeOut(250, function () {
            $('.iframe-container').addClass('is-show');
        });
    }

    function API_ShowContactUs() {
        if (!EWinWebInfo.UserLogined) {
            showMessageOK(mlp.getLanguageKey("錯誤"), mlp.getLanguageKey("請先登入"), function () {
                API_LoadPage("Login", "Login.aspx");
            }, null);
        } else {
            return showContactUs();
        }
    }

    function API_NonCloseShowMessageOK(title, msg, cbOK) {
        return nonCloseShowMessageOK(title, msg, cbOK);
    }

    function API_ComingSoonAlert() {
        window.parent.API_ShowMessageOK("", "<p style='font-size:2em;text-align:center;margin:auto'>" + mlp.getLanguageKey("近期開放") + "</p>");
    }

    //取得當週期7日活動所需資訊
    function API_GetUserThisWeekTotalValidBetValue(cb) {

        //if (UserThisWeekTotalValidBetValueData.length == 0) {
        //    lobbyClient.GetUserAccountThisWeekTotalValidBetValueResult(EWinWebInfo.SID, Math.uuid(), function (success, o) {
        //        if (success) {
        //            if (o.Result == 0) {
        //                UserThisWeekTotalValidBetValueData = o.Datas;
        //                if (cb != null) {
        //                    cb(UserThisWeekTotalValidBetValueData);
        //                }
        //            } else {
        //                UserThisWeekTotalValidBetValueData = [];
        //            }
        //        } else {
        //            if (o == "Timeout") {
        //                window.parent.showMessageOK(mlp.getLanguageKey("錯誤"), mlp.getLanguageKey("網路異常, 請重新嘗試"));
        //            } else {
        //                window.parent.showMessageOK(mlp.getLanguageKey("錯誤"), o);
        //            }
        //        }
        //    });
        //} else {
        //    if (cb != null) {
        //        cb(UserThisWeekTotalValidBetValueData);
        //    }
        //}

        lobbyClient.GetUserAccountThisWeekTotalValidBetValueResult(EWinWebInfo.SID, Math.uuid(), function (success, o) {
            if (success) {
                if (o.Result == 0) {
                    UserThisWeekTotalValidBetValueData = o.Datas;
                     if (cb != null) {
                         cb(UserThisWeekTotalValidBetValueData);
                     }
                } else {
                    UserThisWeekTotalValidBetValueData = [];
                }
            } else {
                if (o == "Timeout") {
                    window.parent.showMessageOK(mlp.getLanguageKey("錯誤"), mlp.getLanguageKey("網路異常, 請重新嘗試"));
                } else {
                    window.parent.showMessageOK(mlp.getLanguageKey("錯誤"), o);
                }
            }
        });
        
    }

    function API_OpenGame(GameBrand, GameName, LangName) {
        openGame(GameBrand, GameName, LangName);
    }
    //#endregion

    //#region Alert
    function showMessage(title, message, cbOK, cbCancel) {
        if ($("#alertMsg").attr("aria-hidden") == 'true') {
            var divMessageBox = document.getElementById("alertMsg");
            var divMessageBoxCloseButton = divMessageBox.querySelector(".alertMsg_Close");
            var divMessageBoxOKButton = divMessageBox.querySelector(".alertMsg_OK");
            var divMessageBoxContent = divMessageBox.querySelector(".alertMsg_Text");

            if (MessageModal == null) {
                MessageModal = new bootstrap.Modal(divMessageBox, { backdrop: 'static', keyboard: false });
            }

            if (divMessageBox != null) {
                MessageModal.toggle();

                if (divMessageBoxCloseButton != null) {
                    divMessageBoxCloseButton.classList.remove("is-hide");
                    divMessageBoxCloseButton.onclick = function () {
                        MessageModal.hide();

                        if (cbCancel != null) {
                            cbCancel();
                        }
                    }
                }

                if (divMessageBoxOKButton != null) {

                    divMessageBoxOKButton.onclick = function () {
                        MessageModal.hide();

                        if (cbOK != null)
                            cbOK();
                    }
                }

                divMessageBoxContent.innerHTML = message;
            }
        }
    }

    function showMessageOK(title, message, cbOK) {
        if ($("#alertMsg").attr("aria-hidden") == 'true') {
            var divMessageBox = document.getElementById("alertMsg");
            var divMessageBoxCloseButton = divMessageBox.querySelector(".alertMsg_Close");
            var divMessageBoxOKButton = divMessageBox.querySelector(".alertMsg_OK");
            var divMessageBoxContent = divMessageBox.querySelector(".alertMsg_Text");

            if (MessageModal == null) {
                MessageModal = new bootstrap.Modal(divMessageBox, { backdrop: 'static', keyboard: false });
            }

            if (divMessageBox != null) {
                MessageModal.show();

                if (divMessageBoxCloseButton != null) {
                    divMessageBoxCloseButton.classList.add("is-hide");
                }

                if (divMessageBoxOKButton != null) {

                    divMessageBoxOKButton.onclick = function () {
                        MessageModal.hide();

                        if (cbOK != null)
                            cbOK();
                    }
                }

                divMessageBoxContent.innerHTML = message;
            }
        }
    }

    function showBoardMsg(title, message, time) {
        if ($("#alertBoardMsg").attr("aria-hidden") == 'true') {
            var divMessageBox = document.getElementById("alertBoardMsg");
            var divMessageBoxOKButton = divMessageBox.querySelector(".alert_OK");
            var divMessageBoxTitle = divMessageBox.querySelector(".alert_Title");
            var divMessageBoTime = divMessageBox.querySelector(".alert_Time");
            var divMessageBoxContent = divMessageBox.querySelector(".alert_Text");
            var modal = new bootstrap.Modal(divMessageBox, { backdrop: 'static', keyboard: false });

            if (divMessageBox != null) {
                modal.show();

                if (divMessageBoxOKButton != null) {

                    divMessageBoxOKButton.onclick = function () {
                        modal.hide();
                    }
                }

                divMessageBoxTitle.innerHTML = title;
                divMessageBoTime.innerHTML = time;
                divMessageBoxContent.innerHTML = message;
            }
        }
    }

    function nonCloseShowMessageOK(title, message, cbOK) {
        var nonCloseDom = $("#nonClose_alertContact");
        if (nonCloseDom.attr("aria-hidden") == 'true') {
            var divMessageBox = document.getElementById("nonClose_alertContact");
            var divMessageBoxCloseButton = divMessageBox.querySelector(".alertContact_Close");
            var divMessageBoxOKButton = divMessageBox.querySelector(".alertContact_OK");
            //var divMessageBoxTitle = divMessageBox.querySelector(".alertContact_Text");
            var divMessageBoxContent = divMessageBox.querySelector(".alertContact_Text");
            var nonCloseMessageModal = new bootstrap.Modal(divMessageBox, { backdrop: 'static', keyboard: false });

            if (divMessageBox != null) {
                nonCloseMessageModal.show();
                nonCloseDom.attr("aria-hidden", 'false');

                if (divMessageBoxCloseButton != null) {
                    divMessageBoxCloseButton.classList.add("is-hide");
                }

                if (divMessageBoxOKButton != null) {

                    divMessageBoxOKButton.onclick = function () {
                        nonCloseMessageModal.hide();
                        nonCloseDom.attr("aria-hidden", 'true');
                        if (cbOK != null)
                            cbOK();
                    }
                }

                divMessageBoxContent.innerHTML = message;
            }
        }
    }

    function WithCheckBoxShowMessageOK(title, message, cbOK) {
        var alertDom = $("#alertContactWithCheckBox")
        if (alertDom.attr("aria-hidden") == 'true') {
            var divMessageBox = document.getElementById("alertContactWithCheckBox");
            var divMessageBoxCloseButton = divMessageBox.querySelector(".alertContact_Close");
            var divMessageBoxOKButton = divMessageBox.querySelector(".alertContact_OK");
            var divMessageBoxTitle = divMessageBox.querySelector(".alert_Title");
            var divMessageBoxContent = divMessageBox.querySelector(".alertContact_Text");
            var checkBoxmessageModal;
            if (checkBoxmessageModal == null) {
                checkBoxmessageModal = new bootstrap.Modal(divMessageBox, { backdrop: 'static', keyboard: false });
            }

            if (divMessageBox != null) {
                checkBoxmessageModal.show();
                alertDom.attr("aria-hidden", 'false');

                if (divMessageBoxCloseButton != null) {
                    divMessageBoxCloseButton.classList.add("is-hide");
                }

                if (divMessageBoxOKButton != null) {
                    //divMessageBoxOKButton.style.display = "inline";

                    divMessageBoxOKButton.onclick = function () {
                        checkBoxmessageModal.hide();
                        alertDom.attr("aria-hidden", 'true');
                        if (cbOK != null)
                            cbOK();
                    }
                }

                divMessageBoxTitle.innerHTML = title;
                divMessageBoxContent.innerHTML = message;
            }
        }
    }
    //#endregion

    function showMobileDeviceGameInfo(brandName, RTP, gameName, GameID,GameLangName,GameCategoryCode) {
        var popupMoblieGameInfo = $('#popupMoblieGameInfo');
        var gameiteminfodetail = popupMoblieGameInfo[0].querySelector(".game-item-info-detail.open");
        var gameitemlink = popupMoblieGameInfo[0].querySelector(".game-item-link");
        var likebtn = popupMoblieGameInfo[0].querySelector(".btn-like");
        var playbtn = popupMoblieGameInfo[0].querySelector(".btn-play");
        var GI_img = popupMoblieGameInfo[0].querySelector(".imgsrc");
        var moreInfoitemcategory= popupMoblieGameInfo.find('.moreInfo-item.category').eq(0);
        var favoriteGames = [];
        var gamecode = brandName + "." + gameName;
        var _gameCategoryCode;

        switch (GameCategoryCode) {
            case "Electron":
                _gameCategoryCode = "elec";
                break;
            case "Live":
                _gameCategoryCode = "live";
                break;
            case "Slot":
                _gameCategoryCode = "slot";
                break;
            default:
                _gameCategoryCode = "etc";
                break;
        }

        popupMoblieGameInfo.find('.BrandName').text(brandName);
        popupMoblieGameInfo.find('.valueRTP').text(RTP);
        popupMoblieGameInfo.find('.GameID').text(GameID);
        if (true) {

        }
    
        moreInfoitemcategory.removeClass("slot");
        moreInfoitemcategory.removeClass("live");
        moreInfoitemcategory.removeClass("elec");
        moreInfoitemcategory.removeClass("etc");
        moreInfoitemcategory.addClass(_gameCategoryCode);
        popupMoblieGameInfo.find('.GameName').text(GameLangName);
        $('.headerGameName').text(GameLangName);
        
        gameitemlink.onclick = new Function("openGame('" + brandName + "', '" + gameName + "')");
        gameiteminfodetail.onclick = new Function("openGame('" + brandName + "', '" + gameName + "')");
        GCB.GetFavo(function (data) {
            favoriteGames.push(data);
        }, function (data) {
            if (favoriteGames.filter(e => e.GameCode === gamecode).length > 0) {
                $(likebtn).addClass("added");
            } else {
                $(likebtn).removeClass("added");
            }
        });

        likebtn.onclick = new Function("favBtnClick('" + brandName + "." + gameName + "')");

        if (GI_img != null) {
            GI_img.src = EWinWebInfo.EWinGameUrl + "/Files/GamePlatformPic/" + brandName + "/PC/" + EWinWebInfo.Lang + "/" + gameName + ".png";
            //var el = GI_img;
            //var observer = lozad(el); // passing a `NodeList` (e.g. `document.querySelectorAll()`) is also valid
            //observer.observe();
        }

        popupMoblieGameInfo.modal('show');
    }

    function showPartialHtml(title, pathName, isNeedLang, cbOK) {
        var realPath;
        var divMessageBox = document.getElementById("alertPartialHtml");
        var divMessageBoxOKButton = divMessageBox.querySelector(".alertPartialHtml_OK");
        var divMessageBoxTitle = divMessageBox.querySelector(".alertPartialHtml_Title");
        var divMessageBoxContent = divMessageBox.querySelector(".alertPartialHtml_Content");
        var modal = new bootstrap.Modal(divMessageBox);

        if (isNeedLang) {
            realPath = pathName + "_" + EWinWebInfo.Lang + ".html";
        } else {
            realPath = pathName + ".html";
        }

        if (divMessageBox != null) {
            if (divMessageBoxOKButton != null) {
                divMessageBoxOKButton.onclick = function () {
                    divMessageBoxContent.innerHTML = "";
                    modal.hide();

                    if (cbOK != null)
                        cbOK();
                }
            }

            divMessageBoxTitle.innerHTML = title;
            $(divMessageBoxContent).load(realPath);

            modal.toggle();
        }
    }

    function showContactUs() {
        var divMessageBox = document.getElementById("alertContactUs");
        var divMessageBoxCrossButton = divMessageBox.querySelector(".close");

        var modal = new bootstrap.Modal(divMessageBox);

        if (divMessageBox != null) {
            modal.toggle();
        }
    }

    function sendContactUs() {
        var contactUsDom = document.querySelector(".inbox_customerService");
        var subjectText = contactUsDom.querySelector(".contectUs_Subject").value;
        var emailText = contactUsDom.querySelector(".contectUs_Eamil").value;
        var bodyText = contactUsDom.querySelector(".contectUs_Body").value;
        var NickName = contactUsDom.querySelector(".contectUs_NickName").value;
        var Phone = contactUsDom.querySelector(".contectUs_Phone").value;

        API_SendSerivceMail(subjectText, "ニックネーム：" + NickName + "<br/>" + "携帯電話：" + Phone + "<br/>" + bodyText, emailText);
    }
    //#region Game
    function GameLoadPage(url, gameBrand, gameName) {
        var IFramePage = document.getElementById("GameIFramePage");

        if (IFramePage != null) {
            //非滿版遊戲介面
            // $('#headerGameDetailContent').show();
            // $('#GameIFramePage').show();
            //非滿版遊戲介面 end

            //滿版遊戲介面
            $('#divGameFrame').css('display', 'flex');
            //滿版遊戲介面 end

            //var showCloseGameTooltipCount = getCookie("showCloseGameTooltip");
            //if (showCloseGameTooltipCount == '') {
            //    showCloseGameTooltipCount = 0;
            //} else {
            //    showCloseGameTooltipCount = parseInt(showCloseGameTooltipCount);
            //}
            //if (showCloseGameTooltipCount < 3) {
            //    $('#closeGameBtn').tooltip('show');
            //    if (showCloseGameTooltipCount == 0) {
            //        setCookie("showCloseGameTooltip", 1, 365);
            //    } else {
            //        setCookie("showCloseGameTooltip", parseInt(showCloseGameTooltipCount) + 1, 365);
            //    }
            //}

            if (IFramePage.tagName.toUpperCase() == "IFRAME".toUpperCase()) {
                API_LoadingStart();

                setTimeout(function () {
                    API_LoadingEnd(1);
                }, 10000);

                IFramePage.src = url;
                IFramePage.onload = function () {
                    API_LoadingEnd(1);
                }
            }
        }
    }

    function setDefaultIcon(brand, name) {
        var img = event.currentTarget;
        img.onerror = null;
        img.src = EWinWebInfo.EWinGameUrl + "/Files/GamePlatformPic/" + brand + "/PC/" + EWinWebInfo.Lang + "/" + name + ".png";
    }

    function openGame(gameBrand, gameName, gameLangName) {
        var alertSearch = $("#alertSearch");
        var alertSearchCloseButton = $("#alertSearchCloseButton");
        var popupMoblieGameInfo = $('#popupMoblieGameInfo');
        //先關閉Game彈出視窗(如果存在)
        if (gameWindow) {
            gameWindow.close();
        }


        if (alertSearch.css("display") == "block") {
            alertSearchCloseButton.click();
        }
       
        if (!EWinWebInfo.UserLogined) {

            if (popupMoblieGameInfo) {
                popupMoblieGameInfo.modal('hide');
            }

            showMessageOK(mlp.getLanguageKey("錯誤"), mlp.getLanguageKey("請先登入"), function () {
                API_LoadPage("Login", "Login.aspx");
            }, null);
        } else {
            EWinWebInfo.IsOpenGame = true;
            GCB.AddPlayed(gameBrand + "." + gameName, function (success) {
                if (success) {
                    API_RefreshPersonalPlayed(gameBrand + "." + gameName, true);
                }
            });

            $('.headerGameName').text(gameLangName);

            if (gameBrand.toUpperCase() != "EWin".toUpperCase()) {
                if (EWinWebInfo.DeviceType == 1) {
                    gameWindow = window.open("/OpenGame.aspx?SID=" + EWinWebInfo.SID + "&Lang=" + EWinWebInfo.Lang + "&CurrencyType=" + API_GetCurrency() + "&GameBrand=" + gameBrand + "&GameName=" + gameName + "&HomeUrl=" + window.location.href, "Maharaja Game")
                } else {
                    GameLoadPage("/OpenGame.aspx?SID=" + EWinWebInfo.SID + "&Lang=" + EWinWebInfo.Lang + "&CurrencyType=" + API_GetCurrency() + "&GameBrand=" + gameBrand + "&GameName=" + gameName + "&HomeUrl=" + window.location.href);
                }
            } else {
                gameWindow = window.open("/OpenGame.aspx?SID=" + EWinWebInfo.SID + "&Lang=" + EWinWebInfo.Lang + "&CurrencyType=" + API_GetCurrency() + "&GameBrand=" + gameBrand + "&GameName=" + gameName + "&HomeUrl=" + window.location.href, "Maharaja Game")
            }
        }
    }

    function openDemo(gameBrand, gameName) {
        //先關閉Game彈出視窗(如果存在)
        EWinWebInfo.IsOpenGame = true;
        GCB.AddPlayed(gameBrand + "." + gameName, function (success) {
            if (success) {
                API_RefreshPersonalPlayed(gameBrand + "." + gameName, true);
            }
        });

        //先關閉Game彈出視窗(如果存在)
        if (gameWindow) {
            gameWindow.close();
        }

        if (gameBrand.toUpperCase() != "EWin".toUpperCase()) {
            if (EWinWebInfo.DeviceType == 1) {
                gameWindow = window.open("/OpenGame.aspx?DemoPlay=1&Lang=" + EWinWebInfo.Lang + "&CurrencyType=" + API_GetCurrency() + "&GameBrand=" + gameBrand + "&GameName=" + gameName + "&HomeUrl=" + window.location.href, "Maharaja Game")
            } else {
                GameLoadPage("/OpenGame.aspx?DemoPlay=1&Lang=" + EWinWebInfo.Lang + "&CurrencyType=" + API_GetCurrency() + "&GameBrand=" + gameBrand + "&GameName=" + gameName + "&HomeUrl=" + window.location.href);
            }
        } else {
            gameWindow = window.open("/OpenGame.aspx?DemoPlay=1&Lang=" + EWinWebInfo.Lang + "&CurrencyType=" + API_GetCurrency() + "&GameBrand=" + gameBrand + "&GameName=" + gameName + "&HomeUrl=" + window.location.href, "Maharaja Game")
        }
    }

    function CloseGameFrame() {
        var IFramePage = document.getElementById("GameIFramePage");
        IFramePage.src = "";
        //非滿版遊戲介面
        // $('#headerGameDetailContent').hide();
        // $('#GameIFramePage').hide();
        //非滿版遊戲介面 end

        //滿版遊戲介面
        $('#divGameFrame').css('display', 'none');
        //滿版遊戲介面 end
    }
    //#endregion

    //#region FavoriteGames And MyGames

    function favBtnClick(gameCode) {
        var btn = event.currentTarget;
        event.stopPropagation();

        if ($(btn).hasClass("added")) {
            $(btn).removeClass("added");
            GCB.RemoveFavo(gameCode, function () {
                window.parent.API_RefreshPersonalFavo(gameCode, false);
                //window.parent.API_ShowMessageOK(mlp.getLanguageKey("我的最愛"), mlp.getLanguageKey("已移除我的最愛"));
            });
        } else {
            $(btn).addClass("added");
            GCB.AddFavo(gameCode, function () {
                window.parent.API_RefreshPersonalFavo(gameCode, true);
                //window.parent.API_ShowMessageOK(mlp.getLanguageKey("我的最愛"), mlp.getLanguageKey("已加入我的最愛"));
            });
        }
    }

    function setFavoriteGame(gameCode) {
        var favoriteGames = [];

        GCB.GetFavo(function (data) {
            favoriteGames.push(data);
        }, function (data) {
            if (!favoriteGames.filter(e => e.GameCode === gameCode).length > 0) {
                //ad
                GCB.AddFavo(gameCode);

                //showMessageOK(mlp.getLanguageKey("我的最愛"), mlp.getLanguageKey("已加入我的最愛"));
            } else {
                //remove
                GCB.RemoveFavo(gameCode);
                //showMessageOK(mlp.getLanguageKey("我的最愛"), mlp.getLanguageKey("已移除我的最愛"));
            }
        });
    }

    //#endregion

    function checkUserLogin(SID, cb) {
        var guid = Math.uuid();

        lobbyClient.GetUserInfo(SID, guid, function (success, o) {
            if (success) {
                if (o.Result == 0) {
                    //EXTRA DATA 處理
                    var ExtraData;

                    if (o.ExtraData != null && o.ExtraData != '') {
                        ExtraData = JSON.parse(o.ExtraData);
                        o.KYCRealName = ExtraData.KYCRealName;
                        o.Country = ExtraData.Country;
                        o.CountryName = ExtraData.CountryName;
                    } else {
                        o.KYCRealName = '';
                        o.Country = '';
                        o.CountryName = '';
                    }

                    EWinWebInfo.SID = SID;
                    EWinWebInfo.UserLogined = true;
                    EWinWebInfo.UserInfo = o;

                    if (cb)
                        cb(true);
                } else {
                    if (o.Message == "InvalidSID" || o.Message == "InvalidWebSID") {
                        // login fail
                        EWinWebInfo.UserLogined = false;
                    } else {
                        EWinWebInfo.UserLogined = false;

                        showMessageOK(mlp.getLanguageKey("錯誤"), mlp.getLanguageKey(o.Message));
                    }

                    if (cb)
                        cb(false);
                }
            } else {
                // 忽略 timeout 
            }
        });
    }

    function notifyWindowEvent(eventName, o) {
        //#region eventNameList
        //LoginState param: (bool)logined
        //BalanceChange (number)point
        //RefreshMyGame null
        //RefreshFavoriteGames null
        //#endregion
        var IFramePage = document.getElementById("IFramePage");

        if (IFramePage != null) {
            isDisplay = true;

            if (IFramePage.contentWindow && IFramePage.contentWindow.EWinEventNotify) {
                try {
                    IFramePage.contentWindow.EWinEventNotify(eventName, isDisplay, o)
                } catch (e) {

                }
            }
        }
    }

    function updateBaseInfo() {
        var idMenuLogin = document.getElementById("idMenuLogin");
        var idLoginBtn = document.getElementById("idLoginBtn");
        //var idUserNameTitle = document.getElementById("idUserNameTitle");
        var idWalletDiv = idMenuLogin.querySelector(".amount")
        if (EWinWebInfo.UserLogined) {
            var wallet = EWinWebInfo.UserInfo.WalletList.find(x => x.CurrencyType.toLocaleUpperCase() == EWinWebInfo.MainCurrencyType);

            //Check Balance Change
            if (selectedWallet != null) {
                if (wallet.PointValue != selectedWallet.PointValue) {
                    //idWalletDiv.innerText = new BigNumber(wallet.PointValue).toFormat();
                    idWalletDiv.innerText = new BigNumber(parseInt(wallet.PointValue)).toFormat();
                    notifyWindowEvent("BalanceChange", wallet.PointValue);
                }
            } else {
                //idWalletDiv.innerText = new BigNumber(wallet.PointValue).toFormat();
                idWalletDiv.innerText = new BigNumber(parseInt(wallet.PointValue)).toFormat();
            }

            selectedWallet = wallet;

            // 已登入
            idMenuLogin.classList.remove("is-hide");
            idLoginBtn.classList.add("is-hide");
            document.getElementById('idLogoutItem').classList.remove('is-hide');
            $(".avater-name").text(EWinWebInfo.UserInfo.EMail);

            //idWalletDiv.insertAdjacentHTML('beforeend', `<div class="currencyDiv">${EWinWebInfo.UserInfo.WalletList[0].CurrencyType}</div><div class="balanceDiv">${EWinWebInfo.UserInfo.WalletList[0].PointValue}</div>`);
        } else {
            // 尚未登入
            idMenuLogin.classList.add("is-hide");
            idLoginBtn.classList.remove("is-hide");
            document.getElementById('idLogoutItem').classList.add('is-hide');
            $(".avater-name").text("");
            selectedWallet = null;
        }
    }

    function userRecover(cb) {

        var recoverToken = getCookie("RecoverToken");
        var LoginAccount = getCookie("LoginAccount");

        if ((recoverToken != null) && (recoverToken != "")) {
            var postData;

            //API_ShowMask(mlp.getLanguageKey("登入復原中"), "full");
            //postData = encodeURI("RecoverToken=" + recoverToken + "&" + "LoginAccount=" + LoginAccount);
            postData = {
                "RecoverToken": recoverToken,
                "LoginAccount": LoginAccount
            }
            c.callService("/LoginRecover.aspx", postData, function (success, o) {
                //API_HideMask();

                if (success) {
                    var obj = c.getJSON(o);

                    if (obj.ResultCode == 0) {
                        EWinWebInfo.SID = obj.SID;
                        setCookie("RecoverToken", obj.RecoverToken, 365);
                        setCookie("LoginAccount", obj.LoginAccount, 365);
                        setCookie("SID", obj.SID, 365);
                        setCookie("CT", obj.CT, 365);


                        API_RefreshUserInfo(function () {
                            updateBaseInfo();

                            if (cb)
                                cb(true);
                        });
                    } else {
                        EWinWebInfo.UserLogined = false;
                        showMessageOK(mlp.getLanguageKey("錯誤"), mlp.getLanguageKey("請重新登入") + ":" + mlp.getLanguageKey(obj.Message), function () {
                            API_Logout(true);
                        });

                        if (cb)
                            cb(false);
                    }
                } else {
                    if (o == "Timeout") {
                        showMessageOK(mlp.getLanguageKey("錯誤"), mlp.getLanguageKey("服務器異常, 請稍後再嘗試一次"));
                    } else {
                        showMessageOK(mlp.getLanguageKey("錯誤"), o);
                    }

                    if (cb)
                        cb(false);
                }
            });
        }
    }

    function setLanguage(c, cb) {
        EWinWebInfo.Lang = c;
        window.localStorage.setItem("Lang", c);

        mlp.loadLanguage(c, function () {
            if (cb)
                cb();
        });

        mlpByGameCode.loadLanguageByOtherFile(EWinWebInfo.EWinUrl + "/GameCode.", c, function () {
            notifyWindowEvent("SetLanguage", c);
        });
        //mlpByGameBrand.loadLanguageByOtherFile(EWinWebInfo.EWinUrl + "/GameBrand.", c);      
    }

    function switchLang(Lang, isReload) {
        API_ShowLoading();
        var LangText;
        $("#btn_switchlang").children().remove();

        switch (Lang) {
            case "JPN":
                LangText = "日本語";
                $("#btn_switchlang").append(`<i class="icon icon-mask icon-flag-JP"></i>`);
                break;
            case "CHT":
                LangText = "繁體中文";
                $("#btn_switchlang").append(`<i class="icon icon-mask icon-flag-ZH"></i>`);
                break;
            case "ENG":
                LangText = "日本語";
                $("#btn_switchlang").append(`<i class="icon icon-mask icon-flag-JP"></i>`);
                break;
            case "CHS":
                LangText = "簡體中文";
                $("#btn_switchlang").append(`<i class="icon icon-mask icon-flag-ZH"></i>`);
                break;
            default:
                LangText = "日本語";
                $("#btn_switchlang").append(`<i class="icon icon-mask icon-flag-JP"></i>`);
                break;
        }

        //document.getElementById("idLangText").innerText = LangText;
        if (isReload) {
            setLanguage(Lang);
        }

        $("#btn_PupLangClose").click();
    }

    function getCookie(cname) {
        var name = cname + "=";
        var decodedCookie = decodeURIComponent(document.cookie);
        var ca = decodedCookie.split(';');
        for (var i = 0; i < ca.length; i++) {
            var c = ca[i];
            while (c.charAt(0) == ' ') {
                c = c.substring(1);
            }
            if (c.indexOf(name) == 0) {
                return c.substring(name.length, c.length);
            }
        }
        return "";
    }

    function setCookie(cname, cvalue, exdays) {
        var d = new Date();
        d.setTime(d.getTime() + (exdays * 24 * 60 * 60 * 1000));
        var expires = "expires=" + d.toUTCString();
        document.cookie = cname + "=" + cvalue + ";" + expires + ";path=/";
    }

    function delCookie(name) {
        var exp = new Date();
        exp.setTime(exp.getTime() - 1);
        cval = getCookie(name);
        if (cval != null) document.cookie = name + "=" + cval + ";expires=" + exp.toGMTString();
    }

    function onBtnLoginShow() {
        API_LoadPage("Login", "Login.aspx");
    }

    function getLoginMessage(cb) {
        lobbyClient.GetLoginMessage(EWinWebInfo.SID, Math.uuid(), function (success, o) {
            if (success) {
                if (o.Result == 0) {
                    LoginMessageTitle = o.Title;
                    LoginMessage = o.Message;
                    LoginMessageVersion = o.Version;
                    if (cb != null) {
                        cb();
                    }
                }
            }
        });
    }

    function showLoginMessage() {
        if (LoginMessage) {
            if (!localStorage.getItem("LoginMessage")) {
                if (!sessionStorage.getItem("LoginMessage")) {
                    WithCheckBoxShowMessageOK(LoginMessageTitle, LoginMessage, function () {
                        if (document.getElementById("cboxLoginMessage").checked) {
                            sessionStorage.setItem("LoginMessage", LoginMessageVersion);
                            localStorage.setItem("LoginMessage", LoginMessageVersion);
                        }
                    });
                } else {
                    if (parseFloat(LoginMessageVersion) > parseFloat(sessionStorage.getItem("LoginMessage"))) {
                        WithCheckBoxShowMessageOK(LoginMessageTitle, LoginMessage, function () {
                            if (document.getElementById("cboxLoginMessage").checked) {
                                sessionStorage.setItem("LoginMessage", LoginMessageVersion);
                                localStorage.setItem("LoginMessage", LoginMessageVersion);
                            }
                        });
                    }
                }
            } else {
                if (parseFloat(LoginMessageVersion) > parseFloat(localStorage.getItem("LoginMessage"))) {
                    WithCheckBoxShowMessageOK(LoginMessageTitle, LoginMessage, function () {
                        if (document.getElementById("cboxLoginMessage").checked) {
                            sessionStorage.setItem("LoginMessage", LoginMessageVersion);
                            localStorage.setItem("LoginMessage", LoginMessageVersion);
                        }
                    });
                }
            }
        }
    }

    function openHotArticle() {
        var orgin = "guides";

        switch (EWinWebInfo.Lang) {
            case "JPN":
                orgin = orgin + "_jp";
                break;
            case "CHT":
                break;
            case "ENG":
                orgin = orgin + "_jp";
                break;
            default:
                break;
        }

        orgin = "Article/" + orgin + ".html";

        API_LoadPage("Article", orgin);
    }

    function resize() {
        if (IFramePage.contentWindow.document.body) {

            let iframebodyheight = IFramePage.contentWindow.document.body.offsetHeight;
            let iframeheight = $("#IFramePage").height();

            if (iframeheight != iframebodyheight) {
                $("#IFramePage").height(iframebodyheight);
            }
        }
    }

    function initByArt() {
        //$('[data-btn-click="openLag"]').click(function () {
        //    $('.lang-select-panel').fadeToggle('fast');
        //});

        //$('.lang-select-panel a').click(function () {
        //    var curLang = $(this).text();
        //    $('.lang-select-panel').fadeToggle('fast');
        //    $('[data-btn-click="openLag"]').find('span').text(curLang);
        //});

        var navbartoggler = $('.navbar-toggler');
        var verticalmenu = $('.vertical-menu');
        var headermenu = $('.header_menu');

        //主選單收合
        navbartoggler.click(function () {
            verticalmenu.toggleClass('navbar-show');
            headermenu.toggleClass('show');
            if (navbartoggler.attr("aria-expanded") == "false") {
                navbartoggler.attr("aria-expanded", "true");
            }
        });
        $('.header_area .mask_overlay').click(function () {
            verticalmenu.removeClass('navbar-show');
            headermenu.removeClass('show');
            headermenu.find(".navbarMenu").removeClass('show');
            if (navbartoggler.attr("aria-expanded") == "true") {
                navbartoggler.attr("aria-expanded", "false");
            }
        });
    }

    function init() {

        //console.log("init start", new Date().toISOString());

        if (navigator.webdriver == true) {
            return;
        }

        GCB = new GameCodeBridge("/API/LobbyAPI.asmx", 30,
            {
                GameCode: "EWin.EWinGaming",
                GameBrand: "EWin",
                GameStatus: 0,
                GameID: 0,
                GameName: "EWinGaming",
                GameCategoryCode: "Live",
                GameCategorySubCode: "Baccarat",
                GameAccountingCode: null,
                AllowDemoPlay: 1,
                RTPInfo: "",
                IsHot: 1,
                IsNew: 1,
                SortIndex: 99,
                Tags: [],
                Language: [{
                    LanguageCode: "JPN",
                    DisplayText: "EWinゲーミング"
                },
                {
                    LanguageCode: "CHT",
                    DisplayText: "真人百家樂(eWIN)"
                }],
                RTP: null
            },
            () => {
                notifyWindowEvent("GameLoadEnd", null);
            }
        );


        mlp = new multiLanguage(v);
        mlpByGameCode = new multiLanguage(v);

        if (window.localStorage.getItem("Lang")) {
            EWinWebInfo.Lang = window.localStorage.getItem("Lang");
        }
        
        //console.log("initByArt start", new Date().toISOString());
        initByArt();
        //console.log("initByArt End", new Date().toISOString());
        switchLang(EWinWebInfo.Lang, false);

        mlp.loadLanguage(EWinWebInfo.Lang, function () {

            if (EWinWebInfo.DeviceType == 1) {
                //noSleep = new NoSleep();

                //document.addEventListener('click', function enableNoSleep() {
                //    document.removeEventListener('click', enableNoSleep, false);
                //    noSleep.enable();
                //}, false);
            }

            if (EWinWebInfo.DeviceType == 1) {
                // $(".searchFilter-item").eq(0).css("flex-grow", "0");
                // $(".searchFilter-item").eq(0).css("flex-shrink","0");
                // $(".searchFilter-item").eq(0).css("flex-basis","100%");
                // $(".searchFilter-item").eq(1).css("margin-left", "0");
                //$(".searchFilter-item").eq(2).css("margin-left","0");
            }

            var dstPage = c.getParameter("DstPage");
            var closeGameBtn = $('#closeGameBtn');
            lobbyClient = new LobbyAPI("/API/LobbyAPI.asmx");
            paymentClient = new PaymentAPI("/API/PaymentAPI.asmx");

            closeGameBtn.attr('title', mlp.getLanguageKey("關閉遊戲"));
            closeGameBtn.tooltip();

            if (dstPage) {
                var loadPage;
                switch (dstPage.toUpperCase()) {
                    case "Home".toUpperCase():
                        loadPage = "Home";
                        break;
                    case "Reg".toUpperCase():
                        loadPage = "register";
                        break;
                    case "Login".toUpperCase():
                        loadPage = "Login";
                        break;
                    default:
                        loadPage = "Home";
                        break;
                }

                history.replaceState(null, null, "?" + c.removeParameter("DstPage"));
                API_LoadPage(loadPage, loadPage + ".aspx");

            } else {
                API_Home();
            }
            
            SearchControll = new searchControlInit("alertSearch");
            
            //getCompanyGameCode();
            //getCompanyGameCodeTwo();
            //登入Check
            window.setTimeout(function () {
                lobbyClient.GetCompanySite(Math.uuid(), function (success, o) {
                    if (success) {
                        if (o.Result == 0) {
                            SiteInfo = o;
                            if ((EWinWebInfo.SID != null) && (EWinWebInfo.SID != "")) {
                                API_SetLogin(EWinWebInfo.SID, function (logined) {
                                    //顯示登入資訊 
                                    getLoginMessage(function () {
                                        showLoginMessage();
                                    });

                                    if (logined == false) {
                                        userRecover();
                                    } else {
                                        var srcPage = window.sessionStorage.getItem("SrcPage");

                                        if (srcPage) {
                                            window.sessionStorage.removeItem("SrcPage");
                                            API_LoadPage("SrcPage", srcPage, true);
                                        }
                                    }

                                    notifyWindowEvent("IndexFirstLoad", logined);
                                    EWinWebInfo.FirstLoaded = true;
                                });
                            } else {
                                updateBaseInfo();
                            }

                            //if (cb)
                            //    cb(true);
                        } else {
                            if (o.Message == "InvalidSID") {
                                // login fail
                                EWinWebInfo.UserLogined = false;
                            } else {
                                EWinWebInfo.UserLogined = false;

                                showMessageOK(mlp.getLanguageKey("錯誤"), mlp.getLanguageKey(o.Message));
                            }

                        }
                    }
                    else {
                        showMessageOK(mlp.getLanguageKey("錯誤"), mlp.getLanguageKey("服務器異常, 請稍後再嘗試一次"), function () {
                            window.location.href = "index.aspx"
                        });
                    }

                })
            }, 500);

            window.setInterval(function () {
                // refresh SID and Token;
                var guid = Math.uuid();

                if ((EWinWebInfo.SID != null) && (EWinWebInfo.SID != "")) {
                    lobbyClient.KeepSID(EWinWebInfo.SID, guid, function (success, o) {
                        if (success == true) {
                            if (o.ResultCode == 0) {
                                needCheckLogin = true;
                            } else {
                                if ((EWinWebInfo.SID != null) && (EWinWebInfo.SID != "")) {
                                    lobbyClient.GetWebSiteMaintainStatus(function (success, o1) {
                                        if (o1.Message == "1") { //維護中
                                            showMessageOK(mlp.getLanguageKey("錯誤"), mlp.getLanguageKey("系統維護中"), function () {
                                                window.location.reload();
                                            });
                                        }
                                    })

                                    needCheckLogin = true;
                                }
                            }
                        }
                    });

                }
            }, 10000);

            window.setInterval(function () {
                if (needCheckLogin == true) {
                    needCheckLogin = false;

                    if ((EWinWebInfo.SID != null) && (EWinWebInfo.SID != "")) {
                        API_SetLogin(EWinWebInfo.SID, function (logined) {
                            if (logined == false) {
                                userRecover();
                            }
                        });
                    } else {
                        updateBaseInfo();
                    }
                }
            }, 1000);

            new ResizeObserver(reportWindowSize).observe(document.body)
            //window.onresize = ;
            //window.setInterval(function () {
            //    resize();
            //}, 1000);
        });

        API_changeAvatarImg(getCookie("selectAvatar"));
        GameInfoModal = new bootstrap.Modal(document.getElementById("alertGameIntro"), { backdrop: 'static', keyboard: false });

        //resize();
    }

    function reportWindowSize() {
        let iframewidth = $('#IFramePage').width();

        notifyWindowEvent("resize", iframewidth);

    }

    //#region 搜尋彈出

    function searchControlInit(searchDomID) {
        var SearchSelf = this;
        var SearchDom = $("#" + searchDomID);
        var showMoreClickCount = 1;

        this.searchGameList = function (gameBrand) {
            var arrayGameBrand = [];
            var gameBrand;
            var keyWord = SearchDom.find('#alertSearchKeyWord').val().trim();
            var gamecategory = SearchDom.find("#seleGameCategory").val() == "All" ? "" : $("#seleGameCategory").val();
            var lang = EWinWebInfo.Lang;
            var alertSearchContent = SearchDom.find('#alertSearchContent');
            var gameItemCount = 0;
            showMoreClickCount = 1;

            alertSearchContent.empty();

            if (gameBrand) {
                arrayGameBrand.push(gameBrand);
            } else {
                SearchDom.find("input[name='button-brandExchange']").each(function (e, v) {
                    if ($(v).prop("checked")) {
                        arrayGameBrand.push($(v).attr('id').split("_")[1]);
                    }
                });
            }
            
            if (arrayGameBrand.length == 0 && gamecategory == "" && keyWord == "") {
                showMessageOK(mlp.getLanguageKey("錯誤"), mlp.getLanguageKey("請選擇／輸入其中一項"));
            } else {
                GCB.CursorGetByMultiSearch2(arrayGameBrand, gamecategory, null, keyWord,
                    function (gameItem) {

                        var RTP = "--";
                        var lang_gamename = gameItem.Language.find(x => x.LanguageCode == EWinWebInfo.Lang) ? gameItem.Language.find(x => x.LanguageCode == EWinWebInfo.Lang).DisplayText : "";
                        if (gameItem.RTPInfo) {
                            RTP = JSON.parse(gameItem.RTPInfo).RTP;
                        }

                        if (RTP == "0") {
                            RTP = "--";
                        }

                        GI = c.getTemplate("tmpSearchGameItem");
                        let GI1 = $(GI);
                        //var GI_a = GI.querySelector(".btn-play");
                        GI.onclick = new Function("openGame('" + gameItem.GameBrand + "', '" + gameItem.GameName + "','" + lang_gamename + "')");
                        GI1.addClass("group" + parseInt(gameItemCount / 60));
                        gameItemCount++;
                        var GI_img = GI.querySelector(".gameimg");
                        if (GI_img != null) {
                            GI_img.src = EWinWebInfo.EWinGameUrl + "/Files/GamePlatformPic/" + gameItem.GameBrand + "/PC/" + lang + "/" + gameItem.GameName + ".png";
                            var el = GI_img;
                            var observer = lozad(el); // passing a `NodeList` (e.g. `document.querySelectorAll()`) is also valid
                            observer.observe();
                        }

                        var likebtn = GI.querySelector(".btn-like");

                        if (EWinWebInfo.DeviceType == 0) {
                            $(likebtn).addClass("desktop");
                        }

                        if (gameItem.FavoTimeStamp) {
                         
                            $(likebtn).addClass("added");
                        } else {
                            $(likebtn).removeClass("added");
                        }

                        likebtn.onclick = new Function("favBtnClick('" + gameItem.GameCode + "')");

                        GI1.find(".gameName").text(lang_gamename);
                        GI1.find(".BrandName").text(mlp.getLanguageKey(gameItem.GameBrand));
                        GI1.find(".valueRTP").text(RTP);
                        GI1.find(".valueID").text(gameItem.GameID);
                        GI1.find(".GameCategoryCode").text(mlp.getLanguageKey(gameItem.GameCategoryCode));

                        if (gameItemCount < 61) {
                            alertSearchContent.append(GI);
                        } else {
                            GI1.css("display", "none");
                            alertSearchContent.append(GI);
                        }

                    }, function (data) {
                        if (alertSearchContent.children().length == 0) {
                            alertSearchContent.append(`<div class="no-Data"><div class="data"><span class="text language_replace">${mlp.getLanguageKey("沒有資料")}</span></div></div>`);
                        } else if (alertSearchContent.children().length >60) {
                            alertSearchContent.append(`<div style="width: 100%;display: block;"></div><div class="s-btn-more" onclick="SearchControll.rem()">${mlp.getLanguageKey("查看更多")}</div>`);
                        }
                    }
                )
            }
        };
        this.rem = function () {
            if (SearchDom.children().find(".group" + showMoreClickCount).length > 0) {
                SearchDom.children().find(".group" + showMoreClickCount).show();
            }

            showMoreClickCount++;

            if (SearchDom.children().find(".group" + showMoreClickCount).length == 0) {
                $(event.currentTarget).remove();
            }
        }

        this.searchGameChange = function () {
            var keyWord = SearchDom.find('#alertSearchKeyWord').val().trim();
            var arrayGameBrand = [];
            let strSeleBrandText = SearchDom.find(".brandSeleCount");
            let kk = "";
            var seleGameCategory = SearchDom.find("#seleGameCategory");
            let allGameBrandLength = $("#alertSearch").find("input[name='button-brandExchange']").length;

            SearchDom.find("input[name='button-brandExchange']").each(function (e, v) {
                if ($(v).prop("checked")) {
                    arrayGameBrand.push($(v).attr('id').split("_")[1]);
                }
            });

            //if (arrayGameBrand.length == 0 && keyWord == "") {
            //    SearchDom.find("#div_SearchGameCategory").hide();
            //} else {
            //    SearchDom.find("#div_SearchGameCategory").show();
            //}
            if (arrayGameBrand.length == 0 || arrayGameBrand.length == allGameBrandLength) {
                strSeleBrandText.text(mlp.getLanguageKey("全部"));
            } else {
                strSeleBrandText.text(` ${arrayGameBrand.length} / ${allGameBrandLength} `);
            }

            var o;
            seleGameCategory.empty();
            o = new Option(mlp.getLanguageKey("全部"), "All");
            seleGameCategory.append(o);

            if (arrayGameBrand.length > 0) {
                for (var k = 0; k < arrayGameBrand.length; k++) {

                    GCB.CursorGetGameCategoryCodeByGameBrand(arrayGameBrand[k],
                        function (data) {
                            if (kk.indexOf(data.GameCategoryCode) < 0) {
                                kk += data.GameCategoryCode + ",";

                                o = new Option(mlp.getLanguageKey(data.GameCategoryCode), data.GameCategoryCode);
                                seleGameCategory.append(o);
                            }
                        }, function (data) { //endcallback

                        }
                    );
                }
            }
        }

        this.searchGameChangeClear = function () {
            var alertSearchContent = SearchDom.find('#alertSearchContent');
            resetSeleGameCategory();
            SearchDom.find("#alertSearchKeyWord").val("");
            SearchDom.find(".brandSeleCount").text(mlp.getLanguageKey("全部"));
            SearchDom.find("input[name='button-brandExchange']").each(function (e, v) {
                $(v).prop("checked", false);
            });

            alertSearchContent.empty();
        }

        this.searchGameChangeConfirm = function () {

            SearchDom.find('.input-fake-select').toggleClass('show');
            SearchDom.find('.input-fake-select').parents('.searchFilter-wrapper').find('.brand-wrapper').slideToggle();
            SearchDom.find('.mask-header').toggleClass('show');
            SearchSelf.searchGameList();
        }

        this.searchGameByBrand = function (gameBrand) {
            SearchDom.find("input[name='button-brandExchange']").each(function (e, v) {
                $(v).prop("checked", false);
            });

            if (SearchDom.find('#searchIcon_' + gameBrand).length > 0) {
                SearchDom.find('#searchIcon_' + gameBrand).prop("checked", true);
            }

            SearchDom.find('#alertSearchKeyWord').val('');
            SearchDom.find("#seleGameCategory").val('');
            SearchDom.modal('show');
            SearchSelf.searchGameList(gameBrand);
        }

        this.searchGameByBrandAndGameCategory = function (gameBrand, gameCategoryName) {
            //待修正
            let o;

            SearchDom.modal('show');
            SearchDom.find("#div_SearchGameCategory").show();
            SearchDom.find("input[name='button-brandExchange']").each(function (e, v) {
                $(v).prop("checked", false);
            });

            if (SearchDom.find('#searchIcon_' + gameBrand).length > 0) {
                SearchDom.find('#searchIcon_' + gameBrand).prop("checked", true);
            }

            SearchDom.find("#seleGameCategory").empty();
            o = new Option(mlp.getLanguageKey("全部"), "All");
            SearchDom.find("#seleGameCategory").append(o);

            if (gameCategoryName) {
                o = new Option(mlp.getLanguageKey(gameCategoryName), gameCategoryName);
                SearchDom.find("#seleGameCategory").append(o);
            }

            SearchDom.find('#alertSearchKeyWord').val('');
            SearchDom.find("#seleGameCategory").val(gameCategoryName);

            SearchSelf.searchGameList(gameBrand);
        }

        //openFullSearch
        this.openFullSearch = function(e) {
            var header_SearchFull = document.getElementById("header_SearchFull");
            header_SearchFull.classList.add("open");
        }

        //openFullSearch
        this.closeFullSearch = function (e) {
            var header_SearchFull = document.getElementById("header_SearchFull");

            if (header_SearchFull.classList.contains("open")) {
                header_SearchFull.classList.remove("open");
            }
        }

        var getSearchGameBrand = function () {
            var ParentMain = SearchDom.find("#ulSearchGameBrand");
            ParentMain.empty();

            lobbyClient.GetGameBrand(Math.uuid(), function (success, o) {
                if (success == true) {
                    if (o.Result == 0) {
                        let GBLDom;
                        let GBL_img;

                        GBLDom = c.getTemplate("tmpSearchGameBrand");
                        GBL_img = GBLDom.querySelector(".brandImg");
                        $(GBLDom).find(".searchGameBrandcheckbox").attr("id", "searchIcon_EWin");
                        GBL_img.src = `images/logo/default/logo-eWIN.svg`;
                        ParentMain.append(GBLDom);

                        for (var i = 0; i < o.GameBrandList.length; i++) {
                            let GBL = o.GameBrandList[i];
                            if (GBL.GameBrandState == 0) {
                                GBLDom = c.getTemplate("tmpSearchGameBrand");
                                GBL_img = GBLDom.querySelector(".brandImg");

                                $(GBLDom).find(".searchGameBrandcheckbox").attr("id", "searchIcon_" + GBL.GameBrand);

                                if (GBL.GameBrandState == 0) {
                                    GBL_img.src = `images/logo/default/logo-${GBL.GameBrand}.png`;
                                }

                                ParentMain.append(GBLDom);
                            }
                        }
                    } else {

                    }
                }
            });
        }

        var resetSeleGameCategory = function () {
            var seleGameCategory = SearchDom.find("#seleGameCategory");
            var o;

            seleGameCategory.empty();

            o = new Option(mlp.getLanguageKey("全部"), "All");
            seleGameCategory.append(o);
            o = new Option(mlp.getLanguageKey("Electron"), "Electron");
            seleGameCategory.append(o);
            o = new Option(mlp.getLanguageKey("Fish"), "Fish");
            seleGameCategory.append(o);
            o = new Option(mlp.getLanguageKey("Live"), "Live");
            seleGameCategory.append(o);
            o = new Option(mlp.getLanguageKey("Slot"), "Slot");
            seleGameCategory.append(o);
            o = new Option(mlp.getLanguageKey("Sports"), "Sports");
            seleGameCategory.append(o);

            seleGameCategory.val("All");
        }

        function init() {
            getSearchGameBrand();
        }

        init();
    };

    //#endregion

    window.onload = init;
</script>
<body class="mainBody vertical-menu">
    <div class="loader-container" style="display: block;">
        <div class="loader-box">
            <div class="loader-spinner">
                <div class="sk-fading-circle">
                    <div class="loader-logo"></div>
                    <div class="sk-circle1 sk-circle"></div>
                    <div class="sk-circle2 sk-circle"></div>
                    <div class="sk-circle3 sk-circle"></div>
                    <div class="sk-circle4 sk-circle"></div>
                    <div class="sk-circle5 sk-circle"></div>
                    <div class="sk-circle6 sk-circle"></div>
                    <div class="sk-circle7 sk-circle"></div>
                    <div class="sk-circle8 sk-circle"></div>
                    <div class="sk-circle9 sk-circle"></div>
                    <div class="sk-circle10 sk-circle"></div>
                    <div class="sk-circle11 sk-circle"></div>
                    <div class="sk-circle12 sk-circle"></div>
                </div>
                <%--<div class="loader-text language_replace">正在加載...</div>--%>
            </div>


        </div>
        <div class="loader-backdrop is-show"></div>
    </div>
    <header class="header_area" id="">
        <div class="header_menu ">
            <!-- class="navbar-expand-xl" trigger hidden -->
            <nav class="navbar">
                <!-- TOP Search-->
                <div class="search-full" id="header_SearchFull">
                    <div class="container-fluid">
                        <form class="search__wrapper">
                            <div class="form-group-search search-plusbutton">
                                <input id="" type="search" class="form-control custom-search" name="search" language_replace="placeholder" placeholder="輸入帳號">
                                <label for="search" class="form-label"><span class="language_replace">輸入帳號</span></label>
                                <div class="btn btnSearch"><span class="language_replace">搜尋</span></div>
                                <button type="reset" class="btn btnReset"><i class="icon icon-ewin-input-reset"></i></button>
                            </div>
                            <span class="btn btn__closefullsearch" onclick="SearchControll.closeFullSearch(this)"><i class="icon icon-ewin-input-compress"></i></span>
                        </form>
                    </div>
                </div>
                <div class="container-fluid navbar__content">
                    <!--MENU BUTTON -->
                    <button id="navbar_toggler" class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarMenu" aria-controls="navbarMenu" aria-expanded="false" aria-label="Toggle navigation">
                        <span class="icon-bar"></span>
                        <span class="icon-bar"></span>
                        <span class="icon-bar"></span>
                    </button>
                    <!-- Sidebar Menu 側邊選單-->
                    <div class="navbarMenu collapse navbar-menu navbar-collapse offset" id="navbarMenu">

                        <div class="search-bar mobile" data-toggle="modal" data-target="#alertSearch">
                            <span class="text language_replace">遊戲搜尋</span>
                            <span class="btn btn-search">
                                <i class="icon icon-mask icon-search"></i>
                            </span>
                        </div>

                        <ul class="nav navbar-nav menu_nav no-gutters">
                            <li class="nav-item navbarMenu__catagory">
                                <ul class="catagory">
                                    <li class="nav-item submenu dropdown"
                                        onclick="API_LoadPage('Casino', 'Casino.aspx', false)">
                                        <a class="nav-link">
                                            <i class="icon icon-mask icon icon-mask icon-all"></i>
                                            <span class="title language_replace">遊戲大廳</span></a>
                                    </li>
                                </ul>
                            </li>
                            <li class="nav-item navbarMenu__catagory">
                                <ul class="catagory">
                                    <li class="nav-item submenu dropdown">
                                        <a class="nav-link" onclick="API_LoadPage('MemberCenter', 'MemberCenter.aspx', true)">
                                            <i class="icon icon-mask icon-people"></i>
                                            <span class="title language_replace">會員中心</span></a>
                                    </li>
                                    <li class="nav-item submenu dropdown">
                                        <a class="nav-link" onclick="API_LoadPage('','ActivityCenter.aspx')">
                                            <i class="icon icon-mask icon-loudspeaker"></i>
                                            <span class="title language_replace">活動中心</span></a>
                                    </li>
                                    <li class="nav-item submenu dropdown">
                                        <a class="nav-link" onclick="API_LoadPage('','Prize.aspx', true)">
                                            <i class="icon icon-mask icon-prize"></i>
                                            <span class="title language_replace">領獎中心</span></a>
                                    </li>
                                    <li class="nav-item submenu dropdown">
                                        <a class="nav-link" onclick="API_LoadPage('record','record.aspx', true)">
                                            <i class="icon icon-mask icon-calendar"></i>
                                            <span class="title language_replace">履歷記錄</span></a>
                                    </li>
                                </ul>
                            </li>
                            <li class="nav-item navbarMenu__catagory">
                                <ul class="catagory">
                                    <li class="nav-item submenu dropdown"
                                        onclick="API_LoadPage('QA','/Article/guide_Q&A_jp.html')">
                                        <a class="nav-link">
                                            <i class="icon icon-mask icon-QA"></i>
                                            <span class="title language_replace">Q&A</span></a>
                                    </li>
                                    <li class="nav-item submenu dropdown" onclick="API_ShowContactUs()">
                                        <a class="nav-link">
                                            <i class="icon icon-mask icon-word"></i>
                                            <span class="title language_replace">聯絡客服</span></a>
                                    </li>
                                </ul>
                            </li>
                            <li class="nav-item navbarMenu__catagory">
                                <ul class="catagory">
                                    <li class="nav-item submenu dropdown"
                                        onclick="API_LoadPage('Deposit','Deposit.aspx', true)">
                                        <a class="nav-link">
                                            <i class="icon icon-mask icon-deposit"></i>
                                            <span class="title language_replace">存款</span></a>
                                    </li>
                                    <li class="nav-item submenu dropdown" onclick="API_LoadPage('Withdrawal','Withdrawal.aspx', true)">
                                        <a class="nav-link">
                                            <i class="icon icon-mask icon-withdarw"></i>
                                            <span class="title language_replace">出款</span></a>
                                    </li>
                                </ul>
                            </li>
                            <%-- <li class="nav-item navbarMenu__catagory">
                                <ul class="catagory">
                                    <li class="nav-item submenu dropdown"
                                        onclick="window.open('https://lin.ee/KD05l9X')">
                                        <a class="nav-link">
                                            <i class="icon icon-mask icon-line"></i>
                                            <span class="title language_replace">Line</span></a>
                                    </li>
                                </ul>
                            </li>--%>
                            <li class="nav-item submenu dropdown" id="idLogoutItem">
                                <a class="nav-link" onclick="API_Logout(true)">
                                    <!-- <i class="icon icon2020-ico-login"></i> -->
                                    <i class="icon icon-mask icon-logout"></i>
                                    <span class="language_replace" langkey="登出">登出</span></a>
                            </li>
                        </ul>
                    </div>
                    <!-- 頂部 NavBar -->
                    <div class="header_topNavBar">
                        <!-- 左上角 -->
                        <div class="header_leftWrapper navbar-nav" onclick="API_LoadPage('Home','Home.aspx')">
                            <div class="navbar-brand">
                                <div class="logo"><a></a></div>
                            </div>
                        </div>
                        <div id="headerGameDetailContent" style="display: none;">
                            <!-- Search -->
                            <ul class="nav header_setting_content">
                                <li class="headerGameDetail navbar-search nav-item">
                                    <button id="closeGameBtn" type="button" onclick="CloseGameFrame()" data-toggle="tooltip" data-placement="bottom" class="btn btn-search" style="background: white;">
                                        <i class="icon">X</i>
                                    </button>
                                    <span class="headerGameName"></span>

                                </li>
                            </ul>
                        </div>
                        <!-- 右上角 -->
                        <div class="header_rightWrapper">

                            <div class="header_setting">
                                <ul class="nav header_setting_content">
                                    <!-- Search -->
                                    <li class="navbar-search nav-item">

                                        <span class="search-bar desktop" data-toggle="modal" data-target="#alertSearch">
                                            <span class="btn btn-search">
                                                <i class="icon icon-mask icon-search"></i>
                                            </span>
                                            <span class="text language_replace">遊戲搜尋</span>
                                        </span>
                                        <!-- <button type="button" class="btn btn-search" data-toggle="modal" data-target="#alertSearch">
                                            <i class="icon icon-mask icon-search"></i>
                                        </button> -->
                                    </li>
                                    <!-- ==== 登入前 ====-->
                                    <li class="nav-item unLogIn_wrapper " id="idLoginBtn">
                                        <ul class="horiz-list">
                                            <li class="login">
                                                <button class="btn-login btn" type="button" onclick="onBtnLoginShow()">
                                                    <span class="avater">
                                                        <img src="images/avatar/avater-2.png" alt=""></span>
                                                    <span class="language_replace">登入</span></button>
                                            </li>
                                            <li class="register">
                                                <button class="btn-register btn " type="button" onclick="API_LoadPage('Register', 'Register.aspx')"><span class="language_replace">註冊</span></button>
                                            </li>
                                        </ul>
                                    </li>
                                    <!--  ==== 登入後 ====-->
                                    <li class="nav-item logIned_wrapper is-hide" id="idMenuLogin">
                                        <ul class="horiz-list">
                                            <li class="nav-item " onclick="API_LoadPage('Deposit','Deposit.aspx', true)">
                                                <span class="balance-container">
                                                    <span class="balance-inner">
                                                        <span class="game-coin">
                                                            <!-- 未完成存款訂單小紅點 -->
                                                            <%--<span class="notify"><span class="notify-dot"></span></span>--%>
                                                            <img src="images/ico/coin-Ocoin.png" alt="">
                                                        </span>
                                                        <span class="balance-info">
                                                            <span class="amount">0</span>
                                                        </span>
                                                        <button class="btn btn-deposit btn-full-stress" onclick="">
                                                            <span class="icon icon-add"></span>
                                                        </button>
                                                    </span>
                                                </span>
                                            </li>
                                            <!-- User -->
                                            <li class="nav-item submenu dropdown avater_wrapper">
                                                <a onclick="API_LoadPage('MemberCenter', 'MemberCenter.aspx', true)" class="btn nav-link btnDropDown " role="button">
                                                    <span class="avater">
                                                        <span class="avater-img">
                                                            <img src="images/avatar/avater-2.png" alt="">
                                                        </span>
                                                        <span class="avater-name"></span>
                                                    </span>
                                                </a>
                                            </li>
                                        </ul>
                                    </li>

                                    <!-- 語系 -->
                                    <li class="nav-item lang_wrapper submenu dropdown">
                                        <button type="button" class="btn nav-link btn-langExchange" data-toggle="modal" data-target="#ModalLanguage" id="btn_switchlang">
                                            <!-- 語系 轉換 ICON -->
                                            <%--<i class="icon icon-mask icon-flag-JP"></i>
                                            <i class="icon icon-mask icon-flag-EN"></i>
                                            <i class="icon icon-mask icon-flag-ZH"></i>--%>
                                        </button>
                                    </li>
                                </ul>
                            </div>
                        </div>
                    </div>
                </div>
            </nav>
        </div>
        <div id="mask_overlay" class="mask_overlay"></div>
    </header>
    <!-- main_area = iframe高度 + Footer高度-->
    <%--    <div class="main_area" style="height: auto;">--%>

    <!-- 滿版遊戲介面 -->
    <div id="divGameFrame" class="divGameFrameBody">
        <div class="divGameFrameWrapper">
            <div class="btn-wrapper">
                <div class="btn btn-game-close" onclick="CloseGameFrame()"><i class="icon icon-mask icon-error"></i></div>
            </div>
            <iframe id="GameIFramePage" class="divGameFrame" name="mainiframe"></iframe>
        </div>
    </div>
    <!-- 滿版遊戲介面 end-->

    <div class="main_area">

        <!-- 非滿版遊戲介面 -->
        <%--<div class="btn btn-game-close is-hide"><i class="icon icon-mask icon-error"></i></div>
        <iframe id="GameIFramePage" style="z-index: 2; display: none;" class="mainIframe" name="mainiframe"></iframe>--%>
        <!-- 非滿版遊戲介面 end-->

        <!-- iframe高度 自動計算高度-->
        <%--        <iframe id="IFramePage" class="mainIframe" name="mainiframe" style="height: 100%; min-height: calc(100vh - 60px)"></iframe>--%>
        <iframe id="IFramePage" style="z-index: 1" class="mainIframe" name="mainiframe"></iframe>
    </div>
    <!-- footer -->
    <div id="footer" style="display: none">
        <footer class="footer-container">
            <div class="footer-inner">
                <div class="container">
                    <ul class="company-info row">
                        <li class="info-item col">
                            <a id="Footer_About" onclick="window.parent.API_LoadPage('About','About.html')"><span class="language_replace">關於我們</span></a>
                        </li>
                        <li class="info-item col">
                            <a onclick="window.parent.API_ShowContactUs()">
                                <span class="language_replace">聯絡客服</span>
                            </a>
                        </li>
                        <li class="info-item col">
                            <a id="Footer_Rules" onclick="window.parent.API_ShowPartialHtml('', 'Rules', true, null)">
                                <span class="language_replace">利用規約</span>
                            </a>
                        </li>
                        <li class="info-item col">
                            <a id="Footer_PrivacyPolicy" onclick="window.parent.API_ShowPartialHtml('', 'PrivacyPolicy', true, null)">
                                <span class="language_replace">隱私權政策</span>
                            </a>
                        </li>
                        <%-- <li class="info-item col" id="li_HotArticle">
                            <a onclick="openHotArticle()">
                                <span class="language_replace">熱門文章</span>
                            </a>
                        </li>--%>
                    </ul>
                    <div class="partner">
                        <div class="logo">
                            <div class="row">
                                <div class="logo-item">
                                    <div class="img-crop">
                                        <img src="images/logo/footer/logo-microgaming.png" alt="">
                                    </div>
                                </div>
                                <div class="logo-item">
                                    <div class="img-crop">
                                        <img src="images/logo/footer/logo-bbin.png" alt="">
                                    </div>
                                </div>
                                <div class="logo-item">
                                    <div class="img-crop">
                                        <img src="images/logo/footer/logo-gmw.png" alt="">
                                    </div>
                                </div>
                                <div class="logo-item">
                                    <div class="img-crop">
                                        <img src="images/logo/footer/logo-cq9.png" alt="">
                                    </div>
                                </div>
                                <div class="logo-item">
                                    <div class="img-crop">
                                        <img src="images/logo/footer/logo-red-tiger.png" alt="">
                                    </div>
                                </div>
                                <div class="logo-item">
                                    <div class="img-crop">
                                        <img src="images/logo/footer/logo-evo.png" alt="">
                                    </div>
                                </div>
                                <div class="logo-item">
                                    <div class="img-crop">
                                        <img src="images/logo/footer/logo-bco.png" alt="">
                                    </div>
                                </div>
                                <div class="logo-item">
                                    <div class="img-crop">
                                        <img src="images/logo/footer/logo-cg.png" alt="">
                                    </div>
                                </div>
                                <div class="logo-item">
                                    <div class="img-crop">
                                        <img src="images/logo/footer/logo-playngo.png" alt="">
                                    </div>
                                </div>
                                <div class="logo-item">
                                    <div class="img-crop">
                                        <img src="images/logo/footer/logo-pg.png" alt="">
                                    </div>
                                </div>
                                <div class="logo-item">
                                    <div class="img-crop">
                                        <img src="images/logo/footer/logo-netent.png" alt="">
                                    </div>
                                </div>
                                <div class="logo-item">
                                    <div class="img-crop">
                                        <img src="images/logo/footer/logo-kx.png" alt="">
                                    </div>
                                </div>
                                <div class="logo-item">
                                    <div class="img-crop">
                                        <img src="images/logo/footer/logo-evops.png" alt="">
                                    </div>
                                </div>
                                <div class="logo-item">
                                    <div class="img-crop">
                                        <img src="images/logo/footer/logo-bti.png" alt="">
                                    </div>
                                </div>
                                <div class="logo-item">
                                    <div class="img-crop">
                                        <img src="images/logo/footer/logo-zeus.png" alt="">
                                    </div>
                                </div>
                                <div class="logo-item">
                                    <div class="img-crop">
                                        <img src="images/logo/footer/logo-biggaming.png" alt="">
                                    </div>
                                </div>
                                <div class="logo-item">
                                    <div class="img-crop">
                                        <img src="images/logo/footer/logo-play.png" alt="">
                                    </div>
                                </div>
                                <div class="logo-item">
                                    <div class="img-crop">
                                        <img src="images/logo/footer/logo-h.png" alt="">
                                    </div>
                                </div>
                                <div class="logo-item">
                                    <div class="img-crop">
                                        <img src="images/logo/footer/logo-va.png" alt="">
                                    </div>
                                </div>
                                <div class="logo-item">
                                    <div class="img-crop">
                                        <img src="images/logo/footer/logo-pagcor.png" alt="">
                                    </div>
                                </div>
                                <div class="logo-item">
                                    <div class="img-crop">
                                        <img src="images/logo/footer/logo-mishuha.png" alt="">
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="company-detail">
                        <div class="company-license">
                            <iframe src="https://licensing.gaming-curacao.com/validator/?lh=73f82515ca83aaf2883e78a6c118bea3&template=tseal" width="150" height="50" style="border: none;"></iframe>
                        </div>
                        <div class="company-address">
                            <%-- <p class="name">Online Chip World Co. N.V</p>--%>
                            <p class="address language_replace">MAHARAJA由(Online Chip World Co. N.V) 所有並營運。（註冊地址：Zuikertuintjeweg Z/N (Zuikertuin Tower), Willemstad, Curacao）取得庫拉索政府核發的執照 註冊號碼：#365 / JAZ 認可，並以此據為標準。</p>
                        </div>
                    </div>


                    <div class="footer-copyright">
                        <p class="language_replace">Copyright © 2022 マハラジャ. All Rights Reserved.</p>
                    </div>
                </div>
            </div>
        </footer>
    </div>

    <!-- mask_overlay 黑色半透明遮罩-->
    <div id="mask_overlay_popup" class="mask_overlay_popup"></div>

    <!-- Modal Language -->
    <div class="modal fade footer-center" id="ModalLanguage" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered modal-dialog-scrollable">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title"><span class="language_replace">請選擇語言</span></h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close" id="btn_PupLangClose">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <div class="lang-popup-wrapper">
                        <ul class="lang-popup-list">
                            <li class="lang-item custom-control custom-radioValue-lang" onclick="switchLang('JPN', true)">
                                <label class="custom-label">
                                    <input type="radio" name="button-langExchange" class="custom-control-input-hidden"
                                        checked>
                                    <div class="custom-input radio-button">
                                        <span class="flag JP"><i class="icon icon-mask icon-flag-JP"></i></span>
                                        <span class="name">日本語</span>
                                    </div>
                                </label>
                            </li>
                            <%--<li class="lang-item custom-control custom-radioValue-lang" onclick="switchLang('ENG', true)">
                                <label class="custom-label">
                                    <input type="radio" name="button-langExchange" class="custom-control-input-hidden">
                                    <div class="custom-input radio-button">
                                        <span class="flag EN"><i class="icon icon-mask icon-flag-EN"></i></span>
                                        <span class="name">English</span>
                                    </div>
                                </label>
                            </li>--%>
                            <li class="lang-item custom-control custom-radioValue-lang" onclick="switchLang('CHT', true)">
                                <label class="custom-label">
                                    <input type="radio" name="button-langExchange" class="custom-control-input-hidden">
                                    <div class="custom-input radio-button">
                                        <span class="flag ZH"><i class="icon icon-mask icon-flag-ZH"></i></span>
                                        <span class="name">繁體中文</span>
                                    </div>
                                </label>
                            </li>
                        </ul>
                    </div>


                </div>
                <%--<div class="modal-footer">
                    <button type="button" class="btn btn-primary">確定</button>
                </div>--%>
            </div>
        </div>
    </div>

    <!-- Modal Search 品牌-文字版-->
    <%--  <div class="modal fade no-footer alertSearch " id="alertSearch" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-xl modal-dialog-scrollable">
            <div class="modal-content">
                <div class="modal-header">
                    <!-- <h5 class="modal-title">我是logo</h5> -->
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close" id="alertSearchCloseButton">
                        <span aria-hidden="true">&times;</span>
                    </button>
                    <div class="searchFilter-wrapper">
                        <div class="searchFilter-item input-group keyword">
                            <input id="alertSearchKeyWord" type="text" class="form-control" language_replace="placeholder" placeholder="キーワード" onkeyup="SearchKeyWordKeyup()">
                            <label for="" class="form-label"><span class="language_replace">キーワード</span></label>
                        </div>
                        
                        <div class="searchFilter-item input-group game-brand" id="div_SearchGameCode">
                            <select class="custom-select" id="alertSearchBrand" onchange="SearchGameCodeChange()">
                                <option class="title" value="-1" selected><span class="language_replace">プロバイダー（すべて）</span></option>
                                <%--<option class="searchFilter-option" value="BBIN"><span class="language_replace">BBIN</span></option>
                                <option class="searchFilter-option language_replace" value="BNG">BNG</option>
                                <option class="searchFilter-option language_replace" value="CG">CG</option>
                                <option class="searchFilter-option language_replace" value="CQ9">CQ9</option>
                                <option class="searchFilter-option language_replace" value="EVO">EVO</option>
                                <%--<option class="searchFilter-option" value="GMW"><span class="language_replace">GMW</span></option>
                                 <option class="searchFilter-option" value="HB"><span class="language_replace">HB</span></option>
                                <option class="searchFilter-option language_replace" value="KGS">KGS</option>
                                <option class="searchFilter-option language_replace" value="KX">KX</option>
                                <%--<option class="searchFilter-option" value="NE"><span class="language_replace">NE</span></option>
                                <option class="searchFilter-option language_replace" value="PG">PG</option>
                                <option class="searchFilter-option language_replace" value="PNG">PNG</option>
                                <option class="searchFilter-option language_replace" value="PP">PP</option>
                                <option class="searchFilter-option language_replace" value="VA">VA</option>
                                <option class="searchFilter-option language_replace" value="ZEUS">ZEUS</option>
                                <option class="searchFilter-option language_replace" value="BTI">BTI</option>
                                <option class="searchFilter-option language_replace" value="BG">BG</option>
                            </select>
                        </div>
                        <div class="searchFilter-item input-group game-type" id="div_SearchGameCategory" style="display: none">
                            <select class="custom-select" id="seleGameCategory">
                                <option class="title language_replace" value="All" selected>全部</option>
                                <option class="searchFilter-option language_replace" value="Electron">Electron</option>
                                <option class="searchFilter-option language_replace" value="Fish">Fish</option>
                                <option class="searchFilter-option language_replace" value="Live">Live</option>
                                <option class="searchFilter-option language_replace" value="Slot">Slot</option>
                                <option class="searchFilter-option language_replace" value="Sports">Sports</option>
                            </select>
                        </div>
                        <button onclick="searchGameList()" type="button" class="btn btn-primary btn-sm btn-search-popup"><span class="language_replace">検索</span></button>                        
                    </div>                    
                </div>
                <div class="modal-body">
                    <div class="game-search-wrapper">
                        <div class="search-result-wrapper">
                            <div class="search-result-inner">
                                <div class="search-result-list">
                                    <div class="game-item-group list-row row" id="alertSearchContent">
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
                    <button type="button" class="btn btn-primary">Save</button>
                </div>
            </div>
        </div>
    </div>--%>


    <!-- Modal Search 品牌-LOGO版-->
    <div class="modal fade no-footer alertSearchTemp" id="alertSearch" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-xl modal-dialog-scrollable">
            <div class="modal-content">
                <div class="modal-header">
                    <div class="modal-header-container">
                        <!-- <h5 class="modal-title">我是logo</h5> -->
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close"
                            id="alertSearchCloseButton">
                            <span aria-hidden="true">&times;</span>
                        </button>
                    </div>
                    <div class="searchFilter-wrapper">
                        <div class="modal-header-container">
                            <div class="searchFilter-item input-group game-brand">
                                <div class="input-fake-select">
                                    <div class="gameName">
                                        <span class="language_replace">遊戲品牌</span>
                                        (<span class="brandSeleCount language_replace">全部</span>)
                                    </div>
                                    <div class="has-arrow"><i class="arrow"></i></div>
                                </div>
                            </div>
                            <div class="searchFilter-item input-group game-type" id="div_SearchGameCategory">
                                <select class="custom-select" id="seleGameCategory">
                                    <option class="title language_replace" value="All" selected>全部</option>
                                    <option class="searchFilter-option language_replace" value="Electron">Electron</option>
                                    <option class="searchFilter-option language_replace" value="Fish">Fish</option>
                                    <option class="searchFilter-option language_replace" value="Live">Live</option>
                                    <option class="searchFilter-option language_replace" value="Slot">Slot</option>
                                    <option class="searchFilter-option language_replace" value="Sports">Sports</option>
                                </select>
                            </div>
                            <div class="searchFilter-item input-group keyword">
                                <input id="alertSearchKeyWord" type="text" class="form-control"
                                    language_replace="placeholder" placeholder="キーワード" enterkeyhint="">
                                <label for="" class="form-label"><span class="language_replace">キーワード</span></label>
                            </div>
                            <div class="wrapper_center action-outter">
                                <button type="button" class="btn btn btn-outline-main btn-sm btn-reset-popup" onclick="SearchControll.searchGameChangeClear()">
                                    <span class="language_replace">重新設定</span>
                                </button>
                                <button onclick="SearchControll.searchGameList()" type="button"
                                    class="btn btn-full-main btn-sm btn-search-popup">
                                    <span class="language_replace">検索</span>
                                </button>
                            </div>                            
                        </div>

                        <!-- 品牌LOGO版 Collapse -->
                        <div class="brand-wrapper">
                            <div class="modal-header-container">
                                <div class="brand-inner">
                                    <ul class="brand-popup-list" id="ulSearchGameBrand">

                                    </ul>
                                    <div class="wrapper_center">
                                        <%--<button class="btn btn-outline-main btn-brand-cancel" type="button"
                                            onclick="SearchControll.searchGameChangeClear()">
                                            <span class="language_replace">重新設定</span>
                                        </button>--%>
                                        <button class="btn btn-full-main btn-brand-confirm" type="button"
                                            onclick="SearchControll.searchGameChangeConfirm()">
                                            <span class="language_replace">確認</span>
                                        </button>
                                    </div>

                                </div>


                            </div>
                        </div>
                    </div>
                </div>
                <div class="mask-header"></div>
                <div class="modal-body">
                    <div class="game-search-wrapper">
                        <div class="search-result-wrapper">
                            <div class="search-result-inner">
                                <div class="search-result-list">
                                    <div class="game-item-group list-row row" id="alertSearchContent">
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
                    <button type="button" class="btn btn-primary">Save</button>
                </div>
            </div>
        </div>
    </div>

    <!-- 遊戲介紹 Modal-->
    <div class="modal fade modal-game" tabindex="-1" role="dialog" aria-labelledby="alertGameIntro" aria-hidden="true" id="alertGameIntro">
        <div class="modal-dialog modal-dialog-scrollable modal-dialog-centered" role="document">
            <div class="modal-content">
                <div class="modal-header border-bottom">
                    <h5 class="modal-title gameRealName language_replace"></h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true"><i class="icon-close-small"></i></span>
                    </button>
                </div>
                <div class="modal-body">
                    <div class="modal-body-content">
                        <div class="game-intro-box">
                            <div class="game-img">
                                <div class="img-wrap">
                                    <img class="GameImg" src="" alt="">
                                </div>
                            </div>
                            <div class="game-info">
                                <div class="game-detail">
                                    <div class="info-item game-num">
                                        <div class="num title">NO.</div>
                                        <div class="data GameID">01234</div>
                                    </div>
                                    <div class="info-item game-rtp">
                                        <div class="rtp-name title">RTP</div>
                                        <div class="rtp-data RtpContent"></div>
                                    </div>
                                    <!-- 當加入最愛時=> class 加 "add" -->
                                    <div class="info-item game-myFavorite add">
                                        <div class="myFavorite-name title">
                                            <span class="language_replace FavoText">加入我的最愛</span>
                                            <!-- <span class="language_replace">移除最愛</span> -->
                                        </div>
                                        <div class="myFavorite-icon">
                                            <i class="icon-casinoworld-favorite"></i>
                                        </div>
                                    </div>
                                </div>
                                <div class="game-play">
                                    <button type="button" class="btn-game game-demo">
                                        <span class="language_replace">試玩</span>
                                        <div class="triangle"></div>
                                    </button>
                                    <button type="button" class="btn-primary btn-game game-login">
                                        <span class="language_replace">登入玩遊戲</span>
                                    </button>
                                </div>
                            </div>
                            <div class="game-intro is-hide">
                                遊戲介紹遊戲介紹遊戲介紹遊戲介紹遊戲介紹遊戲介紹遊戲介紹遊戲介紹遊戲介紹遊戲介紹遊戲介紹遊戲介紹遊戲介紹遊戲介紹遊戲介紹遊戲介紹遊戲介紹遊戲介紹遊戲介紹遊戲介紹遊戲介紹遊戲介紹遊戲介紹遊戲介紹遊戲介紹遊戲介紹遊戲介紹
                            </div>
                        </div>

                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade" tabindex="-1" role="dialog" aria-labelledby="alertPartialHtml" aria-hidden="true" id="alertPartialHtml">
        <div class="modal-dialog modal-dialog-scrollable" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <div class="modal-title alertPartialHtml_Title">
                    </div>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true"><i class="icon-close-small"></i></span>
                    </button>
                </div>
                <div class="modal-body">
                    <div class="modal-body-content alertPartialHtml_Content">
                    </div>
                </div>
                <div class="modal-footer">
                    <div class="btn-container">
                        <button type="button" class="alertPartialHtml_OK btn btn-primary btn-sm" data-dismiss="modal"><span class="language_replace">確定</span></button>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!--alert-->
    <div class="modal fade" tabindex="-1" role="dialog" aria-labelledby="alertContactUs" aria-hidden="true" id="alertContactUs">
        <div class="modal-dialog modal-dialog-centered modal-dialog-scrollable" role="document">
            <div class="modal-content">
                <div class="modal-header border-bottom align-items-center">
                    <i class="icon-service"></i>
                    <h5 class="modal-title language_replace ml-1">客服信箱</h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">×</span>
                    </button>
                </div>
                <div class="modal-body">
                    <div class="modal-body-content">
                        <!-- <div class="service-contact">
                            <span class="titel language_replace">客服信箱</span><span class="data"> : service@BBC117.com</span>
                        </div> -->
                        <div class="inbox_customerService" id="sendMail">
                            <div class="form-group">
                                <label class="form-title language_replace">問題分類</label>
                                <select class="form-control custom-style contectUs_Subject">
                                    <option class="language_replace">出入金</option>
                                    <option class="language_replace">註冊</option>
                                    <option class="language_replace">獎勵</option>
                                    <option class="language_replace">遊戲</option>
                                    <option class="language_replace">其他</option>
                                </select>
                            </div>
                            <div class="form-group">
                                <label class="form-title language_replace">信箱</label>
                                <div class="input-group">
                                    <input type="text" class="form-control custom-style contectUs_Eamil" language_replace="placeholder" placeholder="請輸入回覆信箱" autocomplete="off">
                                    <div class="invalid-feedback language_replace">錯誤提示</div>
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="form-title language_replace">暱稱</label>
                                <div class="input-group">
                                    <input type="text" class="form-control custom-style contectUs_NickName" autocomplete="off" name="NickName">
                                    <div class="invalid-feedback language_replace">錯誤提示</div>
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="form-title language_replace">電話</label>
                                <div class="input-group">
                                    <input type="text" class="form-control custom-style contectUs_Phone" autocomplete="off" name="Phone">
                                    <div class="invalid-feedback language_replace">錯誤提示</div>
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="form-title language_replace">問題敘述</label>
                                <textarea class="form-control custom-style contectUs_Body" rows="5" language_replace="placeholder" placeholder=""></textarea>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="modal-footer justify-content-center">
                    <!-- <button class="btn btn-icon">
                        <i class="icon-copy" onclick="copyText('service@BBC117.com')"></i>
                    </button> -->
                    <div class="btn-container">
                        <button type="button" class="alertContact_OK btn btn-primary btn-block" data-dismiss="modal" onclick="sendContactUs();"><span class="language_replace">寄出</span></button>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!--alert Msg-->
    <div class="modal fade" tabindex="-1" role="dialog" aria-labelledby="alertMsg" aria-hidden="true" id="alertMsg" style="z-index: 10000;">
        <div class="modal-dialog modal-dialog-centered" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true"><%--<i class="icon-close-small is-hide"></i>--%></span>
                    </button>
                </div>
                <div class="modal-body">
                    <div class="modal-body-content">
                        <i class="icon-error_outline primary"></i>
                        <div class="text-wrap">
                            <p class="alertMsg_Text language_replace">變更個人資訊，請透過客服進行 ！</p>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <div class="btn-container">
                        <button type="button" class="alertMsg_OK btn btn-primary btn-sm" data-dismiss="modal"><span class="language_replace">確定</span></button>
                        <button type="button" class="alertMsg_Close btn btn-outline-primary btn-sm" data-dismiss="modal"><span class="language_replace">取消</span></button>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <!--alert-->
    <div class="modal fade" tabindex="-1" role="dialog" aria-labelledby="nonClose_alertContact" aria-hidden="true" id="nonClose_alertContact">
        <div class="modal-dialog modal-dialog-centered" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true"><%--<i class="icon-close-small is-hide"></i>--%></span>
                    </button>
                </div>
                <div class="modal-body">
                    <div class="modal-body-content">
                        <i class="icon-error_outline primary"></i>
                        <div class="text-wrap">
                            <p class="alertContact_Text language_replace">變更個人資訊，請透過客服進行 ！</p>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <div class="btn-container">
                        <button type="button" class="alertContact_OK btn btn-primary btn-sm" data-dismiss="modal"><span class="language_replace">確定</span></button>
                        <button type="button" class="alertContact_Close btn btn-outline-primary btn-sm" data-dismiss="modal"><span class="language_replace">取消</span></button>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!--alert-->


    <div class="modal fade footer-center" tabindex="-1" role="dialog" aria-labelledby="alertContactWithCheckBox" aria-hidden="true" id="alertContactWithCheckBox">
        <div class="modal-dialog modal-dialog-centered modal-dialog-scrollable" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <div class="alert_Title">xxxx</div>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span>×</span>
                    </button>
                </div>
                <div class="modal-body">
                    <div class="modal-body-content">
                        <article class="popup-detail-wrapper">
                            <div class="popup-detail-inner">
                                <div class="popup-detail-content">
                                    <section class="section-wrap">
                                        <h6 class="title"><i class="icon icon-mask ico-grid"></i><span class="language_replace">公告詳情-</span></h6>
                                        <div class="section-content">
                                            <p class="alertContact_Text language_replace">變更個人資訊，請透過客服進行 ！</p>
                                        </div>
                                    </section>
                                </div>
                            </div>
                        </article>
                    </div>
                </div>
                <div style="padding: 1rem; border-top: 1px solid #e9ecef;">
                    <div style="display: inline-block;">
                        <input style="width: 12px; height: 12px; cursor: pointer" type="checkbox" id="cboxLoginMessage">
                        <label style="font-size: 14px" for="cboxLoginMessage " class="language_replace">今後不顯示</label>
                    </div>
                    <div class="btn-container" style="float: right; display: inline-block;">
                        <button type="button" class="alertContact_OK btn btn-primary btn-sm" data-dismiss="modal"><span class="language_replace">確定</span></button>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!--alert Board Msg-->
    <div class="modal fade footer-center" tabindex="-1" role="dialog" aria-labelledby="alertBoardMsg" aria-hidden="true" id="alertBoardMsg">
        <div class="modal-dialog modal-dialog-centered modal-dialog-scrollable" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <div class="alert_Title"></div>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">×</span>
                    </button>
                </div>
                <div class="modal-body">
                    <div class="modal-body-content">
                        <article class="popup-detail-wrapper">
                            <div class="popup-detail-inner">
                                <div class="popup-detail-content">
                                    <section class="section-wrap">
                                        <h6 class="title"><i class="icon icon-mask ico-grid"></i><span class="language_replace">公告時間</span></h6>
                                        <div class="section-content">
                                            <div class="alert_Time"></div>
                                        </div>
                                    </section>
                                    <section class="section-wrap">
                                        <h6 class="title"><i class="icon icon-mask ico-grid"></i><span class="language_replace">公告詳情</span></h6>
                                        <div class="section-content">
                                            <p class="alert_Text language_replace">變更個人資訊，請透過客服進行 ！</p>
                                        </div>
                                    </section>
                                </div>

                            </div>
                        </article>
                        <!-- <i class="icon-error_outline primary"></i>
                        <div class="language_replace">公告時間：</div>
                        <div class="alert_Time"></div>
                        <div class="text-wrap">
                            <div class="language_replace">公告詳情：</div>
                            <p class="alert_Text language_replace">變更個人資訊，請透過客服進行 ！</p>
                        </div> -->
                    </div>
                </div>
                <div class="modal-footer">
                    <div class="btn-container">
                        <button type="button" class="alert_OK btn btn-primary btn-sm" data-dismiss="modal"><span class="language_replace">確定</span></button>
                    </div>
                </div>
            </div>
        </div>
    </div>


    <div class="modal fade no-footer popupGameInfo" id="popupMoblieGameInfo" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-xl modal-dialog-centered modal-dialog-scrollable">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <div class="game-info-mobile-wrapper">
                        <div class="game-item">
                            <div class="game-item-inner">
                                <div class="game-item-focus">
                                    <div class="game-item-img">
                                        <span class="game-item-link"></span>
                                        <div class="img-wrap">
                                            <img class="imgsrc" src="">
                                        </div>
                                    </div>
                                    <div class="game-item-info-detail open">
                                        <div class="game-item-info-detail-wrapper">
                                            <div class="game-item-info-detail-moreInfo">
                                                <ul class="moreInfo-item-wrapper">
                                                    <li class="moreInfo-item category">
                                                        <span class="value"><i class="icon icon-mask"></i></span>
                                                    </li>
                                                    <li class="moreInfo-item brand">
                                                        <span class="title language_replace">廠牌</span>
                                                        <span class="value BrandName"></span>
                                                    </li>
                                                    <li class="moreInfo-item RTP">
                                                        <span class="title">RTP</span>
                                                        <span class="value number valueRTP"></span>
                                                    </li>
                                                    <li class="moreInfo-item gamecode">
                                                        <span class="title">NO.</span>
                                                        <span class="value number GameID"></span>
                                                    </li>
                                                </ul>
                                            </div>
                                            <div class="game-item-info-detail-indicator">
                                                <div class="game-item-info-detail-indicator-inner">
                                                    <div class="info">
                                                        <h3 class="game-item-name GameName"></h3>
                                                    </div>
                                                    <div class="action">
                                                        <div class="btn-s-wrapper">
                                                       <%-- <button type="button" class="btn-thumbUp btn btn-round">
                                                                <i class="icon icon-m-thumup"></i>
                                                            </button>--%>
                                                            <button type="button" class="btn-like btn btn-round">
                                                                <i class="icon icon-m-favorite"></i>
                                                            </button>
                                                      <%--      <button type="button" class="btn-more btn btn-round">
                                                                <i class="arrow arrow-down"></i>
                                                            </button>--%>
                                                        </div>
                                                  <%--      <button type="button" class="btn btn-play">
                                                            <span class="language_replace">プレイ</span><i class="triangle"></i>
                                                        </button>--%>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
                    <button type="button" class="btn btn-primary">Save</button>
                </div>
            </div>
        </div>
    </div>


    <!-- Modal Search 品牌-文字版-->
    <%--    <div id="tmpSearchGameItem" class="is-hide">
        <div class="game-item col-auto">
            <div class="game-item-inner">
                <div class="game-item-img">
                    <span class="game-item-link"></span>
                    <div class="img-wrap">
                        <img class="gameimg" src="">
                    </div>
                </div>
                <div class="game-item-info">
                    <div class="game-item-info-inner">
                        <div class="game-item-info-brief">
                            <div class="game-item-info-pre">
                                <h3 class="gameName"></h3>
                            </div>
                            <div class="game-item-info-moreInfo">
                                <ul class="moreInfo-item-wrapper">
                                    <li class="moreInfo-item brand">
                                        <h4 class="value BrandName"></h4>
                                    </li>                                   
                                    <li class="moreInfo-item RTP">
                                        <span class="title">RTP</span>
                                        <span class="value number valueRTP"></span>
                                    </li>
                                </ul>
                            </div>
                        </div>
                        <div class="game-item-info-indicator">
                            <div class="action">
                                <div class="btn-s-wrapper">
                                    <!-- 按讚 按鈕移除 -->
                                    <button type="button" class="btn-thumbUp btn btn-round" style="display: none;">
                                        <i class="icon icon-m-thumup"></i>
                                    </button>
                                    
                                    <button type="button" class="btn-like btn btn-round">
                                        <i class="icon icon-m-favorite"></i>
                                    </button>
                                </div>
                                <!-- play 按鈕移除 -->
                                <button type="button" class="btn btn-play">
                                    <span class="language_replace title">プレイ</span><i class="triangle"></i>
                                </button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>--%>


    <!-- Modal Search 新版 - 品牌-LOGO版-->
    <div id="tmpSearchGameItem" class="is-hide">
        <div class="game-item col-auto">
            <div class="game-item-inner">
                <div class="game-item-img">
                    <span class="game-item-link"></span>
                    <div class="img-wrap">
                        <img class="gameimg" src="">
                    </div>
                </div>
                <div class="game-item-info">
                    <div class="game-item-info-inner">
                        <div class="game-item-info-brief">
                            <div class="game-item-info-pre">
                                <h3 class="gameName"></h3>
                            </div>
                            <div class="game-item-info-moreInfo">
                                <ul class="moreInfo-item-wrapper">
                                    <li class="moreInfo-item brand">
                                        <h4 class="value BrandName"></h4>
                                    </li>
                                    <li class="moreInfo-item category">
                                        <h4 class="value GameCategoryCode"></h4>
                                    </li>
                                    <li class="moreInfo-item RTP">
                                        <span class="title">RTP</span>
                                        <span class="value number valueRTP"></span>
                                    </li>
                                    <li class="moreInfo-item">
                                        <span class="title">NO</span>
                                        <span class="value number valueID"></span>
                                    </li>
                                </ul>
                            </div>
                        </div>
                        <div class="game-item-info-indicator">
                            <div class="action">
                                <div class="btn-s-wrapper">
                                    <!-- 按讚 按鈕移除 -->
                                    <button type="button" class="btn-thumbUp btn btn-round" style="display: none;">
                                        <i class="icon icon-m-thumup"></i>
                                    </button>

                                    <button type="button" class="btn-like btn btn-round">
                                        <i class="icon icon-m-favorite"></i>
                                    </button>
                                </div>
                                <!-- play 按鈕移除 -->
                                <button type="button" class="btn btn-play" style="display: none;">
                                    <span class="language_replace title">プレイ</span><i class="triangle"></i>
                                </button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- 品牌LOGO版 Collapse TEST-->
    <script>
        $('.brand-wrapper:not(.show)').hide();
        $('.input-fake-select').click(function () {
            $(this).toggleClass('show');
            $(this).parents('.searchFilter-wrapper').find('.brand-wrapper').slideToggle();
            $('.mask-header').toggleClass('show');
        });
    </script>

    <div id="tmpSearchGameBrand" style="display: none">
        <li class="brand-item custom-control custom-checkboxValue-noCheck">
            <label class="custom-label">
                <input type="checkbox" name="button-brandExchange" id="" class="custom-control-input-hidden searchGameBrandcheckbox" onchange="SearchControll.searchGameChange()">
                <div class="custom-input checkbox">
                    <span class="logo-wrap">
                        <span class="img-wrap">
                            <img class="brandImg" src="images/logo/default/logo-eWIN.svg" alt=""></span>
                    </span>
                </div>
            </label>
        </li>
    </div>

</body>
</html>
