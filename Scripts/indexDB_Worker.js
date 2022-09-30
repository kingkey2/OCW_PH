var workerControl;

//定期更新與整理資料吐回(背景執行)
//整理成兩塊
//1.全部遊戲，做索引，做單遊戲搜尋與優化
//2.按照分類、廠牌整理

self.addEventListener('message', function (e) {
    //data格式
    //Cmd => 執行動作
    //Params => data參數
    if (e.data) {
        if (e.data.Cmd == "Init") {
            wokerControl = new Worker(e.data.Params[0], e.data.Params[1], e.data.Params[2], e.data.Params[3], function () {
                self.postMessage("RefreshData");
            });
        } else if (e.data.Cmd == "INIT") {

        }
    }
    self.postMessage(res);
    self.close();
}, false);



//#region  Class
var WorkerControl = function (version, url, second) {
    var defineLocations = ["Home", "GameList_All", "GameList_Slot", "GameList_Live", "GameList_Electron", "GameList_Other"];
    var defineLangs = ["JPN", "CHT"];

    var RecordTimeStamp = 0;
    var url = url

    var IntervalSecond = second;
    var version = version;
    var lobbyAPI

    //#region public屬性
    //刷新全部
    this.onRefreshAllEvent;
    //刷新分類
    this.onRefreshCtEvent;
    //#endregion

    //#region 語系暫時解決方案
    var langUrl = langUrl;
    var languages = [
        {
            lang: "",
            type: "Brand",
            mlp: null
        }
    ];
    var multiLanguage = function (v) {
        var _LanguageContextJSON = [];

        function loadLanguageFromFile(langFile, cb) {
            readTextFile(langFile, function (success, text) {
                if (success) {
                    var langObj = JSON.parse(text);

                    _LanguageContextJSON[_LanguageContextJSON.length] = langObj;
                }

                if (cb != null)
                    cb();
            });
        }

        function readTextFile(file, callback) {
            var rawFile = new XMLHttpRequest();
            //rawFile.overrideMimeType("application/json");
            rawFile.open("GET", file, true);
            //rawFile.setRequestHeader("Cache-Control", "no-cache, no-store, must-revalidate");
            rawFile.onreadystatechange = function () {
                if (rawFile.readyState === 4) {
                    if (rawFile.status == "200") {
                        callback(true, rawFile.responseText);
                    } else {
                        callback(false, rawFile.responseText);
                    }

                }
            }
            rawFile.send(null);
        }

        this.getLanguageKey = function (key) {
            var retValue = key;

            if (key) {
                if (key != "") {
                    if (_LanguageContextJSON != null) {
                        for (var _i = 0; _i < _LanguageContextJSON.length; _i++) {
                            var _o = _LanguageContextJSON[_i];

                            if (typeof _o[key] != 'undefined') {
                                retValue = _o[key];
                            }
                        }
                    }
                }
            }

            return retValue;
        }

        this.loadLanguageByOtherFile = function (filePath, lang, cb) {
            if (lang) {
                if (lang != "") {
                    _LanguageContextJSON = [];

                    if (v) {
                        loadLanguageFromFile(filePath + lang + ".json?" + v, function () {
                            if (cb)
                                cb();
                        });
                    } else {
                        loadLanguageFromFile(filePath + lang + ".json", function () {
                            if (cb)
                                cb();
                        });
                    }
                } else {
                    if (cb)
                        cb();
                }
            } else {
                if (cb)
                    cb();
            }
        }

    };
    var LoadLang = function (cb) {
        var PromiseList = [];

        for (var i = 0; i < defineLangs.length; i++) {
            var lang = defineLangs[i];
            promiseList.push(new Promise(function (resolve, reject) {
                var mlp = new multiLanguage(version);
                mlp.loadLanguageByOtherFile(langUrl + "/GameCode.", lang, function () {
                    languages.push({
                        lang: lang,
                        type: "GameCode",
                        mlp: mlp
                    });
                    resolve();
                })
            }));
            promiseList.push(new Promise(function (resolve, reject) {
                var mlp = new multiLanguage(version);
                mlp.loadLanguageByOtherFile(langUrl + "/GameBrand.", lang, function () {
                    languages.push({
                        lang: lang,
                        type: "GameBrand",
                        mlp: mlp
                    });
                    resolve();
                })
            }));
        }

        Promise.all(promiseList).then(function (values) {
            cb();
        });
    }
    //#endregion

    var RefreshData = function () {
        //兩部分
        //全部的部分使用indexDB
        //自定義部分使用記憶體(暫時)

        //#region List Define

        //var GameCtList = [{
        //    Loacation: "",
        //    Categories: [
        //        {
        //            CategoryID: 0,
        //            State: 0,
        //            SortIndex: 0,
        //            Location: 0,
        //            ShowType: 0,
        //            Datas: [
        //                {
        //                    CategoryID: 0,
        //                    GameID: 0,
        //                    GameCode: "",
        //                    GameName: "",
        //                    GameCategoryCode: "",
        //                    GameCategorySubCode: "",
        //                    AllowDemoPlay: 0,
        //                    RTPInfo: 0,
        //                    Info: 0,
        //                    IsHot: 0,
        //                    IsNew: 0,
        //                    SortIndex: 0
        //                }
        //            ]
        //        }
        //    ]
        //}];

        //#endregion List

        lobbyAPI.GetCompanyGameCodeTwo(getUUID(), function (success, o) {
            if (success) {
                if (o.Result == 0) {
                    var GameCtList = [];

                    for (var i = 0; i < o.CompanyCategoryDatas.length; i++) {
                        var ctData = CompanyCategoryDatas[i];
                        var targetLoacation = GameCtList.find(x => x.Location == ctData.Location);
                        var pushCtData = {
                            CategoryID: ctData.CompanyCategoryID,
                            State: ctData.State,
                            SortIndex: ctData.SortIndex,
                            CategoryName: ctData.CategoryName,
                            Location: ctData.Location,
                            ShowType: ctData.ShowType,
                            Datas: [],
                        };

                        for (var ii = 0; ii < ctData.Datas.length; ii++) {
                            var gameData = ctData.Datas[ii];
                            var pushGameData = {
                                CategoryID: ctData.CompanyCategoryID,
                                GameID: gameData.GameID,
                                GameCode: gameData.GameCode,
                                GameBrand: gameData.GameBrand,
                                GameName: gameData.GameName,
                                GameCategoryCode: gameData.GameCategoryCode,
                                GameCategorySubCode: gameData.GameCategorySubCode,
                                AllowDemoPlay: gameData.AllowDemoPlay,
                                RTPInfo: gameData.RTPInfo,
                                Info: gameData.Info,
                                RTPInfo: gameData.RTPInfo,
                                IsHot: gameData.IsHot,
                                IsNew: gameData.IsNew,
                                SortIndex: gameData.SortIndex,
                                Tag: gameData.Tag,
                                GameText: {},
                                BrandText: {}
                            };

                            for (var iii = 0; iii < languages.length; iii++) {
                                var language = languages[i];

                                if (language.type == "GameCode") {
                                    pushGameData.GameText[language.lang] = mlp.getLanguageKey(pushGameData.GameCode);

                                } else if (language.type == "GameBrand") {
                                    pushGameData.BrandText[language.lang] = mlp.getLanguageKey(pushGameData.GameBrand);
                                }
                            }

                            pushCtData.Datas.push(pushGameData);
                        }

                        pushCtData.Datas.sort((a, b) => a.SortIndex - b.SortIndex);

                        targetLoacation.Categories.push(pushCtData);
                    }

                    for (var i = 0; i < this.GameCtList.length; i++) {
                        GameCtList[i].Categories.sort((a, b) => a.SortIndex - b.SortIndex);
                    }


                }
            }
        });

        lobbyAPI.GeAlltCompanyGameCode(getUUID(), function (success, o) {
            if (success) {
                if (o.Result == 0) {
                    var GameList = {
                        Slices: [],
                        TotalCount
                    };


                    var SearchDic = {
                        //廠牌搜尋
                        Brands: [],
                        //總文字搜尋
                        Langs: []
                    };

                    GameList.Slices.length = Math.trunc(o.MaxGameID / 100) + 1;

                    for (var i = 0; i < GameList.Slices.length; i++) {
                        GameList.Slices[i] = [];
                        GameList.Slices[i].length = 100;
                    }

                    for (var i = 0; i < o.Datas.length; i++) {
                        //利用MaxGameID整理index                        
                        var Data = Datas[i];
                        var targetBrand;
                        var pushData = {
                            GameID: Data.GameID,
                            GameCode: Data.GameCode,
                            GameBrand: Data.GameBrand,
                            GameName: Data.GameName,
                            GameCategoryCode: Data.GameCategoryCode,
                            GameCategorySubCode: Data.GameCategorySubCode,
                            AllowDemoPlay: Data.AllowDemoPlay,
                            RTPInfo: Data.RTPInfo,
                            Info: Data.Info,
                            IsHot: Data.IsHot,
                            IsNew: Data.IsNew,
                            SortIndex: Data.SortIndex,
                            Tag: Data.Tag,
                            GameText: {},
                            BrandText: {}
                        };


                        //依據廠牌整理搜尋索引
                        targetBrand = SearchDic.Brands.find(x => x.GameBrand == Data.GameBrand);


                        if (targetBrand) {
                            var targeCharDatas = targetBrand.GameNameIndex[Data.GameName[0]];
                            if (targeCharDatas) {
                                targeCharDatas.push({
                                    TargetValue: Data.GameName,
                                    GameID: Data.GameID
                                });
                            } else {
                                targetBrand.GameNameIndex[Data.GameName[0]] = [{
                                    TargetValue: Data.GameName,
                                    GameID: Data.GameID
                                }];
                            }
                        } else {
                            //初始化廠牌
                            targetBrand = {
                                GameBrand: Data.GameBrand,
                                //廠牌GameCode搜尋
                                GameNameIndex: {

                                },
                                //廠牌文字搜尋，需再區分語系
                                Langs: {

                                }
                            };

                            //取第一個字母當作切片依據
                            targetBrand.GameNameIndex[Data.GameName[0]] = [{
                                TargetValue: Data.GameName,
                                GameID: Data.GameID
                            }];
                        }

                        //整理語系資料與依照字母加入搜尋索引
                        for (var ii = 0; ii < this.languages.length; ii++) {
                            var language = this.languages[i];
                            var transGameText = mlp.getLanguageKey(Data.GameCode);
                            var transBrandText = mlp.getLanguageKey(Data.GameBrand);
                            var targetLangData;

                            if (language.type == "GameCode") {
                                Data.GameText[language.lang] = transGameText;
                            } else if (language.type == "GameBrand") {
                                Data.BrandText[language.lang] = transBrandText;
                            }


                            //新增至全部文字搜尋
                            targetLangData = SearchDic.Langs[language];

                            if (targetLangData) {
                                var targetCharDatas = targetLangData[transGameText[0]];

                                if (targetCharDatas) {
                                    targetCharDatas.push({
                                        TargetValue: transGameText,
                                        GameID: Data.GameID
                                    });
                                } else {
                                    targetLangData[transGameText[0]] = [{
                                        TargetValue: transGameText,
                                        GameID: Data.GameID
                                    }];
                                }
                            } else {
                                var tempCharDatas = {};
                                tempCharDatas[transGameText[0]] = [{
                                    TargetValue: transGameText,
                                    GameID: Data.GameID
                                }];
                                SearchDic.Langs[language] = tempCharDatas;
                            }


                            //新增至廠牌全文字搜尋
                            targetLangData = targetBrand.Langs[language];

                            if (targetLangData) {
                                var targetCharDatasByBrand = targetLangData[transGameText[0]];

                                if (targetCharDatas) {
                                    targetCharDatas.push({
                                        TargetValue: transGameText,
                                        GameID: Data.GameID
                                    });
                                } else {
                                    targetLangData[transGameText[0]] = [{
                                        TargetValue: transGameText,
                                        GameID: Data.GameID
                                    }];
                                }
                            } else {
                                var tempCharDatas = {};
                                tempCharDatas[transGameText[0]] = [{
                                    TargetValue: transGameText,
                                    GameID: Data.GameID
                                }];
                                targetBrand.Langs[language] = tempCharDatas;
                            }
                        }

                        var IndexOne = Math.trunc(o.MaxGameID / 100);
                        var IndexTwo = o.MaxGameID % 100;

                        GameList.Slices[IndexOne][IndexTwo] = pushData;

                        if (this.onRefreshAllEvent) {
                            this.onRefreshAllEvent({
                                GameList: GameList,
                                SearchDic: SearchDic
                            });
                        }
                    }
                }
            }
        });
    };

    function getUUID(len, radix) {
        if (len) {
            // Compact form
            for (i = 0; i < len; i++) uuid[i] = chars[0 | Math.random() * radix];
        } else {
            // rfc4122, version 4 form
            var r;

            // rfc4122 requires these characters
            uuid[8] = uuid[13] = uuid[18] = uuid[23] = '-';
            uuid[14] = '4';

            // Fill in random data.  At i==19 set the high bits of clock sequence as
            // per rfc4122, sec. 4.1.5
            for (i = 0; i < 36; i++) {
                if (!uuid[i]) {
                    r = 0 | Math.random() * 16;
                    uuid[i] = chars[(i == 19) ? (r & 0x3) | 0x8 : r];
                }
            }
        }

        return uuid.join('');
    }

    function init() {


        //初始化分類
        for (var i = 0; i < defineLocations.length; i++) {
            GameCtList.push({
                Loacation: defineLocations[i],
                Categories: null
            });
        }

        lobbyAPI = new (function (APIUrl) {
            this.GeAlltCompanyGameCode = function (GUID, cb) {
                var url = APIUrl + "/GeAlltCompanyGameCode";
                var postData;

                postData = {
                    GUID: GUID
                };

                callService(url, postData, 10000, function (success, text) {
                    if (success == true) {
                        var obj = getJSON(text);

                        if (cb)
                            cb(true, obj);
                    } else {
                        if (cb)
                            cb(false, text);
                    }
                });
            };

            this.GetCompanyGameCodeTwo = function (GUID, cb) {
                var url = APIUrl + "/GetCompanyGameCodeTwo";
                var postData;

                postData = {
                    GUID: GUID
                };

                callService(url, postData, 10000, function (success, text) {
                    if (success == true) {
                        var obj = getJSON(text);

                        if (cb)
                            cb(true, obj);
                    } else {
                        if (cb)
                            cb(false, text);
                    }
                });
            };

            function callService(URL, postObject, timeoutMS, cb) {
                var xmlHttp = new XMLHttpRequest;
                var postData;

                if (postObject)
                    postData = JSON.stringify(postObject);

                xmlHttp.open("POST", URL, true);
                xmlHttp.onreadystatechange = function () {
                    if (this.readyState == 4) {
                        var contentText = this.responseText;

                        if (this.status == "200") {
                            if (cb) {
                                cb(true, contentText);
                            }
                        } else {
                            cb(false, contentText);
                        }
                    }
                };

                xmlHttp.timeout = timeoutMS;
                xmlHttp.ontimeout = function () {
                    /*
                    timeoutTryCount += 1;
        
                    if (timeoutTryCount < 2)
                        xmlHttp.send(postData);
                    else*/
                    if (cb)
                        cb(false, "Timeout");
                };

                xmlHttp.setRequestHeader("Content-Type", "application/json; charset=utf-8");
                xmlHttp.send(postData);
            }

            function getJSON(text) {
                var obj = JSON.parse(text);

                if (obj) {
                    if (obj.hasOwnProperty('d')) {
                        return obj.d;
                    } else {
                        return obj;
                    }
                }
            }
        })(url);

        LoadLang(function () {
            RefreshData();
            setInterval.call(this, this.RefreshData, IntervalSecond);
        });
    }

    init.call(this);
};
//#endregion
