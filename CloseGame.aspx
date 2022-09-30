<%@ Page Language="C#"%>

<!DOCTYPE html>
<script>
      function getOS() {
        var os = function () {
            var ua = navigator.userAgent,
                isWindowsPhone = /(?:Windows Phone)/.test(ua),
                isSymbian = /(?:SymbianOS)/.test(ua) || isWindowsPhone,
                isAndroid = /(?:Android)/.test(ua),
                isFireFox = /(?:Firefox)/.test(ua),
                isChrome = /(?:Chrome|CriOS)/.test(ua),
                isTablet = /(?:iPad|PlayBook)/.test(ua) || (isAndroid && !/(?:Mobile)/.test(ua)) || (isFireFox && /(?:Tablet)/.test(ua)),
                isPhone = /(?:iPhone)/.test(ua) && !isTablet,
                isPc = !isPhone && !isAndroid && !isSymbian;
            return {
                isTablet: isTablet,
                isPhone: isPhone,
                isAndroid: isAndroid,
                isPc: isPc
            };
        }();

        if (os.isAndroid || os.isTablet) {
            return 1;
        } else if (os.isPhone) {
            return 2;
        } else if (os.isPc) {
            return 0;
        }
    };

    function closeGame(DeviceType) {
        switch (DeviceType) {
            case 0:
                window.top.CloseGameFrame();
                break;
            case 1:
                window.location.href = "about:blank";
                window.close(); 
                break;
            case 2:
                document.getElementById("btnClose").click();
                break;
            default:
                window.top.CloseGameFrame();
                break;
        }
    }

    function init() {
        var DeviceType = getOS();

        closeGame(DeviceType);
    }

    window.onload = init;
</script>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            <button id="btnClose" style="display:none" onclick="window.close(); return false;"></button>
        </div>
    </form>
</body>
</html>
