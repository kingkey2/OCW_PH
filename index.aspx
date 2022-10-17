<%@ Page Language="C#" %>

<%
    if (EWinWeb.IsInMaintain()) {
        Response.Redirect("/Maintain.aspx");
    }

    string Token;
    int RValue;
    Random R = new Random();
    string Lang = "CHT";
    string SID = string.Empty;
    string CT = string.Empty;
    string PCode = string.Empty;
    string PageType = string.Empty;
    int RegisterType;
    int RegisterParentPersonCode;
    int GoEwinLogin = 0;
    string Version = EWinWeb.Version;

    if (string.IsNullOrEmpty(Request["SID"]) == false) {
        SID = Request["SID"];
    }

    if (string.IsNullOrEmpty(Request["CT"]) == false)
        CT = Request["CT"];

    if (string.IsNullOrEmpty(Request["GoEwinLogin"]) == false) {
        GoEwinLogin = int.Parse(Request["GoEwinLogin"]);
    }

    if (string.IsNullOrEmpty(Request["PCode"]) == false) {
        PCode = Request["PCode"];
    }

    if (string.IsNullOrEmpty(Request["PageType"]) == false) {
        PageType = Request["PageType"];
    }

    if (GoEwinLogin == 1) {
        string EwinCallBackUrl;

        if (CodingControl.GetIsHttps()) {
            EwinCallBackUrl = "https://" + Request.Url.Authority + "/RefreshParent.aspx?index.aspx";
        } else {
            EwinCallBackUrl = "http://" + Request.Url.Authority + "/RefreshParent.aspx?index.aspx";
        }
        Response.Redirect(EWinWeb.EWinGameUrl + "/Game/Login.aspx?CT=" + HttpUtility.UrlEncode(CT) + "&KeepLogin=0" + "&Action=Custom" + "&Callback=" + HttpUtility.UrlEncode(EwinCallBackUrl) + "&CallbackHash=" + CodingControl.GetMD5(EwinCallBackUrl + EWinWeb.PrivateKey, false));
    }

    EWin.Lobby.LobbyAPI lobbyAPI = new EWin.Lobby.LobbyAPI();

    RValue = R.Next(100000, 9999999);
    Token = EWinWeb.CreateToken(EWinWeb.PrivateKey, EWinWeb.APIKey, RValue.ToString());
    var CompanySite = lobbyAPI.GetCompanySite(Token, Guid.NewGuid().ToString());

    RegisterType = CompanySite.RegisterType;
    RegisterParentPersonCode = CompanySite.RegisterParentPersonCode;
    if (string.IsNullOrEmpty(Request["Lang"])) {
        string userLang = CodingControl.GetDefaultLanguage();

        if (userLang.ToUpper() == "zh-TW".ToUpper()) {
            Lang = "CHT";
        } else if (userLang.ToUpper() == "zh-HK".ToUpper()) {
            Lang = "CHT";
        } else if (userLang.ToUpper() == "zh-MO".ToUpper()) {
            Lang = "CHT";
        } else if (userLang.ToUpper() == "zh-CHT".ToUpper()) {
            Lang = "CHT";
        } else if (userLang.ToUpper() == "zh-CHS".ToUpper()) {
            Lang = "CHT";
        } else if (userLang.ToUpper() == "zh-SG".ToUpper()) {
            Lang = "CHT";
        } else if (userLang.ToUpper() == "zh-CN".ToUpper()) {
            Lang = "CHT";
        } else if (userLang.ToUpper() == "zh".ToUpper()) {
            Lang = "CHT";
        } else if (userLang.ToUpper() == "en-US".ToUpper()) {
            Lang = "ENG";
        } else if (userLang.ToUpper() == "en-CA".ToUpper()) {
            Lang = "ENG";
        } else if (userLang.ToUpper() == "en-PH".ToUpper()) {
            Lang = "ENG";
        } else if (userLang.ToUpper() == "en".ToUpper()) {
            Lang = "ENG";
        } else if (userLang.ToUpper() == "ko-KR".ToUpper()) {
            Lang = "JPN";
        } else if (userLang.ToUpper() == "ko-KP".ToUpper()) {
            Lang = "JPN";
        } else if (userLang.ToUpper() == "ko".ToUpper()) {
            Lang = "JPN";
        } else if (userLang.ToUpper() == "ja".ToUpper()) {
            Lang = "JPN";
        } else { Lang = "JPN"; }
    } else {
        Lang = Request["Lang"];

        Lang = Lang.ToUpper();
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
    <link rel="stylesheet" href="css/main.css?3">
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+JP:wght@300;500&display=swap" rel="Prefetch" as="style" onload="this.rel = 'stylesheet'" />

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

        .bulletin_list .item {
            margin-bottom: 0.8rem;
            -webkit-box-align: center;
            -ms-flex-align: center;
            align-items: center;
            display: -webkit-box;
            display: -ms-flexbox;
            display: flex;
        }
                .bulletin_list .item:before {
                    content: "";
                    display: -webkit-inline-box;
                    display: -ms-inline-flexbox;
                    display: inline-flex;
                    width: 3px;
                    height: 1rem;
                    border-radius: 0.5px;
                    background-color: #008fd1;
                }
                .bulletin_list .item .date {
                    font-weight: 600;
                    margin-left: 0.5rem;
                    margin-right: 1rem;
                    width: 5rem;
                    display: -webkit-inline-box;
                    display: -ms-inline-flexbox;
                    display: inline-flex;
                }
                .bulletin_list .item .info {
                    -webkit-box-flex: 1;
                    -ms-flex: 1;
                    flex: 1;
                    display: -webkit-box;
                    text-overflow: ellipsis;
                    -webkit-line-clamp: 1;
                    -webkit-box-orient: vertical;
                    overflow: hidden;
                    cursor: pointer;
                }
        .bulletin_list .item .info:hover {
            color: #008fd1;
        }
    </style>
</head>

<script
    src="https://code.jquery.com/jquery-2.2.4.js"
    integrity="sha256-iT6Q9iMJYuQiMWNd9lDyBUStIq/8PuOW33aOqmvFpqI="
    crossorigin="anonymous"></script>
<script type="text/javascript" src="/Scripts/PaymentAPI.js?<%:Version%>"></script>
<script type="text/javascript" src="Scripts/popper.min.js"></script>
<script type="text/javascript" src="/Scripts/LobbyAPI.js?<%:Version%>"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/4.6.2/js/bootstrap.min.js"></script>
<%--<script src="Scripts/vendor/bootstrap/bootstrap.min.js"></script>--%>
<script type="text/javascript" src="/Scripts/Common.js"></script>
<script type="text/javascript" src="/Scripts/UIControl.js"></script>
<script type="text/javascript" src="/Scripts/MultiLanguage.js"></script>
<script type="text/javascript" src="/Scripts/Math.uuid.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/Swiper/6.7.1/swiper-bundle.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/bignumber.js/9.0.2/bignumber.min.js"></script>
<script type="text/javascript" src="/Scripts/GameCodeBridge.js?1"></script>
<script type="text/javascript" src="/Scripts/NoSleep.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/lozad.js/1.16.0/lozad.min.js"></script>
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
        DeviceType: getOS(),
        IsOpenGame: false
    };
    var Favos = [];
    var isFirstLogined = false;
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
    var PCode = "<%=PCode%>";
    var PageType = "<%=PageType%>";
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

    function getOS() {
        var os = function () {
            var ua = navigator.userAgent,
                isWindowsPhone = /(?:Windows Phone)/.test(ua),
                isSymbian = /(?:SymbianOS)/.test(ua) || isWindowsPhone,
                isAndroid = /(?:Android)/.test(ua),
                isFireFox = /(?:Firefox)/.test(ua),
                isChrome = /(?:Chrome|CriOS)/.test(ua),
                isTablet = /(?:iPad|PlayBook)/.test(ua) || (isAndroid && !/(?:Mobile)/.test(ua)) || (isFireFox && /(?:Tablet)/.test(ua)),
                isPhone = /(?:iPhone)/.test(ua) && !isTablet,
                isPc = !isPhone && !isAndroid && !isSymbian;
            return {
                isTablet: isTablet,
                isPhone: isPhone,
                isAndroid: isAndroid,
                isPc: isPc
            };
        }();

        if (os.isAndroid || os.isPhone) {
            return 1;
        } else if (os.isTablet) {
            return 1;
        } else if (os.isPc) {
            return 0;
        }
    };



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

        for (var i = 0; i < Object.keys(window.sessionStorage).length; i++) {
            var sessionStorageKeys = Object.keys(window.sessionStorage)[i];
            if (sessionStorageKeys != 'OpenGameBeforeLogin') {
                window.sessionStorage.removeItem(sessionStorageKeys);
            }
        }

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
        if (!isAdded) {
            var index = Favos.indexOf(gameCode);

            if (index > -1) {
                Favos.splice(index, 1);
            }
        } else if (isAdded) {
            var index = Favos.indexOf(gameCode);

            if (index == -1) {
                Favos.push(gameCode);
            }
        }

        lobbyClient.SetUserAccountProperty(EWinWebInfo.SID, Math.uuid(), "Favo", JSON.stringify(Favos), function (success, o) {
            if (success) {
                if (o.Result == 0) {
                }
            }
        });

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

        if (url == "Register.aspx") {
            if (PCode != "") {
                window.open("<%=EWinWeb.CasinoWorldUrl%>/registerForQrCode.aspx?P=" + PCode + "&IsFromIndex=1");
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

    function API_Casino() {
        //Game
        API_LoadPage("Casino", "Casino.aspx");
    }

    function API_SetFavoToIndexDB(cb) {
        //Game
        GCB.InitPromise.then(() => {
            setFavoToIndexDB(cb);
        });
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

    function API_MobileDeviceGameInfo(brandName, RTP, gameName, GameID, GameLangName, GameCategoryCode, ChampionType) {
        return showMobileDeviceGameInfo(brandName, RTP, gameName, GameID, GameLangName, GameCategoryCode, ChampionType);
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
        lobbyClient.SendCSMail(Math.uuid(), email, subject, body, function (success, o) {
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
        return showContactUs();
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

    function showBoardMsg(title, docNumber) {
        if ($("#alertBoardMsg").attr("aria-hidden") == 'true') {
            $("#popupBulletinList").modal("hide");
            var divMessageBox = document.getElementById("alertBoardMsg");
            var divMessageBoxOKButton = divMessageBox.querySelector(".alert_OK");
            var divMessageBoxTitle = divMessageBox.querySelector(".alert_Title");
            //var divMessageBoTime = divMessageBox.querySelector(".alert_Time");
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
                //divMessageBoTime.innerHTML = time;
                
                $.ajax({
                    url: "<%=EWinWeb.EWinUrl%>/GetDocument.aspx?DocNumber=" + docNumber,
                    success: function (res) {
                        divMessageBoxContent.innerHTML = res;
                    },
                    error: function (err) { console.log(err) },
                });
            }
        }
    }

    function alertBoardMsgClose() {
        $("#alertBoardMsg").modal("hide");
        $("#popupBulletinList").modal("show");
    }

    function showLangProp() {

        if (EWinWebInfo.Lang == 'JPN') {
            $('.lang-popup-list').eq(0).find('input').eq(0).prop("checked", true);
        } else if (EWinWebInfo.Lang == 'ENG') {
            $('.lang-popup-list').eq(0).find('input').eq(1).prop("checked", true);
        } else {
            $('.lang-popup-list').eq(0).find('input').eq(2).prop("checked", true);
        }

        $('#ModalLanguage').modal('show');
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

    function WithCheckBoxShowMessageOK(title, docNumber, cbOK) {
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

                $.ajax({
                    url: "https://ewin.dev.mts.idv.tw/GetDocument.aspx?DocNumber=" + docNumber,
                    success: function (res) {
                        divMessageBoxContent.innerHTML = res;
                    },
                    error: function (err) { console.log(err) },
                });

            }
        }
    }
    //#endregion

    function showMobileDeviceGameInfo(brandName, RTP, gameName, GameID, GameLangName, GameCategoryCode, ChampionType) {
        var popupMoblieGameInfo = $('#popupMoblieGameInfo');
        var gameiteminfodetail = popupMoblieGameInfo[0].querySelector(".game-item-info-detail.open");
        var gameitemlink = popupMoblieGameInfo[0].querySelector(".game-item-link");
        var likebtn = popupMoblieGameInfo[0].querySelector(".btn-like");
        var playbtn = popupMoblieGameInfo[0].querySelector(".btn-play");
        var GI_img = popupMoblieGameInfo[0].querySelector(".imgsrc");
        var moreInfoitemcategory = popupMoblieGameInfo.find('.moreInfo-item.category').eq(0);
        var favoriteGames = [];
        var gamecode = brandName + "." + gameName;
        var _gameCategoryCode;
        var championData = checkChampionType(ChampionType);
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

        var popupMoblieGameInfogameitem = $('#popupMoblieGameInfo-game-item');
        popupMoblieGameInfogameitem.removeClass();
        popupMoblieGameInfogameitem.addClass('game-item');
        if (championData.crownLevel != "") {
            popupMoblieGameInfogameitem.addClass(championData.crownLevel);
        }

        if (championData.championTypeStr != "") {
            var datas = championData.championTypeStr.split(',');
            for (var i = 0; i < datas.length; i++) {
                popupMoblieGameInfogameitem.addClass(datas[i]);
            }

        }

        popupMoblieGameInfo.find('.BrandName').text(brandName);
        popupMoblieGameInfo.find('.valueRTP').text(RTP);
        popupMoblieGameInfo.find('.GameID').text(GameID);

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

            if (pathName == 'Rules') {
                var rulesHtml = "";
                if (EWinWebInfo.Lang == 'JPN') {
                    rulesHtml = `<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>マハラジャ</title>

    <!-- <link rel="stylesheet" href="Scripts/OutSrc/lib/bootstrap/css/bootstrap.min.css" type="text/css" /> -->
    <link rel="stylesheet" href="css/icons.css" type="text/css" />
    <!-- <link rel="stylesheet" href="css/global.css" type="text/css" /> -->
    <link rel="stylesheet" href="css/manual.css" type="text/css" />
</head>
<body>
    <div class="page-container">
        <!-- Heading-Top -->
        <div id="heading-top"></div>
        <div class="page-content">
            <div class="manual-container">
                <h2 class="language_replace">利用規約</h2>
                <div class="text-wrap">
                    <strong><span>バージョン</span></strong><strong><span>: 1.0</span></strong><br />
                    <strong><span>更新日</span></strong><strong><span>: 29.10.2021</span></strong><br />
                    <br />
                    <br />
                    <span><strong>1. </strong></span><strong><span>一般</span></strong><br />
                    <strong><span>このページは、マハラジャの利用規約（以下利用規約）を構成し、このサイトを利用するすべての登録ユーザーは必ず本利用規約に同意する必要があります。本利用規約およびこの中で明確に言及されている文書は、当事者間の合意および理解し、当社とユーザーの契約関係を規定します。</span></strong><strong> </strong><strong><span>マハラジャ（以下ウェブサイト）を利用する前に、本利用規約をしっかりお読みの上、必ず理解してください。本利用規約にご同意いただけない場合には、ウェブサイトの使用および使用の継続をおやめください。また、プライバシーポリシーに関してもよく理解しておかれることをお勧めします。</span></strong><br />
                    <br />
                    <span><strong>1.1</strong></span><br />
                    <strong><span>本利用規約には、以下のようないくつかの追加用語が含まれています</span></strong><strong><span>:</span></strong><br />
                    <span><strong>-</strong></span><strong><span>プレイすることを選択したゲームのルール（「ルール」）。</span></strong><br />
                    <span><strong>-</strong></span><strong><span>特定のキャンペーンに随時適用される当社のキャンペーン利用規約（「キャンペーン利用規約」）。</span></strong><br />
                    <span><strong>-</strong></span><strong><span>当社がユーザーから収集した、またはユーザーから当社に提供された個人情報の処理に関する条件を定めた当社のプライバシーポリシー。</span></strong><br />
                    <br />
                    <span><strong>1.2</strong></span><br />
                    <strong><span>ユーザーは、随時改正されることがある本利用規約に含まれることを理解し、同意するものとします。さらに、当ウェブサイトまたは当社関連のその他のウェブサイトに登録や使用する場合、ルール、キャンペーン利用規約、プライバシーポリシーに従い、またこれらをすべてを読み、理解したうえで承認するものとみなされます。</span></strong><br />
                    <br />
                    <br />
                    <strong><span>2. </span></strong><strong><span>義務、必須条件および責任</span></strong><br />
                    <br />
                    <strong><span>2.1</span></strong><br />
                    <strong><span>本利用規約に同意しアカウント登録を行うことで、ユーザーは、次のことを表明し、保証するものとします</span></strong><strong>
                        <span>
                            :<br />
                            <br />
                            2.1.1
                        </span>
                    </strong><br />
                    <strong><span>アカウントを個人的に登録する</span></strong><br />
                    <strong><span>ユーザー名およびパスワードを含むユーザーのアカウント情報および、またはウェブサイトを介してユーザーのアカウントにアクセスするすべての方法に関する責任は、ユーザー自身が負うものとします。</span></strong><br />
                    <strong><span>アカウントの安全性が損なわれる疑いがある場合、直ちに当社に連絡し、不正なアクセスを防ぐための適切な措置を講じる必要があります。</span></strong><br />
                    <br />
                    <strong>
                        <span>
                            2.1.2<br />
                            18
                        </span>
                    </strong><strong><span>歳以上であること。</span></strong><strong><span>(</span></strong><strong><span>未満は不可</span></strong><strong><span>)</span></strong><br />
                    <strong><span>未成年者のギャンブルは犯罪です。上記に違反していると思われる合理的な理由があるアカウントは、直ちに閉鎖され、すでに支払われた勝利金額を差し引いたすべての入金額がアカウントユーザーに払い戻されます。</span></strong><br />
                    <br />
                    <strong><span>2.1.3</span></strong><br />
                    <strong><span>当ウェブサイトで開設できるアカウントは一つのみです</span></strong><strong> </strong><strong><span>その理由に関わらず、ユーザーが複数のアカウントの開設、または開設を試みた場合は、当社の裁量で、重複するアカウントでのプレイを無効にすることを含む、ユーザーのいずれか、またはすべてのアカウントを閉鎖する場合があります。</span></strong><br />
                    <br />
                    <strong><span>2.1.4</span></strong><br />
                    <strong><span>ユーザーは他の人に代わってではなく自身のために、楽しむことや娯楽の目的のみで当ウェブサイトを利用するものします。</span></strong><br />
                    <br />
                    <strong><span>2.1.5</span></strong><br />
                    <strong><span>特定の地域では、当ウェブサイトへのアクセスおよび使用する権利が違法とみなされる場合があることを認識するものとします。</span></strong><br />
                    <strong><span>ユーザーの居住地域で、当社のウェブサイトを使用することが許可されているかどうかを確認するのはユーザー自身の責任であり、あらゆる地域での当ウェブサイトへのアクセスは当ウェブサイトが提供するサービスの利用の提案、もしくは勧誘を意味するものではありません。</span></strong><br />
                    <br />
                    <strong><span>2.1.6</span></strong><br />
                    <strong><span>アカウントの登録時および存続期間中に要請される個人情報は、正確なものを提供するものとします。個人情報は、氏名、住所、生年月日、メールアドレス、電話番号、決済情報などを含みますが、これに限定されることはありません。この義務を守り、情報が常に最新のものであることを保証するのはユーザー自身の責任です。情報が変更された場合、および登録フォームで提供した必須情報に変更があった場合は、当社に通知するものとします。</span></strong><br />
                    <br />
                    <strong><span>2.1.7</span></strong><br />
                    <strong><span>当ウェブサイトを使用するほかのプレイヤー、およびマハラジャの従業員であるサポートエージェントに対して、侮辱的もしくは節度に欠いた発言を避け、礼儀正しく接するものとします。チャットの使用は、当社提供サービスに関連する問い合わせのみとさせていただきます。</span></strong><br />
                    <br />
                    <br />
                    <strong><span>3. </span></strong><strong><span>アカウントと認証チェック</span></strong><br />
                    <br />
                    <strong><span>3.1</span></strong><br />
                    <strong><span>当ウェブサイトで賭けをしたり入金をするためには、まずユーザー自身が個人的にアカウント（「アカウント」）を開設する必要があります。当社が提供するゲームを実際にリアルマネーを使ってプレイするためには、当ウェブサイトにて登録しなければなりません。マハラジャは、独自の裁量でアカウントの登録や開設を拒否する権利を有します。</span></strong><br />
                    <br />
                    <strong><span>3.2</span></strong><br />
                    <strong><span>一人のユーザー、</span></strong><strong><span>IP</span></strong><strong><span>アドレス、およびデバイスにつきに認められているのは、一アカウントのみです。複数のアカウントを持つユーザーを特定した場合は、当社は、重複したアカウントを閉鎖し、出金可能な資金を返却する権利を留保します。</span></strong><br />
                    <br />
                    <strong><span>3.3</span></strong><br />
                    <strong><span>アカウント登録過程の一環として、ウェブサイトにログインするためのユーザー名とパスワードを選択する必要があります。ログイン情報を安全に保管することは、ユーザー自身のみの責任です。ユーザーは、ログイン情報を決して誰にも開示してはいけません。当社は、意図的または偶発的、能動的または受動的だったに関わらず、第三者へのログイン情報の開示に起因する、第三者によるアカウントの悪用や誤用に関する責任を一切負いません。ユーザーのログイン情報を使用して行われた活動は、ユーザー自身によって実行されたものとみなされ、そのような活動から生じる責任はすべてユーザーが追うものとします。万が一、第三者がユーザーのログイン情報を認識している場合、当社に通知すること、およびログイン情報を変更することはユーザー自身の責任です。</span></strong><br />
                    <br />
                    <strong><span>3.4</span></strong><br />
                    <strong><span>当社は、いかなる理由に関わらず、いつでもユーザーの身元確認を行い、関連する書類の提出を要請する権利を留保します。これには、以下の事項が含まれますがこれらに限定されません</span></strong><strong><span>: </span></strong><strong><span>身元調査、信用調査、または法律で認められてる個人履歴の調査。こういった調査の基準は各ケースによりますが、氏名、住所、年齢、職業などのユーザーの登録情報の確認、ユーザーの金銭的地位、資金源などのユーザーの金銭的取引の確認、および</span></strong><strong><span>/</span></strong><strong><span>またはゲーム活動などを含みます。</span></strong><br />
                    <strong><span>マハラジャには、そのような調査が行われていることをユーザーに伝える義務は一切ないものとします。これらの調査には、許可を受けた信用照会機関、ユーザーの身元を確認するための身元確認サービス、および</span></strong><strong><span>/</span></strong><strong><span>または不正防止機関などの調査を行う特定の第三者企業の使用が含まれる場合があります。マハラジャは、これらの調査の結果が否定的または不確実な場合、独自の裁量でアカウントを閉鎖し、すべての残高を保留することがあります。すべての個人情報は当社のプライバシーポリシーに従って処理されます。</span></strong><br />
                    <br />
                    <strong><span>3.5</span></strong><br />
                    <strong><span>マハラジャは、法的義務および内部ポリシーに従って、ユーザーのアカウントでの入金または出金の処理を行う際に、適正評価の書類の提出を含む追加の本人確認手続きを行う権利を留保します。適正評価手続きに使われるすべての書類が本物であることを保証するのはユーザーの責任です。偽造書類は、資金の没収およびそのような書類の拒否につながる可能性があります。これらの確認手続きは、合理的な時間枠内で実行されるものとします。なお、疑義を避けるため、これらの確認手続きが実行されるまで、ユーザーのアカウントへの資金の支払いなどを遅らせる場合があります。</span></strong><br />
                    <br />
                    <strong><span>3.6</span></strong><br />
                    <strong><span>マネーロンダリング防止のため、すべての決済取引のチェックが行われます。マハラジャおよびすべての規制または管理機関は、犯罪防止の目的で、すべての取引のモニターまたは調査を要求することができます。マハラジャは、疑わしい取引を関連管轄当局に報告します。また、当社は、当社のゲームに関連する疑わしい行為を認識した場合は、直ちに関連機関に報告するものとします。マハラジャは、該当するマネーロンダリングおよびテロ資金供与防止の法律および規制に従って、アカウントの凍結または閉鎖、およびアカウント残高の保留を行う場合があります。</span></strong><br />
                    <br />
                    <strong><span>3.7</span></strong><br />
                    <strong><span>マハラジャは、当社独自の裁量で、ユーザーとの取引関係を継続することが当社のライセンスおよび一般規制義務、または当社のあらゆるサービスに悪影響を与える可能性があるとみなした場合、一切の説明なしで、個人のアカウントの開設を拒否し、またはいつでもアカウントを凍結または閉鎖する権利を留保します。ただし、マハラジャによりすでに行われている契約上の義務は、法律でマハラジャが使用可能な権利を損なうことなく、順守されるものとします。</span></strong><br />
                    <br />
                    <strong><span>3.8</span></strong><br />
                    <strong><span>ユーザーは、いつでもアカウントにログインし、入金、ボーナスクレジット、勝利金、賭け金などのアカウント履歴を確認することができます。誤りに気付いた場合は、必要に応じて調査および修正ができるよう、直ちにマハラジャに報告する必要があります。</span></strong><br />
                    <br />
                    <strong><span>3.9</span></strong><br />
                    <strong><span>ユーザーのアカウントに、クレジットや勝利金またはその他の資金が誤って入金された場合には、ユーザーは、メールまたはチャットを使って、直ちにマハラジャに報告する必要があります。誤って入金された金額は例外なくマハラジャの所有物であり、ユーザーは該当する金額を直ちにアカウントからマハラジャに返金する必要があります。誤って入金された資金を出金した場合、ユーザーは、直ちに返済する必要のある出金額のマハラジャに対する清算債務者とみなされます。誤って入金されたクレジット、勝利金またはその他の資金を使用して賭けが行われた場合、これらの賭けはすべて無効となります。</span></strong><br />
                    <br />
                    <strong><span>3.10</span></strong><br />
                    <strong><span>アカウント残高の金額にかかわらず、残高に利息は一切支払われません。したがってユーザーは、決してマハラジャを金融機関として扱わないものとします。</span></strong><br />
                    <br />
                    <strong><span>3.11</span></strong><br />
                    <strong><span>ユーザーは、マハラジャが、ユーザーによる不正行為および共謀を固く禁じていることを理解し承認するものとします。不正行為や共謀が行われたと合理的に判断された場合、当社は、そのような行為の結果として行われたと思われる賭けを無効にし、および、またはユーザーのアカウントからすべての資金を没収し、閉鎖する権利を留保します。ほかのプレイヤーが、不正行為や共謀によって不当な利益を得ていると考える合理的な根拠のあるユーザーは、メールまたはチャットでマハラジャに報告する必要があります。</span></strong><br />
                    <br />
                    <strong><span>3.12</span></strong><br />
                    <strong><span>ほかのユーザーアカウントへの資金移動は禁止されています。また、その逆も許可されません。</span></strong><br />
                    <br />
                    <strong><span>3.13</span></strong><br />
                    <strong><span>ユーザーは、当ウェブサイトをハッキングしたり、いかなる方法でも当サイトのコードを変更したりしないことに同意します。また、当サイトを使用するにあたり、ユーザー自身、または第三者にかかわらず、ロボット、自動的、機械的、電子的またはそのほかのデバイスを使用して、当サイトでの決断を自動的に行わないことに同意するものとします。当社は、これらのデバイス、またはプレイヤーに不当な優位性を提供するように作られた外部のリソースが、当ウェブサイトで使用されていると合理的に判断された場合には、そのようなデバイスを使って行われたと思われるプレイを無効にする権利を留保します。当社は、調査の対象となるアカウントを一時閉鎖し、当社の独自の裁量でアカウントを閉鎖する場合があります。当社は、これらのデバイスの使用は詐欺行為と同様であるとみなし、このような場合には、アカウントが閉鎖された時点での残高の払い戻しを行わない権利を留保します。</span></strong><br />
                    <br />
                    <strong><span>3.14</span></strong><br />
                    <strong><span>マハラジャは、外国の政府において重要な地位を占める人物（外国</span></strong><strong><span>PEPs</span></strong><strong><span>）とみなされるユーザーへのサービスの提供は行っておりません。いずれかの段階で外国</span></strong><strong><span>PEPs</span></strong><strong><span>と判断された場合は、ユーザーのアカウントは閉鎖され、すべての入金は返金されます。外国</span></strong><strong><span>PEPs</span></strong><strong><span>としての判断に同意しない場合は、メールまたはチャットでご連絡ください。</span></strong><br />
                    <br />
                    <br />
                    <strong><span>4. </span></strong><strong><span>入金</span></strong><br />
                    <br />
                    <strong><span>4.1</span></strong><br />
                    <strong><span>アカウントへの入金において、ユーザーは、合法的な機関によって発行され、合法的にユーザーの名義である有効なクレジットカード、およびその他の決済手段のみを使用することに同意するものとします。ユーザーの決済手段の名義が、ユーザー自身のものではないと当社が判断した場合、または合理的な根拠がある場合、ユーザーのアカウントを閉鎖し、すべての勝利金を無効にする権利を留保します。マハラジャは、企業向けに発行されたカードの使用を禁止します。</span></strong><br />
                    <br />
                    <strong><span>4.2</span></strong><br />
                    <strong><span>マハラジャでは、さまざまな通貨でのプレイを受け入れています。</span></strong><br />
                    <strong><span>ユーザーはその中からアカウントで使用するデフォルト通貨をひとつ選択しなければなりません。ユーザーが選択した通貨以外の通貨でマハラジャに送金された資金は、その時点での為替レートを使って、ユーザーのデフォルト通貨に変換されます。為替レートの費用はすべてユーザーが負担するものとします。</span></strong><br />
                    <br />
                    <strong><span>4.3</span></strong><br />
                    <strong><span>アカウント開設後、ユーザーは、賭けおよびプレイを開始できる前に最低額以上の入金を行う必要があります。最小および最大入金額は、当ウェブサイトにあるユーザーのアカウントの「入金」ページにて確認できます。ユーザーは、アカウントにある資金のみで賭け、およびプレイすることに同意するものとします。</span></strong><br />
                    <br />
                    <strong><span>4.4</span></strong><br />
                    <strong><span>不正な手段で取得した資金を入金することは違法です。適用される法律に従って、マハラジャは、ユーザーのアカウントへの入金に使用されたクレジットカード</span></strong><strong><span>/</span></strong><strong><span>デビットカードと同じ方法に送金を行います。ひとつ以上のクレジットカード</span></strong><strong><span>/</span></strong><strong><span>デビットカードが登録されている場合は、過去</span></strong><strong><span>6</span></strong><strong><span>か月に最も多く入金に使用された決済口座に送金されます。</span></strong><br />
                    <br />
                    <strong><span>4.5</span></strong><br />
                    <strong><span>クレジットカードまたはデビットカードによる入金を行った場合、当社の合理的な裁量により、該当するカードの下</span></strong><strong><span>4</span></strong><strong><span>桁を除くすべての番号を確認できるカードの表面、および</span></strong><strong><span>CVV</span></strong><strong><span>・</span></strong><strong><span>CVV2</span></strong><strong><span>番号を除く裏面の画像の提出を要請する場合があります。</span></strong><br />
                    <br />
                    <strong><span>4.6</span></strong><br />
                    <strong><span>キャンペーン、ロイヤリティプログラム、またはその他のマーケティングキャンペーンの一環として、ボーナス資金がユーザーのアカウントに加算されることがあります。これらのボーナスはウェブサイト上で賭けに利用する必要があり、そのまま出金する事はできません。</span></strong><br />
                    <strong><span>キャンペーンによっては、各キャンペーンの特定の利用規約に沿って条件を達成すると、これらのボーナスがリアルマネーへ換金される場合があります。詳しくは各キャンペーン利用規約をご参照ください。</span></strong><br />
                    <br />
                    <strong><span>4.7</span></strong><br />
                    <strong><span>アカウントへの入金は、常に金融機関、または決済サービス機関を通じて行われます。入金の手続き、利用規約、利用可能性、手数料および処理時間は、関連する金融機関または決済サービス機関によって異なる場合があります。</span></strong><br />
                    <br />
                    <strong><span>4.8</span></strong><br />
                    <strong><span>クレジットは認められていません。アカウントに十分な資金を維持し、それに応じて賭けを行うことはユーザーの責任です。アカウント残高が不十分な場合のギャンブル取引は成立しません。当社は、ユーザーのアカウントにすべての賭けを補う十分な資金がない場合、不注意で行われたまたは受け入れられた賭けを無効にする権利を留保します。</span></strong><br />
                    <br />
                    <br />
                    <strong><span>5. </span></strong><strong><span>カジノゲーム特有のルール</span></strong><br />
                    <br />
                    <strong><span>5.1</span></strong><br />
                    <strong><span>「無料ゲーム」モードでのゲームプレイから得た勝利金およびアカウント残高は、一切の商業的価値を持たず、現金、クレジット、またいかなる形の利益として償還されることはありません。</span></strong><br />
                    <br />
                    <strong><span>5.2</span></strong><br />
                    <strong><span>当ウェブサイトで提供されているゲームは、ランダム・ナンバー・ジェネレーター（</span></strong><strong><span>RNG)</span></strong><strong><span>を使用し、各ゲームの無作為なゲーム結果、およびプロダクトやゲームが公正であることを保証します。この乱数システムは、認可を受けた独立した第三者機関により監査認証されています。当ウェブサイトの「無料ゲーム」モードと「リアルマネー」モードには、まったく同じ乱数ジェネレーターが使用されています。</span></strong><br />
                    <br />
                    <br />
                    <strong><span>6. </span></strong><strong><span>保証と責任</span></strong><br />
                    <br />
                    <strong><span>6.1</span></strong><br />
                    <strong><span>マハラジャは以下の事項を保証しておりません</span></strong><strong><span>: </span></strong><strong><span>当ウェブサイトが完璧で、エラーなく作動すること、ウェブサイトおよび当サイトで提供しているゲームが中断なくアクセスできること、ウェブサイトとゲームが目的に適合していること。マハラジャは明示的または示唆的にかかわらず、このような保証は一切いたしかねます。</span></strong><br />
                    <br />
                    <strong><span>6.2</span></strong><br />
                    <strong><span>予期できない技術的な問題、または第三者プロバイダーの技術的な問題といったマハラジャの管理外の状況において、マハラジャは、プレイのキャンセルおよび</span></strong><strong><span>/</span></strong><strong><span>または払い戻しを行うことができるものとします。また、ユーザーは、ユーザーのコンピューター機器またはモバイルデバイス、およびインターネッとの接続が、ウェブサイトの性能と操作に影響する可能性があることを認識するものとします。マハラジャは、ユーザーの機器、インターネット接続、または第三者プロバイダーに起因する故障や問題に関して一切責任を負いません。これには、プレイができない、または特定のゲームに関連する情報の表示または受信ができない場合も含まれます。</span></strong><br />
                    <br />
                    <strong><span>6.3</span></strong><br />
                    <strong><span>いかなる理由に関わらず、中断または切断された承認済みのゲームラウンドが生じた場合、すべてのユーザーの取引は正確に記録されています。未完了のゲームラウンドは、通常、ゲームが再開されると復元されるか、またはそれが不可能な場合には、そのゲームラウンドはマハラジャにより削除され、プレイ金額がユーザーのアカウントに払い戻されます。</span></strong><br />
                    <br />
                    <strong><span>6.4</span></strong><br />
                    <strong><span>マハラジャは独自の裁量で、ユーザーに事前通知することなく、当ウェブサイトおよび</span></strong><strong><span>/</span></strong><strong><span>または特定のゲームを一時的に利用不可能にする権利を留保します。当社は、こういった状況の結果としてユーザーに生じた損失について一切の責任を負いません。</span></strong><br />
                    <br />
                    <strong><span>6.5</span></strong><br />
                    <strong><span>マハラジャは、いかなるダウンタイム、サーバーの中断、遅延、またはゲームプレイの技術的もしくは政治的妨害についての一切の責任を負いません。払い戻しは、マハラジャの裁量のみで行われるものとします。</span></strong><br />
                    <br />
                    <br />
                    <strong><span>7. </span></strong><strong><span>免責事項</span></strong><br />
                    <br />
                    <strong><span>7.1</span></strong><br />
                    <strong><span>ユーザーは、当ウェブサイトで提供されるサービスが娯楽目的のみであることを認めるものとします。ユーザーは、当サービスを使用することを要求されてはおらず、ユーザーのみの選択および裁量で当サイトのサービスに参加するものとします。結果として、ユーザーは、ユーザー自身の責任で当ウェブサイトを訪れ、ゲームに参加します。ユーザーは、当ウェブサイトおよびサービスへの関心は、職業上のものではなく個人的なものであり、個人の娯楽の目的のみでアカウントを登録したと断言するものとします。当社が提供するサービスのその他の目的の使用は、固く禁じられています。</span></strong><br />
                    <br />
                    <strong><span>7.2</span></strong><br />
                    <strong><span>前述の規定の一般性を失うことなく、マハラジャおよびその取締役、従業員、パートナー、第三者のゲーム配信会社は、法律または契約上の義務で許可されている範囲で、直接的、間接的、特徴的、結果的、偶発的またはその他のかたちに関わらず、ユーザーの当ウェブサイトの使用またはゲームへの参加に関連して生じた、いかなる損失、費用、経費または損害について責任を負いません。</span></strong><br />
                    <strong><span>なお、ゲームでのエラーまたは誤作動に対するマハラジャの責任は該当のゲームのに限定されます。</span></strong><br />
                    <br />
                    <strong><span>7.3</span></strong><br />
                    <strong><span>当ウェブサイトに表示されているすべての情報は、情報提供のみを目的として提供されており、いかなる性質の専門的なアドバイスを提供することは意図していません。マハラジャおよびその独立したプロバイダーは、情報の誤り、不完全性、不正確さ、遅延、またはその中に含まれる情報に起因した行動について、一切責任を負いません。</span></strong><br />
                    <br />
                    <br />
                    <strong><span>8. </span></strong><strong><span>知的財産</span></strong><br />
                    <br />
                    <strong><span>8.1</span></strong><br />
                    <strong><span>ウェブサイト上のすべての知的財産権</span></strong><strong><span>(IP</span></strong><strong><span>権</span></strong><strong><span>)</span></strong><strong><span>は、マハラジャまたは第三者のソフトウェアプロバイダーに帰属します。当ウェブサイトを利用することによって、当サイトまたはソフトウェアプロバイダーの知的財産権の所有権が、ユーザーに付与されることはありません。知的財産権には、特許、著作権、意匠権、商標、データベース権やこれらいずれかのアプリケーション、また著作者人格権、知識、企業秘密、ドメイン名、</span></strong><strong><span>URL</span></strong><strong><span>、商号、およびその他すべての知的財産権および産業所有権</span></strong><strong><span> (</span></strong><strong><span>およびこれらに関係したライセンス</span></strong><strong><span>) </span></strong><strong><span>などがありますが、登録の有無、登録が可能であるかどうか、特定の国や地域、または世界の他の地域に存続するかどうかにかかわらず、これらに限定されません。</span></strong><br />
                    <br />
                    <strong><span>8.2</span></strong><br />
                    <strong><span>ユーザーは、適用する法律で規定された範囲内で以下のことを行うことはできません</span></strong><strong>
                        <span>
                            :<br />
                            <br />
                            8.2.1
                        </span>
                    </strong><br />
                    <strong><span>ソフトウェアおよび</span></strong><strong><span>/</span></strong><strong><span>またはウェブサイトのコピー、配布、公開、リバースエンジニアリング、逆コンパイル、逆アセンブル、修正または翻訳を行ったり、ソフトウェアおよび</span></strong><strong><span>/</span></strong><strong><span>またはウェブサイトのソースコードから二次的著作物を作成するためにソースコードにアクセスしようとすること。</span></strong><br />
                    <br />
                    <strong><span>8.2.2</span></strong><br />
                    <strong><span>ソフトウェアの販売、譲渡、再許諾、移譲、配布、または第三者への貸与。</span></strong><br />
                    <br />
                    <strong><span>8.2.3</span></strong><br />
                    <strong><span>コンピューターネットワークなどを介して、第三者がソフトウェアを使用できるようにすること。</span></strong><br />
                    <br />
                    <strong><span>8.2.4</span></strong><br />
                    <strong><span>物理的または電子的手段を問わず、ソフトウェアを他国に輸出すること。</span></strong><br />
                    <br />
                    <strong><span>8.2.5</span></strong><br />
                    <strong><span>適用される法律または規制で禁止されている方法でソフトウェアを使用すること。</span></strong><br />
                    <br />
                    <strong>
                        <span>
                            8.2.6<br />
                            IP
                        </span>
                    </strong><strong><span>権に害を及ぼす、またはその可能性がある行為を行うこと、また、マハラジャ、その従業員、取締役、役員、およびコンサルタントのイメージや世評を損なう行為を行うこと。</span></strong><br />
                    <br />
                    <strong><span>8.3</span></strong><br />
                    <strong><span>ユーザーは、ウェブサイトまたはゲームに関連してユーザーが使用する名前や画像（ユーザー名など）が、第三者の知的財産権、プライバシー、またはその他の権利を損害したり、他者に対して不快なものでないことを保証するものとします。ユーザーは、当社のプライバシーポリシーの条件に従い、ウェブサイトまたはゲームに関連するあらゆる目的で、これらの名前および画像を使用する、世界的、取り消し不能、譲渡可能、著作権使用料無料の再許諾可能な許可をマハラジャに付与します。</span></strong><br />
                    <br />
                    <br />
                    <strong><span>9. </span></strong><strong><span>クレーム・仲裁</span></strong><br />
                    <br />
                    <strong><span>9.1</span></strong><br />
                    <strong><span>当ウェブサイトに関するクレームの申し立ては、ウェブサイトの手順に従ってカスタマーサポートチームまでご連絡ください。または、</span></strong><strong><span> service@casino-maharaja.com </span></strong><strong><span>までメールにてご連絡ください。</span></strong><br />
                    <strong><span>特定のゲームに関するクレームは、当該事項が発生してから</span></strong><strong><span>7</span></strong><strong><span>営業日以内に申し立てる必要があります。支払い、アカウントの停止、ボーナスの計算を含むそのほかの事項に関するクレームは、当該事項発生から</span></strong><strong><span>1</span></strong><strong><span>か月以内に申し立てを行う必要があります。</span></strong><br />
                    <br />
                    <strong><span>9.2</span></strong><br />
                    <strong><span>クレームはカスタマーサポートチームにより対処され、サポートエージェントが直ちに解決できない場合にはマハラジャ内でエスカレーションすることとします。ユーザーは、クレームの状況について合理的に通知されるものとします。当社は、可能な限り短い時間で、通常の状況においては</span></strong><strong><span>14</span></strong><strong><span>営業日以内に、クレームを解決するよう常に努めるものとします。</span></strong><br />
                    <br />
                    <br />
                    <strong><span>10. </span></strong><strong><span>一般</span></strong><br />
                    <br />
                    <strong><span>10.1</span></strong><br />
                    <strong><span>本利用規約の条項に違反した場合、または違反したと疑われる合理的な根拠がある場合、当社は、ユーザーのアカウントの開設拒否、停止、または閉鎖、またプレイ金の支払いの差し控え、およびユーザーのアカウントにある残高を損害賠償にあてがう権利を留保します。上記は、状況に応じて適切とみなされる、ユーザーに対する法的措置をとる権利を排除するものではありません。</span></strong><br />
                    <br />
                    <strong><span>10.2</span></strong><br />
                    <strong><span>マハラジャが解散または事実上その業務を終了することになった場合には、ユーザーは事前に通知されるものとします。通知後、マハラジャには、有効解散日または終了日まで、本利用規約から生じる義務を履行する責任があるものとします。</span></strong><br />
                    <br />
                    <strong><span>10.3</span></strong><br />
                    <strong><span>本利用規約は、情報提供および利便性の目的で、多言語にて公開されていますが、日本語版の本利用規約が他の言語版に優先するものとします。</span></strong><br />
                    <br />
                    <strong><span>10.4</span></strong><br />
                    <strong><span>当社は、当社の合理的な管理が及ばない事件、出来事、または原因に起因する当社の本利用規約に基づく義務の履行遅延または不履行について、本利用規約に違反したとされず責任を負わないものとします。</span></strong><br />
                    <br />
                    <strong><span>10.5</span></strong><br />
                    <strong><span>本利用規約のいずれかの規定が、違法または法的強制力がないと判断された場合、そのような規定は本利用規約から分離されます。その他のすべての規定は引き続き有効であり、この分離による影響は一切受けません。</span></strong>

                </div>
            </div>
        </div>
    </div>
</body>`;
                } else {
                    rulesHtml = `<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>マハラジャ</title>
    <!-- <link rel="stylesheet" href="Scripts/OutSrc/lib/bootstrap/css/bootstrap.min.css" type="text/css" /> -->
    <link rel="stylesheet" href="css/icons.css" type="text/css" />
    <!-- <link rel="stylesheet" href="css/global.css" type="text/css" /> -->
    <link rel="stylesheet" href="css/manual.css" type="text/css" />
</head>
<body>
    <div class="page-container">
        <!-- Heading-Top -->
        <div id="heading-top"></div>
        <div class="page-content">
            <div class="manual-container">
                <h2 class="language_replace">利用規約</h2>
                <div class="text-wrap">
                    <p dir="ltr">
                        <strong>
                            版本：1.0<br />
                            更新：12.11.2021<br />
                            <br />
                            <br />
                            1. 一般<br />
                            本頁面構成了 マハラジャ 網頁的使用條款（以下簡稱使用條款），所有使用本網站的註冊用戶必須同意這些使用條款。這些使用條款和此處明確提及的文件構成雙方之間的協議和諒解，並管轄我們與您之間的合同關係。在使用 マハラジャ（以下簡稱本網站）之前，請務必閱讀並理解這些使用條款。如果您不同意這些使用條款，請停止使用並繼續使用本網站。我們還建議您充分了解您的隱私政策。
                        </strong>
                    </p>

                    <p dir="ltr">
                        <strong>
                            1.1<br />
                            這些使用條款包括一些附加條款，例如：<br />
                            --您選擇玩的遊戲規則（&ldquo;規則&rdquo;）<br />
                            --我們不適用於特定活動的活動使用條款（&ldquo;活動使用條款&rdquo;）<br />
                            --我們的隱私政策規定了有關處理我們從您那裡收集的或您提供給我們的個人信息的條款和條件。<br />
                            <br />
                            1.2<br />
                            您理解並同意您受這些使用條款中包含的條款的約束，這些條款可能會不時修訂。此外，通過註冊和使用本網站或我們偶爾擁有的其他網站，您也將遵守規則、活動條款和條件、隱私政策，並閱讀並理解所有這些內容。您將被視為接受這樣做之後。<br />
                            <br />
                            <br />
                            <br />
                            2. 義務、要求和責任<br />
                            <br />
                            2.1<br />
                            同意這些使用條款並註冊帳戶，即表示您聲明並保證：<br />
                            <br />
                            2.1.1<br />
                            個人註冊您的帳戶 您對您的所有帳戶信息，包括您的用戶名和密碼，和/或您通過網站訪問您的帳戶的任何其他方式全權負責。 如果您懷疑您的帳戶已被盜用，您應立即與我們聯繫並採取適當措施防止未經授權訪問您的帳戶和您的帳戶餘額。<br />
                            <br />
                            2.1.2<br />
                            必須年滿 18 歲。（不少於）<br />
                            未成年人賭博是犯罪。有合理理由出現違反上述規定的賬戶將被立即關閉，所有押金將退還給賬戶用戶，減去已支付的中獎金額。<br />
                            <br />
                            2.1.3<br />
                            本網站只能開設一個賬戶<br />
                            無論出於何種原因，如果您開立或嘗試開立多個賬戶，我們會酌情決定您的任何或所有賬戶，包括禁止對重複賬戶下注。可能會被阻止或關閉。<br />
                            <br />
                            2.1.4<br />
                            您自行決定僅出於娛樂和娛樂目的使用本網站，不是代表他人，而是您自己。<br />
                            <br />
                            2.1.5<br />
                            您承認在某些領域您訪問和使用本網站的權利可能被視為非法。<br />
                            您有責任確保您的居住地區允許您使用我們的網站。本網站在所有地區的可用性並不意味著建議或招攬使用本網站提供的服務。<br />
                            <br />
                            2.1.6<br />
                            應真實、完整、準確地提供在賬戶註冊時及賬戶存續期間所要求的個人信息。個人信息包括但不限於姓名、地址、出生日期、電子郵件地址、電話號碼、付款信息等。用戶有責任遵守此義務並確保信息始終是最新的。如果任何信息發生變化或註冊表上提供的所需信息發生變化，我們將通知您。<br />
                            <br />
                            2.1.7<br />
                            我們將以禮貌的方式對待使用本網站的其他玩家和作為 マハラジャ 員工的支持代理，避免侮辱或無節制的言論。聊天的使用僅限於我們的服務和與我們的服務嚴格相關的查詢。在任何情況下都不會接受不遵守此條件的行為。<br />
                            <br />
                            <br />
                            <br />
                            3. 賬戶和認證檢查<br />
                            <br />
                            3.1<br />
                            為了在本網站下注或存款，用戶必須首先親自開立賬戶（&ldquo;賬戶&rdquo;）。為了實際使用真錢玩我們公司提供的遊戲，您必須在本網站註冊。マハラジャ 保留自行決定拒絕註冊或開設賬戶的權利。<br />
                            <br />
                            3.2<br />
                            每個用戶、IP 地址和設備只允許有一個帳戶。如果我們發現一個用戶擁有多個賬戶，我們保留關閉重複賬戶並退還可提取資金的權利。<br />
                            <br />
                            3.3<br />
                            作為帳戶註冊過程的一部分，您需要選擇用戶名和密碼才能登錄網站。確保您的登錄信息安全是您的唯一責任。用戶不得向任何人透露其登錄信息。對於因向第三方披露您的登錄信息而導致的任何第三方濫用或誤用您的帳戶，無論是有意或無意、主動或被動，我們概不負責。使用您的登錄信息進行的活動被認為是由您進行的，您應對此類活動產生的任何責任承擔全部責任。萬一第三方知道您的登錄信息，您有責任通知我們並更改您的登錄信息。<br />
                            <br />
                            3.4<br />
                            我們保留隨時以任何理由驗證您的身份並要求提交相關文件的權利。這包括但不限於：背景調查、信用調查或法律允許的個人歷史調查。這些調查的標準會因情況而異，但會確認用戶的註冊信息，如姓名、地址、年齡、職業、用戶的財務狀況、資金來源等用戶財務交易的確認，和/或遊戲。包括活動等。<br />
                            マハラジャ 沒有義務通知用戶正在進行此類調查。這些調查可能包括使用某些第三方公司進行調查，例如授權的信用推薦機構、驗證用戶身份的身份識別服務和/或欺詐預防機構。如果這些調查的結果是否定的或不確定，マハラジャ 可能會自行決定關閉您的帳戶並扣留所有餘額。所有個人信息將根據我們的隱私政策進行處理。<br />
                            <br />
                            3.5<br />
                            マハラジャ 保留在根據法律義務和內部政策處理您賬戶中的存款或取款時執行額外身份驗證程序的權利，包括提交驗證文件。.. 用戶有責任確保盡職調查過程中使用的所有文件都是真實的。偽造文件可能導致資金被沒收和此類文件被拒絕。這些確認程序應在合理的時間範圍內進行。為避免疑慮，我們可能會延遲向用戶帳戶支付資金，直到執行這些確認程序。<br />
                            <br />
                            3.6<br />
                            檢查所有付款交易以防止洗錢。マハラジャ 和所有監管或管理機構可能會出於預防犯罪的目的要求對所有交易進行監控或調查。マハラジャ 向相關主管部門報告可疑交易。此外，我們將立即向相關組織報告與我們的遊戲有關的任何可疑活動。マハラジャ 可能會根據適用的反洗錢和恐怖主義融資法律法規凍結或關閉您的賬戶並保留您的賬戶餘額。<br />
                            <br />
                            3.7<br />
                            網上賭場的世界，在我們的判斷，在所有的情況下，繼續與貴公司建立業務關係，願我們的許可證和一般監管義務，或我們的任何服務產生負面影響。我們保留拒絕開立個人帳戶或凍結權或隨時關閉帳戶而無需解釋。但是，在線賭場世界已經作出的合同義務應得到遵守，但不影響法律使用在線賭場世界的權利。<br />
                            <br />
                            3.8<br />
                            用戶可以隨時登錄他們的賬戶，查看他們的賬戶歷史，如存款、紅利、獎金和賭注。如果您發現錯誤，您應該立即將其報告給 マハラジャ，以便您可以根據需要進行調查和糾正。<br />
                            <br />
                            3.9 如果積分、獎金或其他資金意外存入您的賬戶，您必須立即通過電子郵件或聊天向 マハラジャ 報告。錯誤存入的金額無一例外是 マハラジャ 的財產，用戶必須立即將適用金額從其帳戶退還給 マハラジャ。如果您提取意外存入的資金，您將被視為在線賭場世界的清算債務人，需要立即償還提取金額。如果您使用意外存入的積分、獎金或其他資金進行投注，所有這些投注都將無效。<br />
                            <br />
                            3.10<br />
                            無論您的賬戶餘額有多少，您的餘額都不會支付利息。因此，用戶絕不能將 マハラジャ 視為金融機構。<br />
                            <br />
                            3.11<br />
                            用戶理解並承認，在線賭場世界嚴禁用戶作弊和串謀。如果合理確定發生了欺詐或勾結，我們將取消因此類行為而進行的任何投注和/或沒收用戶賬戶中的所有資金。我們保留關閉的權利。有合理依據的用戶如果認為其他玩家通過欺騙或陰謀不公平地獲利，應通過電子郵件或聊天向 マハラジャ 報告。<br />
                            <br />
                            3.12<br />
                            禁止向其他用戶賬戶轉賬。此外，不允許反向。<br />
                            <br />
                            3.13<br />
                            您同意不會以任何方式入侵我們的網站或修改我們的代碼。我們還使用機器人、自動、機械、電子或其他設備在我們的網站上自動做出決定，無論是通過您或第三方在使用本網站時的試驗或行動。您同意不這樣做。如果我們合理確定這些設備或旨在為玩家提供不公平優勢的外部資源正在本網站上使用，我們保留取消任何可能使用的投注的權利。我們可能會暫時關閉接受調查的帳戶，並自行決定關閉該帳戶。我們認為使用這些設備是欺詐行為，並保留在這種情況下在您的帳戶關閉時不退還您的餘額的權利。<br />
                            <br />
                            3.14<br />
                            マハラジャ 不向在外國政府中被視為重要人物（外國 PEP）的用戶提供服務。如果在任何階段被確定為外國 PEP，用戶的賬戶將被關閉，所有押金將被退還。如果您不同意我們作為外國 PEP 的決定，請通過電子郵件或聊天與我們聯繫。<br />
                            <br />
                            <br />
                            <br />
                            4. 入金<br />
                            <br />
                            4.1 在向您的賬戶入金時，您同意僅使用由合法機構發行的、以您的名義合法的有效信用卡和其他支付方式。.. 如果我們確定您的付款方式名稱不是您的或有合理理由，我們保留關閉您的帳戶並使所有獎金無效的權利。.. マハラジャ 禁止使用發給企業的卡。<br />
                            <br />
                            4.2<br />
                            マハラジャ 接受各種貨幣的投注。<br />
                            用戶必須選擇一種默認貨幣以在其帳戶中使用。以用戶選擇的貨幣以外的貨幣轉移到 マハラジャ 的資金將使用當前匯率轉換為用戶的默認貨幣。所有匯率費用由用戶承擔。<br />
                            <br />
                            4.3<br />
                            開戶後，用戶必須進行最低存款額，方可開始投注和玩遊戲。最低和最高存款可以在本網站您賬戶的&ldquo;存款&rdquo;頁面上找到。您同意僅使用您帳戶中的資金下注和玩遊戲。<br />
                            <br />
                            4.4<br />
                            存入以欺詐手段獲得的資金屬於違法行為。根據適用法律，マハラジャ 將以與用於將資金存入您賬戶的信用卡/借記卡相同的方式轉賬。如果您註冊了不止一張信用卡/借記卡，它們將被發送到過去 6 個月內用於存款最多的支付賬戶。<br />
                            <br />
                            4.5<br />
                            如果您使用信用卡或借記卡進行存款，在我們的合理判斷下，您可以看到除卡的最後 4 位數字外的所有數字，以及除 CVV / CVV2 號碼外的背面圖像。我們可能會要求你提交。<br />
                            <br />
                            4.6<br />
                            獎勵資金可能會作為活動、忠誠度計劃或其他營銷活動的一部分添加到您的帳戶中。這些獎金必須用於在網站上投注，不能按原樣提取。<br />
                            根據活動的不同，如果根據每個活動的特定條款和條件滿足條件，則這些獎金可以兌換為真錢。詳情請參閱各活動的條款及細則。<br />
                            <br />
                            4.7<br />
                            向您的賬戶存款始終是通過金融機構或支付服務機構進行的。存款程序、使用條款、可用性、費用和處理時間可能因相關金融機構或支付服務機構而異。<br />
                            <br />
                            4.8<br />
                            不允許使用積分。用戶有責任在賬戶中保持足夠的資金並相應地下注。如果賬戶餘額不足，賭博交易將無法完成。如果您的賬戶沒有足夠的資金來支付所有投注，我們保留取消無意或接受的投注的權利。<br />
                            <br />
                            <br />
                            <br />
                            5. 賭場遊戲特定規則<br />
                            <br />
                            5.1<br />
                            在&ldquo;免費遊戲&rdquo;模式下玩遊戲賺取的獎金和賬戶餘額沒有商業價值，必須兌換為現金、積分或任何形式的利潤。沒有。<br />
                            <br />
                            5.2<br />
                            本網站提供的遊戲使用隨機數生成器（RNG），以確保每個遊戲的結果都是隨機的，產品和遊戲的公平性。該隨機數系統是由一個獨立的，許可的第三方審核和認證。本網站的&ldquo;免費遊戲&rdquo;模式和&ldquo;真錢&rdquo;模式使用完全相同的隨機數生成器。<br />
                            <br />
                            <br />
                            <br />
                            6. 保證與責任<br />
                            <br />
                            6.1<br />
                            マハラジャ 不保證以下內容： 本網站完美無誤，您可以不間斷地訪問本網站和本網站提供的遊戲，並且遊戲符合目的。マハラジャ 不作任何此類保證，無論是明示的還是暗示性的。<br />
                            <br />
                            6.2<br />
                            在マハラジャ 無法控制的情況下，例如不可預見的技術問題或第三方提供商的技術問題，マハラジャ 可能會取消和/或退還投注。您還承認，您與計算機或移動設備以及互聯網的連接可能會影響您網站的性能和運行。マハラジャ 不對由您的設備、互聯網連接或第三方提供商造成的任何故障或問題負責。這包括您無法下注或無法查看或接收與特定遊戲相關的信息。<br />
                            <br />
                            6.3<br />
                            如果批准的遊戲回合因任何原因中斷或斷開連接，所有用戶交易都將被準確記錄。未完成的遊戲回合通常會在遊戲恢復時恢復，如果無法恢復，在線賭場世界將刪除該遊戲回合併將本金退還給用戶的帳戶。增加。<br />
                            <br />
                            6.4<br />
                            マハラジャ 保留自行決定暫時禁用本網站和/或某些遊戲的權利，恕不另行通知用戶。用戶因此而遭受的任何損失，我們概不負責。<br />
                            <br />
                            6.5<br />
                            マハラジャ 不對遊戲的任何停機時間、服務器中斷、延遲或技術或政治干擾負責。退款僅由 マハラジャ 自行決定。<br />
                            <br />
                            <br />
                            <br />
                            7. 免責聲明<br />
                            <br />
                            7.1<br />
                            用戶承認本網站提供的服務僅用於娛樂目的。用戶無需使用服務，應自行決定是否參與本網站的服務。因此，您有責任訪問我們的網站並參與遊戲。您聲明您對本網站和服務的興趣是個人的而非專業的，並且您註冊您的帳戶僅用於個人娛樂目的。嚴禁將我們提供的服務用於任何其他目的。<br />
                            <br />
                            7.2<br />
                            在不失上述規定的一般性的情況下，マハラジャ 及其董事、員工、合作夥伴和第三方遊戲經銷商，在法律或合同義務允許的範圍內，直接，我們對任何損失、費用、費用或損害承擔責任因您使用我們的網站或您參與遊戲而產生的，無論是間接的、特徵性的、後果性的、意外的或其他的。<br />
                            請注意，マハラジャ 對遊戲中的錯誤或故障的責任僅限於遊戲的交換。<br />
                            <br />
                            7.3<br />
                            本網站上顯示的所有信息僅供參考，無意提供任何性質的專業建議。マハラジャ 及其獨立提供商不對任何錯誤、不完整、不准確、延遲或根據其中包含的信息採取的行動負責。<br />
                            <br />
                            <br />
                            <br />
                            8. 知識產權<br />
                            <br />
                            8.1<br />
                            網站上的所有知識產權（IP rights）均屬於 マハラジャ 或第三方軟件提供商。通過使用本網站，本網站或軟件提供商的知識產權的所有權並不授予用戶。知識產權包括專利、版權、工業權、商標、數據庫權利和任何這些應用程序，以及精神權利、專有技術、商業秘密、域名、URL、商號和所有其他知識產權。這些包括產權和商業秘密（及相關許可），無論是否已註冊，是否可以註冊，是否在特定國家或地區或世界其他地區生存，不限於這些。<br />
                            <br />
                            8.2<br />
                            用戶，我們不能在法律規定的適用範圍內進行以下行為：<br />
                            <br />
                            8.2.1<br />
                            軟件和/或網站的副本、分發、發布、反向工程、反編譯、反彙編、修改或翻譯和訪問、軟件和/或嘗試訪問源代碼以從網站的源代碼創建衍生作品。<br />
                            <br />
                            8.2.2<br />
                            軟件銷售、轉讓、再許可、轉讓、分發或出租。<br />
                            <br />
                            8.2.3<br />
                            軟件可用給第三方，如通過計算機網絡。<br />
                            <br />
                            8.2.4<br />
                            通過物理或電子方式導出軟件到其他國家。<br />
                            <br />
                            8.2.5<br />
                            適用的法律或使用法規所禁止的方式將軟件。<br />
                            <br />
                            8.2.6<br />
                            損害知識產權，或進行有行為的可能性，在線賭場世界，其員工，董事，執行損害形象和聲譽的官員和顧問的行為。<br />
                            <br />
                            8.3<br />
                            用戶，網站或使用的名稱和圖像用戶與遊戲相關的（如用戶名）不損害第三方的知識產權、隱私或其他權利或冒犯他人。應予以保證。您可以根據我們的隱私政策的條款，將這些名稱和圖像用於與您的網站或遊戲相關的任何目的，在全球範圍內，不可撤銷、可轉讓且無版權。授予 マハラジャ 許可。<br />
                            <br />
                            <br />
                            <br />
                            9. 索賠和仲裁<br />
                            <br />
                            9.1 如果您對本網站有任何投訴，請按照網站上的說明聯繫客戶支持團隊。或者，請發送電子郵件至 service@casino-maharaja.com。<br />
                            有關特定遊戲的索賠必須在事件發生後的 7 日內提出。其他事項的索賠，包括付款、帳戶暫停和獎金計算，必須在此類事項發生後的一個月內提出。<br />
                            <br />
                            9.2<br />
                            如果支持代理無法立即解決索賠，則索賠將由客戶支持團隊處理並在 マハラジャ 內升級。應合理地通知用戶索賠的狀態。在正常情況下，我們將始終努力在最短的時間內和 14 個工作日內解決您的索賠。<br />
                            <br />
                            <br />
                            <br />
                            10. 一般條款<br />
                            <br />
                            10.1<br />
                            如果您違反了本使用條款的任何規定，或者您有合理的理由懷疑您已經違反了，我們將拒絕開立、暫停或關閉您的賬戶，並扣留獎金支付，並保留補償用戶賬戶餘額的權利。以上並不排除對用戶採取法律行動的權利，這在某些情況下被認為是適當的。<br />
                            <br />
                            10.2<br />
                            在線娛樂場世界解散或虛擬終止時，應提前通知用戶。收到通知後，マハラジャ 有責任履行由這些使用條款引起的義務，直至有效解散日期或結束日期。<br />
                            <br />
                            10.3<br />
                            本使用條款以提供信息和方便為目的，以多種語言發布，但本使用條款的日文版本將取代其他語言版本。<br />
                            <br />
                            10.4<br />
                            在不違反本使用條款的情況下，由於超出我們合理控制範圍的事件、事件或原因導致我們延遲或未履行本使用條款項下的義務，我們概不負責。<br />
                            <br />
                            10.5<br />
                            如果本使用條款的任何條款被確定為非法或不可執行，則該條款將與本使用條款分開。所有其他規定仍然有效，完全不受這種分離的影響。
                        </strong><br />
                        <br />
                        &nbsp;
                    </p>
                </div>
            </div>
        </div>

    </div>
</body>`;
                }

                $(divMessageBoxContent).html(rulesHtml);
                modal.toggle();
            } else {
                $(divMessageBoxContent).load(realPath, function () {
                    modal.toggle();
                });
            }
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
        var emailText = contactUsDom.querySelector(".contectUs_Eamil").value.trim();
        var bodyText = contactUsDom.querySelector(".contectUs_Body").value;
        var NickName = contactUsDom.querySelector(".contectUs_NickName").value;
        var Phone = contactUsDom.querySelector(".contectUs_Phone").value;

        if (emailText == "") {
            showMessageOK(mlp.getLanguageKey("錯誤"), mlp.getLanguageKey("請輸入回覆信箱"));
        }

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
                var gameData = {
                    GameBrand: gameBrand,
                    GameName: gameName,
                    GameLangName: gameLangName
                }
                window.sessionStorage.setItem("OpenGameBeforeLogin", JSON.stringify(gameData));
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

            if (gameBrand.toUpperCase() == "EWin".toUpperCase() || gameBrand.toUpperCase() == "YS".toUpperCase()) {
                gameWindow = window.open("/OpenGame.aspx?SID=" + EWinWebInfo.SID + "&Lang=" + EWinWebInfo.Lang + "&CurrencyType=" + API_GetCurrency() + "&GameBrand=" + gameBrand + "&GameName=" + gameName + "&HomeUrl=" + "<%=EWinWeb.CasinoWorldUrl%>/CloseGame.aspx", "Maharaja Game")
                CloseWindowOpenGamePage(gameWindow);
            } else {
                if (EWinWebInfo.DeviceType == 1) {

<%--                    gameWindow = window.open("/OpenGame.aspx?SID=" + EWinWebInfo.SID + "&Lang=" + EWinWebInfo.Lang + "&CurrencyType=" + API_GetCurrency() + "&GameBrand=" + gameBrand + "&GameName=" + gameName + "&HomeUrl=" + "<%=EWinWeb.CasinoWorldUrl%>/CloseGame.aspx", "Maharaja Game");
                    CloseWindowOpenGamePage(gameWindow);--%>

                    window.location.href = "/OpenGame_M.aspx?SID=" + EWinWebInfo.SID + "&Lang=" + EWinWebInfo.Lang + "&CurrencyType=" + API_GetCurrency() + "&GameBrand=" + gameBrand + "&GameName=" + gameName + "&HomeUrl=" + "<%=EWinWeb.CasinoWorldUrl%>/CloseGame.aspx";

                } else {
                    GameLoadPage("/OpenGame.aspx?SID=" + EWinWebInfo.SID + "&Lang=" + EWinWebInfo.Lang + "&CurrencyType=" + API_GetCurrency() + "&GameBrand=" + gameBrand + "&GameName=" + gameName + "&HomeUrl=" + "<%=EWinWeb.CasinoWorldUrl%>/CloseGame.aspx");
                }
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
    //.divGameFrame{width:70vw;height:39.375vw;background-color:#09f}
    function CloseGameFrame() {
        //滿版遊戲介面
        $('#divGameFrame').css('display', 'none');
        //滿版遊戲介面 end
        appendGameFrame();
    }

    function appendGameFrame() {
        $("#divGameFrame").children().remove();
        let vw = Math.max(document.documentElement.clientWidth || 0, window.innerWidth || 0);
        let vh = Math.max(document.documentElement.clientHeight || 0, window.innerHeight || 0);

        let w = vh * 16 / 9;

        if (w > vw) {
            w = vw - 110;
        } else if (Math.abs(vw - w) < 110) {
            w = vw - 110;
        }

        // class="divGameFrame"
        let tmp = `<div class="divGameFrameWrapper">
            <div class="btn-wrapper">
                <div class="btn btn-game-close" onclick="CloseGameFrame()"><i class="icon icon-mask icon-error"></i></div>
            </div>
            <iframe id="GameIFramePage" style="width:${w}px;height:${vh}px;background-color:#09f" name="mainiframe" sandbox="allow-same-origin allow-scripts allow-popups allow-forms allow-pointer-lock"></iframe>
        </div>`;
        $("#divGameFrame").append(tmp);
    }

    function CloseWindowOpenGamePage(e) {
        showMessageOK("", "關閉", function () {
            e.close();
        })
    }
    //#endregion

    //#region FavoriteGames And MyGames

    function favBtnClick(gameCode) {
        if (EWinWebInfo.UserLogined) {
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
        } else {
            showMessageOK(mlp.getLanguageKey("錯誤"), mlp.getLanguageKey("請先登入"), function () {
                API_LoadPage("Login", "Login.aspx");
            }, null);
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

                    getPromotionCollectAvailable();
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
            $(".avater-name").text(EWinWebInfo.UserInfo.LoginAccount);

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

        if ($('#langIcon').hasClass('icon-flag-JP')) {
            $('#langIcon').removeClass('icon-flag-JP');
        }

        if ($('#langIcon').hasClass('icon-flag-EN')) {
            $('#langIcon').removeClass('icon-flag-EN');
        }


        if ($('#langIcon').hasClass('icon-flag-ZH')) {
            $('#langIcon').removeClass('icon-flag-ZH');
        }
        switch (Lang) {
            case "JPN":
                LangText = "日本語";
                $("#btn_switchlang").append(`<i class="icon icon-mask icon-flag-JP"></i>`);
                $('#langIcon').addClass('icon-flag-JP');
                break;
            case "CHT":
                LangText = "繁體中文";
                $("#btn_switchlang").append(`<i class="icon icon-mask icon-flag-ZH"></i>`);
                $('#langIcon').addClass('icon-flag-ZH');
                break;
            case "ENG":
                LangText = "English";
                $("#btn_switchlang").append(`<i class="icon icon-mask icon-flag-EN"></i>`);
                $('#langIcon').addClass('icon-flag-EN');
                break;
            case "CHS":
                LangText = "簡體中文";
                $("#btn_switchlang").append(`<i class="icon icon-mask icon-flag-ZH"></i>`);
                $('#langIcon').addClass('icon-flag-ZH');
                break;
            default:
                LangText = "日本語";
                $("#btn_switchlang").append(`<i class="icon icon-mask icon-flag-JP"></i>`);
                $('#langIcon').addClass('icon-flag-JP');
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

        lobbyClient.CheckDocumentByTagName(Math.uuid(), "N2", function (success, o) {
            if (success) {
                if (o.Result == 0) {

                    if (o.DocumentList.length > 0) {
                        var record = o.DocumentList[o.DocumentList.length - 1];
                        LoginMessageTitle = record.DocumentTitle;
                        LoginMessage = record.DocNumber;
                        LoginMessageVersion = record.DocumentID;
                        if (cb != null) {
                            cb();
                        }
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
                //if ((EWinWebInfo.SID != null) && (EWinWebInfo.SID != "")) {
                //    if (EWinWebInfo.DeviceType == 1) {
                //        $('.PC-notify-dot').css('display', 'block');
                //        $('.mobile-notify-dot').css('display', 'none');
                //    }
                //}
            } else {
                //if ((EWinWebInfo.SID != null) && (EWinWebInfo.SID != "")) {
                //    if (EWinWebInfo.DeviceType == 1) {
                //        $('.PC-notify-dot').css('display', 'none');
                //        $('.mobile-notify-dot').css('display', 'block');
                //    }
                //}
            }

        });
        $('.header_area .mask_overlay').click(function () {
            verticalmenu.removeClass('navbar-show');
            headermenu.removeClass('show');
            headermenu.find(".navbarMenu").removeClass('show');
            if (navbartoggler.attr("aria-expanded") == "true") {
                navbartoggler.attr("aria-expanded", "false");
                //if ((EWinWebInfo.SID != null) && (EWinWebInfo.SID != "")) {
                //    if (EWinWebInfo.DeviceType == 1) {
                //        $('.PC-notify-dot').css('display', 'none');
                //        $('.mobile-notify-dot').css('display', 'block');
                //    }
                //}
            }
        });
    }

    function init() {
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

        //if (window.localStorage.getItem("Lang")) {
        //    EWinWebInfo.Lang = window.localStorage.getItem("Lang");
        //}

        initByArt();
        switchLang(EWinWebInfo.Lang, false);

        if (EWinWebInfo.Lang == "JPN") {
            $('#langIcon').addClass('icon-flag-JP');
        } else if (EWinWebInfo.Lang == "CHT") {
            $('#langIcon').addClass('icon-flag-ZH');
        } else {
            $('#langIcon').addClass('icon-flag-EN');
        }

        mlp.loadLanguage(EWinWebInfo.Lang, function () {

            if (EWinWebInfo.DeviceType == 1) {
                noSleep = new NoSleep();
                noSleep.disable();
                document.addEventListener('click', function enableNoSleep() {
                    document.removeEventListener('click', enableNoSleep, false);
                    noSleep.enable();
                }, false);
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

            }
            else {
                if (EWinWebInfo.SID != "") {
                    API_Casino();
                } else {
                    if (PageType != null && PageType != "" && PageType == "OpenSumo") {
                        var gameData = {
                            GameBrand: "YS",
                            GameName: "Sumo",
                            GameLangName: mlp.getLanguageKey("相撲")
                        }

                        window.sessionStorage.setItem("OpenGameBeforeLogin", JSON.stringify(gameData));
                        clearUrlParams();
                        API_LoadPage("Login", "Login.aspx");
                    } else {
                        API_Casino();
                    }

                }
            }

            SearchControll = new searchControlInit("alertSearch");

            setBulletinBoard();

            appendGameFrame();

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
                                        //Check登入前狀態
                                        var openGameBeforeLoginStr = window.sessionStorage.getItem("OpenGameBeforeLogin");

                                        if (openGameBeforeLoginStr) {
                                            var openGameBeforeLogin = JSON.parse(openGameBeforeLoginStr);

                                            window.sessionStorage.removeItem("OpenGameBeforeLogin");
                                            showMessageOK(mlp.getLanguageKey(""), mlp.getLanguageKey("開始遊戲"), function () {
                                                openGame(openGameBeforeLogin.GameBrand, openGameBeforeLogin.GameName, openGameBeforeLogin.GameLangName);
                                            });
                                        } else {
                                            var srcPage = window.sessionStorage.getItem("SrcPage");

                                            if (srcPage) {
                                                window.sessionStorage.removeItem("SrcPage");
                                                API_LoadPage("SrcPage", srcPage, true);
                                            }
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
                            if (o.Result == 0) {
                                needCheckLogin = true;
                                getPromotionCollectAvailable();
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

    function clearUrlParams() {
        if (location.href.includes('?')) {
            history.pushState({}, null, location.href.split('?')[0]);
        }
    }

    function setFavoToIndexDB(cb) {
        if (EWinWebInfo.UserLogined) {
            lobbyClient.GetUserAccountProperty(EWinWebInfo.SID, Math.uuid(), "Favo", function (success, o) {
                if (success) {
                    if (o.Result == 0) {
                        if (o.PropertyValue != "") {
                            var datas = JSON.parse(o.PropertyValue);

                            for (var i = 0; i < datas.length; i++) {
                                if (!Favos.includes(datas[i])) {
                                    Favos.push(datas[i]);
                                }
                            }

                            for (var i = 0; i < datas.length; i++) {
                                GCB.AddFavo(datas[i], function () {
                                });
                            }

                            setFavoToDB(cb);
                        }
                    }
                }
            });
        }
    }

    function setFavoToDB(cb) {
        if (EWinWebInfo.UserLogined) {
            GCB.GetFavo((gameItem) => {
                if (!Favos.includes(gameItem.GameCode)) {
                    Favos.push(gameItem.GameCode);
                }
            }, () => {
                lobbyClient.SetUserAccountProperty(EWinWebInfo.SID, Math.uuid(), "Favo", JSON.stringify(Favos), function (success, o) {
                    if (success) {
                        if (o.Result == 0) {
                            cb();
                        }
                    }
                });
            })

        }
    }

    function getPromotionCollectAvailable() {
        lobbyClient.GetPromotionCollectAvailable(EWinWebInfo.SID, Math.uuid(), function (success2, o2) {
            if (success2) {
                if (o2.Result == 0) {
                    if (o2.CollectList.length > 0) {
                        var boolCheck = false;
                        let wallet = EWinWebInfo.UserInfo.WalletList.find(x => x.CurrencyType.toLocaleUpperCase() == EWinWebInfo.MainCurrencyType);
                        for (var i = 0; i < o2.CollectList.length; i++) {
                            let Collect = o2.CollectList[i];
                            let collectAreaType = Collect.CollectAreaType;
                            if (collectAreaType == 2) {
                                boolCheck = true;
                                break;
                            }

                            if (collectAreaType == 1) {
                                if (wallet.PointValue <= 100) {
                                    boolCheck = true;
                                    break;
                                }
                            }
                        }

                        if (boolCheck) {
                            if (EWinWebInfo.DeviceType == 0) {
                                $('.PC-notify-dot').css('display', 'block');
                            } else {
                                var navbartoggler = $('.navbar-toggler');
                                if (navbartoggler.attr("aria-expanded") == "true") {
                                    $('.PC-notify-dot').css('display', 'block');
                                    $('.mobile-notify-dot').css('display', 'none');
                                } else if (navbartoggler.attr("aria-expanded") == "false") {
                                    $('.PC-notify-dot').css('display', 'none');
                                    $('.mobile-notify-dot').css('display', 'block');
                                }
                            }
                        } else {
                            $('.PC-notify-dot').css('display', 'none');
                            $('.mobile-notify-dot').css('display', 'none');
                        }

                    } else {
                        $('.PC-notify-dot').css('display', 'none');
                        $('.mobile-notify-dot').css('display', 'none');
                    }
                } else {
                    $('.PC-notify-dot').css('display', 'none');
                    $('.mobile-notify-dot').css('display', 'none');
                }
            } else {
                $('.PC-notify-dot').css('display', 'none');
                $('.mobile-notify-dot').css('display', 'none');
            }
        });
    }

    function reportWindowSize() {
        let iframewidth = $('#IFramePage').width();

        notifyWindowEvent("resize", iframewidth);

    }

    function checkChampionType(championType) {
        //三冠王 
        // 等級crownLevel-1/crownLevel-2/crownLevel-3
        // 類別crown-Payout派彩(1)/crown-Multiplier倍率(2)/crown-Spin轉數(4)

        var date = {
            championTypeStr: "",
            crownLevel: ""
        }
        var count = 0;
        if (championType != 0) {
            if ((championType & 1) == 1) {
                date.championTypeStr += "crown-Payout,"
                count++;
            }
            if ((championType & 2) == 2) {
                date.championTypeStr += "crown-Multiplier,"
                count++;
            }

            if ((championType & 4) == 4) {
                date.championTypeStr += "crown-Spin,"
                count++;
            }

            if (date.championTypeStr.length > 0) {
                date.championTypeStr = date.championTypeStr.substring(0, date.championTypeStr.length - 1);
            }

            if (count == 1) { date.crownLevel = "crownLevel-1" }
            else if (count == 2) {
                var championTypeStr = date.championTypeStr;
                date.crownLevel = "crownLevel-2"
                if (championTypeStr.includes("crown-Payout") && championTypeStr.includes("crown-Multiplier")) {
                    date.championTypeStr = "crown-P-M";
                } else if (championTypeStr.includes("crown-Payout") && championTypeStr.includes("crown-Spin")) {
                    date.championTypeStr = "crown-P-S";
                } else if (championTypeStr.includes("crown-Multiplier") && championTypeStr.includes("crown-Spin")) {
                    date.championTypeStr = "crown-M-S";
                }
            }
            else if (count == 3) { date.crownLevel = "crownLevel-3"; date.championTypeStr = ""; }
        }

        return date;
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
                        lang_gamename = lang_gamename.replace("'", "");
                        if (gameItem.RTPInfo) {
                            RTP = JSON.parse(gameItem.RTPInfo).RTP;
                        }

                        if (RTP == "0") {
                            RTP = "--";
                        }

                        GI = c.getTemplate("tmpSearchGameItem");
                        let GI1 = $(GI);
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
                        } else if (alertSearchContent.children().length > 60) {
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

        this.searchGameChange = function (cb) {
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
                            if (cb) {
                                cb();
                            }
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

            for (var i = 0; i < gameBrand.length; i++) {
                if (SearchDom.find('#searchIcon_' + gameBrand[i]).length > 0) {
                    SearchDom.find('#searchIcon_' + gameBrand[i]).prop("checked", true);
                }
            }


            SearchDom.find("#seleGameCategory").empty();
            o = new Option(mlp.getLanguageKey("全部"), "All");
            SearchDom.find("#seleGameCategory").append(o);
            SearchDom.find("#seleGameCategory").val("All");

            if (gameCategoryName) {
                o = new Option(mlp.getLanguageKey(gameCategoryName), gameCategoryName);
                SearchDom.find("#seleGameCategory").append(o);
                SearchDom.find("#seleGameCategory").val(gameCategoryName);
            }

            SearchDom.find('#alertSearchKeyWord').val('');

            SearchSelf.searchGameList();

        }

        //openFullSearch
        this.openFullSearch = function (e) {
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

    function setBulletinBoard() {
        var GUID = Math.uuid();
        lobbyClient.CheckDocumentByTagName(GUID, "N1", function (success, o) {
            if (success) {
                if (o.Result == 0) {
                    var ParentMain2 = document.getElementById("idBulletinBoardContent2");
                    ParentMain2.innerHTML = "";

                    if (o.DocumentList.length > 0) {
                        var RecordDom2;
                        for (var i = 0; i < o.DocumentList.length; i++) {
                            var record = o.DocumentList[i];

                            RecordDom2 = c.getTemplate("idTempBulletinBoard");

                            //c.setClassText(RecordDom2, "BulletinTitle", null, record.DocumentTitle);
                            c.setClassText(RecordDom2, "CreateDate", null, record.DocumentTitle);

                            RecordDom2.onclick = new Function("window.parent.showBoardMsg('" + record.DocumentTitle + "','" + record.DocNumber + "')");
                            ParentMain2.appendChild(RecordDom2);
                        }
                    }
                }
            }
        });
    }

    function showFavoPlayed() {

        if (!EWinWebInfo.UserLogined) {
            showMessageOK(mlp.getLanguageKey("尚未登入"), mlp.getLanguageKey("請先登入"), function () {
                API_LoadPage("Login", "Login.aspx");
            });
            return;
        }

        setFavoPlayeditem(0);
        setFavoPlayeditem(1);
        $("#alertFavoPlayed").modal("show")
    }

    function setFavoPlayeditem(type) {
        
        var lang = EWinWebInfo.Lang;
        var alertSearchContent;

        switch (type) {
            case 0:
                alertSearchContent = $('#alertFavoContent');
                break;
            case 1:
                alertSearchContent = $('#alertPlayedContent');
                break;
            default:
                alertSearchContent = $('#alertFavoContent');
                break;
        }

        alertSearchContent.empty();

        GCB.GetPersonal(type,
            function (gameItem) {

                var RTP = "--";
                var lang_gamename = gameItem.Language.find(x => x.LanguageCode == EWinWebInfo.Lang) ? gameItem.Language.find(x => x.LanguageCode == EWinWebInfo.Lang).DisplayText : "";
                lang_gamename = lang_gamename.replace("'", "");
                if (gameItem.RTPInfo) {
                    RTP = JSON.parse(gameItem.RTPInfo).RTP;
                }

                if (RTP == "0") {
                    RTP = "--";
                }

                GI = c.getTemplate("tmpSearchGameItem");
                let GI1 = $(GI);
                GI.onclick = new Function("openGame('" + gameItem.GameBrand + "', '" + gameItem.GameName + "','" + lang_gamename + "')");

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

                alertSearchContent.append(GI);

            }, function (data) {

            }
        )
    }

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
                        <!-- 通知小紅點-手機版時加入 -->
                        <div class="notify-dot mobile-notify-dot" style="display: none;"></div>
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
                            <ul class="menu_nav_top">
                                <li class="nav-item navbarMenu__catagory">
                                    <ul class="catagory">
                                        <%--
                                        <li class="nav-item submenu dropdown"
                                            onclick="API_LoadPage('Casino', 'Casino.aspx', false)">
                                            <a class="nav-link">
                                                <i class="icon icon-mask icon-all"></i>
                                                <span class="title language_replace">遊戲大廳</span></a>
                                        </li>
                                        --%>
                                        <li class="nav-item submenu dropdown"
                                            onclick="API_LoadPage('Casino', 'Casino.aspx?selectedCategory=GameList_Slot', false)">
                                            <a class="nav-link">
                                                <i class="icon icon-mask icon-slot"></i>
                                                <span class="title language_replace">老虎機</span></a>
                                        </li>
                                        <li class="nav-item submenu dropdown"
                                            onclick="API_LoadPage('Casino', 'Casino.aspx?selectedCategory=GameList_Live', false)">
                                            <a class="nav-link">
                                                <i class="icon icon-mask icon-live"></i>
                                                <span class="title language_replace">真人</span></a>
                                        </li>
                                        <li class="nav-item submenu dropdown"
                                            onclick="openGame('BTI', 'Sport', '')">
                                            <a class="nav-link">
                                                <i class="icon icon-mask icon-sport"></i>
                                                <span class="title language_replace">體育</span></a>
                                        </li>
                                        
                                        <li class="nav-item submenu dropdown">
                                            <a class="nav-link" data-toggle="modal" onclick="showFavoPlayed()">
                                                <i class="icon icon-mask icon-favo"></i>
                                                <span class="title language_replace">我的最愛</span></a>
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
                                                <!-- 通知小紅點 -->
                                                <span class="notify-dot PC-notify-dot" style="display: none;"></span>
                                                <i class="icon icon-mask icon-prize"></i>
                                                <span class="title language_replace">領獎中心</span></a>
                                        </li>
                                        <li class="nav-item submenu dropdown">
                                            <a class="nav-link" onclick="API_LoadPage('record','record.aspx', true)">
                                                <i class="icon icon-mask icon-calendar"></i>
                                                <span class="title language_replace">履歷記錄</span></a>
                                        </li>
                                        <li class="nav-item submenu dropdown">
                                            <a class="nav-link" data-toggle="modal" data-target="#popupBulletinList">
                                                <i class="icon icon-mask icon-announce"></i>
                                                <span class="title language_replace">公告</span></a>
                                        </li>
                                        <li class="nav-item submenu dropdown" onclick="API_LoadPage('Withdrawal','ReportAgent.aspx', true)">
                                            <a class="nav-link">
                                                <i class="icon icon-mask icon-news-report"></i>
                                                <span class="title language_replace">報表</span></a>
                                        </li>
                                    </ul>
                                </li>
                                <%--
                                <li class="nav-item navbarMenu__catagory">
                                    <ul class="catagory">

                                        <li class="nav-item submenu dropdown"
                                            onclick="window.open('https://lin.ee/KD05l9X')">
                                            <a class="nav-link">
                                                <i class="icon icon-mask icon-line"></i>
                                                <span class="title language_replace">Line</span></a>
                                        </li>
                                    </ul>
                                </li>
                                --%>
                                <li class="nav-item submenu dropdown" id="idLogoutItem">
                                    <a class="nav-link" onclick="API_Logout(true)">
                                        <!-- <i class="icon icon2020-ico-login"></i> -->
                                        <i class="icon icon-mask icon-logout"></i>
                                        <span class="language_replace" langkey="登出">登出</span></a>
                                </li>
                            </ul>
                            <li class="nav-item navbarMenu__catagory nav-lang">
                                <ul class="catagory">
                                    <li class="nav-item submenu dropdown "
                                        onclick="showLangProp()">
                                        <a class="nav-link">
                                            <!-- icon-flag-JP/icon-flag-ZH 切換-->
                                            <i id="langIcon" class="icon icon-mask"></i>
                                            <span class="title language_replace">語言選擇</span></a>
                                    </li>

                                </ul>
                            </li>
                        </ul>
                    </div>
                    <!-- 頂部 NavBar -->
                    <div class="header_topNavBar">
                        <!-- 左上角 -->
                        <div class="header_leftWrapper navbar-nav" onclick="API_LoadPage('Casino','Casino.aspx')">
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
                                            <li class="register" style="display: block !important">
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
                                                            <!-- 未完成存款訂單-通知小紅點 -->
                                                            <%--<span class="notify-dot"></span>--%>
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
                                    <li class="nav-item lang_wrapper submenu dropdown is-hide" style="display: none;">
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
            <iframe id="GameIFramePage" class="divGameFrame" name="mainiframe" sandbox="allow-same-origin allow-scripts allow-popups allow-forms allow-pointer-lock"></iframe>
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

                    <%--                    <ul class="company-info row">
                        <li class="info-item col">
                           <a id="Footer_About" onclick="window.parent.API_LoadPage('About','About.html')"><span class="language_replace">關於我們</span></a>
                        </li>

                        <li class="info-item col">
                            <a id="Footer_ResponsibleGaming" onclick="window.parent.API_ShowPartialHtml('', 'ResponsibleGaming', true, null)">
                                <span class="language_replace">負責任的賭博</span>
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

                    </ul>--%>
                    <div class="partner">
                        <div class="logo">
                            <div class="row">
                                <div class="logo-item">
                                    <div class="img-crop">
                                        <img src="/images/logo/footer/logo-eWIN.png" alt="">
                                    </div>
                                </div>
                                <div class="logo-item">
                                    <div class="img-crop">
                                        <img src="/images/logo/footer/logo-microgaming.png" alt="">
                                    </div>
                                </div>
                                <div class="logo-item">
                                    <div class="img-crop">
                                        <img src="/images/logo/footer/logo-kgs.png" alt="">
                                    </div>
                                </div>
                                <div class="logo-item">
                                    <div class="img-crop">
                                        <img src="/images/logo/footer/logo-bbin.png" alt="">
                                    </div>
                                </div>
                                <div class="logo-item">
                                    <div class="img-crop">
                                        <img src="/images/logo/footer/logo-gmw.png" alt="">
                                    </div>
                                </div>
                                <div class="logo-item">
                                    <div class="img-crop">
                                        <img src="/images/logo/footer/logo-cq9.png" alt="">
                                    </div>
                                </div>
                                <div class="logo-item">
                                    <div class="img-crop">
                                        <img src="/images/logo/footer/logo-red-tiger.png" alt="">
                                    </div>
                                </div>
                                <div class="logo-item">
                                    <div class="img-crop">
                                        <img src="/images/logo/footer/logo-evo.png" alt="">
                                    </div>
                                </div>
                                <div class="logo-item">
                                    <div class="img-crop">
                                        <img src="/images/logo/footer/logo-bco.png" alt="">
                                    </div>
                                </div>
                                <div class="logo-item">
                                    <div class="img-crop">
                                        <img src="/images/logo/footer/logo-cg.png" alt="">
                                    </div>
                                </div>
                                <div class="logo-item">
                                    <div class="img-crop">
                                        <img src="/images/logo/footer/logo-playngo.png" alt="">
                                    </div>
                                </div>
                                <div class="logo-item">
                                    <div class="img-crop">
                                        <img src="/images/logo/footer/logo-pg.png" alt="">
                                    </div>
                                </div>
                                <div class="logo-item">
                                    <div class="img-crop">
                                        <img src="/images/logo/footer/logo-netent.png" alt="">
                                    </div>
                                </div>
                                <div class="logo-item">
                                    <div class="img-crop">
                                        <img src="/images/logo/footer/logo-kx.png" alt="">
                                    </div>
                                </div>
                                <div class="logo-item">
                                    <div class="img-crop">
                                        <img src="/images/logo/footer/logo-evops.png" alt="">
                                    </div>
                                </div>
                                <div class="logo-item">
                                    <div class="img-crop">
                                        <img src="/images/logo/footer/logo-bti.png" alt="">
                                    </div>
                                </div>
                                <div class="logo-item">
                                    <div class="img-crop">
                                        <img src="/images/logo/footer/logo-zeus.png" alt="">
                                    </div>
                                </div>
                                <div class="logo-item">
                                    <div class="img-crop">
                                        <img src="/images/logo/footer/logo-biggaming.png" alt="">
                                    </div>
                                </div>
                                <div class="logo-item">
                                    <div class="img-crop">
                                        <img src="/images/logo/footer/logo-play.png" alt="">
                                    </div>
                                </div>
                                <div class="logo-item">
                                    <div class="img-crop">
                                        <img src="/images/logo/footer/logo-h.png" alt="">
                                    </div>
                                </div>
                                <div class="logo-item">
                                    <div class="img-crop">
                                        <img src="/images/logo/footer/logo-va.png" alt="">
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

<%--                    <div class="company-detail">
                        <div class="company-license">
                            <iframe src="https://licensing.gaming-curacao.com/validator/?lh=73f82515ca83aaf2883e78a6c118bea3&template=tseal" width="150" height="50" style="border: none;"></iframe>
                        </div>
                        <div class="company-address">
                            <p class="address language_replace">MAHARAJA由(Online Chip World Co. N.V) 所有並營運。（註冊地址：Zuikertuintjeweg Z/N (Zuikertuin Tower), Willemstad, Curacao）取得庫拉索政府核發的執照 註冊號碼：#365 / JAZ 認可，並以此據為標準。</p>
                        </div>
                    </div>--%>


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
                            <li class="lang-item custom-control custom-radioValue-lang" onclick="switchLang('ENG', true)">
                                <label class="custom-label">
                                    <input type="radio" name="button-langExchange" class="custom-control-input-hidden">
                                    <div class="custom-input radio-button">
                                        <span class="flag EN"><i class="icon icon-mask icon-flag-EN"></i></span>
                                        <span class="name">English</span>
                                    </div>
                                </label>
                            </li>
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
    
    <!-- 我的最愛/遊玩過的遊戲 PoPup-->
    <div class="modal fade no-footer alertSearchTemp" id="alertFavoPlayed" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-xl modal-dialog-scrollable">
            <div class="modal-content">
                <div class="modal-header">
                    <div class="modal-header-container">
                        <!-- <h5 class="modal-title">我是logo</h5> -->
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close"
                            id="alertFavoPlayedCloseButton">
                            <span aria-hidden="true">&times;</span>
                        </button>
                    </div>
                </div>
                <div class="modal-body">
                    <div class="game-search-wrapper">
                        <div class="search-result-wrapper">
                            <div class="search-result-inner">
                                <div class="search-result-list">
                                    <div class="game-item-group list-row row" id="alertFavoContent">

                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="game-search-wrapper">
                        <div class="search-result-wrapper">
                            <div class="search-result-inner">
                                <div class="search-result-list">
                                    <div class="game-item-group list-row row" id="alertPlayedContent">

                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

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
                                    language_replace="placeholder" placeholder="關鍵字" enterkeyhint="">
                                <label for="" class="form-label"><span class="language_replace">關鍵字</span></label>
                            </div>
                            <div class="wrapper_center action-outter">
                                <button type="button" class="btn btn btn-outline-main btn-sm btn-reset-popup" onclick="SearchControll.searchGameChangeClear()">
                                    <span class="language_replace">重新設定</span>
                                </button>
                                <button onclick="SearchControll.searchGameList()" type="button"
                                    class="btn btn-full-main btn-sm btn-search-popup">
                                    <span class="language_replace">搜尋</span>
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
        <div class="modal-dialog modal-lg modal-dialog-scrollable" role="document">
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
                                        <h6 class="title"><i class="icon icon-mask ico-grid"></i><span class="language_replace">公告詳情</span></h6>
                                        <div class="section-content">
                                            <p class="alertContact_Text language_replace"></p>
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
                    <%--<button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">×</span>
                    </button>--%>
                </div>
                <div class="modal-body">
                    <div class="modal-body-content">
                        <article class="popup-detail-wrapper">
                            <div class="popup-detail-inner">
                                <div class="popup-detail-content">
                                    <section class="section-wrap" style="display:none">
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
                    <div class="btn-container"onclick="alertBoardMsgClose()">
                        <button type="button" class="alert_OK btn btn-primary btn-sm" ><span class="language_replace">確定</span></button>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade no-footer popupBulletinList" id="popupBulletinList" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-xl modal-dialog-centered modal-dialog-scrollable">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="alert_Title language_replace">最新公告</h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <div class="-wrapper">
                        <ul class="bulletin_list" id="idBulletinBoardContent2">
                            <li class="item">
                                <span class="date">2022.8.11</span>
                                <span class="info">ゲームメンテナンスのお知らせでございます。</span>
                            </li>
                            <li class="item">
                                <span class="date">2022.8.11</span>
                                <span class="info">ゲームメンテナンスのお知らせでございます。</span>
                            </li>
                        </ul>

                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
                    <button type="button" class="btn btn-primary">Save</button>
                </div>
            </div>
        </div>
    </div>

    <div class="tmpBulletinBoardModel" style="display: none;">
        <div id="idTempBulletinBoard" style="display: none;">
            <!-- <div> -->
            <li class="item" style="cursor:pointer">
                <span class="date CreateDate"></span>
                <span class="info BulletinTitle"></span>
            </li>
            <!-- </div> -->
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
                        <!-- 三冠王 crownLevel-1/crownLevel-2-->
                        <div id="popupMoblieGameInfo-game-item" class="">
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
