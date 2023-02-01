<%@ Page Language="C#" %>

<%
    //int RValue;
    //string Token;
    string MarqueeText = "";
    string Version = EWinWeb.Version;
    //Random R = new Random();

    //EWin.Lobby.APIResult Result;
    //EWin.Lobby.LobbyAPI LobbyAPI = new EWin.Lobby.LobbyAPI();

    //RValue = R.Next(100000, 9999999);
    //Token = EWinWeb.CreateToken(EWinWeb.PrivateKey, EWinWeb.APIKey, RValue.ToString());
    //Result = LobbyAPI.GetCompanyMarqueeText(Token, Guid.NewGuid().ToString());
    //if (Result.Result == EWin.Lobby.enumResult.OK)
    //{
    //    MarqueeText = Result.Message;
    //}
%>

<!doctype html>
<html lang="zh-Hant-TW" class="innerHtml">

<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <title>Maharaja</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="Scripts/vendor/swiper/css/swiper-bundle.min.css" rel="stylesheet" />
    <link href="css/basic.min.css" rel="stylesheet" />
    <link rel="stylesheet" href="css/main.css?a=2">
    <link rel="stylesheet" href="css/index.css?a=1">
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+JP:wght@300;400;700&display=swap" rel="stylesheet">
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/4.6.2/js/bootstrap.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/Swiper/6.7.1/swiper-bundle.min.js"></script>
    <script type="text/javascript" src="/Scripts/Common.js"></script>
    <script type="text/javascript" src="/Scripts/UIControl.js"></script>
    <script type="text/javascript" src="/Scripts/MultiLanguage.js"></script>
    <script type="text/javascript" src="/Scripts/Math.uuid.js"></script>
    <script type="text/javascript" src="/Scripts/date.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/lozad.js/1.16.0/lozad.min.js"></script>
    <style>
        .title-showAll:hover {
            cursor: pointer;
        }

        .game-item-info-detail {
            cursor: pointer;
        }
    </style>
</head>
<script type="text/javascript">
    if (self != top) {
        window.parent.API_LoadingStart();
    }
    var iframeWidth;
    var c = new common();
    var ui = new uiControl();
    var mlp;
    var lang;
    var WebInfo;
    //var marqueeText = "<%=MarqueeText%>";
    var LobbyGameList;
    var HotList;
    var v = "<%:Version%>";
    var initCreatedGameList = false;
    var GCB;
    //temp

    var MyGames;
    var FavoGames;
    var FavoGames;

    var FourGames = [
        {
            GameName: "OnmologistEX",
            GameBrand: "CG",
            GameLangName: "CG.OnmologistEX",
            GameNameJP: "オンミョウジ",
            Description: "先月、最大スピン数が出たゲームです"
        },
        {
            GameName: "vs25goldparty",
            GameBrand: "PP",
            GameLangName: "PP.vs25goldparty",
            GameNameJP: "ゴールドパーティ",
            Description: "先月、最高倍率が出たゲームです。"
        },
        {
            GameName: "NinjaEX",
            GameBrand: "CG",
            GameLangName: "CG.NinjaEX",
            GameNameJP: "ニンジャウォーリアー",
            Description: "大ヒット！ビッグウィンランキング一位を獲得したゲームです。"
        },
        {
            GameName: "LightningTable01",
            GameBrand: "EVO",
            GameLangName: "EVO.LightningTable01",
            GameNameJP: "ライトニング ルーレット",
            Description: "0から36まで37スポットのヨーロピアンタイプルーレットだが、毎回ランダムに発生する演出で配当が 50倍〜500倍GETできる！"
        },
        {
            GameName: "EWinGaming",
            GameBrand: "EWin",
            GameLangName: "EWinGaming",
            GameNameJP: "EWinゲーミング",
            Description: "元祖ライブバカラ新しいサービス初めました！"
        }, {
            GameName: "Sumo",
            GameBrand: "YS",
            GameLangName: "YS.Sumo",
            GameNameJP: "相撲",
            Description: "大相撲がY sportで大登場！是非世界初のブックメーカー楽しんで下さい。"
        }
    ];

    function initSwiper() {
        //HERO 
        var swiper = new Swiper(".thumbSwiper", {

            slidesPerView: "auto",
            freeMode: true,
            // enabled: false,
            allowTouchMove: false,
            watchSlidesProgress: false,
        });

        var heroIndex = new Swiper("#hero-slider", {
            loop: true,
            slidesPerView: 1,
            // effect: "fade",
            speed: 1000, //Duration of transition between slides (in ms)
            autoplay: {
                delay: 4000,
                disableOnInteraction: false,
                pauseOnMouseEnter: true
            },
            // pagination: {
            //     el: ".swiper-pagination",
            //     clickable: true,
            //     renderBullet: function (index, className) {
            //         //   return '<span class="' + className + '">' + (index + 1) + "</span>";
            //         return '<span class="' + className + '">' + '<img src="images/banner/thumb-' + (index + 1) + '.png"></span>';
            //     },
            // },
            thumbs: {
                swiper: swiper,
            }
        });



        // 推薦遊戲
        var gameRecommend = new Swiper("#game-recommend", {
            loop: true,
            slidesPerView: "auto",
            slidesPerGroup: 8,
            navigation: {
                nextEl: "#game-recommend .swiper-button-next",
                prevEl: "#game-recommend .swiper-button-prev",
            },
            // breakpoints: {
            //     768: {
            //         slidesPerView: 4,
            //         freeMode: false                
            //     },
            //     1200: {
            //         slidesPerView: 6,
            //         freeMode: false                
            //     }
            // }

        });
    }

    function setFourGame(index) {
        var tempGI;
        var tempGI_img;
        var tempGI_a;
        var temp_gameItem;
        var ParentMain = document.getElementById("ParentRecommendGameItem");

        temp_gameItem = FourGames[index];
        tempGI = c.getTemplate("temRecommendGameItem");
        tempGI_img = tempGI.querySelector("img");
        tempGI_a = tempGI.querySelector("a");

        if (tempGI_img != null) {
            tempGI_img.src = WebInfo.EWinGameUrl + "/Files/GamePlatformPic/" + temp_gameItem.GameBrand + "/PC/" + WebInfo.Lang + "/" + temp_gameItem.GameName + ".png";
            tempGI_img.onerror = new Function("setDefaultIcon('" + temp_gameItem.GameBrand + "', '" + temp_gameItem.GameName + "')");
        }

        c.setClassText(tempGI, "gameName", null, temp_gameItem.GameNameJP);

        //if (temp_gameItem.GameLangName == "EWinGaming") {
        //    c.setClassText(tempGI, "gameName", null, mlp.getLanguageKey("EWinGaming"));
        //} else {
        //    GCB.GetByGameCode(temp_gameItem.GameLangName, function (gameItem) {

        //        if (gameItem) {
        //            let lang_GameName = gameItem.Language.find(x => x.LanguageCode == lang) ? gameItem.Language.find(x => x.LanguageCode == lang).DisplayText : "";
        //            c.setClassText(tempGI, "gameName", null, lang_GameName);
        //        } else {
        //            c.setClassText(tempGI, "gameName", null, "");
        //        }
        //    })
        //}

        c.setClassText(tempGI, "gameDescription", null, mlp.getLanguageKey(temp_gameItem.Description));
        tempGI.onclick = new Function("window.parent.openGame('" + temp_gameItem.GameBrand + "', '" + temp_gameItem.GameName + "','" + temp_gameItem.GameLangName + "')");
        ParentMain.prepend(tempGI);
    }

    function init() {
        if (self == top) {
            window.parent.location.href = "index.aspx";
        }

        GCB = window.parent.API_GetGCB();
        WebInfo = window.parent.API_GetWebInfo();
        p = window.parent.API_GetLobbyAPI();
        lang = window.parent.API_GetLang();
        mlp = new multiLanguage(v);
        //HotList = window.parent.API_GetGameList(1);
        //window.parent.API_LoadingStart();
        mlp.loadLanguage(lang, function () {
            if (p != null) {

                window.parent.API_LoadingEnd();

                getCompanyGameCode();

                if (FourGames) {
                    updateFourGame();
                }

            } else {
                window.parent.showMessageOK(mlp.getLanguageKey("錯誤"), mlp.getLanguageKey("網路錯誤"), function () {
                    window.parent.location.href = "index.aspx";
                });
            }
        });

        initSwiper();

        setBulletinBoard();

        iframeWidth = document.body.scrollWidth;
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
                date.championTypeStr += " crown-Payout ";
                count++;
            }
            if ((championType & 2) == 2) {
                date.championTypeStr += " crown-Multiplier ";
                count++;
            }

            if ((championType & 4) == 4) {
                date.championTypeStr += " crown-Spin ";
                count++;
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

    function updateFourGame() {
        var ParentMain = document.getElementById("ParentRecommendGameItem");
        ParentMain.innerHTML = "";
        for (var i = 0; i < FourGames.length; i++) {
            setFourGame(i);
        }
    }

    function getCompanyGameCode() {
        p.GetCompanyGameCodeThree(Math.uuid(), "Home", function (success, o) {
            if (success) {
                if (o.Result == 0) {
                    if (o.LobbyGameList.length > 0) {
                        var LobbyGameList = o.LobbyGameList;
                        for (var i = 0; i < LobbyGameList.length; i++) {
                            LobbyGameList[i].Categories.sort(function (a, b) {
                                return b.SortIndex - a.SortIndex;
                            });
                        }

                        window.parent.API_SetFavoToIndexDB(function () {
                            createPersonal(0, true).then(function () {
                                setSwiperBySelector(".GameItemGroup_PersonalFavo");
                            });
                        })

                        createPersonal(1, true).then(function () {
                            setSwiperBySelector(".GameItemGroup_PersonalFavo");
                        });

                        createCategory(LobbyGameList, "Home").then(function () {
                            setSwiper("Home");
                        });
                    } else {
                        window.parent.API_SetFavoToIndexDB(function () {
                            createPersonal(0, true).then(function () {
                                setSwiperBySelector(".GameItemGroup_PersonalFavo");
                            });
                        })

                        createPersonal(1, true).then(function () {
                            setSwiperBySelector(".GameItemGroup_PersonalFavo");
                        });
                    }
                } else {
                    window.parent.API_SetFavoToIndexDB(function () {
                        createPersonal(0, true).then(function () {
                            setSwiperBySelector(".GameItemGroup_PersonalFavo");
                        });
                    })

                    createPersonal(1, true).then(function () {
                        setSwiperBySelector(".GameItemGroup_PersonalFavo");
                    });
                }
            }
            else {
                window.parent.API_SetFavoToIndexDB(function () {
                    createPersonal(0, true).then(function () {
                        setSwiperBySelector(".GameItemGroup_PersonalFavo");
                    });
                })

                createPersonal(1, true).then(function () {
                    setSwiperBySelector(".GameItemGroup_PersonalFavo");
                });
            }

        });
    }

    async function createPersonal(type, isInit) {
        await new Promise((resolve, reject) => {
            var Location = "Home"
            var CategCode;
            var CategText;
            var categArea;
            var gameItems = "";

            switch (type) {
                case 0:
                    CategCode = "PersonalFavo";
                    CategText = "我的最愛";
                    break;
                case 1:
                    CategCode = "PersonalPlayed";
                    CategText = "曾經遊玩"
                    break;
                default:
                    CategCode = "PersonalFavo";
                    CategText = "我的最愛";
                    break;
            }

            GCB.GetPersonal(type,
                (gameItem) => {
                    var GI;
                    var btnlike;
                    var GItitle;
                    var gameitemlink;
                    var btnplay;
                    var imgsrc;
                    var gameName;
                    var _gameCategoryCode;
                    if (gameItem && gameItem.GameStatus == 0) {
                        var championData = checkChampionType(gameItem.ChampionType);
                        gameName = gameItem.Language.find(x => x.LanguageCode == lang) ? gameItem.Language.find(x => x.LanguageCode == lang).DisplayText : "";
                        var gameitemmobilepopup = '<span class="game-item-mobile-popup" data-toggle="modal"></span>';
                        if (gameItem.FavoTimeStamp != null) {
                            if (WebInfo.DeviceType == 0) {
                                btnlike = `<button type="button" class="btn-like desktop gameCode_${gameItem.GameCode} btn btn-round added" onclick="favBtnClcik('${gameItem.GameCode}')">`;
                            } else {
                                btnlike = `<button type="button" class="btn-like gameCode_${gameItem.GameCode} btn btn-round added" onclick="favBtnClcik('${gameItem.GameCode}')">`;
                            }

                        } else {
                            if (WebInfo.DeviceType == 0) {
                                btnlike = `<button type="button" class="btn-like desktop gameCode_${gameItem.GameCode} btn btn-round" onclick="favBtnClcik('${gameItem.GameCode}')">`;
                            } else {
                                btnlike = `<button type="button" class="btn-like gameCode_${gameItem.GameCode} btn btn-round" onclick="favBtnClcik('${gameItem.GameCode}')">`;
                            }

                        }

                        var RTP = "";
                        if (gameItem.RTPInfo) {
                            var RtpInfoObj = JSON.parse(gameItem.RTPInfo);

                            if (RtpInfoObj.RTP && RtpInfoObj.RTP != 0) {
                                RTP = RtpInfoObj.RTP.toString();
                            } else {
                                RTP = '--';
                            }
                        } else {
                            RTP = '--';
                        }

                        if (WebInfo.DeviceType == 1) {
                            GItitle = `<div class="swiper-slide ${'gameCode_' + gameItem.GameCode}">`;
                            btnplay = '<button type="button" class="btn btn-play">';
                            gameitemlink = `<span class="game-item-link"></span>`;
                            gameitemmobilepopup = `<span class="game-item-mobile-popup" data-toggle="modal" onclick="window.parent.API_MobileDeviceGameInfo('${gameItem.GameBrand}','${RTP}','${gameItem.GameName}',${gameItem.GameID},'${gameName}','${gameItem.GameCategoryCode}',${gameItem.ChampionType})"></span>`;
                        } else {
                            if (iframeWidth < 936) {
                                gameitemmobilepopup = `<span class="game-item-mobile-popup" data-toggle="modal" onclick="window.parent.API_MobileDeviceGameInfo('${gameItem.GameBrand}','${RTP}','${gameItem.GameName}',${gameItem.GameID},'${gameName}','${gameItem.GameCategoryCode}',${gameItem.ChampionType})"></span>`;
                            } else {
                                gameitemmobilepopup = '';
                            }

                            GItitle = `<div class="swiper-slide desktop ${'gameCode_' + gameItem.GameCode}" onclick="window.parent.openGame('${gameItem.GameBrand}', '${gameItem.GameName}','${gameName}')">`;
                            gameitemlink = '<span class="game-item-link"></span>';
                            btnplay = '<button type="button" class="btn btn-play" onclick="' + "window.parent.API_OpenGame('" + gameItem.GameBrand + "', '" + gameItem.GameName + "','" + gameName + "')" + '">';
                        }

                        imgsrc = WebInfo.EWinGameUrl + "/Files/GamePlatformPic/" + gameItem.GameBrand + "/PC/" + WebInfo.Lang + "/" + gameItem.GameName + ".png";

                        switch (gameItem.GameCategoryCode) {
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

                        GI = `${GItitle}
                                            <div class="game-item ${championData.crownLevel} ${championData.championTypeStr}">
                                                <div class="game-item-inner">
                                                ${gameitemmobilepopup}
                                                <div class="game-item-focus">
                                                    <div class="game-item-img">
                                                        ${gameitemlink}
                                                        <div class="img-wrap">
                                                            <img class="gameimg lozad" src="${imgsrc}">
                                                        </div>
                                                    </div>
                                                    <div class="game-item-info-detail open" onclick="window.parent.openGame('${gameItem.GameBrand}','${gameItem.GameName}','${gameName}')">
                                                        <div class="game-item-info-detail-wrapper">
                                                            <div class="game-item-info-detail-moreInfo">
                                                                <ul class="moreInfo-item-wrapper">
                                                                    <li class="moreInfo-item category ${_gameCategoryCode}">
                                                                        <span class="value"><i class="icon icon-mask"></i></span>
                                                                    </li>
                                                                    <li class="moreInfo-item brand">
                                                                        <span class="title language_replace">${mlp.getLanguageKey("廠牌")}</span>
                                                                        <span class="value GameBrand">${gameItem.GameBrand}</span>
                                                                    </li>
                                                                    <li class="moreInfo-item RTP">
                                                                         <span class="title">RTP</span>
                                                                         <span class="value number valueRTP">${RTP}</span>
                                                                    </li>
                                                                    <li class="moreInfo-item gamecode">
                                                                         <span class="title">NO.</span>
                                                                         <span class="value number GameID">${gameItem.GameID}</span>
                                                                    </li>
                                                                </ul>
                                                            </div>
                                                            <div class="game-item-info-detail-indicator">
                                                                <div class="game-item-info-detail-indicator-inner">
                                                                    <div class="info">
                                                                        <h3 class="game-item-name">${gameName}</h3>
                                                                    </div>
                                                                    <div class="action">
                                                                        <div class="btn-s-wrapper">
                                                                            <button type="button" class="btn-thumbUp btn btn-round is-hide">
                                                                                <i class="icon icon-m-thumup"></i>
                                                                            </button>
                                                                             ${btnlike}
                                                                                <i class="icon icon-m-favorite"></i>
                                                                            </button>
                                                                            <!-- <button type="button" class="btn-more btn btn-round">
                                                                                <i class="arrow arrow-down"></i>
                                                                            </button> -->
                                                                        </div>
                                                                        <!-- <button type="button" class="btn btn-play">
                                                                            <span class="language_replace">???</span><i class="triangle"></i></button> -->
                                                                    </div>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                                <div class="game-item-info">
                                                    <div class="game-item-info-inner">
                                                        <h3 class="game-item-name">${gameName}</h3>
                                                    </div>
                                                </div>
                                                </div>
                                             </div>
                                            </div>`;

                        gameItems += GI;
                    }
                }, (isDataExist) => {
                    if (isInit) {
                        let isHideStr;
                        if (isDataExist && gameItems) {

                        } else {
                            isHideStr = 'style="display:none"';
                        }

                        categArea = ` <section id="${'categ_' + CategCode}" class="section-wrap section-levelUp" ${isHideStr}>
                                             <div class="game_wrapper">
                                             <div class="sec-title-container">
                                             <div class="sec-title-wrapper">
                                             <h3 class="sec-title"><i class="icon icon-mask icon-star"></i><span class="language_replace title CategName langkey">${mlp.getLanguageKey(CategText)}</span></h3>
                                             </div>
                                             </div>
                                             <div class="game_slider swiper_container gameinfo-hover gameinfo-pack-bg round-arrow GameItemGroup_${Location} GameItemGroup_${CategCode}">
                                             <div class="swiper-wrapper GameItemGroupContent">
                                             ${gameItems}
                                             </div>
                                             <div class="swiper-button-next"></div>
                                             <div class="swiper-button-prev"></div>
                                             </div>
                                             </div>
                                             </section>`;
                        if (type == 0) {
                            $('#favoArea').prepend(categArea);
                        } else {
                            $('#recentArea').prepend(categArea);
                        }
                    } else {
                        if (isDataExist && gameItems) {
                            $('#categ_' + CategCode).show();
                        } else {
                            $('#categ_' + CategCode).hide();
                        }
                        $('.GameItemGroup_' + CategCode + ' .GameItemGroupContent').append(gameItems);
                    }

                    resolve();
                });
        });
    }

    async function createCategory(LobbyGameList, categoryName) {
        if (LobbyGameList) {

            var lobbyGame = LobbyGameList.find(function (o) {
                return o.Location == categoryName;
            });

            if (lobbyGame) {
                var Location = lobbyGame.Location;
                var categAreas = "";

                for (var i = 0; i < lobbyGame.Categories.length; i++) {
                    category = lobbyGame.Categories[i];
                    if (category) {

                        if (category.Datas.length > 0) {
                            var categArea="";
                            var textlink;
                            var gameItems = "";
                            var categName;
                            var gameBrand;

                            category.Datas = category.Datas.sort(function (a, b) {
                                return b.SortIndex - a.SortIndex;
                            });

                            for (var ii = 0; ii < category.Datas.length; ii++) {
                                var o = category.Datas[ii];
                                var _gameCategoryCode;
                                var GI;
                                var btnlike;
                                var GItitle;
                                var gameitemlink;
                                var btnplay;
                                var imgsrc;
                                var gameName;
                                var gameItem = await new Promise((resolve, reject) => {
                                    GCB.GetByGameCode(o.GameCode, (gameItem) => {
                                        resolve(gameItem);
                                    })
                                });

                                if (gameItem && gameItem.GameStatus == 0) {
                                    var championData = checkChampionType(gameItem.ChampionType);
                                    gameName = gameItem.Language.find(x => x.LanguageCode == lang) ? gameItem.Language.find(x => x.LanguageCode == lang).DisplayText : "";
                                    var gameitemmobilepopup = '<span class="game-item-mobile-popup" data-toggle="modal"></span>';
                                    if (gameItem.FavoTimeStamp != null) {
                                        if (WebInfo.DeviceType == 0) {
                                            btnlike = `<button type="button" class="btn-like gameCode_${gameItem.GameCode} btn desktop btn-round added" onclick="favBtnClcik('${gameItem.GameCode}')">`;
                                        } else {
                                            btnlike = `<button type="button" class="btn-like gameCode_${gameItem.GameCode} btn btn-round added" onclick="favBtnClcik('${gameItem.GameCode}')">`;
                                        }
                                    } else {
                                        if (WebInfo.DeviceType == 0) {
                                            btnlike = `<button type="button" class="btn-like gameCode_${gameItem.GameCode} btn desktop btn-round" onclick="favBtnClcik('${gameItem.GameCode}')">`;
                                        } else {
                                            btnlike = `<button type="button" class="btn-like gameCode_${gameItem.GameCode} btn btn-round" onclick="favBtnClcik('${gameItem.GameCode}')">`;
                                        }

                                    }

                                    var RTP = "";
                                    if (gameItem.RTPInfo) {
                                        var RtpInfoObj = JSON.parse(gameItem.RTPInfo);

                                        if (RtpInfoObj.RTP && RtpInfoObj.RTP != 0) {
                                            RTP = RtpInfoObj.RTP.toString();
                                        } else {
                                            RTP = '--';
                                        }
                                    } else {
                                        RTP = '--';
                                    }

                                    if (WebInfo.DeviceType == 1) {
                                        GItitle = `<div class="swiper-slide ${'gameCode_' + gameItem.GameCode}">`;
                                        btnplay = '<button type="button" class="btn btn-play">';
                                        gameitemlink = `<span class="game-item-link"></span>`;
                                        gameitemmobilepopup = `<span class="game-item-mobile-popup" data-toggle="modal" onclick="window.parent.API_MobileDeviceGameInfo('${gameItem.GameBrand}','${RTP}','${gameItem.GameName}',${gameItem.GameID},'${gameName}','${gameItem.GameCategoryCode}',${gameItem.ChampionType})"></span>`;
                                    } else {
                                        if (iframeWidth < 936) {
                                            gameitemmobilepopup = `<span class="game-item-mobile-popup" data-toggle="modal" onclick="window.parent.API_MobileDeviceGameInfo('${gameItem.GameBrand}','${RTP}','${gameItem.GameName}',${gameItem.GameID},'${gameName}','${gameItem.GameCategoryCode}',${gameItem.ChampionType})"></span>`;
                                        } else {
                                            gameitemmobilepopup = '';
                                        }

                                        GItitle = `<div class="swiper-slide desktop ${'gameCode_' + gameItem.GameCode}">`;
                                        gameitemlink = '<span class="game-item-link" onclick="' + "window.parent.API_OpenGame('" + gameItem.GameBrand + "', '" + gameItem.GameName + "','" + gameName + "')" + '"></span>';
                                        btnplay = '<button type="button" class="btn btn-play" onclick="' + "window.parent.API_OpenGame('" + gameItem.GameBrand + "', '" + gameItem.GameName + "','" + gameName + "')" + '">';
                                    }

                                    imgsrc = WebInfo.EWinGameUrl + "/Files/GamePlatformPic/" + gameItem.GameBrand + "/PC/" + WebInfo.Lang + "/" + gameItem.GameName + ".png";

                                    switch (gameItem.GameCategoryCode) {
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

                                    GI = `${GItitle}
                                            <div class="game-item ${championData.crownLevel} ${championData.championTypeStr}">
                                                <div class="game-item-inner">
                                                ${gameitemmobilepopup}
                                                <div class="game-item-focus">
                                                    <div class="game-item-img">
                                                        ${gameitemlink}
                                                        <div class="img-wrap">
                                                            <img class="gameimg lozad" src="${imgsrc}">
                                                        </div>
                                                    </div>
                                                   <div class="game-item-info-detail open" onclick="window.parent.openGame('${gameItem.GameBrand}','${gameItem.GameName}','${gameName}')">
                                                        <div class="game-item-info-detail-wrapper">
                                                            <div class="game-item-info-detail-moreInfo">
                                                                <ul class="moreInfo-item-wrapper">
                                                                    <li class="moreInfo-item category ${_gameCategoryCode}">
                                                                        <span class="value"><i class="icon icon-mask"></i></span>
                                                                    </li>
                                                                    <li class="moreInfo-item brand">
                                                                        <span class="title language_replace">${mlp.getLanguageKey("廠牌")}</span>
                                                                        <span class="value GameBrand">${gameItem.GameBrand}</span>
                                                                    </li>
                                                                    <li class="moreInfo-item RTP">
                                                                         <span class="title">RTP</span>
                                                                         <span class="value number valueRTP">${RTP}</span>
                                                                    </li>
                                                                    <li class="moreInfo-item gamecode">
                                                                         <span class="title">NO.</span>
                                                                         <span class="value number GameID">${gameItem.GameID}</span>
                                                                    </li>
                                                                </ul>
                                                            </div>
                                                            <div class="game-item-info-detail-indicator">
                                                                <div class="game-item-info-detail-indicator-inner">
                                                                    <div class="info">
                                                                        <h3 class="game-item-name">${gameName}</h3>
                                                                    </div>
                                                                    <div class="action">
                                                                        <div class="btn-s-wrapper">
                                                                            <button type="button" class="btn-thumbUp btn btn-round is-hide">
                                                                                <i class="icon icon-m-thumup"></i>
                                                                            </button>
                                                                             ${btnlike}
                                                                                <i class="icon icon-m-favorite"></i>
                                                                            </button>
                                                                            <!-- <button type="button" class="btn-more btn btn-round">
                                                                                <i class="arrow arrow-down"></i>
                                                                            </button> -->
                                                                        </div>
                                                                        <!-- <button type="button" class="btn btn-play">
                                                                            <span class="language_replace">???</span><i class="triangle"></i></button> -->
                                                                    </div>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                                <div class="game-item-info">
                                                    <div class="game-item-info-inner">
                                                        <h3 class="game-item-name">${gameName}</h3>
                                                    </div>
                                                </div>
                                                </div>
                                             </div>
                                            </div>`;

                                    gameItems += GI;
                                }
                            }

                            categName = category.CategoryName.replace('@', '').replace('#', '');
                            gameBrand = category.Datas[0].GameBrand;
                            if (WebInfo.DeviceType == 1) {
                                textlink = '';
                            } else {
                                textlink = `<a class="text-link">
                                            <span class="title-showAll" onclick="window.parent.API_SearchGameByBrand('${gameBrand}')">${mlp.getLanguageKey('全部顯示')}</span><i class="icon arrow arrow-right"></i>
                                            </a>`;
                            }

                            if (gameItems != "") {

                                if (category.SortIndex >= 90) {
                                    categArea = ` <section class="section-wrap section-levelUp">
                                              <div class="game_wrapper">
                                              <div class="sec-title-container">
                                              <div class="sec-title-wrapper">
                                              <h3 class="sec-title"><i class="icon icon-mask icon-star"></i><span class="language_replace title CategName langkey" onclick="window.parent.API_SearchGameByBrand('${gameBrand}')">${mlp.getLanguageKey(categName)}</span></h3>
                                              </div>
                                              ${textlink}
                                              </div>
                                              <div class="game_slider swiper_container gameinfo-hover gameinfo-pack-bg round-arrow GameItemGroup_${Location}">
                                              <div class="swiper-wrapper GameItemGroupContent">
                                              ${gameItems}
                                              </div>
                                              <div class="swiper-button-next"></div>
                                              <div class="swiper-button-prev"></div>
                                              </div>
                                              </div>
                                              </section>`;
                                } else {
                                    categArea = ` <section class="section-wrap section-levelUp">
                                             <div class="game_wrapper">
                                             <div class="sec-title-container">
                                             <div class="sec-title-wrapper">
                                             <h3 class="sec-title"><i class="icon icon-mask icon-star"></i><span class="language_replace title CategName langkey">${mlp.getLanguageKey(categName)}</span></h3>
                                             </div>
                                             </div>
                                             <div class="game_slider swiper_container gameinfo-hover gameinfo-pack-bg round-arrow GameItemGroup_${Location}">
                                             <div class="swiper-wrapper GameItemGroupContent">
                                             ${gameItems}
                                             </div>
                                             <div class="swiper-button-next"></div>
                                             <div class="swiper-button-prev"></div>
                                             </div>
                                             </div>
                                             </section>`;
                                }
                            }


                            categAreas += categArea;
                        }
                    }
                }

                $('#categoryArea').append(categAreas);
            }
        }
    }

    function setSwiperBySelector(selector) {
        if (WebInfo.DeviceType == 0) {
            new Swiper(selector, {
                slidesPerView: "auto",
                allowTouchMove: false,
                // loop:true,
                // slidesPerGroup: 2,
                // loopedSlides: 8,
                lazy: true,
                freeMode: true,
                navigation: {
                    nextEl: selector + " .swiper-button-next",
                    prevEl: selector + " .swiper-button-prev",
                },
                breakpoints: {

                    936: {
                        freeMode: false,
                        //slidesPerGroup: 6, //index:992px
                    },
                    1144: {
                        slidesPerGroup: 7, //index:1200px
                        //allowTouchMove: false, //拖曳
                    },
                    1384: {
                        slidesPerGroup: 7, //index:1440px
                        //allowTouchMove: false,
                    },
                    1544: {
                        slidesPerGroup: 7, //index:1600px
                        //allowTouchMove: false,
                    },
                    1864: {
                        slidesPerGroup: 8, //index:1920px
                        //allowTouchMove: false,
                    },
                    1920: {
                        slidesPerGroup: 8, //index:1920px up
                        //allowTouchMove: false,
                    },
                }
            });
        } else {
            new Swiper(selector, {
                slidesPerView: "auto",
                allowTouchMove: true,
                // loop:true,
                // slidesPerGroup: 2,
                // loopedSlides: 8,
                lazy: true,
                freeMode: true,
                navigation: {
                    nextEl: selector + " .swiper-button-next",
                    prevEl: selector + " .swiper-button-prev",
                },
                breakpoints: {

                    936: {
                        freeMode: false,
                        slidesPerGroup: 6, //index:992px
                    },
                    1144: {
                        slidesPerGroup: 7, //index:1200px
                        //allowTouchMove: false, //拖曳
                    },
                    1384: {
                        slidesPerGroup: 7, //index:1440px
                        //allowTouchMove: false,
                    },
                    1544: {
                        slidesPerGroup: 7, //index:1600px
                        //allowTouchMove: false,
                    },
                    1864: {
                        slidesPerGroup: 8, //index:1920px
                        //allowTouchMove: false,
                    },
                    1920: {
                        slidesPerGroup: 8, //index:1920px up
                        //allowTouchMove: false,
                    },
                }
            });
        }

    }

    function setSwiper(categoryName) {
        if (WebInfo.DeviceType == 0) {
            new Swiper(".GameItemGroup_" + categoryName, {
                slidesPerView: "auto",
                allowTouchMove: false,
                // loop:true,
                // slidesPerGroup: 2,
                // loopedSlides: 8,
                lazy: true,
                freeMode: true,
                navigation: {
                    nextEl: ".GameItemGroup_" + categoryName + " .swiper-button-next",
                    prevEl: ".GameItemGroup_" + categoryName + " .swiper-button-prev",
                },
                breakpoints: {

                    936: {
                        freeMode: false,
                        slidesPerGroup: 6, //index:992px
                    },
                    1144: {
                        slidesPerGroup: 7, //index:1200px
                        allowTouchMove: false, //拖曳
                    },
                    1384: {
                        slidesPerGroup: 7, //index:1440px
                        allowTouchMove: false,
                    },
                    1544: {
                        slidesPerGroup: 7, //index:1600px
                        allowTouchMove: false,
                    },
                    1864: {
                        slidesPerGroup: 8, //index:1920px
                        allowTouchMove: false,
                    },
                    1920: {
                        slidesPerGroup: 8, //index:1920px up
                        allowTouchMove: false,
                    },
                }
            });
        } else {
            new Swiper(".GameItemGroup_" + categoryName, {
                slidesPerView: "auto",
                allowTouchMove: true,
                // loop:true,
                // slidesPerGroup: 2,
                // loopedSlides: 8,
                lazy: true,
                freeMode: true,
                navigation: {
                    nextEl: ".GameItemGroup_" + categoryName + " .swiper-button-next",
                    prevEl: ".GameItemGroup_" + categoryName + " .swiper-button-prev",
                },
                breakpoints: {

                    936: {
                        freeMode: false,
                        slidesPerGroup: 6, //index:992px
                    },
                    1144: {
                        slidesPerGroup: 7, //index:1200px
                        //allowTouchMove: false, //拖曳
                    },
                    1384: {
                        slidesPerGroup: 7, //index:1440px
                        //allowTouchMove: false,
                    },
                    1544: {
                        slidesPerGroup: 7, //index:1600px
                        //allowTouchMove: false,
                    },
                    1864: {
                        slidesPerGroup: 8, //index:1920px
                        //allowTouchMove: false,
                    },
                    1920: {
                        slidesPerGroup: 8, //index:1920px up
                        //allowTouchMove: false,
                    },
                }
            });
        }

    }

    function setBulletinBoard() {
        var GUID = Math.uuid();
        p.CheckDocumentByTagName(GUID, "N1", function (success, o) {
            if (success) {
                if (o.Result == 0) {
                    var ParentMain = document.getElementById("idBulletinBoardContent");
                    var ParentMain2 = document.getElementById("idBulletinBoardContent2");
                    ParentMain.innerHTML = "";
                    ParentMain2.innerHTML = "";

                    if (o.DocumentList.length > 0) {
                        var RecordDom;
                        var RecordDom2;
                        //var numGameTotalValidBetValue = new BigNumber(0);
                        for (var i = 0; i < o.DocumentList.length; i++) {
                            var record = o.DocumentList[i];

                            RecordDom = c.getTemplate("idTempBulletinBoard");
                            RecordDom2 = c.getTemplate("idTempBulletinBoard");

                            c.setClassText(RecordDom, "BulletinTitle", null, record.DocumentTitle);
                            c.setClassText(RecordDom2, "BulletinTitle", null, record.DocumentTitle);

                            RecordDom.onclick = new Function("window.parent.showBoardMsg('" + record.DocumentTitle + "','" + record.DocNumber + "')");
                            RecordDom2.onclick = new Function("window.parent.showBoardMsg('" + record.DocumentTitle + "','" + record.DocNumber + "')");
                            ParentMain.appendChild(RecordDom);
                            ParentMain2.appendChild(RecordDom2);
                        }
                    }
                }
            }
        });
    }

    function setUserThisWeekLogined(UserThisWeekTotalValidBetValueData) {
        if (UserThisWeekTotalValidBetValueData) {
            let k = 0;
            for (var i = 0; i < UserThisWeekTotalValidBetValueData.length; i++) {
                if (UserThisWeekTotalValidBetValueData[i].Status == 1) {
                    k++;
                    $(".bouns-item").eq(i).addClass("got");
                }
            }

            if (k == 7) {
                $(".bouns-amount").text(10000);
            } else {
                $(".bouns-amount").text(k * 1000);
            }
        }
    }

    function EWinEventNotify(eventName, isDisplay, param) {
        switch (eventName) {
            case "LoginState":
                //updateBaseInfo();

                break;
            case "BalanceChange":
                break;
            case "SetLanguage":
                lang = param;

                mlp.loadLanguage(lang, function () {
                    updateFourGame();
                    window.parent.API_LoadingEnd(1);
                });

                break;
            case "resize":
                //if ((iframeWidth > param && param < 936) || (iframeWidth < param && param > 936)) {
                //    //updateGameList();
                //    refreshFavoGame();
                //}

                break;
            case "RefreshPersonalFavo":
                //window.parent.API_LoadingEnd();
                var selector = "." + ("gameCode_" + param.GameCode + ".btn-like").replace(".", "\\.");
                $(".GameItemGroup_PersonalFavo .GameItemGroupContent").empty();
                if (param.IsAdded) {
                    $(selector).addClass("added");

                } else {
                    $(selector).removeClass("added");

                    //if ($(".GameItemGroup_PersonalFavo .gameCode_" + param.GameCode).length == 0) {
                    //    $(".GameItemGroup_PersonalFavo").css("display", "none");
                    //} else {
                    //    $(".GameItemGroup_PersonalFavo").css("display", "none");
                    //}
                }

                createPersonal(0, false).then(function () {
                    setSwiperBySelector(".GameItemGroup_PersonalFavo");
                });
                break;
            case "RefreshPersonalPlayed":
                //window.parent.API_LoadingEnd();
                $(".GameItemGroup_PersonalPlayed .GameItemGroupContent").empty();
                createPersonal(1, false).then(function () {
                    setSwiperBySelector(".GameItemGroup_PersonalPlayed");
                });
                break;
            case "GameLoadEnd":
                //if (!initCreatedGameList) {                                     
                //updateGameList();
                //}
                window.parent.API_LoadingEnd();
                break;
        }
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

    function ComingSoonAlert() {
        window.parent.API_ShowMessageOK("", "<p style='font-size:2em;text-align:center;margin:auto'>" + mlp.getLanguageKey("近期開放") + "</p>");
    }

    function favBtnClcik(gameCode) {
        if (WebInfo.UserLogined) {
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
                window.parent.API_LoadPage("Login", "Login.aspx");
            }, null);
        }
    }

    window.onload = init;

</script>
<body class="innerBody">
    <main class="innerMain">
        <section class="section-wrap hero">
            <div class="swiper hero_slider swiper-container round-arrow" id="hero-slider">
                <div class="swiper-wrapper">
                    <%--<div class="swiper-slide">
                        <div class="hero-item">
                            <a class="hero-item-link " onclick="window.open('Activity/event/ysport/index.html')"></a>
                            <div class="hero-item-box mobile">
                                <img src="images/banner/sumo-m.jpg" alt="">
                            </div>
                            <div class="hero-item-box desktop">
                                <div class="img-wrap">
                                    <img src="images/banner/sumo.jpg" class="bg">
                                </div>
                            </div>
                        </div>
                    </div>--%>
                    <div class="swiper-slide">
                        <div class="hero-item">
                            <a class="hero-item-link " onclick="window.parent.API_LoadPage('ActivityCenter','ActivityCenter.aspx?type=1')"></a>
                            <div class="hero-item-box mobile">
                                <img src="images/banner/b2-m.jpg?1" alt="">
                            </div>
                            <div class="hero-item-box desktop">
                                <div class="img-wrap">
                                    <img src="images/banner/b2.jpg?1" class="bg">
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="swiper-slide">
                        <div class="hero-item">
                            <a class="hero-item-link " onclick="window.parent.API_LoadPage('ActivityCenter','ActivityCenter.aspx?type=2')"></a>
                            <div class="hero-item-box mobile">
                                <img src="images/banner/b1-m.jpg" alt="">
                            </div>
                            <div class="hero-item-box desktop">
                                <div class="img-wrap">
                                    <img src="images/banner/b1.jpg" class="bg">
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="swiper-slide">
                        <div class="hero-item">
                            <a class="hero-item-link " onclick="window.parent.API_LoadPage('ActivityCenter','ActivityCenter.aspx?type=3')"></a>
                            <div class="hero-item-box mobile">
                                <img src="images/banner/b3-m.jpg" alt="">
                            </div>
                            <div class="hero-item-box desktop">
                                <div class="img-wrap">
                                    <img src="images/banner/b3.jpg" class="bg">
                                </div>
                            </div>
                        </div>
                    </div>
                  <%--  <div class="swiper-slide">
                        <div class="hero-item">
                            <a class="hero-item-link " onclick="window.parent.API_LoadPage('ActMishuha','/Activity/ActMishuha/index.html', true)"></a>
                            <!-- <a class="hero-item-link " onclick="API_LoadPage('ActMishuha','/Activity/ActMishuha/index.html')"></a> -->
                            <div class="hero-item-box mobile">
                                <img src="images/banner/b5-m.jpg" alt="">
                            </div>
                            <div class="hero-item-box desktop">
                                <div class="img-wrap">
                                    <img src="images/banner/b5.jpg" class="bg">
                                </div>
                            </div>
                        </div>
                    </div>--%>
                </div>
                <div class="swiper-mask"></div>
                <%--
                <div class="container">
                    <div class="swiper-pagination"></div>
                </div> --%>
            </div>
            <!-- 縮圖 ====================-->
            <div class="thumb-wrapper">
                <div class="container">
                    <div thumbsslider="" class="thumbSwiper">
                        <div class="swiper-wrapper">
                            <%--<div class="swiper-slide">
                                <img src="images/banner/thumb-8.png" alt="">
                            </div>--%>
                            <div class="swiper-slide">
                                <img src="images/banner/thumb-1.png" alt="">
                            </div>
                            <div class="swiper-slide">
                                <img src="images/banner/thumb-2.png" alt="">
                            </div>
                            <div class="swiper-slide">
                                <img src="images/banner/thumb-3.png" alt="">
                            </div>
                         <%--   <div class="swiper-slide">
                                <img src="images/banner/thumb-4.png" alt="">
                            </div>--%>
                        </div>
                    </div>
                </div>
            </div>
        </section>

        <!-- 推薦遊戲 -->
        <section class="section_recommand section-wrap">
            <div class="container">
                <div class="sec-title-container">
                    <div class="sec-title-wrapper">
                        <h3 class="sec-title"><i class="icon icon-mask icon-star"></i><span class="title  language_replace CategoryName">推薦遊戲</span></h3>
                    </div>
                    <%--
                    <a class="text-link" href="casino.html">
                        <span class="language_replace">全部顯示</span><i class="icon arrow arrow-right"></i>
                    </a>
                    --%>
                </div>
                <div class="box-item-container recommend-list" id="ParentRecommendGameItem">
                </div>
            </div>
        </section>

        <!-- 遊戲大廳入口 + 自定義分類 + 活動中心-->
        <div class="entrance_Game_wrapper game-area overflow-hidden">
            <div class="container">
                <div class="entrance_Game_inner">
                    <!-- 遊戲大廳入口 -->
                    <section class="section-lobbyEntrance section-wrap">
                        <div class="section-lobbyEntrance-wrapper" onclick="window.parent.API_LoadPage('Casino','Casino.aspx')">
                            <img src="images/index/lobby-entrance.jpg" alt="">
                        </div>
                    </section>
                    <!-- 自定義分類 -->
                    <section class="section-game-area section-wrap ">
                        <div class="" id="gameAreas">
                            <div id="favoArea">
                            </div>
                            <div id="recentArea">
                            </div>
                            <div id="categoryArea">
                            </div>
                        </div>
                    </section>
                    <!-- 活動中心 -->
                    <section class="section-activityCenter section-wrap">
                        <div class="activity-center-wrapper lable-new" onclick="window.top.API_LoadPage('','ActivityCenter.aspx')">
                            <div class="activity-center-inner">
                                <div class="activity-center-content">
                                    <div class="title language_replace">活動中心</div>
                                    <div class="btn btn-activity-in"><span class="language_replace">參加</span></div>
                                </div>
                            </div>
                        </div>
                    </section>
                </div>
            </div>
        </div>
        <section class="section_publicize section-wrap">
            <div class="container">
                <!-- writer + vTuber -->
                <%--
                <div class="publicize_wrapper publicize_top">
                    <div class="publicize_top_inner">
                        <div class="item writer">
                            <img src="images/index/writer-comingsoon.png" alt="">
                        </div>
                        <div class="item vtuber">
                            <img src="images/index/vtuber-comingsoon.png" alt="">
                        </div>
                    </div>
                </div>
                --%>
                <!-- 入出金說明 + 最新公告 + 會員簽到進度顯示 -->
                <div class="publicize_wrapper publicize_bottom">
                    <div class="publicize_bottom_inner">
                        <!-- 入出金說明 -->
                        <div class="publicize-wrap way-payment-wrapper">
                            <div class="item way-payment-inner" onclick="window.top.API_LoadPage('','Article/guide_CashQa_jp.html')">
                                <div class="way-payment-img">
                                    <div class="img-crop">
                                        <img src="images/theme/girl-half.png" class="mobile" alt="">
                                    </div>
                                </div>
                                <div class="way-payment-content">
                                    <div class="way-payment-detail">
                                        <h2 class="title language_replace">入出金の手順</h2>
                                        <p class="desc language_replace">Deposit and Withdrawal Instructions</p>
                                    </div>
                                </div>

                            </div>
                        </div>
                        <!-- 最新公告 + 會員簽到進度顯示-->
                        <div class="publicize-wrap bulletin-login">
                            <div class="item daily-login">
                                <!-- 會員簽到進度顯示 -->
                                <div class="activity-dailylogin-wrapper" onclick="window.parent.API_LoadPage('','ActivityCenter.aspx?type=3')">
                                    <%--
                                    <div class="coming-soon-text">
                                        2022/7/8 イベントスタート
                                    </div>
                                    --%>
                                    <div class="dailylogin-bouns-wrapper">
                                        <div class="dailylogin-bouns-inner">
                                            <div class="dailylogin-bouns-content">
                                                <div class="sec-title">
                                                    <h3 class="title">
                                                        <span class="name language_replace">金曜日の<span>プレゼント</span></span></h3>
                                                        <span class="dailylogin-bouns-QA sec-title-intro-link">
                                                        <span class="btn btn-QA-dailylogin-bouns btn-full-stress btn-round"><i class="icon icon-mask icon-question"></i></span><span class="language_replace">説明</span></span>
                                                </div>

                                                <ul class="dailylogin-bouns-list">
                                                    <!-- 已領取 bouns => got-->
                                                    <li class="bouns-item">
                                                        <span class="day"><span class="language_replace">五</span></span></li>
                                                    <li class="bouns-item saturday">
                                                        <span class="day"><span class="language_replace">六</span></span>
                                                    </li>
                                                    <li class="bouns-item sunday">
                                                        <span class="day"><span class="language_replace">日</span></span></li>
                                                    <li class="bouns-item">
                                                        <span class="day"><span class="language_replace">一</span></span>
                                                    </li>
                                                    <li class="bouns-item">
                                                        <span class="day"><span class="language_replace">二</span></span></li>
                                                    <li class="bouns-item">
                                                        <span class="day"><span class="language_replace">三</span></span>
                                                    </li>
                                                    <li class="bouns-item">
                                                        <span class="day"><span class="language_replace">四</span></span>
                                                    </li>
                                                </ul>
                                                <div class="dailylogin-bouns-amount">
                                                    <span class="amount-title language_replace">累積獎金</span>
                                                    <span class="bouns-amount">0</span>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="item bulletin">
                                <div class="bulletin_inner">
                                    <div class="sec-title-container sec-col-2" data-toggle="modal" data-target="#popupBulletinList">
                                        <div class="sec-title-wrapper">
                                            <h2 class="sec-title"><i class="icon icon-mask icon-dialog"></i><span class="title language_replace">最新公告</span></h2>
                                        </div>
                                        <span class="btn btn-more btn-outline-main language_replace ">查看更多</span>
                                    </div>
                                    <ul class="bulletin_list" id="idBulletinBoardContent">
                                    </ul>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </section>
    </main>

    <div class="tmpModel" style="display: none;">
        <div id="idTempBulletinBoard" style="display: none;">
            <!-- <div> -->
            <li class="item">
                <span class="date CreateDate"></span>
                <span class="info BulletinTitle"></span>
            </li>
            <!-- </div> -->
        </div>
    </div>

    <div id="temCategArea" class="is-hide">
        <section class="section-wrap section-levelUp">
            <div class="game_wrapper">
                <div class="sec-title-container">
                    <div class="sec-title-wrapper">
                        <h3 class="sec-title"><i class="icon icon-mask icon-star"></i><span class="title  language_replace CategoryName"></span></h3>
                    </div>
                    <%--<a class="text-link" href="casino.html">
                        <span class="language_replace">全部顯示</span><i class="icon arrow arrow-right"></i>
                    </a>--%>
                </div>
                <div class="game_slider swiper_container gameinfo-hover gameinfo-pack-bg round-arrow GameItemGroup">
                    <div class="swiper-wrapper GameItemGroupContent">
                    </div>
                    <div class="swiper-button-next"></div>
                    <div class="swiper-button-prev"></div>
                </div>
            </div>
        </section>
    </div>

    <div id="temGameItem" class="is-hide">
        <div class="swiper-slide">
            <div class="game-item">
                <div class="game-item-inner">
                    <span class="game-item-mobile-popup" data-toggle="modal" data-target="#popupGameInfo"></span>
                    <div class="game-item-focus">
                        <div class="game-item-img">
                            <span class="game-item-link"></span>
                            <div class="img-wrap">
                                <img class="gameimg" src="">
                            </div>
                        </div>
                        <div class="game-item-info-detail">
                            <div class="game-item-info-detail-wrapper">
                                <div class="game-item-info-detail-moreInfo">
                                    <ul class="moreInfo-item-wrapper">
                                        <li class="moreInfo-item brand">
                                            <span class="title language_replace">廠牌</span>
                                            <span class="value GameBrand">PG</span>
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
                                            <h3 class="game-item-name"></h3>
                                        </div>
                                        <div class="action">
                                            <div class="btn-s-wrapper">
                                                <button type="button" class="btn-thumbUp btn btn-round">
                                                    <i class="icon icon-m-thumup"></i>
                                                </button>
                                                <button type="button" class="btn-like btn btn-round">
                                                    <i class="icon icon-m-favorite"></i>
                                                </button>
                                                <button type="button" class="btn-more btn btn-round">
                                                    <i class="arrow arrow-down"></i>
                                                </button>
                                            </div>
                                            <button type="button" class="btn btn-play">
                                                <span class="language_replace">プレイ</span><i class="triangle"></i></button>
                                        </div>
                                    </div>
                                </div>
                            </div>

                        </div>
                    </div>
                    <div class="game-item-info">
                        <div class="game-item-info-inner">
                            <h3 class="game-item-name">バタフライブロッサム</h3>
                        </div>
                    </div>

                </div>
            </div>
        </div>
    </div>

    <div id="temRecommendGameItem" class="is-hide">
        <div class="box-item">
            <div class="box-item-link">
                <div class="box-item-inner">
                    <div class="box-item-img">
                        <div class="img-wrap">
                            <img src="">
                        </div>
                    </div>
                    <div class="box-item-detail">
                        <div class="box-item-title gameName"></div>
                        <div class="box-item-desc gameDescription"></div>
                    </div>
                    <span class="btn btn-round"><i class="icon arrow arrow-right"></i></span>

                </div>
            </div>
        </div>
    </div>

    <%--推薦遊戲--%>
    <%--
    <div id="temCategArea2" class="is-hide">
        <section class="section-wrap section_randomRem">
            <div class="container-fluid">
                <div class="game_wrapper">
                    <div class="sec-title-container">
                        <div class="sec-title-wrapper">
                            <!-- <h3 class="title">隨機推薦遊戲</h3> -->
                        </div>
                    </div>
                    <div class="game_slider swiper_container gameinfo-hover gameinfo-pack-bg round-arrow GameItemGroup">
                        <div class="swiper-wrapper GameItemGroupContent">
                        </div>
                    </div>
                </div>
        </section>
    </div>
    --%>
    <div id="temGameItem2" class="is-hide">
        <div class="swiper-slide">
            <div class="game-item">
                <div class="game-item-inner">
                    <span class="game-item-link"></span>
                    <div class="img-wrap">
                        <img class="gameimg lozad" src="">
                    </div>
                </div>
                <div class="game-item-info">
                    <h3 class="game-item-name"></h3>
                </div>
            </div>
        </div>
    </div>

    <%--<div class="float_SideBar">
        <div class="Line-AddFriend">
            <a onclick="window.open('https://lin.ee/KD05l9X')">
                <span class="addFriend">
                    <span class="logo">
                        <img src="../images/assets/LINE/Line_W.png" alt=""></span>
                </span>
            </a>
        </div>
    </div>--%>

    <div class="float_SideBar" id="float_SideBar">
        <div class="guide-QA" onclick="window.parent.API_LoadPage('guide_QnA', '/Article/guide_Q&amp;A_jp.html', false)">
            <a>
                <!-- <div class="text">
                    <h3 class="title language_replace" langkey="Q&amp;A">Q&amp;A</h3>
                </div> -->
                <div class="img-wrap">
                    <img src="images/Q_A.svg">
                </div>
            </a>
        </div>
    </div>

    <!-- 最新公告-總列表 -->
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
</body>
</html>
