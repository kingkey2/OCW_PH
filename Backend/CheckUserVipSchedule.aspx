﻿<%@ Page Language="C#" AutoEventWireup="true" CodeFile="CheckUserVipSchedule.aspx.cs" Inherits="Backend_CheckUserVipSchedule" %>
<% 
    EWin.GlobalPermissionAPI.GlobalPermissionAPI GApi = new EWin.GlobalPermissionAPI.GlobalPermissionAPI();
    EWin.GlobalPermissionAPI.APIResult GR = new EWin.GlobalPermissionAPI.APIResult();
    string ASID = string.Empty;

    if (string.IsNullOrEmpty(Request["ASID"]) == false) {
        ASID = Request["ASID"];
        GR = GApi.CheckPermission(ASID, EWinWeb.CompanyCode, "CheckUserVipSchedule", "CheckUserVipSchedule", "");

        if (GR.Result == EWin.GlobalPermissionAPI.enumResult.ERR) {
            Response.Redirect("../Error.aspx?ErrMsg=NoPermissions");
        }
    } else {
        Response.Redirect("../Error.aspx?ErrMsg=NoPermissions");
    }

%>
<!doctype html>
<html>
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Lucky Sprite</title>

    <link rel="stylesheet" href="../Scripts/OutSrc/lib/bootstrap/css/bootstrap.min.css" type="text/css" />
    <link rel="stylesheet" href="../css/icons.css" type="text/css" />
    <link rel="stylesheet" href="../css/global.css" type="text/css" />
    <link rel="stylesheet" href="../css/member-2.css"/>
</head>

<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/4.6.2/js/bootstrap.min.js"></script>
<script type="text/javascript" src="/Scripts/Common.js"></script>
<script type="text/javascript" src="/Scripts/UIControl.js"></script>
<script>      
    var c = new common();
    var ApiUrl = "CheckUserVipSchedule.aspx";
    var ASID = "<%=ASID%>";

    function init() {
        if (self == top) {
            window.close();
        }
    }

    function search() {
        var postData = {
            ASID: ASID,
            LoginAccount: $("#idLoginaccount").val()
        };

        $("#LoginAccount").text('');
        $("#UserLevelIndex").text('');
        $("#UserLevelUpdateDate").text('');
        $("#UserLevelAccumulationDepositAmount").text('');
        $("#UserLevelAccumulationValidBetValue").text('');

        c.callService(ApiUrl + "/CheckUserVipSchedule", postData, function (success, o) {
            if (success) {
                var obj = c.getJSON(o);
                if (obj.Result == 0) {
                    //alert("完成");
                    if (obj.IP != "") {
                        $("#LoginAccount").text(obj.LoginAccount);
                        $("#UserLevelIndex").text(obj.UserLevelIndex);
                        $("#UserLevelUpdateDate").text(obj.UserLevelUpdateDate);
                        $("#UserLevelAccumulationDepositAmount").text(obj.UserLevelAccumulationDepositAmount);
                        $("#UserLevelAccumulationValidBetValue").text(obj.UserLevelAccumulationValidBetValue);
                    } else {
                        alert("無帳戶");
                    }

                    //console.log(obj);
                } else {
                    alert(obj.Message);
                }
            }
        });
    }
    
    window.onload = init;
</script>
<body>
    <div class="layout-full-screen sign-container" data-form-group="signContainer">
        <div class="btn-back is-hide" data-click-btn="backToSign">
            <div></div>
        </div>

        <!-- 主內容框 -->
        <div class="main-panel">
            <div id="idRegister">
                <!-- 簡易註冊 -->
                <div id="contentStep1" class="form-content" data-form-group="registerStep1" style="padding:20px !important">
                    <form id="registerStep1">
                        <div class="form-group mt-4">
                            <label class="form-title language_replace">帳號</label>
                            <div class="input-group">
                                <input id="idLoginaccount" type="text" class="form-control custom-style"  style="width:100%"/>
                            </div>
                        </div>
                        <div class="btn-container register my-3" id="divSendValidateCodeBtn">
                            <button type="button" class=" btn-primary " onclick="search()">
                                <span class="language_replace">查詢</span>
                            </button>
                        </div>
                        <div class="form-group mt-4">
                            <label class="language_replace">帳號：</label>
                            <label class="language_replace" id="LoginAccount"></label>
                        </div>
                        <div class="form-group mt-4">
                            <label class="language_replace">等級：</label>
                            <label class="language_replace" id="UserLevelIndex"></label>
                        </div>
                        <div class="form-group mt-4">
                            <label class="language_replace">升級時間：</label>
                            <label class="language_replace" id="UserLevelUpdateDate"></label>
                        </div>
                        <div class="form-group mt-4">
                            <label class="language_replace">入金金額：</label>
                            <label class="language_replace" id="UserLevelAccumulationDepositAmount"></label>
                        </div>
                        <div class="form-group mt-4">
                            <label class="language_replace">有效投注：</label>
                            <label class="language_replace" id="UserLevelAccumulationValidBetValue"></label>
                        </div>
                        <div class="form-group mt-4">
                            <img src="images/VipUpgrade.PNG" />
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
