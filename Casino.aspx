<%@ Page Language="C#" %>

<%
    string Version = EWinWeb.Version;

    string selectedCategory ="GameList_Hot";

    if (string.IsNullOrEmpty(Request["selectedCategory"]) == false) {
        selectedCategory = Request["selectedCategory"];
    }
%>
<!doctype html>
<html class="innerHtml">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Lucky Fanta</title>
    <link href="Scripts/vendor/swiper/css/swiper-bundle.min.css" rel="stylesheet" />
    <link href="css/basic.min.css" rel="stylesheet" />
    <link href="css/main.css" rel="stylesheet" />
    <link href="css/lobby.css" rel="stylesheet" />
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+JP:wght@300;500&display=swap" rel="Prefetch" as="style" onload="this.rel = 'stylesheet'" />
    <!--===========JS========-->
    <script type="text/javascript" src="/Scripts/Common.js?<%:Version%>"></script>
    <%--<script type="text/javascript" src="/Scripts/UIControl.js"></script>--%>
    <script type="text/javascript" src="/Scripts/MultiLanguage.js"></script>
    <script type="text/javascript" src="/Scripts/Math.uuid.js"></script>
    <script type="text/javascript" src="/Scripts/bignumber.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/lozad.js/1.16.0/lozad.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/4.6.2/js/bootstrap.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/Swiper/6.7.1/swiper-bundle.min.js"></script>
    
    <style>
        .title-showAll:hover {
            cursor: pointer;
        }

        .game-item-info-detail{
            cursor: pointer;
        }

    </style>
</head>
<%--<script type="text/javascript" src="/Scripts/Common.js?<%:Version%>"></script>
<script type="text/javascript" src="/Scripts/UIControl.js"></script>
<script type="text/javascript" src="/Scripts/MultiLanguage.js"></script>
<script type="text/javascript" src="/Scripts/Math.uuid.js"></script>
<script type="text/javascript" src="/Scripts/bignumber.min.js"></script>
<script src="Scripts/OutSrc/lib/jquery/jquery.min.js"></script>
<script src="Scripts/vendor/bootstrap/bootstrap.min.js"></script>
<script src="Scripts/OutSrc/lib/bootstrap/js/bootstrap.bundle.min.js"></script>
<script src="Scripts/OutSrc/lib/swiper/js/swiper-bundle.min.js"></script>
<script src="Scripts/theme.js"></script>--%>
<%--<script src="Scripts/OutSrc/js/games.js"></script>--%>

<script type="text/javascript">      
    if (self != top) {
        window.parent.API_LoadingStart();
    }
    //var ui = new uiControl();
    var c = new common();
    var mlp;
    var sumask;
    var Webinfo;
    var p;
    var LobbyGameList;
    var lang;
    var nowGameBrand = "All";
    var gameBrandList = [];
    var v = "";
    var GCB;
    var iframeWidth;
    var selectedCategoryCode="<%=selectedCategory %>";
    var categoryDatas = [];
    var tmpCategory_GameList_All = "";
    var tmpCategory_GameList_Live = "";
    var tmpCategory_GameList_Electron = "";
    var tmpCategory_GameList_Other = "";
    var tmpCategory_GameList_Slot = "";
    var selectedCategorys = [];
    var GameCategoryCodeArray = [];

    var HeaderGames = [
        {
            GameCode: "BNG.242",
            GameBrand: "BNG",
            Location: "GameList_Hot",
            MobileSrc: "/images/lobby/dailypush-hot-M-001.jpg",
            PadSrc: "/images/lobby/dailypush-hot-MD-001.jpg",
            DesktopSrc: "/images/lobby/dailypush-hot-001.jpg",
            BackgroundColor: "#121a16"
        },
        {
            GameCode: "PNG.moonprincess",
            GameBrand: "PNG",
            Location: "GameList_Slot",
            MobileSrc: "/images/lobby/dailypush-slot-M-001.jpg",
            PadSrc: "/images/lobby/dailypush-slot-MD-001.jpg",
            DesktopSrc: "/images/lobby/dailypush-slot-001.jpg",
            BackgroundColor: "#3f2e56"
        },
        {
            GameCode: "EVO.LightningTable01",
            GameBrand: "EVO",
            Location: "GameList_Live",
            MobileSrc: "/images/lobby/dailypush-live-M-001.jpg",
            PadSrc: "/images/lobby/dailypush-live-MD-001.jpg",
            DesktopSrc: "/images/lobby/dailypush-live-001.jpg",
            BackgroundColor: "#010101"
        },
        {
            GameCode: "BTI.Sport",
            GameBrand: "BTI",
            Location: "GameList_Other",
            MobileSrc: "/images/lobby/dailypush-bti-M-001.jpg",
            PadSrc: "/images/lobby/dailypush-bti-MD-001.jpg",
            DesktopSrc: "/images/lobby/dailypush-bti-001.jpg",
            BackgroundColor: "#f66f13"
        },
        {
            GameCode: "MG.429",
            GameBrand: "MG",
            Location: "GameList_Brand",
            MobileSrc: "/images/lobby/dailypush-brand-M-001.jpg",
            PadSrc: "/images/lobby/dailypush-brand-MD-001.jpg",
            DesktopSrc: "/images/lobby/dailypush-brand-002.jpg",
            BackgroundColor: "#4c1802"
        },
        {
            GameCode: "EVO.GonzoTH000000001",
            GameBrand: "EVO",
            Location: "GameList_Favo",
            MobileSrc: "/images/lobby/dailypush-favo-M-001.jpg",
            PadSrc: "/images/lobby/dailypush-favo-MD-001.jpg",
            DesktopSrc: "/images/lobby/dailypush-favo-001.jpg",
            BackgroundColor: "#352c1d"
        }
    ];

    function showSearchGameModel() {
        window.parent.API_ShowSearchGameModel();
    }

    function loginRecover() {
        window.location.href = "LoginRecover.aspx";
    }

    function selGameCategory(categoryCode, doc) {

        selectedCategory = selectedCategoryCode;
        $('#idGameItemTitle .tab-item').removeClass('active');
        $(doc).addClass('active');
        selectedCategoryCode = categoryCode;
        if (!selectedCategorys.includes(categoryCode)) {
            createCategory(categoryCode, function () {
                var oldSel = $('#categoryPage_' + selectedCategory);
                var newSel = $('#categoryPage_' + categoryCode);

                //oldSel.addClass('contain-disappear');
                //oldSel.css('padding-bottom', '0');
                //newSel.removeClass('contain-disappear');
                //newSel.css('padding-bottom', '160px');

                oldSel.css('display', 'none');
                //oldSel.css('padding-bottom', '0');
                newSel.css('display', 'block');
                //newSel.css('padding-bottom', '160px');
                setSwiper(categoryCode);
            });
        } else {
            var oldSel = $('#categoryPage_' + selectedCategory);
            var newSel = $('#categoryPage_' + categoryCode);

            //oldSel.addClass('contain-disappear');
            //oldSel.css('padding-bottom', '0');
            //newSel.removeClass('contain-disappear');
            //newSel.css('padding-bottom', '160px');

            oldSel.css('display', 'none');
            //oldSel.css('padding-bottom', '0');
            newSel.css('display', 'block');
            //newSel.css('padding-bottom', '160px');
        }

        window.document.body.scrollTop = 0;
        window.document.documentElement.scrollTop = 0;
    }

    function setSwiper(categoryName) {
        if (WebInfo.DeviceType == 0) {
            new Swiper(".GameItemGroup0_" + categoryName, {
                slidesPerView: "auto",
                lazy: true,
                freeMode: true,
                allowTouchMove: false,
                navigation: {
                    nextEl: ".GameItemGroup0_" + categoryName + " .swiper-button-next",
                    prevEl: ".GameItemGroup0_" + categoryName + " .swiper-button-prev",
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
                    }
                }
            });
        } else {
            new Swiper(".GameItemGroup0_" + categoryName, {
                slidesPerView: "auto",
                lazy: true,
                freeMode: true,
                allowTouchMove: true,
                navigation: {
                    nextEl: ".GameItemGroup0_" + categoryName + " .swiper-button-next",
                    prevEl: ".GameItemGroup0_" + categoryName + " .swiper-button-prev",
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
                    }
                }
            });
        }

        new Swiper('.GameItemGroup1_' + categoryName, {
            effect: "coverflow",
            grabCursor: true,
            centeredSlides: true,
            slidesPerView: "auto",
            // slidesPerView: 5,
            coverflowEffect: {
                rotate: 20,
                stretch: 0,
                depth: 300,
                modifier: 1,
                slideShadows: true,
            },
            // pagination: {
            //     el: ".swiper-pagination",
            // },
            loop: true,
            autuplay: {
                delay: 100,
                disableOnInteraction: false,
            }
        });

    }

    async function createCategory(categoryName, cb) {
        if (LobbyGameList) {

            var lobbyGame = LobbyGameList.find(function (o) {
                return o.Location == categoryName;
            });

            if (lobbyGame) {
                selectedCategorys.push(categoryName);
                var Location = lobbyGame.Location;
                var categAreas = "";
                var gameBrand;
                var addContainStart = false;
                var addContainMiddle = false;
                var addContainEnd = false;
                for (var i = 0; i < lobbyGame.Categories.length; i++) {
                    category = lobbyGame.Categories[i];
                    if (category) {
                        var showType = category.ShowType;
                        var game_wrapper = "";
                        if (category.Datas.length > 0) {
                            var categArea="";
                            var textlink;
                            var gameItems = "";

                            category.Datas = category.Datas.sort(function (a, b) {
                                return b.SortIndex - a.SortIndex;
                            });

                            for (var ii = 0; ii < category.Datas.length; ii++) {
                                var o = category.Datas[ii];
                                var gameItem = await new Promise((resolve, reject) => {
                                    GCB.GetByGameCode(o.GameCode, (gameItem) => {
                                        resolve(gameItem);
                                    })
                                });

                                if (gameItem && gameItem.GameStatus==0) {
                                    createGameItem(gameItem, showType, function (stringGameItem) {
                                        gameBrand = gameItem.GameBrand;
                                        gameItems += stringGameItem;
                                    });
                                }
                            }

                            categName = category.CategoryName.replace('@', '').replace('#', '');

                            if (WebInfo.DeviceType == 1) {
                                textlink = '';
                            } else {
                                textlink = `<a class="text-link">
                    <span class="title-showAll" onclick="window.parent.API_SearchGameByBrand('${gameBrand}')">${mlp.getLanguageKey('全部顯示')}</span><i class="icon arrow arrow-right"></i>
                    </a>`;
                            }

                            if (showType == 0) {
                                if (!addContainStart) {
                                    addContainStart = true;
                                    addContainEnd = false;
                                }

                                game_wrapper = '<div class="game_wrapper">';
                            } else if (showType == 1) {
                                if (!addContainStart) {
                                    addContainStart = true;
                                    addContainEnd = false;
                                }
                                game_wrapper = '<div class="game_wrapper">';
                            } else if (showType == 2) {
                                addContainEnd = true;
                                addContainStart = false;
                                addContainMiddle = false;
                            }

                            if (gameItems!="") {
                                if (showType == 0) {
                                    if (Location == "GameList_Brand") {
                                        categArea = `<section class="section-wrap section-levelUp">
                                                    ${game_wrapper}
                                                    <div class="sec-title-container">
                                                    <div class="sec-title-wrapper">
                                                    <h3 class="sec-title"><i class="icon icon-mask icon-star"></i>
                                                    <span class="language_replace title CategName langkey" onclick="window.parent.API_SearchGameByBrand('${gameBrand}')">${mlp.getLanguageKey(categName)}</span>
                                                    </h3>
                                                    </div>
                                                    ${textlink}
                                                    </div>
                                                    <div class="game_slider swiper_container gameinfo-hover gameinfo-pack-bg round-arrow GameItemGroup0_${Location} data-showtype=${showType}">
                                                    <div class="swiper-wrapper GameItemGroupContent">
                                                    ${gameItems}
                                                    </div>
                                                    <div class="swiper-button-next"></div>
                                                    <div class="swiper-button-prev"></div>
                                                    </div>
                                                    </div>
                                                    </section>`;
                                    }
                                    else {
                                        categArea = `<section class="section-wrap section-levelUp">
                                                ${game_wrapper}
                                                <div class="sec-title-container">
                                                <div class="sec-title-wrapper">
                                                <h3 class="sec-title"><i class="icon icon-mask icon-star"></i>
                                                    <span class="language_replace title CategName langkey">${mlp.getLanguageKey(categName)}</span>
                                                </h3>
                                                </div>
                                                </div>
                                                <div class="game_slider swiper_container gameinfo-hover gameinfo-pack-bg round-arrow GameItemGroup0_${Location} data-showtype=${showType}">
                                                <div class="swiper-wrapper GameItemGroupContent">
                                                ${gameItems}
                                                </div>
                                                <div class="swiper-button-next"></div>
                                                <div class="swiper-button-prev"></div>
                                                </div>
                                                </div>
                                                </section>`;
                                    }
                                } else if (showType == 1) {
                                    if (Location == "GameList_Brand") {
                                        categArea = `<section class="section-wrap section-levelUp gameRanking">
                                                    ${game_wrapper}
                                                    <div class="sec-title-container">
                                                    <div class="sec-title-wrapper">
                                                    <h3 class="sec-title"><i class="icon icon-mask icon-star"></i>
                                                    <span class="language_replace title CategName langkey" onclick="window.parent.API_SearchGameByBrand('${gameBrand}')">${mlp.getLanguageKey(categName)}</span>
                                                    </h3>
                                                    </div>
                                                    ${textlink}
                                                    </div>
                                                    <div class="game_slider swiper_container gameinfo-hover gameinfo-pack-bg round-arrow GameItemGroup0_${Location} data-showtype=${showType}">
                                                    <div class="swiper-wrapper GameItemGroupContent">
                                                    ${gameItems}
                                                    </div>
                                                    <div class="swiper-button-next"></div>
                                                    <div class="swiper-button-prev"></div>
                                                    </div>
                                                    </div>
                                                    </section>`;
                                    }
                                    else {
                                        categArea = `<section class="section-wrap section-levelUp gameRanking">
                                                ${game_wrapper}
                                                <div class="sec-title-container">
                                                <div class="sec-title-wrapper">
                                                <h3 class="sec-title"><i class="icon icon-mask icon-star"></i>
                                                    <span class="language_replace title CategName langkey">${mlp.getLanguageKey(categName)}</span>
                                                </h3>
                                                </div>
                                                </div>
                                                <div class="game_slider swiper_container gameinfo-hover gameinfo-pack-bg round-arrow GameItemGroup0_${Location} data-showtype=${showType}">
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
                                else if (showType == 2) {
                                    categArea = `<section class="section-wrap section_randomRem">
                                                    <div class="container">
                                                        <div class="game_wrapper">
                                                            <div class="sec-title-container">
                                                                <div class="sec-title-wrapper">
                                                                </div>
                                                            </div>
                                                            <div class="game_slider swiper_container round-arrow swiper-cover GameItemGroup1_${Location}">
                                                                <div class="swiper-wrapper GameItemGroupContent">
                                                                ${gameItems}
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </section>`;
                                }
                            }

                         

                            if (addContainMiddle) {
                                categAreas += categArea;
                            } else {
                                if (addContainStart) {
                                    addContainMiddle = true;
                                    categAreas += '<div class="container"> ' + categArea;
                                } else if (addContainEnd) {
                                    addContainMiddle = false;
                                    categAreas += '</div>' + categArea;
                                } else {
                                    categAreas += categArea;
                                }
                            }



                        }
                    }
                }

                var categoryDiv = $('<div id="categoryPage_' + Location + '" class="categoryPage" style="display:none;"></div>');
                //var categoryDiv = $('<div id="categoryPage_' + Location + '" class="categoryPage contain-disappear"></div>');
                createHeaderGame(Location, function (headerGame) {
                    categoryDiv.append(headerGame);
                    categoryDiv.append(categAreas);
                    $('#gameAreas').append(categoryDiv);
                    cb();
                });
            }
        }
    }

    function createHeaderGame(Location, cb) {
        var type = "";
        var btnlike = "";
        var btnplay = "";
        var titleobj = "";
        switch (Location) {
            case "GameList_Hot":
                type = "hot";
                break;
            case "GameList_Slot":
                type = "slot";
                break;
            case "GameList_Live":
                type = "live";
                break;
            case "GameList_Other":
                type = "other";
                break;
            case "GameList_Brand":
                type = "brand";
                break;
            case "GameList_Favo":
                type = "favo";
                break;
            default:
        }

        var headerGameData = HeaderGames.find(function (o) { return o.Location == Location });
        if (headerGameData) {
            const promise = new Promise((resolve, reject) => {
                GCB.GetByGameCode(headerGameData.GameCode, (gameItem) => {
                    resolve(gameItem);
                })
            });
            promise.then((gameItem) => {
                if (gameItem) {
                    var championData = checkChampionType(gameItem.ChampionType);
                    gameName = gameItem.Language.find(x => x.LanguageCode == lang) ? gameItem.Language.find(x => x.LanguageCode == lang).DisplayText : "";
                    gameCode = gameItem.GameCode;
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

                    if (gameItem.FavoTimeStamp != null) {
                        if (WebInfo.DeviceType == 1) {
                            btnlike = `<button type="button" class="btn-like gameCode_${gameCode} btn btn-round added" onclick="favBtnClcik('${gameCode}')">`;
                        } else {
                            btnlike = `<button type="button" class="btn-like desktop gameCode_${gameCode} btn btn-round added" onclick="favBtnClcik('${gameCode}')">`;
                        }
                    } else {
                        if (WebInfo.DeviceType == 1) {
                            btnlike = `<button type="button" class="btn-like gameCode_${gameCode} btn btn-round" onclick="favBtnClcik('${gameCode}')">`;
                        } else {
                            btnlike = `<button type="button" class="btn-like desktop gameCode_${gameCode} btn btn-round" onclick="favBtnClcik('${gameCode}')">`;
                        }
                    }

                    if (WebInfo.DeviceType == 1) {
                        titleobj = `<section class="section-category-dailypush" onclick="window.parent.API_MobileDeviceGameInfo('${gameItem.GameBrand}','${RTP}','${gameItem.GameName}',${gameItem.GameID},'${gameName}','${gameItem.GameCategoryCode}',${gameItem.ChampionType})">`;
                        btnplay = `<button class="btn btn-play" onclick="window.parent.API_MobileDeviceGameInfo('${gameItem.GameBrand}','${RTP}','${gameItem.GameName}',${gameItem.GameID},'${gameName}','${gameItem.GameCategoryCode}',${gameItem.ChampionType})"><span class="language_replace">${mlp.getLanguageKey("進入遊戲")}</span></button>`;
                    } else {
                        titleobj = `<section class="section-category-dailypush" onclick="window.parent.openGame('${gameItem.GameBrand}', '${gameItem.GameName}','${gameName}')">`;
                        btnplay = `<button class="btn btn-play" onclick="window.parent.openGame('${gameItem.GameBrand}', '${gameItem.GameName}','${gameName}')"><span class="language_replace">${mlp.getLanguageKey("進入遊戲")}</span></button>`;
                    }

                    var docString = `<div class="container category-dailypush">
                                     ${titleobj}
                 <div class="category-dailypush-wrapper ${type} ${championData.crownLevel} ${championData.championTypeStr}">
                    <div class="category-dailypush-inner">
                        <div class="category-dailypush-img" style="background-color: ${headerGameData.BackgroundColor};">
                            <div class="img-box mobile">
                                <div class="img-wrap">
                                    <img src="${headerGameData.MobileSrc}" alt="">
                                </div>
                            </div>
                            <div class="img-box pad">
                                <div class="img-wrap">
                                    <img src="${headerGameData.PadSrc}" alt="">
                                </div>
                            </div>
                            <div class="img-box desktop">
                                <div class="img-wrap">
                                    <img src="${headerGameData.DesktopSrc}" alt="">
                                </div>
                            </div>
                        </div>
                        <div class="category-dailypush-cotentBox">
                            <div class="category-dailypush-cotent">
                                <h2 class="title language_replace">${mlp.getLanguageKey("本日優選推薦")}</h2>
                                <div class="info">
                                    <h3 class="gamename language_replace">${gameName}</h3>
                                    <div class="detail">
                                        <span class="gamebrand">${mlp.getLanguageKey(gameItem.GameBrand)}</span >
                                        <span class="gamecategory">${mlp.getLanguageKey(gameItem.GameCategoryCode)}</span>
                                    </div>
                                </div>
                                <div class="intro language_replace is-hide">
                                    遊戲介紹遊戲介紹遊戲介紹遊戲介紹遊戲介紹遊戲介紹遊戲介紹遊戲介紹遊戲介紹遊戲介紹遊戲介紹遊戲介紹
                                </div>
                                <div class="action">
                                    ${btnplay}
                                    <!-- 加入最愛 class=>added-->
                                    ${btnlike}
                                        <i class="icon icon-m-favorite"></i>
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
         </section>
        </div>`;

                    cb(docString);
                } else {
                    cb('');
                }

            });
        } else {
            cb('');
        }
    }

    function createGameItem(gameItem, showType, cb) {
        var gameitemmobilepopup;
        var GI;
        var GItitle;
        var gameitemlink;
        var imgsrc;
        var gameName;
        var gameItemInfo = "";

        if (gameItem) {
            gameName = gameItem.Language.find(x => x.LanguageCode == lang) ? gameItem.Language.find(x => x.LanguageCode == lang).DisplayText : "";
            //if (gameItem.ChampionType > 0) {
            //    debugger;
            //    console.log(gameItem);
            //}

            var championData = checkChampionType(gameItem.ChampionType);
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

            if (showType == 0) {
                gameItemInfo = `<div class="game-item-info">
                                    <div class="game-item-info-inner">
                                        <h3 class="game-item-name">${gameName}</h3>
                                    </div>
                                </div>`;
            } else if (showType == 2) {
                gameItemInfo = `<div class="game-item-info">
                                    <h3 class="game-item-name">${gameName}</h3>
                                 </div>`;
            }



            if (WebInfo.DeviceType == 1) {
                GItitle = `<div class="swiper-slide ${'gameid_' + gameItem.GameID}">`;
                gameitemlink = `<span class="game-item-link"></span>`;
                gameitemmobilepopup = `<span class="game-item-mobile-popup" data-toggle="modal" onclick="window.parent.API_MobileDeviceGameInfo('${gameItem.GameBrand}','${RTP}','${gameItem.GameName}',${gameItem.GameID},'${gameName}','${gameItem.GameCategoryCode}',${gameItem.ChampionType})"></span>`;
                //gameitemlink = `<span class="game-item-link" onclick="window.parent.API_MobileDeviceGameInfo('${gameItem.GameBrand}','${RTP}','${gameItem.GameName}',${gameItem.GameID})"></span>`;
            } else {
                if (iframeWidth < 936) {
                    gameitemmobilepopup = `<span class="game-item-mobile-popup" data-toggle="modal" onclick="window.parent.API_MobileDeviceGameInfo('${gameItem.GameBrand}','${RTP}','${gameItem.GameName}',${gameItem.GameID},'${gameName}','${gameItem.GameCategoryCode}',${gameItem.ChampionType})"></span>`;
                } else {
                    gameitemmobilepopup = '';
                }
         
                GItitle = `<div class="swiper-slide desktop ${'gameid_' + gameItem.GameID}">`;
                gameitemlink = `<span class="game-item-link" onclick="window.parent.openGame('${gameItem.GameBrand}', '${gameItem.GameName}','${gameName}')" onmouseover="appendGameProp('${gameItem.GameBrand}','${gameName}','${RTP}','${gameItem.GameID}','${gameItem.GameCode}',${showType},'${gameItem.GameCategoryCode}','${gameItem.GameName}')"></span>`;

            }
            
            imgsrc =  `${WebInfo.ImageUrl}/${gameItem.GameBrand}/${WebInfo.Lang}/${gameItem.GameName}.png`;
           /*  三冠王 ===========================
            等級：crownLevel-1/
            類別：crown-Payout派彩(1)/crown-Multiplier倍率(2)/crown-Spin轉數(4) 
            ----------------------------------------------------------
            等級：crownLevel-2
            類別：crown-P-M 派彩+倍率 / crown-P-S 派彩+轉數 / crown-M-S 派彩+轉數
            ----------------------------------------------------------
            等級：crownLevel-3
           */
            if (showType == 2) {
                GI = `${GItitle}
                        <div class="game-item ${championData.crownLevel} ${championData.championTypeStr}">
                            <div class="game-item-inner">
                                ${gameitemmobilepopup}
                                    ${gameitemlink}
                                    <div class="img-wrap">
                                        <img class="gameimg lozad" src="${imgsrc}" onerror="setDefaultIcon(this)">
                                    </div>
                             </div>
                             <div class="game-item-info">
                               <h3 class="game-item-name">${gameName}</h3>
                             </div>
                           </div>
                        </div>`;
            } else {
                GI = `${GItitle}
                        <div class="game-item ${championData.crownLevel} ${championData.championTypeStr}">
                            <div class="game-item-inner">
                            ${gameitemmobilepopup}
                            <div class="game-item-focus">
                                <div class="game-item-img">
                                    ${gameitemlink}
                                    <div class="img-wrap">
                                        <img class="gameimg lozad" src="${imgsrc}" onerror="setDefaultIcon(this)">
                                    </div>
                                </div>
 
                            </div>
                            ${gameItemInfo}
                            </div>
                        </div>
                    </div>`;
            }


            cb(GI);
        }
    }

    function checkChampionType(championType) {
        /*  三冠王 ===========================
             等級：crownLevel-1/
             類別：crown-Payout派彩(1)/crown-Multiplier倍率(2)/crown-Spin轉數(4)
             ----------------------------------------------------------
             等級：crownLevel-2
             類別：crown-P-M 派彩+倍率 / crown-P-S 派彩+轉數 / crown-M-S 派彩+轉數
             ----------------------------------------------------------
             等級：crownLevel-3
            */

        var date = {
            championTypeStr: "",
            crownLevel:""
        }
        var count = 0;
        if (championType != 0) {
            if ((championType & 1) == 1) {
                date.championTypeStr += " crown-Payout "
                count++;
            }

            if ((championType & 2) == 2) {
                date.championTypeStr += " crown-Multiplier "
                count++;
            }

            if ((championType & 4) == 4) {
                date.championTypeStr += " crown-Spin "
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
            else if (count == 3) { date.crownLevel = "crownLevel-3"; date.championTypeStr = "";  }
        }

      
        return date;
    }

    function appendGameProp(gameBrand, gameLangName, RTP, gameID, gameCode, showType, gameCategoryCode, gameName) {

        var doc = event.currentTarget;
        var jquerydoc = $(doc).parent().parent().eq(0);
        var btnlike;
        var gameProp;
        var _gameCategoryCode;

        const promise = new Promise((resolve, reject) => {
            GCB.GetByGameCode(gameCode, (gameItem) => {
                resolve(gameItem.FavoTimeStamp);
            })
        });
        promise.then((favoTimeStamp) => {

            switch (gameCategoryCode) {
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

            if (!jquerydoc.hasClass('addedGameProp')) {
                if (favoTimeStamp != null) {
                    if (WebInfo.DeviceType == 1) {
                        btnlike = `<button type="button" class="btn-like gameCode_${gameCode} btn btn-round added" onclick="favBtnClcik('${gameCode}')">`;
                    } else {
                        btnlike = `<button type="button" class="btn-like desktop gameCode_${gameCode} btn btn-round added" onclick="favBtnClcik('${gameCode}')">`;
                    }

                } else {
                    if (WebInfo.DeviceType == 1) {
                        btnlike = `<button type="button" class="btn-like gameCode_${gameCode} btn btn-round" onclick="favBtnClcik('${gameCode}')">`;
                    } else {
                        btnlike = `<button type="button" class="btn-like desktop gameCode_${gameCode} btn btn-round" onclick="favBtnClcik('${gameCode}')">`;
                    }

                }
                // onclick="' + "window.parent.openGame('" + gameItem.GameBrand + "', '" + gameItem.GameName + "','" + gameName + "')" 
                //<!-- 判斷分類 加入class=> slot/live/etc/elec-->
                if (showType != 2) {
                    gameProp = `<div class="game-item-info-detail open" onclick="window.parent.openGame('${gameBrand}','${gameName}','${gameLangName}')">
                                <div class="game-item-info-detail-wrapper">
                                    <div class="game-item-info-detail-moreInfo">
                                        <ul class="moreInfo-item-wrapper">
                                            <li class="moreInfo-item category ${_gameCategoryCode}">
                                                <span class="value"><i class="icon icon-mask"></i></span>
                                            </li>
                                            <li class="moreInfo-item brand">
                                                <span class="title language_replace">${mlp.getLanguageKey("廠牌")}</span>
                                                <span class="value GameBrand">${gameBrand}</span>
                                            </li>
                                            <li class="moreInfo-item RTP">
                                                 <span class="title">RTP</span>
                                                 <span class="value number valueRTP">${RTP}</span>
                                            </li>
                                            <li class="moreInfo-item gamecode">
                                                 <span class="title">NO.</span>
                                                 <span class="value number GameID">${gameID}</span>
                                            </li>
                                        </ul>
                                    </div>
                                    <div class="game-item-info-detail-indicator">
                                        <div class="game-item-info-detail-indicator-inner">
                                            <div class="info">
                                                <h3 class="game-item-name">${gameLangName}</h3>
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
                            </div>`;

                    jquerydoc.append(gameProp);
                }
                jquerydoc.addClass('addedGameProp');
            }

        });
    };

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

    function updateGameCode() {
        iframeWidth = window.innerWidth;
        var idGameItemTitle = document.getElementById("idGameItemTitle");
        idGameItemTitle.innerHTML = "";
        // 尋找新增+
        var RecordDom;
        var record;

        if (LobbyGameList) {
            for (var i = 0; i < LobbyGameList.length; i++) {
                LobbyGameList[i].Categories.sort(function (a, b) {
                    return b.SortIndex - a.SortIndex;
                });
            }

            //熱門
            var lobbyGame = LobbyGameList.find(function (o) { return o.Location == "GameList_Hot" });
            if (lobbyGame) {
                if (lobbyGame.Location.includes("GameList")) {
                    RecordDom = c.getTemplate("temCategItem");
                    c.setClassText(RecordDom, "CategName", null, mlp.getLanguageKey(lobbyGame.Location));
                    $(RecordDom).find('.CategName').attr('langkey', lobbyGame.Location);
                    switch (lobbyGame.Location) {
                        case 'GameList_Hot':
                            $(RecordDom).find('.CategIcon').addClass('icon-hot');
                            break;
                        case 'GameList_Favo':
                            $(RecordDom).find('.CategIcon').addClass('icon-favo');
                            break;
                        case 'GameList_Live':
                            $(RecordDom).find('.CategIcon').addClass('icon-live');
                            break;
                        case 'GameList_Slot':
                            $(RecordDom).find('.CategIcon').addClass('icon-slot');
                            break;
                        case 'GameList_Other':
                            $(RecordDom).find('.CategIcon').addClass('icon-etc');
                            break;
                        case 'GameList_Brand':
                            $(RecordDom).find('.CategIcon').addClass('icon-brand');
                            break;
                        default:
                    }
                    if (selectedCategoryCode == lobbyGame.Location) {
                        $(RecordDom).addClass('active');
                    }

                    RecordDom.onclick = new Function("selGameCategory('" + lobbyGame.Location + "',this)");
                    idGameItemTitle.appendChild(RecordDom);
                }
            }
            //老虎雞
            var lobbyGame = LobbyGameList.find(function (o) { return o.Location == "GameList_Slot" });
            if (lobbyGame) {
                if (lobbyGame.Location.includes("GameList")) {
                    RecordDom = c.getTemplate("temCategItem");
                    c.setClassText(RecordDom, "CategName", null, mlp.getLanguageKey(lobbyGame.Location));
                    $(RecordDom).find('.CategName').attr('langkey', lobbyGame.Location);
                    switch (lobbyGame.Location) {
                        case 'GameList_Hot':
                            $(RecordDom).find('.CategIcon').addClass('icon-hot');
                            break;
                        case 'GameList_Favo':
                            $(RecordDom).find('.CategIcon').addClass('icon-favo');
                            break;
                        case 'GameList_Live':
                            $(RecordDom).find('.CategIcon').addClass('icon-live');
                            break;
                        case 'GameList_Slot':
                            $(RecordDom).find('.CategIcon').addClass('icon-slot');
                            break;
                        case 'GameList_Other':
                            $(RecordDom).find('.CategIcon').addClass('icon-etc');
                            break;
                        case 'GameList_Brand':
                            $(RecordDom).find('.CategIcon').addClass('icon-brand');
                            break;
                        default:
                    }
                    if (selectedCategoryCode == lobbyGame.Location) {
                        $(RecordDom).addClass('active');
                    }

                    RecordDom.onclick = new Function("selGameCategory('" + lobbyGame.Location + "',this)");
                    idGameItemTitle.appendChild(RecordDom);
                }
            }
            //真人
            var lobbyGame = LobbyGameList.find(function (o) { return o.Location == "GameList_Live" });
            if (lobbyGame) {
                if (lobbyGame.Location.includes("GameList")) {
                    RecordDom = c.getTemplate("temCategItem");
                    c.setClassText(RecordDom, "CategName", null, mlp.getLanguageKey(lobbyGame.Location));
                    $(RecordDom).find('.CategName').attr('langkey', lobbyGame.Location);
                    switch (lobbyGame.Location) {
                        case 'GameList_Hot':
                            $(RecordDom).find('.CategIcon').addClass('icon-hot');
                            break;
                        case 'GameList_Favo':
                            $(RecordDom).find('.CategIcon').addClass('icon-favo');
                            break;
                        case 'GameList_Live':
                            $(RecordDom).find('.CategIcon').addClass('icon-live');
                            break;
                        case 'GameList_Slot':
                            $(RecordDom).find('.CategIcon').addClass('icon-slot');
                            break;
                        case 'GameList_Other':
                            $(RecordDom).find('.CategIcon').addClass('icon-etc');
                            break;
                        case 'GameList_Brand':
                            $(RecordDom).find('.CategIcon').addClass('icon-brand');
                            break;
                        default:
                    }

                    if (selectedCategoryCode == lobbyGame.Location) {
                        $(RecordDom).addClass('active');
                    }

                    RecordDom.onclick = new Function("selGameCategory('" + lobbyGame.Location + "',this)");
                    idGameItemTitle.appendChild(RecordDom);
                }
            }
            //其他
            var lobbyGame = LobbyGameList.find(function (o) { return o.Location == "GameList_Other" });
            if (lobbyGame) {
                if (lobbyGame.Location.includes("GameList")) {
                    RecordDom = c.getTemplate("temCategItem");
                    c.setClassText(RecordDom, "CategName", null, mlp.getLanguageKey(lobbyGame.Location));
                    $(RecordDom).find('.CategName').attr('langkey', lobbyGame.Location);
                    switch (lobbyGame.Location) {
                        case 'GameList_Hot':
                            $(RecordDom).find('.CategIcon').addClass('icon-hot');
                            break;
                        case 'GameList_Favo':
                            $(RecordDom).find('.CategIcon').addClass('icon-favo');
                            break;
                        case 'GameList_Live':
                            $(RecordDom).find('.CategIcon').addClass('icon-live');
                            break;
                        case 'GameList_Slot':
                            $(RecordDom).find('.CategIcon').addClass('icon-slot');
                            break;
                        case 'GameList_Other':
                            $(RecordDom).find('.CategIcon').addClass('icon-etc');
                            break;
                        case 'GameList_Brand':
                            $(RecordDom).find('.CategIcon').addClass('icon-brand');
                            break;
                        default:
                    }

                    if (selectedCategoryCode == lobbyGame.Location) {
                        $(RecordDom).addClass('active');
                    }

                    RecordDom.onclick = new Function("selGameCategory('" + lobbyGame.Location + "',this)");
                    idGameItemTitle.appendChild(RecordDom);
                }
            }
           
            //廠牌
            var lobbyGame = LobbyGameList.find(function (o) { return o.Location == "GameList_Brand" });
            if (lobbyGame) {
                if (lobbyGame.Location.includes("GameList")) {
                    RecordDom = c.getTemplate("temCategItem");
                    c.setClassText(RecordDom, "CategName", null, mlp.getLanguageKey(lobbyGame.Location));
                    $(RecordDom).find('.CategName').attr('langkey', lobbyGame.Location);
                    switch (lobbyGame.Location) {
                        case 'GameList_Hot':
                            $(RecordDom).find('.CategIcon').addClass('icon-hot');
                            break;
                        case 'GameList_Favo':
                            $(RecordDom).find('.CategIcon').addClass('icon-favo');
                            break;
                        case 'GameList_Live':
                            $(RecordDom).find('.CategIcon').addClass('icon-live');
                            break;
                        case 'GameList_Slot':
                            $(RecordDom).find('.CategIcon').addClass('icon-slot');
                            break;
                        case 'GameList_Other':
                            $(RecordDom).find('.CategIcon').addClass('icon-etc');
                            break;
                        case 'GameList_Brand':
                            $(RecordDom).find('.CategIcon').addClass('icon-brand');
                            break;
                        default:
                    }

                    if (selectedCategoryCode == lobbyGame.Location) {
                        $(RecordDom).addClass('active');
                    }

                    RecordDom.onclick = new Function("selGameCategory('" + lobbyGame.Location + "',this)");
                    idGameItemTitle.appendChild(RecordDom);
                }
            }
            $('#idGameItemTitle').append('<div class="tab-slide"></div>');
        }

        //selectedCategoryCode = "GameList_Hot";
        iframeWidth = window.innerWidth;
        var idGameItemGroup = document.getElementById("gameAreas");
        idGameItemGroup.innerHTML = "";
        
        createCategory(selectedCategoryCode, function () {
            //$('#idGameItemTitle .tab-item').eq(0).addClass('active');
            $('#categoryPage_' + selectedCategoryCode).css('display', 'block');

            //$('#categoryPage_' + selectedCategoryCode).removeClass('contain-disappear');
            //$('#categoryPage_' + selectedCategoryCode).css('overflow-y', 'hidden');
            
            setSwiper(selectedCategoryCode);
        });

    }

    function resetCategory(categoryCode) {

        selectedCategorys = [];
        var idGameItemGroup = document.getElementById("gameAreas");
        idGameItemGroup.innerHTML = "";
        iframeWidth = window.innerWidth;
        createCategory(categoryCode, function () {
            //$('.categoryPage').addClass('contain-disappear');
            //$('#categoryPage_' + categoryCode).removeClass('contain-disappear');
            $('.categoryPage').css('display', 'none');
            $('#categoryPage_' + categoryCode).css('display', 'block');
            setSwiper(categoryCode);
        });

    }

    function init() {
        if (self == top) {
            window.parent.location.href = "index.aspx";
        }

        GCB = window.parent.API_GetGCB();
        WebInfo = window.parent.API_GetWebInfo();
        p = window.parent.API_GetLobbyAPI();

        lang = window.parent.API_GetLang();

        //GCB.InitPromise.then(() => {
        //});

        mlp = new multiLanguage(v);
        mlp.loadLanguage(lang, function () {
            if (p != null) {
                getBanner();
                getCompanyGameCode();
            } else {
                window.parent.showMessageOK(mlp.getLanguageKey("錯誤"), mlp.getLanguageKey("網路錯誤"), function () {
                    window.parent.location.href = "index.aspx";
                });
            }
        });
    }

    function getCompanyGameCode() {
        p.GetCompanyGameCodeThree(Math.uuid(), "GameList", function (success, o) {
            if (success) {
                if (o.Result == 0) {
                    if (o.LobbyGameList.length > 0) {
                        LobbyGameList = o.LobbyGameList;
                        updateGameCode();

                        window.parent.API_SetFavoToIndexDB();
                    } else {
                        //window.parent.showMessageOK(mlp.getLanguageKey("錯誤"), mlp.getLanguageKey("網路錯誤"), function () {
                        //    window.parent.location.href = "index.aspx";
                        //});
                        window.parent.API_SetFavoToIndexDB();
                    }
                } else {
                    //window.parent.showMessageOK(mlp.getLanguageKey("錯誤"), mlp.getLanguageKey("網路錯誤"), function () {
                    //    window.parent.location.href = "index.aspx";
                    //});
                    window.parent.API_SetFavoToIndexDB();
                }
            }
            else {
                //window.parent.showMessageOK(mlp.getLanguageKey("錯誤"), mlp.getLanguageKey("網路錯誤"), function () {
                //    window.parent.location.href = "index.aspx";
                //});
                    window.parent.API_SetFavoToIndexDB();
            }

        });
    }

    function setDefaultIcon(e) {
        e.onerror = null;
        e.src = "images/icon/GameDefault.png";
    }

    function EWinEventNotify(eventName, isDisplay, param) {
        switch (eventName) {
            case "LoginState":
                //updateBaseInfo();

                break;
            case "BalanceChange":
                break;
            case "resize":

                //if ((iframeWidth > param && param < 936) || (iframeWidth < param && param > 936)) {
                //    resetCategory(selectedCategoryCode);
                //}

                break;
            case "RefreshPersonalFavo":
                //window.parent.API_LoadingEnd();
                var selector = "." + ("gameCode_" + param.GameCode + ".btn-like").replace(".", "\\.");

                if (param.IsAdded) {
                    $(selector).addClass("added");
                } else {
                    $(selector).removeClass("added");
                }
                break;
            case "SetLanguage":
                lang = param;

                mlp.loadLanguage(lang, function () {
                    getBanner();
                    window.parent.API_LoadingEnd(1);
                    resetCategory(selectedCategoryCode);
                });
            case "GameLoadEnd":
                //if (!initCreatedGameList) {                                     
                //updateGameList();
                //}

                break;
        }
    }

    function getBanner() {
        var GUID = Math.uuid();
        var TagName = "CasinoBanner";

        if (WebInfo.DeviceType == 1) {
            TagName = TagName + "_M";
        } else {
            TagName = TagName + "_P";
        }

        p.CheckDocumentByTagName(GUID, TagName, function (success, o) {
            if (success) {
                if (o.Result == 0) {
                    var ParentMain = document.getElementById("divBanner");
                    ParentMain.innerHTML = "";

                    if (o.DocumentList.length > 0) {
                        var RecordDom2;
                        var promiseAll = [];
                        for (var i = 0; i < o.DocumentList.length; i++) {
                            var record = o.DocumentList[i];

                            RecordDom2 = c.getTemplate("tmpBanner");

                            let DocNumber = record.DocNumber;
                            ParentMain.appendChild(RecordDom2);

                            var promise = new Promise((resolve, reject) => {
                                $.ajax({
                                    url: "<%=EWinWeb.EWinUrl%>/GetDocument.aspx?DocNumber=" + DocNumber,
                                    success: (function (res) {
                                        var k = this;
                                        if (WebInfo.DeviceType == 1) {
                                            $(k).find('.Banner_M').html(res);
                                            $(k).find('.Banner_M').children().find('img').removeAttr("width");
                                            $(k).find('.Banner_M').children().find('img').removeAttr("height");
                                            $(k).find('.Banner_M').children().find('img').unwrap();
                                        } else {
                                            $(k).find('.Banner_P').html(res);
                                            $(k).find('.Banner_P').children().find('img').addClass("bg");
                                            $(k).find('.Banner_P').children().find('img').unwrap();
                                        }
                                        resolve();
                                    }).bind(RecordDom2)
                                });
                            });

                            promiseAll.push(promise);

                        }

                        Promise.all(promiseAll).then(values => {
                            var heroLobby = new Swiper("#hero-slider-lobby", {
                                loop: true,
                                slidesPerView: "auto",
                                centeredSlides: true,
                                speed: 1000,
                                pagination: {
                                    el: ".swiper-pagination",
                                    clickable: true,
                                },

                            });
                            window.parent.API_LoadingEnd();
                        });
                    } else {
                        window.parent.API_LoadingEnd();
                    }
                } else {
                    window.parent.API_LoadingEnd();
                }
            } else {
                window.parent.API_LoadingEnd();
            }
        });
    }

    window.onload = init;
</script>

<body class="innerBody">
    <main class="innerMain">
        <section class="section-slider_lobby hero">
            <div class="hero_slider_lobby swiper_container round-arrow" id="hero-slider-lobby">
                <div class="swiper-wrapper" id="divBanner">
                  
                </div>
                <div class="swiper-pagination"></div>
            </div>
        </section>
        <div class="tab-game">
            <div class="tab-inner">
                <div class="tab-search" onclick="showSearchGameModel()">
                    <img src="images/icon/ico-search-dog-tt.svg" alt="" onerror="setDefaultIcon(this)"><span class="title language_replace">找遊戲</span>
                </div>
                <div class="tab-scroller tab-6">
                    <div class="tab-scroller__area">
                        <ul class="tab-scroller__content" id="idGameItemTitle">
                            <div class="tab-slide"></div>
                        </ul>
                    </div>
                </div>
            </div>
        </div>
        <!-- 各分類-單一遊戲推薦區 -->
         <%--    <section class="section-category-dailypush" style="display:none;">
            <div class="container">                
                <!-- hot -->
                <div class="category-dailypush-wrapper hot">
                    <div class="category-dailypush-inner">
                        <div class="category-dailypush-img" style="background-color: #121a16;">
                            <div class="img-box mobile">
                                <div class="img-wrap">
                                    <img src="images/lobby/dailypush-hot-M-001.jpg" alt="">
                                </div>
                            </div>
                            <div class="img-box desktop">
                                <div class="img-wrap">
                                    <img src="images/lobby/dailypush-hot-001.jpg" alt="">
                                </div>
                            </div>
                        </div>
                        <div class="category-dailypush-cotentBox">
                            <div class="category-dailypush-cotent">
                                <h2 class="title language_replace">本日優選推薦</h2>
                                <div class="info">
                                    <h3 class="gamename language_replace">叢林之王-集鴻運</h3>
                                    <div class="detail">
                                        <span class="gamebrand">BNG</span>
                                        <span class="gamecategory">HOT</span>
                                    </div>
                                </div>
                                <div class="intro language_replace is-hide">
                                    遊戲介紹遊戲介紹遊戲介紹遊戲介紹遊戲介紹遊戲介紹遊戲介紹遊戲介紹遊戲介紹遊戲介紹遊戲介紹遊戲介紹
                                </div>
                                <div class="action">
                                    <button class="btn btn-play"><span class="language_replace">進入遊戲</span></button>
                                    <!-- 加入最愛 class=>added-->
                                    <button type="button" class="btn-like btn btn-round">
                                        <i class="icon icon-m-favorite"></i>
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <!-- SLOT -->
                <div class="category-dailypush-wrapper slot">
                    <div class="category-dailypush-inner">
                        <div class="category-dailypush-img" style="background-color: #3f2e56;">
                            <div class="img-box mobile">
                                <div class="img-wrap">
                                    <img src="images/lobby/dailypush-slot-M-001.jpg" alt="">
                                </div>
                            </div>
                            <div class="img-box desktop">
                                <div class="img-wrap">
                                    <img src="images/lobby/dailypush-slot-001.jpg" alt="">
                                </div>
                            </div>
                        </div>
                        <div class="category-dailypush-cotentBox">
                            <div class="category-dailypush-cotent">
                                <h2 class="title language_replace">本日優選推薦</h2>
                                <div class="info">
                                    <h3 class="gamename language_replace">moonprincess 月亮守護者</h3>
                                    <div class="detail">
                                        <span class="gamebrand">PNG</span>
                                        <span class="gamecategory">SLOT</span>
                                    </div>
                                </div>
                                <div class="intro language_replace is-hide">
                                    遊戲介紹遊戲介紹遊戲介紹遊戲介紹遊戲介紹遊戲介紹遊戲介紹遊戲介紹遊戲介紹遊戲介紹遊戲介紹遊戲介紹
                                </div>
                                <div class="action">
                                    <button class="btn btn-play"><span class="language_replace">進入遊戲</span></button>
                                    <!-- 加入最愛 class=>added-->
                                    <button type="button" class="btn-like btn btn-round">
                                        <i class="icon icon-m-favorite"></i>
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <!-- LIVE -->   
                <div class="category-dailypush-wrapper live">
                    <div class="category-dailypush-inner">
                        <div class="category-dailypush-img" style="background-color: #010101;">
                            <div class="img-box mobile">
                                <div class="img-wrap">
                                    <img src="images/lobby/dailypush-live-M-001.jpg" alt="">
                                </div>
                            </div>
                            <div class="img-box desktop">
                                <div class="img-wrap">
                                    <img src="images/lobby/dailypush-live-001.jpg" alt="">
                                </div>
                            </div>
                        </div>
                        <div class="category-dailypush-cotentBox">
                            <div class="category-dailypush-cotent">
                                <h2 class="title language_replace">本日優選推薦</h2>
                                <div class="info">
                                    <h3 class="gamename language_replace">LightningTable01 閃電輪盤</h3>
                                    <div class="detail">
                                        <span class="gamebrand">EVO</span>
                                        <span class="gamecategory">LIVE</span>
                                    </div>
                                </div>
                                <div class="intro language_replace is-hide">
                                    遊戲介紹遊戲介紹遊戲介紹遊戲介紹遊戲介紹遊戲介紹遊戲介紹遊戲介紹遊戲介紹遊戲介紹遊戲介紹遊戲介紹
                                </div>
                                <div class="action">
                                    <button class="btn btn-play"><span class="language_replace">進入遊戲</span></button>
                                    <!-- 加入最愛 class=>added-->
                                    <button type="button" class="btn-like btn btn-round">
                                        <i class="icon icon-m-favorite"></i>
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>             
                <div class="category-dailypush-wrapper other">
                    <div class="category-dailypush-inner">
                        <div class="category-dailypush-img" style="background-color: #3a3227;">
                            <div class="img-box mobile">
                                <div class="img-wrap">
                                    <img src="images/lobby/dailypush-other-M-001.jpg" alt="">
                                </div>
                            </div>
                            <div class="img-box desktop">
                                <div class="img-wrap">
                                    <img src="images/lobby/dailypush-other-001.jpg" alt="">
                                </div>
                            </div>
                        </div>
                        <div class="category-dailypush-cotentBox">
                            <div class="category-dailypush-cotent">
                                <h2 class="title language_replace">本日優選推薦</h2>
                                <div class="info">
                                    <h3 class="gamename language_replace">7PK</h3>
                                    <div class="detail">
                                        <span class="gamebrand">KGS</span>
                                        <span class="gamecategory">OTHER</span>
                                    </div>
                                </div>
                                <div class="intro language_replace is-hide">
                                    遊戲介紹遊戲介紹遊戲介紹遊戲介紹遊戲介紹遊戲介紹遊戲介紹遊戲介紹遊戲介紹遊戲介紹遊戲介紹遊戲介紹
                                </div>
                                <div class="action">
                                    <button class="btn btn-play"><span class="language_replace">進入遊戲</span></button>
                                    <button type="button" class="btn-like btn btn-round">
                                        <i class="icon icon-m-favorite"></i>
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>             
                <div class="category-dailypush-wrapper favo">
                    <div class="category-dailypush-inner">
                        <div class="category-dailypush-img" style="background-color: #352c1d;">
                            <div class="img-box mobile">
                                <div class="img-wrap">
                                    <img src="images/lobby/dailypush-favo-M-001.jpg" alt="">
                                </div>
                            </div>
                            <div class="img-box desktop">
                                <div class="img-wrap">
                                    <img src="images/lobby/dailypush-favo-001.jpg" alt="">
                                </div>
                            </div>
                        </div>
                        <div class="category-dailypush-cotentBox">
                            <div class="category-dailypush-cotent">
                                <h2 class="title language_replace">本日優選推薦</h2>
                                <div class="info">
                                    <h3 class="gamename language_replace">GonzoTH000000001 岡佐的尋寶之旅</h3>
                                    <div class="detail">
                                        <span class="gamebrand">EVO</span>
                                        <span class="gamecategory">FAVO</span>
                                    </div>
                                </div>
                                <div class="intro language_replace is-hide">
                                    遊戲介紹遊戲介紹遊戲介紹遊戲介紹遊戲介紹遊戲介紹遊戲介紹遊戲介紹遊戲介紹遊戲介紹遊戲介紹遊戲介紹
                                </div>
                                <div class="action">
                                    <button class="btn btn-play"><span class="language_replace">進入遊戲</span></button>
                                    <!-- 加入最愛 class=>added-->
                                    <button type="button" class="btn-like btn btn-round">
                                        <i class="icon icon-m-favorite"></i>
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>             
                <div class="category-dailypush-wrapper brand">
                    <div class="category-dailypush-inner">
                        <div class="category-dailypush-img" style="background-color: #4c1802;">
                            <div class="img-box mobile">
                                <div class="img-wrap">
                                    <img src="images/lobby/dailypush-brand-M-001.jpg" alt="">
                                </div>
                            </div>
                            <div class="img-box desktop">
                                <div class="img-wrap">
                                    <img src="images/lobby/dailypush-brand-002.jpg" alt="">
                                </div>
                            </div>
                        </div>
                        <div class="category-dailypush-cotentBox">
                            <div class="category-dailypush-cotent">
                                <h2 class="title language_replace">本日優選推薦</h2>
                                <div class="info">
                                    <h3 class="gamename language_replace">冰球突破豪華版</h3>
                                    <div class="detail">
                                        <span class="gamebrand">MG</span>
                                        <span class="gamecategory">BRAND</span>
                                    </div>
                                </div>
                                <div class="intro language_replace is-hide">
                                    遊戲介紹遊戲介紹遊戲介紹遊戲介紹遊戲介紹遊戲介紹遊戲介紹遊戲介紹遊戲介紹遊戲介紹遊戲介紹遊戲介紹
                                </div>
                                <div class="action">
                                    <button class="btn btn-play"><span class="language_replace">進入遊戲</span></button>
                                    <!-- 加入最愛 class=>added-->
                                    <button type="button" class="btn-like btn btn-round">
                                        <i class="icon icon-m-favorite"></i>
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>             
            </div>
        </section>--%>
         <section class="game-area overflow-hidden">
            <div id="gameAreas">
                 
            </div>           
        </section>
          <!-- 遊戲-排名區-新版 遊戲內容-->
         <section class="game-area overflow-hidden" style="display:none">
            <div class="container">
                <section class="section-wrap section-levelUp"> 
                    <div class="game_wrapper gameRanking">
                        <div class="sec-title-container">
                        <div class="sec-title-wrapper">
                            <h3 class="sec-title"><i class="icon icon-mask icon-star"></i><span class="">排名</span></h3>
                        </div>
                        </div>
                        <div class="game_slider swiper_container gameinfo-hover gameinfo-pack-bg round-arrow" id="idGameRanking">
                            <div class="swiper-wrapper">
                                <div class="swiper-slide">
                                    <div class="game-item">
                                        <div class="game-item-inner">
                                            <span class="game-item-mobile-popup" data-toggle="modal" data-target="#popupGameInfo"></span>
                                            <div class="game-item-focus">
                                                <div class="game-item-img">
                                                    <span class="game-item-link"></span>
                                                    <div class="img-wrap">
                                                        <img src=""  onerror="setDefaultIcon(this)"/>
                                                    </div>
                                                </div>
                                                <div class="game-item-info-detail open">
                                                    <div class="game-item-info-detail-wrapper">
                                                        <div class="game-item-info-detail-moreInfo">
                                                            <ul class="moreInfo-item-wrapper">
                                                                <!-- 判斷分類 加入class=> slot/live/etc/elec-->
                                                                <li class="moreInfo-item category slot">
                                                                    <span class="value"><i class="icon icon-mask"></i></span>
                                                                </li>
                                                                <li class="moreInfo-item brand">
                                                                    <span class="title">メーカー</span>
                                                                    <span class="value">PG</span>
                                                                </li>
                                                                <li class="moreInfo-item RTP">
                                                                    <span class="title">RTP</span>
                                                                    <span class="value number">96.66</span>
                                                                </li>
                                                                <li class="moreInfo-item gamecode">
                                                                    <span class="title">NO.</span>
                                                                    <span class="value number">00976</span>
                                                                </li>
                                                            </ul>
                                                        </div>
                                                        <div class="game-item-info-detail-indicator">
                                                            <div class="game-item-info-detail-indicator-inner">
                                                                <div class="info">
                                                                    <h3 class="game-item-name">バタフライブロッサム</h3>
                                                                </div>
                                                                <div class="action">
                                                                    <div class="btn-s-wrapper">
                                                                        <button type="button" class="btn-thumbUp btn btn-round is-hide">
                                                                            <i class="icon icon-m-thumup"></i>
                                                                        </button>                                                                       
                                                                        <button type="button" class="btn-like btn btn-round">
                                                                            <i class="icon icon-m-favorite"></i>
                                                                        </button>
                                                                        <!-- <button type="button" class="btn-more btn btn-round">
                                                                            <i class="arrow arrow-down"></i>
                                                                        </button> -->
                                                                    </div>
                                                                    <!-- <button type="button" class="btn btn-play">
                                                                        <span class="language_replace">プレイ</span><i class="triangle"></i></button> -->
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                            <!-- <div class="game-item-info">
                                                <div class="game-item-info-inner">
                                                    <h3 class="game-item-name">バタフライブロッサム</h3>
                                                </div>
                                            </div> -->
                                        </div>
                                    </div>
                                </div>                   
                            </div>
                            <div class="swiper-button-next"></div>
                            <div class="swiper-button-prev"></div>
                        </div>
                    </div>
            </section>
            </div> 
         </section>
         <!-- 遊戲-隨機推薦-->
        <%-- <section class="section-wrap section_randomRem" style="display:none;">
            <div class="container-fluid">
                <div class="game_wrapper">
                    <div class="sec-title-container">
                        <div class="sec-title-wrapper">
                            <!-- <h3 class="title">隨機推薦遊戲</h3> -->
                        </div>
                    </div>
                    <div class="game_slider swiper-container round-arrow swiper-cover GameItemGroup">
                        <div class="swiper-wrapper GameItemGroupContent">
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
                    </div>
                </div>
             </div>
        </section>--%>

    </main>

    <div id="temCategItem" class="is-hide">
        <li class="tab-item">
            <span class="tab-item-link"><i class="icon icon-mask CategIcon"></i>
                <span class="title language_replace CategName"></span></span>
        </li>
    </div>
 <%--   <div id="testdiv">
        <div class="container category-dailypush">
                                     <section class="section-category-dailypush" onclick="window.parent.openGame('BNG', '242','タイガー ジャングル')">
                 <div class="category-dailypush-wrapper hot">
                    <div class="category-dailypush-inner">
                        <div class="category-dailypush-img" style="background-color: #121a16;">
                            <div class="img-box mobile">
                                <div class="img-wrap">
                                    <img src="/images/lobby/dailypush-hot-M-001.jpg" alt="">
                                </div>
                            </div>
                            <div class="img-box pad">
                                <div class="img-wrap">
                                    <img src="/images/lobby/dailypush-hot-MD-001.jpg" alt="">
                                </div>
                            </div>
                            <div class="img-box desktop">
                                <div class="img-wrap">
                                    <img src="/images/lobby/dailypush-hot-001.jpg" alt="">
                                </div>
                            </div>
                        </div>
                        <div class="category-dailypush-cotentBox">
                            <div class="category-dailypush-cotent">
                                <h2 class="title language_replace">本日一押し厳選</h2>
                                <div class="info">
                                    <h3 class="gamename language_replace">タイガー ジャングル</h3>
                                    <div class="detail">
                                        <span class="gamebrand">ブーンゴー</span>
                                        <span class="gamecategory">スロット</span>
                                    </div>
                                </div>
                                <div class="intro language_replace is-hide">
                                    遊戲介紹遊戲介紹遊戲介紹遊戲介紹遊戲介紹遊戲介紹遊戲介紹遊戲介紹遊戲介紹遊戲介紹遊戲介紹遊戲介紹
                                </div>
                                <div class="action">
                                    <button class="btn btn-play" onclick="window.parent.openGame('BNG', '242','タイガー ジャングル')"><span class="language_replace">ゲームへ</span></button>
                                    <!-- 加入最愛 class=>added-->
                                    <button type="button" class="btn-like desktop gameCode_BNG.242 btn btn-round" onclick="favBtnClcik('BNG.242')">
                                        <i class="icon icon-m-favorite"></i>
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
         </section>
        </div>
    </div>
    <div id="testdiv2" class="container">
     <section class="section-wrap section-levelUp">
                                                <div class="game_wrapper">
                                                <div class="sec-title-container">
                                                <div class="sec-title-wrapper">
                                                <h3 class="sec-title"><i class="icon icon-mask icon-star"></i>
                                                    <span class="language_replace title CategName langkey">ジュラシック・パーク!モンスタースロット</span>
                                                </h3>
                                                </div>
                                                </div>
                                                <div class="game_slider swiper_container gameinfo-hover gameinfo-pack-bg round-arrow GameItemGroup0_GameList_Hot data-showtype=0 swiper-container-initialized swiper-container-horizontal swiper-container-pointer-events swiper-container-free-mode">
                                                <div class="swiper-wrapper GameItemGroupContent" aria-live="polite">
                                                <div class="swiper-slide gameid_3891 swiper-slide-active" role="group" aria-label="1 / 10">
                                                    <div class="swiper-slide gameid_6502"> <div class="game-item"><div class="game-item-inner"><div class="game-item-focus">    <div class="game-item-img">        <span class="game-item-link" onclick="window.parent.openGame('BBIN', '1204','ニンジャ マスター')" onmouseover="appendGameProp('BBIN','ニンジャ マスター','96.44','6502','BBIN.1204',1,'Slot','1204')"></span>        <div class="img-wrap">            <img class="gameimg lozad" src="https://ewin.dev.mts.idv.tw/Files/GamePlatformPic/BBIN/PC/JPN/1204.png"></div></div></div></div> </div></div>
                                                </div>
                                                </div>
                                                <div class="swiper-button-next" tabindex="0" role="button" aria-label="Next slide" aria-controls="swiper-wrapper-aa260d7b0a7e6195" aria-disabled="false"></div>
                                                <div class="swiper-button-prev swiper-button-disabled" tabindex="-1" role="button" aria-label="Previous slide" aria-controls="swiper-wrapper-aa260d7b0a7e6195" aria-disabled="true"></div>
                                                <span class="swiper-notification" aria-live="assertive" aria-atomic="true"></span></div>
                                                </div>
                                                </section>
    </div>

    <div id="testdiv3">
        <section class="section-wrap section_randomRem">
                                                    <div class="container">
                                                        <div class="game_wrapper">
                                                            <div class="sec-title-container">
                                                                <div class="sec-title-wrapper">
                                                                </div>
                                                            </div>
                                                            <div class="game_slider swiper_container round-arrow swiper-cover GameItemGroup1_GameList_Hot swiper-container-coverflow swiper-container-3d swiper-container-initialized swiper-container-horizontal swiper-container-pointer-events" style="cursor: grab;">
                                                                <div class="swiper-wrapper GameItemGroupContent" aria-live="polite" style="transition-duration: 0ms; transform: translate3d(-1470px, 0px, 0px);">
                                                                
                                                                <div class="swiper-slide gameid_849 swiper-slide-duplicate" style="transition-duration: 0ms; transform: translate3d(0px, 0px, -5700px) rotateX(0deg) rotateY(-380deg) scale(1); z-index: -18;">
                        <div class="game-item addedGameProp">
                            <div class="game-item-inner">
                                
                                    <span class="game-item-link" onclick="window.parent.openGame('PP', 'vswaysrhino','巨大なサイ Megaways')" onmouseover="appendGameProp('PP','巨大なサイ Megaways','96.58','849','PP.vswaysrhino',2,'Slot','vswaysrhino')"></span>
                                    <div class="img-wrap">
                                        <img class="gameimg lozad" src="https://ewin.dev.mts.idv.tw/Files/GamePlatformPic/PP/PC/JPN/vswaysrhino.png">
                                    </div>
                             </div>
                             <div class="game-item-info">
                               <h3 class="game-item-name">巨大なサイ Megaways</h3>
                             </div>
                           </div>
                        <div class="swiper-slide-shadow-left" style="opacity: 0; transition-duration: 0ms;"></div><div class="swiper-slide-shadow-right" style="opacity: 19; transition-duration: 0ms;"></div></div></div>
                                                            <span class="swiper-notification" aria-live="assertive" aria-atomic="true"></span></div>
                                                        </div>
                                                    </div>
                                                </section>
    </div>--%>
    <%--推薦遊戲--%>
    <div id="temCategArea2" class="is-hide">
        <section class="section-wrap section_randomRem">
            <div class="container-fluid">
                <div class="game_wrapper">
                    <div class="sec-title-container">
                        <div class="sec-title-wrapper">
                            <!-- <h3 class="title">隨機推薦遊戲</h3> -->
                        </div>
                    </div>
                    <div class="game_slider swiper_container round-arrow swiper-cover GameItemGroup">
                        <div class="swiper-wrapper GameItemGroupContent">
                        </div>
                    </div>
                </div>
             </div>
        </section>
    </div>
    <div id="temGameItem2" class="is-hide">
        <div class="swiper-slide">
            <div class="game-item">
                <div class="game-item-inner">
                    <span class="game-item-link"></span>
                    <div class="img-wrap">
                        <img class="gameimg lozad" src="" onerror="setDefaultIcon(this)">
                    </div>
                </div>
                <div class="game-item-info">
                    <h3 class="game-item-name"></h3>
                </div>
            </div>
        </div>
    </div>

    <div id="temCategArea3" class="is-hide">
         <section class="section-wrap section-levelUp"> 
                    <div class="game_wrapper gameRanking">
                        <div class="sec-title-container">
                        <div class="sec-title-wrapper">
                            <h3 class="sec-title"><i class="icon icon-mask icon-star"></i><span class="">排名</span></h3>
                        </div>
                        </div>
                        <div class="game_slider swiper_container gameinfo-hover gameinfo-pack-bg round-arrow">
                            <div class="swiper-wrapper">
                    
                            </div>
                            <div class="swiper-button-next"></div>
                            <div class="swiper-button-prev"></div>
                        </div>
                    </div>
            </section>
    </div>

    <div id="temGameItem3" class="is-hide">
         <div class="swiper-slide">
                                    <div class="game-item">
                                        <div class="game-item-inner">
                                            <span class="game-item-mobile-popup" data-toggle="modal"></span>
                                            <div class="game-item-focus">
                                                <div class="game-item-img">
                                                    <span class="game-item-link"></span>
                                                    <div class="img-wrap">
                                                        <img src="" onerror="setDefaultIcon(this)">
                                                    </div>
                                                </div>
                                                <div class="game-item-info-detail">
                                                    <div class="game-item-info-detail-wrapper">
                                                        <div class="game-item-info-detail-moreInfo">
                                                            <ul class="moreInfo-item-wrapper">
                                                                <li class="moreInfo-item brand">
                                                                    <span class="title">メーカー</span>
                                                                    <span class="value">PG</span>
                                                                </li>
                                                                <li class="moreInfo-item RTP">
                                                                    <span class="title">RTP</span>
                                                                    <span class="value number">96.66</span>
                                                                </li>
                                                                <li class="moreInfo-item gamecode">
                                                                    <span class="title">NO.</span>
                                                                    <span class="value number">00976</span>
                                                                </li>
                                                            </ul>
                                                        </div>
                                                        <div class="game-item-info-detail-indicator">
                                                            <div class="game-item-info-detail-indicator-inner">
                                                                <div class="info">
                                                                    <h3 class="game-item-name">バタフライブロッサム</h3>
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
                                            <!-- <div class="game-item-info">
                                                <div class="game-item-info-inner">
                                                    <h3 class="game-item-name">バタフライブロッサム</h3>
                                                </div>
                                            </div> -->
                                        </div>
                                    </div>
                                </div>
    </div>

     <%--banner--%>
    <div id="tmpBanner" class="is-hide">
        <div class="swiper-slide">
            <div class="hero-item">
                <a class="hero-item-link"></a>
                <div class="hero-item-box mobile Banner_M">
                    
                </div>
                <div class="hero-item-box desktop">
                    <div class="img-wrap  Banner_P">
                        
                    </div>
                </div>
            </div>
        </div>
    </div>
</body>
<script>
     // 遊戲排名 TEST
    // var GameRanking = new Swiper("#idGameRanking", {    
    //    slidesPerView: "auto",
    //    lazy: true,
    //    freeMode: true,
    //    navigation: {
    //        nextEl: "#idGameRanking .swiper-button-next",
    //        prevEl: "#idGameRanking .swiper-button-prev",
    //    },
    //    breakpoints: {
    //        936: {
    //                freeMode: false,
    //                slidesPerGroup: 6, //index:992px
    //            },
    //            1144: {
    //                slidesPerGroup: 7, //index:1200px
    //                allowTouchMove: false, //拖曳
    //            },
    //            1384: {
    //                slidesPerGroup: 7, //index:1440px
    //                allowTouchMove: false,
    //            },
    //            1544: {
    //                slidesPerGroup: 7, //index:1600px
    //                allowTouchMove: false,
    //            },
    //            1864: {
    //                slidesPerGroup: 8, //index:1920px
    //                allowTouchMove: false,
    //            },
    //            1920: {
    //                slidesPerGroup: 8, //index:1920px up
    //                allowTouchMove: false,
    //            },
    //    }

    //});

</script>
</html>

