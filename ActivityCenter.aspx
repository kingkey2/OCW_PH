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
    <title>Lucky Fanta</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="css/basic.min.css">
    <link rel="stylesheet" href="css/main.css">
    <link rel="stylesheet" href="css/activity.css">
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+JP:wght@300;500&display=swap" rel="Prefetch" as="style" onload="this.rel = 'stylesheet'" />
    
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
                getAllActivityFromJson();
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
                            var k = o1.DocumentList[i];

                            kk.onclick = new Function("showPopup('" + k.DocNumber + "')");
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
                        for (var i = 0; i < o2.DocumentList.length; i++) {
                            var k1 = o2.DocumentList[i];

                            $.ajax({
                                url: "<%=EWinWeb.EWinUrl%>/GetDocument.aspx?DocNumber=" + k1.DocNumber,
                                success: (function (res) {
                                    var k = this;
                                    $(k).find('.activityTitle').html(res);

                                }).bind(kkk)
                            });
                        }
                    }
                }
            }
        }).bind(RecordDom2));

        LobbyClient.CheckDocumentByTagName(GUID, TagName_Pic, (function (success, o2) {
            var kkk = this;
            if (success) {
                if (o2.Result == 0) {
                    if (o2.DocumentList.length > 0) {
                        for (var i = 0; i < o2.DocumentList.length; i++) {
                            var k1 = o2.DocumentList[i];

                            $.ajax({
                                url: "<%=EWinWeb.EWinUrl%>/GetDocument.aspx?DocNumber=" + k1.DocNumber,
                                success: (function (res) {
                                    var k = this;
                                    $(k).find('.activityPicture').html(res);

                                }).bind(kkk)
                            });
                        }
                    }
                }
            }
        }).bind(RecordDom2));

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
                    <a class="btn btn-link btn-prize" onclick="window.parent.API_LoadPage('','Prize.aspx', true)">
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
        
                    </div>
                    <div class="activity-item-group" id="divFinish" style="display:none">
        
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
                    <button type="button" class="btn btn-full-sub is-hide" onclick="window.parent.API_LoadPage('','Prize.aspx')">領取獎勵</button>

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
                        <div class="activity-popup-detail-inner" >
                        </div>
                    </article>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-primary language_replace" onclick="window.parent.API_LoadPage('Casino', 'Casino.aspx', false)">開始洗碼</button>

                    <!--獎勵可領取-->
                    <button type="button" class="btn btn-full-sub is-hide" onclick="window.parent.API_LoadPage('','Prize.aspx')">領取獎勵</button>

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
                    <button type="button" class="btn btn-primary language_replace" onclick="window.parent.API_LoadPage('','Prize.aspx')">參加活動</button>

                    <!--獎勵可領取-->
                    <button type="button" class="btn btn-full-sub is-hide language_replace" onclick="window.parent.API_LoadPage('','Prize.aspx')">參加活動</button>

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

    <div style="display:none" id="tmpActivity">
        <figure class="activity-item">
             <div class="activity-item-inner"><%-- onclick="GoActivityDetail(14,'/Activity/event/ne-rt/202210/index-jp.html')"--%>
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

    <div style="display:none" id="tmpActivityDetail">

    </div>

</body>

</html>
