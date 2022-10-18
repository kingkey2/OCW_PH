<%@ Page Language="C#" %>

<% 
    string SID;
    string Lang;
    string gameBrand;
    string gameName;
    string CurrencyType;

    SID = Request["SID"];
    Lang = Request["Lang"];
    gameBrand = Request["gameBrand"];
    gameName = Request["gameName"];
    CurrencyType = Request["CurrencyType"];

%>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title></title>
    <link rel="stylesheet" href="css/basic.min.css">
    <link rel="stylesheet" href="css/main.css">
    <script type="text/javascript" src="/Scripts/LobbyAPI.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
    <script type="text/javascript" src="/Scripts/Math.uuid.js"></script>
    <script type="text/javascript" src="/Scripts/NoSleep.js"></script>
</head>
<script>
    var SID = "<%=SID%>";
    var Lang = "<%=Lang%>";
    var gameBrand = "<%=gameBrand%>";
    var gameName = "<%=gameName%>";
    var CurrencyType = "<%=CurrencyType%>";
    var lobbyClient;
    var noSleep;

    function GoBack() {
        noSleep.disable();
        window.location.href = "/index.aspx";
    }

    function init() {
        noSleep = new NoSleep();
        noSleep.disable();

        document.addEventListener('click', function enableNoSleep() {
            document.removeEventListener('click', enableNoSleep, false);
            noSleep.enable();
        }, false);

        lobbyClient = new LobbyAPI("/API/LobbyAPI.asmx");
        var IFramePage = document.getElementById("GameIFramePage");

        IFramePage.src = "/OpenGame.aspx?SID=" + SID + "&Lang=" + Lang + "&CurrencyType=" + CurrencyType + "&GameBrand=" + gameBrand + "&GameName=" + gameName + "&HomeUrl=" + "<%=EWinWeb.CasinoWorldUrl%>/CloseGame.aspx";;

        window.setInterval(function () {
            var guid = Math.uuid();

            lobbyClient.KeepSID(SID, guid, function (success, o) {
                if (success == true) {
                    if (o.Result == 0) {

                    } else {

                    }
                }
            });
        }, 10000);
    }

    window.onload = init;
</script>
<body>
    <div class="divGameWrapperMobile">
        <div class="divGameFrameMobile"> 
            <iframe style="height: 100%; width: 100%; background-color: black" id="GameIFramePage"></iframe>
        </div>
        <div class="menu-bar">
            <button class="btn btn-game-close" onclick="GoBack()">
                <i class="icon icon-mask icon-error"></i>
            </button>
        </div>
    </div>   
</body>
</html>
