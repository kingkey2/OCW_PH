<%@ Page Language="C#" %>

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
<script src="../Scripts/MgmtAPI.js"></script>
<script>      
    var c = new common();
    var m;

    function init() {
        m = new MgmtAPI("../API/MgmtAPI.asmx");
    }

    function onBtnUpdateUserLevel() {
        if ($("#idPassWord").val() == "") {
            alert("請輸入密碼");
            return;
        }

        m.ManualUserLevelAdjust($("#idPassWord").val(), $("#idLoginAccount").val(), $("#idUserLevelIndex").val(), (function (success, o) {
            if (success) {
                if (o.Result == 0) {
                    alert("完成");
                } else {
                    alert(o.Message);
                }
            }
        }));
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
                <div id="contentStep1" class="form-content" data-form-group="registerStep1" style="padding:20px !important;width:100%">
                    <form id="registerStep1">
                        <div class="form-group mt-4">
                            <label class="form-title language_replace">密碼</label>
                            <div class="input-group">
                                <input id="idPassWord" type="text" class="form-control custom-style"  style="width:100%"/>
                            </div>
                        </div>
                        <div class="form-group mt-4">
                            <label class="form-title language_replace">帳號</label>
                            <div class="input-group">
                                <input id="idLoginAccount" type="text" class="form-control custom-style"  style="width:100%"/>
                            </div>
                        </div>
                    <%--    <div class="form-group mt-4">
                            <label class="form-title language_replace">等級</label>
                            <div class="input-group">
                                <input id="idUserLevelIndex" type="text" class="form-control custom-style"  style="width:100%"/>
                            </div>
                        </div>--%>
                        <div class="form-row">
                            <div class="form-group col">
                                <label class="form-title language_replace" langkey="等級">等級</label>
                                <div class="input-group">
                                    <select id="idUserLevelIndex" class="form-control custom-style" name="UserLevelIndex" >
                                        <option value="0" selected="">VIP0</option>
                                        <option value="1">青銅</option>
                                        <option value="2">白銀</option>
                                        <option value="3">勇士</option>
                                        <option value="4">白金</option>
                                        <option value="5">鑽石</option>
                                        <option value="6">精英</option>
                                        <option value="7">金鑽</option>
                                        <option value="8">大師</option>
                                        <option value="9">宗師</option>
                                        <option value="10">史詩</option>
                                    </select>
                                </div>
                            </div>
                        </div>
                        <div class="btn-container register my-3" id="divSendValidateCodeBtn">
                            <button type="button" class=" btn-primary " onclick="onBtnUpdateUserLevel()">
                                <span class="language_replace">升級</span>
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
