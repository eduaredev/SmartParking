<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Estacionamiento</title>
</head>
<body>
<%
    if(session.getAttribute("usuarioLogueado")==null){
        response.sendRedirect("login.jsp");
        return;
    }
%>


</body>
</html>
