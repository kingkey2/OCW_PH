<%@ Page Language="C#" AutoEventWireup="true" CodeFile="UserAccount_Add_Casino.aspx.cs" Inherits="UserAccount_Add_Casino" %>

<%
%>
<!doctype html>
<html lang="zh-Hant-TW" class="innerHtml">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <title>代理網</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="css/basic.min.css?<%=DateTime.Now.ToString("yyyyMMddHHmmss") %>">
    <link rel="stylesheet" href="css/main.css?<%=DateTime.Now.ToString("yyyyMMddHHmmss") %>">
    <link rel="stylesheet" href="css/layoutADJ.css?<%=DateTime.Now.ToString("yyyyMMddHHmmss") %>">
</head>
<script type="text/javascript" src="/Scripts/Common.js?20191127"></script>
<script type="text/javascript" src="/Scripts/UIControl.js"></script>
<script type="text/javascript" src="Scripts/MultiLanguage.js"></script>
<script type="text/javascript" src="/Scripts/Math.uuid.js"></script>
<script type="text/javascript" src="/Scripts/bignumber.min.js"></script>
<script type="text/javascript" src="/Scripts/SelectItem.js"></script>
<script type="text/javascript" src="js/AgentCommon.js"></script>
<script type="text/javascript">
    var c = new common();
    var ac = new AgentCommon();
    var ApiUrl = "UserAccount_Add_Casino.aspx";
    var mlp;
    var lang;
    var EWinInfo;
    var parentObj;
    var timerChkUserAccount;
    var uType;
    var processing = false;
    var GetCompanyPermissionGroup;
    //function btnSubmit() {
    //    checkFormData(function () {
    //        updateUserInfo();
    //    });
    //}

    function getQBetLimitCount(currencyType) {
        var QBetLimitList = document.getElementById("QBetLimitList");
        var div_CurrencyType;
        var elInputList;
        var count = 0;
        var canAssignType = false;

        elInputList = QBetLimitList.getElementsByClassName("BetLimitID");
        div_CurrencyType = QBetLimitList.getElementsByClassName("div_CurrencyType");
        for (var i = 0; i < elInputList.length; i++) {
            var el = elInputList[i];
            canAssignType = false;

            switch (uType) {
                case 0:
                    if (div_CurrencyType[i].getAttribute("assigntype") == "0") {
                        canAssignType = true;
                    }
                    break;
                case 1:
                    if (div_CurrencyType[i].getAttribute("assigntype") == "0" || div_CurrencyType[i].getAttribute("assigntype") == "1") {
                        canAssignType = true;
                    }
                    break;
            }

            if (canAssignType == true) {
                if (el.tagName.toUpperCase() == "INPUT".toUpperCase()) {
                    if (el.checked == true) {
                        if (el.getAttribute("CurrencyType") == currencyType) {
                            count++;
                        }
                    }
                }
            }
        }

        return count;
    }

    function getNBetLimitCount(currencyType) {
        var NBetLimitList = document.getElementById("NBetLimitList");
        var div_CurrencyType;
        var elInputList;
        var count = 0;
        var canAssignType = false;

        elInputList = NBetLimitList.getElementsByClassName("BetLimitID")
        div_CurrencyType = NBetLimitList.getElementsByClassName("div_CurrencyType");
        for (var i = 0; i < elInputList.length; i++) {
            var el = elInputList[i];
            canAssignType = false;

            switch (uType) {
                case 0:
                    if (div_CurrencyType[i].getAttribute("assigntype") == "0") {
                        canAssignType = true;
                    }
                    break;
                case 1:
                    if (div_CurrencyType[i].getAttribute("assigntype") == "0" || div_CurrencyType[i].getAttribute("assigntype") == "1") {
                        canAssignType = true;
                    }
                    break;
            }

            if (canAssignType == true) {
                if (el.tagName.toUpperCase() == "INPUT".toUpperCase()) {
                    if (el.checked == true) {
                        if (el.getAttribute("CurrencyType") == currencyType) {
                            count++;
                        }
                    }
                }
            }

        }

        return count;
    }

    function checkFormData() {
        var retValue = true;
        var chkMessage = "";
        var form = document.forms[0];
        var eWinBACPoint = false;

        if (form.LoginPassword.value != "") {
            if (form.LoginPassword.value != form.LoginPassword2.value) {
                window.parent.API_ShowMessageOK(mlp.getLanguageKey("錯誤"), mlp.getLanguageKey("登入密碼二次驗證失敗"));
                retValue = false;
            }
        }

        // 檢查所有錢包數值
        for (var i = 0; i < idPointList.children.length; i++) {
            var el = idPointList.children[i];
            
            if (el.hasAttribute("currencyType")) {
                var btnPointNew = c.getFirstClassElement(el, "btnPointNew");

                //有啟用錢包
                if (btnPointNew.getAttribute("btnType") == "cancel") {
                    //eWin百家樂
                    if (btnPointNew.getAttribute("btnGameCode") == "eWinBAC") {
                        var currencyType = el.getAttribute("currencyType");
                        //var pointState = c.getFirstClassElement(el, "PointState");
                        var pointUserRate = c.getFirstClassElement(el, "PointUserRate");
                        var pointBuyChipRate = c.getFirstClassElement(el, "PointBuyChipRate");

                        //if (pointState.options[pointState.selectedIndex].value == "0") {
                        var agentWallet = window.parent.API_GetCurrencyType(currencyType);

                        eWinBACPoint = true;
                        if (isNaN(pointUserRate.value) == true || isNaN(pointBuyChipRate.value) == true) {
                            window.parent.API_ShowMessageOK(mlp.getLanguageKey("錯誤"), currencyType + " " + mlp.getLanguageKey("佔成/轉碼請輸入正確數字"));
                            retValue = false;
                            break;
                        }


                        if ((pointUserRate.value != "") && (pointUserRate.value != null)) {
                            if ((Number(pointUserRate.value) > agentWallet.UserRate) || Number(pointUserRate.value) < 0) {
                                window.parent.API_ShowMessageOK(mlp.getLanguageKey("錯誤"), currencyType + " " + mlp.getLanguageKey("佔成可接受範圍為") + " 0 - " + agentWallet.UserRate);
                                retValue = false;
                                break;
                            }

                        } else {
                            window.parent.API_ShowMessageOK(mlp.getLanguageKey("錯誤"), currencyType + " " + mlp.getLanguageKey("佔成率不可空白"));
                            retValue = false;
                            break;
                        }

                        if ((pointBuyChipRate.value != "") || (pointBuyChipRate.value != null)) {
                            if (Number(pointBuyChipRate.value) < 0) {
                                window.parent.API_ShowMessageOK(mlp.getLanguageKey("錯誤"), currencyType + " " + mlp.getLanguageKey("轉碼不可負數"));
                                retValue = false;
                                break;
                            }
                            else {
                                switch (EWinInfo.CompanyInfo.DownlineBuyChipRateType) {
                                    case 0:
                                        //不允許下線轉碼率設定高於上線
                                        if (Number(agentWallet.BuyChipRate) < Number(pointBuyChipRate.value)) {
                                            window.parent.API_ShowMessageOK(mlp.getLanguageKey("錯誤"), currencyType + " " + mlp.getLanguageKey("下線轉碼率不可高於上線"));
                                            retValue = false;
                                            break;
                                        }
                                        break;
                                    case 1:
                                        //允許設定高於上線
                                        if (Number(agentWallet.BuyChipRate) < Number(pointBuyChipRate.value)) {
                                            if (chkMessage == "") {
                                                chkMessage = currencyType + " " + mlp.getLanguageKey("轉碼數超過上線,用戶須自行承擔差額,確定要繼續嗎?");
                                            }
                                            else {
                                                chkMessage = chkMessage + "<br/>" + currencyType + " " + mlp.getLanguageKey("轉碼數超過上線,用戶須自行承擔差額,確定要繼續嗎?");
                                            }
                                            break;
                                        }
                                        break;
                                    case 2:
                                        //代理佔成時才允許下線碼佣高於代理
                                        if (Number(agentWallet.UserRate) > 0) {
                                            if (Number(agentWallet.BuyChipRate) < Number(pointBuyChipRate.value)) {
                                                window.parent.API_ShowMessageOK(mlp.getLanguageKey("錯誤"), currencyType + " " + mlp.getLanguageKey("下線轉碼率不可高於上線"));
                                                retValue = false;
                                                break;
                                            }
                                        }
                                        break;
                                }
                            }

                        } else {
                            window.parent.API_ShowMessageOK(mlp.getLanguageKey("錯誤"), currencyType + " " + mlp.getLanguageKey("轉碼率不可空白"));
                            retValue = false;
                            break;
                        }
                        //}

                        if ((EWinInfo.CompanyInfo.BetLimitCount > 0) || (EWinInfo.CompanyInfo.BetLimitMin > 0)) {
                            //if (UserObj.UserAccountType == 0) {
                            //確認公司是否有快速電投限紅
                            if (parentObj.WalletList) {
                                for (var j = 0; j < parentObj.WalletList.length; j++) {
                                    if (parentObj.WalletList[j].CurrencyType == currencyType) {
                                        if (parentObj.WalletList[j].CompanyQBetLimitCount > 0) {
                                            if (((getQBetLimitCount(currencyType) >= EWinInfo.CompanyInfo.BetLimitMin) && (EWinInfo.CompanyInfo.BetLimitMin != 0)) && ((getQBetLimitCount(currencyType) <= EWinInfo.CompanyInfo.BetLimitCount) && (EWinInfo.CompanyInfo.BetLimitCount != 0))) {
                                                //Nothing;
                                            }
                                            else {
                                                window.parent.API_ShowMessageOK(mlp.getLanguageKey("錯誤"), currencyType + " " + mlp.getLanguageKey("快速電投限紅可選擇的數量") + ":" + " " + EWinInfo.CompanyInfo.BetLimitMin + "~" + EWinInfo.CompanyInfo.BetLimitCount);
                                                retValue = false;
                                                break;
                                            }
                                        }
                                    }
                                }
                            }

                            //確認公司是否有網投限紅
                            if (parentObj.WalletList) {
                                for (var j = 0; j < parentObj.WalletList.length; j++) {
                                    if (parentObj.WalletList[j].CurrencyType == currencyType) {
                                        if (parentObj.WalletList[j].CompanyNBetLimitCount > 0) {
                                            if (((getNBetLimitCount(currencyType) >= EWinInfo.CompanyInfo.BetLimitMin) && (EWinInfo.CompanyInfo.BetLimitMin != 0)) && ((getNBetLimitCount(currencyType) <= EWinInfo.CompanyInfo.BetLimitCount) && (EWinInfo.CompanyInfo.BetLimitCount != 0))) {
                                                //Nothing
                                            }
                                            else {
                                                window.parent.API_ShowMessageOK(mlp.getLanguageKey("錯誤"), currencyType + " " + mlp.getLanguageKey("網投限紅可選擇的數量") + ":" + " " + EWinInfo.CompanyInfo.BetLimitMin + "~" + EWinInfo.CompanyInfo.BetLimitCount);
                                                retValue = false;
                                                break;
                                            }
                                        }
                                    }
                                }
                            }
                            //}
                        }                       
                    }
                    else {
                        //其它遊戲
                        var currencyType = el.getAttribute("currencyType");
                        var pointUserRate = c.getFirstClassElement(el, "PointUserRate");
                        var pointBuyChipRate = c.getFirstClassElement(el, "PointBuyChipRate");
                        var agentGameUserRate = 0;
                        var agentGameBuyChipRate = 0;

                        if (isNaN(pointUserRate.value) == true || isNaN(pointBuyChipRate.value) == true) {
                            window.parent.API_ShowMessageOK(mlp.getLanguageKey("錯誤"), btnPointNew.getAttribute("btnGameCode") + "-" + currencyType + " " + mlp.getLanguageKey("佔成/轉碼請輸入正確數字"));
                            retValue = false;
                            break;
                        }

                        for (var j = 0; j < EWinInfo.UserInfo.GameCodeList.length; j++) {
                            if (EWinInfo.UserInfo.GameCodeList[j].CurrencyType == currencyType) {
                                if (EWinInfo.UserInfo.GameCodeList[j].GameAccountingCode == btnPointNew.getAttribute("btnGameCode")) {
                                    agentGameUserRate = EWinInfo.UserInfo.GameCodeList[j].UserRate;
                                    agentGameBuyChipRate = EWinInfo.UserInfo.GameCodeList[j].BuyChipRate;
                                }
                            }
                        }

                        if ((pointUserRate.value != "") && (pointUserRate.value != null)) {
                            if ((Number(pointUserRate.value) > agentGameUserRate) || Number(pointUserRate.value) < 0) {
                                window.parent.API_ShowMessageOK(mlp.getLanguageKey("錯誤"), btnPointNew.getAttribute("btnGameCode") + "-" + currencyType + " " + mlp.getLanguageKey("佔成可接受範圍為") + " 0 - " + agentGameUserRate);
                                retValue = false;
                                break;
                            }
                        } else {
                            window.parent.API_ShowMessageOK(mlp.getLanguageKey("錯誤"), btnPointNew.getAttribute("btnGameCode") + "-" + currencyType + " " + mlp.getLanguageKey("佔成率不可空白"));
                            retValue = false;
                            break;
                        }

                        if ((pointBuyChipRate.value != "") || (pointBuyChipRate.value != null)) {
                            if (Number(pointBuyChipRate.value) < 0) {
                                window.parent.API_ShowMessageOK(mlp.getLanguageKey("錯誤"), btnPointNew.getAttribute("btnGameCode") + "-" + currencyType + " " + mlp.getLanguageKey("轉碼不可負數"));
                                retValue = false;
                                break;
                            }
                            else {
                                switch (EWinInfo.CompanyInfo.DownlineBuyChipRateType) {
                                    case 0:
                                        //不允許下線轉碼率設定高於上線
                                        if (Number(agentGameBuyChipRate) < Number(pointBuyChipRate.value)) {
                                            window.parent.API_ShowMessageOK(mlp.getLanguageKey("錯誤"), btnPointNew.getAttribute("btnGameCode") + "-" + currencyType + " " + mlp.getLanguageKey("下線轉碼率不可高於上線"));
                                            retValue = false;
                                            break;
                                        }
                                        break;
                                    case 1:
                                        //允許設定高於上線
                                        if (Number(agentGameBuyChipRate) < Number(pointBuyChipRate.value)) {
                                            if (chkMessage == "") {
                                                chkMessage = btnPointNew.getAttribute("btnGameCode") + "-" + currencyType + " " + mlp.getLanguageKey("轉碼數超過上線,用戶須自行承擔差額,確定要繼續嗎?");
                                            }
                                            else {
                                                chkMessage = chkMessage + "<br/>" + btnPointNew.getAttribute("btnGameCode") + "-" + currencyType + " " + mlp.getLanguageKey("轉碼數超過上線,用戶須自行承擔差額,確定要繼續嗎?");
                                            }
                                            break;
                                        }
                                        break;
                                    case 2:
                                        //代理佔成時才允許下線碼佣高於代理
                                        if (Number(agentGameUserRate) > 0) {
                                            if (Number(agentGameBuyChipRate) < Number(pointBuyChipRate.value)) {
                                                window.parent.API_ShowMessageOK(mlp.getLanguageKey("錯誤"), btnPointNew.getAttribute("btnGameCode") + "-" + currencyType + " " + mlp.getLanguageKey("下線轉碼率不可高於上線"));
                                                retValue = false;
                                                break;
                                            }
                                        }
                                        break;
                                }
                            }

                        } else {
                            window.parent.API_ShowMessageOK(mlp.getLanguageKey("錯誤"), btnPointNew.getAttribute("btnGameCode") + "-" + currencyType + " " + mlp.getLanguageKey("轉碼率不可空白"));
                            retValue = false;
                            break;
                        }
                    }
                }
            }
        }

        if (retValue == true) {
            if (eWinBACPoint == true) {
                checkAccountExist(form.LoginAccount.value, function (accountExist) {
                    if (accountExist == true) {
                        if (chkMessage != "") {
                            window.parent.API_ShowMessage(mlp.getLanguageKey("警告"), chkMessage, function () {
                                updateUserInfo();
                            }, null);
                        }
                        else {
                            updateUserInfo();
                        }

                    } else {
                        window.parent.API_ShowMessageOK(mlp.getLanguageKey("錯誤"), mlp.getLanguageKey("登入帳號已存在"));
                    }
                });
            }
            else {
                window.parent.API_ShowMessageOK(mlp.getLanguageKey("錯誤"), mlp.getLanguageKey("至少需新增一組Ewin百家樂錢包"));
            }
        }
    }

    function chkUserAccount(el) {
        window.clearTimeout(timerChkUserAccount);
        document.getElementById("idLoginAccount").classList.remove("iconError");
        document.getElementById("idLoginAccount").classList.remove("iconErrorAnim");
        document.getElementById("idLoginAccount").classList.remove("iconCheck");
        document.getElementById("idLoginAccount").classList.remove("iconCheckAnim");
        document.getElementsByClassName("icon-loading")[0].style.display = "none";
        if (el.value.trim() != "") {
            document.getElementsByClassName("icon-loading")[0].style.display = "";
        }
        timerChkUserAccount = window.setTimeout(function () {
            if (el.value.trim() != "") {

                checkAccountExist(el.value, function (retValue) {
                    document.getElementsByClassName("icon-loading")[0].style.display = "none";
                    if (retValue == true) {
                        document.getElementById("idLoginAccount").classList.remove("iconError");
                        document.getElementById("idLoginAccount").classList.remove("iconErrorAnim");

                        document.getElementById("idLoginAccount").classList.add("iconCheck");
                        document.getElementById("idLoginAccount").classList.add("iconCheckAnim");
                    }
                    else {
                        document.getElementById("idLoginAccount").classList.remove("iconCheck");
                        document.getElementById("idLoginAccount").classList.remove("iconCheckAnim");

                        document.getElementById("idLoginAccount").classList.add("iconError");
                        document.getElementById("idLoginAccount").classList.add("iconErrorAnim");
                    }
                })
            }

        }, 2000)
    }

    function checkAccountExist(loginAccount, cb) {
        var postObj;

        postObj = {
            AID: EWinInfo.ASID,
            LoginAccount: loginAccount
        };

        c.callService(ApiUrl + "/CheckAccountExist", postObj, function (success, o) {
            if (success) {
                var obj = c.getJSON(o);

                if (obj.Result == 0) {
                    if (cb)
                        cb(true);
                } else {
                    if (obj.Message == "AccountExist") {
                        if (cb)
                            cb(false);
                    } else {
                        window.parent.API_ShowMessageOK(mlp.getLanguageKey("錯誤"), obj.Message);
                    }
                }
            } else {
                if (o == "Timeout") {
                    window.parent.API_ShowMessageOK(mlp.getLanguageKey("錯誤"), mlp.getLanguageKey("網路異常, 請稍後重新嘗試"));
                } else {
                    window.parent.API_ShowMessageOK(mlp.getLanguageKey("錯誤"), o);
                }
            }
        });
    }

    function queryCurrentUserInfo() {
        var postObj;

        postObj = {
            AID: EWinInfo.ASID
        };

        c.callService(ApiUrl + "/QueryCurrentUserInfo", postObj, function (success, o) {
            if (success) {
                var obj = c.getJSON(o);

                if (obj.Result == 0) {
                    parentObj = obj;
                    updateBaseInfo(obj);

                } else {
                    window.parent.API_ShowMessageOK(mlp.getLanguageKey("錯誤"), obj.Message);
                }
            } else {
                if (o == "Timeout") {
                    window.parent.API_ShowMessageOK(mlp.getLanguageKey("錯誤"), mlp.getLanguageKey("網路異常, 請稍後重新嘗試"));
                } else {
                    window.parent.API_ShowMessageOK(mlp.getLanguageKey("錯誤"), o);
                }
            }

            window.parent.API_CloseLoading();
        });
    }

    function updateUserInfo() {
        var form = document.forms[0];
        var userList = [];
        var postObj;
        var idPointList = document.getElementById("idPointList");
        var QBetLimitList = document.getElementById("QBetLimitList");
        var NBetLimitList = document.getElementById("NBetLimitList");
        //var UserAccountType = document.getElementsByName("UserAccountType");
        //var iUserAccountType = 0;
        var AllowPayment = 0;
        var AllowServiceChat = 0;

        //if (UserAccountType[0].checked == true)
        //    iUserAccountType = 1;

        if (processing == false) {

            // 建立用戶更新物件
            if ((form.LoginPassword.value != "") && (form.LoginPassword.value != null))
                userList[userList.length] = { Name: "LoginPassword", Value: form.LoginPassword.value };

            //userList[userList.length] = { Name: "UserAccountType", Value: iUserAccountType };
            userList[userList.length] = { Name: "UserAccountType", Value: uType };
            userList[userList.length] = { Name: "UserAccountState", Value: 0 };
            userList[userList.length] = { Name: "RealName", Value: form.RealName.value };
            userList[userList.length] = { Name: "ContactPhonePrefix", Value: form.ContactPhonePrefix.options[form.ContactPhonePrefix.selectedIndex].value };
            userList[userList.length] = { Name: "ContactPhoneNumber", Value: form.ContactPhoneNumber.value };

            if (EWinInfo) {
                //確定公司是否允許
                if (EWinInfo.CompanyInfo) {
                    if (EWinInfo.CompanyInfo.PaymentGPay != 0) {
                        if (parentObj) {
                            //確定上線是否可用金流
                            if (parentObj.AllowPayment == 1) {
                                AllowPayment = 1;
                            }
                        }
                    }
                    if (EWinInfo.CompanyInfo.ServiceChatType == 1) {
                        if (parentObj) {
                            //確定上線是否可用客服
                            if (parentObj.AllowServiceChat == 1) {
                                AllowServiceChat = 1;
                            }
                        }
                    }
                }
            }

            userList[userList.length] = { Name: "AllowPayment", Value: AllowPayment };
            userList[userList.length] = { Name: "AllowServiceChat", Value: AllowServiceChat };



            //if (form.AllowPayment.checked == true) {
            //    userList[userList.length] = { Name: "AllowPayment", Value: "1" };
            //} else {
            //    userList[userList.length] = { Name: "AllowPayment", Value: "0" };
            //}

            //if (form.AllowServiceChat.checked == true) {
            //    userList[userList.length] = { Name: "AllowServiceChat", Value: "1" };
            //} else {
            //    userList[userList.length] = { Name: "AllowServiceChat", Value: "0" };
            //}

            userList[userList.length] = { Name: "AllowBet", Value: 3 };

            // 建立錢包更新物件
            for (var i = 0; i < idPointList.children.length; i++) {
                var el = idPointList.children[i];

                if (el.hasAttribute("currencyType")) {
                    var btnPointNew = c.getFirstClassElement(el, "btnPointNew");
                    if (btnPointNew.getAttribute("btnType") == "cancel") {
                        if (btnPointNew.getAttribute("btnGameCode") == "eWinBAC") {
                            var currencyType = el.getAttribute("currencyType");
                            //var pointState = c.getFirstClassElement(el, "PointState");
                            var PointStateSelect;
                            var pointUserRate = c.getFirstClassElement(el, "PointUserRate");
                            var pointBuyChipRate = c.getFirstClassElement(el, "PointBuyChipRate");
                            var w;

                            //錢包預設為開啟
                            //PointStateSelect = pointState.options[pointState.selectedIndex].value
                            PointStateSelect = 0;

                            w = {
                                CurrencyType: currencyType,
                                PointState: PointStateSelect,
                                UserRate: pointUserRate.value,
                                BuyChipRate: pointBuyChipRate.value
                            }

                            userList[userList.length] = {
                                Name: "Wallet",
                                Value: JSON.stringify(w)
                            };
                        }
                        else {
                            var currencyType = el.getAttribute("currencyType");
                            var PointStateSelect = 0;
                            var pointUserRate = c.getFirstClassElement(el, "PointUserRate");
                            var pointBuyChipRate = c.getFirstClassElement(el, "PointBuyChipRate");
                            var g;


                            g = {
                                CurrencyType: currencyType,
                                PointState: PointStateSelect,
                                UserRate: pointUserRate.value,
                                BuyChipRate: pointBuyChipRate.value,
                                GameAccountingCode: btnPointNew.getAttribute("btnGameCode")
                            }

                            userList[userList.length] = {
                                Name: "GameCodeList",
                                Value: JSON.stringify(g)
                            };
                        }
                    }
                }
            }

            // 建立限紅物件
            for (var i = 0; i < QBetLimitList.children.length; i++) {
                var el = QBetLimitList.children[i];

                if (el.hasAttribute("BetLimitID")) {
                    var assignType = el.getAttribute("assigntype");
                    var betLimitID = c.getFirstClassElement(el, "BetLimitID");

                    if (betLimitID.checked == true) {
                        var canAssignType = false;

                        switch (uType) {
                            case 0:
                                if (assignType == "0") {
                                    canAssignType = true;
                                }
                                break;
                            case 1:
                                if (assignType == "0" || assignType == "1") {
                                    canAssignType = true;
                                }
                                break;
                        }

                        if (canAssignType == true) {
                            userList[userList.length] = {
                                Name: "QBetLimit",
                                Value: betLimitID.value
                            };
                        }
                    }

                }
            }

            for (var i = 0; i < NBetLimitList.children.length; i++) {
                var el = NBetLimitList.children[i];

                if (el.hasAttribute("BetLimitID")) {
                    var assignType = el.getAttribute("assigntype");
                    var betLimitID = c.getFirstClassElement(el, "BetLimitID");

                    if (betLimitID.checked == true) {
                        var canAssignType = false;

                        switch (uType) {
                            case 0:
                                if (assignType == "0") {
                                    canAssignType = true;
                                }
                                break;
                            case 1:
                                if (assignType == "0" || assignType == "1") {
                                    canAssignType = true;
                                }
                                break;
                        }

                        if (canAssignType == true) {
                            userList[userList.length] = {
                                Name: "NBetLimit",
                                Value: betLimitID.value
                            };
                        }

                    }
                }
            }

            postObj = {
                AID: EWinInfo.ASID,
                LoginAccount: form.LoginAccount.value,
                UserField: userList
            }
            processing = true;
            window.parent.API_ShowLoading("Sending");

            c.callService(ApiUrl + "/CreateUserInfo", postObj, function (success, o) {
                if (success) {
                    var obj = c.getJSON(o);

                    if (obj.Result == 0) {
                        window.parent.API_ShowMessageOK(mlp.getLanguageKey("更新完成"), mlp.getLanguageKey("更新完成"), function () {
                            window.parent.API_CloseWindow(true);
                        });
                    } else {
                        window.parent.API_ShowMessageOK(mlp.getLanguageKey("錯誤"), obj.Message);
                        processing = false;
                    }
                } else {
                    if (o == "Timeout") {
                        window.parent.API_ShowMessageOK(mlp.getLanguageKey("錯誤"), mlp.getLanguageKey("網路異常, 請稍後重新嘗試"));
                        processing = false;
                    } else {
                        window.parent.API_ShowMessageOK(mlp.getLanguageKey("錯誤"), o);
                        processing = false;
                    }
                }

                window.parent.API_CloseLoading();
            })

        }
        else {
            window.parent.API_ShowToastMessage(mlp.getLanguageKey("作業進行中"));
        }
    }


    function updateBaseInfo(o) {
        var UserAccountState0 = document.getElementById("UserAccountState0");
        var UserAccountState1 = document.getElementById("UserAccountState1");
        var IsLendChipAccount = document.getElementById("IsLendChipAccount");
        var AllowPayment = document.getElementById("AllowPayment");
        var AllowBet = document.getElementById("AllowBet");
        var AllowServiceChat = document.getElementById("AllowServiceChat");
        var RealName = document.getElementById("RealName");
        var t;
        var btnPointNew;
        var pointUserRate;
        var pointBuyChipRate;
        var btnBitLimit;


        if (o != null) {
            c.setElementText("idCompanyCode", null, o.CompanyCode);
            c.setElementText("ParentLoginAccount", null, o.LoginAccount);


            if (o.IsLendChipAccount) {
                c.setElementText("IsLendChipAccount", null, mlp.getLanguageKey("此帳戶為配碼帳戶"));
                idLendChipAccount.style.display = "block";
            } else {
                idLendChipAccount.style.display = "none";
            }

            if (o.WalletList != null) {
                var idPointList = document.getElementById("idPointList");

                c.clearChildren(idPointList);

                for (var i = 0; i < o.WalletList.length; i++) {
                    if (o.WalletList[i].CurrencyType != EWinInfo.CompanyInfo.DefaultCurrencyType) {
                        continue;
                    }
                    var w = o.WalletList[i];
                    t = c.getTemplate("templateWalletItem");
                    btnPointNew = c.getFirstClassElement(t, "btnPointNew");
                    //var pointState = c.getFirstClassElement(t, "PointState");
                    pointUserRate = c.getFirstClassElement(t, "PointUserRate");
                    pointBuyChipRate = c.getFirstClassElement(t, "PointBuyChipRate");
                    btnBitLimit = c.getFirstClassElement(t, "btnBitLimit");

                    t.setAttribute("currencyType", w.CurrencyType);
                    t.classList.add("eWinBAC");
                    t.classList.add("div_GameCode");
                    c.setClassText(t, "PointCurrencyType", null, w.CurrencyType);


                    // pointUserRate.style.display = "none";
                    // pointBuyChipRate.style.display = "none";
                    pointUserRate.classList.add("input-hidden-default");
                    pointBuyChipRate.classList.add("input-hidden-default");


                    // btnPointNew.style.display = "block";
                    //pointState.style.display = "none";
                    btnBitLimit.style.display = "none";

                    //btnPointNew.setAttribute("btnCurrencyType", w.CurrencyType);
                    btnPointNew.setAttribute("btnGameCode", "eWinBAC");
                    btnPointNew.onclick = new Function("createWallet(this, '" + w.CurrencyType + "')");

                    idPointList.appendChild(t);

                    //多遊戲設定
                    if (EWinInfo.UserInfo.GameCodeList.length > 0) {
                        for (var j = 0; j < EWinInfo.UserInfo.GameCodeList.length; j++) {
                            if (EWinInfo.UserInfo.GameCodeList[j].CurrencyType == w.CurrencyType) {
                                t = c.getTemplate("templateWalletItem");
                                t.style.display = "none";
                                btnPointNew = c.getFirstClassElement(t, "btnPointNew");
                                pointUserRate = c.getFirstClassElement(t, "PointUserRate");
                                pointBuyChipRate = c.getFirstClassElement(t, "PointBuyChipRate");
                                btnBitLimit = c.getFirstClassElement(t, "btnBitLimit");

                                t.setAttribute("currencyType", w.CurrencyType);
                                t.classList.add(EWinInfo.UserInfo.GameCodeList[j].GameAccountingCode);
                                t.classList.add("div_GameCode");
                                c.setClassText(t, "PointCurrencyType", null, w.CurrencyType);

                                pointUserRate.classList.add("input-hidden-default");
                                pointBuyChipRate.classList.add("input-hidden-default");

                                btnBitLimit.style.display = "none";

                                btnPointNew.setAttribute("btnGameCode", EWinInfo.UserInfo.GameCodeList[j].GameAccountingCode);
                                btnPointNew.setAttribute("btnUserRate", EWinInfo.UserInfo.GameCodeList[j].UserRate);
                                btnPointNew.setAttribute("btnBuyChipRate", EWinInfo.UserInfo.GameCodeList[j].BuyChipRate);
                                btnPointNew.onclick = new Function("createWallet(this, '" + w.CurrencyType + "')");
                                idPointList.appendChild(t);
                            } 
                        }
                    }


                } 
            }

            if (o.QBetLimitList != null) {
                var QBetLimitList = document.getElementById("QBetLimitList");
                var div = document.createElement("DIV");

                c.clearChildren(QBetLimitList);

                div.innerHTML = mlp.getLanguageKey("無數據");
                div.style.display = "none";
                div.classList.add("td__content", "td__hasNoData");
                QBetLimitList.classList.add("tbody__hasNoData");
                QBetLimitList.appendChild(div);

                for (var i = 0; i < o.QBetLimitList.length; i++) {
                    var bl = o.QBetLimitList[i];
                    var t = c.getTemplate("templateQBetLimit");
                    var bID;

                    t.setAttribute("BetLimitID", bl.BetLimitID);
                    t.setAttribute("AssignType", bl.AssignType);

                    bID = c.getFirstClassElement(t, "BetLimitID");
                    bID.value = bl.BetLimitID;
                    bID.setAttribute("CurrencyType", bl.CurrencyType);
                    bID.setAttribute("BetLimitType", bl.BetLimitType);
                    bID.classList.add("BetLimitID_" + bl.BetLimitID);

                    bID.onclick = function () {
                        if (this.getAttribute("BetLimitType") == "2") {
                            bCheckBtn = document.getElementsByClassName("BetLimitID_" + this.value);
                            for (i = 0; i < bCheckBtn.length; i++) {
                                bCheckBtn[i].checked = this.checked;
                            }
                        }
                    }

                    t.setAttribute("CurrencyType", bl.CurrencyType);

                    c.setClassText(t, "CurrencyType", null, bl.CurrencyType + ": " + bl.UserBalance);
                    c.setClassText(t, "BetLimitB", null, bl.MinBetBanker + " - " + bl.MaxBet);
                    c.setClassText(t, "BetLimitP", null, bl.MinBetPlayer + " - " + bl.MaxBet);
                    c.setClassText(t, "BetLimitT", null, bl.MinBetTie + " - " + bl.MaxBetTie);
                    c.setClassText(t, "BetLimitPair", null, bl.MinBetPair + " - " + bl.MaxBetPair);

                    QBetLimitList.appendChild(t);
                }
            }


            if (o.NBetLimitList != null) {
                var NBetLimitList = document.getElementById("NBetLimitList");
                var div = document.createElement("DIV");

                c.clearChildren(NBetLimitList);

                div.innerHTML = mlp.getLanguageKey("無數據");
                div.style.display = "none";
                div.classList.add("td__content", "td__hasNoData");
                NBetLimitList.classList.add("tbody__hasNoData");
                NBetLimitList.appendChild(div);


                for (var i = 0; i < o.NBetLimitList.length; i++) {
                    var bl = o.NBetLimitList[i];
                    var t = c.getTemplate("templateNBetLimit");
                    var bID;

                    t.setAttribute("BetLimitID", bl.BetLimitID);
                    t.setAttribute("AssignType", bl.AssignType);

                    bID = c.getFirstClassElement(t, "BetLimitID");
                    bID.value = bl.BetLimitID;
                    bID.setAttribute("CurrencyType", bl.CurrencyType);
                    bID.setAttribute("BetLimitType", bl.BetLimitType);
                    bID.classList.add("BetLimitID_" + bl.BetLimitID);

                    bID.onclick = function () {
                        if (this.getAttribute("BetLimitType") == "2") {
                            bCheckBtn = document.getElementsByClassName("BetLimitID_" + this.value);
                            for (i = 0; i < bCheckBtn.length; i++) {
                                bCheckBtn[i].checked = this.checked;
                            }
                        }
                    }

                    t.setAttribute("CurrencyType", bl.CurrencyType);

                    c.setClassText(t, "CurrencyType", null, bl.CurrencyType + ": " + bl.UserBalance);
                    c.setClassText(t, "BetLimitB", null, bl.MinBetBanker + " - " + bl.MaxBet);
                    c.setClassText(t, "BetLimitP", null, bl.MinBetPlayer + " - " + bl.MaxBet);
                    c.setClassText(t, "BetLimitT", null, bl.MinBetTie + " - " + bl.MaxBetTie);
                    c.setClassText(t, "BetLimitPair", null, bl.MinBetPair + " - " + bl.MaxBetPair);

                    NBetLimitList.appendChild(t);
                }
            }
        }

    }

    function createWallet(o, currencyType) {
        var idPointList = document.getElementById("idPointList");
        var agentWallet = window.parent.API_GetCurrencyType(currencyType);
        var myPointList;

        if (agentWallet != null) {
            myPointList = idPointList.getElementsByClassName(o.getAttribute("btnGameCode"));
            for (var i = 0; i < myPointList.length; i++) {
                var el = myPointList[i];
                if (el.hasAttribute("currencyType")) {
                    if (el.getAttribute("currencyType").toUpperCase() == currencyType.toUpperCase()) {
                        var btnPointNew = c.getFirstClassElement(el, "btnPointNew");
                        //var pointState = c.getFirstClassElement(el, "PointState");
                        var pointUserRate = c.getFirstClassElement(el, "PointUserRate");
                        var pointBuyChipRate = c.getFirstClassElement(el, "PointBuyChipRate");
                        var btnBitLimit = c.getFirstClassElement(el, "btnBitLimit");
                        var span_parentUserRate = c.getFirstClassElement(el, "span_parentUserRate");
                        var span_parentBuyChipRate = c.getFirstClassElement(el, "span_parentBuyChipRate");

                        if (btnPointNew.getAttribute("btnType") == "create") {
                            btnPointNew.setAttribute("btnType", "cancel");
                            btnPointNew.getElementsByClassName("btnText")[0].innerText = mlp.getLanguageKey("取消");

                            // pointUserRate.style.display = "block";
                            // pointBuyChipRate.style.display = "block";
                            pointUserRate.classList.remove("input-hidden-default");
                            pointBuyChipRate.classList.remove("input-hidden-default");

                            if (o.getAttribute("btnGameCode") == "eWinBAC") {
                                btnBitLimit.style.display = "block";
                                c.setClassText(el, "parentBuyChipRate", null, agentWallet.BuyChipRate);
                                c.setClassText(el, "parentUserRate", null, agentWallet.UserRate);
                            }
                            else {
                                c.setClassText(el, "parentBuyChipRate", null, o.getAttribute("btnBuyChipRate"));
                                c.setClassText(el, "parentUserRate", null, o.getAttribute("btnUserRate"));
                            }
                            // span_parentUserRate.style.display = "block";
                            // span_parentBuyChipRate.style.display = "block";

                            //pointUserRate.value = agentWallet.UserRate;
                            //pointBuyChipRate.value = agentWallet.BuyChipRate;
                            pointUserRate.value = 0;
                            pointBuyChipRate.value = 0;

                        }
                        else {
                            btnPointNew.setAttribute("btnType", "create");
                            btnPointNew.getElementsByClassName("btnText")[0].innerText = mlp.getLanguageKey("新增");

                            // pointUserRate.style.display = "none";
                            // pointBuyChipRate.style.display = "none";
                            pointUserRate.classList.add("input-hidden-default");
                            pointBuyChipRate.classList.add("input-hidden-default");

                            btnBitLimit.style.display = "none";
                            // span_parentUserRate.style.display = "none";
                            // span_parentBuyChipRate.style.display = "none";
                        }

                        //btnPointNew.style.display = "none";
                        //pointState.style.display = "block";

                        btnBitLimit.onclick = new Function("setBitLimit('" + currencyType.toUpperCase() + "')");
                        break;
                    }
                }
            }
        } else {
            window.parent.API_ShowMessageOK(mlp.getLanguageKey("錯誤"), mlp.getLanguageKey("無法取得代理錢包資訊"));
        }
    }

    function setBitLimit(currencyType) {
        var messageContent;
        var div_CurrencyType = document.getElementsByClassName("div_CurrencyType");
        var idMessageText = document.getElementById("idMessageText");
        var bitLimitDIV = document.getElementsByClassName("bitLimitDIV");
        var divUserAccountType = document.getElementById("divUserAccountType");
        var QBetLimitList = document.getElementById("QBetLimitList");
        var NBetLimitList = document.getElementById("NBetLimitList");
        var QBetLimitArr;
        var NBetLimitArr;
        var hadData;

        for (var i = 0; i < div_CurrencyType.length; i++) {
            div_CurrencyType[i].style.display = "none";
            if (div_CurrencyType[i].getAttribute("CurrencyType") == currencyType) {
                switch (uType) {
                    case 0:
                        if (div_CurrencyType[i].getAttribute("assigntype") == "0") {
                            div_CurrencyType[i].style.display = "";
                        }
                        break;
                    case 1:
                        if (div_CurrencyType[i].getAttribute("assigntype") == "0" || div_CurrencyType[i].getAttribute("assigntype") == "1") {
                            div_CurrencyType[i].style.display = "";
                        }
                        break;
                }

            }
        }

        //加入NoData
        hadData = false;
        QBetLimitList.getElementsByClassName("td__hasNoData")[0].style.display = "none";
        QBetLimitArr = QBetLimitList.getElementsByClassName("div_CurrencyType");
        for (var i = 0; i < QBetLimitArr.length; i++) {
            if (QBetLimitArr[i].style.display != "none") {
                hadData = true;
                break;
            }
        }

        if (hadData == false) {
            QBetLimitList.getElementsByClassName("td__hasNoData")[0].style.display = "";            
        }

        hadData = false;
        NBetLimitList.getElementsByClassName("td__hasNoData")[0].style.display = "none";
        NBetLimitArr = NBetLimitList.getElementsByClassName("div_CurrencyType");
        for (var i = 0; i < NBetLimitArr.length; i++) {
            if (NBetLimitArr[i].style.display != "none") {
                hadData = true;
                break;
            }
        }

        if (hadData == false) {
            NBetLimitList.getElementsByClassName("td__hasNoData")[0].style.display = "";
        }
        //加入NoData

        divUserAccountType.style.display = "none";

        idMessageText.appendChild(bitLimitDIV[0]);
        bitLimitDIV[0].style.display = "";

        showBox(mlp.getLanguageKey("限紅設定") + " " + currencyType, "", true, function () {

        })
    }

    function setUserAccountType() {
        var idMessageText = document.getElementById("idMessageText");
        var divUserAccountType = document.getElementById("divUserAccountType");
        var bitLimitDIV = document.getElementsByClassName("bitLimitDIV");

        idMessageText.appendChild(divUserAccountType);
        divUserAccountType.style.display = "";
        bitLimitDIV[0].style.display = "none";

        showBox(mlp.getLanguageKey("帳戶類型"), "", false, function () {

        })

    }

    function setUType(iUType) {
        uType = iUType;

        switch (iUType) {
            case "Agent":
                document.getElementById("idUserAccountType").innerText = mlp.getLanguageKey("代理");
                uType = 1;
                break;
            case "UserAccount":
                document.getElementById("idUserAccountType").innerText = mlp.getLanguageKey("一般帳戶");
                uType = 0;
                break
        }

        c.removeClassName(idMessageBox, "show");

    }

    function showGame() {
        var idGameList = document.getElementById("idGameList");

        idGameList.classList.add("show");

    }

    function chgGameCode(el) {
        var spanGameName = c.getFirstClassElement(el, "spanGameName");
        var iptGameCode = c.getFirstClassElement(el, "iptGameCode");
        var revenue;
        var div_GameCode;


        GameAccountingCode = iptGameCode.getAttribute("GameCode");
        document.getElementById("idGameName").innerText = spanGameName.innerText;
        document.getElementById("btnGameListClose").click();

        div_GameCode = document.getElementsByClassName("div_GameCode");
        for (var i = 0; i < div_GameCode.length; i++) {
            div_GameCode[i].style.display = "none";
        }

        div_GameCode = document.getElementsByClassName(GameAccountingCode);
        for (var i = 0; i < div_GameCode.length; i++) {
            div_GameCode[i].style.display = "";
        }

    }


    function init() {
        var temp;
        var gameAccountingCodeArr = new Array();
        var idGameInfoList = document.getElementById("idGameInfoList");

        lang = window.localStorage.getItem("agent_lang");

        mlp = new multiLanguage();
        mlp.loadLanguage(lang, function () {
            EWinInfo = window.parent.EWinInfo;
            queryCurrentUserInfo();
            setUserAccountType();
            
            if (EWinInfo.CompanyCode.toUpperCase() == "fanta".toUpperCase()) {
                var select = document.getElementById("ContactPhonePrefix");
                select.innerHTML = "";

                var option = document.createElement("option");
                option.text =  mlp.getLanguageKey("+63 菲律賓");
                option.value = "+63";
                select.appendChild(option);
            }

            if (EWinInfo.UserInfo.GameCodeList.length > 0) {
                for (var i = 0; i < EWinInfo.UserInfo.GameCodeList.length; i++) {
                    temp = c.getTemplate("templateGameInfo");
                    if (temp != null) {
                        if (gameAccountingCodeArr[EWinInfo.UserInfo.GameCodeList[i].GameAccountingCode] == null) {
                            c.setClassText(temp, "spanGameName", null, EWinInfo.UserInfo.GameCodeList[i].GameAccountingCode);
                            c.getFirstClassElement(temp, "iptGameCode").setAttribute("GameCode", EWinInfo.UserInfo.GameCodeList[i].GameAccountingCode);
                            idGameInfoList.appendChild(temp);

                            gameAccountingCodeArr[EWinInfo.UserInfo.GameCodeList[i].GameAccountingCode] = EWinInfo.UserInfo.GameCodeList[i].GameAccountingCode;
                        }

                    }
                }
                document.getElementById("idGameCodeList").style.display = "";
            }

            GetCompanyPermissionGroup = window.parent.API_GetCompanyPermissionGroup();

            if (GetCompanyPermissionGroup) {
                if (GetCompanyPermissionGroup.includes("Casino")) {
                    document.getElementById("btncreateuser").hidden = true;
                }
            }
        });


    }

    window.onload = init;
</script>
<body class="innerBody">
    <main>
        <%--        <div class="loginUserInfo">
            <div class="loginUserInfo__account heading-1" id="idLoginAccount">
            </div>
        </div>--%>
        <div class="topList-box box-shadow fixed">
            <div class="container-fluid">
                <h1 class="page__title "><span class="language_replace">新增下線</span></h1>

                <div class="step__header">

                    <div id="stepFlows" class="step__flows step-total-2">
                        <!-- flow 狀態 
                                1.目前所在step => 加入class="active"
                            -->
                        <div class="step__flow flow-1 active" onclick="previousStep(this)" data-step="1" aria-checked="checking">
                            <div class="step__status">
                                <span class="number">1</span>
                                <span class="icon icon2020-ico-account"></span>
                                <span class="chedcked"></span>
                            </div>
                            <div class="step__title"><span class="language_replace">基本資料</span></div>
                        </div>
                        <div class="step__flow flow-2" onclick="nextStep(this)" data-step="1" aria-checked="checking">
                            <div class="step__status">
                                <span class="number">2</span>
                                <span class="icon icon-ico-wallet"></span>
                                <span class="chedcked"></span>
                            </div>
                            <div class="step__title"><span class="language_replace">錢包設定</span></div>
                        </div>
                        <%--<div class="step__flow flow-3 " onclick="previousStep(this)" data-step="3" aria-checked="uncheck">
                            <div class="step__status">
                                <span class="number">3</span>
                                <span class="icon icon-ico-wallet"></span>
                                <span class="chedcked"></span>
                            </div>
                            <div class="step__title"><span class="language_replace">限紅設定</span></div>
                        </div>--%>

                        <div class="progress_inner__bar"></div>
                        <div class="progress_inner__bar--base"></div>

                    </div>
                </div>
            </div>
        </div>
        <form method="post" onsubmit="return false">


            <div class="step__content">

                <div id="idStepContent" class="dataList step__list step-1">

                    <div class="step__listItem step-1">
                        <fieldset class="dataFieldset">
                            <legend class="dataFieldset-title language_replace hidden shown-lg">基本資料</legend>
                            <div class="row">

                                <%--<div class="col-12 form-group">
                                    <label class="title">
                                        <span class="language_replace">公司代碼</span>
                                    </label>
                                    <span class="language_replace" id="idCompanyCode"></span>
                                </div>
                                <div class="col-12 form-group">
                                    <label class="title">
                                        <span class="language_replace">上線代理</span>
                                    </label>
                                    <span class="language_replace" id="ParentLoginAccount"></span>
                                </div>
                                --%>

                                <div class="col-12 col-smd-12 col-md-6 col-lg-12 form-group row no-gutters">
                                    <div class="col-12">
                                        <label class="title"><span class="title_name"><i class="icon icon-ewin-default-accountType icon-s icon-before"></i><span class="language_replace">帳戶類型</span></span></label>
                                    </div>
                                    <div class="col-12 form-line d-flex justify-content-between align-items-center">
                                        <span class="language_replace" id="idUserAccountType"></span>
                                        <button type="button" class="btn btn-icon btn-s btn-outline-main btn-roundcorner" onclick="setUserAccountType()"><i class="icon icon-ewin-input-setUserAccountType icon-before icon-line-vertical"></i><span class="language_replace">狀態變更</span></button>
                                    </div>
                                </div>
                                <div class="col-12 col-smd-12 col-md-6 col-lg-12 form-group row no-gutters">
                                    <div class="col-12">
                                        <label class="title"><span class="title_name"><i class="icon icon-ewin-default-account icon-s icon-before"></i><span class="language_replace">登入帳號</span></span> </label>
                                    </div>
                                    <div class="col-12">
                                        <!-- 
                                                1.若資料正確 <div class="form-control-underline...=>加入class "iconCheck iconCheckAnim"
                                                2.若資料錯誤 <div class="form-control-underline...=>加入class "iconError iconErrorAnim" 

                                                 3.若 資料驗證中，則 icon-loading => display:block
                                                -->
                                        <div id="idLoginAccount" class="form-control-underline ">
                                            <input type="text" class="form-control" name="LoginAccount" id="LoginAccount" language_replace="placeholder" placeholder="請輸入帳號" onkeyup="chkUserAccount(this)">
                                            <label for="password" class="form-label "><span class="language_replace">請輸入帳號</span></label>
                                            <!-- loading 動畫 -->
                                            <div class="icon-loading" style="display: none;">
                                                <div class="lds-dual-ring"></div>
                                            </div>

                                        </div>
                                    </div>
                                </div>
                                <%--
                                <div class="col-12 col-smd-6 col-md-6 col-lg-6 form-group row no-gutters">
                                    <div class="col-12">
                                        <label class="title"><i class="icon icon-ewin-default-accountType icon-s icon-before"></i><span class="language_replace">帳戶類型</span></label>
                                    </div>
                                    <div class="col-12">
                                        <div class="custom-control custom-radioValue custom-control-inline">
                                            <label class="custom-label">
                                                <input type="radio" name="UserAccountType" id="UserAccountType1" class="custom-control-input-hidden" value="1" />
                                                <div class="custom-input radio-button"><span class="language_replace">代理</span></div>
                                            </label>
                                        </div>
                                        <div class="custom-control custom-radioValue custom-control-inline">
                                            <label class="custom-label">
                                                <input type="radio" name="UserAccountType" id="UserAccountType0" class="custom-control-input-hidden" value="0" checked />
                                                <div class="custom-input radio-button"><span class="language_replace">一般帳戶</span></div>
                                            </label>
                                        </div>
                                    </div>
                                </div>
                                --%>

                                <div class="col-12 col-md-6 form-group" id="idLendChipAccount">
                                    <label class="title"><span class="title_name"><i class="icon icon-ewin-default-accountType icon-s icon-before"></i><span class="language_replace">配碼帳戶</span></span></label>
                                    <span class="language_replace" id="IsLendChipAccount"></span>
                                </div>

                                <%--
                               <div class="col-12 form-group">
                                <label class="title"><span class="title_name"><i class="icon icon-ewin-default-paymentSystem icon-s icon-before"></i><span class="language_replace">允許使用支付系統</span></span>                           </label>                      <div class="custom-control custom-checkboxSwitchValue custom-control-inline">
                                    <label class="custom-label">
                                        <span class="custom-switch-text-left"><span class="language_replace">關</span></span>
                                        <input type="checkbox" name="AllowPayment" id="AllowPayment" class="custom-control-input-hidden" value="1" checked />
                                        <div class="custom-input toggle-button"></div>
                                        <span class="custom-switch-text-right"><span class="language_replace">開</span></span>
                                    </label>
                                </div>
                                </div>
                                <div class="col-12 col-md-6 form-group">
                                    <label class="title"><span class="title_name"><i class="icon icon-ewin-default-callCenter icon-s icon-before"></i><span class="language_replace">允許使用線上客服系統</span></span></label>
                                    <div class="custom-control custom-checkboxSwitchValue custom-control-inline">
                                        <label class="custom-label">
                                            <span class="custom-switch-text-left"><span class="language_replace">關</span></span>
                                            <input type="checkbox" name="AllowServiceChat" id="AllowServiceChat" class="custom-control-input-hidden" value="1" checked />
                                            <div class="custom-input toggle-button"></div>
                                            <span class="custom-switch-text-right"><span class="language_replace">開</span></span>
                                        </label>
                                    </div>
                                </div>
                                <div class="col-12 col-md-6 form-group row no-gutters">                                    <div class="col-12">                <label class="title"><span class="title_name"><i class="icon icon-ewin-default-accountName icon-s icon-before"></i> <span class="language_replace">允許投注類型</span></span></label>
                                    </div>
                                    <div class="col-12">
                                        <div class="form-control-underline custom-control-inline mr-1">
                                            <select name="AllowBet" id="AllowBet" class="custom-select">
                                                <option class="language_replace" value="0">不允許投注</option>
                                                <option class="language_replace" value="1">傳統電投</option>
                                                <option class="language_replace" value="2">網投/快速</option>
                                                <option class="language_replace" selected value="3">全部允許</option>
                                            </select>
                                        </div>
                                    </div>
                                </div>
                                --%>

                                <div class="col-12 col-smd-12 col-md-12 form-group row no-gutters">
                                    <div class="col-12">
                                        <label class="title"><span class="title_name"><i class="icon icon-ewin-default-accountNickname icon-s icon-before"></i><span class="language_replace">姓名</span></span></label>
                                    </div>
                                    <div class="col-12">
                                        <div class="form-control-underline">
                                            <input type="text" class="form-control" name="RealName" id="RealName" language_replace="placeholder" placeholder="請輸入姓名">
                                            <label for="password" class="form-label "><span class="language_replace">請輸入姓名</span></label>
                                        </div>
                                    </div>
                                </div>
                                <!-- password input =============== -->
                                <div class="col-12 form-group row no-gutters">
                                    <div class="col-12">
                                        <label class="title"><span class="title_name"><i class="icon icon-ewin-default-accountPassword icon-s icon-before"></i><span class="language_replace">登入密碼</span></span>                        </label>
                                    </div>
                                    <div class="col-12 col-smd-6 pr-smd-1">
                                        <div class="form-control-underline">
                                            <input type="password" class="form-control" name="LoginPassword" id="LoginPassword" language_replace="placeholder" placeholder="請輸入登入密碼">
                                            <label for="password" class="form-label "><span class="language_replace">請輸入登入密碼</span></label>
                                        </div>
                                    </div>
                                    <div class="col-12 col-smd-6 mt-3 mt-smd-0 pl-smd-1">
                                        <div class="form-control-underline">
                                            <input type="password" class="form-control" name="LoginPassword2" id="LoginPassword2" language_replace="placeholder" placeholder="確認密碼">
                                            <label for="password" class="form-label "><span class="language_replace">確認密碼</span></label>
                                        </div>
                                    </div>
                                </div>
                                <!-- <div class="col-12 form-group row no-gutters">                              
                                <div class="col-12">
                                    <div class="form-control-underline">
                                        <input type="password" class="form-control" name="LoginPassword2" id="LoginPassword2" placeholder="確認密碼">
                                        <label for="password" class="form-label "><span class="language_replace">確認密碼</span></label>
                                    </div>
                                </div>
                               </div> -->
                                <!-- select =============== -->
                                <div class="col-12 form-group row no-gutters">
                                    <div class="col-12">
                                        <label class="title"><span class="title_name"><i class="icon icon-ewin-default-accounCellphone icon-s icon-before"></i><span class="language_replace">電話</span></span></label>
                                    </div>
                                    <div class="col-12 col-md">
                                        <div class="row no-gutters">
                                            <div class="col-auto col-md-6">
                                                <div class="form-control-underline">
                                                    <select name="ContactPhonePrefix" id="ContactPhonePrefix" class="custom-select">
                                                        <option class="language_replace" value="">(其他)</option>
                                                        <option class="language_replace" value="+86">+86 中國</option>
                                                        <option class="language_replace" value="+853">+853 澳門</option>
                                                        <option class="language_replace" value="+852">+852 香港</option>
                                                        <option class="language_replace" value="+886">+886 台灣</option>
                                                        <option class="language_replace" value="+81">+81 日本</option>
                                                        <option class="language_replace" value="+82">+82 南韓</option>
                                                        <option class="language_replace" value="+84">+84 越南</option>
                                                        <option class="language_replace" value="+66">+66 泰國</option>
                                                        <option class="language_replace" value="+855">+855 柬埔寨</option>
                                                        <option class="language_replace" value="+63">+63 菲律賓</option>
                                                        <option class="language_replace" value="+65">+65 新加坡</option>
                                                        <option class="language_replace" value="+60">+60 馬來西亞</option>
                                                    </select>
                                                </div>
                                            </div>
                                            <div class="col col-md-6 pl-2">
                                                <div class="form-control-underline">
                                                    <input type="text" class="form-control" name="ContactPhoneNumber" id="ContactPhoneNumber" language_replace="placeholder" placeholder="請輸入手機號碼">
                                                    <label for="password" class="form-label "><span class="language_replace">請輸入手機號碼</span></label>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </fieldset>

                        <div class="wrapper_center fixed-Bottom hidden-lg btn-group-lg ">
                            <button type="button" class="btn btn-outline-main" onclick="closePage(this)"><i class="icon icon-before icon-ewin-input-cancel"></i><span class="language_replace">取消</span></button>
                            <button type="button" class="btn btn-full-main " onclick="nextStep(this)" data-step="1"><span class="language_replace">下一步</span><i class="icon icon-after icon-ewin-input-arrow-right"></i></button>
                        </div>
                    </div>
                    <div class="step__listItem step-2">
                        <!-- 錢包管理 -->

                        <fieldset class="dataFieldset">
                            <legend class="dataFieldset-title language_replace hidden shown-lg">錢包管理</legend>

                            <div id="idGameCodeList" class="gameNameSettingWrapper mb-0 mb-smd-2 mb-lg-3 fixed" style="display:none ">
                                <div class="gameNameSetting btn_gameNameSetting" onclick="showGame()">
                                    <div class="gameName"><span id="idGameName" class="language_replace">eWin百家樂</span></div>
                                    <div class="has-arrow"><i class="arrow"></i></div>
                                </div>
                            </div>

                            <div class="MT__tableDiv">
                                <!-- 自訂表格 -->
                                <div class="MT__table MT__table--Sub table-col-7">
                                    <!-- 標題項目  -->
                                    <div class="thead">
                                        <!--標題項目單行 -->
                                        <div class="thead__tr">
                                            <div class="thead__th">
                                                <span class="language_replace">貨幣</span>
                                            </div>
                                            <%--
                                            <div class="thead__th">
                                                <span class="language_replace">狀態</span>
                                            </div>
                                            --%>
                                            <div class="thead__th">
                                                <span class="language_replace">佔成率(%)</span>
                                            </div>
                                            <div class="thead__th">
                                                <span class="language_replace">轉碼率(%)</span>
                                            </div>
                                            <div class="thead__th">
                                                <span class="language_replace">限紅</span>
                                            </div>
                                        </div>
                                    </div>
                                    <!-- 表格上下滑動框 -->
                                    <div id="templateWalletItem" style="display: none">
                                        <!--表格內容單行 -->
                                        <div class="tbody__tr">
                                            <div class="tbody__td td-100 currencyType">
                                                <span class="td__title">
                                                    <i class="icon icon-ewin-default-coin-o"></i>
                                                    <span class="language_replace"></span>
                                                </span>
                                                <span class="td__content">
                                                    <span class="language_replace PointCurrencyType"></span>
                                                    <span class="btnPointNew" btntype="create">
                                                        <button type="button" class="btn btn-s btn-outline-main "><i class="icon"></i><span class="language_replace btnText">新增</span></button>
                                                    </span>
                                                </span>
                                            </div>
                                            <%--
                                            <div class="tbody__td">
                                                <span class="td__title"><span class="language_replace">狀態</span></span>
                                                <span class="td__content">
                                                    
                                                        <button type="button" class="btn btn-full-main PointNew"><span class="language_replace">新增</span></button>
                                                        <select class="custom-select PointState">
                                                            <option class="language_replace" value="0">使用中</option>
                                                            <option class="language_replace" value="1">停用</option>
                                                        </select>
                                                   
                                                </span>
                                            </div>
                                            --%>
                                            <div class="tbody__td td-3 td-vertical">
                                                <span class="td__title">
                                                    <span class="language_replace">佔成率(%)</span>
                                                    <!-- <span class="span_parentUserRate num-negative" style="display:none">
                                                    <i class="icon icon2020-members"></i><span class="language_replace">上線</span>
                                                    <span><span class="parentUserRate"></span>%</span>
                                                   </span> -->
                                                </span>
                                                <span class="td__content">
                                                    <div class="form-control-hidden ADJ_userRate">
                                                        <input type="text" class="form-control PointUserRate" language_replace="placeholder" placeholder="佔成率上限">
                                                        <!-- placholder label -->
                                                        <label class="form-label span_parentUserRate">
                                                            <span class="language_replace">上線</span><span class="number"><span class="parentUserRate"></span>%</span>
                                                        </label>
                                                    </div>
                                                </span>
                                            </div>
                                            <div class="tbody__td td-3 td-vertical">
                                                <span class="td__title">
                                                    <span class="language_replace">轉碼率(%)</span>
                                                    <!-- <span class="span_parentBuyChipRate num-negative" style="position:relative;top:25px;left:40px;display:none"><i class="icon icon2020-members"></i><span class="language_replace">上線</span><span><span class="parentBuyChipRate"></span>%</span></span> -->
                                                </span>
                                                <span class="td__content">
                                                    <div class="form-control-hidden ADJ_userRate">
                                                        <input type="text" class="form-control PointBuyChipRate" language_replace="placeholder" placeholder="轉碼率上限">
                                                        <!-- placholder label -->
                                                        <label class="form-label span_parentBuyChipRate">
                                                            <span class="language_replace">上線</span><span class="number"><span class="parentBuyChipRate"></span>%</span>
                                                        </label>
                                                    </div>
                                                </span>
                                            </div>
                                            <div class="tbody__td nonTitle td-function-execute td-100">
                                                <span class="td__title"><span class="language_replace">限紅</span></span>
                                                <span class="td__content ">
                                                    <span class="btnBitLimit">
                                                        <button type="button" class="btn btn-full-main"><i class="icon icon-before icon-ewin-input-chip"></i><span class="language_replace">限紅設定1</span></button>
                                                    </span>

                                                </span>

                                            </div>
                                        </div>
                                    </div>
                                    <!-- END OF templateWalletItem  -->

                                    <!-- 原本的寫法 寫在 tbody裡-->
                                    <!-- <div id="idPointList" class="wallet_PointList">
                                    </div> -->
                                    <div id="idPointList" class="tbody wallet_PointList userAccount_Edit">
                                    </div>

                                </div>

                            </div>
                        </fieldset>
                        <div class="wrapper_center fixed-Bottom last-step-execute btn-group-lg">
                            <button type="button" class="btn btn-outline-main " onclick="closePage(this)"><i class="icon icon-before icon-ewin-input-cancel"></i><span class="language_replace">取消</span></button>
                            <button type="button" class="btn btn-full-main hidden-lg" onclick="previousStep(this)" data-step="1"><i class="icon icon-before icon-ewin-input-arrow-left"></i><span class="language_replace">上一步</span></button>
                            <button type="button" class="btn btn-full-main" onclick="checkFormData()"><i class="icon icon-before icon-ewin-input-submit"></i><span class="language_replace">送出</span></button>
                        </div>
                    </div>

                    <div id="BetLimitTab" class="BetLimitTab bitLimitDIV" style="display: none">
                        <ul class="nav-tabs-block nav nav-tabs tab-items-2" role="tablist">
                            <li class="nav-item">
                                <a onclick="tabSwitch(this)" class="BetLimitTabNavTabs nav-link active language_replace" data-toggle="tab" href="#tab-1" role="tab" aria-controls="tab-1" aria-selected="true">快速電投</a>
                            </li>
                            <li class="nav-item">
                                <a onclick="tabSwitch(this)" class="BetLimitTabNavTabs nav-link language_replace" data-toggle="tab" href="#tab-2" role="tab" aria-controls="tab-2" aria-selected="false">網投</a>
                            </li>
                            <li class="tab-slide"></li>
                        </ul>

                        <div class="tab-content">
                            <div id="tab-1" class="BetLimitTabContent tab-pane fade show active">
                                <!-- mobile 版 Title + 全選 -->
                                <%--<div class="form-group form-group-s2 hidden-smd">
                                    <div class="title"><span class="language_replace">組別</span></div>
                                    <div class="content">
                                        <div class="custom-control custom-checkboxValue custom-control-inline check-all">
                                            <label class="custom-label">
                                                <input type="checkbox" name="chkCurrencyType" class="custom-control-input-hidden" onclick="" value="all">
                                                <div class="custom-input checkbox"><span class="language_replace">全選</span></div>
                                            </label>
                                        </div>
                                    </div>
                                </div>--%>

                                <div class="MT__tableDiv MT__table--checkbox ">
                                    <div class="MT__table MT__table--Sub table-col-5">
                                        <div class="thead">
                                            <div class="thead__tr">
                                                <div class="thead__th">
                                                    <span class="custom-control custom-checkboxValue custom-control-inline" style="display: none;">
                                                        <label class="custom-label">
                                                            <input type="checkbox" name="BetLimitID" class="custom-control-input-hidden BetLimitID" value="18">
                                                            <span class="custom-input checkbox"><span class="language_replace" langkey=""></span></span>
                                                        </label>
                                                    </span>
                                                </div>
                                                <div class="thead__th">
                                                    <span class="language_replace">庄</span>
                                                </div>
                                                <div class="thead__th">
                                                    <span class="language_replace">闲</span>
                                                </div>
                                                <div class="thead__th">
                                                    <span class="language_replace">和</span>
                                                </div>
                                                <div class="thead__th">
                                                    <span class="language_replace">對子</span>
                                                </div>
                                            </div>
                                        </div>
                                        <div id="templateQBetLimit" style="display: none">
                                            <div class="tbody__tr div_CurrencyType td-non-underline-last-2">
                                                <div class="tbody__td floatT-left floatT-checkbox">
                                                    <span class="td__title"></span>
                                                    <span class="td__content">
                                                        <span class="custom-control custom-checkboxValue custom-control-inline">
                                                            <label class="custom-label">
                                                                <input type="checkbox" name="BetLimitID" class="custom-control-input-hidden BetLimitID" value="18">
                                                                <span class="custom-input checkbox"><span class="language_replace" langkey=""></span></span>
                                                            </label>
                                                        </span>
                                                    </span>
                                                </div>
                                                <div class="tbody__td td-3">
                                                    <span class="td__title"><span class="language_replace">庄</span></span>
                                                    <span class="td__content"><span class="BetLimitB">0.02 - 2</span></span>
                                                </div>
                                                <div class="tbody__td td-3">
                                                    <span class="td__title"><span class="language_replace">闲</span></span>
                                                    <span class="td__content"><span class="BetLimitP">0.02 - 2</span></span>
                                                </div>
                                                <div class="tbody__td td-3">
                                                    <span class="td__title"><span class="language_replace">和</span></span>
                                                    <span class="td__content"><span class="BetLimitT">0.01 - 0.25</span></span>
                                                </div>
                                                <div class="tbody__td td-3">
                                                    <span class="td__title"><span class="language_replace">對子</span></span>
                                                    <span class="td__content"><span class="BetLimitPair">0.01 - 0.18</span></span>
                                                </div>
                                            </div>
                                        </div>
                                        <!-- 原本的寫法 寫在 tbody裡-->
                                        <!-- <div id="QBetLimitList"></div> -->
                                        <div class="tbody" id="QBetLimitList">
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div id="tab-2" class="BetLimitTabContent tab-pane fade">
                                <!-- mobile 版 Title + 全選 -->
                                <%--<div class="form-group form-group-s2 hidden-smd">
                                    <div class="title"><span class="language_replace">組別</span></div>
                                    <div class="content">
                                        <div class="custom-control custom-checkboxValue custom-control-inline check-all">
                                            <label class="custom-label">
                                                <input type="checkbox" name="chkCurrencyType" class="custom-control-input-hidden" onclick="" value="all">
                                                <div class="custom-input checkbox"><span class="language_replace">全選</span></div>
                                            </label>
                                        </div>
                                    </div>
                                </div>--%>

                                <div class="MT__tableDiv MT__table--checkbox">
                                    <div class="MT__table MT__table--Sub table-col-5">
                                        <div class="thead">
                                            <div class="thead__tr">
                                                <div class="thead__th">
                                                    <span class="custom-control custom-checkboxValue custom-control-inline" style="display: none;">
                                                        <label class="custom-label">
                                                            <input type="checkbox" name="BetLimitID" class="custom-control-input-hidden BetLimitID" value="18">
                                                            <span class="custom-input checkbox"><span class="language_replace" langkey=""></span></span>
                                                        </label>
                                                    </span>
                                                </div>
                                                <div class="thead__th">
                                                    <span class="language_replace">庄</span>
                                                </div>
                                                <div class="thead__th">
                                                    <span class="language_replace">闲</span>
                                                </div>
                                                <div class="thead__th">
                                                    <span class="language_replace">和</span>
                                                </div>
                                                <div class="thead__th">
                                                    <span class="language_replace">對子</span>
                                                </div>
                                            </div>
                                        </div>
                                        <div id="templateNBetLimit" style="display: none">
                                            <div class="tbody__tr div_CurrencyType td-non-underline-last-2">
                                                <div class="tbody__td floatT-left floatT-checkbox">
                                                    <span class="td__title"></span>
                                                    <span class="td__content">
                                                        <span class="custom-control custom-checkboxValue custom-control-inline">
                                                            <label class="custom-label">
                                                                <input type="checkbox" name="BetLimitID" class="custom-control-input-hidden BetLimitID" value="18">
                                                                <span class="custom-input checkbox"><span class="language_replace" langkey=""></span></span>
                                                            </label>
                                                        </span>
                                                    </span>
                                                </div>
                                                <div class="tbody__td td-3">
                                                    <span class="td__title"><span class="language_replace">庄</span></span>
                                                    <span class="td__content"><span class="BetLimitB">0.02 - 2</span></span>
                                                </div>
                                                <div class="tbody__td td-3">
                                                    <span class="td__title"><span class="language_replace">闲</span></span>
                                                    <span class="td__content"><span class="BetLimitP">0.02 - 2</span></span>
                                                </div>
                                                <div class="tbody__td td-3">
                                                    <span class="td__title"><span class="language_replace">和</span></span>
                                                    <span class="td__content"><span class="BetLimitT">0.01 - 0.25</span></span>
                                                </div>
                                                <div class="tbody__td td-3">
                                                    <span class="td__title"><span class="language_replace">對子</span></span>
                                                    <span class="td__content"><span class="BetLimitPair">0.01 - 0.18</span></span>
                                                </div>
                                            </div>
                                        </div>
                                        <!-- 原本的寫法 寫在 tbody裡-->
                                        <!-- <div id="NBetLimitList"></div> -->
                                        <div class="tbody" id="NBetLimitList">
                                        </div>

                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                </div>
            </div>

            <div id="divUserAccountType" class="popUp__UserAccountType" style="display: none">
                <div class="user-item UserAccountType__agent" onclick="setUType('Agent')">
                    <div class="content">
                        <span class="icon"></span>
                        <span class="text"><span class="language_replace">代理</span></span>
                    </div>
                </div>
                <div class="user-item UserAccountType__normal" id="btncreateuser" onclick="setUType('UserAccount')">
                    <div class="content">
                        <span class="icon"></span>
                        <span class="text"><span class="language_replace">一般帳戶</span></span>
                    </div>
                </div>
            </div>
        </form>

    </main>

    <!-- 遊戲設定 popUp - popUp 跳出加 show-->
     <div id="idGameList" class="popUp">
            <div class="popUpWrapper">
                <div id="btnGameListClose" class="popUp__close btn btn-close" onclick="ac.closePopUp(this)"></div>
                <div class="popUp__title"><span class="language_replace">選擇遊戲</span></div>
                <div class="popUp__content">
                    <div class="popUp__GameNameSetting">
                        <form class="search__wrapper" action="">
                            <%--<div class="form-group-search">
                                <input id="" type="search" class="form-control custom-search" name="search" language_replace="placeholder" placeholder="遊戲名稱">
                                <label for="search" class="form-label"><span class="language_replace">遊戲名稱</span></label>
                                <button type="reset" class="btn btnReset"><i class="icon icon-ewin-input-reset"></i></button>
                            </div>--%>
                        </form>
                        <div id="idGameInfoList" class="content__GameNameSetting">
                            <div class="game-item col-6 col-sm-6 col-smd-4 custom-control custom-radioValue-button" onclick="chgGameCode(this)">
                                <label class="custom-label">
                                    <input type="radio" name="rdoGameCode" class="custom-control-input-hidden iptGameCode" gamecode="eWinBAC" checked>
                                    <div class="custom-input-icon radio-button">
                                        <span class="icon icon-before icon-circle icon-ico-selected"></span>
                                        <span class="radioText language_replace spanGameName">eWin百家樂</span>
                                    </div>
                                </label>
                            </div>
                        </div>
                        <div id="templateGameInfo" style="display: none">
                            <div class="game-item col-6 col-sm-6 col-smd-4 custom-control custom-radioValue-button" onclick="chgGameCode(this)">
                                <label class="custom-label">
                                    <input type="radio" name="rdoGameCode" class="custom-control-input-hidden iptGameCode" gamecode="radio-game">
                                    <div class="custom-input-icon radio-button">
                                        <span class="icon icon-before icon-circle icon-ico-selected"></span>
                                        <span class="radioText language_replace spanGameName">--</span>
                                    </div>
                                </label>
                            </div>
                        </div>

                    </div>
                </div>
        </div>
        <!-- mask_overlay 半透明遮罩-->
        <div id="mask_overlay_popup" class="mask_overlay_popup" onclick="ac.MaskPopUp(this)"></div>
    </div>

    <!-- 
        popUp MessageBOX=================================
        popUp 出現 => class 加入show
        mask_overlay_popup 遮罩按下時 popup會消失
     -->
    <div class="popUp " id="idMessageBox">
        <div class="popUpWrapper">
            <div class="popUp__title" id="idMessageTitle">[Title]</div>
            <div class="popUp__content" id="idMessageText">
            </div>
            <div class="popUp__footer">
                <div class="form-group-popupBtn">
                    <div class="btn btn-outline-main btn-popup-cancel" id="idMessageButtonCancel">Cancel</div>
                    <div class="btn btn-full-main btn-popup-confirm" id="idMessageButtonOK">OK</div>
                </div>
            </div>
        </div>
        <!-- mask_overlay 半透明遮罩-->
        <!-- <div id="mask_overlay_popup" class="mask_overlay_popup" onclick="MaskPopUp(this)"></div> -->
        <div id="mask_overlay_popup" class="mask_overlay_popup"></div>
    </div>

    <script>
        //TAB FLOW
        //上一步
        function previousStep(e) {
            var idStepContent = document.getElementById("idStepContent");
            var idstepFlows = document.getElementById("stepFlows");
            var step__listItem = document.getElementsByClassName("step__listItem");
            var data_step = e.dataset.step; //get TAB data-step 
            var myIndex = 0;

            // GET EACH TAB item
            var stepFlowItems = idstepFlows.querySelectorAll('.step__flow');

            for (var i = 0; i < stepFlowItems.length; i++) {
                stepFlowItems[i].classList.remove('active');
                stepFlowItems[i].setAttribute("aria-checked", "checking");
            }

            myIndex = parseInt(data_step) - 1;
            stepFlowItems[myIndex].classList.add('active');
            idStepContent.className = "dataList step__list step-" + parseInt(data_step);

            window.setTimeout(function () {
                setScreenToTop();
            }, 100)

        }

        //下一步
        function nextStep(e) {
            var idStepContent = document.getElementById("idStepContent");
            var idstepFlows = document.getElementById("stepFlows");
            var step__listItem = document.getElementsByClassName("step__listItem");

            // var data_step = e.dataset.stepfinish; //get TAB data-step 
            var data_step = e.dataset.step; //get top TAB data-step 

            // GET EACH TAB item
            var stepFlowItems = idstepFlows.querySelectorAll('.step__flow');
            var myIndex = 0;

            for (var i = 0; i < stepFlowItems.length; i++) {
                stepFlowItems[i].classList.remove('active');
                stepFlowItems[i].setAttribute("aria-checked", "checking");
            }

            myIndex = parseInt(data_step);
            stepFlowItems[myIndex].classList.add('active');
            // stepFlowItems[myIndex].setAttribute("aria-checked", "checking");
            stepFlowItems[myIndex - 1].setAttribute("aria-checked", "checked");

            idStepContent.className = "dataList step__list step-" + (myIndex + 1);

            window.setTimeout(function () {
                setScreenToTop();
            }, 100)
        }

        function setScreenToTop() {
            var stepContent;
            var scrollTop = 0;

            stepContent = document.getElementsByClassName("step__content")[0];
            stepContent.scrollTo(0, 0);
        }

        function closePage() {
            window.parent.API_CloseWindow(false);
        }

        // tab 切換 ===================================
        function tabSwitch(e) {
            var idBetLimitTab = document.getElementById("BetLimitTab");

            var tabNavItems = idBetLimitTab.getElementsByClassName('nav-item');
            var tabNavItemsALink = idBetLimitTab.getElementsByClassName("BetLimitTabNavTabs");

            var tabContentItems = idBetLimitTab.getElementsByClassName("BetLimitTabContent");


            var data_toggle = e.dataset.toggle;
            var data_target = e.getAttribute("aria-controls");


            window.event.stopPropagation();
            window.event.preventDefault();

            for (var i = 0; i < tabNavItemsALink.length; i++) {

                tabNavItems[i].classList.remove('active');
                tabNavItemsALink[i].classList.remove('active');
                tabNavItemsALink[i].setAttribute("aria-selected", "false");

            }

            e.parentNode.classList.add('active');
            e.classList.add('active');
            e.setAttribute("aria-selected", "true");

            //TAB 內容==========================================

            for (var i = 0; i < tabContentItems.length; i++) {
                tabContentItems[i].classList.remove('show', 'active');
            }

            document.getElementById(data_target).classList.add('show', 'active');


            return false;
        }

        function showBox(title, msg, showOK, cbOK) {
            var idMessageBox = document.getElementById("idMessageBox");
            var idMessageTitle = document.getElementById("idMessageTitle");
            var idMessageText = document.getElementById("idMessageText");
            var idMessageButtonOK = document.getElementById("idMessageButtonOK");
            var idMessageButtonCancel = document.getElementById("idMessageButtonCancel");

            var funcOK = function () {
                c.removeClassName(idMessageBox, "show");

                if (cbOK != null)
                    cbOK();
            }

            if (idMessageTitle != null)
                idMessageTitle.innerHTML = title;

            //if (idMessageText != null)
            //    idMessageText.innerHTML = msg;

            if (idMessageButtonOK != null) {
                if (showOK == true) {
                    idMessageButtonOK.style.display = "";
                    idMessageButtonOK.onclick = funcOK;
                }
                else {
                    idMessageButtonOK.style.display = "none";
                }
            }

            if (idMessageButtonCancel != null) {
                idMessageButtonCancel.style.display = "none";
            }

            c.addClassName(idMessageBox, "show");
        }

        //PopUP半透明遮罩
        function MaskPopUp(obj) {
            idMessageBox.classList.remove("show");
        }

    </script>
</body>
</html>
