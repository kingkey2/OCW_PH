<%@ Page Language="C#" %>

<%
    Newtonsoft.Json.Linq.JObject jObject = EWinWeb.GetSettingJObj();
    string MaintainMessage = jObject["MaintainMessage"].ToString();


%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Lucky Sprite - Most popular online casino</title>
    <link rel="stylesheet" href="Scripts/OutSrc/lib/bootstrap/css/bootstrap.min.css" type="text/css" />
    <link rel="stylesheet" href="css/icons.css" type="text/css" />
    <link rel="stylesheet" href="css/global.css" type="text/css" />
    <!--日文圖片-->
    <meta property="og:image" content="https://casino-maharaja.com/images/share_pic.png" />
</head>
<body>
    <div class="page-container">
        <!-- 系統錯誤 -->
        <div id="system-msg" class="">
            <div class="layout-full-screen system-msg-container">
                <div class="main-panel">

                    <section class="section-wrap">
                        <div class="logo">
                            <img src="images/assets/logo-icon.svg" alt="">
                        </div>
                        <div class="img-wrap img-error">
                            <img src="images/assets/feature-img.png">
                        </div>
                        <div class="text-wrap text-center">
                            <p>
                                <span class="language_replace">Lucky Sprite in currently down for maintenance</span><br>
                                <span class="language_replace">Please wait a moment, we will be right back!</span><br>
                                <br>
                                <span class="language_replace"><%:MaintainMessage%></span>
                            </p>
                            <!-- <p><span class="language_replace">您點選的頁面沒有反應，請回到首頁。</span></p> -->
                        </div>
                        <div class="btn-container">
                            <a href="index.aspx" class="square-link outline">
                                <i class="icon-home"></i>
                                <!-- <span class="language_replace">首頁</span> -->
                                <span class="language_replace">Home</span>
                            </a>
                        </div>
                    </section>

                </div>
            </div>

        </div>

    </div>
    <script type="text/javascript">
</script>
</body>
</html>
