<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="es">
<!-- Sentencia Java para verificar si el usuario se encuentra en sesion, sino se manda al login-->
<%
    if(session.getAttribute("usuario_uid")==null){
        response.sendRedirect("login.jsp");
        return;
    }
%>
<head>
    <meta charset="UTF-8">
        <title>Dashboard</title>
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="css/dashboard.css">
</head>
<body>
    <div class="main">
        <a href="http:localhost:5000/mapa" class="btn-python">
            Abrir Mapa 3D
        </a>
    </div>
<body>
</html>