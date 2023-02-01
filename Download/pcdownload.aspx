<%@ Page Language="VB" %>
<!doctype html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, user-scale=no">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <title>Lucky Sprite game APP</title>
    <link rel="stylesheet" type="text/css" href="css/main.css">
    <link rel="stylesheet" type="text/css" href="css/downloadPage.css">
</head>
    
    <script type="text/javascript">
        function onGame(){
            var elm_mainDiv = document.getElementById("id_mainDiv");
            elm_mainDiv.className = "bg onGame";
        }
        function onAgent(){
            var elm_mainDiv = document.getElementById("id_mainDiv");
            elm_mainDiv.className = "bg onAgent";
        }
    </script>

<body>
    <div id="id_mainDiv" class="bg onAgent">
        <div class="main dlP_main">
            <div class="dlP_Wrapper">
                <div class="dlP_tabDiv">
                    <!-- 當前tab被選中需額外加上class="active" -->
                   <%-- <div class="dlP_tab dlP_tab1" onclick="onGame()">
                        <span class="language_replace">GAME APP</span>
                    </div>--%>
                    <div class="dlP_tab dlP_tab2" onclick="onAgent()">
                        <span class="language_replace">GAME APP</span>
                    </div>
                </div>  
                <!-- game 內容 -->
                <%--<div class="dlP_Con gameLoadDiv">
                    <div class="dlP_ConAppInfo">
                        <div class="dlP_AppIcon"><img src="images/DDicon-App_gold.png" alt="icon_game"></div>
                        <div class="dlP_AppType"><span>GAME APP</span></div>
                        <div class="dlP_AppName"><span>龍昇88 遊戲APP</span></div>
                    </div>
                    <div class="dlP_ConAppQrcode">
                        <img class="img" src="images/Qrcode_Game.png" alt="qrcode" />
                    </div>
                    <div class="dlP_ConBtnDiv" onclick="javascript:location.href='https://game.ewin-soft.com/GetDownloadLink?Tag=MDBE0B1K'">
                        <div class="dlP_ConBtn" onClick="">
                            <img src="images/APPSTOREICON.png">
                            <img src="images/APPSTOREICON2.png">
                            <span>Download</span>
                        </div>
                    </div>
                </div>--%>
                <!-- -->
                <div class="dlP_Con agentLoadDiv">
                    <div class="dlP_ConAppInfo">
                        <div class="dlP_AppIcon"><img src="../images/appdownload_logo.png" alt="icon_game"></div>
                        <div class="dlP_AppType"><img src="../images/logo.png?1" alt="Lucky Sprite"></div>
                        <!-- <span>Agent APP</span> -->
                        <div class="dlP_AppName"><span>Lucky Sprite game APP</span></div>
                    </div>
                    <div class="dlP_ConAppQrcode">
                        <img class="img" src="images/DownloadPage.png" alt="qrcode" />
                    </div>
                    <div class="dlP_ConBtnDiv">
                        <div class="dlP_ConBtn" onclick="javascript:location.href='https://backend.ewin888.com/GetDownloadLink.aspx?Tag=A0NQP51Y'">
                            <img src="images/APPSTOREICON.png">
                            <img src="images/APPSTOREICON2.png">
                            <span>Download</span>
                        </div>
                    </div>
                </div>
                
                
            </div>
        </div>
    </div>
</body>
</html>
