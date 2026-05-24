<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="es">
<%
    // Si no hay usuario logueado, lo regresamos al login
    if(session.getAttribute("usuarioLogueado") == null){
        response.sendRedirect("login.jsp");
        return;
    }
%>
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>SMARTPARKING - MAPA</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/ol@v10.9.0/ol.css">
    <link rel="stylesheet" href="css/mapa.css">
</head>

<body>
    <a href="dashboard.jsp" style="position: absolute; top: 20px; left: 50px; z-index: 1000; background: #2155CF; color: white; padding: 10px 20px; text-decoration: none; border-radius: 8px; font-weight: bold; box-shadow: 0 4px 6px rgba(0,0,0,0.3);">
        &larr; Volver al Dashboard
    </a>
    <div id="map"></div>
    <script src="https://cdn.jsdelivr.net/npm/ol@v10.9.0/dist/ol.js"></script>
    <script type="module" src="js/mapa/main.js"></script>
</body>

</html>