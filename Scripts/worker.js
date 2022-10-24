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
            wokerControl = new worker(e.data.Params[0], e.data.Params[1], e.data.Params[2], 12);

            //dataExist,true => indexedDB已經有資料，可不等同步直接使用
            wokerControl.OnInitSyncStart = function (dataExist) {
                self.postMessage({
                    Cmd: "InitSyncStart",
                    Data: dataExist,
                });
            };

            wokerControl.OnInitSyncEnd = function () {
                self.postMessage({
                    Cmd: "InitSyncEnd",
                    Data: null,
                });
            };

            wokerControl.Start();
        }
    }
}, false);



//#region  Class
var worker = function (WebUrl, Second, eWinGameItem, Version) {
    var workerSelf = this;
    var APIUrl = WebUrl;
    var ChampionList = [
        {
            Name: "ビッグウィン",
            Value:  1
        },
        {
            Name: "最大倍率",
            Value: 2
        },
        {
            Name: "最大スピン数",
            Value: 4
        }
    ]

    var callService = function (URL, postObject, timeoutMS, cb) {
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

    var getJSON = function (text) {
        var obj = JSON.parse(text);

        if (obj) {
            if (obj.hasOwnProperty('d')) {
                return obj.d;
            } else {
                return obj;
            }
        }
    }

    var InitDBSchema = function (db) {
        var store;
        var categoryStore;
        var syncStore;

        store = db.createObjectStore("GameCodes", { keyPath: "GameCode", autoIncrement: false });
        store.createIndex('GameID', "GameID", { unique: true, multiEntry: false });
        store.createIndex('GameBrand', ['GameBrand', 'SortIndex'], { unique: false, multiEntry: false });
        store.createIndex('GameCategoryCode', ['GameCategoryCode', 'SortIndex'], { unique: false, multiEntry: false });
        store.createIndex('GameCategorySubCode', ['GameCategoryCode', 'GameCategorySubCode', 'SortIndex'], { unique: false, multiEntry: false });
        store.createIndex('SearchKeyWord', "Tags", { unique: false, multiEntry: true }); //搜尋關鍵字使用
        store.createIndex('PersonalFavo', ['IsFavo', 'FavoTimeStamp'], { unique: false, multiEntry: false });
        store.createIndex('PersonalPlayed', ['IsPlayed', 'PlayedTimeStamp'], { unique: false, multiEntry: false });
        //store.createIndex('ShowTags', 'ShowTags', { unique: false, multiEntry: true }); //顯性標籤

        categoryStore = db.createObjectStore("GameCategory", { keyPath: ['GameBrand', 'GameCategoryCode'], autoIncrement: false });
        categoryStore.createIndex('GameBrand', 'GameBrand', { unique: false, multiEntry: false });
        categoryStore.createIndex('GameCategoryCode', 'GameCategoryCode', { unique: false, multiEntry: false });

        syncStore = db.createObjectStore("SyncData", { keyPath: 'SyncID', autoIncrement: false });

        //store.createIndex('ShowTags', 'ShowTags', { unique: false, multiEntry: true }); //顯性標籤

        db.createObjectStore("RealSearchKey", { keyPath: "RealSearchKey", autoIncrement: false });

        //if (workerSelf.EWinGameItem) {
        //    store.put(workerSelf.EWinGameItem);
        //    categoryStore.put({
        //        GameBrand: workerSelf.EWinGameItem.GameBrand,
        //        GameCategoryCode: workerSelf.EWinGameItem.GameCategoryCode,
        //    });
        //}
    }

    var ClearDBSchema = function (cb) {
        workerSelf.SyncEventData.Database.close();
        console.log("deleteStart");
        let DBDeleteRequest = self.indexedDB.deleteDatabase("GameCodeDB");

        DBDeleteRequest.onsuccess = function (event) {
            console.log("Deleted database successfully")
            if (cb) {
                cb();
            }
        };

        DBDeleteRequest.onerror = function () {
            console.log("Couldn't delete database");
        };
        DBDeleteRequest.onblocked = function () {
            console.log("Couldn't delete database due to the operation being blocked");
        };

        if (cb) {
            cb();
        }
    };

    //#region public屬性

    //property
    this.SyncEventData = {
        Database: null,
        LastTimeStamp: 0,
        LastGameID: 0,
        NowTimeStamp: 0,
        NowGameID: 0,
        IntervalSecond: Second,
        FailureSecond: 3,
        RealSearchKeys: [],
        Version: Version
    };

    this.EWinGameItem = eWinGameItem;

    //delegate
    //刷新全部    
    this.OnInitSyncStart;

    this.OnInitSyncEnd;

    this.IsFirstLoaded = false;

    this.Sync = function () {
        //初始化，不指定version
        let DBRequestLink = self.indexedDB.open('GameCodeDB', workerSelf.SyncEventData.Version);
        let oldVersion;
        //check indexDB init

        //版本號高於當前版本，觸發
        DBRequestLink.onupgradeneeded = function (event) {
            let db = event.target.result;
            oldVersion = event.oldVersion;
            if (event.oldVersion == 0) {
                InitDBSchema(event.target.result);
            } else {
                try {
                    db.deleteObjectStore("GameCodes");
                    db.deleteObjectStore("GameCategory");
                    db.deleteObjectStore("SyncData");
                    db.deleteObjectStore("RealSearchKey");
                } catch (e) {

                }
                InitDBSchema(event.target.result);
            }
        };

        DBRequestLink.onerror = (event) => {
            //workerSelf.SyncEventData.Database.close();
            let delRequest = self.indexedDB.deleteDatabase('GameCodeDB');
            delRequest.onsuccess = (event) => {
                workerSelf.Sync();
            };
        };

        DBRequestLink.onsuccess = function (event) {
            let dbVersion;
            let SyncStartPromise;

            workerSelf.SyncEventData.Database = event.target.result;
            dbVersion = workerSelf.SyncEventData.Database.version;

            //if (oldVersion != 0 && dbVersion != oldVersion && dbVersion == 7) {
            //    workerSelf.SyncEventData.Database.close();
            //    let delRequest = self.indexedDB.deleteDatabase('GameCodes');
            //    delRequest.onsuccess = (event) => {
            //        workerSelf.Sync();
            //    };
            //    return;
            //}

            SyncStartPromise = new Promise((resolve, reject) => {
                let transaction = workerSelf.SyncEventData.Database.transaction(['SyncData'], 'readwrite');
                let objectStore = transaction.objectStore('SyncData');

                if (oldVersion == 0) {
                    let syncData = {
                        SyncID: 1,
                        GameID: 0,
                        TimeStamp: 0,
                        LastUpdateDate: new Date().toISOString(),
                        StatusText: "Start"
                    };

                    console.log("SyncStart");
                    console.log(syncData);

                    objectStore.put(syncData);

                    workerSelf.SyncEventData.NowGameID = 0;
                    workerSelf.SyncEventData.NowTimeStamp = 0;

                    if (workerSelf.IsFirstLoaded == false) {
                        if (workerSelf.OnInitSyncStart) {
                            workerSelf.OnInitSyncStart(false);
                        }
                    }

                    resolve();
                } else {
                    objectStore.get(1).onsuccess = function (event) {
                        if (event.target.result) {
                            console.log("SyncStart");
                            //console.log(event.target.result);

                            workerSelf.SyncEventData.NowGameID = event.target.result.GameID;
                            workerSelf.SyncEventData.NowTimeStamp = event.target.result.TimeStamp;

                            if (workerSelf.IsFirstLoaded == false) {
                                if (workerSelf.OnInitSyncStart) {
                                    workerSelf.OnInitSyncStart(true);
                                }
                            }
                        } else {
                            let syncData = {
                                SyncID: 1,
                                GameID: 0,
                                TimeStamp: 0,
                                LastUpdateDate: new Date().toISOString(),
                                StatusText: "Start"
                            };

                            console.log("SyncStart");
                            //console.log(syncData);


                            objectStore.put(syncData);

                            workerSelf.SyncEventData.NowGameID = 0;
                            workerSelf.SyncEventData.NowTimeStamp = 0;

                            if (workerSelf.IsFirstLoaded == false) {
                                if (workerSelf.OnInitSyncStart) {
                                    workerSelf.OnInitSyncStart(false);
                                }
                            }
                        }

                        resolve();
                    };
                }
            });

            SyncStartPromise.then(workerSelf.RecursiveSyncGameCode);
        };

    };

    this.NextSync = function (Second) {
        workerSelf.SyncEventData.LastTimeStamp = 0;
        workerSelf.SyncEventData.LastGameID = 0;

        setTimeout(workerSelf.Sync, Second * 1000)
    };

    this.SyncSuccess = function (needResetVersion) {
        //db drop
        console.log('SyncSuccess');
        if (workerSelf.SyncEventData.Database) {
            workerSelf.SyncEventData.Database.close();
            workerSelf.SyncEventData.Database = null;
        }

        if (workerSelf.IsFirstLoaded == false) {
            if (workerSelf.OnInitSyncEnd) {
                workerSelf.OnInitSyncEnd();
            }

            workerSelf.IsFirstLoaded = true;
        }

        workerSelf.NextSync(workerSelf.SyncEventData.IntervalSecond);
    };

    this.SyncFaliure = function () {
        console.log('SyncFaliure');
        //db drop
        if (workerSelf.SyncEventData.Database) {
            workerSelf.SyncEventData.Database.close();
            workerSelf.SyncEventData.Database = null;
        }

        workerSelf.NextSync(workerSelf.SyncEventData.FailureSecond);
    };

    this.GetCompanyGameCodeByUpdateTimestamp = function (GUID, UpdateTimestamp, GameID, cb) {
        var url = APIUrl + "/GetCompanyGameCodeByUpdateTimestamp";
        var postData;

        postData = {
            GUID: GUID,
            UpdateTimestamp: UpdateTimestamp,
            GameID: GameID
        };

        callService(url, postData, 100000, function (success, text) {
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

    this.RecursiveSyncGameCode = function () {
        let transaction = workerSelf.SyncEventData.Database.transaction(['RealSearchKey'], 'readonly');
        let objectStore = transaction.objectStore('RealSearchKey');
        let getAllKeysRequest = objectStore.getAllKeys();

        getAllKeysRequest.onsuccess = (event) => {
            if (event.target.result) {
                workerSelf.SyncEventData.RealSearchKeys = event.target.result;
            }

            console.log('workerSelf.SyncEventData.NowTimeStamp = ' + workerSelf.SyncEventData.NowTimeStamp);
            console.log('workerSelf.SyncEventData.NowGameID = ' + workerSelf.SyncEventData.NowGameID);

            workerSelf.GetCompanyGameCodeByUpdateTimestamp(Math.uuid(), workerSelf.SyncEventData.NowTimeStamp, workerSelf.SyncEventData.NowGameID, function (success, o) {
                if (workerSelf.SyncEventData.Database) {
                    if (success) {
                        if (o.Result == 0) {
                            workerSelf.SyncEventData.LastTimeStamp = o.LastTimestamp;
                            workerSelf.SyncEventData.LastGameID = o.LastGameID;

                            if (workerSelf.SyncEventData.LastTimeStamp == workerSelf.SyncEventData.NowTimeStamp && workerSelf.SyncEventData.NowGameID == workerSelf.SyncEventData.LastGameID) {


                                //已是最新數據，不用同步
                                console.log("NoSyncing, SyncSuccess");
                                workerSelf.SyncSuccess(false);
                            } else {

                                let transaction = workerSelf.SyncEventData.Database.transaction(['GameCodes', 'GameCategory', 'SyncData'], 'readwrite');
                                let objectStore = transaction.objectStore('GameCodes');
                                let objectCategoryStore = transaction.objectStore('GameCategory');
                                let objectSyncStore = transaction.objectStore('SyncData');

                                for (var i = 0; i < o.GameCodeList.length; i++) {
                                    let gameCodeItem = o.GameCodeList[i];
                                    let tags = [];
                                    let temps = gameCodeItem.GameCodeCategory;
                                    let ChampionType = 0;
                                    for (var ii = 0; ii < temps.length; ii++) {
                                        let index = temps[ii].CategoryName.indexOf("@")
                                        if (index != -1) {
                                            let tagValue = temps[ii].CategoryName.substring(index + 1).trim();
                                            tags.push(tagValue);

                                            for (var iii = 0; iii < ChampionList.length; iii++) {
                                                if (ChampionList[iii].Name == tagValue) {
                                                    ChampionType = ChampionType | ChampionList[iii].Value;
                                                }
                                            }
                                        }
                                    }


                                    //檢查目前存在的關鍵字，產生相關索引
                                    for (var ii = 0; ii < workerSelf.SyncEventData.RealSearchKeys.length; ii++) {
                                        let SearchKeyWord = workerSelf.SyncEventData.RealSearchKeys[ii];
                                        let searchFlag = false;

                                        for (var iii = 0; iii < tags.length; iii++) {
                                            let tagValue = tags[iii]
                                            if (SearchKeyWord.toLowerCase().includes(tagValue)) {
                                                searchFlag = true;
                                                break;
                                            }

                                            if (SearchKeyWord.length >= 2 && tagValue.toLowerCase().includes(SearchKeyWord.toLowerCase())) {
                                                searchFlag = true;
                                                break;
                                            }
                                        }

                                        for (var iii = 0; iii < gameCodeItem.Language.length; iii++) {
                                            if (gameCodeItem.Language[iii].DisplayText.toLowerCase().includes(SearchKeyWord.toLowerCase())) {
                                                searchFlag = true;
                                                break;
                                            }
                                        }

                                        if (searchFlag == true && !tags.includes(SearchKeyWord)) {
                                            tags.push(SearchKeyWord);
                                        }
                                    }

                                    let InsertData = {
                                        GameCode: gameCodeItem.GameCode,
                                        GameBrand: gameCodeItem.BrandCode,
                                        GameStatus: gameCodeItem.GameStatus,
                                        GameID: gameCodeItem.GameID,
                                        GameName: gameCodeItem.GameName,
                                        GameCategoryCode: gameCodeItem.GameCategoryCode,
                                        GameCategorySubCode: gameCodeItem.GameCategorySubCode,
                                        GameAccountingCode: gameCodeItem.GameAccountingCode,
                                        AllowDemoPlay: gameCodeItem.AllowDemoPlay,
                                        RTPInfo: gameCodeItem.RTPInfo,
                                        IsHot: gameCodeItem.IsHot,
                                        IsNew: gameCodeItem.IsNew,
                                        IsFavo: 0,
                                        IsPlayed: 0,
                                        ChampionType: ChampionType,
                                        SortIndex: gameCodeItem.SortIndex,
                                        Tags: tags,
                                        Language: gameCodeItem.Language,
                                        RTP: gameCodeItem.RTP,
                                        FavoTimeStamp: null,
                                        PlayedTimeStamp: null
                                    };


                                    try {
                                        objectStore.put(InsertData);
                                        objectCategoryStore.put({
                                            GameBrand: InsertData.GameBrand,
                                            GameCategoryCode: InsertData.GameCategoryCode
                                        });

                                        workerSelf.SyncEventData.NowGameID = gameCodeItem.GameID;
                                        workerSelf.SyncEventData.NowTimeStamp = gameCodeItem.UpdateTimestamp;

                                        if (workerSelf.SyncEventData.LastTimeStamp == workerSelf.SyncEventData.NowTimeStamp && workerSelf.SyncEventData.NowGameID == workerSelf.SyncEventData.LastGameID) {
                                            let syncData = {
                                                SyncID: 1,
                                                GameID: gameCodeItem.GameID,
                                                TimeStamp: gameCodeItem.UpdateTimestamp,
                                                LastUpdateDate: new Date().toISOString(),
                                                StatusText: "Finish"
                                            };

                                            console.log("SyncFinish");
                                            //console.log(syncData);

                                            objectSyncStore.put(syncData);

                                        } else {
                                            let syncData = {
                                                SyncID: 1,
                                                GameID: gameCodeItem.GameID,
                                                TimeStamp: gameCodeItem.UpdateTimestamp,
                                                LastUpdateDate: new Date().toISOString(),
                                                StatusText: "Continue"
                                            };

                                            console.log("SyncContinue");
                                            //console.log(syncData);
                                            objectSyncStore.put(syncData);
                                        }
                                    } catch (e) {
                                        workerSelf.SyncEventData.NowGameID = gameCodeItem.GameID;
                                        workerSelf.SyncEventData.NowTimeStamp = gameCodeItem.UpdateTimestamp;
                                        workerSelf.SyncFaliure();
                                        break;
                                    }
                                }

                                transaction.oncomplete = function (event) {
                                    if (workerSelf.SyncEventData.LastTimeStamp == workerSelf.SyncEventData.NowTimeStamp && workerSelf.SyncEventData.NowGameID == workerSelf.SyncEventData.LastGameID) {
                                        console.log("hasSyncing, SyncSuccess");
                                        workerSelf.SyncSuccess(true);
                                    } else {
                                        workerSelf.RecursiveSyncGameCode();
                                    }
                                };
                            }
                        } else {
                            workerSelf.SyncFaliure();
                        }
                    } else {
                        workerSelf.SyncFaliure();
                    }
                }
            });
        };


    };

    this.Start = function () {
        //分為兩部分進行
        //1.indexDB 處理GameCode事務
        //2.處理分類事務

        //indexDB init
        self.indexedDB = self.indexedDB || self.mozIndexedDB || self.webkitIndexedDB || self.msIndexedDB;
        self.IDBTransaction = self.IDBTransaction || self.webkitIDBTransaction || self.msIDBTransaction;
        self.IDBKeyRange = self.IDBKeyRange || self.webkitIDBKeyRange || self.msIDBKeyRange;

        workerSelf.Sync();
    };
    //#endregion
};
//#endregion
