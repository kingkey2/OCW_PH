<%@ Page Language="C#" %>

<%
    string Version = EWinWeb.Version;
    string type = Request["type"];
%>

<!doctype html>
<html lang="zh-Hant-TW" class="innerHtml">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <title>Maharaja</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="css/basic.min.css">
    <link rel="stylesheet" href="css/main.css">
    <link rel="stylesheet" href="css/activity.css">
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+JP:wght@300;500&display=swap" rel="Prefetch" as="style" onload="this.rel = 'stylesheet'" />
    
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/4.6.2/js/bootstrap.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/Swiper/6.7.1/swiper-bundle.min.js"></script>
    <script type="text/javascript" src="/Scripts/Common.js"></script>
    <script type="text/javascript" src="/Scripts/UIControl.js"></script>
    <script type="text/javascript" src="/Scripts/MultiLanguage.js"></script>
    <script type="text/javascript" src="/Scripts/Math.uuid.js"></script>
</head>
<script type="text/javascript">
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
    var t = "<%:type%>";

    function init() {
        if (self == top) {
            window.parent.location.href = "index.aspx";
        }

        WebInfo = window.parent.API_GetWebInfo();
        LobbyClient = window.parent.API_GetLobbyAPI();
        lang = window.parent.API_GetLang();
        getUserAccountEventSummary();
        mlp = new multiLanguage(v);

        mlp.loadLanguage(lang, function () {
            window.parent.API_LoadingEnd();

            if (LobbyClient != null) {
                //window.parent.sleep(500).then(() => {
                //    if (WebInfo.UserLogined) {
                //        document.getElementById("idGoRegBtn").classList.add("is-hide");
                //        $(".register-list").hide();
                //    }
                //})

                if (t) {
                    switch (t) {
                        case "1":
                            GoActivityDetail(1, '/Activity/Act001/CenterPage/index.html');
                            break;
                        case "2":
                            GoActivityDetail(2, '/Activity/Act002/CenterPage/index.html');
                            break;
                        case "3":
                            GoActivityDetail(3,'/Activity/Act003/CenterPage/index.html')
                            break;
                        case "4":
                            GoActivityDetail(4, '/Activity/event/pp-1/index-jp.html');
                            break;
                        case "5":
                            GoActivityDetail(5, '/Activity/event/pp-2/index-jp.html');
                            break;
                        case "6":
                            GoActivityDetail(6, '/Activity/event/bng/bng2207/index.html');
                            break;
                        case "8":
                            GoActivityDetail(8, '/Activity/event/ne-rt/08222022/index-jp.html');
                            break;
                        case "9":
                            GoActivityDetail(9, '/Activity/event/bng/09092022moonfestival/index-jp.html');
                            break;
                        case "10":
                            GoActivityDetail(10, '/Activity/event/bng/bng220919BH/index-jp.html');
                            break;
                        case "11":
                            GoActivityDetail(11, '/Activity/event/pp202209-1/index-jp.html');
                            break;
                        case "12":
                            GoActivityDetail(12, '/Activity/event/pp202209-2/index-jp.html');
                            break;
                        case "13":
                            GoActivityDetail(13, '/Activity/event/bng/bng221003MR/index-jp.html');
                            break;
                        case "14":
                            GoActivityDetail(14, '/Activity/event/ne-rt/202210/index-jp.html');
                            break;
                    }
                }

            } else {
                window.parent.showMessageOK(mlp.getLanguageKey("錯誤"), mlp.getLanguageKey("網路錯誤"), function () {
                    window.parent.location.href = "index.aspx";
                });
            }
        });
    }

    function getUserAccountEventSummary() {
        LobbyClient.GetUserAccountEventSummary(WebInfo.SID, Math.uuid(), function (success, o) {
            if (success) {
                if (o.Result == 0) {
                    if (o.Datas.length > 0) {
                        for (var i = 0; i < o.Datas.length; i++) {
                            if (o.Datas[i].ActivityName == 'RegisterBouns') {
                                if (o.Datas[i].CollectCount == o.Datas[i].JoinCount) {
                                    $('#ModalRegister .btn-secondary').removeClass('is-hide');    
                                } else {
                                    $('#ModalRegister .btn-full-sub').removeClass('is-hide');
                                }
                                $('#ModalRegister .btn-primary').addClass('is-hide');

                            }
                        }
                    } else {
                        window.parent.showMessageOK(mlp.getLanguageKey("提示"), mlp.getLanguageKey("沒有資料"));
                        //document.getElementById('gameTotalValidBetValue').textContent = 0;
                    }
                }
            }
        });
    }

    function GoActivityDetail(type, url) {
        event.stopPropagation();
        //001 入金
        //002 註冊
        //003 7日
        //004 PP-slot
        //005 pp-live
        let title;
        let btnText;
        let popupBtnHide;

        if (url) {
            switch (type) {
                case 1:
                    $('#ModalDeposit .activity-popup-detail-inner').load(url, function () {
                        $('#ModalDeposit').modal('show');
                    });
                    break;
                case 2:
                    $('#ModalRegister .activity-popup-detail-inner').load(url, function () {
                        $('#ModalRegister').modal('show');
                    });
                    break;
                case 3:
                    $('#ModalDailylogin .activity-popup-detail-inner').load(url, function () {
                        $('#ModalDailylogin').modal('show');
                    });
                    break;
                case 4:
                    title = "スロットトーナメントおよび現金配布";
                    btnText = mlp.getLanguageKey("前往遊玩");
                    popupBtnHide = 0;
                    showPopup(type, title, btnText, url, popupBtnHide);
                    break;
                case 5:
                    title = "夏のウィークリートーナメント-ライブカジノ";
                    btnText = mlp.getLanguageKey("前往遊玩");
                    popupBtnHide = 0;
                    showPopup(type, title, btnText, url, popupBtnHide);
                    break;
                case 6:
                    title = "BNG周年祝い勝利レースプレゼント";
                    btnText = mlp.getLanguageKey("前往遊玩");
                    popupBtnHide = 1;
                    showPopup(type, title, btnText, url, popupBtnHide);
                    break;
                case 8:
                    title = "ボーナス爆弾キャンペーン";
                    btnText = mlp.getLanguageKey("前往遊玩");
                    popupBtnHide = 0;
                    showPopup(type, title, btnText, url, popupBtnHide);
                    break;
                case 9:
                    title = "ブンーゴー中秋の名月";
                    btnText = mlp.getLanguageKey("前往遊玩");
                    popupBtnHide = 1;
                    showPopup(type, title, btnText, url, popupBtnHide);
                    break;    
                case 10:
                    title = "BNGまほう怪盗トーナメント";
                    btnText = mlp.getLanguageKey("前往遊玩");
                    popupBtnHide = 1;
                    showPopup(type, title, btnText, url, popupBtnHide);
                    break;    
                case 11:
                    title = "ライブカジノウィークリー トーナメント";
                    btnText = mlp.getLanguageKey("前往遊玩");
                    popupBtnHide = 0;
                    showPopup(type, title, btnText, url, popupBtnHide);
                    break;
                case 12:
                    title = "スロットトーナメントとキャッシュ ドロップ";
                    btnText = mlp.getLanguageKey("前往遊玩");
                    popupBtnHide = 0;
                    showPopup(type, title, btnText, url, popupBtnHide);
                    break;
                case 13:
                    title = "ブンーゴー秋がもたらす幸運レース";
                    btnText = mlp.getLanguageKey("前往遊玩");
                    popupBtnHide = 1;
                    showPopup(type, title, btnText, url, popupBtnHide);
                    break;
                case 14:
                    title = "HELLOWIN";
                    btnText = mlp.getLanguageKey("前往遊玩");
                    popupBtnHide = 0;
                    showPopup(type, title, btnText, url, popupBtnHide);
                    break;
                default:
                    break;
            }
        }
    }

    function activityBtnClick(type) {
        event.stopPropagation();

        switch (type) {
            case 1:
                window.parent.API_LoadPage('Casino', 'Casino.aspx', false);
                break;
            case 2:
                window.parent.API_LoadPage('Deposit', 'Deposit.aspx', true);
                break;
            case 3:
                window.parent.API_LoadPage('', 'Prize.aspx');
                break;
            case 4:
                $('#TempModal').modal('hide');
                window.parent.SearchControll.searchGameByBrandAndGameCategory(["PP"], "Slot");
                break;
            case 5:
                $('#TempModal').modal('hide');
                window.parent.SearchControll.searchGameByBrandAndGameCategory(["PP"], "Live");
                break;
            case 6:
                $('#TempModal').modal('hide');
                window.parent.SearchControll.searchGameByBrandAndGameCategory(["BNG"], "Slot");
                break;
            case 8:
                $('#TempModal').modal('hide');
                window.parent.SearchControll.searchGameByBrandAndGameCategory(["NE","RT"]);                
                break;
            case 11:
                $('#TempModal').modal('hide');
                window.parent.SearchControll.searchGameByBrandAndGameCategory(["PP"], "Live");
                break;
            case 12:
                $('#TempModal').modal('hide');
                window.parent.SearchControll.searchGameByBrandAndGameCategory(["PP"], "Slot");
                break;
            case 14:
                $('#TempModal').modal('hide');
                window.parent.SearchControll.searchGameByBrandAndGameCategory(["NE","RT"]);
                break;
        }
    }

    function showPopup(type, title, btnText, url, popupBtnHide) {
        $("#TempModal .btnGoActivity").unbind();
        $("#TempModal .btnGoActivity").text(btnText);
        $("#TempModal .modal-title").text(title);

        if (popupBtnHide == 1) {
            $("#TempModal .btnGoActivity").hide();
        } else {
            $("#TempModal .btnGoActivity").show();
            $("#TempModal .btnGoActivity").click(function () {
                event.stopPropagation();
                activityBtnClick(type);
            })
        }

        $('#TempModal .activity-popup-detail-inner').load(url, function () {
            $('#TempModal').modal('show');
        });
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
                    window.parent.API_LoadingEnd(1);
                });
                break;
        }
    }

    window.onload = init;
</script>
<body class="innerBody">
    <main class="innerMain">
        <div class="page-content">
            <div class="container">
                <div class="sec-title-container sec-title-activity">
                    <!-- 領獎中心 link-->
                    <a class="btn btn-link btn-prize" onclick="window.parent.API_LoadPage('','Prize.aspx', true)">
                        <span class="title language_replace">前往領獎中心</span><i class="icon icon-mask icon-arrow-right-dot"></i>
                    </a>
                    <div class="sec-title-wrapper">
                        <h1 class="sec-title title-deco"><span class="language_replace">活動</span></h1>
                    </div>
                </div>
                <section class="section-wrap section-activity">
                    <div class="activity-item-group">
                        <figure class="activity-item">
                            <div class="activity-item-inner" onclick="GoActivityDetail(14,'/Activity/event/ne-rt/202210/index-jp.html')">
                                <!-- 活動連結 -->
                                <div class="activity-item-link" data-toggle="modal">
                                    <div class="img-wrap">
                                        <img src="Activity/event/ne-rt/202210/img/JP-img-act.jpg">
                                    </div>
                                    <div class="info">
                                        <div class="detail">
                                            <!-- <figcaption class="title language_replace">金熱門！</figcaption> -->
                                            <div class="desc language_replace">ネットエント（NE）とレッドタイガー（RT）のゲームをプレイすれば、最大130,000のギフトマネーが貰えるよ！
                                            </div>
                                        </div>
                                        <!-- 活動詳情 Popup-->
                                        <!-- <button type="button" onclick="activityBtnClick(2)" class="btn-popup btn btn-full-main"><span class="language_replace">立即確認</span></button> -->
                                        <button type="button" class="btn-popup btn btn-full-main"><span class="language_replace">立即確認</span></button>
                                    </div>
                                </div>
                            </div>
                        </figure>
                        <figure class="activity-item">
                            <div class="activity-item-inner" onclick="GoActivityDetail(13,'/Activity/event/bng/bng221003MR/index-jp.html')">
                                <!-- 活動連結 -->
                                <div class="activity-item-link" data-toggle="modal">
                                    <div class="img-wrap">
                                        <img src="Activity/event/bng/bng221003MR/img/img-act.jpg">
                                    </div>
                                    <div class="info">
                                        <div class="detail">
                                            <!-- <figcaption class="title language_replace">金熱門！</figcaption> -->
                                            <div class="desc language_replace">ブンーゴーの対象ゲームをプレイすれば、最大360,000のギフトマネーがもらえる！
                                            </div>
                                        </div>
                                        <!-- 活動詳情 Popup-->
                                        <!-- <button type="button" onclick="activityBtnClick(2)" class="btn-popup btn btn-full-main"><span class="language_replace">立即確認</span></button> -->
                                        <button type="button" class="btn-popup btn btn-full-main"><span class="language_replace">立即確認</span></button>
                                    </div>
                                </div>
                            </div>
                        </figure>
                        <figure class="activity-item">
                            <div class="activity-item-inner" onclick="GoActivityDetail(11,'/Activity/event/pp202209-1/index-jp.html')">
                                <!-- 活動連結 -->
                                <div class="activity-item-link" data-toggle="modal">
                                    <div class="img-wrap">
                                        <img src="Activity/event/pp202209-1/img/img-liveJp-act.jpg">
                                    </div>
                                    <div class="info">
                                        <div class="detail">
                                            <!-- <figcaption class="title language_replace">金熱門！</figcaption> -->
                                            <div class="desc language_replace">プラグマティックプレイのライブカジノゲームをプレイし、高スコアを獲得しリーダーボードの上位になれば、最大115,000ギフトマネーがもらえる。</div>
                                        </div>
                                        <!-- 活動詳情 Popup-->
                                        <!-- <button type="button" onclick="activityBtnClick(2)" class="btn-popup btn btn-full-main"><span class="language_replace">立即確認</span></button> -->
                                        <button type="button" class="btn-popup btn btn-full-main"><span class="language_replace">立即確認</span></button>
                                    </div>
                                </div>
                            </div>
                        </figure>
                        <figure class="activity-item">
                            <div class="activity-item-inner" onclick="GoActivityDetail(12,'/Activity/event/pp202209-2/index-jp.html')">
                                <!-- 活動連結 -->
                                <div class="activity-item-link" data-toggle="modal">
                                    <div class="img-wrap">
                                        <img src="Activity/event/pp202209-2/img/img-actJp.jpg">
                                    </div>
                                    <div class="info">
                                        <div class="detail">
                                            <!-- <figcaption class="title language_replace">金熱門！</figcaption> -->
                                            <div class="desc language_replace">プラグマティックプレイの対象ゲームをプレイすれば、最大115,000ギフトマネーがもらえる。さらにベット金額1000倍のサプライス賞もあるよ！</div>
                                        </div>
                                        <!-- 活動詳情 Popup-->
                                        <!-- <button type="button" onclick="activityBtnClick(2)" class="btn-popup btn btn-full-main"><span class="language_replace">立即確認</span></button> -->
                                        <button type="button" class="btn-popup btn btn-full-main"><span class="language_replace">立即確認</span></button>
                                    </div>
                                </div>
                            </div>
                        </figure>
                        <figure class="activity-item">
                            <div class="activity-item-inner" onclick="GoActivityDetail(1,'/Activity/Act001/CenterPage/index.html')">
                                <!-- 活動連結 -->
                                <div class="activity-item-link" data-toggle="modal">
                                    <div class="img-wrap">
                                        <img class="" src="Activity/act001/CenterPage/img/deposit-act.jpg">
                                    </div>
                                    <div class="info">
                                        <div class="detail">
                                            <!-- <figcaption class="title language_replace">金熱門！</figcaption> -->
                                            <div class="desc language_replace">銀行振込の還元上限は2倍で、最大100,000 Ocoin！</div>
                                        </div>
                                        <!-- 活動詳情 Popup-->
                                        <!-- <button type="button" onclick="activityBtnClick(2)" class="btn-popup btn btn-full-main"><span class="language_replace">立即確認</span></button> -->
                                        <button type="button" class="btn-popup btn btn-full-main"><span class="language_replace">立即確認</span></button>
                                    </div>
                                </div>
                            </div>
                        </figure>                        
                        <figure class="activity-item">
                            <div class="activity-item-inner"  onclick="GoActivityDetail(3,'/Activity/Act003/CenterPage/index.html')">
                                <!-- 活動連結 -->
                                <div class="activity-item-link" data-toggle="modal">
                                    <div class="img-wrap">
                                        <img class="" src="Activity/Act003/CenterPage/img/activity-popup-b-m-01.jpg">
                                    </div>
                                    <div class="info">
                                        <div class="detail">
                                            <!-- <figcaption class="title language_replace">金熱門！</figcaption> -->
                                            <div class="desc language_replace">毎日20,000ローリングのミッションを達成し、最大10,000 Ocoin獲得できる！</div>
                                        </div>
                                        <!-- 活動詳情 Popup-->
                                        <!-- <button type="button" onclick="activityBtnClick(1)" class="btn-popup btn btn-full-main"><span class="language_replace">立即確認</span></button> -->
                                        <button type="button" class="btn-popup btn btn-full-main"><span class="language_replace">立即確認</span></button>
                                    </div>
                                </div>
                            </div>
                        </figure>
                        <figure class="activity-item">
                            <div class="activity-item-inner" onclick="GoActivityDetail(2,'/Activity/Act002/CenterPage/index.html')">
                                <!-- 活動連結 -->
                                <div class="activity-item-link" data-toggle="modal">
                                    <div class="img-wrap">
                                        <img class="" src="images/activity/activity-register.jpg">
                                    </div>
                                    <div class="info">
                                        <div class="detail">
                                            <!-- <figcaption class="title language_replace">金熱門！</figcaption> -->
                                            <div class="desc language_replace">マハラジャ会員限定！新規登録と招待で、最大1,000 Ocoin獲得できる</div>
                                        </div>
                                        <!-- 活動詳情 Popup-->
                                        <!-- <button type="button" onclick="activityBtnClick(3)" class="btn-popup btn btn-full-main"><span class="language_replace">立即確認</span></button> -->
                                        <button type="button" class="btn-popup btn btn-full-main"><span class="language_replace">立即確認</span></button>
                                    </div>
                                </div>
                            </div>
                        </figure>
                        <figure class="activity-item">
                            <div class="activity-item-inner" onclick="GoActivityDetail(10,'/Activity/event/bng/bng220919BH/index-jp.html')">
                                <!-- 活動連結 -->
                                <div class="activity-item-link" data-toggle="modal">
                                    <div class="img-wrap">
                                        <img src="Activity/event/bng/bng220919BH/img/img-act-close.jpg">
                                    </div>
                                    <div class="info">
                                        <div class="detail">
                                            <!-- <figcaption class="title language_replace">金熱門！</figcaption> -->
                                            <div class="desc language_replace">キャンペーン期間中にブン―ゴーの対象ゲームをプレイすれば、最大160,000のギフトマネーがもらえる！</div>
                                        </div>
                                        <!-- 活動詳情 Popup-->
                                        <!-- <button type="button" onclick="activityBtnClick(2)" class="btn-popup btn btn-full-main"><span class="language_replace">立即確認</span></button> -->
                                        <button type="button" class="btn-popup btn btn-full-main"><span class="language_replace">立即確認</span></button>
                                    </div>
                                </div>
                            </div>
                        </figure>
                        <figure class="activity-item">
                            <div class="activity-item-inner" onclick="GoActivityDetail(8,'/Activity/event/ne-rt/08222022/index-jp.html')">
                                <!-- 活動連結 -->
                                <div class="activity-item-link" data-toggle="modal">
                                    <div class="img-wrap">
                                        <img src="Activity/event/ne-rt/08222022/img/img-act.jpg">
                                    </div>
                                    <div class="info">
                                        <div class="detail">
                                            <!-- <figcaption class="title language_replace">金熱門！</figcaption> -->
                                            <div class="desc language_replace">ネットエント（NE）とレッドタイガー（RT）のゲームをプレイすれば、最大135,000のギフトマネーが貰えるよ！</div>
                                        </div>
                                        <!-- 活動詳情 Popup-->
                                        <!-- <button type="button" onclick="activityBtnClick(2)" class="btn-popup btn btn-full-main"><span class="language_replace">立即確認</span></button> -->
                                        <button type="button" class="btn-popup btn btn-full-main"><span class="language_replace">立即確認</span></button>
                                    </div>
                                </div>
                            </div>
                        </figure>
                        <figure class="activity-item">
                            <div class="activity-item-inner" onclick="GoActivityDetail(9,'/Activity/event/bng/09092022moonfestival/index-jp.html')">
                                <!-- 活動連結 -->
                                <div class="activity-item-link" data-toggle="modal">
                                    <div class="img-wrap">
                                        <img src="Activity/event/bng/09092022moonfestival/img/img-act-end.jpg">
                                    </div>
                                    <div class="info">
                                        <div class="detail">
                                            <!-- <figcaption class="title language_replace">金熱門！</figcaption> -->
                                            <div class="desc language_replace">ブンーゴーの対象ゲームをプレイすれば、最大360,000のギフトマネーがもらえる！</div>
                                        </div>
                                        <!-- 活動詳情 Popup-->
                                        <!-- <button type="button" onclick="activityBtnClick(2)" class="btn-popup btn btn-full-main"><span class="language_replace">立即確認</span></button> -->
                                        <button type="button" class="btn-popup btn btn-full-main"><span class="language_replace">立即確認</span></button>
                                    </div>
                                </div>
                            </div>
                        </figure>
                        <figure class="activity-item">
                            <div class="activity-item-inner" onclick="GoActivityDetail(4,'/Activity/event/pp-1/index-jp.html')">                           
                                <!-- 活動連結 -->
                                <div class="activity-item-link" data-toggle="modal">
                                    <div class="img-wrap">
                                        <img src="Activity/event/pp-1/img/img-act.jpg" />
                                    </div>
                                    <div class="info">
                                        <div class="detail">
                                            <!-- <figcaption class="title language_replace">金熱門！</figcaption> -->
                                            <div class="desc language_replace">プラグマティックプレイの対象ゲームをプレイし、高いポジションを争い、高額ギフトマネー＆サプライズ賞を獲得！</div>
                                        </div>
                                       <!-- 活動詳情 Popup-->
                                       <!-- <button type="button" onclick="activityBtnClick(4)" class="btn-popup btn btn-full-main"><span class="language_replace">立即確認</span></button> -->
                                       <button type="button" class="btn-popup btn btn-full-main"><span class="language_replace">立即確認</span></button>
                                    </div>
                                </div>
                            </div>
                        </figure>                        
                        <figure class="activity-item">
                            <div class="activity-item-inner" onclick="GoActivityDetail(5,'/Activity/event/pp-2/index-jp.html')">
                                <!-- 活動連結 -->
                                <div class="activity-item-link" data-toggle="modal">
                                    <div class="img-wrap">
                                        <img src="Activity/event/pp-2/img/img-live-act.jpg" />
                                    </div>
                                    <div class="info">
                                        <div class="detail">
                                            <!-- <figcaption class="title language_replace"></figcaption> -->
                                            <div class="desc language_replace">プラグマティックプレイの対象ライブカジノをプレイし、高いポジションを争い、高額ギフトマネーを獲得！</div>
                                        </div>
                                        <!-- 活動詳情 Popup-->
                                        <!-- <button type="button" onclick="activityBtnClick(5)" class="btn-popup btn btn-full-main"><span class="language_replace">立即確認</span></button> -->
                                        <button type="button" class="btn-popup btn btn-full-main"><span class="language_replace">立即確認</span></button>
                                    </div>
                                </div>
                            </div>
                        </figure>
                        <figure class="activity-item">
                            <div class="activity-item-inner" onclick="window.open('/Activity/event/bng/bng2207-2/index.html')">
                                <!-- 活動連結 -->
                                <div class="activity-item-link" data-toggle="modal">
                                    <div class="img-wrap">
                                        <img class="" src="images/activity/BNG-actionList-act.jpg">
                                    </div>
                                    <div class="info">
                                        <div class="detail">
                                            <!-- <figcaption class="title language_replace">金熱門！</figcaption> -->
                                            <div class="desc language_replace">マハラジャは出血覚悟で平和祈願ボーナズ！毎回最大100,000 Ocoin</div>
                                        </div>
                                        <!-- 活動詳情 Popup-->
                                        <!-- <button type="button" onclick="activityBtnClick(6)" class="btn-popup btn btn-full-main"><span class="language_replace">立即確認</span></button> -->
                                        <button type="button" class="btn-popup btn btn-full-main"><span class="language_replace">立即確認</span></button>
                                    </div>
                                </div>
                            </div>
                        </figure>
                        <figure class="activity-item">
                            <div class="activity-item-inner" onclick="GoActivityDetail(6,'/Activity/event/bng/bng2207/index.html')">                           
                                <!-- 活動連結 -->
                                <div class="activity-item-link" data-toggle="modal">
                                    <div class="img-wrap">
                                        <img src="Activity/event/bng/bng2207/img/actList-img.jpg" />
                                    </div>
                                    <div class="info">
                                        <div class="detail">
                                            <!-- <figcaption class="title language_replace">金熱門！</figcaption> -->
                                            <div class="desc language_replace">この狛犬大吉と一緒にBNGの周年記念キャンペーンに参加するぞ！対象ゲームで100ラウンドベットして、ポイントの高い人はボーナスが多くもらえるぞ！</div>
                                        </div>
                                       <!-- 活動詳情 Popup-->
                                       <!-- <button type="button" onclick="GoActivityDetail(6,'/Activity/event/bng/bng2207/index.html')" class="btn-popup btn btn-full-main"><span class="language_replace">立即確認</span></button> -->
                                       <button type="button" class="btn-popup btn btn-full-main"><span class="language_replace">立即確認</span></button>
                                    </div>
                                </div>
                            </div>
                        </figure>
                    </div>
                </section>
            </div>
        </div>
    </main>
    
    <!-- Modal -->
    <div class="modal fade footer-center" id="ModalTest" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-lg modal-dialog-centered modal-dialog-scrollable">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">我是標題</h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <article class="activity-popup-detail-wrapper">
                        <div class="activity-popup-detail-inner">
                        </div>
                    </article>
                </div>
                <div class="modal-footer">
   
                    <!--獎勵可領取-->
                    <button type="button" class="btn btn-full-sub is-hide" onclick="window.parent.API_LoadPage('','Prize.aspx')">領取獎勵</button>

                    <!--獎勵不可領取-->
                    <button type="button" class="btn btn-secondary is-hide" disabled>領取獎勵</button>
                </div>
            </div>
        </div>
    </div>
    <!-- Modal - ModalDailylogin-->
    <div class="modal fade footer-center" id="ModalDailylogin" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-lg modal-dialog-centered modal-dialog-scrollable">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title language_replace">金曜日的禮物</h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <article class="activity-popup-detail-wrapper">
                        <div class="activity-popup-detail-inner" >
                        </div>
                    </article>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-primary language_replace" onclick="window.parent.API_LoadPage('Casino', 'Casino.aspx', false)">開始洗碼</button>

                    <!--獎勵可領取-->
                    <button type="button" class="btn btn-full-sub is-hide" onclick="window.parent.API_LoadPage('','Prize.aspx')">領取獎勵</button>

                    <!--獎勵不可領取-->
                    <button type="button" class="btn btn-secondary is-hide" disabled>領取獎勵</button>
                </div>
            </div>
        </div>
    </div>
    <!-- Modal - ModalDeposit-->
    <div class="modal fade footer-center" id="ModalDeposit" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-lg modal-dialog-centered modal-dialog-scrollable">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title language_replace">大好評の入金還元プラン復活！しかも銀行振込は2倍！</h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <article class="activity-popup-detail-wrapper">
                        <div class="activity-popup-detail-inner">
                        </div>
                    </article>
                </div>
                <div class="modal-footer">
                    <!--獎勵可領取-->
                    <button type="button" class="btn btn-full-sub language_replace" onclick="window.parent.API_LoadPage('Deposit','Deposit.aspx', true)">前往入金</button>
                </div>
            </div>
        </div>
    </div>
    <!-- Modal - ModalDeposit-->
    <div class="modal fade footer-center" id="ModalRegister" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-lg modal-dialog-centered modal-dialog-scrollable">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title language_replace">MAHARAJA見面禮</h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <article class="activity-popup-detail-wrapper">
                        <div class="activity-popup-detail-inner">
                        </div>
                    </article>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-primary language_replace" onclick="window.parent.API_LoadPage('','Prize.aspx')">參加活動</button>

                    <!--獎勵可領取-->
                    <button type="button" class="btn btn-full-sub is-hide language_replace" onclick="window.parent.API_LoadPage('','Prize.aspx')">參加活動</button>

                    <!--獎勵不可領取-->
                    <button type="button" class="btn btn-secondary is-hide language_replace" disabled>參加活動</button>
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade footer-center" id="TempModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-lg modal-dialog-centered modal-dialog-scrollable">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title language_replace"></h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <article class="activity-popup-detail-wrapper">
                        <div class="activity-popup-detail-inner">
                        </div>
                    </article>
                </div>
                <div class="modal-footer">
                     <button type="button" class="btn btn-primary language_replace btnGoActivity">參加活動</button> 
                </div>
            </div>
        </div>
    </div>
</body>

</html>
