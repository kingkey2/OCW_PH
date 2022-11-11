<%@ Page Language="C#" %>

<%
    string Version = EWinWeb.Version;
%>

<!doctype html>
<html lang="zh-Hant-TW" class="innerHtml">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <title>Lucky Sprite</title>
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
    <script src="https://cdnjs.cloudflare.com/ajax/libs/bignumber.js/9.0.2/bignumber.min.js"></script>
    <script type="text/javascript" src="/Scripts/Math.uuid.js"></script>
    <script type="text/javascript" src="/Scripts/date.js"></script>
    <script type="text/javascript" src="Scripts/DateExtension.js"></script>
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
    var search_Year;
    var search_Month;

    function init() {
        if (self == top) {
            window.parent.location.href = "index.aspx";
        }

        WebInfo = window.parent.API_GetWebInfo();
        LobbyClient = window.parent.API_GetLobbyAPI();
        lang = window.parent.API_GetLang();
        mlp = new multiLanguage(v);

        mlp.loadLanguage(lang, function () {
            window.parent.API_LoadingEnd();

            if (LobbyClient != null) {
                //可領取獎金
                GetPromotionCollectAvailable(2);
                //領取紀錄
                let now_date = Date.today().moveToFirstDayOfMonth().toString("yyyy/MM/dd");
                search_Year = now_date.split('/')[0];
                search_Month = now_date.split('/')[1];

                let beginDate = Date.today().moveToFirstDayOfMonth().toString("yyyy/MM/dd");
                let endDate = Date.today().moveToLastDayOfMonth().toString("yyyy/MM/dd");

                GetPromotionCollectHistory(beginDate, endDate);

            } else {
                window.parent.showMessageOK(mlp.getLanguageKey("錯誤"), mlp.getLanguageKey("網路錯誤"), function () {
                    window.parent.location.href = "index.aspx";
                });
            }
        });
    }

    function GetPromotionCollectHistory(BeginDate, EndDate) {
        var ParentMain = document.getElementById("div_History");
        ParentMain.innerHTML = "";
        document.getElementById("idSearchDate_P").innerText = new Date(EndDate).toString("yyyy/MM");
        
        LobbyClient.GetPromotionCollectHistory(WebInfo.SID, Math.uuid(), BeginDate, EndDate, function (success, o) {
            if (success) {
                if (o.Result == 0) {
                    if (o.CollectList.length > 0) {
                        for (var i = 0; i < o.CollectList.length; i++) {
                            var collect = o.CollectList[i];
                            var collectDate = Date.parse(collect.CollectDate);
                            var rowDom = c.getTemplate("IDHistoryRow");

                            rowDom.querySelector(".year").innerText = collectDate.toString("yyyy");
                            rowDom.querySelector(".month").innerText = collectDate.toString("MM");
                            rowDom.querySelector(".day").innerText = collectDate.toString("dd");

                            rowDom.querySelector(".value").innerText = new BigNumber(collect.PointValue).toFormat();
                            rowDom.querySelector(".title").innerText = collect.PromotionTitle;

                            ParentMain.appendChild(rowDom);
                        }

                        if ($("#div_History").children().length == 0) {
                            $(ParentMain).append(`<div class="no-Data"><div class="data"><span class="text language_replace">${mlp.getLanguageKey('沒有資料')}</span></div></div>`);
                            // $("#div_History").height(50);
                        }

                        window.parent.API_CloseLoading();
                    } else {
                        $(ParentMain).append(`<div class="no-Data"><div class="data"><span class="text language_replace">${mlp.getLanguageKey('沒有資料')}</span></div></div>`);
                        // $("#div_History").height(50);
                        window.parent.API_CloseLoading();
                    }
                } else {
                    $(ParentMain).append(`<div class="no-Data"><div class="data"><span class="text language_replace">${mlp.getLanguageKey('沒有資料')}</span></div></div>`);
                    // $("#div_History").height(50);
                    //window.parent.API_ShowMessageOK(mlp.getLanguageKey("錯誤"), mlp.getLanguageKey(o.Message));
                    window.parent.API_CloseLoading();
                }
            } else {
                if (o == "Timeout") {
                    window.parent.API_ShowMessageOK(mlp.getLanguageKey("錯誤"), mlp.getLanguageKey("網路異常, 請重新嘗試"));
                    window.parent.API_CloseLoading();
                } else {
                    window.parent.API_ShowMessageOK(mlp.getLanguageKey("錯誤"), o);
                    window.parent.API_CloseLoading();
                }
            }
        });

    }

    function GetPromotionCollectAvailable(collectareatype) {
        window.parent.API_ShowLoading();
        var ParentMain = document.getElementById("div_Prize");
        ParentMain.innerHTML = "";
        $(".tab-scroller__content").find(".tab-item").removeClass("active");
        $("#li_bonus" + collectareatype).addClass("active");
        let wallet = WebInfo.UserInfo.WalletList.find(x => x.CurrencyType.toLocaleUpperCase() == WebInfo.MainCurrencyType);
 
        //CollectAreaType
        // 1 (獎金 bonus) => i.   本金歸零時可領 
        //                                    ii.   出金時歸零
        //                                   iii.   EX:入金贈點
        // 2 (禮金 gift) =>       i.   隨時可領
        //                                    ii.   出金時不歸零
        //                                   iii.   EX:註冊贈點、7日

        LobbyClient.GetPromotionCollectAvailable(WebInfo.SID, Math.uuid(), function (success, o) {
            if (success) {
                if (o.Result == 0) {
                    if (o.CollectList.length > 0) {
                            let RecordDom;
                        for (var i = 0; i < o.CollectList.length; i++) {
                            let Collect = o.CollectList[i];
                            let collectAreaType = Collect.CollectAreaType;

                            if (collectAreaType == collectareatype) {
                                let CreateDate = Date.parse(Collect.CreateDate);
                                let ExpireDate = Date.parse(Collect.ExpireDate);
                                let PointValue = Collect.PointValue;

                                RecordDom = c.getTemplate("tmpPrize0");

                                let DomBtn = RecordDom.querySelector(".bouns-get");

                                c.setClassText(RecordDom, "year_c", null, CreateDate.toString("yyyy"));
                                c.setClassText(RecordDom, "month_c", null, CreateDate.toString("MM"));
                                c.setClassText(RecordDom, "day_c", null, CreateDate.toString("dd"));
                                if (ExpireDate) {
                                    c.setClassText(RecordDom, "year_e", null, ExpireDate.toString("yyyy"));
                                    c.setClassText(RecordDom, "month_e", null, ExpireDate.toString("MM"));
                                    c.setClassText(RecordDom, "day_e", null, ExpireDate.toString("dd"));
                                } else {
                                    let k = CreateDate.getFullYear() + 1;
                                    c.setClassText(RecordDom, "year_e", null, k);
                                    c.setClassText(RecordDom, "month_e", null, CreateDate.toString("MM"));
                                    c.setClassText(RecordDom, "day_e", null, CreateDate.toString("dd"));
                                }
                                c.setClassText(RecordDom, "title", null, Collect.PromotionTitle);
                                c.setClassText(RecordDom, "pointval", null, PointValue);
                                $(RecordDom).attr("data-collectid", Collect.CollectID);
                                $(RecordDom).attr("data-val", PointValue);

                                DomBtn.onclick = function (e) {
                                    let CollectID = $(e.target).closest(".prize-item").data("collectid");
                                    let val = new BigNumber($(e.target).closest(".prize-item").data("val")).toFormat();

                                    window.parent.API_ShowMessage(mlp.getLanguageKey("確認"), val + mlp.getLanguageKey(" 確認領取"), function () {
                                        LobbyClient.CollectUserAccountPromotion(WebInfo.SID, Math.uuid(), CollectID, function (success, o) {
                                            if (success) {
                                                if (o.Result == 0) {
                                                    //window.parent.API_ShowMessageOK(mlp.getLanguageKey("確認"), mlp.getLanguageKey("領取成功"), function () {
                                                    GetPromotionCollectAvailable(collectareatype);

                                                    window.top.API_RefreshUserInfo(function () {
                                                    });

                                                    let now_date = Date.today().moveToFirstDayOfMonth().toString("yyyy/MM/dd");
                                                    search_Year = now_date.split('/')[0];
                                                    search_Month = now_date.split('/')[1];

                                                    let beginDate = Date.today().moveToFirstDayOfMonth().toString("yyyy/MM/dd");
                                                    let endDate = Date.today().moveToLastDayOfMonth().toString("yyyy/MM/dd");

                                                    GetPromotionCollectHistory(beginDate, endDate);
                                                    //});
                                                } else {
                                                    //window.parent.API_ShowMessageOK(mlp.getLanguageKey("錯誤"), mlp.getLanguageKey(o.Message));
                                                    alert(mlp.getLanguageKey(o.Message));
                                                }
                                            } else {
                                                if (o == "Timeout") {
                                                    window.parent.API_ShowMessageOK(mlp.getLanguageKey("錯誤"), mlp.getLanguageKey("網路異常, 請重新嘗試"));
                                                } else {
                                                    window.parent.API_ShowMessageOK(mlp.getLanguageKey("錯誤"), mlp.getLanguageKey(o));
                                                }
                                            }
                                        })
                                    });
                                };

                                ParentMain.appendChild(RecordDom);
                            }
                        }

                        //新增當週期7日登入可領取的禮物箱
                        if (collectareatype == 2) {

                            window.top.API_GetUserThisWeekTotalValidBetValue(function (e) {
                                let PointValue = 0;
                                if (e) {
                                    let k = 0;
                                    for (var i = 0; i < e.length; i++) {
                                        if (e[i].Status == 1) {
                                            k++;
                                        }
                                    }

                                    if (k == 7) {
                                        PointValue = 10000;
                                    } else {
                                        PointValue = k * 1000;
                                    }

                                    if (PointValue > 0) {
                                        RecordDom = c.getTemplate("tmpPrize1");
                                        let ExpireDate = Date.parse(e[e.length - 1].Date).addDays(1);

                                        c.setClassText(RecordDom, "year_c", null, ExpireDate.toString("yyyy"));
                                        c.setClassText(RecordDom, "month_c", null, ExpireDate.toString("MM"));
                                        c.setClassText(RecordDom, "day_c", null, ExpireDate.toString("dd") + "~");
                                        c.setClassText(RecordDom, "title", null, "金曜日のプレゼント");
                                        c.setClassText(RecordDom, "pointval", null, PointValue);

                                        $(RecordDom).find(".date-period-end").hide();
                                        $(RecordDom).find(".prize-status").hide();

                                        ParentMain.prepend(RecordDom);
                                    }
                                }
                            });
                        }
                        
                        if ($("#div_Prize").children().length == 0) {
                            $(ParentMain).append(`<div class="no-Data"><div class="data"><span class="text language_replace">${mlp.getLanguageKey('沒有資料')}</span></div></div>`);
                        }
                        window.parent.API_CloseLoading();
                    } else {
                        $(ParentMain).append(`<div class="no-Data"><div class="data"><span class="text language_replace">${mlp.getLanguageKey('沒有資料')}</span></div></div>`);
                        window.parent.API_CloseLoading();
                    }
                } else {
                    $(ParentMain).append(`<div class="no-Data"><div class="data"><span class="text language_replace">${mlp.getLanguageKey('沒有資料')}</span></div></div>`);
                    //window.parent.API_ShowMessageOK(mlp.getLanguageKey("錯誤"), mlp.getLanguageKey(o.Message));
                    window.parent.API_CloseLoading();
                }
            } else {
                if (o == "Timeout") {
                    window.parent.API_ShowMessageOK(mlp.getLanguageKey("錯誤"), mlp.getLanguageKey("網路異常, 請重新嘗試"));
                    window.parent.API_CloseLoading();
                } else {
                    window.parent.API_ShowMessageOK(mlp.getLanguageKey("錯誤"), o);
                    window.parent.API_CloseLoading();
                }
            }
        });

    }

    function getLastDate(y, m) {
        var lastDay = new Date(y, m, 0);
        var year = lastDay.getFullYear();
        var month = lastDay.getMonth() + 1;
        month = month < 10 ? '0' + month : month;
        var day = lastDay.getDate();
        day = day < 10 ? '0' + day : day;

        return day;
    }

    function getPreMonth() {
        window.parent.API_ShowLoading();

        let newSearchDate = new Date(search_Year + "/" + search_Month + "/01").addMonths(-1);

        search_Year = newSearchDate.toString("yyyy/MM/dd").split('/')[0];
        search_Month = newSearchDate.toString("yyyy/MM/dd").split('/')[1];

        let beginDate = newSearchDate.moveToFirstDayOfMonth().toString("yyyy/MM/dd");
        let endDate = newSearchDate.moveToLastDayOfMonth().toString("yyyy/MM/dd");

        GetPromotionCollectHistory(beginDate, endDate);

    }

    function getNextMonth() {
        window.parent.API_ShowLoading();

        let newSearchDate = new Date(search_Year + "/" + search_Month + "/01").addMonths(1);

        let beginDate;
        let endDate;
        //時間超過當月
        if (Date.compare(newSearchDate, Date.parse("today")) > 0) {
            beginDate = Date.today().moveToFirstDayOfMonth().toString("yyyy/MM/dd");
            endDate = Date.today().moveToLastDayOfMonth().toString("yyyy/MM/dd");

            GetPromotionCollectHistory(beginDate, endDate);
        } else {
            beginDate = newSearchDate.moveToFirstDayOfMonth().toString("yyyy/MM/dd");
            endDate = newSearchDate.moveToLastDayOfMonth().toString("yyyy/MM/dd");

            search_Year = newSearchDate.toString("yyyy/MM/dd").split('/')[0];
            search_Month = newSearchDate.toString("yyyy/MM/dd").split('/')[1];

            GetPromotionCollectHistory(beginDate, endDate);
        }

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
                <div class="sec-title-container sec-title-prize">
                    <!-- 活動中心 link-->
                    <a class="btn btn-link btn-activity" onclick="window.parent.API_LoadPage('ActivityCenter','ActivityCenter.aspx')">
                        <span class="title language_replace">前往活動中心</span><i class="icon icon-mask icon-arrow-right-dot"></i>
                    </a>
                    <div class="sec-title-wrapper">
                        <h1 class="sec-title title-deco"><span class="language_replace">領獎中心</span></h1>
                        <!-- 使用說明LINK -->
                      <%--  <span class="sec-title-intro-link" onclick="window.parent.API_LoadPage('Prize','/Guide/prize.html', true)">
                            <span class="btn btn-QA-transaction btn-full-stress btn-round"><i class="icon icon-mask icon-question"></i></span><span class="title language_replace">領獎中心使用說明</span>
                        </span>        --%>               
                    </div>
                     <!-- 獎金/禮金 TAB -->
                     <div class="tab-prize tab-scroller tab-2 tab-primary">
                        <div class="tab-scroller__area">
                            <ul class="tab-scroller__content">
                                <li class="tab-item " id="li_bonus1" onclick="GetPromotionCollectAvailable(1)">
                                    <span class="tab-item-link"><span class="title language_replace">獎金</span>
                                    </span>
                                </li>
                                <li class="tab-item active" id="li_bonus2" onclick="GetPromotionCollectAvailable(2)">
                                    <span class="tab-item-link"><span class="title language_replace">禮金</span></span>
                                </li>
                            </ul>
                        </div>
                    </div>
                </div>

                <section class="section-wrap section-prize">
                    <div class="prize-item-wrapper">
                        <div class="prize-item-group" id="div_Prize">
                            <%--<div ></div>
                            <!-- 無資料 ========================= -->
                            <div class="no-Data" id="idNoPrizeData">
                                <div class="data">
                                    <span class="text language_replace">沒有資料</span>
                                </div>
                            </div>--%>
                        </div>
                    </div>
                </section>

                <!-- 獎金 - 已領取紀錄區 -->
                <section class="section-wrap section-prize-record">
                    <div class="sec-title-container">
                        <div class="sec-title-wrapper">
                            <h1 class="sec-title title-deco"><span class="language_replace">領取紀錄</span></h1>
                        </div>
                        <!-- 前/後 月 -->
                        <div class="sec_link sec-month">
                            <button class="btn btn-link btn-gray" type="button" onclick="getPreMonth()"><i class="icon arrow arrow-left mr-1"></i><span class="language_replace">上個月</span></button>
                            <span id="idSearchDate_P" class="date_text"></span>
                            <button class="btn btn-link btn-gray" type="button" onclick="getNextMonth()"><span class="language_replace">下個月</span><i class="icon arrow arrow-right ml-1"></i></button>
                        </div>

                    </div>
                    <div class="MT__table table-prize-record">
                        <!-- Thead  -->
                        <div class="Thead">
                            <div class="thead__tr">
                                <div class="thead__th"><span class="language_replace">領取時間</span></div>
                                <div class="thead__th"><span class="language_replace">活動名稱</span></div>
                                <div class="thead__th"><span class="language_replace">金額</span></div>
                            </div>
                        </div>
                        <!-- Tbody -->
                        <div class="Tbody"  id="div_History">
                            <%--<div></div>
                             <!-- 無資料 ========================= -->
                            <div class="no-Data" id="idNoHistoryData">
                                <div class="data">
                                    <span class="text language_replace">沒有資料</span>
                                </div>
                            </div>--%>
                        </div>
                    </div>
                </section>
            </div>
        </div>
    </main>

    <div id="IDHistoryRow" style="display: none">
        <div class="tbody__tr">
            <div class="tbody__td">
                <span class="td__content">
                    <span class="date-period">
                        <span class="year">2022</span><span class="month">04</span><span class="day">04</span>
                    </span>
                </span>
            </div>
            <div class="tbody__td">
                <span class="td__content"><span class="title">ゴールドヒット！ゴールドヒット！ ゴールドヒット！</span></span>
            </div>
            <div class="tbody__td">
                <span class="td__content"><span class="value">999,999,999</span></span>
            </div>
        </div>
    </div>

    <div id="tmpPrize0" style="display: none">
        <figure class="prize-item">
            <div class="prize-item-inner">
                <!-- 活動連結 prize-item-link-->
                <div class="prize-item-link">
                    <div class="prize-item-img">
                        <div class="img-wrap">
                            <img class="" src="images/prize-01.jpg">
                        </div>
                    </div>
                    <div class="detail">
                        <figcaption class="title language_replace">ゴールドヒット！ゴールドヒット！ ゴールドヒット！</figcaption>
                        <div class="date-period language_replace">
                            <span class="date-period-start">
                                <span class="year year_c"></span><span class="month month_c"></span><span class="day day_c"></span>
                            </span>
                            <span class="date-period-end">
                                <span class="year year_e"></span><span class="month month_e"></span><span class="day day_e"></span>
                            </span>
                        </div>
                        <span class="prize-status text-primary language_replace">可領取</span>
                    </div>
                </div>
                <!-- 獎金Button - 可領取 -->
                <button type="button" class="btn btn-bouns bouns-get"><span class="btn-bouns-num language_replace pointval">領取</span></button>
            </div>
        </figure>
    </div>

    <div id="tmpPrize1" style="display: none">
        <figure class="prize-item">
            <div class="prize-item-inner">
                <!-- 活動連結 prize-item-link-->
                <div class="prize-item-link">
                    <div class="prize-item-img">
                        <div class="img-wrap">
                            <img class="" src="images/prize-01.jpg">
                        </div>
                    </div>
                    <div class="detail">
                        <figcaption class="title language_replace"></figcaption>
                        <div class="date-period language_replace">
                            <span class="date-period-start">
                                <span class="year year_c"></span><span class="month month_c"></span><span class="day day_c"></span>
                            </span>
                            <span class="date-period-end">
                                <span class="year year_e"></span><span class="month month_e"></span><span class="day day_e"></span>
                            </span>
                        </div>
                        <span class="prize-status text-primary language_replace">餘額１００以下才可領取</span>
                    </div>
                </div>
                <!-- 獎金Button - 不可領取 -->
                <button type="button" class="btn btn-bouns bouns-get" disabled><span class="btn-bouns-num language_replace pointval">$5000000</span></button>
            </div>
        </figure>
    </div>
</body>

</html>
