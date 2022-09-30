<%@ Page Language="C#" %>

<%
    string EwinCallBackUrl;
    if ( CodingControl.GetIsHttps())
    {
        EwinCallBackUrl =  "https://" + Request.Url.Authority + "/RefreshParent.aspx?index.aspx";
    }
    else {
         EwinCallBackUrl = "http://" + Request.Url.Authority + "/RefreshParent.aspx?index.aspx";
    }
      
    Response.Write(EwinCallBackUrl);
    Response.Flush();
    Response.End();
%>
<!doctype html>
<html>
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Maharaja</title>


</head>

<%--<script src="Scripts/OutSrc/lib/jquery/jquery.min.js"></script>
<script src="Scripts/OutSrc/lib/bootstrap/js/bootstrap.bundle.min.js"></script>
<script src="Scripts/OutSrc/js/script.js"></script>--%>
<script src="Scripts/jquery-3.3.1.min.js"></script>
<script type="text/javascript" src="/Scripts/Common.js"></script>
<script type="text/javascript" src="/Scripts/UIControl.js"></script>
<script type="text/javascript" src="/Scripts/MultiLanguage.js"></script>
<script type="text/javascript" src="/Scripts/libphonenumber.js"></script>
<script type="text/javascript" src="/Scripts/fingerprint.js"></script>

<body>
 

</body>
</html>
