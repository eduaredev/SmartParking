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
    <title>SmartParking - Métodos de Pago</title>
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
                        <a href="vehiculo.jsp" class="nav-link text-start text-dark"><i class="fas fa-car me-2"></i> Mis Vehículos</a>
                        <a href="pagos.jsp" class="nav-link active text-start"><i class="fas fa-credit-card me-2"></i> Métodos de Pago</a>
                        <a href="HistorialServlet" class="nav-link text-start text-dark"><i class="fas fa-history me-2"></i> Historial</a>
                    </div>
                </div>
            </div>
        </div>

        <div class="col-md-9">
            <div class="card border-0 shadow-sm rounded-4">
                <div class="card-body p-4">
                    <div class="d-flex justify-content-between align-items-center mb-4">
                        <h4 class="fw-bold mb-0">Métodos de Pago</h4>
                        <button class="btn btn-sm btn-outline-dark"><i class="fas fa-plus"></i> Añadir Tarjeta</button>
                    </div>
                    <div class="border rounded-3 p-3 d-flex align-items-center justify-content-between mb-2">
                        <div class="d-flex align-items-center">
                            <i class="fab fa-cc-visa text-primary fs-2 me-3"></i>
                            <div>
                                <h6 class="mb-0 fw-bold">Visa terminada en 4321</h6>
                                <small class="text-muted">Expira 12/28</small>
                            </div>
                        </div>
                        <button class="btn btn-sm btn-light text-danger"><i class="fas fa-trash"></i></button>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
