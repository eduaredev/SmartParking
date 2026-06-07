<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="modelos.Usuario" %>
<%
    Usuario usuarioActual = (Usuario) session.getAttribute("usuarioLogueado");
    if(usuarioActual == null){
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <base href="<%= request.getContextPath() %>/">
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>SmartParking - Mis Vehículos</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet" />
    <script src="https://use.fontawesome.com/releases/v6.3.0/js/all.js" crossorigin="anonymous"></script>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="css/perfil.css">
</head>
<body>

<nav class="navbar d-flex justify-content-between align-items-center navbar-perfil">
    <div class="navbar-logo"> SmartParking </div>
    <a href="dashboard.jsp" class="btn btn-warning fw-bold" style="border-radius: 8px;">
        <i class="fas fa-save me-2"></i> Guardar y Volver
    </a>
</nav>

<div class="container mt-5 mb-5">
    <div class="row">
        <div class="col-md-3 mb-4">
            <div class="card border-0 shadow-sm rounded-4">
                <div class="card-body p-3">
                    <div class="text-center mb-4 mt-2">
                        <div class="rounded-circle bg-secondary text-white d-inline-flex justify-content-center align-items-center foto-perfil-placeholder">
                            <i class="fas fa-user"></i>
                        </div>
                        <h5 class="mt-3 fw-bold">Mi Cuenta</h5>
                    </div>
                    <div class="nav flex-column nav-pills">
                        <a href="perfil.jsp" class="nav-link text-start text-dark"><i class="fas fa-id-card me-2"></i> Editar Perfil</a>
                        <a href="vehiculo.jsp" class="nav-link active text-start"><i class="fas fa-car me-2"></i> Mis Vehículos</a>
                        <a href="pagos.jsp" class="nav-link text-start text-dark"><i class="fas fa-credit-card me-2"></i> Métodos de Pago</a>
                        <a href="HistorialServlet" class="nav-link text-start text-dark"><i class="fas fa-history me-2"></i> Historial</a>
                    </div>
                </div>
            </div>
        </div>

        <div class="col-md-9">
            <div class="card border-0 shadow-sm rounded-4">
                <div class="card-body p-4">
                    <div class="d-flex justify-content-between align-items-center mb-4">
                        <h4 class="fw-bold mb-0">Mis Vehículos</h4>
                        <button class="btn btn-sm btn-outline-dark" data-bs-toggle="modal" data-bs-target="#modalAgregarVehiculo">
                            <i class="fas fa-plus"></i> Agregar Vehículo
                        </button>
                    </div>
                    <p class="text-muted small">Selecciona el vehículo que usarás para tu próxima reserva. Solo puedes tener un vehículo activo a la vez.</p>

                    <div class="row" id="contenedor-vehiculos">
                        <%
                            java.util.List<modelos.Vehiculos> listaVehiculos = usuarioActual.getVehiculos();
                            if(listaVehiculos != null && !listaVehiculos.isEmpty()) {
                                for(modelos.Vehiculos v : listaVehiculos) {
                                    String estadoActivo = v.isActivo() ? "activo" : "";
                                    String claseBadge = v.isActivo() ? "bg-success" : "bg-light text-dark border";
                                    String textoBadge = v.isActivo() ? "ACTIVO" : "OFF";
                                    String claseBoton = v.isActivo() ? "btn-success" : "btn-outline-dark";
                                    String textoBoton = v.isActivo() ? "Vehículo Seleccionado" : "Usar para Reserva";
                                    String disableAttr = v.isActivo() ? "disabled" : "";

                                    String colorTipo = "bg-secondary";
                                    if("CAMIONETA".equals(v.getTipo().name())) colorTipo = "bg-danger";
                                    if("MOTO".equals(v.getTipo().name())) colorTipo = "bg-success";
                        %>
                        <div class="col-md-6 mb-3">
                            <div class="card vehiculo-card p-3 rounded-3 <%= estadoActivo %>" id="<%= v.getIdvehiculo() %>">
                                <div class="d-flex justify-content-between align-items-start">
                                    <div>
                                        <h5 class="fw-bold mb-1"><%= v.getMarca() %> <%= v.getModelo() %></h5>
                                        <p class="text-muted mb-2">Placas: <strong class="text-dark"><%= v.getPlaca() %></strong> | <%= v.getColor() %></p>
                                        <span class="badge <%= colorTipo %>"><%= v.getTipo().name() %></span>
                                    </div>
                                    <span class="badge badge-estado <%= claseBadge %>" id="badge-<%= v.getIdvehiculo() %>"><%= textoBadge %></span>
                                </div>
                                <button class="btn btn-sm w-100 mt-3 btn-seleccionar <%= claseBoton %>" onclick="seleccionarVehiculo('<%= v.getIdvehiculo() %>')" <%= disableAttr %>><%= textoBoton %></button>
                            </div>
                        </div>
                        <%
                            }
                        } else {
                        %>
                        <div class="col-12 text-center py-4">
                            <i class="fas fa-car-side fs-1 text-muted mb-3"></i>
                            <h6 class="text-muted">Aún no tienes vehículos registrados.</h6>
                        </div>
                        <% } %>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<div class="modal fade" id="modalAgregarVehiculo" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content rounded-4 border-0 shadow">
            <div class="modal-header bg-dark text-white rounded-top-4">
                <h5 class="modal-title fw-bold"><i class="fas fa-car me-2"></i> Nuevo Vehículo</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>

            <form action="VehiculoServlet" method="POST">
                <input type="hidden" name="accion" value="agregar">
                <div class="modal-body p-4">
                    <div class="row">
                        <div class="col-6 mb-3">
                            <label class="form-label fw-bold small">Placas</label>
                            <input type="text" name="placa" class="form-control text-uppercase" placeholder="ABC-123-A" required>
                        </div>
                        <div class="col-6 mb-3">
                            <label class="form-label fw-bold small">Tipo de Vehículo</label>
                            <select name="tipo" class="form-select" required>
                                <option value="COCHE">Coche Normal</option>
                                <option value="CAMIONETA">Camioneta</option>
                                <option value="MOTO">Moto</option>
                            </select>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-6 mb-3">
                            <label class="form-label fw-bold small">Marca</label>
                            <input type="text" name="marca" class="form-control" placeholder="Ej. Honda" required>
                        </div>
                        <div class="col-6 mb-3">
                            <label class="form-label fw-bold small">Modelo</label>
                            <input type="text" name="modelo" class="form-control" placeholder="Ej. Civic" required>
                        </div>
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-bold small">Color</label>
                        <input type="text" name="color" class="form-control" placeholder="Ej. Plata" required>
                    </div>
                </div>
                <div class="modal-footer border-0 pb-4 px-4">
                    <button type="button" class="btn btn-light" data-bs-dismiss="modal">Cancelar</button>
                    <button type="submit" class="btn btn-warning fw-bold">Guardar Vehículo</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>

<script>
    function seleccionarVehiculo(idVehiculoSeleccionado) {
        const datos = new URLSearchParams();
        datos.append("accion", "seleccionar");
        datos.append("idVehiculo", idVehiculoSeleccionado);

        fetch("VehiculoServlet", {
            method: "POST",
            body: datos,
            headers: { "Content-Type": "application/x-www-form-urlencoded" }
        })
            .then(res => res.json())
            .then(data => {
                if (data.status === "success") {
                    const todasLasCards = document.querySelectorAll('.vehiculo-card');
                    todasLasCards.forEach(card => {
                        card.classList.remove('activo');
                        const badge = card.querySelector('.badge-estado');
                        badge.className = 'badge bg-light text-dark border badge-estado';
                        badge.innerText = 'OFF';
                        const boton = card.querySelector('.btn-seleccionar');
                        boton.className = 'btn btn-sm btn-outline-dark w-100 mt-3 btn-seleccionar';
                        boton.innerText = 'Usar para Reserva';
                        boton.disabled = false;
                    });

                    const cardSeleccionada = document.getElementById(idVehiculoSeleccionado);
                    cardSeleccionada.classList.add('activo');
                    const badgeActivo = cardSeleccionada.querySelector('.badge-estado');
                    badgeActivo.className = 'badge bg-success badge-estado';
                    badgeActivo.innerText = 'ACTIVO';
                    const botonActivo = cardSeleccionada.querySelector('.btn-seleccionar');
                    botonActivo.className = 'btn btn-sm btn-success w-100 mt-3 btn-seleccionar';
                    botonActivo.innerText = 'Vehículo Seleccionado';
                    botonActivo.disabled = true;
                } else {
                    alert("Hubo un error al cambiar el vehículo en la base de datos.");
                }
            })
            .catch(error => console.error("Error:", error));
    }
</script>
</body>
</html>