<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // Validación de sesión
    if(session.getAttribute("usuarioLogueado") == null){
        response.sendRedirect("login.jsp");
        return;
    }

    String idPlaza = request.getParameter("plaza");
    if(idPlaza == null) idPlaza = "Plaza Desconocida";
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <base href="<%= request.getContextPath() %>/">
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>SmartParking - Estacionamiento</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet" />
    <script src="https://use.fontawesome.com/releases/v6.3.0/js/all.js" crossorigin="anonymous"></script>
    <link href="https://fonts.googleapis.com/css?family=Montserrat:400,700" rel="stylesheet" type="text/css" />
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="css/estacionamiento.css">

    <script>
        // Si por alguna razón el Servlet no mandó los datos, usamos 'false' o 'NINGUNO' por seguridad
        window.USUARIO_ES_VIP = ${esVip != null ? esVip : false};
        window.USUARIO_ES_DISCAPACITADO = ${esDiscapacitado != null ? esDiscapacitado : false};
        window.TIPO_VEHICULO = "${tipoVehiculo != null ? tipoVehiculo : 'NINGUNO'}";

        // Coordenadas entrada plaza (Punto inicial para el A*)
        window.ORIGEN_X = 80.5;
        window.ORIGEN_Y = 262.5;

        window.CAJONES_OCUPADOS = ${cajonesOcupadosJs != null ? cajonesOcupadosJs : "[]"};
    </script>
</head>
<body>

<nav class="navbar d-flex justify-content-between align-items-center">
    <div class="logo"> SmartParking </div>
    <a href="dashboard.jsp" class="btn btn-back fw-bold" style="border-radius: 10px">
        <i class="fas fa-arrow-left me-2"></i> Volver a Plazas
    </a>
</nav>

<div class="container-fluid mt-4 px-4 mb-5">
    <div class="row">

        <div class="col-lg-4 col-md-5 mb-4">
            <div class="card shadow-sm border-0 d-flex flex-column panel-reserva" style="border-radius: 12px;">
                <div class="card-header bg-dark text-white text-center fw-bold py-3" style="border-top-left-radius: 12px; border-top-right-radius: 12px;">
                    <i class="fas fa-ticket-alt me-2"></i><strong class="titulo-plaza"><%= idPlaza %></strong>
                </div>

                <div class="card-body p-4 d-flex flex-column">
                    <p class="text-muted mb-3">Selecciona un lugar en el mapa o ingresa los datos de tu reserva.</p>

                    <div id="panel-vip" class="alert alert-warning border-0 shadow-sm fw-bold mb-3" style="display: none; font-size: 0.9rem; padding: 12px;">
                        <i class="fas fa-crown me-2"></i> Eres VIP. Haz clic directo en el mapa para elegir tu cajón.
                    </div>

                    <div id="panel-estandar" class="card bg-light border-0 mb-3 shadow-sm" style="display: none;">
                        <div class="card-body p-3">
                            <label class="form-label fw-bold text-danger" style="font-size: 0.9rem;">
                                <i class="fas fa-map-marker-alt me-1"></i> ¿A dónde te diriges?
                            </label>
                            <select id="select-tienda" class="form-select form-select-sm mb-2 fw-bold">
                                <option value="140,9">Baños</option>
                                <option value="615,9">Palacio de Hierro</option>
                                <option value="525,418">Entrada Plaza</option>
                                <option value="676,143">Querreve</option>
                            </select>
                            <button type="button" class="btn btn-dark w-100 fw-bold btn-sm" onclick="window.solicitarRutaEstandar()">Encontrar Lugar Óptimo</button>
                        </div>
                    </div>

                    <form action="ReservaServlet" method="POST" class="mt-2" onsubmit="return validarReserva()">
                        <input type="hidden" name="plaza" value="<%= idPlaza %>">
                        <div class="mb-3">
                            <label class="form-label fw-bold">Cajón Seleccionado</label>
                            <input type="text" class="form-control fw-bold text-success" id="cajon-seleccionado" name="cajon" placeholder="Esperando asignación..." readonly required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label fw-bold">Matrícula del Vehículo</label>
                            <input type="text" class="form-control text-uppercase" name="matricula" value="${placaVehiculo}" readonly>
                        </div>
                        <div class="mb-3">
                            <label class="form-label fw-bold">Tiempo Estimado</label>
                            <select class="form-select" name="horas">
                                <option value="1">1 Hora</option>
                                <option value="2">2 Horas</option>
                                <option value="3">3+ Horas</option>
                            </select>
                        </div>
                        <button type="submit" class="btn btn-warning w-100 fw-bold mt-2 shadow-sm">Confirmar Reserva</button>
                    </form>

                    <div class="mt-auto pt-4" style="border-top: 1px solid #eee;">
                        <h6 class="fw-bold mb-3 text-muted"><i class="fas fa-info-circle me-2"></i>Tipos de Cajones</h6>
                        <div class="d-flex flex-wrap gap-2" style="font-size: 0.85rem;">
                            <span class="badge" style="background-color: #b0bec5; color: #333; padding: 8px;">Coche Normal</span>
                            <span class="badge" style="background-color: #e74c3c; color: white; padding: 8px;">Camioneta</span>
                            <span class="badge" style="background-color: #2ecc71; color: #333; padding: 8px;">Moto</span>
                            <span class="badge" style="background-color: #3498db; color: white; padding: 8px;">Discapacitado</span>
                            <span class="badge" style="background-color: #f1c40f; color: #333; padding: 8px;">VIP</span>
                            <br>
                            <div style="flex-basis: 100%; height: 0;"></div> <!-- Salto de linea que no es un salto de linea solamente es para ocupar el resto del espacio sobre la box -->
                        </div>
                        <h6 class="fw-bold mb-3 text-muted"><i class="fas fa-info-circle me-2"></i>Entradas</h6>
                        <div class="d-flex flex-wrap gap-2" style="font-size: 0.85rem;">
                            <span class="badge" style="background-color: #F527E4; color: white; padding: 8px;">BAÑOS</span>
                            <span class="badge" style="background-color: red; color: white; padding: 8px;">PALACIO H</span>
                            <span class="badge" style="background-color: deepskyblue; color: #333; padding: 8px;">QUERREVE</span>
                            <span class="badge" style="background-color: mediumspringgreen; color: #333; padding: 8px;">ENTRADA PLAZA</span>
                        </div>
                    </div>

                </div>
            </div>
        </div>

        <div class="col-lg-8 col-md-7">
            <div class="contenedor-mapa mt-0">
                <object id="mapa-svg" type="image/svg+xml" data="assets/img/Mapa_SmartParking.svg">
                    Tu navegador no soporta archivos SVG.
                </object>
            </div>
        </div>

    </div>
</div>

<script src="js/estacionamiento.js"></script>
</body>
</html>