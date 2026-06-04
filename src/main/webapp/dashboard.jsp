<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="es">
<!-- Sentencia Java para verificar si el usuario se encuentra en sesion, sino se manda al login-->
<%
    if(session.getAttribute("usuarioLogueado")==null){
        response.sendRedirect("index.jsp");
        return;
    }
%>
<head>
    <base href="<%= request.getContextPath() %>/">
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>SmartParking - Dashboard</title>

    <script src="https://use.fontawesome.com/releases/v6.3.0/js/all.js" crossorigin="anonymous"></script>
    <link href="https://fonts.googleapis.com/css?family=Montserrat:400,700" rel="stylesheet" type="text/css" />
    <link href="https://fonts.googleapis.com/css?family=Roboto+Slab:400,100,300,700" rel="stylesheet" type="text/css" />

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet" />

    <link href="css/styles.css" rel="stylesheet" />
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/ol@v10.9.0/ol.css">
    <link rel="stylesheet" href="css/dashboard.css?v=3">
</head>
<body>
<div class="contenedor-dashboard">

    <div class="panel-opciones">
        <div class="header-panel mb-4">
            <div class="d-flex justify-content-between align-items-center mb-2">
                <h2 class="tarjeta m-0">SMARTPARKING</h2>

                <a href="#" class="btn btn-primary rounded-circle" title="Mi Perfil" style="width: 42px; height: 42px; display: flex; align-items: center; justify-content: center; border-width: 2px;">
                    <i class="fas fa-user"></i>
                </a>
            </div>
            <p class="subtitulo">Gestiona tus reservaciones de estacionamiento en tiempo real</p>
        </div>

        <div class="menu-acciones" id="menu-principal">
            <h5 class="fw-bold mb-3" style="color: white; font-size: 0.95rem; text-transform: uppercase; letter-spacing: 1px;">Plazas Cercanas</h5>

            <button class="btn btn-primary text-start mb-2 fw-bold p-3" style="border-radius: 10px;">
                <i class="fas fa-map-marker-alt me-2" style="color: white;"></i> Centro Comercial Andamar
            </button>
            <button class="btn btn-primary text-start mb-2 fw-bold p-3" style="border-radius: 10px;">
                <i class="fas fa-map-marker-alt me-2" style="color: white;"></i> Plaza Las Américas
            </button>
            <button class="btn btn-primary text-start mb-2 fw-bold p-3" style="border-radius: 10px;">
                <i class="fas fa-map-marker-alt me-2" style="color: white;"></i> Centro Comercial El Dorado
            </button>
        </div>

        <div id="info-plaza-lateral" class="tarjeta_completa">
        </div>

        <div class="footer-panel mt-auto pt-3">
            <a href="index.jsp" class="btn btn-danger w-100 fw-bold py-2"><i class="fas fa-sign-out-alt me-2"></i> Cerrar Sesión</a>
        </div>
    </div>

    <div class="panel-mapa">
        <div id="map"></div>

    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/ol@v10.9.0/dist/ol.js"></script>
<script type="module" src="js/mapa/main.js"></script>
</body>
</html>