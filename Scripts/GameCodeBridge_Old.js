var GameCodeBridge = function (version, url, langUrl, second, loadedEvent) {
    var myWorker
    this.CtList = null;
    this.SearchCore = null;
    this.LangDic = null;

    this.FirstLoaded = false;
    this.SearchGameCodeByLang = function (lang, searchText, gameBrand, gameCategoryCode) {
        let Ret = [];
        let findCharList;
        let langTemp;
        //find GameID

        if (gameBrand) {
            let targetBrand = this.SearchCore.SearchDic.Brands.find(x => x.GameBrand == gameBrand);

            if (targetBrand) {
                langTemp = targetBrand.Langs[lang];

            } else {
                langTemp = this.SearchCore.SearchDic.Langs[lang];
            }
        } else {
            langTemp = this.SearchCore.SearchDic.Langs[lang];
        }

        if (langTemp) {
            findCharList = langTemp[searchText[0]];

            if (findCharList) {
                for (var i = 0; i < findCharList.length; i++) {
                    // gameID + 
                    let charObj = findCharList[i];
                    if (charObj.TargetValue.indexOf(searchText) != -1) {
                        let IndexOne = Math.trunc(charObj.GameID / 100);
                        let IndexTwo = charObj.GameID % 100;
                        let gameCodeObj = this.SearchCore.GameList.Slices[IndexOne][IndexTwo];

                        if (gameCategoryCode) {
                            if (gameCodeObj.GameCategoryCode == gameCategoryCode) {
                                Ret.push(gameCodeObj);
                            }
                        } else {
                            Ret.push(gameCodeObj);
                        }
                    }
                }
            }
        }

        return Ret;
    }
    this.SearchGameCodeByBrand = function (gameBrand, gameCategoryCode) {
        let Ret = [];
        //find GameID

        let targetBrand = this.SearchCore.SearchDic.Brands.find(x => x.GameBrand == gameBrand);

        if (targetBrand) {
            for (var i = 0; i < targetBrand.AllGame.length; i++) {
                // gameID + 
                let gameID = targetBrand.AllGame[i];
                let IndexOne = Math.trunc(gameID / 100);
                let IndexTwo = gameID % 100;
                let gameCodeObj = this.SearchCore.GameList.Slices[IndexOne][IndexTwo];

                if (gameCategoryCode) {
                    if (gameCodeObj.GameCategoryCode == gameCategoryCode) {
                        Ret.push(gameCodeObj);
                    }
                } else {
                    Ret.push(gameCodeObj);
                }
            }
        }
        

        return Ret;
    }
    this.SearchGameCtByBrand = function (gameBrand) {
        let Ret = [];
        //find GameID

        let targetBrand = this.SearchCore.SearchDic.Brands.find(x => x.GameBrand == gameBrand);


        if (targetBrand) {
            Ret = targetBrand.GameCtList;
        }

        return Ret;
    }


    this.OtherFindGameCodeText = function (lang, GameCode) {
        for (var i = 0; i < this.LangDic.length; i++) {
            var langData = this.LangDic[i];
            if (langData.type == "GameCode") {
                return langData.Data[GameCode];
            }
        }
    }

    this.OtherFindGameBrandText = function (lang, GameBrand) {
        for (var i = 0; i < this.LangDic.length; i++) {
            var langData = this.LangDic[i];
            if (langData.type == "GameBrand") {
                return langData.Data[GameBrand];
            }
        }
    }

    this.GetGameText = function (lang, gameCode) {
        let Ret = "";
        let splitIndex = gameCode.indexOf(".");
        if (splitIndex != -1) {
            let gameBrand = gameCode.substring(0, splitIndex);
            let gameName = gameCode.substring(splitIndex + 1, gameCode.length);
            let targetBrand = this.SearchCore.SearchDic.Brands.find(x => x.GameBrand == gameBrand);

            if (targetBrand) {
                let findCharList = targetBrand.GameNameIndex[gameName[0]];

                if (findCharList) {
                    for (var i = 0; i < findCharList.length; i++) {
                        // gameID + 
                        let charObj = findCharList[i];
                        if (charObj.TargetValue == gameName) {
                            let IndexOne = Math.trunc(charObj.GameID / 100);
                            let IndexTwo = charObj.GameID % 100;
                            let gameCodeObj = this.SearchCore.GameList.Slices[IndexOne][IndexTwo];

                            Ret = gameCodeObj.GameText[lang];
                        }
                    }
                }
            }            
        }

        return Ret;
    }

    this.GetBrandText = function (lang, gameBrand) {
        let Ret = "";

        let targetBrand = this.SearchCore.SearchDic.Brands.find(x => x.GameBrand == gameBrand);

        if (targetBrand) {
            Ret = targetBrand.BrandText[lang];
        }

        return Ret;
    }

    this.GetGameCode = function (gameID) {
        let IndexOne = Math.trunc(gameID / 100);
        let IndexTwo = gameID % 100;
        return this.SearchCore.GameList.Slices[IndexOne][IndexTwo];
    }
    this.GetCategories = function (loactions) {
        let Ret;
        let CtList = this.CtList;
        if (loactions) {
            Ret = [];

            for (var i = 0; i < CtList.length; i++) {
                if (CtList[i].Location.includes(loactions)) {
                    Ret.push(CtList[i]);
                }
            }
        } else {
            Ret = CtList;
        }

        return Ret;
    }
    this.GetCategory = function (loaction) {

        let Ret;
        let CtList = this.CtList;
        for (var i = 0; i < CtList.length; i++) {
            if (loaction == CtList[i].Location) {
                Ret = CtList[i];
                break;
            }
        }

        return Ret;
    }
    this.onCtListChange;
    this.onFirstLoaded = loadedEvent;
    this.init = function () {

        //#region SetStorage

        let timeStamp = 0;
        let ctStr = localStorage.getItem("GCB_Ct");
        let coreStr = localStorage.getItem("GCB_Core");
        let langStr = localStorage.getItem("GCB_LangDic");

        timeStamp = Number(localStorage.getItem("GCB_timeStamp"));
        if (timeStamp != NaN && timeStamp != 0) {
            this.SearchCore = JSON.parse(coreStr);
            this.CtList = JSON.parse(ctStr);
            this.LangDic = JSON.parse(langStr);
            this.FirstLoaded = true;
        }
        //#endregion 

        myWorker = new Worker("/Scripts/worker.js");


        myWorker.postMessage({
            Cmd: "Init",
            Params: [version, url, langUrl, second, timeStamp]
        });

        myWorker.onmessage = (function (e) {
            if (e.data) {
                switch (e.data.Cmd) {
                    case "RefreshCtList":
                        let ctResult = e.data.Data;
                        this.CtList = ctResult.CtList;

                        if (this.FirstLoaded == false) {
                            if (this.CtList != null && this.SearchCore != null) {
                                if (this.onFirstLoaded) {
                                    this.onFirstLoaded();
                                }
                                this.FirstLoaded = true;
                                localStorage.setItem("GCB_timeStamp", ctResult.TimeStamp);
                            }
                        }

                        if (this.onCtListChange) {
                            this.onCtListChange(this.CtList);
                        }

                        localStorage.setItem("GCB_Ct", JSON.stringify(this.CtList));


                        break;

                    case "RefreshDic":
                        let SearchResult = e.data.Data;
                        this.SearchCore = SearchResult.SearchCore;

                        if (this.FirstLoaded == false) {
                            if (this.CtList != null && this.SearchCore != null) {
                                if (this.onFirstLoaded) {
                                    this.onFirstLoaded();
                                }
                                this.FirstLoaded = true;
                                localStorage.setItem("GCB_timeStamp", SearchResult.TimeStamp);
                            }
                        }



                        localStorage.setItem("GCB_Core", JSON.stringify(this.SearchCore));


                        break;
                    case "LangsLoaded":
                        this.LangDic = e.data.Data;


                        localStorage.setItem("GCB_LangDic", JSON.stringify(this.LangDic));


                        break;
                    default:
                        break;
                }
            }
        }).bind(this);
    }

    this.init();
}