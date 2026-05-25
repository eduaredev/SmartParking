<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="es">
<!-- Sentencia Java para verificar si el usuario se encuentra en sesion, sino se manda al login-->
<%
    if(session.getAttribute("usuarioLogueado")==null){
        response.sendRedirect("login.jsp");
        return;
    }
%>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>SmartParking - Panel de Control</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/ol@v10.9.0/ol.css">
    <link rel="stylesheet" href="css/dashboard.css">
</head>
<body>
<div class="contenedor-dashboard">

    <div class="panel-opciones">
        <div class="header-panel">
            <div class="logo-dashboard">
                <h2>SmartParking</h2>
            </div>
        </div>

        <div class="menu-acciones">
            <a href="#" class="item-menu">Buscar Plazas</a>
            <a href="#" class="item-menu">Mis Reservas Activas</a>
            <a href="#" class="item-menu">Métodos de Pago</a>
            <a href="#" class="item-menu">Mi Perfil</a>
        </div>

        <div class="footer-panel">
            <a href="login.jsp" class="btn-cerrar-sesion">Cerrar Sesión</a>
        </div>
    </div>

    <div class="panel-mapa">

        <div class="contenedor-buscador">
            <input type="text" id="input-busqueda" placeholder="Buscar plaza o centro comercial..." />
            <button id="btn-buscar">🔍</button>
        </div>

        <div id="tarjeta" class="tarjeta_plaza">
            <a href="#" id="tarjeta_cerrar" class="boton_cerrar"> x </a>
            <div id="tarjeta_contenido"></div>
        </div>

        <div id="map"></div>

    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/ol@v10.9.0/dist/ol.js"></script>
<script type="module" src="js/mapa/main.js"></script>
</body>
</html>