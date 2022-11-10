<%@ Page Language="C#" %>

<%

    RedisCache.SessionContext.SIDInfo SI;
    string SID = Request["SID"];
    string Event = Request["event"];

    SI = RedisCache.SessionContext.GetSIDInfo(SID);

    if (SI != null && !string.IsNullOrEmpty(SI.EWinSID)) {
       Response.Redirect("https://servicebooongo.com/bngevent/event?event="+Event+"&lang=jp&currency=JPY&project=kingkey&player_token=OCOIN_"+SI.EWinSID);
    } else {
       Response.Redirect("https://servicebooongo.com/bngevent/event?event="+Event+"&lang=jp&currency=JPY&project=kingkey");
    }
%>
<!doctype html>
<html>
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Lucky Sprite</title>
</head>

<body>
    <div class="loader-container">
        <div class="loader-box">
            <div class="loader-spinner">
                <div></div>
            </div>
            <div class="loader-text"></div>
        </div>
        <div class="loader-backdrop"></div>
    </div>
</body>
</html>
