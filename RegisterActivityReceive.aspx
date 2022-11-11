<%@ Page Language="C#" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Lucky Sprite</title>

    <link rel="stylesheet" href="Scripts/OutSrc/lib/bootstrap/css/bootstrap.min.css" type="text/css" />
    <link rel="stylesheet" href="css/icons.css" type="text/css" />
    <link rel="stylesheet" href="css/global.css" type="text/css" />
    <link rel="stylesheet" href="css/manual.css" type="text/css" />
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+JP:wght@300;500&display=swap" rel="Prefetch" as="style" onload="this.rel = 'stylesheet'" />

</head>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/4.6.2/js/bootstrap.min.js"></script>
<script src="Scripts/OutSrc/js/wallet.js"></script>
<script type="text/javascript" src="/Scripts/MultiLanguage.js"></script>
<script type="text/javascript" src="/Scripts/Math.uuid.js"></script>
<script type="text/javascript">
    if (self != top) {
        window.parent.API_LoadingStart();
    }

    var lang;
    var mlp;
    var WebInfo;
    var p;

    function init() {
        if (self == top) {
            window.parent.location.href = "index.aspx";
        }
        WebInfo = window.parent.API_GetWebInfo();
        p = window.parent.API_GetLobbyAPI();

        mlp = new multiLanguage();
        lang = window.parent.API_GetLang();
        mlp.loadLanguage(lang, function () {
            window.parent.API_LoadingEnd();
        });

        $("#idEmail").val(WebInfo.UserInfo.EMail);
    }

    function EWinEventNotify(eventName, isDisplay, param) {
        switch (eventName) {
            case "LoginState":
                //updateBaseInfo();

                break;
            case "BalanceChange":
                break;
            case "SetLanguage":
                lang = param;
                mlp.loadLanguage(lang, function () {
                    window.parent.API_LoadingEnd(1);
                });
                break;
        }
    }

    function ReceiveRegisterReward() {
        let emailRule = /^\w+((-\w+)|(\.\w+))*\@[A-Za-z0-9]+((\.|-)[A-Za-z0-9]+)*\.[A-Za-z]+$/;
        let Email = $("#idEmail").val();
        let ReceiveRegisterRewardURL = "<%=EWinWeb.CasinoWorldUrl%>" + "/ReceiveRegisterReward.aspx?LoginAccount=" + WebInfo.UserInfo.LoginAccount;
       

        if (Email.search(emailRule) != -1) {

            p.SetUserMail(Math.uuid(), 0, 3, Email, "", "", ReceiveRegisterRewardURL, function (success, o) {
                if (success) {
                    if (o.Result == 0) {
                        window.parent.showMessageOK(mlp.getLanguageKey("成功"), mlp.getLanguageKey("メールの発信完了しました。"), function () {
                            if (Email != WebInfo.UserInfo.EMail) {
                                let ExtraData = WebInfo.UserInfo.ExtraData;
                                let updateinfo = {
                                    "EMail": Email,
                                    "ExtraData": ExtraData
                                };

                                p.UpdateUserAccount(WebInfo.SID, Math.uuid(), updateinfo, function (success, o) {
                                   
                                });
                            }
                        });
                    } else {
                        window.parent.showMessageOK(mlp.getLanguageKey("失敗"), mlp.getLanguageKey("Eメールの発送失敗しました"), function () {

                        });
                    }
                }
            });
        } else {
            window.parent.showMessageOK(mlp.getLanguageKey("失敗"), mlp.getLanguageKey("正しいEメールをご記入下さい"), function () {

            });
        }

    }
    window.onload = init;
</script>

<body>
    <div class="page-container">
        <!-- Heading-Top -->
        <div id="heading-top"></div>

        <div class="page-content">
            <div class="manual-container">
                <h2 class="language_replace text-center mb-md-5">マハラジャアカウント開設キャンペン</h2>
                <div class="text-wrap mt-md-5 pt-md-3 pt-lg-4" style="max-width: 640px; margin-left: auto; margin-right: auto;">
                    <p class="language_replace">◉マハラジャ開設キャンペーン！アカウント開設して頂きありがとうございます。マハラジャはアカウントを開設すると500 Ocoinをアカウント開設感謝として、皆さまにプレゼント。</p>
                    <p class="language_replace">※ご登録のEメールで下記送信後受取れます。</p>
                    <p class="language_replace">◉マハラジャ入金キャンペーン！マハラジャをご入金して頂くと、初回　500 Ocoinをさらにプレゼントしております。この場合、お客様の紹介者にもさらに、さらに500 Ocoinプレゼント。</p>
                    <p class="language_replace">※3月初日から5月末まで1人につき500 Oコイン（ローリング1倍）プレゼントいたします、更に紹介された方も500 Oコイン（ローリング20倍）プレゼント致します。</p>
                    <p class="language_replace">是非、ご家族・お友達をご紹介ください。</p>
                    <p class="language_replace">さらに稼げるご紹介ボーナスは、サポートまでお問い合わせください。</p>
                    &nbsp;&nbsp;
                    <div class="company-address mt-3 mb-4 mt-md-5 mb-md-5">
                        <p class="name language_replace">ご登録のメールアドレスご確認下さい。問題無い場合は送信をクリック</p>
                    </div>
                    <div class="form-group info">
                        <label class="form-title language_replace" langkey="信箱">信箱</label>
                        <div class="input-group">
                            <input id="idEmail" type="text" class="form-control custom-style">
                        </div>
                    </div>
                    <div class="btn-container pt-2 pt-md-4">
                        <button type="button" class="btn btn-primary btn-lg" onclick="ReceiveRegisterReward()"><span class="language_replace" langkey="送信">送信</span></button>
                    </div>
                </div>
            </div>

        </div>
    </div>
</body>
</html>
