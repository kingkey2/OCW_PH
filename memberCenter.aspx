<%@ Page Language="C#" %>

<% string Version = EWinWeb.Version; %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Maharaja</title>
    <%--    <link rel="stylesheet" href="Scripts/OutSrc/lib/bootstrap/css/bootstrap.min.css" type="text/css" />
    <link rel="stylesheet" href="Scripts/OutSrc/lib/swiper/css/swiper-bundle.min.css" type="text/css" />

    <link rel="stylesheet" href="css/icons.css?<%:Version%>" type="text/css" />
    <link rel="stylesheet" href="css/global.css?<%:Version%>" type="text/css" />
    <link rel="stylesheet" href="css/member.css" type="text/css" />
    --%>
    <link href="Scripts/vendor/swiper/css/swiper-bundle.min.css" rel="stylesheet" />
    <link href="css/basic.min.css" rel="stylesheet" />
    <link href="css/main.css" rel="stylesheet" />
    <link href="css/member.css" rel="stylesheet" />
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+JP:wght@300;500&display=swap" rel="Prefetch" as="style" onload="this.rel = 'stylesheet'" />

</head>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
<script type="text/javascript" src="/Scripts/Common.js"></script>
<script type="text/javascript" src="/Scripts/UIControl.js"></script>
<script type="text/javascript" src="/Scripts/MultiLanguage.js"></script>
<script type="text/javascript" src="/Scripts/Math.uuid.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/bignumber.js/9.0.2/bignumber.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/4.6.2/js/bootstrap.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/Swiper/6.7.1/swiper-bundle.min.js"></script>
<script>

    if (self != top) {
        window.parent.API_LoadingStart();
    }

    var WebInfo;
    var p;
    var lang;
    var BackCardInfo = null;
    var v = "<%:Version%>";
    var swiper;
    var initSwiperEnd = false;

    function copyText(tag) {
        var copyText = document.getElementById(tag);
        copyText.select();
        copyText.setSelectionRange(0, 99999);

        copyToClipboard(copyText.textContent)
            .then(() => window.parent.showMessageOK(mlp.getLanguageKey("提示"), mlp.getLanguageKey("複製成功")))
            .catch(() => window.parent.showMessageOK(mlp.getLanguageKey("提示"), mlp.getLanguageKey("複製失敗")));
    }

    function copyToClipboard(textToCopy) {
        // navigator clipboard api needs a secure context (https)
        if (navigator.clipboard && window.isSecureContext) {
            // navigator clipboard api method'
            return navigator.clipboard.writeText(textToCopy);
        } else {
            // text area method
            let textArea = document.createElement("textarea");
            textArea.value = textToCopy;
            // make the textarea out of viewport
            textArea.style.position = "fixed";
            textArea.style.left = "-999999px";
            textArea.style.top = "-999999px";
            document.body.appendChild(textArea);
            textArea.focus();
            textArea.select();
            return new Promise((res, rej) => {
                // here the magic happens
                document.execCommand('copy') ? res() : rej();
                textArea.remove();
            });
        }
    }

    function updateBaseInfo() {
        $("#RealName").val(WebInfo.UserInfo.RealName);
        $("#Email").val(WebInfo.UserInfo.EMail == undefined ? "" : WebInfo.UserInfo.EMail);
        $("#PhoneNumber").val(WebInfo.UserInfo.ContactPhonePrefix + " " + WebInfo.UserInfo.ContactPhoneNumber);
        let IsFullRegistration = 0;

        if (WebInfo.UserInfo.ExtraData) {
            var ExtraData = JSON.parse(WebInfo.UserInfo.ExtraData);
            for (var i = 0; i < ExtraData.length; i++) {
                if (ExtraData[i].Name == "Birthday") {
                    var Birthdays = ExtraData[i].Value.split('/');
                    $("#idBornYear").val(Birthdays[0]);
                    $("#idBornMonth").val(Birthdays[1]);
                    $("#idBornDay").val(Birthdays[2]);
                }

                if (ExtraData[i].Name == "UserGetMail") {
                    $("#check_UserGetMail").prop("checked", ExtraData[i].Value);
                }

                if (ExtraData[i].Name == "IsFullRegistration") {
                    IsFullRegistration = ExtraData[i].Value;
                }
            }
        }
        // var Birthdays = ExtraData[i].Value.split('/');
        if (WebInfo.UserInfo.Birthday != undefined && WebInfo.UserInfo.Birthday != "") {
            var Birthdays = WebInfo.UserInfo.Birthday.split('-');
            $("#idBornYear").val(Birthdays[0]);
            $("#idBornMonth").val(Birthdays[1]);
            $("#idBornDay").val(Birthdays[2]);
        }

        $("#Address").val(WebInfo.UserInfo.ContactAddress == undefined ? "" : WebInfo.UserInfo.ContactAddress);
        //$("#idAmount").text(new BigNumber(WebInfo.UserInfo.WalletList.find(x => x.CurrencyType == window.parent.API_GetCurrency()).PointValue).toFormat());

        //若bonus錢包金額大於0則顯示bonus錢包金額
        var wallet;
        wallet = WebInfo.UserInfo.WalletList.find(x => x.CurrencyType.toLocaleUpperCase() == WebInfo.BonusCurrencyType.toLocaleUpperCase());

        if (wallet) {
            if (wallet.PointValue > 0) {

            } else {
                wallet = WebInfo.UserInfo.WalletList.find(x => x.CurrencyType.toLocaleUpperCase() == WebInfo.MainCurrencyType.toLocaleUpperCase());
            }
        } else {
            wallet = WebInfo.UserInfo.WalletList.find(x => x.CurrencyType.toLocaleUpperCase() == WebInfo.MainCurrencyType.toLocaleUpperCase());
        }
        
        $("#idAmount").text(new BigNumber(parseFloat(wallet.PointValue).toFixed(1)).toFormat());
        $("#PersonCode").text(WebInfo.UserInfo.PersonCode);
        $("#idCopyPersonCode").text(WebInfo.UserInfo.PersonCode);
        $('#QRCodeimg').attr("src", `/GetQRCode.aspx?QRCode=${"<%=EWinWeb.CasinoWorldUrl %>"}/registerForQrCode.aspx?P=${WebInfo.UserInfo.PersonCode}&Download=2`);

        var ThresholdInfos = WebInfo.UserInfo.ThresholdInfo;
        if (ThresholdInfos && ThresholdInfos.length > 0) {
            let thresholdInfo;

             thresholdInfo = ThresholdInfos.find(x => x.CurrencyType.toLocaleUpperCase() == WebInfo.BonusCurrencyType.toLocaleUpperCase() );

            if (thresholdInfo) {
                if (thresholdInfo.ThresholdValue > 0) {

                } else {
                    thresholdInfo = ThresholdInfos.find(x => x.CurrencyType.toLocaleUpperCase() == WebInfo.MainCurrencyType.toLocaleUpperCase());
                }
            } else {
                 thresholdInfo = ThresholdInfos.find(x => x.CurrencyType.toLocaleUpperCase() == WebInfo.MainCurrencyType.toLocaleUpperCase() );
            }


            if (thresholdInfo) {

                if (new BigNumber(thresholdInfo.ThresholdValue).toFormat() == "0") {
                    $("#divThrehold").addClass("enough");
                    $("#divThrehold").removeClass("lacking");
                } else {
                    $("#divThrehold").removeClass("enough");
                    $("#divThrehold").addClass("lacking");
                }

                $("#idThrehold").text(new BigNumber(thresholdInfo.ThresholdValue).toFixed(2));
            } else {
                $("#idThrehold").text("0");
                $("#divThrehold").addClass("enough");
                $("#divThrehold").removeClass("lacking");
            }
        } else {
            $("#idThrehold").text("0");
            $("#divThrehold").addClass("enough");
            $("#divThrehold").removeClass("lacking");
        }

        if (IsFullRegistration == 0) {
            $("#IsFullRegistration0").show();
        } else {
            $("#IsFullRegistration1").show();
        }
    }

    function memberInit() {

    }

    function updateUserAccountRemoveReadOnly() {
        $('.password-fake').addClass('is-hide');
        $('#idOldPasswordGroup').removeClass('is-hide');
        $('#idNewPasswordGroup').removeClass('is-hide');
        $('#updateUserAccountRemoveReadOnlyBtn').addClass('is-hide');
        $('#updateUserAccountCancelBtn').removeClass('is-hide');
        $('#updateUserAccountBtn').removeClass('is-hide');

        //$('#idNewPasswordSuccessIcon').addClass('is-hide');
        $('#NewPasswordErrorMessage').addClass('is-hide');
        //$('#idNewPasswordErrorIcon').addClass('is-hide');
        $('#NewPasswordErrorMessage').text('');

        $('#OldPasswordErrorMessage').addClass('is-hide');
        //$('#idOldPasswordSuccessIcon').addClass('is-hide');
        //$('#idOldPasswordErrorIcon').addClass('is-hide');
        $('#OldPasswordErrorMessage').text('');

    }

    function updateUserAccountReadOnly() {
        $('#idOldPasswordGroup').addClass('is-hide');
        $('#idNewPasswordGroup').addClass('is-hide');
        $('.password-fake').removeClass('is-hide');
        $('#updateUserAccountRemoveReadOnlyBtn').removeClass('is-hide');
        $('#updateUserAccountCancelBtn').addClass('is-hide');
        $('#updateUserAccountBtn').addClass('is-hide');
        $('#idNewPassword').val('');
        $('#idOldPassword').val('');
    }

    function updateUserAccount() {

        var idNewPassword = $("#idNewPassword").val().trim();
        var idOldPassword = $("#idOldPassword").val().trim();
        var rules = new RegExp('^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{6,12}$')

        if (idOldPassword == "") {
            $('#OldPasswordErrorMessage').text(mlp.getLanguageKey("尚未輸入舊密碼"));
            $('#OldPasswordErrorMessage').removeClass('is-hide');
            //$('#idOldPasswordSuccessIcon').addClass('is-hide');
            //$('#idOldPasswordErrorIcon').removeClass('is-hide');
            return false;
        } else {
            $('#OldPasswordErrorMessage').text('');
            $('#OldPasswordErrorMessage').addClass('is-hide');
            //$('#idOldPasswordSuccessIcon').removeClass('is-hide');
            //$('#idOldPasswordErrorIcon').addClass('is-hide');
        }

        if (idNewPassword == "") {
            $('#NewPasswordErrorMessage').text(mlp.getLanguageKey("尚未輸入新密碼"));
            $('#NewPasswordErrorMessage').removeClass('is-hide');
            //$('#idNewPasswordSuccessIcon').addClass('is-hide');
            //$('#idNewPasswordErrorIcon').removeClass('is-hide');
            return false;
        } else if (idNewPassword.length < 6) {
            $('#NewPasswordErrorMessage').text(mlp.getLanguageKey("新密碼需大於6位"));
            $('#NewPasswordErrorMessage').removeClass('is-hide');
            //$('#idNewPasswordSuccessIcon').addClass('is-hide');
            //$('#idNewPasswordErrorIcon').removeClass('is-hide');
            return false;
        } else if (!rules.test(idNewPassword)) {
            $('#NewPasswordErrorMessage').text(mlp.getLanguageKey("請輸入半形的英文大小寫/數字，至少要有一個英文大寫與英文小寫與數字"));
            $('#NewPasswordErrorMessage').removeClass('is-hide');
            //$('#idNewPasswordSuccessIcon').addClass('is-hide');
            //$('#idNewPasswordErrorIcon').removeClass('is-hide');
            return false;
        } else {
            $('#NewPasswordErrorMessage').text('');
            $('#NewPasswordErrorMessage').addClass('is-hide');
            //$('#idNewPasswordSuccessIcon').removeClass('is-hide');
            //$('#idNewPasswordErrorIcon').addClass('is-hide');
        }

        p.SetUserPassword(WebInfo.SID, Math.uuid(), idOldPassword, idNewPassword, function (success, o) {
            if (success) {
                if (o.Result == 0) {
                    updateUserAccountReadOnly();
                    window.parent.showMessageOK(mlp.getLanguageKey("成功"), mlp.getLanguageKey("成功"), function () {

                        window.top.API_RefreshUserInfo(function () {
                        });
                    });
                } else {
                    window.parent.showMessageOK(mlp.getLanguageKey("錯誤"), mlp.getLanguageKey(o.Message));
                }
            } else {
                if (o == "Timeout") {
                    window.parent.showMessageOK(mlp.getLanguageKey("錯誤"), mlp.getLanguageKey("網路異常, 請重新嘗試"));
                } else {
                    window.parent.showMessageOK(mlp.getLanguageKey("錯誤"), o);
                }
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
                    window.parent.API_LoadingEnd(1);
                });
                break;
        }
    }

    function setUserThisWeekLogined(UserThisWeekTotalValidBetValueData) {
        if (UserThisWeekTotalValidBetValueData) {
            let k = 0;
            for (var i = 0; i < UserThisWeekTotalValidBetValueData.length; i++) {
                if (UserThisWeekTotalValidBetValueData[i].Status == 1) {
                    k++;
                    $(".bouns-item").eq(i).addClass("got");
                }
            }

            if (k == 7) {
                $(".bouns-amount").text(10000);
            } else {
                $(".bouns-amount").text(k * 1000);
            }
        }
    }

    function initSwiper() {
        //HERO 
        var swiper = new Swiper(".thumbSwiper", {

            slidesPerView: "auto",
            freeMode: true,
            // enabled: false,
            // allowTouchMove: false,
            watchSlidesProgress: false,
        });

        var heroIndex = new Swiper("#slider-card", {
            // loop: true,
            slidesPerView: 1,
            // effect: "fade",
            speed: 1000, //Duration of transition between slides (in ms)
            // autoplay: {
            //     delay: 4000,
            //     disableOnInteraction: false,
            //     pauseOnMouseEnter: true
            // },
            // pagination: {
            //     el: ".swiper-pagination",
            //     clickable: true,
            //     renderBullet: function (index, className) {
            //         //   return '<span class="' + className + '">' + (index + 1) + "</span>";
            //         return '<span class="' + className + '">' + '<img src="images/banner/thumb-' + (index + 1) + '.png"></span>';
            //     },
            // },
            thumbs: {
                swiper: swiper,
            },
            navigation: {
                nextEl: ".swiper-button-next",
                prevEl: ".swiper-button-prev",
            },
            breakpoints: {
                992: {
                    freeMode: false,
                    slidesPerView: 3,
                    centeredSlides: true,
                    loop: true,
                    // slidesPerGroup: 6, //index:992px
                },
               
            }

        });        
    }



    function init() {
        if (self == top) {
            window.parent.location.href = "index.aspx";
        }

        WebInfo = window.parent.API_GetWebInfo();
        p = window.parent.API_GetLobbyAPI();
        lang = window.parent.API_GetLang();
        mlp = new multiLanguage(v);
        mlp.loadLanguage(lang, function () {
            window.parent.API_LoadingEnd();

            if (p != null) {
                updateBaseInfo();
                window.top.API_GetUserThisWeekTotalValidBetValue(function (e) {
                    setUserThisWeekLogined(e);
                });
            }
            else {
                window.parent.showMessageOK(mlp.getLanguageKey("錯誤"), mlp.getLanguageKey("網路錯誤"), function () {
                    window.parent.location.href = "index.aspx";
                });
            }
        });

        AdjustDate();

        memberInit();
        //changeAvatar(getCookie("selectAvatar"));
        

        $("#activityURL").attr("href", "https://casino-maharaja.net/lp/01/" + WebInfo.UserInfo.PersonCode);
        $("#activityURL1").attr("href", "https://casino-maharaja.net/lp/02/" + WebInfo.UserInfo.PersonCode);

        if (!WebInfo.UserInfo.IsWalletPasswordSet) {
            //document.getElementById('idWalletPasswordUnSet').style.display = "block";
        }

        //initSwiper();
    }

    function copyActivityUrl() {

        navigator.clipboard.writeText("https://casino-maharaja.net/lp/01/" + WebInfo.UserInfo.PersonCode).then(
            () => { window.parent.showMessageOK(mlp.getLanguageKey("提示"), mlp.getLanguageKey("複製成功")) },
            () => { window.parent.showMessageOK(mlp.getLanguageKey("提示"), mlp.getLanguageKey("複製失敗")) });
        //alert("Copied the text: " + copyText.value);
    }

    function copyActivityUrl1() {

        navigator.clipboard.writeText("https://casino-maharaja.net/lp/02/" + WebInfo.UserInfo.PersonCode).then(
            () => { window.parent.showMessageOK(mlp.getLanguageKey("提示"), mlp.getLanguageKey("複製成功")) },
            () => { window.parent.showMessageOK(mlp.getLanguageKey("提示"), mlp.getLanguageKey("複製失敗")) });
        //alert("Copied the text: " + copyText.value);
    }

    function AdjustDate() {
        var idBornYear = document.getElementById("idBornYear1");
        var idBornMonth = document.getElementById("idBornMonth1");
        var idBornDate = document.getElementById("idBornDate");
        idBornDate.options.length = 0;

        var year = idBornYear.value;
        var month = parseInt(idBornMonth.value);

        //get the last day, so the number of days in that month
        var days = new Date(year, month, 0).getDate();

        //lets create the days of that month
        for (var d = 1; d <= days; d++) {
            var dayElem = document.createElement("option");
            dayElem.value = d;
            dayElem.textContent = d;

            if (d == 1) {
                dayElem.selected = true;
            }

            idBornDate.append(dayElem);
        }
    }

    function Certification() {
        var idBornYear = document.getElementById("idBornYear1");
        var idBornMonth = document.getElementById("idBornMonth1");
        var idBornDate = document.getElementById("idBornDate");
        var idEmail = document.getElementById("idEmail").value;
        var Name1 = document.getElementById("Name1").value;
        var Name2 = document.getElementById("Name2").value;

        var year = idBornYear.value;
        var month = parseInt(idBornMonth.value);
        var date = parseInt(idBornDate.value);
        let nowYear = new Date().getFullYear();
        let strExtraData = "";

        if (year.length != 4) {
            window.parent.showMessageOK("", mlp.getLanguageKey("請輸入正確年分"));
            return;
        } else if (parseInt(year) < 1900) {
            window.parent.showMessageOK("", mlp.getLanguageKey("請輸入正確年分"));
            return;
        } else if (parseInt(year) > nowYear) {
            window.parent.showMessageOK("", mlp.getLanguageKey("請輸入正確年分"));
            return;
        } else if (Name1 == "") {
            window.parent.showMessageOK("", mlp.getLanguageKey("請輸入姓"));
            return;
        } else if (Name2 == "") {
            window.parent.showMessageOK("", mlp.getLanguageKey("請輸入名"));
            return;
        } else if (idEmail == "") {
            window.parent.showMessageOK("", mlp.getLanguageKey("請輸入信箱"));
            return;
        }

        let ExtraData = [];

        if (WebInfo.UserInfo.ExtraData) {
            ExtraData = JSON.parse(WebInfo.UserInfo.ExtraData);

            if (WebInfo.UserInfo.ExtraData.indexOf("IsFullRegistration") > 0) {
                for (var i = 0; i < ExtraData.length; i++) {
                    if (ExtraData[i].Name == "IsFullRegistration") {
                        ExtraData[i].Value = 1;
                    }
                }
            } else {
                ExtraData.push({
                    Name: 'IsFullRegistration', Value: 1
                });
            }
        } else {
            ExtraData.push({
                Name: 'IsFullRegistration', Value: 1
            });
        }

        strExtraData = JSON.stringify(ExtraData);

        var data = {
            "OldPassword": "",
            "RealName": Name1 + Name2,
            "Birthday": year + "/" + month + "/" + date,
            "EMail": idEmail,
            "ExtraData": strExtraData
        }

        window.parent.API_LoadingStart();

        p.UpdateUserAccount(WebInfo.SID, Math.uuid(), data, function (success, o) {
            window.parent.API_LoadingEnd(1);
            if (success) {
                if (o.Result == 0) {
                    updateBaseInfo();
                    $("#CertificationFail").hide();
                    $("#CertificationSucc").show();
                } else {
                    $("#CertificationSucc").hide();
                    $("#CertificationFail").show();
                }
            } else {
                if (o == "Timeout") {
                    window.parent.showMessageOK(mlp.getLanguageKey("錯誤"), mlp.getLanguageKey("網路異常, 請重新嘗試"));
                } else {
                    $("#CertificationSucc").hide();
                    $("#CertificationFail").show();
                }
            }
        });
    }

    function closeCertification() {
        updateBaseInfo();
        $("#btn_PupLangClose1").click();
    }

    $(document).on('shown.bs.modal', '#ModalMemberLevel', function () {
        if (!initSwiperEnd) {
            initSwiper();
            initSwiperEnd = true;
        }
    });

    window.onload = init;
</script>
<body class="innerBody">
    <main class="innerMain">
        <div class="page-content">
            <div class="container">
                <article class="article-member-center">
                    <!-- 個人資料 -->
                    <section class="section-member-profile">
                        <!-- 會員頭像 + 會員等級 -->
                        <div class="member-profile-wrapper" style="display:">
                            <div class="member-profile-avater-wrapper">
                                <span class="avater">
                                    <span class="avater-img">
                                        <img src="images/avatar/avater-1.png" alt="">
                                    </span>
                                   <%--
                                    <button type="button" class="btn btn-round btn-primary btn-exchange-avater" data-toggle="modal" data-target="#ModalAvatar">
                                        <i class="icon icon-mask icon-camera"></i>
                                    </button>
                                    --%>
                                </span>
                            </div>
                            <div class="member-profile-level-wrapper">
                                <div class="sec-title-container sec-title-member mb-0 align-items-end sec-col-2">
                                    <div class="sec-title-wrapper align-items-end">
                                        <div class="member-level ">
                                            <h1 class="sec-title language_replace">青銅</h1>
                                            <span class="btn" data-toggle="modal" data-target="#ModalMemberLevel">
                                                <img src="images/member/btn-member-level-popup.png" alt="">
                                            </span>
                                        </div>                                        
                                    </div>
                                    <span class="unit">PHP</span>
                                </div>
                                <!-- 升級條件 -->
                                <div class="member-level-upgrade-wrapper"> 
                                    <div class="level-progress progress">
                                        <div class="progress-bar" role="progressbar" style="width: 50%" aria-valuenow="50" aria-valuemin="0" aria-valuemax="100"></div>
                                        <div class="member-level">
                                            <span class="level-name current language_replace">VIP0</span>
                                            <span class="level-name next language_replace">青銅</span>
                                        </div> 
                                    </div>
                                    <div class="level-rules">
                                        <div class="level-item deposit">
                                            <h4 class="title language_replace">累積存款</h4>
                                            <span class="value">900,000,000</span>
                                        </div>
                                        <div class="level-item rollover">
                                            <h4 class="title language_replace">累積流水</h4>
                                            <span class="value">
                                                <span class="current ">25,000,000</span>/
                                                <span class="level-rule">50,000,000</span>
                                            </span>
                                        </div>
                                    </div>
                                </div>

                                <!-- 保級條件 -->
                                <div class="member-level-reservation-wrapper">
                                    <div class="sec-title"><h2 class="title language_replace">保級流水</h2>
                                        <span class="days">(<span class="current">10</span>/<span class="total">30D</span>)</span>
                                    </div>
                                    <div class="level-progress progress">
                                        <div class="progress-bar" role="progressbar" style="width: 70%" aria-valuenow="70" aria-valuemin="0" aria-valuemax="100"></div>                                       
                                    </div>
                                    <div class="level-rules">
                                        <div class="level-item rollover">
                                            <h4 class="title language_replace">每月流水</h4>
                                           <span class="value">
                                                <span class="current ">25,000,000</span>/
                                                <span class="level-rule">50,000,000</span>
                                            </span>
                                        </div>
                                    </div>

                                </div>    
                            </div>
                        </div>
                        <div class="member-profile-data-wrapper dataList">
                            <fieldset class="dataFieldset">
                                <legend class="sec-title-container sec-col-2 sec-title-member ">
                                    <div class="sec-title-wrapper">
                                        <h1 class="sec-title title-deco"><span class="language_replace">會員中心</span></h1>
                                    </div>
                                    <!-- 資料更新 Button-->
                                    <button id="updateUserAccountRemoveReadOnlyBtn" type="button" class="btn btn-edit btn-full-main" onclick="updateUserAccountRemoveReadOnly()"><i class="icon icon-mask icon-pencile"></i></button>
                                </legend>

                                <!-- 當點擊 資料更新 Button時 text input可編輯的項目 會移除 readonly-->
                                <div class="dataFieldset-content row no-gutters">
                                    <div class="data-item name" style="width: 50%">
                                        <div class="data-item-title">
                                            <label class="title">
                                                <i class="icon icon-mask icon-people"></i>
                                                <span class="title-name language_replace">姓名</span>
                                            </label>
                                        </div>
                                        <div class="data-item-content">
                                            <input type="text" class="custom-input-edit" id="RealName" value="" readonly>
                                        </div>
                                    </div>
                                    <div class="data-item birth" style="width: 50%">
                                        <div class="data-item-title">
                                            <label class="title">
                                                <i class="icon icon-mask icon-gift"></i>
                                                <span class="title-name language_replace">出生年月日</span>
                                            </label>
                                        </div>
                                        <div class="data-item-content">
                                            <input type="number" min="1920" max="2300" class="custom-input-edit year" id="idBornYear" value="" readonly> / 
                                            <input type="number" min="1" max="12" class="custom-input-edit month" id="idBornMonth" value="" readonly> / 
                                            <input type="number" min="1" max="31"  class="custom-input-edit day" id="idBornDay" value="" readonly>
                                        </div>
                                    </div>
                                    
                                    <%--<div class="data-item password" style="display: none;">
                                        <div class="data-item-title">
                                            <label class="title">
                                                <i class="icon icon-mask icon-lock-closed"></i>
                                                <span class="title-name language_replace">舊密碼</span>
                                            </label>
                                        </div>
                                        <div class="data-item-content">
                                            <input type="password" class="custom-input-edit" id="idOldPassword" value="">
                                        </div>
                                    </div>--%>                                   
                                    <div class="data-item password">
                                        <div class="data-item-title">
                                            <label class="title">
                                                <i class="icon icon-mask icon-lock-closed"></i>
                                                <span class="title-name language_replace">密碼</span>
                                            </label>
                                        </div>
                                        <div class="data-item-content">
                                            <div class="password-fake">
                                                <p class="password">**************</p>
                                            </div>
                                            <div class="password-real">
                                                <div id="idOldPasswordGroup" class="data-item-form-group is-hide">
                                                    <input type="password" class="form-control" id="idOldPassword" value="" language_replace="placeholder" placeholder="請輸入舊密碼" >
                                                    <label for="" class="form-label"><span class="language_replace">請輸入舊密碼</span></label>
                                                    <span id="idOldPasswordSuccessIcon" class="label success is-hide"><i class="icon icon-mask icon-check"></i></span>
                                                    <span id="idOldPasswordErrorIcon" class="label fail is-hide"><i class="icon icon-mask icon-error"></i></span>
                                                    <p class="notice is-hide" id="OldPasswordErrorMessage"></p>
                                                </div>
                                                <div id="idNewPasswordGroup" class="data-item-form-group is-hide">
                                                    <input type="password" class="form-control" id="idNewPassword" value="" language_replace="placeholder" placeholder="請輸入新密碼">
                                                    <label for="" class="form-label"><span class="language_replace">請輸入新密碼</span></label>
                                                    <span id="idNewPasswordSuccessIcon" class="label success is-hide"><i class="icon icon-mask icon-check"></i></span>
                                                    <span id="idNewPasswordErrorIcon" class="label fail is-hide"><i class="icon icon-mask icon-error"></i></span>
                                                    <p class="notice is-hide" id="NewPasswordErrorMessage"></p>                                                 
                                                </div>                                                
                                            </div>
                                        </div>                                        
                                    </div>

                                   <div class="data-item verify">
                                        <div class="data-item-title">
                                            <label class="title mb-3">
                                                <i class="icon icon-mask icon-verify"></i>
                                                <span class="title-name language_replace">認證狀態</span>
                                                <span class="btn btn-Q-mark btn-round btn-sm" data-toggle="modal" data-target="#ModalVerify"><i class="icon icon-mask icon-question"></i></span>
                                            </label>
                                        </div>
                                        <div class="data-item-content">
                                            <div class="verify-item">
                                                <!-- 尚未認證 -->
                                                <span class="verify-result fail" id="IsFullRegistration0" style="display:none">
                                                    <span class="label fail"><i class="icon icon-mask icon-error"></i></span>
                                                    <span class="verify-desc language_replace">尚未認證</span>  
                                                    <button type="button" class="btn btn-verify" data-toggle="modal" data-target="#ModalRegisterComplete">
                                                        <span class="title language_replace">進行認證</span>
                                                        <i class="icon icon-mask icon-pencile"></i>
                                                    </button>
                                                </span>

                                                <!-- 認證完成 -->
                                                <span class="verify-result success" id="IsFullRegistration1" style="display:none">
                                                    <span class="label success"><i class="icon icon-mask icon-check"></i></span>
                                                    <span class="verify-desc language_replace">認證完成</span>
                                                </span>
                                               
                                            </div>
                                        </div>                                        
                                    </div>
                                  
                                    <div class="data-item mobile">
                                        <div class="data-item-title">
                                            <label class="title">
                                                <i class="icon icon-mask icon-mobile"></i>
                                                <span class="title-name language_replace">手機號碼</span>
                                            </label>
                                            <%--<div class="labels labels-status">
                                                <span class="label language_replace update">更新</span>
                                                <span class="label language_replace validated">認証</span>
                                                <span class="label language_replace unvalidated">認証済み</span>
                                            </div>--%>
                                        </div>
                                        <div class="data-item-content">
                                            <input type="text" class="custom-input-edit" id="PhoneNumber" value="" readonly>
                                        </div>
                                    </div>
                                    <div class="data-item email" style="width: 100%">
                                        <div class="data-item-title">
                                            <label class="title">
                                                <i class="icon icon-mask icon-mail"></i>
                                                <span class="title-name language_replace">E-mail</span>
                                            </label>
                                        </div>
                                        <div class="data-item-content">
                                            <input type="text" class="custom-input-edit" id="Email" value="" readonly>
                                        </div>
                                    </div>
                                   
                                    <div class="data-item-group">
                                        <%--
                                        <div class="data-item home" id="divAddress">
                                            <div class="data-item-title">
                                                <label class="title">
                                                    <i class="icon icon-mask icon-location"></i>
                                                    <span class="title-name language_replace">地址</span>
                                                </label>
                                            </div>
                                            <div class="data-item-content">
                                                <input type="text" class="custom-input-edit" id="Address" value="" readonly>
                                            </div>
                                        </div>
                                        <div class="data-item news">
                                            <div class="data-item-title">
                                                <label class="title">
                                                    <i class="icon icon-mask icon-flag"></i>
                                                    <span class="title-name language_replace">訊息通知</span>
                                                </label>
                                            </div>
                                            <div class="data-item-content">
                                                <div class="custom-control custom-checkboxValue custom-control-inline">
                                                    <label class="custom-label">
                                                        <input type="checkbox" class="custom-control-input-hidden" checked="checked" id="check_UserGetMail">
                                                        <div class="custom-input checkbox"><span class="language_replace">接收最新資訊</span></div>
                                                    </label>
                                                </div>

                                            </div>
                                        </div>
                                        --%>

                                        <div class="wrapper_center">
                                            <button id="updateUserAccountCancelBtn" onclick="updateUserAccountReadOnly()" type="button" class="btn btn-confirm btn-gray is-hide"><span class="language_replace">取消</span></button>
                                            <button id="updateUserAccountBtn" onclick="updateUserAccount()" type="button" class="btn btn-confirm btn-full-main is-hide"><span class="language_replace">確認</span></button>
                                        </div>
                                        <div class="data-item qrcode">
                                            <div class="data-item-title">
                                                <label class="title">
                                                    <i class="icon icon-mask icon-qrocde"></i>
                                                    <span class="title-name language_replace">推廣碼</span>
                                                </label>
                                            </div>
                                            <div class="data-item-content">
                                                <div class="member-profile-QRcode">
                                                    <div class="qrcode-img">
                                                        <span class="img">
                                                            <img id="QRCodeimg" src="" alt="">
                                                        </span>
                                                    </div>
                                                    <div class="qrcode-number">
                                                        <span class="number" id="PersonCode"></span>
                                                        <input id="idCopyPersonCode" class="is-hide">

                                                        <button type="button" class="btn btn-transparent btn-exchange-avater">
                                                            <i class="icon icon-mask icon-copy" onclick="copyText('idCopyPersonCode')"></i>

                                                        </button>

                                                    </div>

                                                </div>


                                            </div>
                                        </div>

                                    </div>
                                </div>
                            </fieldset>
                        </div>
                    </section>
                    <section class="section-member-setting">
                        <!-- 會員錢包中心 - 入金 + 履歷紀錄 / 出金 -->
                        <section class="section-member-wallet-transaction">
                            <div class="member-wallet-deposit-wrapper">
                                <!-- 錢包中心 -->
                                <div class="member-wallet-wrapper">
                                    <div class="member-wallet-inner">
                                        <div class="member-wallet-contnet" onclick="window.top.API_LoadPage('Deposit','Deposit.aspx', true)">
                                            <div class="member-wallet-detail">
                                                <h3 class="member-wallet-title language_replace">錢包</h3>
                                                <div class="member-wallet-amount">
                                                    <span class="unit">PHP</span>
                                                    <div class="member-deposit">
                                                        <span class="amount" id="idAmount">999,999,999</span>
                                                        <!-- 入金 Button -->
                                                        <span class="btn btn-deposit btn-full-stress btn-round"><i class="icon icon-add"></i></span>
                                                    </div>
                                                </div>                                            
                                            </div>
                                        </div>
                                        <!-- 履歷紀錄 -->
                                        <div class="member-record-wrapper">
                                            <div class="btn" onclick="window.top.API_LoadPage('record','record.aspx', true)">
                                                <div class="member-record-title">
                                                    <i class="icon icon-mask icon-list-time"></i>
                                                    <h3 class="title language_replace">履歷紀錄</h3>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- 出金門檻--新版: class判斷=> 不足:lacking  足夠:enough-->
                            <div class="member-withdraw-wrapper lacking" id="divThrehold">
                                <div class="member-withdraw-limit-inner ">
                                    <div class="member-withdraw-limit-content">
                                        <div class="member-withdraw-limit-hint"></div>
                                        <div class="member-withdraw-limit-detail">
                                            <div class="limit-wrapper">
                                                <div class="limit-status">
                                                    <span class="title language_replace">錢包</span>
                                                    <div>  
                                                        <span class="value lacking language_replace">不可出金</span>
                                                        <span class="value enough language_replace">可出金</span>
                                                        <!-- 出金說明 -->
                                                     <%--   <span class="btn btn-Q-mark btn-round btn-sm" onclick="window.parent.API_LoadPage('','/Article/guide_Rolling.html')"><i class="icon icon-mask icon-question"></i></span>--%>

                                                    </div>      
                                                </div>        
                                                <div class="limit-amount">
                                                    <span class="title language_replace">出金限制</span>
                                                    <span class="value" id="idThrehold"></span>
                                                </div> 
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- 出金門檻--舊版: class判斷=> 不足:lacking  足夠:enough-->
                            <div class="member-withdraw-wrapper lacking" id="divThrehold" style="display: none;">
                                <div class="member-withdraw-limit-wrapper">
                                    <div class="member-withdraw-limit-inner ">
                                        <i class="icon icon-mask icon-lock"></i>
                                        <span class="member-withdraw-limit-content">
                                            <!-- 出金門檻 不足-->
                                            <span class="title lacking language_replace">不可出金</span>
                                            <!-- 出金門檻 足夠-->
                                            <span class="title enough language_replace">可出金</span>
                                            <!-- 出入金說明 -->
                                            <span class="btn btn-QA-transaction btn-full-stress btn-round"><i class="icon icon-mask icon-question"></i></span>
                                            <!-- 出金門檻 -->
                                            <span class="limit-amount" id="idThrehold"></span>
                                        </span>
                                    </div>
                                </div>
                            </div>

                        </section>

                        <!-- 會員簽到進度顯示 + 活動中心 + 獎金中心 -->
                        <section class="section-member-activity">
                             <!-- 活動中心 + 獎金中心 -->
                            <div class="activity-record-wrapper">
                                <!-- 活動中心 -->
                                <div class="activity-center-wrapper" onclick="window.top.API_LoadPage('','ActivityCenter.aspx')">
                                    <div class="activity-center-inner">
                                        <div class="activity-center-content">
                                            <div class="title language_replace">活動中心</div>
                                            <div class="btn btn-activity-in"><span class="language_replace">參加</span></div>
                                        </div>
                                    </div>
                                </div>                                
                                <!-- 獎金中心 -->
                                <div class="prize-center-wrapper" onclick="window.top.API_LoadPage('','ReportAgent.aspx')">
                                    <div class="prize-center-inner">
                                        <div class="title language_replace">報表</div>
                                    </div>
                                </div>
                            </div>
                            <%--
                             <!-- 會員簽到進度顯示 -->
                             <div class="activity-dailylogin-wrapper">
                                <div class="dailylogin-bouns-wrapper" onclick="window.parent.API_LoadPage('','ActivityCenter.aspx?type=3')">
                                    <div class="dailylogin-bouns-inner">
                                        <div class="dailylogin-bouns-content">
                                            <div class="sec-title">
                                                <h3 class="title">
                                                    <span class="name language_replace">金曜日の<span>プレゼント</span></span></h3>
                                                    <span class="dailylogin-bouns-QA sec-title-intro-link">
                                                    <span class="btn btn-QA-dailylogin-bouns btn-full-stress btn-round"><i class="icon icon-mask icon-question"></i></span><span class="language_replace">説明</span></span>
                                            </div>
                                            <ul class="dailylogin-bouns-list">
                                                <!-- 已領取 bouns => got-->
                                                <li class="bouns-item ">
                                                    <span class="day"><span class="language_replace">五</span></span></li>
                                                <li class="bouns-item saturday">
                                                    <span class="day"><span class="language_replace">六</span></span>
                                                </li>
                                                <li class="bouns-item sunday">
                                                    <span class="day"><span class="language_replace">日</span></span></li>
                                                <li class="bouns-item">
                                                    <span class="day"><span class="language_replace">一</span></span>
                                                </li>
                                                <li class="bouns-item">
                                                    <span class="day"><span class="language_replace">二</span></span></li>
                                                <li class="bouns-item">
                                                    <span class="day"><span class="language_replace">三</span></span>
                                                </li>
                                                <li class="bouns-item">
                                                    <span class="day"><span class="language_replace">四</span></span>
                                                </li>
                                            </ul>
                                            <div class="dailylogin-bouns-amount">
                                                <span class="amount-title language_replace">累積獎金</span>
                                                <span class="bouns-amount">0</span>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            --%>
                        </section>
                    </section>
                    <%--
                    <!-- 熱門活動 -->
                    <div class="activity-promo-wrapper">
                        <div class="activity-promo-inner">
                            <div class="sec-title-container sec-title-member ">
                                <div class="sec-title-wrapper">
                                    <h3 class="sec-title title-deco"><span class="language_replace">熱門活動</span></h3>
                                </div>
                            </div>                           
                            <div class="activity-promo-content">
                                <ul class="activity-promo-list">
                                    <li class="promo-item">
                                        <div class="promo-inner">
                                            <div class="promo-img">
                                                <a id="activityURL1" href="https://www.casino-maharaja.net/lp/02/N00000000"
                                                    target="_blank">
                                                    <div class="img-crop">
                                                        <img src="images/activity/promo-02.jpg"
                                                            alt="パチンコって何？それっておいしいの？">
                                                    </div>
                                                </a>
                                            </div>
                                            <div class="promo-content">
                                                <h4 class="title language_replace">顧客活用的介紹推廣頁②（柏青哥愛好者）</h4>
                                                <button type="button" class="btn btn-full-sub" onclick="copyActivityUrl1()">
                                                    <i class="icon icon-mask icon-copy"></i><span class="language_replace">複製活動連結</span>
                                                </button>
                                            </div>
                                        </div>
                                    </li>
                                    <li class="promo-item">
                                        <div class="promo-inner">
                                            <div class="promo-img">
                                                <a id="activityURL" href="https://casino-maharaja.net/lp/01/N00000000"
                                                    target="_blank">
                                                    <div class="img-crop">
                                                        <img src="images/activity/promo-01.jpg"
                                                            alt="とりあえず、当社のドメインで紹介用LPをアップしてみました。">
                                                    </div>
                                                </a>
                                            </div>
                                            <div class="promo-content">
                                                <h4 class="title language_replace">お客様活用、紹介ランディングページその①（主婦）</h4>
                                                <button type="button" class="btn btn-full-sub " onclick="copyActivityUrl()"><i class="icon icon-mask icon-copy"></i>
                                                    <span class="language_replace">複製活動連結</span>
                                                </button>
                                            </div>
                                        </div>
                                    </li>
                                </ul>
                            </div>
                        </div>
                    </div>
                    --%>
                </article>
            </div>
        </div>
    </main>

    <!-- Modal - Game Info for Mobile Device-->
    <div class="modal fade no-footer popupGameInfo " id="popupGameInfo" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-xl modal-dialog-centered modal-dialog-scrollable">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <div class="game-info-mobile-wrapper gameinfo-pack-bg">
                        <div class="game-item">
                            <div class="game-item-inner">
                                <div class="game-item-focus">
                                    <div class="game-item-img">
                                        <span class="game-item-link"></span>
                                        <div class="img-wrap">
                                            <img src="">
                                        </div>
                                    </div>
                                    <div class="game-item-info-detail open">
                                        <div class="game-item-info-detail-wrapper">
                                            <div class="game-item-info-detail-moreInfo">
                                                <ul class="moreInfo-item-wrapper">
                                                    <li class="moreInfo-item brand">
                                                        <span class="title language_replace">廠牌</span>
                                                        <span class="value">PG</span>
                                                    </li>
                                                    <li class="moreInfo-item RTP">
                                                        <span class="title">RTP</span>
                                                        <span class="value number">96.66</span>
                                                    </li>
                                                    <li class="moreInfo-item gamecode">
                                                        <span class="title">NO.</span>
                                                        <span class="value number">00976</span>
                                                    </li>
                                                </ul>
                                            </div>
                                            <div class="game-item-info-detail-indicator">
                                                <div class="game-item-info-detail-indicator-inner">
                                                    <div class="info">
                                                        <h3 class="game-item-name language_replace">蝶戀花</h3>
                                                    </div>
                                                    <div class="action">
                                                        <div class="btn-s-wrapper">
                                                            <button type="button" class="btn-thumbUp btn btn-round">
                                                                <i class="icon icon-m-thumup"></i>
                                                            </button>
                                                            <button type="button" class="btn-like btn btn-round">
                                                                <i class="icon icon-m-favorite"></i>
                                                            </button>
                                                            <button type="button" class="btn-more btn btn-round">
                                                                <i class="arrow arrow-down"></i>
                                                            </button>
                                                        </div>
                                                        <button type="button" class="btn btn-play">
                                                            <span class="language_replace">プレイ</span><i class="triangle"></i></button>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
                    <button type="button" class="btn btn-primary">Save</button>
                </div>
            </div>
        </div>
    </div>

     <!-- Modal Complete Register -->
     <div class="modal fade footer-center" id="ModalRegisterComplete" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered modal-dialog-scrollable">
            <div class="modal-content">
                <div class="modal-header">
                    <div class="sec-title-container">
                        <h5 class="modal-title language_replace">進行資料認證</h5><span class="btn btn-Q-mark btn-round ml-2" data-toggle="modal" data-target="#ModalVerify"><i class="icon icon-mask icon-question"></i></span>
                    </div>                    
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close" id="btn_PupLangClose1">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <div class="registerComplete-popup-wrapper">
                        <form id="CertificationForm">
                            <div class="registerComplete-popup-inner">
                                <div class="form-group">
                                    <label class="form-title language_replace">信箱</label>
                                    <div class="input-group">
                                        <input id="idEmail" name="Email" type="text" language_replace="placeholder" class="form-control custom-style" placeholder="請填寫正確的E-mail信箱" inputmode="email">
                                        <div class="invalid-feedback language_replace">請輸入正確信箱</div>
                                    </div>
                                </div>
                                <%--
                                <div class="form-row">
                                    <div class="form-group col phonePrefix">
                                        <label class="form-title language_replace">國碼</label>
                                        <div class="input-group">
                                            <input id="idPhonePrefix" type="text" class="form-control custom-style" placeholder="+81" inputmode="decimal" value="+81" onchange="onChangePhonePrefix()">
                                            <div class="invalid-feedback language_replace">請輸入國碼</div>
                                        </div>
                                    </div>
                                    <div class="form-group col">
                                        <label class="form-title language_replace">手機電話號碼</label>
                                        <div class="input-group">
                                            <input id="idPhoneNumber" type="text" class="form-control custom-style" language_replace="placeholder" placeholder="000-0000-0000 (最前面的00請勿輸入)" inputmode="decimal">
                                            <div class="invalid-feedback language_replace">請輸入正確電話</div>
                                        </div>
                                    </div>
                                </div>
                                --%>
                                <div class="form-row">
                                    <div class="form-group col-md">
                                        <label class="form-title language_replace">姓(羅馬字)</label>
                                        <div class="input-group">
                                            <input type="text" class="form-control custom-style" placeholder="Yamada" inputmode="email" id="Name1" name="Name1">
                                            <div class="invalid-feedback language_replace">提示</div>
                                        </div>
                                    </div>
                                    <div class="form-group col-md">
                                        <label class="form-title language_replace">名(羅馬字)</label>
                                        <div class="input-group">
                                            <input type="text" class="form-control custom-style" placeholder="Taro" inputmode="email" id="Name2" name="Name2">
                                            <div class="invalid-feedback language_replace">提示</div>
                                        </div>
                                    </div>
                                </div>
                                <div class="form-row">
                                    <div class="form-group col">
                                        <label class="form-title language_replace">出生年</label>
                                        <div class="input-group">
                                            <input id="idBornYear1" type="text" class="form-control custom-style" placeholder="1900" inputmode="numeric" name="BornYear" onchange="AdjustDate()" value="1990">
                                        </div>
                                    </div>
                                    <div class="form-group col">
                                        <label class="form-title language_replace">月</label>
                                        <div class="input-group">
                                            <select id="idBornMonth1" class="form-control custom-style" name="BornMonth" onchange="AdjustDate()">
                                                <option value="1" selected>1</option>
                                                <option value="2">2</option>
                                                <option value="3">3</option>
                                                <option value="4">4</option>
                                                <option value="5">5</option>
                                                <option value="6">6</option>
                                                <option value="7">7</option>
                                                <option value="8">8</option>
                                                <option value="9">9</option>
                                                <option value="10">10</option>
                                                <option value="11">11</option>
                                                <option value="12">12</option>
                                            </select>
                                        </div>
                                    </div>
                                    <div class="form-group col">
                                        <label class="form-title language_replace">日</label>
                                        <div class="input-group">
                                            <select id="idBornDate" class="form-control custom-style" name="BornDate">
                                            </select>
                                        </div>
                                    </div>
                                </div> 

                            </div>
                            <div class="wrapper_center">
                                <button class="btn btn-full-main btn-roundcorner" type="button" onclick="Certification()">
                                    <span class="language_replace">確認</span>
                                </button>
                            </div>            
                        </form>

                        <div class="verifyResult-wrapper">

                            <!-- 認證成功 -->
                            <div class="resultShow success" id="CertificationSucc" style="display:none">
                                <div class="verifyResult-inner">
                                    <div class="verify_resultShow">
                                        <div class="verify_resultDisplay">
                                            <div class="icon-symbol"></div>
                                        </div>
                                        <p class="verify_resultTitle"><span class="language_replace" >認證完成</span></p>
                                    </div>
                                </div>
                                <div class="verify_detail">
                                    <div class="item-detail">
                                        <div class="title language_replace">
                                            <%--<span class="memeberNickname">Eddie</span>--%>
                                            <span class="language_replace">升級為完整會員</span>
                                        </div>
                                    </div>
                                </div>
                                <div class="wrapper_center">
                                    <button class="btn btn-full-main btn-roundcorner" type="button" onclick="closeCertification()">
                                        <span class="language_replace">確認</span>
                                    </button>
                                </div>   
                            </div>

                            <!-- 認證失敗 -->
                            <div class="resultShow fail" id="CertificationFail" style="display:none">
                                <div class="verifyResult-inner">
                                    <div class="verify_resultShow">
                                        <div class="verify_resultDisplay">
                                            <div class="icon-symbol"></div>
                                        </div>
                                        <p class="verify_resultTitle"><span class="language_replace" >認證失敗</span></p>
                                    </div>
                                </div>
                                <div class="verify_detail">
                                    <div class="item-detail">
                                        <div class="title language_replace">
                                            <%--<span class="memeberNickname">Eddie</span>--%>
                                            <span class="language_replace">尚未升級為完整會員</span>
                                        </div>
                                    </div>
                                </div>
                               <%-- <div class="wrapper_center">
                                    <button class="btn btn-gray btn-roundcorner" type="button" onclick="">
                                        <span class="language_replace">取消</span>
                                    </button>
                                    <button class="btn btn-full-main btn-roundcorner" type="button" onclick="">
                                        <span class="language_replace">重新認證</span>
                                    </button>
                                </div>   --%>
                                <div class="wrapper_center">
                                    <button class="btn btn-full-main btn-roundcorner" type="button" onclick="closeCertification()">
                                        <span class="language_replace">確認</span>
                                    </button>
                                </div>   
                            </div>
                        </div>
                        
                    </div>
                </div>
                <%--<div class="modal-footer">
                <button type="button" class="btn btn-primary">確定</button>
            </div>--%>
            </div>
        </div>
    </div>

    <!-- Modal - Member LEVEL -->
    <div class="modal fade footer-center show modalMemberLevel" id="ModalMemberLevel" tabindex="-1" aria-hidden="true" style="display: ;">
        <div class="modal-dialog modal-dialog-centered modal-dialog-scrollable modal-xl">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title language_replace">VIP 會員級數說明</h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close" id="btn_PupLangClose">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <div class="member-level-popup-wrapper">
                        <section class="section-wrap member-level-popup-inner">
                            <!-- 縮圖 ====================-->
                            <div class="card-thumb-wrapper">
                                <div thumbsslider="" class="thumbSwiper">
                                    <div class="swiper-wrapper">
                                        <div class="swiper-slide">
                                            <div class="thumb-item">
                                                <div class="img-crop">
                                                    <img src="images/member/card-thumb-normal.png" alt="">
                                                </div>
                                                <span class="level language_replace">VIP0</span>
                                            </div>
                                        </div>
                                        <div class="swiper-slide">
                                            <div class="thumb-item">
                                                <div class="img-crop">
                                                    <img src="images/member/card-thumb-bronze.png" alt="">
                                                </div>
                                                <span class="level language_replace">青銅</span>
                                            </div>
                                        </div>
                                        <div class="swiper-slide">
                                            <div class="thumb-item">
                                                <div class="img-crop">
                                                    <img src="images/member/card-thumb-silver.png" alt="">
                                                </div>
                                                <span class="level language_replace">白銀</span>
                                            </div>
                                        </div>
                                        <div class="swiper-slide">
                                            <div class="thumb-item">
                                                <div class="img-crop">
                                                    <img src="images/member/card-thumb-gold.png" alt="">
                                                </div>
                                                <span class="level language_replace">勇士</span>
                                            </div>
                                        </div>
                                        <div class="swiper-slide">
                                            <div class="thumb-item">
                                                <div class="img-crop">
                                                    <img src="images/member/card-thumb-platinum.png" alt="">
                                                </div>
                                                <span class="level language_replace">白金</span>
                                            </div>
                                        </div>
                                        <div class="swiper-slide">
                                            <div class="thumb-item">
                                                <div class="img-crop">
                                                    <img src="images/member/card-thumb-diamond.png" alt="">
                                                </div>
                                                <span class="level language_replace">鑽石</span>
                                            </div>
                                        </div>
                                        <div class="swiper-slide">
                                            <div class="thumb-item">
                                                <div class="img-crop">
                                                    <img src="images/member/card-thumb-S.diamond.png" alt="">
                                                </div>
                                                <span class="level language_replace">精英</span>
                                            </div>
                                        </div>
                                        <div class="swiper-slide">
                                            <div class="thumb-item">
                                                <div class="img-crop">
                                                    <img src="images/member/card-thumb-G.diamond.png" alt="">
                                                </div>
                                                <span class="level language_replace">金鑽</span>
                                            </div>
                                        </div>
                                        <div class="swiper-slide">
                                            <div class="thumb-item">
                                                <div class="img-crop">
                                                    <img src="images/member/card-thumb-Star.png" alt="">
                                                </div>
                                                <span class="level language_replace">大師</span>
                                            </div>
                                        </div>
                                        <div class="swiper-slide">
                                            <div class="thumb-item">
                                                <div class="img-crop">
                                                    <img src="images/member/card-thumb-eternal.png" alt="">
                                                </div>
                                                <span class="level language_replace">宗師</span>
                                            </div>
                                        </div>
                                        <div class="swiper-slide">
                                            <div class="thumb-item">
                                                <div class="img-crop">
                                                    <img src="images/member/card-thumb-legend.png" alt="">
                                                </div>
                                                <span class="level language_replace">史詩</span>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <div class="card-slider-wrapper">
                                <div class="swiper card-slider swiper-container round-arrow" id="slider-card">
                                    <div class="swiper-wrapper">
                                        <!-- vip0 normal -->
                                        <div class="swiper-slide m-normal">
                                            <div class="slider-item">
                                                <div class="card-item">
                                                    <a class="card-item-link"></a>
                                                    <div class="card-item-box">
                                                        <h3 class="member-level language_replace">VIP0</h3>
                                                        <div class="member-bouns">
                                                            <div class="item">
                                                                <h4 class="title language_replace">升級紅利</h4>
                                                                <span class="value"> - </span>
                                                            </div>
                                                            <div class="item">
                                                                <h4 class="title language_replace">月紅包</h4>
                                                                <span class="value"> - </span>
                                                            </div>
                                                        </div>
                                                        <div class="member-rights">
                                                            <div class="item">
                                                                <h4 class="title language_replace">累積存款要求</h4>
                                                                <span class="value"> - </span>
                                                            </div>
                                                            <div class="item">
                                                                <h4 class="title language_replace">累積流水要求</h4>
                                                                <span class="value"> - </span>
                                                            </div>
                                                            <div class="item">
                                                                <h4 class="title language_replace">保級流水</h4>
                                                                <span class="value"> - </span>
                                                            </div>
                                                        </div>                                              
                                                    </div>
                                                </div>
                                                <div class="memberlevel-rules">
                                                    <div class="memberlevel-wrapper">
                                                        <div class="thead language_replace">VIP0</div>
                                                        <div class="tbody">
                                                            <div class="tr">
                                                                <div class="td title"><h4 class="language_replace">累積存款</h4></div>
                                                                <div class="td value"> - </div>
                                                            </div>
                                                            <div class="tr">
                                                                <div class="td title"><h4 class="language_replace">流水要求</h4></div>
                                                                <div class="td value"> - </div>
                                                            </div>
                                                            <div class="tr">
                                                                <div class="td title"><h4 class="language_replace">保級流水</h4></div>
                                                                <div class="td value"> - </div>
                                                            </div>
                                                            <div class="tr">
                                                                <div class="td title"><h4 class="language_replace">特別服務通道</h4></div>
                                                                <div class="td value">✕</div>
                                                            </div>
                                                            <div class="tr">
                                                                <div class="td title"><h4 class="language_replace">升級紅利</h4></div>
                                                                <div class="td value"> - </div>
                                                            </div>
                                                            <div class="tr">
                                                                <div class="td title"><h4 class="language_replace">月紅包</h4></div>
                                                                <div class="td value"> - </div>
                                                            </div>
                                                            <div class="tr">
                                                                <div class="td title"><h4 class="language_replace">生日禮金</h4></div>
                                                                <div class="td value"> - </div>
                                                            </div>
                                                            <div class="tr">
                                                                <div class="td title"><h4 class="language_replace">體育返水</h4></div>
                                                                <div class="td value"> - </div>
                                                            </div>
                                                            <div class="tr">
                                                                <div class="td title"><h4 class="language_replace">真人返水</h4></div>
                                                                <div class="td value"> - </div>
                                                            </div>
                                                            <div class="tr">
                                                                <div class="td title"><h4 class="language_replace">電子返水</h4></div>
                                                                <div class="td value"> - </div>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        <!-- 青銅 bronze -->
                                        <div class="swiper-slide m-bronze">
                                            <div class="slider-item">
                                                <div class="card-item">
                                                    <a class="card-item-link"></a>
                                                    <div class="card-item-box">
                                                        <h3 class="member-level language_replace">青銅</h3>
                                                        <div class="member-bouns">
                                                            <div class="item">
                                                                <h4 class="title language_replace">升級紅利</h4>
                                                                <span class="value"> - </span>
                                                            </div>
                                                            <div class="item">
                                                                <h4 class="title language_replace">月紅包</h4>
                                                                <span class="value"> - </span>
                                                            </div>
                                                        </div>
                                                        <div class="member-rights">
                                                            <div class="item">
                                                                <h4 class="title language_replace">累積存款要求</h4>
                                                                <span class="value">500</span>
                                                            </div>
                                                            <div class="item">
                                                                <h4 class="title language_replace">累積流水要求</h4>
                                                                <span class="value">3,000</span>
                                                            </div>
                                                            <div class="item">
                                                                <h4 class="title language_replace">保級流水</h4>
                                                                <span class="value">2,000</span>
                                                            </div>
                                                        </div>                                              
                                                    </div>
                                                </div>
                                                <div class="memberlevel-rules">
                                                    <div class="memberlevel-wrapper">
                                                        <div class="thead language_replace">青銅</div>
                                                        <div class="tbody">
                                                            <div class="tr">
                                                                <div class="td title"><h4 class="language_replace">累積存款</h4></div>
                                                                <div class="td value">500</div>
                                                            </div>
                                                            <div class="tr">
                                                                <div class="td title"><h4 class="language_replace">流水要求</h4></div>
                                                                <div class="td value">3,000</div>
                                                            </div>
                                                            <div class="tr">
                                                                <div class="td title"><h4 class="language_replace">保級流水</h4></div>
                                                                <div class="td value">2,000</div>
                                                            </div>
                                                            <div class="tr">
                                                                <div class="td title"><h4 class="language_replace">特別服務通道</h4></div>
                                                                <div class="td value">✕</div>
                                                            </div>
                                                            <div class="tr">
                                                                <div class="td title"><h4 class="language_replace">升級紅利</h4></div>
                                                                <div class="td value"> - </div>
                                                            </div>
                                                            <div class="tr">
                                                                <div class="td title"><h4 class="language_replace">月紅包</h4></div>
                                                                <div class="td value"> - </div>
                                                            </div>
                                                            <div class="tr">
                                                                <div class="td title"><h4 class="language_replace">生日禮金</h4></div>
                                                                <div class="td value"> - </div>
                                                            </div>
                                                            <div class="tr">
                                                                <div class="td title"><h4 class="language_replace">體育返水</h4></div>
                                                                <div class="td value"> - </div>
                                                            </div>
                                                            <div class="tr">
                                                                <div class="td title"><h4 class="language_replace">真人返水</h4></div>
                                                                <div class="td value"> - </div>
                                                            </div>
                                                            <div class="tr">
                                                                <div class="td title"><h4 class="language_replace">電子返水</h4></div>
                                                                <div class="td value"> - </div>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        <!-- 白銀 silver -->
                                        <div class="swiper-slide m-silver">
                                            <div class="slider-item">
                                                <div class="card-item">
                                                    <a class="card-item-link"></a>
                                                    <div class="card-item-box">
                                                        <h3 class="member-level language_replace">白銀</h3>
                                                        <div class="member-bouns">
                                                            <div class="item">
                                                                <h4 class="title language_replace">升級紅利</h4>
                                                                <span class="value"> - </span>
                                                            </div>
                                                            <div class="item">
                                                                <h4 class="title language_replace">月紅包</h4>
                                                                <span class="value"> - </span>
                                                            </div>
                                                        </div>
                                                        <div class="member-rights">
                                                            <div class="item">
                                                                <h4 class="title language_replace">累積存款要求</h4>
                                                                <span class="value">2,000</span>
                                                            </div>
                                                            <div class="item">
                                                                <h4 class="title language_replace">累積流水要求</h4>
                                                                <span class="value">12,000</span>
                                                            </div>
                                                            <div class="item">
                                                                <h4 class="title language_replace">保級流水</h4>
                                                                <span class="value">5,000</span>
                                                            </div>
                                                        </div>                                              
                                                    </div>
                                                </div>
                                                <div class="memberlevel-rules">
                                                    <div class="memberlevel-wrapper">
                                                        <div class="thead language_replace">白銀</div>
                                                        <div class="tbody">
                                                            <div class="tr">
                                                                <div class="td title"><h4 class="language_replace">累積存款</h4></div>
                                                                <div class="td value">2,000</div>
                                                            </div>
                                                            <div class="tr">
                                                                <div class="td title"><h4 class="language_replace">流水要求</h4></div>
                                                                <div class="td value">12,000</div>
                                                            </div>
                                                            <div class="tr">
                                                                <div class="td title"><h4 class="language_replace">保級流水</h4></div>
                                                                <div class="td value">5,000</div>
                                                            </div>
                                                            <div class="tr">
                                                                <div class="td title"><h4 class="language_replace">特別服務通道</h4></div>
                                                                <div class="td value">✕</div>
                                                            </div>
                                                            <div class="tr">
                                                                <div class="td title"><h4 class="language_replace">升級紅利</h4></div>
                                                                <div class="td value"> - </div>
                                                            </div>
                                                            <div class="tr">
                                                                <div class="td title"><h4 class="language_replace">月紅包</h4></div>
                                                                <div class="td value"> - </div>
                                                            </div>
                                                            <div class="tr">
                                                                <div class="td title"><h4 class="language_replace">生日禮金</h4></div>
                                                                <div class="td value"> - </div>
                                                            </div>
                                                            <div class="tr">
                                                                <div class="td title"><h4 class="language_replace">體育返水</h4></div>
                                                                <div class="td value"> - </div>
                                                            </div>
                                                            <div class="tr">
                                                                <div class="td title"><h4 class="language_replace">真人返水</h4></div>
                                                                <div class="td value"> - </div>
                                                            </div>
                                                            <div class="tr">
                                                                <div class="td title"><h4 class="language_replace">電子返水</h4></div>
                                                                <div class="td value"> - </div>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        
                                        <!--  勇士  Warrior/  黃金 gold-->
                                        <div class="swiper-slide m-warrior">
                                            <div class="slider-item">
                                                <div class="card-item">
                                                    <a class="card-item-link"></a>
                                                    <div class="card-item-box">
                                                        <h3 class="member-level language_replace">勇士</h3>
                                                        <div class="member-bouns">
                                                            <div class="item">
                                                                <h4 class="title language_replace">升級紅利</h4>
                                                                <span class="value">500</span>
                                                            </div>
                                                            <div class="item">
                                                                <h4 class="title language_replace">月紅包</h4>
                                                                <span class="value"> - </span>
                                                            </div>
                                                        </div>
                                                        <div class="member-rights">
                                                            <div class="item">
                                                                <h4 class="title language_replace">累積存款要求</h4>
                                                                <span class="value">10,000</span>
                                                            </div>
                                                            <div class="item">
                                                                <h4 class="title language_replace">累積流水要求</h4>
                                                                <span class="value">60,000</span>
                                                            </div>
                                                            <div class="item">
                                                                <h4 class="title language_replace">保級流水</h4>
                                                                <span class="value">18,000</span>
                                                            </div>
                                                        </div>                                              
                                                    </div>
                                                </div>
                                                <div class="memberlevel-rules">
                                                    <div class="memberlevel-wrapper">
                                                        <div class="thead language_replace">勇士</div>
                                                        <div class="tbody">
                                                            <div class="tr">
                                                                <div class="td title"><h4 class="language_replace">累積存款</h4></div>
                                                                <div class="td value">10,000</div>
                                                            </div>
                                                            <div class="tr">
                                                                <div class="td title"><h4 class="language_replace">流水要求</h4></div>
                                                                <div class="td value">60,000</div>
                                                            </div>
                                                            <div class="tr">
                                                                <div class="td title"><h4 class="language_replace">保級流水</h4></div>
                                                                <div class="td value">18,000</div>
                                                            </div>
                                                            <div class="tr">
                                                                <div class="td title"><h4 class="language_replace">特別服務通道</h4></div>
                                                                <div class="td value">✕</div>
                                                            </div>
                                                            <div class="tr">
                                                                <div class="td title"><h4 class="language_replace">升級紅利</h4></div>
                                                                <div class="td value">500</div>
                                                            </div>
                                                            <div class="tr">
                                                                <div class="td title"><h4 class="language_replace">月紅包</h4></div>
                                                                <div class="td value"> - </div>
                                                            </div>
                                                            <div class="tr">
                                                                <div class="td title"><h4 class="language_replace">生日禮金</h4></div>
                                                                <div class="td value"> - </div>
                                                            </div>
                                                            <div class="tr">
                                                                <div class="td title"><h4 class="language_replace">體育返水</h4></div>
                                                                <div class="td value">1.5%</div>
                                                            </div>
                                                            <div class="tr">
                                                                <div class="td title"><h4 class="language_replace">真人返水</h4></div>
                                                                <div class="td value">1.5%</div>
                                                            </div>
                                                            <div class="tr">
                                                                <div class="td title"><h4 class="language_replace">電子返水</h4></div>
                                                                <div class="td value"> - </div>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        <!-- 白金 platinum -->
                                        <div class="swiper-slide m-platinum">
                                            <div class="slider-item">
                                                <div class="card-item">
                                                    <a class="card-item-link"></a>
                                                    <div class="card-item-box">
                                                        <h3 class="member-level language_replace">白金</h3>
                                                        <div class="member-bouns">
                                                            <div class="item">
                                                                <h4 class="title language_replace">升級紅利</h4>
                                                                <span class="value">1,000</span>
                                                            </div>
                                                            <div class="item">
                                                                <h4 class="title language_replace">月紅包</h4>
                                                                <span class="value">500</span>
                                                            </div>
                                                        </div>
                                                        <div class="member-rights">
                                                            <div class="item">
                                                                <h4 class="title language_replace">累積存款要求</h4>
                                                                <span class="value">50,000</span>
                                                            </div>
                                                            <div class="item">
                                                                <h4 class="title language_replace">累積流水要求</h4>
                                                                <span class="value">300,000</span>
                                                            </div>
                                                            <div class="item">
                                                                <h4 class="title language_replace">保級流水</h4>
                                                                <span class="value">60,000</span>
                                                            </div>
                                                        </div>                                              
                                                    </div>
                                                </div>
                                                <div class="memberlevel-rules">
                                                    <div class="memberlevel-wrapper">
                                                        <div class="thead language_replace">白金</div>
                                                        <div class="tbody">
                                                            <div class="tr">
                                                                <div class="td title"><h4 class="language_replace">累積存款</h4></div>
                                                                <div class="td value">50,000</div>
                                                            </div>
                                                            <div class="tr">
                                                                <div class="td title"><h4 class="language_replace">流水要求</h4></div>
                                                                <div class="td value">300,000</div>
                                                            </div>
                                                            <div class="tr">
                                                                <div class="td title"><h4 class="language_replace">保級流水</h4></div>
                                                                <div class="td value">60,000</div>
                                                            </div>
                                                            <div class="tr">
                                                                <div class="td title"><h4 class="language_replace">特別服務通道</h4></div>
                                                                <div class="td value">✕</div>
                                                            </div>
                                                            <div class="tr">
                                                                <div class="td title"><h4 class="language_replace">升級紅利</h4></div>
                                                                <div class="td value">1,000</div>
                                                            </div>
                                                            <div class="tr">
                                                                <div class="td title"><h4 class="language_replace">月紅包</h4></div>
                                                                <div class="td value">500</div>
                                                            </div>
                                                            <div class="tr">
                                                                <div class="td title"><h4 class="language_replace">生日禮金</h4></div>
                                                                <div class="td value">1,500</div>
                                                            </div>
                                                            <div class="tr">
                                                                <div class="td title"><h4 class="language_replace">體育返水</h4></div>
                                                                <div class="td value">2%</div>
                                                            </div>
                                                            <div class="tr">
                                                                <div class="td title"><h4 class="language_replace">真人返水</h4></div>
                                                                <div class="td value">2%</div>
                                                            </div>
                                                            <div class="tr">
                                                                <div class="td title"><h4 class="language_replace">電子返水</h4></div>
                                                                <div class="td value">2%</div>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        <!-- 鑽石 diamond -->
                                        <div class="swiper-slide m-diamond">
                                            <div class="slider-item">
                                                <div class="card-item">
                                                    <a class="card-item-link"></a>
                                                    <div class="card-item-box">
                                                        <h3 class="member-level language_replace">鑽石</h3>
                                                        <div class="member-bouns">
                                                            <div class="item">
                                                                <h4 class="title language_replace">升級紅利</h4>
                                                                <span class="value">5,000</span>
                                                            </div>
                                                            <div class="item">
                                                                <h4 class="title language_replace">月紅包</h4>
                                                                <span class="value">1,000</span>
                                                            </div>
                                                        </div>
                                                        <div class="member-rights">
                                                            <div class="item">
                                                                <h4 class="title language_replace">累積存款要求</h4>
                                                                <span class="value">200,000</span>
                                                            </div>
                                                            <div class="item">
                                                                <h4 class="title language_replace">累積流水要求</h4>
                                                                <span class="value">1,200,000</span>
                                                            </div>
                                                            <div class="item">
                                                                <h4 class="title language_replace">保級流水</h4>
                                                                <span class="value">250,000</span>
                                                            </div>
                                                        </div>                                              
                                                    </div>
                                                </div>
                                                <div class="memberlevel-rules">
                                                    <div class="memberlevel-wrapper">
                                                        <div class="thead language_replace">鑽石</div>
                                                        <div class="tbody">
                                                            <div class="tr">
                                                                <div class="td title"><h4 class="language_replace">累積存款</h4></div>
                                                                <div class="td value">200,000</div>
                                                            </div>
                                                            <div class="tr">
                                                                <div class="td title"><h4 class="language_replace">流水要求</h4></div>
                                                                <div class="td value">1,200,000</div>
                                                            </div>
                                                            <div class="tr">
                                                                <div class="td title"><h4 class="language_replace">保級流水</h4></div>
                                                                <div class="td value">250,000</div>
                                                            </div>
                                                            <div class="tr">
                                                                <div class="td title"><h4 class="language_replace">特別服務通道</h4></div>
                                                                <div class="td value">〇</div>
                                                            </div>
                                                            <div class="tr">
                                                                <div class="td title"><h4 class="language_replace">升級紅利</h4></div>
                                                                <div class="td value">5,000</div>
                                                            </div>
                                                            <div class="tr">
                                                                <div class="td title"><h4 class="language_replace">月紅包</h4></div>
                                                                <div class="td value">1,000</div>
                                                            </div>
                                                            <div class="tr">
                                                                <div class="td title"><h4 class="language_replace">生日禮金</h4></div>
                                                                <div class="td value">3,000</div>
                                                            </div>
                                                            <div class="tr">
                                                                <div class="td title"><h4 class="language_replace">體育返水</h4></div>
                                                                <div class="td value">2.5%</div>
                                                            </div>
                                                            <div class="tr">
                                                                <div class="td title"><h4 class="language_replace">真人返水</h4></div>
                                                                <div class="td value">2.5%</div>
                                                            </div>
                                                            <div class="tr">
                                                                <div class="td title"><h4 class="language_replace">電子返水</h4></div>
                                                                <div class="td value">2.5%</div>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        <!-- 精英  Elite / 銀鑽 silver diamond -->
                                        <div class="swiper-slide m-elite">
                                            <div class="slider-item">
                                                <div class="card-item">
                                                    <a class="card-item-link"></a>
                                                    <div class="card-item-box">
                                                        <h3 class="member-level language_replace">精英</h3>
                                                        <div class="member-bouns">
                                                            <div class="item">
                                                                <h4 class="title language_replace">升級紅利</h4>
                                                                <span class="value">7,000</span>
                                                            </div>
                                                            <div class="item">
                                                                <h4 class="title language_replace">月紅包</h4>
                                                                <span class="value">1,500</span>
                                                            </div>
                                                        </div>
                                                        <div class="member-rights">
                                                            <div class="item">
                                                                <h4 class="title language_replace">累積存款要求</h4>
                                                                <span class="value">500,000</span>
                                                            </div>
                                                            <div class="item">
                                                                <h4 class="title language_replace">累積流水要求</h4>
                                                                <span class="value">3,000,000</span>
                                                            </div>
                                                            <div class="item">
                                                                <h4 class="title language_replace">保級流水</h4>
                                                                <span class="value">600,000</span>
                                                            </div>
                                                        </div>                                              
                                                    </div>
                                                </div>
                                                <div class="memberlevel-rules">
                                                    <div class="memberlevel-wrapper">
                                                        <div class="thead language_replace">精英</div>
                                                        <div class="tbody">
                                                            <div class="tr">
                                                                <div class="td title"><h4 class="language_replace">累積存款</h4></div>
                                                                <div class="td value">500,000</div>
                                                            </div>
                                                            <div class="tr">
                                                                <div class="td title"><h4 class="language_replace">流水要求</h4></div>
                                                                <div class="td value">3,000,000</div>
                                                            </div>
                                                            <div class="tr">
                                                                <div class="td title"><h4 class="language_replace">保級流水</h4></div>
                                                                <div class="td value">600,000</div>
                                                            </div>
                                                            <div class="tr">
                                                                <div class="td title"><h4 class="language_replace">特別服務通道</h4></div>
                                                                <div class="td value">〇</div>
                                                            </div>
                                                            <div class="tr">
                                                                <div class="td title"><h4 class="language_replace">升級紅利</h4></div>
                                                                <div class="td value">7,000</div>
                                                            </div>
                                                            <div class="tr">
                                                                <div class="td title"><h4 class="language_replace">月紅包</h4></div>
                                                                <div class="td value">1,500</div>
                                                            </div>
                                                            <div class="tr">
                                                                <div class="td title"><h4 class="language_replace">生日禮金</h4></div>
                                                                <div class="td value">5,000</div>
                                                            </div>
                                                            <div class="tr">
                                                                <div class="td title"><h4 class="language_replace">體育返水</h4></div>
                                                                <div class="td value">3%</div>
                                                            </div>
                                                            <div class="tr">
                                                                <div class="td title"><h4 class="language_replace">真人返水</h4></div>
                                                                <div class="td value">3%</div>
                                                            </div>
                                                            <div class="tr">
                                                                <div class="td title"><h4 class="language_replace">電子返水</h4></div>
                                                                <div class="td value">3%</div>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        <!-- 金鑽 Gold Diamond -->
                                        <div class="swiper-slide m-G-diamond">
                                            <div class="slider-item">
                                                <div class="card-item">
                                                    <a class="card-item-link"></a>
                                                    <div class="card-item-box">
                                                        <h3 class="member-level language_replace">金鑽</h3>
                                                        <div class="member-bouns">
                                                            <div class="item">
                                                                <h4 class="title language_replace">升級紅利</h4>
                                                                <span class="value">10,000</span>
                                                            </div>
                                                            <div class="item">
                                                                <h4 class="title language_replace">月紅包</h4>
                                                                <span class="value">2,000</span>
                                                            </div>
                                                        </div>
                                                        <div class="member-rights">
                                                            <div class="item">
                                                                <h4 class="title language_replace">累積存款要求</h4>
                                                                <span class="value">1,200,000</span>
                                                            </div>
                                                            <div class="item">
                                                                <h4 class="title language_replace">累積流水要求</h4>
                                                                <span class="value">7,200,000</span>
                                                            </div>
                                                            <div class="item">
                                                                <h4 class="title language_replace">保級流水</h4>
                                                                <span class="value">1,800,000</span>
                                                            </div>
                                                        </div>                                              
                                                    </div>
                                                </div>
                                                <div class="memberlevel-rules">
                                                    <div class="memberlevel-wrapper">
                                                        <div class="thead language_replace">金鑽</div>
                                                        <div class="tbody">
                                                            <div class="tr">
                                                                <div class="td title"><h4 class="language_replace">累積存款</h4></div>
                                                                <div class="td value">1,200,000</div>
                                                            </div>
                                                            <div class="tr">
                                                                <div class="td title"><h4 class="language_replace">流水要求</h4></div>
                                                                <div class="td value">7,200,000</div>
                                                            </div>
                                                            <div class="tr">
                                                                <div class="td title"><h4 class="language_replace">保級流水</h4></div>
                                                                <div class="td value">1,800,000</div>
                                                            </div>
                                                            <div class="tr">
                                                                <div class="td title"><h4 class="language_replace">特別服務通道</h4></div>
                                                                <div class="td value">〇</div>
                                                            </div>
                                                            <div class="tr">
                                                                <div class="td title"><h4 class="language_replace">升級紅利</h4></div>
                                                                <div class="td value">10,000</div>
                                                            </div>
                                                            <div class="tr">
                                                                <div class="td title"><h4 class="language_replace">月紅包</h4></div>
                                                                <div class="td value">2,000</div>
                                                            </div>
                                                            <div class="tr">
                                                                <div class="td title"><h4 class="language_replace">生日禮金</h4></div>
                                                                <div class="td value">8,888</div>
                                                            </div>
                                                            <div class="tr">
                                                                <div class="td title"><h4 class="language_replace">體育返水</h4></div>
                                                                <div class="td value">3.5%</div>
                                                            </div>
                                                            <div class="tr">
                                                                <div class="td title"><h4 class="language_replace">真人返水</h4></div>
                                                                <div class="td value">3.5%</div>
                                                            </div>
                                                            <div class="tr">
                                                                <div class="td title"><h4 class="language_replace">電子返水</h4></div>
                                                                <div class="td value">3.5%</div>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>

                                        <!-- 大師 Master/ 星耀 Starlight  -->
                                        <div class="swiper-slide m-master">
                                            <div class="slider-item">
                                                <div class="card-item">
                                                    <a class="card-item-link"></a>
                                                    <div class="card-item-box">
                                                        <h3 class="member-level language_replace">大師</h3>
                                                        <div class="member-bouns">
                                                            <div class="item">
                                                                <h4 class="title language_replace">升級紅利</h4>
                                                                <span class="value">12,000</span>
                                                            </div>
                                                            <div class="item">
                                                                <h4 class="title language_replace">月紅包</h4>
                                                                <span class="value">3,000</span>
                                                            </div>
                                                        </div>
                                                        <div class="member-rights">
                                                            <div class="item">
                                                                <h4 class="title language_replace">累積存款要求</h4>
                                                                <span class="value">3,000,000</span>
                                                            </div>
                                                            <div class="item">
                                                                <h4 class="title language_replace">累積流水要求</h4>
                                                                <span class="value">18,000,000</span>
                                                            </div>
                                                            <div class="item">
                                                                <h4 class="title language_replace">保級流水</h4>
                                                                <span class="value">6,000,000</span>
                                                            </div>
                                                        </div>                                              
                                                    </div>
                                                </div>
                                                <div class="memberlevel-rules">
                                                    <div class="memberlevel-wrapper">
                                                        <div class="thead language_replace">大師</div>
                                                        <div class="tbody">
                                                            <div class="tr">
                                                                <div class="td title"><h4 class="language_replace">累積存款</h4></div>
                                                                <div class="td value">3,000,000</div>
                                                            </div>
                                                            <div class="tr">
                                                                <div class="td title"><h4 class="language_replace">流水要求</h4></div>
                                                                <div class="td value">18,000,000</div>
                                                            </div>
                                                            <div class="tr">
                                                                <div class="td title"><h4 class="language_replace">保級流水</h4></div>
                                                                <div class="td value">6,000,000</div>
                                                            </div>
                                                            <div class="tr">
                                                                <div class="td title"><h4 class="language_replace">特別服務通道</h4></div>
                                                                <div class="td value">〇</div>
                                                            </div>
                                                            <div class="tr">
                                                                <div class="td title"><h4 class="language_replace">升級紅利</h4></div>
                                                                <div class="td value">12,000</div>
                                                            </div>
                                                            <div class="tr">
                                                                <div class="td title"><h4 class="language_replace">月紅包</h4></div>
                                                                <div class="td value">3,000</div>
                                                            </div>
                                                            <div class="tr">
                                                                <div class="td title"><h4 class="language_replace">生日禮金</h4></div>
                                                                <div class="td value">10,000</div>
                                                            </div>
                                                            <div class="tr">
                                                                <div class="td title"><h4 class="language_replace">體育返水</h4></div>
                                                                <div class="td value">4%</div>
                                                            </div>
                                                            <div class="tr">
                                                                <div class="td title"><h4 class="language_replace">真人返水</h4></div>
                                                                <div class="td value">4%</div>
                                                            </div>
                                                            <div class="tr">
                                                                <div class="td title"><h4 class="language_replace">電子返水</h4></div>
                                                                <div class="td value">4%</div>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>

                                        <!-- 宗師 Grandmaster / 永恆 eternal -->   
                                        <div class="swiper-slide m-grandmaster">
                                            <div class="slider-item">
                                                <div class="card-item">
                                                    <a class="card-item-link"></a>
                                                    <div class="card-item-box">
                                                        <h3 class="member-level language_replace">宗師</h3>
                                                        <div class="member-bouns">
                                                            <div class="item">
                                                                <h4 class="title language_replace">升級紅利</h4>
                                                                <span class="value">50,000</span>
                                                            </div>
                                                            <div class="item">
                                                                <h4 class="title language_replace">月紅包</h4>
                                                                <span class="value">10,000</span>
                                                            </div>
                                                        </div>
                                                        <div class="member-rights">
                                                            <div class="item">
                                                                <h4 class="title language_replace">累積存款要求</h4>
                                                                <span class="value">10,000,000</span>
                                                            </div>
                                                            <div class="item">
                                                                <h4 class="title language_replace">累積流水要求</h4>
                                                                <span class="value">60,000,000</span>
                                                            </div>
                                                            <div class="item">
                                                                <h4 class="title language_replace">保級流水</h4>
                                                                <span class="value">25,000,000</span>
                                                            </div>
                                                        </div>                                              
                                                    </div>
                                                </div>
                                                <div class="memberlevel-rules">
                                                    <div class="memberlevel-wrapper">
                                                        <div class="thead language_replace">宗師</div>
                                                        <div class="tbody">
                                                            <div class="tr">
                                                                <div class="td title"><h4 class="language_replace">累積存款</h4></div>
                                                                <div class="td value">10,000,000</div>
                                                            </div>
                                                            <div class="tr">
                                                                <div class="td title"><h4 class="language_replace">流水要求</h4></div>
                                                                <div class="td value">60,000,000</div>
                                                            </div>
                                                            <div class="tr">
                                                                <div class="td title"><h4 class="language_replace">保級流水</h4></div>
                                                                <div class="td value">25,000,000</div>
                                                            </div>
                                                            <div class="tr">
                                                                <div class="td title"><h4 class="language_replace">特別服務通道</h4></div>
                                                                <div class="td value">〇</div>
                                                            </div>
                                                            <div class="tr">
                                                                <div class="td title"><h4 class="language_replace">升級紅利</h4></div>
                                                                <div class="td value">50,000</div>
                                                            </div>
                                                            <div class="tr">
                                                                <div class="td title"><h4 class="language_replace">月紅包</h4></div>
                                                                <div class="td value">10,000</div>
                                                            </div>
                                                            <div class="tr">
                                                                <div class="td title"><h4 class="language_replace">生日禮金</h4></div>
                                                                <div class="td value">20,000</div>
                                                            </div>
                                                            <div class="tr">
                                                                <div class="td title"><h4 class="language_replace">體育返水</h4></div>
                                                                <div class="td value">4.5%</div>
                                                            </div>
                                                            <div class="tr">
                                                                <div class="td title"><h4 class="language_replace">真人返水</h4></div>
                                                                <div class="td value">4.5%</div>
                                                            </div>
                                                            <div class="tr">
                                                                <div class="td title"><h4 class="language_replace">電子返水</h4></div>
                                                                <div class="td value">4.5%</div>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>  

                                        <!-- 史詩 Epic/ 傳說 legend -->
                                        <div class="swiper-slide m-epic">
                                            <div class="slider-item">
                                                <div class="card-item">
                                                    <a class="card-item-link"></a>
                                                    <div class="card-item-box">
                                                        <h3 class="member-level language_replace">史詩</h3>
                                                        <div class="member-bouns">
                                                            <div class="item">
                                                                <h4 class="title language_replace">升級紅利</h4>
                                                                <span class="value">100,000</span>
                                                            </div>
                                                            <div class="item">
                                                                <h4 class="title language_replace">月紅包</h4>
                                                                <span class="value">20,000</span>
                                                            </div>
                                                        </div>
                                                        <div class="member-rights">
                                                            <div class="item">
                                                                <h4 class="title language_replace">累積存款要求</h4>
                                                                <span class="value">30,000,000</span>
                                                            </div>
                                                            <div class="item">
                                                                <h4 class="title language_replace">累積流水要求</h4>
                                                                <span class="value">180,000,000</span>
                                                            </div>
                                                            <div class="item">
                                                                <h4 class="title language_replace">保級流水</h4>
                                                                <span class="value">50,000,000</span>
                                                            </div>
                                                        </div>                                              
                                                    </div>
                                                </div>
                                                <div class="memberlevel-rules">
                                                    <div class="memberlevel-wrapper">
                                                        <div class="thead language_replace">史詩</div>
                                                        <div class="tbody">
                                                            <div class="tr">
                                                                <div class="td title"><h4 class="language_replace">累積存款</h4></div>
                                                                <div class="td value">30,000,000</div>
                                                            </div>
                                                            <div class="tr">
                                                                <div class="td title"><h4 class="language_replace">流水要求</h4></div>
                                                                <div class="td value">180,000,000</div>
                                                            </div>
                                                            <div class="tr">
                                                                <div class="td title"><h4 class="language_replace">保級流水</h4></div>
                                                                <div class="td value">50,000,000</div>
                                                            </div>
                                                            <div class="tr">
                                                                <div class="td title"><h4 class="language_replace">特別服務通道</h4></div>
                                                                <div class="td value">〇</div>
                                                            </div>
                                                            <div class="tr">
                                                                <div class="td title"><h4 class="language_replace">升級紅利</h4></div>
                                                                <div class="td value">100,000</div>
                                                            </div>
                                                            <div class="tr">
                                                                <div class="td title"><h4 class="language_replace">月紅包</h4></div>
                                                                <div class="td value">20,000</div>
                                                            </div>
                                                            <div class="tr">
                                                                <div class="td title"><h4 class="language_replace">生日禮金</h4></div>
                                                                <div class="td value">50,000</div>
                                                            </div>
                                                            <div class="tr">
                                                                <div class="td title"><h4 class="language_replace">體育返水</h4></div>
                                                                <div class="td value">5%</div>
                                                            </div>
                                                            <div class="tr">
                                                                <div class="td title"><h4 class="language_replace">真人返水</h4></div>
                                                                <div class="td value">5%</div>
                                                            </div>
                                                            <div class="tr">
                                                                <div class="td title"><h4 class="language_replace">電子返水</h4></div>
                                                                <div class="td value">5%</div>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>                                           
                                </div>
                                <div class="swiper-button-next"></div>
                                <div class="swiper-button-prev"></div> 
                            </div>

                            <div class="MT-table-wrapper">
                                <table class="MT__table memberlevel-table">
                                    <thead class="Thead">
                                        <tr class="thead__tr">
                                            <td class="thead__th language_replace" style="width: 200px;">等級</td>
                                            <td class="thead__th language_replace">VIP0</td>
                                            <td class="thead__th language_replace">青銅</td>
                                            <td class="thead__th language_replace">白銀</td>
                                            <td class="thead__th language_replace">勇士</td>
                                            <td class="thead__th language_replace">白金</td>
                                            <td class="thead__th language_replace">鑽石</td>
                                            <td class="thead__th language_replace">精英</td>
                                            <td class="thead__th language_replace">金鑽</td>
                                            <td class="thead__th language_replace">大師</td>
                                            <td class="thead__th language_replace">宗師</td>
                                            <td class="thead__th language_replace">史詩</td>
                                        </tr>
                                     </thead>
                                    <tbody class="Tbody">
                                        <tr class="tbody__tr">
                                            <td class="tbody__td language_replace">累積存款</td>
                                            <td class="tbody__td"> - </td>
                                            <td class="tbody__td">500</td>
                                            <td class="tbody__td">2,000</td>
                                            <td class="tbody__td">10,000</td>
                                            <td class="tbody__td">50,000</td>
                                            <td class="tbody__td">200,000</td>
                                            <td class="tbody__td">500,000</td>
                                            <td class="tbody__td">1,200,000</td>
                                            <td class="tbody__td">3,000,000</td>
                                            <td class="tbody__td">10,000,000</td>
                                            <td class="tbody__td">30,000,000</td>
                                        </tr>
                                        <tr class="tbody__tr">
                                            <td class="tbody__td language_replace">流水要求</td>
                                            <td class="tbody__td"> - </td>
                                            <td class="tbody__td">3,000</td>
                                            <td class="tbody__td">12,000</td>
                                            <td class="tbody__td">60,000</td>
                                            <td class="tbody__td">300,000</td>
                                            <td class="tbody__td">1,200,000</td>
                                            <td class="tbody__td">3,000,000</td>
                                            <td class="tbody__td">7,200,000</td>
                                            <td class="tbody__td">18,000,000</td>
                                            <td class="tbody__td">60,000,000</td>
                                            <td class="tbody__td">180,000,000</td>
                                        </tr>
                                        <tr class="tbody__tr">
                                            <td class="tbody__td language_replace">保級流水</td>
                                            <td class="tbody__td"> - </td>
                                            <td class="tbody__td">2,000</td>
                                            <td class="tbody__td">5,000</td>
                                            <td class="tbody__td">18,000</td>
                                            <td class="tbody__td">60,000</td>
                                            <td class="tbody__td">250,000</td>
                                            <td class="tbody__td">600,000</td>
                                            <td class="tbody__td">1,800,000</td>
                                            <td class="tbody__td">6,000,000</td>
                                            <td class="tbody__td">25,000,000</td>
                                            <td class="tbody__td">50,000,000</td>
                                        </tr>
                                        <tr class="tbody__tr">
                                            <td class="tbody__td language_replace">特別服務通道</td>
                                            <td class="tbody__td">✕</td>
                                            <td class="tbody__td">✕</td>
                                            <td class="tbody__td">✕</td>
                                            <td class="tbody__td">✕</td>
                                            <td class="tbody__td">✕</td>
                                            <td class="tbody__td">〇</td>
                                            <td class="tbody__td">〇</td>
                                            <td class="tbody__td">〇</td>
                                            <td class="tbody__td">〇</td>
                                            <td class="tbody__td">〇</td>
                                            <td class="tbody__td">〇</td>
                                        </tr>
                                        <tr class="tbody__tr">
                                            <td class="tbody__td language_replace">升級紅利</td>
                                            <td class="tbody__td"> - </td>
                                            <td class="tbody__td"> - </td>
                                            <td class="tbody__td"> - </td>
                                            <td class="tbody__td">500</td>
                                            <td class="tbody__td">1,000</td>
                                            <td class="tbody__td">5,000</td>
                                            <td class="tbody__td">7,000</td>
                                            <td class="tbody__td">10,000</td>
                                            <td class="tbody__td">12,000</td>
                                            <td class="tbody__td">50,000</td>
                                            <td class="tbody__td">100,000</td>
                                        </tr>
                                        <tr class="tbody__tr">
                                            <td class="tbody__td language_replace">月紅包</td>
                                            <td class="tbody__td"> - </td>
                                            <td class="tbody__td"> - </td>
                                            <td class="tbody__td"> - </td>
                                            <td class="tbody__td"> - </td>
                                            <td class="tbody__td">500</td>
                                            <td class="tbody__td">1,000</td>
                                            <td class="tbody__td">1,500</td>
                                            <td class="tbody__td">2,000</td>
                                            <td class="tbody__td">3,000</td>
                                            <td class="tbody__td">10,000</td>
                                            <td class="tbody__td">20,000</td>
                                        </tr>
                                        <tr class="tbody__tr">
                                            <td class="tbody__td language_replace">生日禮金</td>
                                            <td class="tbody__td"> - </td>
                                            <td class="tbody__td"> - </td>
                                            <td class="tbody__td"> - </td>
                                            <td class="tbody__td"> - </td>
                                            <td class="tbody__td">1,500</td>
                                            <td class="tbody__td">3,000</td>
                                            <td class="tbody__td">5,000</td>
                                            <td class="tbody__td">8,888</td>
                                            <td class="tbody__td">10,000</td>
                                            <td class="tbody__td">20,000</td>
                                            <td class="tbody__td">50,000</td>
                                        </tr>
                                        <tr class="tbody__tr">
                                            <td class="tbody__td language_replace">體育返水</td>
                                            <td class="tbody__td"> - </td>
                                            <td class="tbody__td"> - </td>
                                            <td class="tbody__td"> - </td>
                                            <td class="tbody__td">1.50%</td>
                                            <td class="tbody__td">2%</td>
                                            <td class="tbody__td">2.50%</td>
                                            <td class="tbody__td">3%</td>
                                            <td class="tbody__td">3.50%</td>
                                            <td class="tbody__td">4%</td>
                                            <td class="tbody__td">4.50%</td>
                                            <td class="tbody__td">5%</td>
                                        </tr>
                                        <tr class="tbody__tr">
                                            <td class="tbody__td language_replace">真人返水</td>
                                            <td class="tbody__td"> - </td>
                                            <td class="tbody__td"> - </td>
                                            <td class="tbody__td"> - </td>
                                            <td class="tbody__td">1.50%</td>
                                            <td class="tbody__td">2%</td>
                                            <td class="tbody__td">2.50%</td>
                                            <td class="tbody__td">3%</td>
                                            <td class="tbody__td">3.50%</td>
                                            <td class="tbody__td">4%</td>
                                            <td class="tbody__td">4.50%</td>
                                            <td class="tbody__td">5%</td>
                                        </tr>
                                        <tr class="tbody__tr">
                                            <td class="tbody__td language_replace">電子返水</td>
                                            <td class="tbody__td"> - </td>
                                            <td class="tbody__td"> - </td>
                                            <td class="tbody__td"> - </td>
                                            <td class="tbody__td"> - </td>
                                            <td class="tbody__td">2%</td>
                                            <td class="tbody__td">2.50%</td>
                                            <td class="tbody__td">3%</td>
                                            <td class="tbody__td">3.50%</td>
                                            <td class="tbody__td">4%</td>
                                            <td class="tbody__td">4.50%</td>
                                            <td class="tbody__td">5%</td>
                                        </tr>
                                    </tbody>
                                </table>
                            </div>  

                            <div class="notice-wrapper">
                                <div class="sec-title-container">
                                    <div class="sec-title-wrapper">
                                        <h6 class="sec-title title-deco"><span class="language_replace">VIP規則</span></h6>
                                    </div>
                                </div>
                                <ul class="notice-list">
                                    <li class="item language_replace">1.晉升標準：會員的累積存款以及累計投注額在30天內達到相應級別的要求，即可在次日24點前晉級相應VIP等級。</li>
                                    <li class="item language_replace">2.保級要求：會員在達到某VIP等級後，30天內投注需要完成保級要求。如果在此期間完成晉升，保級要求重新按照當前等級計算。</li>
                                    <li class="item language_replace">3.降級標準：如果會員在30天內沒有完成相應的保級要求流水，系統會自動降級1個等級，相應的返水及其它優惠也會隨之調整至降級後的等級。</li>
                                    <li class="item language_replace">4.自升/降級日起算，每30天後會重新計算累積存款以及累計投注額。</li>
                                    <li class="item language_replace">5.30日的計算條件以升降級的當下重新計算(VIP0時是以當日往前30天的總洗碼量計算。若是青銅降回VIP0級，以降級的時間點重新計算30日洗碼量)</li>
                                    <li class="item language_replace">6.網站保留對活動的修改、停止及最終解釋權。</li>
                                </ul>
                            </div>
                        </section>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Modal Verify Tip -->
    <div class="modal fade footer-center" id="ModalVerify" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered modal-dialog-scrollable">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close" id="btn_PupLangClose">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <div class="Verify-popup-wrapper popup-tip">
                        <ul class="Verify-popup-list">
                            <li class="item">
                                <h3 class="title language_replace">為何需要認證?</h3>
                                <p class="desc language_replace">認證需要您填入您實際的姓名，以證明為帳號之所有者，未來於出入金時的證明。因此若未完成認證，則無法使用出入金等部分功能，也無法享有領取獎勵的權益。</p>
                            </li>
                            <li class="item">
                                <h3 class="title language_replace">如何進行認證?</h3>
                                <p class="desc language_replace">於會員中心按下<span class="text-bold">『進行認證』</span>之按鈕，或欲使用被限制之功能時，提供填寫介面以利會員完成認證。</p>
                            </li>
                        </ul>
                    </div>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
