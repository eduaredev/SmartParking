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
    <title>SmartParking - Mi Perfil</title>
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
                        <a href="perfil.jsp" class="nav-link active text-start"><i class="fas fa-id-card me-2"></i> Editar Perfil</a>
                        <a href="vehiculo.jsp" class="nav-link text-start text-dark"><i class="fas fa-car me-2"></i> Mis Vehículos</a>
                        <a href="pagos.jsp" class="nav-link text-start text-dark"><i class="fas fa-credit-card me-2"></i> Métodos de Pago</a>
                        <a href="HistorialServlet" class="nav-link text-start text-dark"><i class="fas fa-history me-2"></i> Historial</a>
                    </div>
                </div>
            </div>
        </div>

        <div class="col-md-9">
            <div class="card border-0 shadow-sm rounded-4">
                <div class="card-body p-4">
                    <h4 class="fw-bold mb-4">Información Personal</h4>
                    <form action="PerfilServlet" method="POST">
                        <div class="row mb-3">
                            <div class="col-md-6">
                                <label class="form-label text-muted">Nombre Completo</label>
                                <input type="text" name="nombre" class="form-control" value="<%= usuarioActual.getNombre() %>" required>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label text-muted">Correo Electrónico</label>
                                <input type="email" class="form-control" value="<%= usuarioActual.getEmail() %>" readonly style="background-color: #e9ecef;">
                            </div>
                        </div>
                        <div class="row mb-3">
                            <div class="col-md-6">
                                <label class="form-label text-muted">Teléfono</label>
                                <input type="tel" name="telefono" class="form-control" value="<%= usuarioActual.getTelefono() != null ? usuarioActual.getTelefono() : "" %>">
                            </div>
                        </div>
                        <div class="row mb-4 mt-2">
                            <div class="col-12">
                                <div class="form-check form-switch p-3 border rounded-3 bg-light d-flex align-items-center">
                                    <input class="form-check-input ms-0 me-3 mt-0 switch-accesibilidad" type="checkbox" role="switch" id="switchDiscapacidad" name="esDiscapacitado" <%= usuarioActual.isEsDiscapacitado() ? "checked" : "" %>>
                                    <label class="form-check-label d-flex flex-column" for="switchDiscapacidad">
                                        <span class="fw-bold text-dark">Requiero cajón para personas con discapacidad</span>
                                        <small class="text-muted">Al activar esta opción, el sistema priorizará la asignación de espacios azules exclusivos en tu reserva.</small>
                                    </label>
                                </div>
                            </div>
                        </div>
                        <div class="row mb-4 mt-3">
                            <div class="col-12">
                                <div class="p-3 border rounded-3 d-flex align-items-center shadow-sm" style="background-color: white;">
                                    <i class="fas fa-crown fs-1 me-3" style="color: #f1c40f;"></i>
                                    <div class="flex-grow-1">
                                        <span class="fw-bold text-dark d-block" style="font-size: 1.1rem;">Membresía VIP</span>
                                        <small class="text-muted">Desbloquea el acceso a cualquier lugar del estacionamiento sin importar tu vehículo o ruta.</small>
                                    </div>
                                    <div class="form-check form-switch ms-3">
                                        <input class="form-check-input mt-0 switch-accesibilidad" type="checkbox" role="switch" id="switchVip" name="esVip" <%= usuarioActual.isEsVip() ? "checked" : "" %>>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="text-end">
                            <button type="submit" class="btn btn-dark fw-bold px-4">Actualizar Datos</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>