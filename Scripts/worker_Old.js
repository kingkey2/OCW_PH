self.importScripts("/Scripts/Math.uuid.js");

//定期更新與整理資料吐回(背景執行)
//整理成兩塊
//1.全部遊戲，做索引，做單遊戲搜尋與優化
//2.按照分類、廠牌整理

var wokerControl;
self.addEventListener('message', function (e) {
    //data格式
    //Cmd => 執行動作
    //Params => data參數
    if (e.data) {
        if (e.data.Cmd == "Init") {
            wokerControl = new Worker(e.data.Params[0], e.data.Params[1], e.data.Params[2], e.data.Params[3], e.data.Params[4]);
            wokerControl.onRefreshCtEvent = function (ctResult) {
                self.postMessage({
                    Cmd: "RefreshCtList",
                    Data: ctResult,
                });
            };
            wokerControl.onRefreshDicEvent = function (searchResult) {
                self.postMessage({
                    Cmd: "RefreshDic",
                    Data: searchResult,
                });
            };

            wokerControl.onLoadLangEnd = function (langs) {
                self.postMessage({
                    Cmd: "LangsLoaded",
                    Data: langs,
                });
            };

            wokerControl.start();
        }
    }
}, false);



//#region  Class
var Worker = function (version, url, langUrl, second, timeStamp) {
    var defineLocations = ["Home", "GameList_All", "GameList_Slot", "GameList_Live", "GameList_Electron", "GameList_Other"];
    var defineLangs = ["JPN", "CHT"];    
    var url = url
    var langUrl = langUrl;
    var IntervalSecond = second;   
    var version = version;

    var lobbyAPI;

    var languages = [

    ];

    var multiLanguage = function (v) {
        var _LanguageContextJSON = [];

        this.getLangText = function () {
            return _LanguageContextJSON[0];
        }

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
                                cb(lang);
                        });
                    } else {
                        loadLanguageFromFile(filePath + lang + ".json", function () {
                            if (cb)
                                cb(lang);
                        });
                    }
                } else {
                    if (cb)
                        cb(lang);
                }
            } else {
                if (cb)
                    cb(lang);
            }
        }

    };

    var LoadLang = function (cb) {
        var PromiseList = [];
        
        for (var i = 0; i < defineLangs.length; i++) {
            var gameCodeMlp = new multiLanguage(version);
            var gameBrandMlp = new multiLanguage(version);
            var lang = defineLangs[i];
            PromiseList.push(new Promise(function (resolve, reject) {               
                gameCodeMlp.loadLanguageByOtherFile(langUrl + "/GameCode.", lang, (function (lang) {
                    languages.push({
                        lang: lang,
                        type: "GameCode",
                        mlp: this
                    });
                    resolve({ Data: this.getLangText(), lang: lang, type: "GameCode"});
                }).bind(gameCodeMlp));
            }));

            PromiseList.push(new Promise(function (resolve, reject) {             
                gameBrandMlp.loadLanguageByOtherFile(langUrl + "/GameBrand.", lang, (function (lang) {
                    languages.push({
                        lang: lang,
                        type: "GameBrand",
                        mlp: this
                    });
                    resolve({ Data: this.getLangText(), lang: lang, type: "GameBrand"});
                }).bind(gameBrandMlp));
            }));         
        }

        Promise.all(PromiseList).then(function (values) {
            cb(values);
        });
    }

    var RefreshData = function RefreshData() {

        //#region List Define


        //var GameList = {
        //    Slices: [
        //        {
        //            Index: 0 // GameID /100
        //            Datas: [
        //          GameData                           
        //            ]
        //        }
        //    ]
        //};

        //var SearchDic = {
        //    //廠牌搜尋
        //    Brands: [{GameBrand:,AllGame:[],GameIndex}],
        //    //總文字搜尋
        //    Langs: { CHT : { 好:[] }}
        //};


        //var GameCtList = [{
        //    Location: "",
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

        let tempStamp = this.RecordTimeStamp;
        lobbyAPI.GetCompanyGameCodeTwo(Math.uuid(), tempStamp, (function (success, o) {
            if (success) {
                if (o.Result == 0) {
                    if (o.CompanyCategoryDatas.length > 0) {
                        var GameCtList = [];

                        for (var i = 0; i < defineLocations.length; i++) {
                            GameCtList.push({
                                Location: defineLocations[i],
                                Categories: []
                            });
                        }


                        for (var i = 0; i < o.CompanyCategoryDatas.length; i++) {
                            var ctData = o.CompanyCategoryDatas[i];
                            var targetLocation = GameCtList.find(x => x.Location == ctData.Location);
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
                                    var language = languages[iii];

                                    if (language.type == "GameCode") {
                                        pushGameData.GameText[language.lang] = language.mlp.getLanguageKey(pushGameData.GameBrand + "." + pushGameData.GameName);

                                    } else if (language.type == "GameBrand") {
                                        pushGameData.BrandText[language.lang] = language.mlp.getLanguageKey(pushGameData.GameBrand);
                                    }
                                }

                                pushCtData.Datas.push(pushGameData);
                            }

                            pushCtData.Datas.sort((a, b) => a.SortIndex - b.SortIndex);

                            targetLocation.Categories.push(pushCtData);
                        }

                        for (var i = 0; i < GameCtList.length; i++) {
                            GameCtList[i].Categories.sort((a, b) => a.SortIndex - b.SortIndex);
                        }


                        this.RecordTimeStamp = o.TimeStamp;
                        if (this.onRefreshCtEvent) {
                            this.onRefreshCtEvent({
                                TimeStamp: this.RecordTimeStamp,
                                CtList:GameCtList
                            });
                        }
                    }                                    
                }
            }
        }).bind(this));

        lobbyAPI.GeAllCompanyGameCode(Math.uuid(), tempStamp, (function (success, o) {
            if (success) {
                if (o.Result == 0) {
                    if (o.Datas.length > 0) {
                        var GameList = {
                            Slices: [],
                            TotalCount: 0
                        };


                        var SearchDic = {
                            //廠牌搜尋
                            Brands: [],
                            //總文字搜尋
                            Langs: {}
                        };

                        GameList.Slices.length = Math.trunc(o.MaxGameID / 100) + 1;

                        for (var i = 0; i < GameList.Slices.length; i++) {
                            GameList.Slices[i] = [];
                            GameList.Slices[i].length = 100;
                        }

                        for (var i = 0; i < o.Datas.length; i++) {
                            //利用MaxGameID整理index                        
                            var Data = o.Datas[i];
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
                                targetBrand.AllGame.push(Data.GameID);
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

                                    },
                                    BrandText: {},
                                    GameCtList:[],
                                    AllGame: [Data.GameID]
                                };

                                //取第一個字母當作切片依據
                                targetBrand.GameNameIndex[Data.GameName[0]] = [{
                                    TargetValue: Data.GameName,
                                    GameID: Data.GameID
                                }];


                                

                                for (var ii = 0; ii < languages.length; ii++) {
                                    var language = languages[ii];
                                    var transBrandText = language.mlp.getLanguageKey(Data.GameBrand);
                                    var targetLangData;

                                    if (language.type == "GameCode") {
                                       
                                    } else if (language.type == "GameBrand") {
                                        targetBrand.BrandText[language.lang] = transBrandText;
                                    }
                                }

                                SearchDic.Brands.push(targetBrand);
                            }

                            //處理Brand的Category
                            if (targetBrand.GameCtList.indexOf(pushData.GameCategoryCode) == -1) {
                                targetBrand.GameCtList.push(pushData.GameCategoryCode);
                            }


                            //整理語系資料與依照字母加入搜尋索引
                            for (var ii = 0; ii < languages.length; ii++) {
                                var language = languages[ii];
                                var transGameText = language.mlp.getLanguageKey(Data.GameCode);
                                var transBrandText = language.mlp.getLanguageKey(Data.GameBrand);
                                var targetLangData;

                                if (language.type == "GameCode") {
                                    pushData.GameText[language.lang] = transGameText;
                                } else if (language.type == "GameBrand") {
                                    pushData.BrandText[language.lang] = transBrandText;
                                }

                                if (language.type == "GameCode") {
                                    //新增至全部文字搜尋
                                    targetLangData = SearchDic.Langs[language.lang];

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
                                        SearchDic.Langs[language.lang] = tempCharDatas;
                                    }


                                    //新增至廠牌全文字搜尋
                                    targetLangData = targetBrand.Langs[language.lang];

                                    if (targetLangData) {
                                        var targetCharDatasByBrand = targetLangData[transGameText[0]];

                                        if (targetCharDatasByBrand) {
                                            targetCharDatasByBrand.push({
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
                                        targetBrand.Langs[language.lang] = tempCharDatas;
                                    }
                                }
                            }

                            var IndexOne = Math.trunc(Data.GameID / 100);
                            var IndexTwo = Data.GameID % 100;

                            GameList.Slices[IndexOne][IndexTwo] = pushData;
                            GameList.TotalCount++;
                        }

                        this.RecordTimeStamp = o.TimeStamp;
                        if (this.onRefreshDicEvent) {
                            this.onRefreshDicEvent({
                                TimeStamp: this.RecordTimeStamp,
                                SearchCore: {
                                    GameList: GameList,
                                    SearchDic: SearchDic
                                }});
                        }
                    }             
                }
            }
        }).bind(this));
    };


    //#region public屬性
    this.RecordTimeStamp = timeStamp;
    //刷新全部
    this.onRefreshDicEvent;
    //刷新分類
    this.onRefreshCtEvent;

    this.onLoadLangEnd;

    this.start = function () {
        lobbyAPI = new (function (APIUrl) {
            this.GeAllCompanyGameCode = function (GUID, RecordTimeStamp, cb) {
                var url = APIUrl + "/GeAllCompanyGameCode";
                var postData;

                postData = {
                    GUID: GUID,
                    RecordTimeStamp: RecordTimeStamp
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

            this.GetCompanyGameCodeTwo = function (GUID, RecordTimeStamp, cb) {
                var url = APIUrl + "/GetCompanyGameCodeTwo";
                var postData;

                postData = {
                    GUID: GUID,
                    RecordTimeStamp: RecordTimeStamp
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

        

        LoadLang((function (values) {
            this.onLoadLangEnd(values);
            RefreshData.call(this);
            setInterval(RefreshData.bind(this), IntervalSecond);
        }).bind(this));
    }
    //#endregion
};
//#endregion
