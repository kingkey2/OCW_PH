<%@ Page Language="C#" %>

<%
    string Version = EWinWeb.Version;
    string type = Request["type"];
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

    <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/4.6.2/js/bootstrap.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/Swiper/6.7.1/swiper-bundle.min.js"></script>
    <script type="text/javascript" src="/Scripts/Common.js"></script>
    <script type="text/javascript" src="/Scripts/UIControl.js"></script>
    <script type="text/javascript" src="/Scripts/MultiLanguage.js"></script>
    <script type="text/javascript" src="/Scripts/Math.uuid.js"></script>
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
    var PaymentClient;
    var v = "<%:Version%>";
    var t = "<%:type%>";

    function init() {
        if (self == top) {
            window.parent.location.href = "index.aspx";
        }

        WebInfo = window.parent.API_GetWebInfo();
        LobbyClient = window.parent.API_GetLobbyAPI();
        PaymentClient = window.parent.API_GetPaymentAPI();
        lang = window.parent.API_GetLang();
        mlp = new multiLanguage(v);

        mlp.loadLanguage(lang, function () {
            window.parent.API_LoadingEnd();

            if (LobbyClient != null) {
                //getAllActivityFromJson();

                if (t) {
                    switch (t) {
                        case "SignUpBonus":
                            showPropUp("SignUpBonus");
                            break;
                        case "ReferFriendAndGetBonus":
                            showPropUp("ReferFriendAndGetBonus");
                            break;
                        case "NewPlayerFirstTimeDepositEvent":
                            showPropUp("NewPlayerFirstTimeDepositEvent");
                            break;
                        case "ReferFriendsAndPlay":
                            showPropUp("ReferFriendsAndPlay");
                            break;
                        case "DepositSpecialBonus":
                            showPropUp("DepositSpecialBonus");
                            break;
                    }
                }

            } else {
                window.parent.showMessageOK(mlp.getLanguageKey("錯誤"), mlp.getLanguageKey("網路錯誤"), function () {
                    window.parent.location.href = "index.aspx";
                });
            }
        });
    }

    function showPopup(DocNumber) {
        $.ajax({
            url: "<%=EWinWeb.EWinUrl%>/GetDocument.aspx?DocNumber=" + DocNumber,
            success: function (res) {
                $('#TempModal .activity-popup-detail-inner').html(res);
                $('#TempModal').modal('show');
            }
        });
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
                    getAllActivityFromJson();
                    window.parent.API_LoadingEnd(1);
                });
                break;
        }
    }

    function getAllActivityFromJson() {
        var GUID = Math.uuid();
        window.parent.API_LoadingStart();

        PaymentClient.GetAllActivityInfo(GUID, (function (success, o) {
            if (success) {
                if (o.Result == 0) {
                    var ParentMain = document.getElementById("divProcessing");
                    ParentMain.innerHTML = "";
                    var ParentMain2 = document.getElementById("divFinish");
                    ParentMain2.innerHTML = "";

                    for (var i = 0; i < o.Data.length; i++) {
                        let ActivityName = o.Data[i].ActivityName;
                        let State = o.Data[i].State;
                        let PageShowState = o.Data[i].PageShowState;

                        if (PageShowState == 0) {
                            createActivityItem(ActivityName, State);
                        }
                    }
                }
            }
        }));
        window.parent.API_LoadingEnd(1);
    }

    function createActivityItem(activityName, state) {
        var ParentMain;
        var RecordDom2;
        var TagName_Pic;
        var TagName_Title;
        var TagName_Info;
        var GUID = Math.uuid();

        if (state == 0) {
            ParentMain = document.getElementById("divProcessing");
        } else {
            ParentMain = document.getElementById("divFinish");
        }

        RecordDom2 = c.getTemplate("tmpActivity");

        TagName_Pic = activityName + "_Pic";
        TagName_Title = activityName + "_Title";
        TagName_Info = activityName + "_Info";
        if (WebInfo.DeviceType == 1) {
            TagName_Info = TagName_Info + "_M";
        } else {
            TagName_Info = TagName_Info + "_P";
        }
        ParentMain.appendChild(RecordDom2);

        LobbyClient.CheckDocumentByTagName(GUID, TagName_Info, (function (success, o1) {
            var kk = this;
            if (success) {
                if (o1.Result == 0) {
                    if (o1.DocumentList.length > 0) {
                        for (var i = 0; i < o1.DocumentList.length; i++) {
                            var a = o1.DocumentList[i];

                            kk.onclick = new Function("showPopup('" + a.DocNumber + "')");
                        }
                    }
                }
            }
        }).bind(RecordDom2));

        LobbyClient.CheckDocumentByTagName(GUID, TagName_Title, (function (success, o2) {
            var kkk = this;
            if (success) {
                if (o2.Result == 0) {
                    if (o2.DocumentList.length > 0) {
                        for (var ii = 0; ii < o2.DocumentList.length; ii++) {
                            var k1 = o2.DocumentList[ii];

                            $.ajax({
                                url: "<%=EWinWeb.EWinUrl%>/GetDocument.aspx?DocNumber=" + k1.DocNumber,
                                success: (function (res) {
                                    var b = this;
                                    $(b).find('.activityTitle').html(res);

                                }).bind(kkk)
                            });
                        }
                    }
                }
            }
        }).bind(RecordDom2));

        LobbyClient.CheckDocumentByTagName(GUID, TagName_Pic, (function (success, o2) {
            var kkkk = this;
            if (success) {
                if (o2.Result == 0) {
                    if (o2.DocumentList.length > 0) {
                        for (var iii = 0; iii < o2.DocumentList.length; iii++) {
                            var k2 = o2.DocumentList[iii];

                            $.ajax({
                                url: "<%=EWinWeb.EWinUrl%>/GetDocument.aspx?DocNumber=" + k2.DocNumber,
                                success: (function (res) {
                                    var c = this;
                                    $(c).find('.activityPicture').html(res);

                                }).bind(kkkk)
                            });
                        }
                    }
                }
            }
        }).bind(RecordDom2));

    }

    function showPropUp(activityName) {
        if (WebInfo.DeviceType == 0) {
            if (activityName == 'ReferFriendAndGetBonus') {
        
                var html = `<p><span style="font-family: 'arial black', sans-serif;"><img title="Refer a friend and get bonus" src="images/activity/ReferafriendandgetbonusPC.jpg" /></span></p>
<p class="MsoNormal" style="mso-margin-top-alt: auto; mso-margin-bottom-alt: auto; mso-pagination: widow-orphan;"><span style="font-size: 16px;"><strong><span lang="EN-US" style="font-family: Arial, 'sans-serif'; color: black;">Activity details:</span></strong></span></p>
<p class="MsoNormal" style="mso-pagination: widow-orphan;"><span lang="EN-US" style="font-size: 16px; font-family: Arial, 'sans-serif'; color: black;">Anyone who is a SPRITE player and who refers a friend to join can claim a bonus to get 0.5</span></p>
<p class="MsoNormal" style="mso-pagination: widow-orphan;"><span lang="EN-US" style="font-size: 16px; font-family: Arial, 'sans-serif'; color: black;">(PHP). Notify your friends as soon as possible so you can get great rewards together.</span></p>
<p class="MsoNormal" style="mso-pagination: widow-orphan;"><span lang="EN-US" style="font-size: 16px; font-family: Arial, 'sans-serif'; color: black;">&nbsp;</span></p>
<p class="MsoNormal" style="mso-pagination: widow-orphan;"><span lang="EN-US" style="font-size: 16px; font-family: Arial, 'sans-serif'; color: black;">The more referrals you have, the more bonus you can get, for example you have 200&nbsp;referrals *0.5= $ 100 (PHP).</span></p>
<p class="MsoNormal" style="mso-pagination: widow-orphan;"><span lang="EN-US" style="font-size: 16px; font-family: Arial, 'sans-serif'; color: black;">event:</span></p>
<p class="MsoNormal" style="mso-pagination: widow-orphan;"><span lang="EN-US" style="font-size: 16px; font-family: Arial, 'sans-serif'; color: black;">1. Referrers must deposit 500 (PHP) or more to participate.</span></p>
<p class="MsoNormal" style="mso-pagination: widow-orphan;"><span lang="EN-US" style="font-size: 16px; font-family: Arial, 'sans-serif'; color: black;">2. There is no limit to the number of referrals for each referrer, and the same promotion URL&nbsp;is limited to only one referrer.</span></p>
<p class="MsoNormal" style="mso-pagination: widow-orphan;"><span lang="EN-US" style="font-size: 16px; font-family: Arial, 'sans-serif'; color: black;">3. You must complete 3 times the valid bet before you can withdraw.</span></p>
<p class="MsoNormal" style="mso-pagination: widow-orphan;"><span lang="EN-US" style="font-size: 16px; font-family: Arial, 'sans-serif'; color: black;">&nbsp;</span></p>
<p class="MsoNormal" style="mso-pagination: widow-orphan;"><span lang="EN-US" style="font-size: 16px; font-family: Arial, 'sans-serif'; color: black;"> Anyone who uses the link to share with others to register, can get 0.5 (PHP) after&nbsp;completing the registration, unlimited claim, and quickly notify friends to make high bonuses&nbsp;together.</span></p>
<p class="MsoNormal" style="mso-pagination: widow-orphan;"><span lang="EN-US" style="font-size: 16px; font-family: Arial, 'sans-serif'; color: black;">The more referrals you have, the more bonus you can get, for example you referred 10&nbsp;people to register 10 *0.5=5 $(PHP).</span></p>
<p class="MsoNormal" style="mso-margin-top-alt: auto; mso-margin-bottom-alt: auto; mso-pagination: widow-orphan;"><span style="font-size: 16px;"><strong><span lang="EN-US" style="font-family: Arial, 'sans-serif'; color: black;">&nbsp;</span></strong></span></p>
<p class="MsoNormal" style="mso-margin-top-alt: auto; mso-margin-bottom-alt: auto; mso-pagination: widow-orphan;"><span style="font-size: 16px;"><strong><span lang="EN-US" style="font-family: Arial, 'sans-serif'; color: black;">Event rules and terms:</span></strong></span></p>
<p class="MsoNormal" style="mso-pagination: widow-orphan;"><span lang="EN-US" style="font-size: 16px; font-family: Arial, 'sans-serif'; color: black;">1. This promotion is limited to a single player, a single account, a single contact information, a single payment account, a single IP and a single computer environment to participate in. Anyone who gains the bonus by illegal means, the LUCKYSPRITE organizer has the right to adjust the content of the event.</span></p>
<p class="MsoNormal" style="mso-pagination: widow-orphan;"><span lang="EN-US" style="font-size: 16px; font-family: Arial, 'sans-serif'; color: black;">2.All games must have a win or loss calculation. Any cancelled events, games and risk-free bets will not be counted as valid bets for this event.</span></p>
<p class="MsoNormal" style="mso-pagination: widow-orphan;"><span lang="EN-US" style="font-size: 16px; font-family: Arial, 'sans-serif'; color: black;">3. LUCKYSPRITE has the right to adjust the content of the event, and can modify and stop this promotion at any time without prior notice. If the member is found to have violated the promotion rules or used any improper means to obtain the promotion, the member can cancel the distribution of the award, and claim back the profit generated by the award.</span></p>
<p class="MsoNormal" style="mso-pagination: widow-orphan;"><span style="font-size: 16px;"><span lang="EN-US" style="font-family: Arial, 'sans-serif'; color: black;">4.Risk-free bets are void bets, and the following are void bets. Casino: In the same round of Baccarat, Sic Bo or Roulette, bet Banker and Player at the same time, Odd and Even/Black and Red. Stadium: Betting on two teams at the same time on the same match. (</span><span style="font-family: 新細明體, 'serif'; color: black;">※</span><span lang="EN-US" style="font-family: Arial, 'sans-serif'; color: black;"> Cross-level is not included in the effective amount), Colored balls: bet on odd/even/big/big/small/single-double/ball color combination at the same time at the same time.</span></span></p>
<p class="MsoNormal" style="mso-pagination: widow-orphan;"><span lang="EN-US" style="font-size: 16px; font-family: Arial, 'sans-serif'; color: black;">5.LUCKYSPRITE discounts are only distributed by this website. Members are requested to check the promotions on the official website. If there are disputes arising from the discounts obtained through other channels, the company will not be responsible for it!</span></p>`;
                $('#TempModal .activity-popup-detail-inner').html(html);
                $('#TempModal').modal('show');
            }
            else if (activityName == 'NewPlayerFirstTimeDepositEvent') {
        
                var html = `<p><span style="font-family: 'arial black', sans-serif;"><img title="New Player First Time Deposit Event!" src="images/activity/NewPlayerFirstTimeDepositEventPC.jpg" /></span></p>
<p class="MsoNormal"><span style="font-family: arial, helvetica, sans-serif; font-size: 16px;"><strong style="mso-bidi-font-weight: normal;">Event time:</strong></span></p>
<p dir="ltr" style="box-sizing: border-box; margin-top: 0pt; margin-bottom: 0pt; color: rgba(0, 0, 0, 0.8); font-family: Roboto, Oswald, 'Noto Sans JP', 'Helvetica Neue', Arial, -apple-system, 'system-ui', 'Microsoft JhengHei', 'Noto Sans TC', 'Segoe UI', sans-serif, 'Apple Color Emoji', 'Segoe UI Emoji', 'Segoe UI Symbol', 'Noto Color Emoji'; font-size: 16px; background-color: #ffffff; line-height: 1.38;"><span style="font-family: arial, helvetica, sans-serif; font-size: 16px;"> </span></p>
<p class="MsoNormal"><span style="font-family: arial, helvetica, sans-serif; font-size: 16px;">2022-09-20 to end time (further notice)</span></p>
<p dir="ltr" style="box-sizing: border-box; margin-top: 0pt; margin-bottom: 0pt; color: rgba(0, 0, 0, 0.8); font-family: Roboto, Oswald, 'Noto Sans JP', 'Helvetica Neue', Arial, -apple-system, 'system-ui', 'Microsoft JhengHei', 'Noto Sans TC', 'Segoe UI', sans-serif, 'Apple Color Emoji', 'Segoe UI Emoji', 'Segoe UI Symbol', 'Noto Color Emoji'; font-size: 16px; background-color: #ffffff; line-height: 1.38;"><span style="font-family: arial, helvetica, sans-serif; font-size: 16px;"> </span></p>
<p class="MsoNormal"><span style="font-family: arial, helvetica, sans-serif; font-size: 16px;">&nbsp;</span></p>
<p dir="ltr" style="box-sizing: border-box; margin-top: 0pt; margin-bottom: 0pt; color: rgba(0, 0, 0, 0.8); font-family: Roboto, Oswald, 'Noto Sans JP', 'Helvetica Neue', Arial, -apple-system, 'system-ui', 'Microsoft JhengHei', 'Noto Sans TC', 'Segoe UI', sans-serif, 'Apple Color Emoji', 'Segoe UI Emoji', 'Segoe UI Symbol', 'Noto Color Emoji'; font-size: 16px; background-color: #ffffff; line-height: 1.38;"><span style="font-family: arial, helvetica, sans-serif; font-size: 16px;"> </span></p>
<p class="MsoNormal"><span style="font-family: arial, helvetica, sans-serif; font-size: 16px;"><strong style="mso-bidi-font-weight: normal;">Event Details:</strong></span></p>
<p dir="ltr" style="box-sizing: border-box; margin-top: 0pt; margin-bottom: 0pt; color: rgba(0, 0, 0, 0.8); font-family: Roboto, Oswald, 'Noto Sans JP', 'Helvetica Neue', Arial, -apple-system, 'system-ui', 'Microsoft JhengHei', 'Noto Sans TC', 'Segoe UI', sans-serif, 'Apple Color Emoji', 'Segoe UI Emoji', 'Segoe UI Symbol', 'Noto Color Emoji'; font-size: 16px; background-color: #ffffff; line-height: 1.38;"><span style="font-family: arial, helvetica, sans-serif; font-size: 16px;"> </span></p>
<p class="MsoNormal"><span style="font-family: arial, helvetica, sans-serif; font-size: 16px;">New players register and cash in more than 500, and you can join on this event.</span></p>
<p class="MsoNormal"><span style="font-family: arial, helvetica, sans-serif; font-size: 16px;">New players can get 50% bonus for their first cash in!</span></p>
<p dir="ltr" style="box-sizing: border-box; margin-top: 0pt; margin-bottom: 0pt; color: rgba(0, 0, 0, 0.8); font-family: Roboto, Oswald, 'Noto Sans JP', 'Helvetica Neue', Arial, -apple-system, 'system-ui', 'Microsoft JhengHei', 'Noto Sans TC', 'Segoe UI', sans-serif, 'Apple Color Emoji', 'Segoe UI Emoji', 'Segoe UI Symbol', 'Noto Color Emoji'; font-size: 16px; background-color: #ffffff; line-height: 1.38;"><span style="font-family: arial, helvetica, sans-serif; font-size: 16px;"> </span></p>
<p class="MsoNormal"><span style="font-family: arial, helvetica, sans-serif; font-size: 16px;">Receive a maximum bonus 10000!!!</span></p>
<p dir="ltr" style="box-sizing: border-box; margin-top: 0pt; margin-bottom: 0pt; color: rgba(0, 0, 0, 0.8); font-family: Roboto, Oswald, 'Noto Sans JP', 'Helvetica Neue', Arial, -apple-system, 'system-ui', 'Microsoft JhengHei', 'Noto Sans TC', 'Segoe UI', sans-serif, 'Apple Color Emoji', 'Segoe UI Emoji', 'Segoe UI Symbol', 'Noto Color Emoji'; font-size: 16px; background-color: #ffffff; line-height: 1.38;"><span style="font-family: arial, helvetica, sans-serif; font-size: 16px;"> </span></p>
<p class="MsoNormal"><span style="font-family: arial, helvetica, sans-serif; font-size: 16px;">&nbsp;</span></p>
<p dir="ltr" style="box-sizing: border-box; margin-top: 0pt; margin-bottom: 0pt; color: rgba(0, 0, 0, 0.8); font-family: Roboto, Oswald, 'Noto Sans JP', 'Helvetica Neue', Arial, -apple-system, 'system-ui', 'Microsoft JhengHei', 'Noto Sans TC', 'Segoe UI', sans-serif, 'Apple Color Emoji', 'Segoe UI Emoji', 'Segoe UI Symbol', 'Noto Color Emoji'; font-size: 16px; background-color: #ffffff; line-height: 1.38;"><span style="font-family: arial, helvetica, sans-serif; font-size: 16px;"> </span></p>
<p class="MsoNormal"><span style="font-family: arial, helvetica, sans-serif; font-size: 16px;">FRIST TIME Deposit and get 50% bonus cashback</span></p>
<p dir="ltr" style="box-sizing: border-box; margin-top: 0pt; margin-bottom: 0pt; color: rgba(0, 0, 0, 0.8); font-family: Roboto, Oswald, 'Noto Sans JP', 'Helvetica Neue', Arial, -apple-system, 'system-ui', 'Microsoft JhengHei', 'Noto Sans TC', 'Segoe UI', sans-serif, 'Apple Color Emoji', 'Segoe UI Emoji', 'Segoe UI Symbol', 'Noto Color Emoji'; font-size: 16px; background-color: #ffffff; line-height: 1.38;"><span style="font-family: arial, helvetica, sans-serif; font-size: 16px;"> </span></p>
<p class="MsoNormal"><span style="font-family: arial, helvetica, sans-serif; font-size: 16px;">Minimum deposit - 500</span></p>
<p dir="ltr" style="box-sizing: border-box; margin-top: 0pt; margin-bottom: 0pt; color: rgba(0, 0, 0, 0.8); font-family: Roboto, Oswald, 'Noto Sans JP', 'Helvetica Neue', Arial, -apple-system, 'system-ui', 'Microsoft JhengHei', 'Noto Sans TC', 'Segoe UI', sans-serif, 'Apple Color Emoji', 'Segoe UI Emoji', 'Segoe UI Symbol', 'Noto Color Emoji'; font-size: 16px; background-color: #ffffff; line-height: 1.38;"><span style="font-family: arial, helvetica, sans-serif; font-size: 16px;"> </span></p>
<p class="MsoNormal"><span style="font-family: arial, helvetica, sans-serif; font-size: 16px;">Bonus - 50%</span></p>
<p dir="ltr" style="box-sizing: border-box; margin-top: 0pt; margin-bottom: 0pt; color: rgba(0, 0, 0, 0.8); font-family: Roboto, Oswald, 'Noto Sans JP', 'Helvetica Neue', Arial, -apple-system, 'system-ui', 'Microsoft JhengHei', 'Noto Sans TC', 'Segoe UI', sans-serif, 'Apple Color Emoji', 'Segoe UI Emoji', 'Segoe UI Symbol', 'Noto Color Emoji'; font-size: 16px; background-color: #ffffff; line-height: 1.38;"><span style="font-family: arial, helvetica, sans-serif; font-size: 16px;"> </span></p>
<p class="MsoNormal"><span style="font-family: arial, helvetica, sans-serif; font-size: 16px;">Wager Limit - x5</span></p>
<p dir="ltr" style="box-sizing: border-box; margin-top: 0pt; margin-bottom: 0pt; color: rgba(0, 0, 0, 0.8); font-family: Roboto, Oswald, 'Noto Sans JP', 'Helvetica Neue', Arial, -apple-system, 'system-ui', 'Microsoft JhengHei', 'Noto Sans TC', 'Segoe UI', sans-serif, 'Apple Color Emoji', 'Segoe UI Emoji', 'Segoe UI Symbol', 'Noto Color Emoji'; font-size: 16px; background-color: #ffffff; line-height: 1.38;"><span style="font-family: arial, helvetica, sans-serif; font-size: 16px;"> </span></p>
<p class="MsoNormal"><span style="font-family: arial, helvetica, sans-serif; font-size: 16px;">Example: Deposit 500</span></p>
<p dir="ltr" style="box-sizing: border-box; margin-top: 0pt; margin-bottom: 0pt; color: rgba(0, 0, 0, 0.8); font-family: Roboto, Oswald, 'Noto Sans JP', 'Helvetica Neue', Arial, -apple-system, 'system-ui', 'Microsoft JhengHei', 'Noto Sans TC', 'Segoe UI', sans-serif, 'Apple Color Emoji', 'Segoe UI Emoji', 'Segoe UI Symbol', 'Noto Color Emoji'; font-size: 16px; background-color: #ffffff; line-height: 1.38;"><span style="font-family: arial, helvetica, sans-serif; font-size: 16px;"> </span></p>
<p class="MsoNormal"><span style="font-family: arial, helvetica, sans-serif; font-size: 16px;">500*0.5=250, 500+250=750</span></p>
<p dir="ltr" style="box-sizing: border-box; margin-top: 0pt; margin-bottom: 0pt; color: rgba(0, 0, 0, 0.8); font-family: Roboto, Oswald, 'Noto Sans JP', 'Helvetica Neue', Arial, -apple-system, 'system-ui', 'Microsoft JhengHei', 'Noto Sans TC', 'Segoe UI', sans-serif, 'Apple Color Emoji', 'Segoe UI Emoji', 'Segoe UI Symbol', 'Noto Color Emoji'; font-size: 16px; background-color: #ffffff; line-height: 1.38;"><span style="font-family: arial, helvetica, sans-serif; font-size: 16px;"> </span></p>
<p class="MsoNormal"><span style="font-family: arial, helvetica, sans-serif; font-size: 16px;">The betting wager limit is 750*5=3750 total valid bet to withdraw</span></p>
<p dir="ltr" style="box-sizing: border-box; margin-top: 0pt; margin-bottom: 0pt; color: rgba(0, 0, 0, 0.8); font-family: Roboto, Oswald, 'Noto Sans JP', 'Helvetica Neue', Arial, -apple-system, 'system-ui', 'Microsoft JhengHei', 'Noto Sans TC', 'Segoe UI', sans-serif, 'Apple Color Emoji', 'Segoe UI Emoji', 'Segoe UI Symbol', 'Noto Color Emoji'; font-size: 16px; background-color: #ffffff; line-height: 1.38;"><span style="font-family: arial, helvetica, sans-serif; font-size: 16px;"> </span></p>
<p class="MsoNormal"><span style="font-family: arial, helvetica, sans-serif; font-size: 16px;">&nbsp;</span></p>
<p dir="ltr" style="box-sizing: border-box; margin-top: 0pt; margin-bottom: 0pt; color: rgba(0, 0, 0, 0.8); font-family: Roboto, Oswald, 'Noto Sans JP', 'Helvetica Neue', Arial, -apple-system, 'system-ui', 'Microsoft JhengHei', 'Noto Sans TC', 'Segoe UI', sans-serif, 'Apple Color Emoji', 'Segoe UI Emoji', 'Segoe UI Symbol', 'Noto Color Emoji'; font-size: 16px; background-color: #ffffff; line-height: 1.38;"><span style="font-family: arial, helvetica, sans-serif; font-size: 16px;"> </span></p>
<p class="MsoNormal"><span style="font-size: 16px; font-family: arial, helvetica, sans-serif; color: #000000; font-weight: 400; font-style: normal; font-variant: normal; text-decoration: none; vertical-align: baseline; white-space: pre-wrap;">After claiming the event bonus, you will be requested to reset the withdrawal threshold to zero before you can claim the next event bonus.</span></p>
<p class="MsoNormal"><span style="font-size: 16px; font-family: arial, helvetica, sans-serif; color: #000000; font-weight: 400; font-style: normal; font-variant: normal; text-decoration: none; vertical-align: baseline; white-space: pre-wrap;">Only for electronic slot games, cannot be used in live video games.</span></p>
<p class="MsoNormal"><span style="font-size: 16px; font-family: arial, helvetica, sans-serif; color: #000000; font-weight: 400; font-style: normal; font-variant: normal; text-decoration: none; vertical-align: baseline; white-space: pre-wrap;">(Betting amount is calculated by playing electronic slot games)</span></p>
<p dir="ltr" style="line-height: 1.38; margin-top: 0pt; margin-bottom: 0pt;"><span style="font-size: 16px; font-family: arial, helvetica, sans-serif; color: #000000; font-weight: 400; font-style: normal; font-variant: normal; text-decoration: none; vertical-align: baseline; white-space: pre-wrap;">A single deposit of 1000 or more is required to participate in this activity.</span></p>
<p dir="ltr" style="box-sizing: border-box; margin-top: 0pt; margin-bottom: 0pt; color: rgba(0, 0, 0, 0.8); font-family: Roboto, Oswald, 'Noto Sans JP', 'Helvetica Neue', Arial, -apple-system, 'system-ui', 'Microsoft JhengHei', 'Noto Sans TC', 'Segoe UI', sans-serif, 'Apple Color Emoji', 'Segoe UI Emoji', 'Segoe UI Symbol', 'Noto Color Emoji'; font-size: 16px; background-color: #ffffff; line-height: 1.38;"><span style="font-family: arial, helvetica, sans-serif; font-size: 16px;"> </span></p>
<p class="MsoNormal"><span style="font-family: arial, helvetica, sans-serif; font-size: 16px;">&nbsp;</span></p>
<p dir="ltr" style="box-sizing: border-box; margin-top: 0pt; margin-bottom: 0pt; color: rgba(0, 0, 0, 0.8); font-family: Roboto, Oswald, 'Noto Sans JP', 'Helvetica Neue', Arial, -apple-system, 'system-ui', 'Microsoft JhengHei', 'Noto Sans TC', 'Segoe UI', sans-serif, 'Apple Color Emoji', 'Segoe UI Emoji', 'Segoe UI Symbol', 'Noto Color Emoji'; font-size: 16px; background-color: #ffffff; line-height: 1.38;"><span style="font-family: arial, helvetica, sans-serif; font-size: 16px;"> </span></p>
<p class="MsoNormal"><span style="font-family: arial, helvetica, sans-serif; font-size: 16px;">This promotion is open to every account</span></p>
<p dir="ltr" style="box-sizing: border-box; margin-top: 0pt; margin-bottom: 0pt; color: rgba(0, 0, 0, 0.8); font-family: Roboto, Oswald, 'Noto Sans JP', 'Helvetica Neue', Arial, -apple-system, 'system-ui', 'Microsoft JhengHei', 'Noto Sans TC', 'Segoe UI', sans-serif, 'Apple Color Emoji', 'Segoe UI Emoji', 'Segoe UI Symbol', 'Noto Color Emoji'; font-size: 16px; background-color: #ffffff; line-height: 1.38;"><span style="font-family: arial, helvetica, sans-serif; font-size: 16px;"> </span></p>
<p class="MsoNormal"><span style="font-family: arial, helvetica, sans-serif; font-size: 16px;">5x wager limit must be reached before you can apply for a withdrawal</span></p>
<p dir="ltr" style="box-sizing: border-box; margin-top: 0pt; margin-bottom: 0pt; color: rgba(0, 0, 0, 0.8); font-family: Roboto, Oswald, 'Noto Sans JP', 'Helvetica Neue', Arial, -apple-system, 'system-ui', 'Microsoft JhengHei', 'Noto Sans TC', 'Segoe UI', sans-serif, 'Apple Color Emoji', 'Segoe UI Emoji', 'Segoe UI Symbol', 'Noto Color Emoji'; font-size: 16px; background-color: #ffffff; line-height: 1.38;"><span style="font-family: arial, helvetica, sans-serif; font-size: 16px;"> </span></p>
<p class="MsoNormal"><span style="font-family: arial, helvetica, sans-serif; font-size: 16px;">(Only for electronic slot games, other games wager bet amount is invalid)</span></p>
<p dir="ltr" style="box-sizing: border-box; margin-top: 0pt; margin-bottom: 0pt; color: rgba(0, 0, 0, 0.8); font-family: Roboto, Oswald, 'Noto Sans JP', 'Helvetica Neue', Arial, -apple-system, 'system-ui', 'Microsoft JhengHei', 'Noto Sans TC', 'Segoe UI', sans-serif, 'Apple Color Emoji', 'Segoe UI Emoji', 'Segoe UI Symbol', 'Noto Color Emoji'; font-size: 16px; background-color: #ffffff; line-height: 1.38;"><span style="font-family: arial, helvetica, sans-serif; font-size: 16px;"> </span></p>
<p class="MsoNormal"><span style="font-family: arial, helvetica, sans-serif; font-size: 16px;">⛔️Cannot play: Live Casino, Sports. (Bonus cannot be withdrawn when the promotion rules </span><span style="font-family: arial, helvetica, sans-serif; font-size: 16px;">are violated.) ⛔️</span></p>
<p dir="ltr" style="box-sizing: border-box; margin-top: 0pt; margin-bottom: 0pt; color: rgba(0, 0, 0, 0.8); font-family: Roboto, Oswald, 'Noto Sans JP', 'Helvetica Neue', Arial, -apple-system, 'system-ui', 'Microsoft JhengHei', 'Noto Sans TC', 'Segoe UI', sans-serif, 'Apple Color Emoji', 'Segoe UI Emoji', 'Segoe UI Symbol', 'Noto Color Emoji'; font-size: 16px; background-color: #ffffff; line-height: 1.38;"><span style="font-family: arial, helvetica, sans-serif; font-size: 16px;"> </span></p>
<p class="MsoNormal"><span style="font-family: arial, helvetica, sans-serif; font-size: 16px;">&nbsp;</span></p>
<p dir="ltr" style="box-sizing: border-box; margin-top: 0pt; margin-bottom: 0pt; color: rgba(0, 0, 0, 0.8); font-family: Roboto, Oswald, 'Noto Sans JP', 'Helvetica Neue', Arial, -apple-system, 'system-ui', 'Microsoft JhengHei', 'Noto Sans TC', 'Segoe UI', sans-serif, 'Apple Color Emoji', 'Segoe UI Emoji', 'Segoe UI Symbol', 'Noto Color Emoji'; font-size: 16px; background-color: #ffffff; line-height: 1.38;"><span style="font-family: arial, helvetica, sans-serif; font-size: 16px;"> </span></p>
<p class="MsoNormal"><span style="font-family: arial, helvetica, sans-serif; background: #ffffff; font-size: 16px;">Event Threshold Description:</span></p>
<p dir="ltr" style="box-sizing: border-box; margin-top: 0pt; margin-bottom: 0pt; color: rgba(0, 0, 0, 0.8); font-family: Roboto, Oswald, 'Noto Sans JP', 'Helvetica Neue', Arial, -apple-system, 'system-ui', 'Microsoft JhengHei', 'Noto Sans TC', 'Segoe UI', sans-serif, 'Apple Color Emoji', 'Segoe UI Emoji', 'Segoe UI Symbol', 'Noto Color Emoji'; font-size: 16px; background-color: #ffffff; line-height: 1.38;"><span style="font-family: arial, helvetica, sans-serif; font-size: 16px; background-color: #ffffff;"> </span></p>
<p class="MsoNormal"><span style="font-family: arial, helvetica, sans-serif; background: #ffffff; font-size: 16px;">The total threshold is (Capital + Bonus) * 5.<span style="mso-spacerun: yes;">&nbsp; </span></span></p>
<p dir="ltr" style="box-sizing: border-box; margin-top: 0pt; margin-bottom: 0pt; color: rgba(0, 0, 0, 0.8); font-family: Roboto, Oswald, 'Noto Sans JP', 'Helvetica Neue', Arial, -apple-system, 'system-ui', 'Microsoft JhengHei', 'Noto Sans TC', 'Segoe UI', sans-serif, 'Apple Color Emoji', 'Segoe UI Emoji', 'Segoe UI Symbol', 'Noto Color Emoji'; font-size: 16px; background-color: #ffffff; line-height: 1.38;"><span style="font-family: arial, helvetica, sans-serif; font-size: 16px; background-color: #ffffff;"> </span></p>
<p class="MsoNormal"><span style="font-family: arial, helvetica, sans-serif; background: #ffffff; font-size: 16px;">Please note that the capital threshold is "Deposit amount * 1" and the other thresholds will be added when you choose to receive a Bonus.</span></p>
<p dir="ltr" style="box-sizing: border-box; margin-top: 0pt; margin-bottom: 0pt; color: rgba(0, 0, 0, 0.8); font-family: Roboto, Oswald, 'Noto Sans JP', 'Helvetica Neue', Arial, -apple-system, 'system-ui', 'Microsoft JhengHei', 'Noto Sans TC', 'Segoe UI', sans-serif, 'Apple Color Emoji', 'Segoe UI Emoji', 'Segoe UI Symbol', 'Noto Color Emoji'; font-size: 16px; background-color: #ffffff; line-height: 1.38;"><span style="font-family: arial, helvetica, sans-serif; font-size: 16px; background-color: #ffffff;"> </span></p>
<p class="MsoNormal"><span style="font-family: arial, helvetica, sans-serif; background: #ffffff; font-size: 16px;">&nbsp;</span></p>
<p dir="ltr" style="box-sizing: border-box; margin-top: 0pt; margin-bottom: 0pt; color: rgba(0, 0, 0, 0.8); font-family: Roboto, Oswald, 'Noto Sans JP', 'Helvetica Neue', Arial, -apple-system, 'system-ui', 'Microsoft JhengHei', 'Noto Sans TC', 'Segoe UI', sans-serif, 'Apple Color Emoji', 'Segoe UI Emoji', 'Segoe UI Symbol', 'Noto Color Emoji'; font-size: 16px; background-color: #ffffff; line-height: 1.38;"><span style="font-family: arial, helvetica, sans-serif; font-size: 16px; background-color: #ffffff;"> </span></p>
<p class="MsoNormal"><span style="font-family: arial, helvetica, sans-serif; background: #ffffff; font-size: 16px;">For example: </span></p>
<p dir="ltr" style="box-sizing: border-box; margin-top: 0pt; margin-bottom: 0pt; color: rgba(0, 0, 0, 0.8); font-family: Roboto, Oswald, 'Noto Sans JP', 'Helvetica Neue', Arial, -apple-system, 'system-ui', 'Microsoft JhengHei', 'Noto Sans TC', 'Segoe UI', sans-serif, 'Apple Color Emoji', 'Segoe UI Emoji', 'Segoe UI Symbol', 'Noto Color Emoji'; font-size: 16px; background-color: #ffffff; line-height: 1.38;"><span style="font-family: arial, helvetica, sans-serif; font-size: 16px; background-color: #ffffff;"> </span></p>
<p class="MsoNormal"><span style="font-family: arial, helvetica, sans-serif; background: #ffffff; font-size: 16px;">Deposit amount is 10,000 and choose to receive Bonus 5,000. </span></p>
<p dir="ltr" style="box-sizing: border-box; margin-top: 0pt; margin-bottom: 0pt; color: rgba(0, 0, 0, 0.8); font-family: Roboto, Oswald, 'Noto Sans JP', 'Helvetica Neue', Arial, -apple-system, 'system-ui', 'Microsoft JhengHei', 'Noto Sans TC', 'Segoe UI', sans-serif, 'Apple Color Emoji', 'Segoe UI Emoji', 'Segoe UI Symbol', 'Noto Color Emoji'; font-size: 16px; background-color: #ffffff; line-height: 1.38;"><span style="font-family: arial, helvetica, sans-serif; font-size: 16px; background-color: #ffffff;"> </span></p>
<p class="MsoNormal"><span style="font-family: arial, helvetica, sans-serif; background: #ffffff; font-size: 16px;">In this case, the total threshold is (10,000 + 5,000) * 5=75,000.</span></p>
<p dir="ltr" style="box-sizing: border-box; margin-top: 0pt; margin-bottom: 0pt; color: rgba(0, 0, 0, 0.8); font-family: Roboto, Oswald, 'Noto Sans JP', 'Helvetica Neue', Arial, -apple-system, 'system-ui', 'Microsoft JhengHei', 'Noto Sans TC', 'Segoe UI', sans-serif, 'Apple Color Emoji', 'Segoe UI Emoji', 'Segoe UI Symbol', 'Noto Color Emoji'; font-size: 16px; background-color: #ffffff; line-height: 1.38;"><span style="font-family: arial, helvetica, sans-serif; font-size: 16px; background-color: #ffffff;"> </span></p>
<p class="MsoNormal"><span style="font-family: arial, helvetica, sans-serif; background: #ffffff; font-size: 16px;">The threshold is 10,000 when depositing, and the other thresholds 65,000 will be added when you choose to receive a Bonus.</span></p>
<p dir="ltr" style="box-sizing: border-box; margin-top: 0pt; margin-bottom: 0pt; color: rgba(0, 0, 0, 0.8); font-family: Roboto, Oswald, 'Noto Sans JP', 'Helvetica Neue', Arial, -apple-system, 'system-ui', 'Microsoft JhengHei', 'Noto Sans TC', 'Segoe UI', sans-serif, 'Apple Color Emoji', 'Segoe UI Emoji', 'Segoe UI Symbol', 'Noto Color Emoji'; font-size: 16px; background-color: #ffffff; line-height: 1.38;"><span style="font-family: arial, helvetica, sans-serif; font-size: 16px;"> </span></p>
<p class="MsoNormal"><span style="font-family: arial, helvetica, sans-serif; font-size: 16px;">&nbsp;</span></p>
<p dir="ltr" style="box-sizing: border-box; margin-top: 0pt; margin-bottom: 0pt; color: rgba(0, 0, 0, 0.8); font-family: Roboto, Oswald, 'Noto Sans JP', 'Helvetica Neue', Arial, -apple-system, 'system-ui', 'Microsoft JhengHei', 'Noto Sans TC', 'Segoe UI', sans-serif, 'Apple Color Emoji', 'Segoe UI Emoji', 'Segoe UI Symbol', 'Noto Color Emoji'; font-size: 16px; background-color: #ffffff; line-height: 1.38;"><span style="font-family: arial, helvetica, sans-serif; font-size: 16px;"> </span></p>
<p class="MsoNormal"><strong><span style="font-family: arial, helvetica, sans-serif; font-size: 16px;">Event rules and terms:</span></strong></p>
<p dir="ltr" style="box-sizing: border-box; margin-top: 0pt; margin-bottom: 0pt; color: rgba(0, 0, 0, 0.8); font-family: Roboto, Oswald, 'Noto Sans JP', 'Helvetica Neue', Arial, -apple-system, 'system-ui', 'Microsoft JhengHei', 'Noto Sans TC', 'Segoe UI', sans-serif, 'Apple Color Emoji', 'Segoe UI Emoji', 'Segoe UI Symbol', 'Noto Color Emoji'; font-size: 16px; background-color: #ffffff; line-height: 1.38;"><span style="font-family: arial, helvetica, sans-serif; font-size: 16px;"> </span></p>
<p class="MsoNormal"><span style="font-family: arial, helvetica, sans-serif; font-size: 16px;">1. This promotion is limited to a single player, a single account, a single contact information, a single payment account, a single IP and a single computer environment to participate in. Anyone who gains the bonus by illegal means, the LUCKYSPRITE organizer has the right to adjust the content of the event. </span></p>
<p dir="ltr" style="box-sizing: border-box; margin-top: 0pt; margin-bottom: 0pt; color: rgba(0, 0, 0, 0.8); font-family: Roboto, Oswald, 'Noto Sans JP', 'Helvetica Neue', Arial, -apple-system, 'system-ui', 'Microsoft JhengHei', 'Noto Sans TC', 'Segoe UI', sans-serif, 'Apple Color Emoji', 'Segoe UI Emoji', 'Segoe UI Symbol', 'Noto Color Emoji'; font-size: 16px; background-color: #ffffff; line-height: 1.38;"><span style="font-family: arial, helvetica, sans-serif; font-size: 16px;"> </span></p>
<p class="MsoNormal"><span style="font-family: arial, helvetica, sans-serif; font-size: 16px;">2.All games must have a win or loss calculation. Any cancelled events, games and risk-free bets will not be counted as valid bets for this event.</span></p>
<p dir="ltr" style="box-sizing: border-box; margin-top: 0pt; margin-bottom: 0pt; color: rgba(0, 0, 0, 0.8); font-family: Roboto, Oswald, 'Noto Sans JP', 'Helvetica Neue', Arial, -apple-system, 'system-ui', 'Microsoft JhengHei', 'Noto Sans TC', 'Segoe UI', sans-serif, 'Apple Color Emoji', 'Segoe UI Emoji', 'Segoe UI Symbol', 'Noto Color Emoji'; font-size: 16px; background-color: #ffffff; line-height: 1.38;"><span style="font-family: arial, helvetica, sans-serif; font-size: 16px;"> </span></p>
<p class="MsoNormal"><span style="font-family: arial, helvetica, sans-serif; font-size: 16px;">3. LUCKYSPRITE has the right to adjust the content of the event, and can modify and stop this promotion at any time without prior notice. If the member is found to have violated the promotion rules or used any improper means to obtain the promotion, the member can cancel the distribution of the award, and claim back the profit generated by the award.。 </span></p>
<p dir="ltr" style="box-sizing: border-box; margin-top: 0pt; margin-bottom: 0pt; color: rgba(0, 0, 0, 0.8); font-family: Roboto, Oswald, 'Noto Sans JP', 'Helvetica Neue', Arial, -apple-system, 'system-ui', 'Microsoft JhengHei', 'Noto Sans TC', 'Segoe UI', sans-serif, 'Apple Color Emoji', 'Segoe UI Emoji', 'Segoe UI Symbol', 'Noto Color Emoji'; font-size: 16px; background-color: #ffffff; line-height: 1.38;"><span style="font-family: arial, helvetica, sans-serif; font-size: 16px;"> </span></p>
<p class="MsoNormal"><span style="font-family: arial, helvetica, sans-serif; font-size: 16px;">4.Risk-free bets are void bets, and the following are void bets. Casino: In the same round of Baccarat, Sic Bo or Roulette, bet Banker and Player at the same time, Odd and Even/Black and Red. Stadium: Betting on two teams at the same time on the same match. (※ Cross-level is not included in the effective amount), Colored balls: bet on odd/even/big/big/small/single-double/ball color combination at the same time at the same time. </span></p>
<p dir="ltr" style="box-sizing: border-box; margin-top: 0pt; margin-bottom: 0pt; color: rgba(0, 0, 0, 0.8); font-family: Roboto, Oswald, 'Noto Sans JP', 'Helvetica Neue', Arial, -apple-system, 'system-ui', 'Microsoft JhengHei', 'Noto Sans TC', 'Segoe UI', sans-serif, 'Apple Color Emoji', 'Segoe UI Emoji', 'Segoe UI Symbol', 'Noto Color Emoji'; font-size: 16px; background-color: #ffffff; line-height: 1.38;"><span style="font-family: arial, helvetica, sans-serif; font-size: 16px;"> </span></p>
<p class="MsoNormal"><span style="font-family: arial, helvetica, sans-serif; font-size: 16px;">5.LUCKYSPRITE discounts are only distributed by this website. Members are requested to check the promotions on the official website. If there are disputes arising from the discounts obtained through other channels, the company will not be responsible for it!</span></p>`;
                $('#TempModal .activity-popup-detail-inner').html(html);
                $('#TempModal').modal('show');
            } else if (activityName == 'ReferFriendsAndPlay') {
                var html = `<p><span style="font-family: 'arial black', sans-serif;"><img title="Refer Friends And Play" src="images/activity/ReferFriendsAndPlayPC.jpg" /></span></p>
<p class="MsoNormal"><span style="font-family: arial, helvetica, sans-serif;"><strong>Activity details:</strong></span></p>
<p class="MsoNormal"><span style="font-family: arial, helvetica, sans-serif;">⦁ Anyone who joins as a member and play games, you can recommend friends to join, and </span><span style="font-family: arial, helvetica, sans-serif;">makes a deposit can apply for a bonus and get 10 (PHP) bonus. Quickly notify your friends to earn high bonuses together.</span></p>
<p class="MsoNormal"><span style="font-family: arial, helvetica, sans-serif;">The more referrals you have, the more bonus you can get, for example you have 3 referrals</span><span style="font-family: arial, helvetica, sans-serif;">(deposit 100) *10= $ 30 (PHP).</span></p>
<p>&nbsp;</p>
<p class="MsoNormal"><span style="font-family: arial, helvetica, sans-serif;">This event:</span></p>
<p class="MsoNormal"><span style="font-family: arial, helvetica, sans-serif;">1. Referrers must deposit more than 500 (PHP) to participate.</span></p>
<p class="MsoNormal"><span style="font-family: arial, helvetica, sans-serif;">2. There is no limit to the number of referrals for each referrer, and the same promotion URL is limited to single person.</span></p>
<p class="MsoNormal"><span style="font-family: arial, helvetica, sans-serif;">3. You must complete 3 times the valid bet before you can withdraw.</span></p>
<p class="MsoNormal"><span style="font-family: arial, helvetica, sans-serif;">4. The player must deposit more than 100, before the referrer can get a bonus of 10 (PHP).</span></p>
<p class="MsoNormal">&nbsp;</p>
<p class="MsoNormal"><span style="font-family: arial, helvetica, sans-serif;">example:</span></p>
<p class="MsoNormal"><span style="font-family: arial, helvetica, sans-serif;">After player A deposits 500, invite player B to join, player B deposits 100, player A can get </span><span style="font-family: arial, helvetica, sans-serif;">10 (PHP).</span></p>
<p class="MsoNormal">&nbsp;</p>
<p class="MsoNormal"><span style="font-family: arial, helvetica, sans-serif;">⦁ Any players who use the link to share with others to register, and recharge more than 100, </span><span style="font-family: arial, helvetica, sans-serif;">unlimited claim, and quickly notify your friends now to earn high bonuses together.</span></p>
<p class="MsoNormal"><span style="font-family: arial, helvetica, sans-serif;">The more referrals you have, the more bonus you can get, for example you referred 10 </span><span style="font-family: arial, helvetica, sans-serif;">people to register and recharge 10 *10=1000 $(PHP).</span></p>
<p>&nbsp;</p>
<p class="MsoNormal"><strong><span style="font-family: arial, helvetica, sans-serif;">Event rules and terms:</span></strong></p>
<p class="MsoNormal"><span style="font-family: arial, helvetica, sans-serif;">1. This promotion is limited to a single player, a single account, a single contact information, a single payment account, a single IP and a single computer environment to participate in. Anyone who gains the bonus by illegal means, the LUCKYSPRITE organizer has the right to adjust the content of the event.</span></p>
<p class="MsoNormal"><span style="font-family: arial, helvetica, sans-serif;">2.All games must have a win or loss calculation. Any cancelled events, games and risk-free bets will not be counted as valid bets for this event.</span></p>
<p class="MsoNormal"><span style="font-family: arial, helvetica, sans-serif;">3. LUCKYSPRITE has the right to adjust the content of the event, and can modify and stop this promotion at any time without prior notice. If the member is found to have violated the promotion rules or used any improper means to obtain the promotion, the member can cancel the distribution of the award, and claim back the profit generated by the award.。</span></p>
<p class="MsoNormal"><span style="font-family: arial, helvetica, sans-serif;">4.Risk-free bets are void bets, and the following are void bets. Casino: In the same round of Baccarat, Sic Bo or Roulette, bet Banker and Player at the same time, Odd and Even/Black and Red. Stadium: Betting on two teams at the same time on the same match. (※ Cross-level is not included in the effective amount), Colored balls: bet on odd/even/big/big/small/single-double/ball color combination at the same time at the same time.</span></p>
<p class="MsoNormal"><span style="font-family: arial, helvetica, sans-serif;">5.LUCKYSPRITE discounts are only distributed by this website. Members are requested to check the promotions on the official website. If there are disputes arising from the discounts obtained through other channels, the company will not be responsible for it!</span></p>`;
                $('#TempModal .activity-popup-detail-inner').html(html);
                $('#TempModal').modal('show');
            } else if (activityName == 'DepositSpecialBonus') {
                var html = `<p><span style="font-family: 'arial black', sans-serif;"><img title="Deposit Special Bonus" src="images/activity/DepositSpecialBonusPC.jpg" /></span></p>
<p class="MsoNormal"><strong><span style="font-family: arial, helvetica, sans-serif; font-size: 16px;">Event Time: </span></strong></p>
<p><span style="font-family: arial, helvetica, sans-serif; font-size: 16px;"> </span></p>
<p class="MsoNormal"><span style="font-family: arial, helvetica, sans-serif;"><span style="font-size: 16px;">2022/06/10 - Deadline will be notified</span></span></p>
<p><span style="font-family: arial, helvetica, sans-serif; font-size: 16px;"> </span></p>
<p class="MsoNormal"><span style="font-family: arial, helvetica, sans-serif; font-size: 16px;">&nbsp;</span></p>
<p><span style="font-family: arial, helvetica, sans-serif; font-size: 16px;"> </span></p>
<p class="MsoNormal"><span style="font-family: arial, helvetica, sans-serif; font-size: 16px;"><strong style="mso-bidi-font-weight: normal;">Event Details:</strong></span></p>
<p><span style="font-family: arial, helvetica, sans-serif; font-size: 16px;"> </span></p>
<p class="MsoNormal"><span style="font-family: arial, helvetica, sans-serif; font-size: 16px;">Anyone who join and deposit for LUCKY SPRITE players can participate in this event and get </span><span style="font-family: arial, helvetica, sans-serif; font-size: 16px;">10% (unlimited deposit times) of player deposits.</span></p>
<p class="MsoNormal"><span style="font-size: 16px; font-family: arial, helvetica, sans-serif; color: #000000; font-weight: 400; font-style: normal; font-variant: normal; text-decoration: none; vertical-align: baseline; white-space: pre-wrap;">After claiming the event bonus, you will be requested to reset the withdrawal threshold to zero before you can claim the next event bonus.</span></p>
<p class="MsoNormal"><span style="font-size: 16px; font-family: arial, helvetica, sans-serif; color: #000000; font-weight: 400; font-style: normal; font-variant: normal; text-decoration: none; vertical-align: baseline; white-space: pre-wrap;">Only for electronic slot games, cannot be used in live video games.</span></p>
<p class="MsoNormal"><span style="font-size: 16px; font-family: arial, helvetica, sans-serif; color: #000000; font-weight: 400; font-style: normal; font-variant: normal; text-decoration: none; vertical-align: baseline; white-space: pre-wrap;">(Betting amount is calculated by playing electronic slot games)</span></p>
<p dir="ltr" style="line-height: 1.38; margin-top: 0pt; margin-bottom: 0pt;"><span style="font-size: 16px; font-family: arial, helvetica, sans-serif; color: #000000; font-weight: 400; font-style: normal; font-variant: normal; text-decoration: none; vertical-align: baseline; white-space: pre-wrap;">A single deposit of 1000 or more is required to participate in this activity.</span></p>
<p class="MsoNormal"><span id="docs-internal-guid-b77e9594-7fff-b430-669d-ab2e5590b1fb" style="font-family: arial, helvetica, sans-serif;"></span></p>
<p class="MsoNormal">&nbsp;</p>
<p><span style="font-family: arial, helvetica, sans-serif; font-size: 16px;"> </span></p>
<p class="MsoNormal"><span style="font-family: arial, helvetica, sans-serif; font-size: 16px;">This promotion is only applicable to players who deposit (wager limit requires 10 times the </span><span style="font-family: arial, helvetica, sans-serif; font-size: 16px;">deposit amount)</span></p>
<p><span style="font-family: arial, helvetica, sans-serif; font-size: 16px;"> </span></p>
<p class="MsoNormal"><span style="font-family: arial, helvetica, sans-serif; font-size: 16px;">Example: Deposit 1000</span></p>
<p><span style="font-family: arial, helvetica, sans-serif; font-size: 16px;"> </span></p>
<p class="MsoNormal"><span style="font-family: arial, helvetica, sans-serif; font-size: 16px;">1000*10%=1100</span></p>
<p><span style="font-family: arial, helvetica, sans-serif; font-size: 16px;"> </span></p>
<p class="MsoNormal"><span style="font-family: arial, helvetica, sans-serif; font-size: 16px;">1100*(10 times the bet)=11000</span></p>
<p><span style="font-family: arial, helvetica, sans-serif; font-size: 16px;"> </span></p>
<p class="MsoNormal"><span style="font-family: arial, helvetica, sans-serif; font-size: 16px;">Withdrawal approved when the bet amount reaches 11000</span></p>
<p><span style="font-family: arial, helvetica, sans-serif; font-size: 16px;"> </span></p>
<p class="MsoNormal"><span style="font-family: arial, helvetica, sans-serif; font-size: 16px;">A single deposit of 1000 or more is required to participate in this activity</span></p>
<p><span style="font-family: arial, helvetica, sans-serif; font-size: 16px;"> </span></p>
<p class="MsoNormal"><span style="font-family: arial, helvetica, sans-serif; font-size: 16px; background-color: #ffffff;">&nbsp;</span></p>
<p><span style="font-family: arial, helvetica, sans-serif; font-size: 16px; background-color: #ffffff;"> </span></p>
<p class="MsoNormal"><span style="font-family: arial, helvetica, sans-serif; background: #ffffff; font-size: 16px;">Event Threshold Description:</span></p>
<p><span style="font-family: arial, helvetica, sans-serif; font-size: 16px; background-color: #ffffff;"> </span></p>
<p class="MsoNormal"><span style="font-family: arial, helvetica, sans-serif; background: #ffffff; font-size: 16px;">The total threshold is (Capital + Bonus) * 10.</span></p>
<p><span style="font-family: arial, helvetica, sans-serif; font-size: 16px; background-color: #ffffff;"> </span></p>
<p class="MsoNormal"><span style="font-family: arial, helvetica, sans-serif; background: #ffffff; font-size: 16px;">Please note that the capital threshold is "Deposit amount * 1" and the other thresholds will be added when you choose to receive a Bonus.</span></p>
<p><span style="font-family: arial, helvetica, sans-serif; font-size: 16px; background-color: #ffffff;"> </span></p>
<p class="MsoNormal"><span style="font-family: arial, helvetica, sans-serif; background: #ffffff; font-size: 16px;">&nbsp;</span></p>
<p><span style="font-family: arial, helvetica, sans-serif; font-size: 16px; background-color: #ffffff;"> </span></p>
<p class="MsoNormal"><span style="font-family: arial, helvetica, sans-serif; background: #ffffff; font-size: 16px;">For example: </span></p>
<p><span style="font-family: arial, helvetica, sans-serif; font-size: 16px; background-color: #ffffff;"> </span></p>
<p class="MsoNormal"><span style="font-family: arial, helvetica, sans-serif; background: #ffffff; font-size: 16px;">Deposit amount is 10,000 and choose to receive Bonus 1,000. </span></p>
<p><span style="font-family: arial, helvetica, sans-serif; font-size: 16px; background-color: #ffffff;"> </span></p>
<p class="MsoNormal"><span style="font-family: arial, helvetica, sans-serif; background: #ffffff; font-size: 16px;">In this case, the total threshold is (10,000 + 1,000) * 10=110,000.</span></p>
<p><span style="font-family: arial, helvetica, sans-serif; font-size: 16px; background-color: #ffffff;"> </span></p>
<p class="MsoNormal"><span style="font-family: arial, helvetica, sans-serif; background: #ffffff; font-size: 16px;">The threshold is 10,000 when depositing, and the other thresholds 100,000 will be added when you choose to receive a Bonus.</span></p>
<p><span style="font-family: arial, helvetica, sans-serif; font-size: 16px; background-color: #ffffff;"> </span></p>
<p class="MsoNormal"><span style="font-family: arial, helvetica, sans-serif; background: #ffffff; font-size: 16px;">&nbsp;</span></p>
<p><span style="font-family: arial, helvetica, sans-serif; font-size: 16px;"> </span></p>
<p class="MsoNormal"><strong><span style="font-family: arial, helvetica, sans-serif; font-size: 16px;">Event rules and terms:</span></strong></p>
<p><span style="font-family: arial, helvetica, sans-serif; font-size: 16px;"> </span></p>
<p class="MsoNormal"><span style="font-family: arial, helvetica, sans-serif; font-size: 16px;">1. This promotion is limited to a single player, a single account, a single contact information, a single payment account, a single IP and a single computer environment to participate in. Anyone who gains the bonus by illegal means, the LUCKYSPRITE organizer has the right to adjust the content of the event. </span></p>
<p><span style="font-family: arial, helvetica, sans-serif; font-size: 16px;"> </span></p>
<p class="MsoNormal"><span style="font-family: arial, helvetica, sans-serif; font-size: 16px;">2.All games must have a win or loss calculation. Any cancelled events, games and risk-free bets will not be counted as valid bets for this event.</span></p>
<p><span style="font-family: arial, helvetica, sans-serif; font-size: 16px;"> </span></p>
<p class="MsoNormal"><span style="font-family: arial, helvetica, sans-serif; font-size: 16px;">3. LUCKYSPRITE has the right to adjust the content of the event, and can modify and stop this promotion at any time without prior notice. If the member is found to have violated the promotion rules or used any improper means to obtain the promotion, the member can cancel the distribution of the award, and claim back the profit generated by the award.。 </span></p>
<p><span style="font-family: arial, helvetica, sans-serif; font-size: 16px;"> </span></p>
<p class="MsoNormal"><span style="font-family: arial, helvetica, sans-serif; font-size: 16px;">4.Risk-free bets are void bets, and the following are void bets. Casino: In the same round of Baccarat, Sic Bo or Roulette, bet Banker and Player at the same time, Odd and Even/Black and Red. Stadium: Betting on two teams at the same time on the same match. (※ Cross-level is not included in the effective amount), Colored balls: bet on odd/even/big/big/small/single-double/ball color combination at the same time at the same time. </span></p>
<p><span style="font-family: arial, helvetica, sans-serif; font-size: 16px;"> </span></p>
<p class="MsoNormal"><span style="font-family: arial, helvetica, sans-serif; font-size: 16px;">5.LUCKYSPRITE discounts are only distributed by this website. Members are requested to check the promotions on the official website. If there are disputes arising from the discounts obtained through other channels, the company will not be responsible for it!</span></p>`;
                $('#TempModal .activity-popup-detail-inner').html(html);
                $('#TempModal').modal('show');
            } else if (activityName == 'SignUpBonus') {
                var html = `<p><span style="font-family: 'arial black', sans-serif;"><img title="Sign Up Bonus" src="images/activity/SignUpBonusPC.jpg" /></span></p>
<p class="MsoNormal"><span style="font-family: arial, helvetica, sans-serif; font-size: 16px;"><strong>Event Time:<br></strong>No Limit<strong><br><!-- [if !supportLineBreakNewLine]--><br><!--[endif]--></strong></span></p>
<p class="MsoNormal"><span style="font-family: arial, helvetica, sans-serif; font-size: 16px;"><strong>Event Details:</strong></span></p>
<p dir="ltr" style="line-height: 1.38; margin-top: 0pt; margin-bottom: 0pt;"><span style="font-family: arial, helvetica, sans-serif;"><span style="font-size: 16px; color: #000000; background-color: transparent; font-style: normal; font-variant: normal; text-decoration: none; vertical-align: baseline; white-space: pre-wrap;">Event rules</span></span></p>
<p dir="ltr" style="line-height: 1.38; margin-top: 0pt; margin-bottom: 0pt;"><span style="font-family: arial, helvetica, sans-serif;"><span style="font-size: 16px; color: #000000; background-color: transparent; font-style: normal; font-variant: normal; text-decoration: none; vertical-align: baseline; white-space: pre-wrap;">Starting now, new members will receive 20 bonus when they register.</span></span></p>
<p dir="ltr" style="line-height: 1.38; margin-top: 0pt; margin-bottom: 0pt;"><span style="font-family: arial, helvetica, sans-serif;"><span style="font-size: 16px; color: #000000; background-color: transparent; font-style: normal; font-variant: normal; text-decoration: none; vertical-align: baseline; white-space: pre-wrap;">One set of IP have 3 chances, sample: IP 123.321.21 with 3 different accounts, If there is a fourth group of different accounts, bonus will not be given.</span></span></p>
<p class="MsoNormal"><span style="font-family: arial, helvetica, sans-serif;"><span style="font-size: 16px;"><span style="font-weight: normal;">&nbsp;</span></span></span></p>
<p dir="ltr" style="line-height: 1.38; margin-top: 0pt; margin-bottom: 0pt;"><span style="font-family: arial, helvetica, sans-serif;"><span style="font-size: 16px; color: #000000; background-color: transparent; font-style: normal; font-variant: normal; text-decoration: none; vertical-align: baseline; white-space: pre-wrap;">Bonus rules</span></span></p>
<p dir="ltr" style="line-height: 1.38; margin-top: 0pt; margin-bottom: 0pt;"><span style="font-family: arial, helvetica, sans-serif;"><span style="font-size: 16px; color: #000000; font-style: normal; font-variant: normal; text-decoration: none; vertical-align: baseline; white-space: pre-wrap;"><span id="docs-internal-guid-074cd914-7fff-86a2-caad-3ff086f27ba2"><span style="font-size: 11pt; font-family: Arial; font-variant-numeric: normal; font-variant-east-asian: normal; vertical-align: baseline;"> * The ₱20 you received in this event will not be included in the valid bet calculation of the VIP level upgrade.</span></span></span></span></p>
<p dir="ltr" style="line-height: 1.38; margin-top: 0pt; margin-bottom: 0pt;"><span style="font-family: arial, helvetica, sans-serif;"><span id="docs-internal-guid-79b55fd0-7fff-2c63-0dfc-c36c95a2c1d1" style="font-size: 16px; color: #000000;"><span style="font-variant-numeric: normal; font-variant-east-asian: normal; vertical-align: baseline; white-space: pre-wrap;"> * If you do not receive the 20 bonus and deposit directly, it will be deemed as giving up this event. The system will automatically reclaim the 20 bonus.</span></span></span></p>
<p dir="ltr" style="line-height: 1.38; margin-top: 0pt; margin-bottom: 0pt;"><span style="font-family: arial, helvetica, sans-serif;"><span style="font-size: 16px; color: #000000; background-color: transparent; font-style: normal; font-variant: normal; text-decoration: none; vertical-align: baseline; white-space: pre-wrap;"> * If main wallet did not exceed 200, the wallet balance will be cleared.</span></span></p>
<p dir="ltr" style="line-height: 1.38; margin-top: 0pt; margin-bottom: 0pt;"><span style="font-family: arial, helvetica, sans-serif;"><span style="font-size: 16px; color: #000000; background-color: transparent; font-style: normal; font-variant: normal; text-decoration: none; vertical-align: baseline; white-space: pre-wrap;"> * If main wallet exceeds 200, wallet will be emptied first when recharging, and the 200 will be given.</span></span></p>
<p class="MsoNormal">&nbsp;</p>
<p class="MsoNormal"><span style="font-family: arial, helvetica, sans-serif; font-size: 16px;"><strong>Event rules and terms:</strong></span></p>
<p class="MsoNormal"><span style="font-family: arial, helvetica, sans-serif; font-size: 16px;">1. This promotion is limited to a single player, a single account, a single contact information, a single payment account, a single IP and a single computer environment to participate in. Anyone who gains the bonus by illegal means, the LUCKYSPRITE has the right to adjust the content of the event. </span></p>
<p class="MsoNormal"><span style="font-family: arial, helvetica, sans-serif; font-size: 16px;">2. All games must have a win or loss calculation. Any cancelled events, games and risk-free bets will not be counted as valid bets for this event.</span></p>
<p class="MsoNormal"><span style="font-family: arial, helvetica, sans-serif; font-size: 16px;">3. LUCKYSPRITE has the right to adjust the content of the event, and can modify and stop this promotion at any time without prior notice. If the member is found to have violated the promotion rules or used any improper means to obtain the promotion, LUCKYSPRITE can cancel the distribution of the award, and claim back the profit generated by the award.</span></p>
<p class="MsoNormal"><span style="font-family: arial, helvetica, sans-serif; font-size: 16px;">4. Risk-free bets are void bets, and the following are void bets,Casino: In the same round of Baccarat, Sic Bo or Roulette, betting Banker and Player at the same time, Odd and Even/Black and Red. Stadium: Betting on two teams at the same time on the same match. (※ Cross-level is not included in the effective amount), Colored balls: bet on odd/even/big/big/small/single-double/ball color combination at the same time at the same time. </span></p>
<p><span style="font-family: arial, helvetica, sans-serif; font-size: 16px;"><span style="line-height: 115%;">5.LUCKYSPRITE bonuses are only distributed by this website. It is recommended that members visit the official website to check out the promotions. If there are disputes arising from the bonuses obtained through other channels, the company will not be responsible for it!</span></span></p>`;
                $('#TempModal .activity-popup-detail-inner').html(html);
                $('#TempModal').modal('show');
            }
        }
        else {
            if (activityName == 'ReferFriendAndGetBonus') {
                var html =`<p><span style="font-family: 'arial black', sans-serif;"><img width="400" height="126" title="Refer a friend and get bonus" src="images/activity/ReferafriendandgetbonusPhone.jpg" /></span></p>
<p class="MsoNormal"><span style="font-family: arial, helvetica, sans-serif;"><strong style="mso-bidi-font-weight: normal;">Activity details:</strong></span></p>
<p class="MsoNormal"><span style="font-family: arial, helvetica, sans-serif;">⦁ Anyone who is a SPRITE player and who refers a friend to join can claim a bonus to get 0.5</span><span style="font-family: arial, helvetica, sans-serif;">(PHP). Notify your friends as soon as possible so you can get great rewards together.</span></p>
<p class="MsoNormal"><span style="font-family: arial, helvetica, sans-serif;">&nbsp;</span></p>
<p class="MsoNormal"><span style="font-family: arial, helvetica, sans-serif;">The more referrals you have, the more bonus you can get, for example you have 200 </span><span style="font-family: arial, helvetica, sans-serif;">referrals *0.5= $ 100 (PHP).</span></p>
<p class="MsoNormal"><span style="font-family: arial, helvetica, sans-serif;">event:</span></p>
<p class="MsoNormal"><span style="font-family: arial, helvetica, sans-serif;">1. Referrers must deposit 500 (PHP) or more to participate.</span></p>
<p class="MsoNormal"><span style="font-family: arial, helvetica, sans-serif;">2. There is no limit to the number of referrals for each referrer, and the same promotion URL </span><span style="font-family: arial, helvetica, sans-serif;">is limited to only one referrer.</span></p>
<p class="MsoNormal"><span style="font-family: arial, helvetica, sans-serif;">3. You must complete 3 times the valid bet before you can withdraw.</span></p>
<p class="MsoNormal">&nbsp;</p>
<p class="MsoNormal"><span style="font-family: arial, helvetica, sans-serif;">⦁ Anyone who uses the link to share with others to register, can get 0.5 (PHP) after </span><span style="font-family: arial, helvetica, sans-serif;">completing the registration, unlimited claim, and quickly notify friends to make high bonuses </span><span style="font-family: arial, helvetica, sans-serif;">together.</span></p>
<p class="MsoNormal"><span style="font-family: arial, helvetica, sans-serif;">The more referrals you have, the more bonus you can get, for example you referred 10 </span><span style="font-family: arial, helvetica, sans-serif;">people to register 10 *0.5=5 $(PHP).</span></p>
<p class="MsoNormal"><span style="font-family: arial, helvetica, sans-serif;">&nbsp;</span></p>
<p class="MsoNormal"><strong><span style="font-family: arial, helvetica, sans-serif;">Event rules and terms:</span></strong></p>
<p class="MsoNormal"><span style="font-family: arial, helvetica, sans-serif;">1. This promotion is limited to a single player, a single account, a single contact information, a single payment account, a single IP and a single computer environment to participate in. Anyone who gains the bonus by illegal means, the LUCKYSPRITE organizer has the right to adjust the content of the event. </span></p>
<p class="MsoNormal"><span style="font-family: arial, helvetica, sans-serif;">2.All games must have a win or loss calculation. Any cancelled events, games and risk-free bets will not be counted as valid bets for this event.</span></p>
<p class="MsoNormal"><span style="font-family: arial, helvetica, sans-serif;">3. LUCKYSPRITE has the right to adjust the content of the event, and can modify and stop this promotion at any time without prior notice. If the member is found to have violated the promotion rules or used any improper means to obtain the promotion, the member can cancel the distribution of the award, and claim back the profit generated by the award.</span></p>
<p class="MsoNormal"><span style="font-family: arial, helvetica, sans-serif;">4.Risk-free bets are void bets, and the following are void bets. Casino: In the same round of Baccarat, Sic Bo or Roulette, bet Banker and Player at the same time, Odd and Even/Black and Red. Stadium: Betting on two teams at the same time on the same match. (※ Cross-level is not included in the effective amount), Colored balls: bet on odd/even/big/big/small/single-double/ball color combination at the same time at the same time. </span></p>
<p class="MsoNormal"><span style="font-family: arial, helvetica, sans-serif;">5.LUCKYSPRITE discounts are only distributed by this website. Members are requested to check the promotions on the official website. If there are disputes arising from the discounts obtained through other channels, the company will not be responsible for it!</span></p>`;
                $('#TempModal .activity-popup-detail-inner').html(html);
                $('#TempModal').modal('show');
            } else if (activityName == 'NewPlayerFirstTimeDepositEvent') {
                var html = `<p><span style="font-family: 'arial black', sans-serif;"><img title="New Player First Time Deposit Event!" src="images/activity/NewPlayerFirstTimeDepositEventPhone.jpg" /></span></p>
<p class="MsoNormal"><span style="font-family: arial, helvetica, sans-serif; font-size: 16px;"><strong>Event time:</strong></span></p>
<p class="MsoNormal"><span style="font-family: arial, helvetica, sans-serif; font-size: 16px;">2022-09-20 to end time (further notice)</span></p>
<p class="MsoNormal">&nbsp;</p>
<p class="MsoNormal"><span style="font-family: arial, helvetica, sans-serif; font-size: 16px;"><strong>Event Details:</strong></span></p>
<p class="MsoNormal"><span style="font-family: arial, helvetica, sans-serif; font-size: 16px;">New players register and cash in more than 500, and you can join on this event.</span></p>
<p class="MsoNormal"><span style="font-family: arial, helvetica, sans-serif; font-size: 16px;">New players can get 50% bonus for their first cash in!</span></p>
<p class="MsoNormal"><span style="font-family: arial, helvetica, sans-serif; font-size: 16px;">Receive a maximum bonus 10000!!!</span></p>
<p class="MsoNormal">&nbsp;</p>
<p class="MsoNormal"><span style="font-family: arial, helvetica, sans-serif; font-size: 16px;">FRIST TIME Deposit and get 50% bonus cashback</span></p>
<p class="MsoNormal"><span style="font-family: arial, helvetica, sans-serif; font-size: 16px;">Minimum deposit - 500</span></p>
<p class="MsoNormal"><span style="font-family: arial, helvetica, sans-serif; font-size: 16px;">Bonus - 50%</span></p>
<p class="MsoNormal"><span style="font-family: arial, helvetica, sans-serif; font-size: 16px;">Wager Limit - x5</span></p>
<p class="MsoNormal"><span style="font-family: arial, helvetica, sans-serif; font-size: 16px;">Example: Deposit 500</span></p>
<p class="MsoNormal"><span style="font-family: arial, helvetica, sans-serif; font-size: 16px;">500*0.5=250, 500+250=750</span></p>
<p class="MsoNormal"><span style="font-family: arial, helvetica, sans-serif; font-size: 16px;">The betting wager limit is 750*5=3750 total valid bet to withdraw</span></p>
<p class="MsoNormal">&nbsp;</p>
<p class="MsoNormal"><span style="font-size: 16px; font-family: arial, helvetica, sans-serif; color: #000000; font-weight: 400; font-style: normal; font-variant: normal; text-decoration: none; vertical-align: baseline; white-space: pre-wrap;">After claiming the event bonus, you will be requested to reset the withdrawal threshold to zero before you can claim the next event bonus.</span></p>
<p class="MsoNormal"><span style="font-size: 16px; font-family: arial, helvetica, sans-serif; color: #000000; font-weight: 400; font-style: normal; font-variant: normal; text-decoration: none; vertical-align: baseline; white-space: pre-wrap;">Only for electronic slot games, cannot be used in live video games.</span></p>
<p class="MsoNormal"><span style="font-size: 16px; font-family: arial, helvetica, sans-serif; color: #000000; font-weight: 400; font-style: normal; font-variant: normal; text-decoration: none; vertical-align: baseline; white-space: pre-wrap;">(Betting amount is calculated by playing electronic slot games)</span></p>
<p dir="ltr" style="line-height: 1.38; margin-top: 0pt; margin-bottom: 0pt;"><span style="font-size: 16px; font-family: arial, helvetica, sans-serif; color: #000000; font-weight: 400; font-style: normal; font-variant: normal; text-decoration: none; vertical-align: baseline; white-space: pre-wrap;">A single deposit of 1000 or more is required to participate in this activity.</span></p>
<p class="MsoNormal">&nbsp;</p>
<p class="MsoNormal"><span style="font-family: arial, helvetica, sans-serif; font-size: 16px;">This promotion is open to every account</span></p>
<p class="MsoNormal"><span style="font-family: arial, helvetica, sans-serif; font-size: 16px;">5x wager limit must be reached before you can apply for a withdrawal</span></p>
<p class="MsoNormal"><span style="font-family: arial, helvetica, sans-serif; font-size: 16px;">(Only for electronic slot games, other games wager bet amount is invalid)</span></p>
<p class="MsoNormal"><span style="font-family: arial, helvetica, sans-serif;"><span style="font-size: 16px;">⛔️Cannot play: Live Casino, Sports. (Bonus cannot be withdrawn when the promotion rules</span><span style="font-size: 16px;">are violated.) ⛔️</span></span></p>
<p class="MsoNormal">&nbsp;</p>
<p class="MsoNormal"><span style="font-family: arial, helvetica, sans-serif; background: #ffffff; font-size: 16px;">Event Threshold Description:</span></p>
<p class="MsoNormal"><span style="font-family: arial, helvetica, sans-serif; background: #ffffff; font-size: 16px;">The total threshold is (Capital + Bonus) * 5.&nbsp;</span></p>
<p class="MsoNormal"><span style="font-family: arial, helvetica, sans-serif; background: #ffffff; font-size: 16px;">Please note that the capital threshold is "Deposit amount * 1" and the other thresholds will be added when you choose to receive a Bonus.</span></p>
<p class="MsoNormal">&nbsp;</p>
<p class="MsoNormal"><span style="font-family: arial, helvetica, sans-serif; background: #ffffff; font-size: 16px;">For example:</span></p>
<p class="MsoNormal"><span style="font-family: arial, helvetica, sans-serif; background: #ffffff; font-size: 16px;">Deposit amount is 10,000 and choose to receive Bonus 5,000.</span></p>
<p class="MsoNormal"><span style="font-family: arial, helvetica, sans-serif; background: #ffffff; font-size: 16px;">In this case, the total threshold is (10,000 + 5,000) * 5=75,000.</span></p>
<p class="MsoNormal"><span style="font-family: arial, helvetica, sans-serif; background: #ffffff; font-size: 16px;">The threshold is 10,000 when depositing, and the other thresholds 65,000 will be added when you choose to receive a Bonus.</span></p>
<p class="MsoNormal">&nbsp;</p>
<p class="MsoNormal"><strong><span style="font-family: arial, helvetica, sans-serif; font-size: 16px;">Event rules and terms:</span></strong></p>
<p class="MsoNormal"><span style="font-family: arial, helvetica, sans-serif; font-size: 16px;">1. This promotion is limited to a single player, a single account, a single contact information, a single payment account, a single IP and a single computer environment to participate in. Anyone who gains the bonus by illegal means, the LUCKYSPRITE&nbsp;organizer has the right to adjust the content of the event.</span></p>
<p class="MsoNormal"><span style="font-family: arial, helvetica, sans-serif; font-size: 16px;">2.All games must have a win or loss calculation. Any cancelled events, games and risk-free bets will not be counted as valid bets for this event.</span></p>
<p class="MsoNormal"><span style="font-family: arial, helvetica, sans-serif; font-size: 16px;">3. LUCKYSPRITE&nbsp;has the right to adjust the content of the event, and can modify and stop this promotion at any time without prior notice. If the member is found to have violated the promotion rules or used any improper means to obtain the promotion, the member can cancel the distribution of the award, and claim back the profit generated by the award.。</span></p>
<p class="MsoNormal"><span style="font-family: arial, helvetica, sans-serif; font-size: 16px;">4.Risk-free bets are void bets, and the following are void bets. Casino: In the same round of Baccarat, Sic Bo or Roulette, bet Banker and Player at the same time, Odd and Even/Black and Red. Stadium: Betting on two teams at the same time on the same match. (※ Cross-level is not included in the effective amount), Colored balls: bet on odd/even/big/big/small/single-double/ball color combination at the same time at the same time.</span></p>
<p class="MsoNormal"><span style="font-family: arial, helvetica, sans-serif; font-size: 16px;">5.LUCKYSPRITE discounts are only distributed by this website. Members are requested to check the promotions on the official website. If there are disputes arising from the discounts obtained through other channels, the company will not be responsible for it!</span></p>`;
                $('#TempModal .activity-popup-detail-inner').html(html);
                $('#TempModal').modal('show');
            } else if (activityName == 'ReferFriendsAndPlay') {
                var html = `<p><span style="font-family: 'arial black', sans-serif;"><img title="Refer Friends And Play" src="images/activity/ReferFriendsAndPlayPhone.jpg" /></span></p>
<p class="MsoNormal"><span style="font-family: arial, helvetica, sans-serif;"><strong style="mso-bidi-font-weight: normal;">Activity details:</strong></span></p>
<p><span style="font-family: arial, helvetica, sans-serif;"> </span></p>
<p class="MsoNormal"><span style="font-family: arial, helvetica, sans-serif;">⦁ Anyone who joins as a member and play games, you can recommend friends to join, and </span><span style="font-family: arial, helvetica, sans-serif;">makes a deposit can apply for a bonus and get 10 (PHP) bonus. Quickly notify your friends </span><span style="font-family: arial, helvetica, sans-serif;">to earn high bonuses together.</span></p>
<p><span style="font-family: arial, helvetica, sans-serif;"> </span></p>
<p class="MsoNormal"><span style="font-family: arial, helvetica, sans-serif;">The more referrals you have, the more bonus you can get, for example you have 3 referrals</span><span style="font-family: arial, helvetica, sans-serif;">(deposit 100) *10= $ 30 (PHP).</span></p>
<p class="MsoNormal">&nbsp;</p>
<p><span style="font-family: arial, helvetica, sans-serif;"> </span></p>
<p class="MsoNormal"><span style="font-family: arial, helvetica, sans-serif;">This event:</span></p>
<p><span style="font-family: arial, helvetica, sans-serif;"> </span></p>
<p class="MsoNormal"><span style="font-family: arial, helvetica, sans-serif;">1. Referrers must deposit more than 500 (PHP) to participate.</span></p>
<p><span style="font-family: arial, helvetica, sans-serif;"> </span></p>
<p class="MsoNormal"><span style="font-family: arial, helvetica, sans-serif;">2. There is no limit to the number of referrals for each referrer, and the same promotion URL </span><span style="font-family: arial, helvetica, sans-serif;">is limited to single person.</span></p>
<p><span style="font-family: arial, helvetica, sans-serif;"> </span></p>
<p class="MsoNormal"><span style="font-family: arial, helvetica, sans-serif;">3. You must complete 3 times the valid bet before you can withdraw.</span></p>
<p><span style="font-family: arial, helvetica, sans-serif;"> </span></p>
<p class="MsoNormal"><span style="font-family: arial, helvetica, sans-serif;">4. The player must deposit more than 100, before the referrer can get a bonus of 10 (PHP).</span></p>
<p><span style="font-family: arial, helvetica, sans-serif;"> </span></p>
<p class="MsoNormal"><span style="font-family: arial, helvetica, sans-serif;">&nbsp;</span></p>
<p><span style="font-family: arial, helvetica, sans-serif;"> </span></p>
<p class="MsoNormal"><span style="font-family: arial, helvetica, sans-serif;">example:</span></p>
<p><span style="font-family: arial, helvetica, sans-serif;"> </span></p>
<p class="MsoNormal"><span style="font-family: arial, helvetica, sans-serif;">After player A deposits 500, invite player B to join, player B deposits 100, player A can get </span><span style="font-family: arial, helvetica, sans-serif;">10 (PHP).</span></p>
<p><span style="font-family: arial, helvetica, sans-serif;"> </span></p>
<p class="MsoNormal"><span style="font-family: arial, helvetica, sans-serif;">&nbsp;</span></p>
<p><span style="font-family: arial, helvetica, sans-serif;"> </span></p>
<p class="MsoNormal"><span style="font-family: arial, helvetica, sans-serif;">⦁ Any players who use the link to share with others to register, and recharge more than 100,</span><span style="font-family: arial, helvetica, sans-serif;">unlimited claim, and quickly notify your friends now to earn high bonuses together.</span></p>
<p><span style="font-family: arial, helvetica, sans-serif;"> </span></p>
<p class="MsoNormal"><span style="font-family: arial, helvetica, sans-serif;">The more referrals you have, the more bonus you can get, for example you referred 10 </span><span style="font-family: arial, helvetica, sans-serif;">people to register and recharge 10 *10=1000 $(PHP).</span></p>
<p><span style="font-family: arial, helvetica, sans-serif;"> </span></p>
<p class="MsoNormal"><span style="font-family: arial, helvetica, sans-serif;">&nbsp;</span></p>
<p><span style="font-family: arial, helvetica, sans-serif;"> </span></p>
<p class="MsoNormal"><strong><span style="font-family: arial, helvetica, sans-serif;">Event rules and terms:</span></strong></p>
<p><span style="font-family: arial, helvetica, sans-serif;"> </span></p>
<p class="MsoNormal"><span style="font-family: arial, helvetica, sans-serif;">1. This promotion is limited to a single player, a single account, a single contact information, a single payment account, a single IP and a single computer environment to participate in. Anyone who gains the bonus by illegal means, the LUCKYSPRITE organizer has the right to adjust the content of the event. </span></p>
<p><span style="font-family: arial, helvetica, sans-serif;"> </span></p>
<p class="MsoNormal"><span style="font-family: arial, helvetica, sans-serif;">2.All games must have a win or loss calculation. Any cancelled events, games and risk-free bets will not be counted as valid bets for this event.</span></p>
<p><span style="font-family: arial, helvetica, sans-serif;"> </span></p>
<p class="MsoNormal"><span style="font-family: arial, helvetica, sans-serif;">3. LUCKYSPRITE has the right to adjust the content of the event, and can modify and stop this promotion at any time without prior notice. If the member is found to have violated the promotion rules or used any improper means to obtain the promotion, the member can cancel the distribution of the award, and claim back the profit generated by the award.</span></p>
<p><span style="font-family: arial, helvetica, sans-serif;"> </span></p>
<p class="MsoNormal"><span style="font-family: arial, helvetica, sans-serif;">4.Risk-free bets are void bets, and the following are void bets. Casino: In the same round of Baccarat, Sic Bo or Roulette, bet Banker and Player at the same time, Odd and Even/Black and Red. Stadium: Betting on two teams at the same time on the same match. (※ Cross-level is not included in the effective amount), Colored balls: bet on odd/even/big/big/small/single-double/ball color combination at the same time at the same time. </span></p>
<p><span style="font-family: arial, helvetica, sans-serif;"> </span></p>
<p class="MsoNormal"><span style="font-family: arial, helvetica, sans-serif;">5.LUCKYSPRITE discounts are only distributed by this website. Members are requested to check the promotions on the official website. If there are disputes arising from the discounts obtained through other channels, the company will not be responsible for it!</span></p>`;
                $('#TempModal .activity-popup-detail-inner').html(html);
                $('#TempModal').modal('show');
            } else if (activityName == 'DepositSpecialBonus') {
                var html = `<p><span style="font-family: 'arial black', sans-serif;"><img title="Deposit Special Bonus" src="images/activity/DepositSpecialBonusPhone.jpg" /></span></p>
<p class="MsoNormal"><span style="font-family: arial, helvetica, sans-serif; font-size: 16px;"><strong>Event Time:</strong></span></p>
<p class="MsoNormal"><span style="font-family: arial, helvetica, sans-serif; font-size: 16px;">2022/06/10 - Deadline will be notified</span></p>
<p class="MsoNormal">&nbsp;</p>
<p class="MsoNormal"><span style="font-family: arial, helvetica, sans-serif; font-size: 16px;"><strong>Event Details:</strong></span></p>
<p class="MsoNormal"><span style="font-family: arial, helvetica, sans-serif; font-size: 16px;">Anyone who join and deposit for LUCKY SPRITE players can participate in this event and get </span><span style="font-family: arial, helvetica, sans-serif; font-size: 16px;">10% (unlimited deposit times) of player deposits.</span></p>
<p class="MsoNormal"><span style="font-size: 16px; font-family: arial, helvetica, sans-serif; color: #000000; font-weight: 400; font-style: normal; font-variant: normal; text-decoration: none; vertical-align: baseline; white-space: pre-wrap;">After claiming the event bonus, you will be requested to reset the withdrawal threshold to zero before you can claim the next event bonus.</span></p>
<p class="MsoNormal"><span style="font-size: 16px; font-family: arial, helvetica, sans-serif; color: #000000; font-weight: 400; font-style: normal; font-variant: normal; text-decoration: none; vertical-align: baseline; white-space: pre-wrap;">Only for electronic slot games, cannot be used in live video games.</span></p>
<p class="MsoNormal"><span style="font-size: 16px; font-family: arial, helvetica, sans-serif; color: #000000; font-weight: 400; font-style: normal; font-variant: normal; text-decoration: none; vertical-align: baseline; white-space: pre-wrap;">(Betting amount is calculated by playing electronic slot games)</span></p>
<p dir="ltr" style="line-height: 1.38; margin-top: 0pt; margin-bottom: 0pt;"><span style="font-size: 16px; font-family: arial, helvetica, sans-serif; color: #000000; font-weight: 400; font-style: normal; font-variant: normal; text-decoration: none; vertical-align: baseline; white-space: pre-wrap;">A single deposit of 1000 or more is required to participate in this activity.</span></p>
<p class="MsoNormal"><span id="docs-internal-guid-b77e9594-7fff-b430-669d-ab2e5590b1fb" style="font-family: arial, helvetica, sans-serif;"></span></p>
<p>&nbsp;</p>
<p class="MsoNormal"><span style="font-family: arial, helvetica, sans-serif;"><span style="font-size: 16px;">This promotion is only applicable to players who deposit (wager limit requires 10 times the</span><span style="font-size: 16px;">deposit amount)</span></span></p>
<p class="MsoNormal"><span style="font-family: arial, helvetica, sans-serif; font-size: 16px;">Example: </span></p>
<p class="MsoNormal"><span style="font-family: arial, helvetica, sans-serif; font-size: 16px;">Deposit 1000</span></p>
<p class="MsoNormal"><span style="font-family: arial, helvetica, sans-serif; font-size: 16px;">1000*10%=1100</span></p>
<p class="MsoNormal"><span style="font-family: arial, helvetica, sans-serif; font-size: 16px;">1100*(10 times the bet)=11000</span></p>
<p class="MsoNormal"><span style="font-family: arial, helvetica, sans-serif; font-size: 16px;">Withdrawal approved when the bet amount reaches 11000</span></p>
<p class="MsoNormal"><span style="font-family: arial, helvetica, sans-serif; font-size: 16px;">A single deposit of 1000 or more is required to participate in this activity</span></p>
<p class="MsoNormal">&nbsp;</p>
<p class="MsoNormal"><span style="font-family: arial, helvetica, sans-serif; background: #ffffff; font-size: 16px;">Event Threshold Description:</span></p>
<p class="MsoNormal"><span style="font-family: arial, helvetica, sans-serif; background: #ffffff; font-size: 16px;">The total threshold is (Capital + Bonus) * 10.&nbsp;</span></p>
<p class="MsoNormal"><span style="font-family: arial, helvetica, sans-serif; background: #ffffff; font-size: 16px;">Please note that the capital threshold is "Deposit amount * 1" and the other thresholds will be added when you choose to receive a Bonus.</span></p>
<p class="MsoNormal">&nbsp;</p>
<p class="MsoNormal"><span style="font-family: arial, helvetica, sans-serif; background: #ffffff; font-size: 16px;">For example:</span></p>
<p class="MsoNormal"><span style="font-family: arial, helvetica, sans-serif; background: #ffffff; font-size: 16px;">Deposit amount is 10,000 and choose to receive Bonus 1,000.</span></p>
<p class="MsoNormal"><span style="font-family: arial, helvetica, sans-serif; background: #ffffff; font-size: 16px;">In this case, the total threshold is (10,000 + 1,000) * 10=110,000.</span></p>
<p class="MsoNormal"><span style="font-family: arial, helvetica, sans-serif; background: #ffffff; font-size: 16px;">The threshold is 10,000 when depositing, and the other thresholds 100,000 will be added when you choose to receive a Bonus.</span></p>
<p>&nbsp;</p>
<p class="MsoNormal"><strong><span style="font-family: arial, helvetica, sans-serif; font-size: 16px;">Event rules and terms:</span></strong></p>
<p class="MsoNormal"><span style="font-family: arial, helvetica, sans-serif; font-size: 16px;">1. This promotion is limited to a single player, a single account, a single contact information, a single payment account, a single IP and a single computer environment to participate in. Anyone who gains the bonus by illegal means, the LUCKYSPRITE organizer has the right to adjust the content of the event.</span></p>
<p class="MsoNormal"><span style="font-family: arial, helvetica, sans-serif; font-size: 16px;">2.All games must have a win or loss calculation. Any cancelled events, games and risk-free bets will not be counted as valid bets for this event.</span></p>
<p class="MsoNormal"><span style="font-family: arial, helvetica, sans-serif; font-size: 16px;">3. LUCKYSPRITE has the right to adjust the content of the event, and can modify and stop this promotion at any time without prior notice. If the member is found to have violated the promotion rules or used any improper means to obtain the promotion, the member can cancel the distribution of the award, and claim back the profit generated by the award.。</span></p>
<p class="MsoNormal"><span style="font-family: arial, helvetica, sans-serif; font-size: 16px;">4.Risk-free bets are void bets, and the following are void bets. Casino: In the same round of Baccarat, Sic Bo or Roulette, bet Banker and Player at the same time, Odd and Even/Black and Red. Stadium: Betting on two teams at the same time on the same match. (※ Cross-level is not included in the effective amount), Colored balls: bet on odd/even/big/big/small/single-double/ball color combination at the same time at the same time.</span></p>
<p class="MsoNormal"><span style="font-family: arial, helvetica, sans-serif; font-size: 16px;">5.LUCKYSPRITE discounts are only distributed by this website. Members are requested to check the promotions on the official website. If there are disputes arising from the discounts obtained through other channels, the company will not be responsible for it!</span></p>`;
                $('#TempModal .activity-popup-detail-inner').html(html);
                $('#TempModal').modal('show');
            } else if (activityName == 'SignUpBonus') {
                var html = `<p><span style="font-family: 'arial black', sans-serif;"><img title="Sign Up Bonus" src="images/activity/SignUpBonusPhone.jpg" /></span></p>
<p class="MsoNormal"><span style="font-family: arial, helvetica, sans-serif; font-size: 16px;"><strong>Event Time:<br></strong>No Limit<strong><br><!-- [if !supportLineBreakNewLine]--><br><!--[endif]--></strong></span></p>
<p class="MsoNormal"><span style="font-family: arial, helvetica, sans-serif; font-size: 16px;"><strong>Event Details:</strong></span></p>
<p dir="ltr" style="line-height: 1.38; margin-top: 0pt; margin-bottom: 0pt;"><span style="font-family: arial, helvetica, sans-serif;"><span style="font-size: 16px; color: #000000; background-color: transparent; font-style: normal; font-variant: normal; text-decoration: none; vertical-align: baseline; white-space: pre-wrap;">Event rules</span></span></p>
<p dir="ltr" style="line-height: 1.38; margin-top: 0pt; margin-bottom: 0pt;"><span style="font-family: arial, helvetica, sans-serif;"><span style="font-size: 16px; color: #000000; background-color: transparent; font-style: normal; font-variant: normal; text-decoration: none; vertical-align: baseline; white-space: pre-wrap;">Starting now, new members will receive 20 bonus when they register.</span></span></p>
<p dir="ltr" style="line-height: 1.38; margin-top: 0pt; margin-bottom: 0pt;"><span style="font-family: arial, helvetica, sans-serif;"><span style="font-size: 16px; color: #000000; background-color: transparent; font-style: normal; font-variant: normal; text-decoration: none; vertical-align: baseline; white-space: pre-wrap;">One set of IP have 3 chances, sample: IP 123.321.21 with 3 different accounts, If there is a fourth group of different accounts, bonus will not be given.</span></span></p>
<p class="MsoNormal"><span style="font-family: arial, helvetica, sans-serif;"><span style="font-size: 16px;"><span style="font-weight: normal;">&nbsp;</span></span></span></p>
<p dir="ltr" style="line-height: 1.38; margin-top: 0pt; margin-bottom: 0pt;"><span style="font-family: arial, helvetica, sans-serif;"><span style="font-size: 16px; color: #000000; background-color: transparent; font-style: normal; font-variant: normal; text-decoration: none; vertical-align: baseline; white-space: pre-wrap;">Bonus rules</span></span></p>
<p dir="ltr" style="line-height: 1.38; margin-top: 0pt; margin-bottom: 0pt;"><span style="font-family: arial, helvetica, sans-serif;"><span style="font-size: 16px; color: #000000; background-color: transparent; font-style: normal; font-variant: normal; text-decoration: none; vertical-align: baseline; white-space: pre-wrap;"><span style="font-family: Arial; font-size: 14.6667px;"> * The ₱20 you received in this event will not be included in the valid bet calculation of the VIP level upgrade.</span></span></span></p>
<p dir="ltr" style="line-height: 1.38; margin-top: 0pt; margin-bottom: 0pt;"><span style="font-family: arial, helvetica, sans-serif;"><span id="docs-internal-guid-79b55fd0-7fff-2c63-0dfc-c36c95a2c1d1" style="font-size: 16px; color: #000000;"><span style="font-variant-numeric: normal; font-variant-east-asian: normal; vertical-align: baseline; white-space: pre-wrap;"> * If you do not receive the 20 bonus and deposit directly, it will be deemed as giving up this event. The system will automatically reclaim the 20 bonus.</span></span></span></p>
<p dir="ltr" style="line-height: 1.38; margin-top: 0pt; margin-bottom: 0pt;"><span style="font-family: arial, helvetica, sans-serif;"><span style="font-size: 16px; color: #000000; background-color: transparent; font-style: normal; font-variant: normal; text-decoration: none; vertical-align: baseline; white-space: pre-wrap;"> * If main wallet did not exceed 200, the wallet balance will be cleared.</span></span></p>
<p dir="ltr" style="line-height: 1.38; margin-top: 0pt; margin-bottom: 0pt;"><span style="font-family: arial, helvetica, sans-serif;"><span style="font-size: 16px; color: #000000; background-color: transparent; font-style: normal; font-variant: normal; text-decoration: none; vertical-align: baseline; white-space: pre-wrap;"> * If main wallet exceeds 200, wallet will be emptied first when recharging, and the 200 will be given.</span></span></p>
<p class="MsoNormal"><span style="font-family: arial, helvetica, sans-serif; font-size: 16px;">&nbsp;</span></p>
<p class="MsoNormal"><span style="font-family: arial, helvetica, sans-serif; font-size: 16px;"><strong>Event rules and terms:</strong></span></p>
<p class="MsoNormal"><span style="font-family: arial, helvetica, sans-serif; font-size: 16px;">1. This promotion is limited to a single player, a single account, a single contact information, a single payment account, a single IP and a single computer environment to participate in. Anyone who gains the bonus by illegal means, the LUCKYSPRITE has the right to adjust the content of the event. </span></p>
<p class="MsoNormal"><span style="font-family: arial, helvetica, sans-serif; font-size: 16px;">2. All games must have a win or loss calculation. Any cancelled events, games and risk-free bets will not be counted as valid bets for this event.</span></p>
<p class="MsoNormal"><span style="font-family: arial, helvetica, sans-serif; font-size: 16px;">3. LUCKYSPRITE has the right to adjust the content of the event, and can modify and stop this promotion at any time without prior notice. If the member is found to have violated the promotion rules or used any improper means to obtain the promotion, LUCKYSPRITE can cancel the distribution of the award, and claim back the profit generated by the award.</span></p>
<p class="MsoNormal"><span style="font-family: arial, helvetica, sans-serif; font-size: 16px;">4. Risk-free bets are void bets, and the following are void bets,Casino: In the same round of Baccarat, Sic Bo or Roulette, betting Banker and Player at the same time, Odd and Even/Black and Red. Stadium: Betting on two teams at the same time on the same match. (※ Cross-level is not included in the effective amount), Colored balls: bet on odd/even/big/big/small/single-double/ball color combination at the same time at the same time. </span></p>
<p><span style="font-family: arial, helvetica, sans-serif; font-size: 16px;"><span style="line-height: 115%;">5.LUCKYSPRITE bonuses are only distributed by this website. It is recommended that members visit the official website to check out the promotions. If there are disputes arising from the bonuses obtained through other channels, the company will not be responsible for it!</span></span></p>`;
                $('#TempModal .activity-popup-detail-inner').html(html);
                $('#TempModal').modal('show');
            }
        }
    }

    function ChangeActivity(type) {
        $(".tab-scroller__content").find(".tab-item").removeClass("active");
        $("#li_activity" + type).addClass("active");

        if (type == 0) {
            $("#divProcessing").show();
            $("#divFinish").hide();
        } else {
            $("#divFinish").show();
            $("#divProcessing").hide();
        }
    }

    window.onload = init;
</script>
<body class="innerBody">
    <main class="innerMain">
        <div class="page-content">
            <div class="container">
                <div class="sec-title-container sec-title-activity">
                    <!-- 領獎中心 link-->
                    <a class="btn btn-link btn-prize" onclick="window.parent.API_LoadPage('Prize','Prize.aspx', true)">
                        <span class="title language_replace">前往領獎中心</span><i class="icon icon-mask icon-arrow-right-dot"></i>
                    </a>
                    <div class="sec-title-wrapper">
                        <h1 class="sec-title title-deco"><span class="language_replace">活動</span></h1>
                    </div>
                </div>
                <nav class="tab-activity">
                    <div class="tab-scroller tab-2">
                        <div class="tab-scroller__area">
                            <ul class="tab-scroller__content" id="idTabActivityList">
                                <li class="tab-item act-running active" id="li_activity0" onclick="ChangeActivity(0)">
                                    <span class="tab-item-link">
                                        <span class="title language_replace">進行中</span>
                                    </span>
                                </li>
                                <li class="tab-item act-finish" id="li_activity1" onclick="ChangeActivity(1)">
                                    <span class="tab-item-link">
                                        <span class="title language_replace">已結束</span>
                                    </span>
                                </li>
                                <div class="tab-slide"></div>
                            </ul>
                        </div>
                    </div>
                </nav>
                <section class="section-wrap section-activity">
                    <div class="activity-item-group" id="divProcessing">
                        <figure class="activity-item" onclick="showPropUp('SignUpBonus')">
                            <div class="activity-item-inner">

                                <div class="activity-item-link" data-toggle="modal">
                                    <div class="img-wrap activityPicture">
                                             <p>
                                                <img title="Sign Up Bonus" src="images/activity/SignUpBonus.jpg?a=2" />
                                             </p>
                                       
                                    </div>
                                    <div class="info">
                                        <div class="detail">
                                            <div class="desc language_replace activityTitle" langkey="">
                                                <p class="MsoNormal" style="text-align: left;" align="center"><span style="font-family: 'arial black', sans-serif; font-size: 16px;"><strong style="mso-bidi-font-weight: normal;">Sign Up Bonus</strong></span></p>
                                            </div>
                                        </div>


                                        <button type="button" class="btn-popup btn btn-full-main"><span class="language_replace" langkey="立即確認">View</span></button>
                                    </div>
                                </div>
                            </div>
                        </figure>
                        <figure class="activity-item" onclick="showPropUp('ReferFriendAndGetBonus')">
                            <div class="activity-item-inner">

                                <div class="activity-item-link" data-toggle="modal">
                                    <div class="img-wrap activityPicture">
                                           <p>
                                               <img title="Refer A Friend And Get Bonus" src="images/activity/ReferFriendAndGetBonus.jpg?a=2" />
                                             </p>
                                    </div>
                                    <div class="info">
                                        <div class="detail">
                                            <div class="desc language_replace activityTitle" langkey="">
                                                <p><span style="font-family: 'arial black', sans-serif; font-size: 18px; color: #000000;"><strong><span style="line-height: 115%;">Refer a friend and get bonus</span></strong></span></p>
                                            </div>
                                        </div>


                                        <button type="button" class="btn-popup btn btn-full-main"><span class="language_replace" langkey="立即確認">View</span></button>
                                    </div>
                                </div>
                            </div>
                        </figure>
                        <figure class="activity-item" onclick="showPropUp('NewPlayerFirstTimeDepositEvent')">
                            <div class="activity-item-inner">

                                <div class="activity-item-link" data-toggle="modal">
                                    <div class="img-wrap activityPicture">
                                            <p>
                                                   <img title="New Player First Time Deposit Event!" src="images/activity/NewPlayerFirstTimeDepositEvent.jpg?a=2" />
                                             </p>
                                      
                                    </div>
                                    <div class="info">
                                        <div class="detail">
                                            <div class="desc language_replace activityTitle" langkey="">
                                                <p class="MsoNormal" style="text-align: left;" align="center"><span style="font-family: 'arial black', sans-serif; font-size: 16px; color: #000000;"><strong style="mso-bidi-font-weight: normal;">New Player First Time Deposit Event!</strong></span></p>
                                            </div>
                                        </div>


                                        <button type="button" class="btn-popup btn btn-full-main"><span class="language_replace" langkey="立即確認">View</span></button>
                                    </div>
                                </div>
                            </div>
                        </figure>
                        <figure class="activity-item" onclick="showPropUp('ReferFriendsAndPlay')">
                            <div class="activity-item-inner">

                                <div class="activity-item-link" data-toggle="modal">
                                    <div class="img-wrap activityPicture">
                                            <p>
                                                <img title="Refer friends and play" src="images/activity/ReferFriendsAndPlay.jpg?a=2" />
                                            </p>
                                               
                                                        
                                    </div>
                                    <div class="info">
                                        <div class="detail">
                                            <div class="desc language_replace activityTitle" langkey="">
                                                <p class="MsoNormal" style="text-align: left;" align="center"><strong><span style="font-family: 'arial black', sans-serif; font-size: 16px;">Refer friends and play</span></strong></p>
                                            </div>
                                        </div>


                                        <button type="button" class="btn-popup btn btn-full-main"><span class="language_replace" langkey="立即確認">View</span></button>
                                    </div>
                                </div>
                            </div>
                        </figure>
                        <figure class="activity-item" onclick="showPropUp('DepositSpecialBonus')">
                            <div class="activity-item-inner">

                                <div class="activity-item-link" data-toggle="modal">
                                    <div class="img-wrap activityPicture">
                                              <p>
                                                  <img title="Refer friends and play" src="images/activity/DepositSpecialBonus.jpg?a=2" />
                                            </p>
                                    </div>
                                    <div class="info">
                                        <div class="detail">
                                            <div class="desc language_replace activityTitle" langkey="">
                                                <p><span style="font-family: 'arial black', sans-serif; font-size: 16px;"><strong><span style="line-height: 115%;">Deposit Special Bonus</span></strong></span></p>
                                            </div>
                                        </div>


                                        <button type="button" class="btn-popup btn btn-full-main"><span class="language_replace" langkey="立即確認">View</span></button>
                                    </div>
                                </div>
                            </div>
                        </figure>
                    </div>
                    <div class="activity-item-group" id="divFinish" style="display: none">
                    </div>
                </section>
            </div>
        </div>
    </main>

    <!-- Modal -->
    <div class="modal fade footer-center" id="ModalTest" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-lg modal-dialog-centered modal-dialog-scrollable">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">我是標題</h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <article class="activity-popup-detail-wrapper">
                        <div class="activity-popup-detail-inner">
                        </div>
                    </article>
                </div>
                <div class="modal-footer">

                    <!--獎勵可領取-->
                    <button type="button" class="btn btn-full-sub is-hide" onclick="window.parent.API_LoadPage('Prize','Prize.aspx')">領取獎勵</button>

                    <!--獎勵不可領取-->
                    <button type="button" class="btn btn-secondary is-hide" disabled>領取獎勵</button>
                </div>
            </div>
        </div>
    </div>
    <!-- Modal - ModalDailylogin-->
    <div class="modal fade footer-center" id="ModalDailylogin" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-lg modal-dialog-centered modal-dialog-scrollable">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title language_replace">金曜日的禮物</h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <article class="activity-popup-detail-wrapper">
                        <div class="activity-popup-detail-inner">
                        </div>
                    </article>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-primary language_replace" onclick="window.parent.API_LoadPage('Casino', 'Casino.aspx', false)">開始洗碼</button>

                    <!--獎勵可領取-->
                    <button type="button" class="btn btn-full-sub is-hide" onclick="window.parent.API_LoadPage('Prize','Prize.aspx')">領取獎勵</button>

                    <!--獎勵不可領取-->
                    <button type="button" class="btn btn-secondary is-hide" disabled>領取獎勵</button>
                </div>
            </div>
        </div>
    </div>
    <!-- Modal - ModalDeposit-->
    <div class="modal fade footer-center" id="ModalDeposit" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-lg modal-dialog-centered modal-dialog-scrollable">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title language_replace">大好評の入金還元プラン復活！しかも銀行振込は2倍！</h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <article class="activity-popup-detail-wrapper">
                        <div class="activity-popup-detail-inner">
                        </div>
                    </article>
                </div>
                <div class="modal-footer">
                    <!--獎勵可領取-->
                    <button type="button" class="btn btn-full-sub language_replace" onclick="window.parent.API_LoadPage('Deposit','Deposit.aspx', true)">前往入金</button>
                </div>
            </div>
        </div>
    </div>
    <!-- Modal - ModalDeposit-->
    <div class="modal fade footer-center" id="ModalRegister" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-lg modal-dialog-centered modal-dialog-scrollable">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title language_replace">MAHARAJA見面禮</h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <article class="activity-popup-detail-wrapper">
                        <div class="activity-popup-detail-inner">
                        </div>
                    </article>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-primary language_replace" onclick="window.parent.API_LoadPage('Prize','Prize.aspx')">參加活動</button>

                    <!--獎勵可領取-->
                    <button type="button" class="btn btn-full-sub is-hide language_replace" onclick="window.parent.API_LoadPage('Prize','Prize.aspx')">參加活動</button>

                    <!--獎勵不可領取-->
                    <button type="button" class="btn btn-secondary is-hide language_replace" disabled>參加活動</button>
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade footer-center" id="TempModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-lg modal-dialog-centered modal-dialog-scrollable">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <article class="activity-popup-detail-wrapper">
                        <div class="activity-popup-detail-inner">
                        </div>
                    </article>
                </div>
            </div>
        </div>
    </div>

    <div style="display: none" id="tmpActivity">
        <figure class="activity-item">
            <div class="activity-item-inner">
                <%-- onclick="GoActivityDetail(14,'/Activity/event/ne-rt/202210/index-jp.html')"--%>
                <!-- 活動連結 -->
                <div class="activity-item-link" data-toggle="modal">
                    <div class="img-wrap activityPicture">
                        <%--<img src="Activity/event/ne-rt/202210/img/JP-img-act.jpg">--%>
                    </div>
                    <div class="info">
                        <div class="detail">
                            <div class="desc language_replace activityTitle"></div>
                        </div>
                        <!-- 活動詳情 Popup-->
                        <!-- <button type="button" onclick="activityBtnClick(2)" class="btn-popup btn btn-full-main"><span class="language_replace">立即確認</span></button> -->
                        <button type="button" class="btn-popup btn btn-full-main"><span class="language_replace">立即確認</span></button>
                    </div>
                </div>
            </div>
        </figure>
    </div>

    <div style="display: none" id="tmpActivityDetail">
    </div>

</body>

</html>
