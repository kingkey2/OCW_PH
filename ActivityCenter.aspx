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
    <title>Maharaja</title>
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
    var v = "<%:Version%>";
    var t = "<%:type%>";

    function init() {
        if (self == top) {
            window.parent.location.href = "index.aspx";
        }

        WebInfo = window.parent.API_GetWebInfo();
        LobbyClient = window.parent.API_GetLobbyAPI();
        lang = window.parent.API_GetLang();
        mlp = new multiLanguage(v);

        mlp.loadLanguage(lang, function () {
            window.parent.API_LoadingEnd();

            if (LobbyClient != null) {
                getActivity();
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
                    window.parent.API_LoadingEnd(1);
                });
                break;
        }
    }

    function getActivity() {
        var GUID = Math.uuid();
        var TagName = "Activity";

        LobbyClient.CheckDocumentByTagName(GUID, TagName, function (success, o) {
            if (success) {
                if (o.Result == 0) {
                    var ParentMain = document.getElementById("divProcessing");
                    ParentMain.innerHTML = "";

                    if (o.DocumentList.length > 0) {
                        var RecordDom2;
                        for (var i = 0; i < o.DocumentList.length; i++) {
                            var record = o.DocumentList[i];

                            RecordDom2 = c.getTemplate("tmpActivity");

                            let DocNumber = record.DocNumber;
                            
                            LobbyClient.CheckDocumentByTagName(GUID, DocNumber + "_Pic", function (success, o) {
                                if (success) {
                                    if (o.Result == 0) {
                                        if (o.DocumentList.length > 0) {
                                            for (var i = 0; i < o.DocumentList.length; i++) {
                                                var record = o.DocumentList[i];

                                                let DocNumber = record.DocNumber;

                                                $.ajax({
                                                    url: "<%=EWinWeb.EWinUrl%>/GetDocument.aspx?DocNumber=" + DocNumber,
                                                    success: function (res) {
                                                        $(RecordDom2).find('.activityPicture').html(res);
                                                        $(RecordDom2).find('.activityPicture').children().find('img').unwrap();
                                                    }
                                                });
                                            }
                                        }
                                    }
                                }
                            });

                            LobbyClient.CheckDocumentByTagName(GUID, DocNumber + "_Title", function (success, o) {
                                if (success) {
                                    if (o.Result == 0) {
                                        if (o.DocumentList.length > 0) {
                                            for (var i = 0; i < o.DocumentList.length; i++) {
                                                var record = o.DocumentList[i];

                                                let DocNumber = record.DocNumber;

                                                $.ajax({
                                                    url: "<%=EWinWeb.EWinUrl%>/GetDocument.aspx?DocNumber=" + DocNumber,
                                                    success: function (res) {
                                                        $(RecordDom2).find('.activityTitle').html(res);
                                                    }
                                                });
                                            }
                                        }
                                    }
                                }
                            });

                            RecordDom2.onclick = new Function("showPopup('" + DocNumber + "')");

                            ParentMain.appendChild(RecordDom2);
                        }
                    }
                }
            }
        });
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
                <section class="section-wrap section-activity">
                    <div class="activity-item-group" id="divProcessing">
        
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
