<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="modelos.Usuario" %>
<%@ page import="java.util.List" %>
<%@ page import="org.bson.Document" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%
    Usuario usuarioActual = (Usuario) session.getAttribute("usuarioLogueado");
    if(usuarioActual == null){
        response.sendRedirect("login.jsp");
        return;
    }

    // Recibimos las reservas desde el Servlet
    List<Document> reservas = (List<Document>) request.getAttribute("misReservas");
    SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm");
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <base href="<%= request.getContextPath() %>/">
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>SmartParking - Historial</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet" />
    <script src="https://use.fontawesome.com/releases/v6.3.0/js/all.js" crossorigin="anonymous"></script>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="css/perfil.css">
</head>
<body>

<nav class="navbar d-flex justify-content-between align-items-center navbar-perfil">
    <div class="navbar-logo"> SmartParking </div>
    <a href="dashboard.jsp" class="btn btn-warning fw-bold" style="border-radius: 8px;">
        <i class="fas fa-arrow-left me-2"></i> Volver al Dashboard
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
                        <a href="VehiculoServlet" class="nav-link text-start text-dark"><i class="fas fa-car me-2"></i> Mis Vehículos</a>
                        <a href="pagos.jsp" class="nav-link text-start text-dark"><i class="fas fa-credit-card me-2"></i> Métodos de Pago</a>
                        <a href="HistorialServlet" class="nav-link active text-start"><i class="fas fa-history me-2"></i> Historial</a>
                    </div>
                </div>
            </div>
        </div>

        <div class="col-md-9">
            <div class="card border-0 shadow-sm rounded-4">
                <div class="card-body p-4">
                    <h4 class="fw-bold mb-4">Historial de Reservas</h4>
                    <div class="table-responsive">
                        <table class="table table-hover align-middle">
                            <thead class="table-light">
                            <tr>
                                <th>Fecha</th>
                                <th>Plaza</th>
                                <th>Cajón</th>
                                <th>Total</th>
                                <th>Estado</th>
                            </tr>
                            </thead>
                            <tbody>
                            <%
                                if(reservas == null || reservas.isEmpty()) {
                            %>
                            <tr>
                                <td colspan="5" class="text-center text-muted py-4">Aún no tienes reservas registradas.</td>
                            </tr>
                            <%
                            } else {
                                for(Document r : reservas) {
                                    String fechaStr = r.getDate("fecha_reserva") != null ? sdf.format(r.getDate("fecha_reserva")) : "N/A";
                            %>
                            <tr>
                                <td class="text-muted"><%= fechaStr %></td>
                                <td class="fw-bold"><%= r.getString("plaza_nombre") %></td>
                                <td><span class="badge bg-secondary" style="font-size: 0.85rem;"><%= r.getString("cajon") %></span></td>
                                <td class="text-danger fw-bold">$<%= r.getInteger("total") %></td>
                                <td><span class="badge bg-success"><%= r.getString("estado") %></span></td>
                            </tr>
                            <%
                                    }
                                }
                            %>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
</body>
</html>