<%@ Page Language="C#" %>

<%
    string Version = EWinWeb.Version;
    string MarqueeText = "";
    int RValue;
    string Token;
    string selectedCategory = "GameList_Hot";

    if (string.IsNullOrEmpty(Request["selectedCategory"]) == false)
    {
        selectedCategory = Request["selectedCategory"];
    }

    Random R = new Random();

    EWin.Lobby.APIResult Result;
    EWin.Lobby.LobbyAPI LobbyAPI = new EWin.Lobby.LobbyAPI();

    RValue = R.Next(100000, 9999999);
    Token = EWinWeb.CreateToken(EWinWeb.PrivateKey, EWinWeb.APIKey, RValue.ToString());
    Result = LobbyAPI.GetCompanyMarqueeText(Token, Guid.NewGuid().ToString());
    if (Result.Result == EWin.Lobby.enumResult.OK)
    {
        MarqueeText = Result.Message;
    }
%>
<!doctype html>
<html class="innerHtml">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Lucky Sprite</title>
    <link href="Scripts/vendor/swiper/css/swiper-bundle.min.css" rel="stylesheet" />
    <link href="css/basic.min.css" rel="stylesheet" />
    <link href="css/main.css" rel="stylesheet" />
    <link href="css/lobby.css" rel="stylesheet" />
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

        .game-item-info-detail {
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
    var Webinfo;
    var p;
    var lang;
    var v = "";
    var GCB;
    var selectedLocation = "<%=selectedCategory%>";
    var locationList = {
        GameList_Hot: {
            daliyData: {
                GameCode: "JL.74",
                GameBrand: "JL",
                MobileSrc: "/images/lobby/Mega Fishing-phone.jpg",
                PadSrc: "/images/lobby/Mega Fishing-pad.jpg",
                DesktopSrc: "/images/lobby/Mega Fishing-pc.jpg",
                BackgroundColor: "#192033"
            },
            dcDoms: [],
            dcDatas: null
        },
        GameList_Slot: {
            daliyData: {
                GameCode: "JL.49",
                GameBrand: "JL",
                MobileSrc: "/images/lobby/SuperAce-phone.jpg",
                PadSrc: "/images/lobby/SuperAce-pad.jpg",
                DesktopSrc: "/images/lobby/SuperAce-pc.jpg",
                BackgroundColor: "#8c1d0a"
            },
            dcDoms: [],
            dcDatas: null
        },
        GameList_Live: {
            daliyData: {
                GameCode: "EVO.CrazyTime0000001",
                GameBrand: "EVO",
                Location: "GameList_Live",
                MobileSrc: "/images/lobby/CrazyTime-phone.jpg",
                PadSrc: "/images/lobby/CrazyTime-pad.jpg",
                DesktopSrc: "/images/lobby/CrazyTime-pc.jpg",
                BackgroundColor: "#2d0503"
            },
            dcDoms: [],
            dcDatas: null
        },
        GameList_Brand: {
            daliyData: {
                GameCode: "EVO.CrazyTime0000001",
                GameBrand: "EVO",
                Location: "GameList_Live",
                MobileSrc: "/images/lobby/CrazyTime-phone.jpg",
                PadSrc: "/images/lobby/CrazyTime-pad.jpg",
                DesktopSrc: "/images/lobby/CrazyTime-pc.jpg",
                BackgroundColor: "#2d0503"
            },
            dcDoms: [],
            dcDatas: null
        },
        GameList_Other: {
            daliyData: {
                GameCode: "EVO.GonzoTH000000001",
                GameBrand: "EVO",
                MobileSrc: "/images/lobby/dailypush-favo-M-001.jpg",
                PadSrc: "/images/lobby/dailypush-favo-MD-001.jpg",
                DesktopSrc: "/images/lobby/dailypush-favo-001.jpg",
                BackgroundColor: "#352c1d"
            },
            dcDoms: [],
            dcDatas: null
        }
    };

    function showSearchGameModel() {
        window.parent.API_ShowSearchGameModel();
    }
    s
    function loginRecover() {
        window.location.href = "LoginRecover.aspx";
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
                if (showType != 2 && false) {
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

    function selLocation(location) {
        var domGameAreas = document.getElementById("gameAreas");
        selectedLocation = location;

        if (event) {
            $(event.target).addClass('active');
            $('#idGameItemTitle .active').removeClass('active');
        }

        setDailyGame(location);

        domGameAreas.innerHTML = "";
        domGameAreas.dataset.isfinished = "N";
        domGameAreas.dataset.loadcount = "0";
        domGameAreas.dataset.hidecount = "0";

        window.scrollTo(0, 0);

        scrollLoading();
    }

    function favBtnClcik(gameCode) {
        var btn = event.currentTarget;
        event.stopPropagation();

        if (WebInfo.UserLogined) {
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
            window.parent.showMessageOK(mlp.getLanguageKey("錯誤"), mlp.getLanguageKey("請先登入"), function () {
                window.parent.API_LoadPage("Login", "Login.aspx");
            }, null);
        }
    }

    function supplyCat() {
        if (domGameAreas.dataset.isfinished == "Y") {
            return;
        } else {
            loadedCount = Number(domGameAreas.dataset.loadcount);
            hideCount = Number(domGameAreas.dataset.hidecount);
        }

        loadedCount = Number(domGameAreas.dataset.loadcount);
        hideCount = Number(domGameAreas.dataset.hidecount);
    }

    function createBasicCatrgory(dcData, cb) {
        //建立Cat => 建立初始化GameCode =>init Swiper =>
        var dcDom = {
            Dom: null,
            Swiper: null,
            NeedHide: false
        };

        if (dcData.Datas.length > 0) {
            dcDom.Dom = c.getTemplate("temCategArea1");

            var catText = dcData.CategoryName.replace('@', '').replace('#', '');
            var catTextDom = dcDom.Dom.querySelector(".CategName");
            var gameItemsParentDom = dcDom.Dom.querySelector(".GameItemGroupContent");
            var PromisList = [];
            var IsHasDom = false;


            if (dcData.Location == "GameList_Brand") {
                var brandText = dcData.Datas.length > 0 ? dcData.Datas[0].GameCode.split(".")[0] : catText;

                if (WebInfo.DeviceType != 1) {
                    var showAllDom = dcDom.Dom.querySelector(".title-showAll");
                    showAllDom.innerText = mlp.getLanguageKey('全部顯示');
                    showAllDom.setAttribute("langkey", "全部顯示");
                    showAllDom.onclick = new Function("window.parent.API_SearchGameByBrand('" + brandText + "')");

                    dcDom.Dom.querySelector(".ShowAll").classList.remove("is-hide");
                }

                catTextDom.innerText = mlp.getLanguageKey(brandText)
                catTextDom.classList.add("language_replace");
                catTextDom.setAttribute("langkey", brandText);
                catTextDom.onclick = new Function("window.parent.API_SearchGameByBrand('" + brandText + "')");
            } else {
                catTextDom.innerText = catText;
            }

            dcData.Datas.forEach((x, index, array) => {
                var gameItemDom = c.getTemplate("temGameItem");
                var gameItemEventDom = gameItemDom.querySelector(".Event");
                gameItemDom.querySelector(".GameImg").src = WebInfo.ImageUrl + "/default.png";

                if (dcData.ShowType != 0) {
                    gameItemDom.querySelector(".InfoTag").classList.add("is-hide");
                }

                gameItemEventDom.onclick = new Function("clickGameItemEvent('" + dcData.showType + "','" + x.GameCode + "')");
                gameItemEventDom.onmouseover = new Function("mouseoverGameItemEvent('" + dcData.showType + "','" + x.GameCode + "')");
                gameItemsParentDom.appendChild(gameItemDom);

                PromisList.push(new Promise((resolve, reject) => {
                    GCB.GetByGameCode2(x.GameCode, function (gameItem) {
                        if (gameItem) {
                            var championData = checkChampionType(gameItem.ChampionType);
                            var gameItemTag = gameItemDom.querySelector(".game-item");

                            gameItemDom.querySelector(".GameImg").src = WebInfo.ImageUrl + "/" + gameItem.GameBrand + "/ENG/" + gameItem.GameName + ".png";
                            gameItemDom.querySelector(".GameName").innerText = getGameName(gameItem.Language);

                            if (championData.crownLevel) {
                                gameItemTag.classList.add(championData.crownLevel);
                            }

                            if (championData.championTypeStr) {
                                gameItemTag.classList.add(championData.championTypeStr);
                            }

                            if (gameItem.GameStatus == 0) {
                                IsHasDom = true;
                            } else {
                                gameItemDom.classList.add("is-hide");
                            }
                        } else {
                            gameItemDom.classList.add("is-hide");
                        }

                        resolve();
                    });
                }));
            });

            dcDom.Swiper = new Swiper(dcDom.Dom.querySelector('.swiper_container'), {
                slidesPerView: "auto",
                lazy: true,
                freeMode: true,
                allowTouchMove: WebInfo.DeviceType != 0,
                navigation: {
                    nextEl: dcDom.Dom.querySelector('.swiper-button-next'),
                    prevEl: dcDom.Dom.querySelector('.swiper-button-prev'),
                },
                slidesPerGroup: 6
            });

            Promise.all(PromisList).then((values) => {
                if (IsHasDom) {
                    dcDom.Swiper.update();
                } else {
                    dcDom.Dom.classList.add("is-hide");
                    dcDom.NeedHide = true;
                    supplyCat();
                }
            });
        } else {
            dcDom.NeedHide = true;
            supplyCat();
        }

        if (cb) {
            cb(dcDom);
        }
    };

    function createRandomCat(dcData, cb) {
        var dcDom = {
            Dom: null,
            Swiper: null,
            NeedHide: false
        };

        if (dcData.Datas.length > 0) {
            //有資料時，swiper的項目必須一開始就決定，不能事後修改
            dcDom.Dom = c.getTemplate("temCategArea3");

            var gameItemsParentDom = dcDom.Dom.querySelector(".GameItemGroupContent");
            var PromisList = [];
            var IsHasDom = false;

            dcData.Datas.forEach((x, index, array) => {
                PromisList.push(new Promise((resolve, reject) => {
                    GCB.GetByGameCode2(x.GameCode, function (gameItem) {
                        if (gameItem && gameItem.GameStatus == 0) {
                            var gameItemDom = c.getTemplate("temGameItem");
                            var gameItemEventDom = gameItemDom.querySelector(".Event");
                            var championData = checkChampionType(gameItem.ChampionType);
                            var gameItemTag = gameItemDom.querySelector(".game-item");

                            gameItemDom.querySelector(".GameImg").src = WebInfo.ImageUrl + "/default.png";
                            gameItemEventDom.onclick = new Function("clickGameItemEvent('" + dcData.showType + "','" + x.GameCode + "')");
                            gameItemEventDom.onmouseover = new Function("mouseoverGameItemEvent('" + dcData.showType + "','" + x.GameCode + "')");
                            gameItemDom.querySelector(".GameImg").src = WebInfo.ImageUrl + "/" + gameItem.GameBrand + "/ENG/" + gameItem.GameName + ".png";
                            gameItemDom.querySelector(".GameName").innerText = getGameName(gameItem.Language);

                            if (championData.crownLevel) {
                                gameItemTag.classList.add(championData.crownLevel);
                            }

                            if (championData.championTypeStr) {
                                gameItemTag.classList.add(championData.championTypeStr);
                            }

                            gameItemsParentDom.appendChild(gameItemDom);
                            IsHasDom = true;
                        }

                        resolve();

                        //最後一筆的額外處理
                        if ((index + 1) == array.length) {
                            //無法事後調整圖片，一次塞入完，在做swiper
                            if (IsHasDom) {

                            } else {
                                dcDom.NeedHide = true;
                            }

                            if (cb) {
                                cb(dcDom);
                            }
                        }
                    });
                }));
            });

            Promise.all(PromisList).then((values) => {
                if (IsHasDom) {
                    dcDom.Swiper = new Swiper(dcDom.Dom.querySelector('.swiper_container'), {
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
                } else {
                    dcDom.Dom.classList.add("is-hide");
                    dcDom.NeedHide = true;
                    supplyCat();
                }

                if (cb) {
                    cb(dcDom);
                }
            });
        } else {
            dcDom.NeedHide = true;
            supplyCat();

            if (cb) {
                cb(dcDom);
            }
        }
    }

    function createRankCat(dcData, cb) {
        var dcDom = {
            Dom: null,
            Swiper: null,
            NeedHide: false
        };

        if (dcData.Datas.length > 0) {
            //建置category
            dcDom.Dom = c.getTemplate("temCategArea2");

            var catText = dcData.CategoryName.replace('@', '').replace('#', '');
            var catTextDom = dcDom.Dom.querySelector(".CategName");
            var gameItemsParentDom = dcDom.Dom.querySelector(".GameItemGroupContent");
            var PromisList = [];
            var IsHasDom = false;

            if (dcData.Location == "GameList_Brand") {
                var brandText = dcData.Datas.length > 0 ? dcData.Datas[0].GameCode.split(".")[0] : catText;

                if (WebInfo.DeviceType != 1) {
                    var showAllDom = dcDom.Dom.querySelector(".title-showAll");
                    showAllDom.innerText = mlp.getLanguageKey('全部顯示');
                    showAllDom.setAttribute("langkey", "全部顯示");
                    showAllDom.onclick = new Function("window.parent.API_SearchGameByBrand('" + brandText + "')");

                    dcDom.Dom.querySelector(".ShowAll").classList.remove("is-hide");
                }

                catTextDom.innerText = mlp.getLanguageKey(brandText)
                catTextDom.classList.add("language_replace");
                catTextDom.setAttribute("langkey", brandText);
                catTextDom.onclick = new Function("window.parent.API_SearchGameByBrand('" + brandText + "')");
            } else {
                catTextDom.innerText = catText;
            }

            var gameItemsParentDom = dcDom.Dom.querySelector(".GameItemGroupContent");

            dcData.Datas.forEach((x, index, array) => {
                var gameItemDom = c.getTemplate("temGameItem");
                var gameItemEventDom = gameItemDom.querySelector(".Event");

                gameItemDom.querySelector(".GameImg").src = WebInfo.ImageUrl + "/default.png";

                if (dcData.ShowType != 0) {
                    gameItemDom.querySelector(".InfoTag").classList.add("is-hide");
                }

                gameItemEventDom.onclick = new Function("clickGameItemEvent('" + dcData.showType + "','" + x.GameCode + "')");
                gameItemEventDom.onmouseover = new Function("mouseoverGameItemEvent('" + dcData.showType + "','" + x.GameCode + "')");
                gameItemsParentDom.appendChild(gameItemDom);

                PromisList.push(new Promise((resolve, reject) => {
                    GCB.GetByGameCode2(x.GameCode, function (gameItem) {
                        if (gameItem) {
                            var championData = checkChampionType(gameItem.ChampionType);
                            var gameItemTag = gameItemDom.querySelector(".game-item");

                            gameItemDom.querySelector(".GameImg").src = WebInfo.ImageUrl + "/" + gameItem.GameBrand + "/ENG/" + gameItem.GameName + ".png";
                            gameItemDom.querySelector(".GameName").innerText = getGameName(gameItem.Language);

                            if (championData.crownLevel) {
                                gameItemTag.classList.add(championData.crownLevel);
                            }

                            if (championData.championTypeStr) {
                                gameItemTag.classList.add(championData.championTypeStr);
                            }

                            if (gameItem.GameStatus == 0) {
                                IsHasDom = true;
                            } else {
                                gameItemDom.classList.add("is-hide");
                            }
                        } else {
                            gameItemDom.classList.add("is-hide");
                        }

                        resolve();
                    });
                }));
            });

            dcDom.Swiper = new Swiper(dcDom.Dom.querySelector('.swiper_container'), {
                slidesPerView: "auto",
                lazy: true,
                freeMode: true,
                allowTouchMove: WebInfo.DeviceType != 0,
                navigation: {
                    nextEl: dcDom.Dom.querySelector('.swiper-button-next'),
                    prevEl: dcDom.Dom.querySelector('.swiper-button-prev'),
                },
                slidesPerGroup: 6              
            });

            Promise.all(PromisList).then((values) => {
                if (IsHasDom) {
                    dcDom.Swiper.update();
                } else {
                    dcDom.Dom.classList.add("is-hide");
                    dcDom.NeedHide = true;
                    supplyCat();
                }
            });
        } else {
            dcDom.NeedHide = true;
            supplyCat();
        }


        if (cb) {
            cb(dcDom);
        }
    }

    //#region GameItem
    function getGameName(languageDatas) {
        var langData = languageDatas.find(x => x.LanguageCode == lang);

        if (langData) {
            return langData.DisplayText;
        } else {
            return "";
        }
    }

    function getRTP(rtpInfo) {
        var RTP = "";
        if (rtpInfo) {
            var RtpInfoObj = JSON.parse(rtpInfo);

            if (RtpInfoObj.RTP && RtpInfoObj.RTP != 0) {
                RTP = RtpInfoObj.RTP.toString();
            } else {
                RTP = '--';
            }
        } else {
            RTP = '--';
        }

        return RTP;
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
            crownLevel: ""
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
            else if (count == 3) { date.crownLevel = "crownLevel-3"; date.championTypeStr = ""; }
        }


        return date;
    }

    function mouseoverGameItemEvent(showType, gameCode) {
        GCB.GetByGameCode(gameCode, (gameItem) => {
            appendGameProp()
        })
    }

    function clickGameItemEvent(showType, gameCode) {

    }

    //#endregion

    function setDailyGame(Location) {
        var headerGame = locationList[Location];
        if (headerGame) {
            var daliyData = headerGame.daliyData;

            GCB.GetByGameCode(daliyData.GameCode, (gameItem) => {
                var targetDom = document.getElementById("idDailyPush");
                var tempDom;
                var gameName = getGameName(gameItem.Language);
                var championData = checkChampionType(gameItem.ChampionType);
                var type;
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

                targetDom.classList.remove(targetDom.dataset.topcat);
                targetDom.querySelector(".dImg").src = daliyData.DesktopSrc;
                targetDom.querySelector(".pImg").src = daliyData.PadSrc;
                targetDom.querySelector(".mImg").src = daliyData.MobileSrc;
                targetDom.querySelector(".category-dailypush-img").setAttribute("style", "background-color:" + daliyData.BackgroundColor);

                tempDom = targetDom.querySelector(".category-dailypush-wrapper");
                tempDom.classList.add(type);

                if (championData.crownLevel)
                    tempDom.classList.add(championData.crownLevel);

                if (championData.championTypeStr)
                    tempDom.classList.add(championData.championTypeStr);


                tempDom = targetDom.querySelector(".gamename");
                tempDom.innerText = gameName;
                tempDom.classList.add("GameLang");
                tempDom.dataset.gamecode = gameItem.GameCode;

                tempDom = targetDom.querySelector(".gamebrand");
                tempDom.innerText = mlp.getLanguageKey(gameItem.GameBrand);
                tempDom.setAttribute("langkey", gameItem.GameBrand);

                tempDom = targetDom.querySelector(".gamecategory");
                tempDom.innerText = mlp.getLanguageKey(gameItem.GameCategoryCode);
                tempDom.setAttribute("langkey", gameItem.GameCategoryCode);

                if (WebInfo.DeviceType == 1) {
                    tempDom = targetDom.querySelector(".btn-like");
                    tempDom.onclick = new Function("favBtnClcik('" + gameItem.GameCode + "')")
                    tempDom.classList.add("fav_" + gameItem.GameCode);
                    tempDom.classList.remove("desktop");

                    if (gameItem.FavoTimeStamp != null) {
                        tempDom.classList.add("added");
                    } else {
                        tempDom.classList.remove("added");
                    }

                    targetDom.onclick = new Function("clickGameItemEvent(1,'" + gameItem.GameCode + "')");

                    targetDom.querySelector(".btn-play").onclick = new Function("clickGameItemEvent(1,'" + gameItem.GameCode + "')");
                } else {
                    tempDom = targetDom.querySelector(".btn-like");
                    tempDom.onclick = new Function("favBtnClcik('" + gameItem.GameCode + "')");
                    tempDom.classList.add("fav_" + gameItem.GameCode);
                    tempDom.classList.add("desktop");

                    if (gameItem.FavoTimeStamp != null) {
                        tempDom.classList.add("added");
                    } else {
                        tempDom.classList.remove("added");
                    }

                    targetDom.onclick = new Function("clickGameItemEvent(1,'" + gameItem.GameCode + "')");

                    targetDom.querySelector(".btn-play").onclick = new Function("clickGameItemEvent(1,'" + gameItem.GameCode + "')");
                }

            });
        }
    }

    function scrollLoading() {
        var domGameAreas = document.getElementById("gameAreas");
        //上方基準高度=area所在之y相對位置 + scrollY - header;
        var itemHeight = 150;
        var minusHeight = -1 * (domGameAreas.getBoundingClientRect().y - 60) + itemHeight * 3;
        var basicCount = 4;
        var targetCount = 0;
        var loadedCount = 0;
        var hideCount = 0;
        var startIndex = 0;
        var endIndexLimit = 0;
        var locationData = null;

        locationData = locationList[selectedLocation];

        if (domGameAreas.dataset.isfinished == "Y") {
            return;
        } else {
            loadedCount = Number(domGameAreas.dataset.loadcount);
            hideCount = Number(domGameAreas.dataset.hidecount);
        }



        if (minusHeight > 0) {
            targetCount = parseInt(minusHeight / itemHeight) + basicCount;
        } else {
            targetCount = basicCount;
        }

        if (targetCount > locationData.dcDatas.length) {
            targetCount = locationData.dcDatas.length;
        }

        if (loadedCount >= targetCount + hidecount) {
            return;
        }

        domGameAreas.dataset.isfinished = (targetCount + hidecount) == locationData.dcDatas.length ? "Y" : "N";
        domGameAreas.dataset.loadcount = targetCount + hidecount;

        startIndex =  loadedCount;
        endIndexLimit = targetCount + hideCount;

        for (var i = startIndex; i < endIndexLimit; i++) {
            if (i < locationData.dcDoms.length) {
                if (locationData.dcDoms[i].Dom) {
                    domGameAreas.appendChild(locationData.dcDoms[i].Dom);
                } else {
                    //如果Dom物件為，表示為不需要加入的項目
                    supplyCat();
                }
            } else {
                //緩存dom未找到該項目，從頭建立
                var cb = function (dc) {
                    domGameAreas.appendChild(dc.Dom);
                    locationData.dcDoms.push(dc);
                    dc.Swiper.update();
                };


                switch (locationData.dcDatas[i].ShowType) {
                    case 0:
                        createBasicCatrgory(locationData.dcDatas[i], cb);
                        break;
                    case 1:
                        createRankCat(locationData.dcDatas[i], cb);
                        break;
                    case 2:
                        createRandomCat(locationData.dcDatas[i], cb);
                        break;                 
                }            
            }
        }

    }

    function doHideCatDom() {
        //如果有項目被隱藏時的補位處理
    }

    function initBanner() {
        var bannerList = [
            "CasinoBanner1",
            "CasinoBanner2",
            "CasinoBanner3",
            "CasinoBanner4",
            "CasinoBanner5",
        ];

        var appendHtmlStr = "";
        var deviceStr = WebInfo.DeviceType_B == 1 ? "casinobanner_m" : "casinobanner_p";
        for (var i = 0; i < bannerList.length; i++) {

            appendHtmlStr += `<div class="swiper-slide">
                        <div class="hero-item">
                            <div class="hero-item-box desktop ${deviceStr}" >
                                <div class="img-wrap">
                                    <img src="images/casinobanner/${(bannerList[i] + (WebInfo.DeviceType_B == 1 ? "_M" : "_P"))}.jpg" class="bg" />
                                </div>
                            </div>
                        </div>
                    </div>`;
        }

        $("#divBanner").append(appendHtmlStr);

        new Swiper("#hero-slider-lobby", {
            loop: true,
            // slidesPerView: 1,
            slidesPerView: "auto",
            centeredSlides: true,
            // freeMode: true,
            // spaceBetween: 20,  
            speed: 1000, //Duration of transition between slides (in ms)
            // autoplay: {
            //     delay: 3500,
            //     disableOnInteraction: false,
            // },
            pagination: {
                el: ".swiper-pagination",
                clickable: true,
            },

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

        mlp = new multiLanguage(v);
        mlp.loadLanguage(lang, function () {
            if (p != null) {
                //getBanner();
                initBanner();
                getCategory(x => {
                    if (selectedLocation) {
                        selectedLocation = "GameList_Hot";
                    }

                    selLocation(selectedLocation);
                });

                window.parent.API_LoadingEnd();
            } else {
                window.parent.showMessageOK(mlp.getLanguageKey("錯誤"), mlp.getLanguageKey("網路錯誤"), function () {
                    window.parent.location.href = "index.aspx";
                });
            }
        });
    }

    function getCategory(cb) {
        p.GetCompanyGameCodeThree(Math.uuid(), "GameList", function (success, o) {
            if (success) {
                if (o.Result == 0) {
                    if (o.LobbyGameList.length > 0) {
                        for (var i = 0; i < o.LobbyGameList.length; i++) {
                            var locationData = locationList[o.LobbyGameList[i].Location];

                            if (locationData) {
                                locationData.dcDatas = o.LobbyGameList[i].Categories.sort(function (a, b) {
                                    return b.SortIndex - a.SortIndex;
                                });

                                locationData.dcDatas.forEach(x => x.Datas.sort(function (a, b) {
                                    return b.SortIndex - a.SortIndex;
                                }));

                                var test = 0
                                while (test < 3) {
                                    o.LobbyGameList[i].Categories.forEach(x => locationData.dcDatas.push(x));

                                    test++;
                                }
                            }
                        }

                        if (cb) {
                            cb();
                        }
                    }
                }
            }
        });
    }

    function setDefaultIcon(e) {
        e.onerror = null;
        e.src = "images/icon/GameDefault.png";
    }

    function showDefauktGameIcon(GameBrand, GameName) {
        var el = event.target;
        el.onerror = showDefauktGameIcon2;
        el.src = WebInfo.ImageUrl + "/" + GameBrand + "/ENG/" + GameName + ".png";
    }

    function showDefauktGameIcon2() {

        var el = event.target;
        if (el.src.includes("PG")) {
            el.onerror = null;
            el.src = el.src.replace("PG", "PG2");
        } else if (el.src.includes("MG")) {
            el.onerror = null;
            el.src = el.src.replace("MG", "MG2");
        } else {
            el.onerror = null;
            el.src = WebInfo.ImageUrl + "/default.png";
        }
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
                //    resetCategory(selectedLocation);
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
                    //getBanner();
                    window.parent.API_LoadingEnd(1);
                    resetCategory(selectedLocation);
                });
            case "GameLoadEnd":
                //if (!initCreatedGameList) {                                     
                //updateGameList();
                //}

                break;
        }
    }

    window.onload = init;
    window.onscroll = scrollLoading;

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
                    <img src="images/icon/ico-search-dog-tt.png?a=1" alt=""><span class="title language_replace">找遊戲</span>
                </div>
                <div class="tab-scroller tab-6">
                    <div class="tab-scroller__area">
                        <ul class="tab-scroller__content" id="idGameItemTitle">
                            <li class="tab-item active" onclick="selLocation('GameList_Hot')">
                                <span class="tab-item-link"><i class="icon icon-mask icon-hot"></i>
                                    <span class="title language_replace CategName">GameList_Hot</span></span>
                            </li>
                            <li class="tab-item" onclick="selLocation('GameList_Slot')">
                                <span class="tab-item-link"><i class="icon icon-mask icon-slot"></i>
                                    <span class="title language_replace CategName">GameList_Slot</span></span>
                            </li>
                            <li class="tab-item" onclick="selLocation('GameList_Live')">
                                <span class="tab-item-link"><i class="icon icon-mask icon-live"></i>
                                    <span class="title language_replace CategName">GameList_Live</span></span>
                            </li>
                            <li class="tab-item" onclick="selLocation('GameList_Other')">
                                <span class="tab-item-link"><i class="icon icon-mask icon-etc"></i>
                                    <span class="title language_replace CategName">GameList_Other</span></span>
                            </li>
                            <li class="tab-item" onclick="selLocation('GameList_Brand')">
                                <span class="tab-item-link"><i class="icon icon-mask icon-brand"></i>
                                    <span class="title language_replace CategName">GameList_Brand</span></span>
                            </li>
                            <div class="tab-slide"></div>
                        </ul>
                    </div>
                </div>
            </div>
        </div>

        <!-- 跑馬燈 -->
        <%-- --%>
        <div class="container marquee">
            <div class="marquee_bock">
                <div class="marquee_title">
                    <i class="icon icon-mask icon-announce"></i>
                </div>
                <marquee class="marquee-content" direction="left" scrollamount="3" scrolldelay="100" behavior="scroll" hover="true" onmouseover="this.stop()" onmouseout="this.start()">
                    <a class="marquee-item" data-remote="true" href="#"><%=MarqueeText %></a>
                </marquee>
            </div>
        </div>

        <!-- 各分類-單一遊戲推薦區 -->
        <section id="idDailyPush" class="section-category-dailypush">
            <div class="container">
                <!-- hot -->
                <div class="category-dailypush-wrapper hot" data-topcat="hot">
                    <div class="category-dailypush-inner">
                        <div class="category-dailypush-img" style="background-color: #121a16;">
                            <div class="img-box mobile">
                                <div class="img-wrap">
                                    <img class="mImg" src="" alt="">
                                </div>
                            </div>
                            <div class="img-box pad">
                                <div class="img-wrap">
                                    <img class="pImg" src="" alt="">
                                </div>
                            </div>
                            <div class="img-box desktop">
                                <div class="img-wrap">
                                    <img class="dImg" src="" alt="">
                                </div>
                            </div>
                        </div>
                        <div class="category-dailypush-cotentBox">
                            <div class="category-dailypush-cotent">
                                <h2 class="title language_replace">本日優選推薦</h2>
                                <div class="info">
                                    <h3 class="gamename language_replace">叢林之王-集鴻運</h3>
                                    <div class="detail">
                                        <span class="language_replace gamebrand">BNG</span>
                                        <span class="language_replace gamecategory">HOT</span>
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
        </section>
        <section class="game-area overflow-hidden">
            <div class="container" id="gameAreas">
            </div>
        </section>
    </main>


    <%--推薦遊戲--%>
    <template id="temCategArea1">
        <section class="section-wrap section-levelUp">
            <div class="game_wrapper">
                <div class="sec-title-container">
                    <div class="sec-title-wrapper">
                        <h3 class="sec-title"><i class="icon icon-mask icon-star"></i>
                            <span class="language_replace title CategName"></span>
                        </h3>
                    </div>
                    <a class="text-link is-hide ShowAll">
                        <span class="language_replace title-showAll">All</span><i class="icon arrow arrow-right"></i>
                    </a>
                </div>
                <div class="game_slider swiper_container gameinfo-hover gameinfo-pack-bg round-arrow">
                    <div class="swiper-wrapper GameItemGroupContent">
                    </div>
                    <div class="swiper-button-next"></div>
                    <div class="swiper-button-prev"></div>
                </div>
            </div>
        </section>
    </template>

    <template id="temCategArea2">
        <section class="section-wrap gameRanking">
            <div class="game_wrapper">
                <div class="sec-title-container">
                    <div class="sec-title-wrapper">
                        <h3 class="sec-title"><i class="icon icon-mask icon-star"></i><span class="CategName"></span></h3>
                    </div>
                    <a class="text-link is-hide ShowAll">
                        <span class="title-showAll language_replace">All</span><i class="icon arrow arrow-right"></i>
                    </a>
                </div>
                <div class="game_slider swiper_container gameinfo-hover gameinfo-pack-bg round-arrow">
                    <div class="swiper-wrapper GameItemGroupContent">
                    </div>
                    <div class="swiper-button-next"></div>
                    <div class="swiper-button-prev"></div>
                </div>
            </div>
        </section>
    </template>

    <template id="temCategArea3">
        <section class="section-wrap section_randomRem">
            <div class="container">
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
    </template>

    <template id="temGameItem">
        <div class="swiper-slide">
            <div class="game-item">
                <div class="game-item-inner">
                    <div class="game-item-focus">
                        <span class="game-item-link Event"></span>
                        <div class="img-wrap">
                            <img class="GameImg" src="">
                        </div>
                    </div>
                </div>
                <div class="game-item-info InfoTag">
                    <h3 class="game-item-name GameName"></h3>
                </div>
            </div>
        </div>
    </template>

    <template id="tmpBanner">
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
    </template>

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

