<%@ Page Language="C#" %>
<%
    string ErrMsg = string.Empty;

    if (string.IsNullOrEmpty(Request["ErrMsg"]) == false)
        ErrMsg = Request["ErrMsg"];

%>
<!DOCTYPE html>


<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title></title>
</head>
<script >
    var k = "<%=ErrMsg%>";
    function init() {
        alert(k);
    }
    window.onload = init();
</script>
<body>
    <form id="form1" runat="server">
        <div>
            <h1 id="errmsg"></h1>
        </div>
    </form>
</body>
</html>
