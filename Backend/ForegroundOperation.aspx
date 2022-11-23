<%@ Page Language="C#" AutoEventWireup="true" CodeFile="ForegroundOperation.aspx.cs" Inherits="Backend_ForegroundOperation" %>

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
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+JP:wght@300;500&display=swap" rel="Prefetch" as="style" onload="this.rel = 'stylesheet'" />
</head>

<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/4.6.2/js/bootstrap.min.js"></script>
<script type="text/javascript" src="/Scripts/Common.js"></script>
<script type="text/javascript" src="/Scripts/UIControl.js"></script>
<script>      
    var c = new common();
    var ApiUrl = "ForegroundOperation.aspx";

    function init() {
     
    }

    function onBtnUpdateCompanyCategory() {
        var postData = {

        };

        c.callService(ApiUrl + "/UpdateCompanyCategory", postData, function (success, o) {
            if (success) {
                var obj = c.getJSON(o);
                if (obj.Result == 0) {
                    alert("完成");
                } else {
                    alert(obj.Message);
                }
            }
        });
    }

    function onBtnOpenWebSite() {
        var postData = {

        };

        c.callService(ApiUrl + "/OpenSite", postData, function (success, o) {
            if (success) {
                var obj = c.getJSON(o);
                if (obj.Result == 0) {
                    alert("完成");
                } else {
                    alert(obj.Message);
                }
            }
        });
    }

    function onBtnCloseWebSite() {
        var postData = {
            Message: $("#idCloseWebSiteTxt").val()
        };

        c.callService(ApiUrl + "/MaintainSite", postData, function (success, o) {
            if (success) {
                var obj = c.getJSON(o);
                if (obj.Result == 0) {
                    alert("完成");
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
            <div id="idRegister" class="form-container cashflowCard-wrapper">
                <!-- 簡易註冊 -->
                <div id="contentStep1" class="form-content" data-form-group="registerStep1" style="padding:20px !important">
                    <form id="registerStep1">
                        <div class="form-group mt-4">
                            <label class="form-title language_replace">關站說明</label>
                            <div class="input-group">
                                <input id="idCloseWebSiteTxt" type="text" class="form-control custom-style"  style="width:100%"/>
                            </div>
                        </div>
                        <div class="btn-container register my-3" id="divSendValidateCodeBtn">
                            <button type="button" class=" btn-primary " onclick="onBtnUpdateCompanyCategory()">
                                <span class="language_replace">同步遊戲</span>
                            </button>
                            <button type="button" class=" btn-primary " onclick="onBtnOpenWebSite()">
                                <span class="language_replace">開站</span>
                            </button>
                            <button type="button" class=" btn-primary " onclick="onBtnCloseWebSite()">
                                <span class="language_replace">關站</span>
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
