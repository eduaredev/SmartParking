<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <title>SmartParking - Tu Ticket</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet" />
    <script src="https://use.fontawesome.com/releases/v6.3.0/js/all.js" crossorigin="anonymous"></script>
    <link rel="stylesheet" href="css/ticket.css">
</head>
<body>
<div class="ticket-card">
    <h2 class="fw-bold mb-1">¡Reserva Exitosa!</h2>
    <p class="text-muted mb-4">Muestra este código al entrar o salir.</p>

    <div class="d-flex justify-content-between border-bottom pb-2 mb-2 text-start">
        <span class="text-muted">Plaza:</span> <strong class="text-dark">${plaza}</strong>
    </div>
    <div class="d-flex justify-content-between border-bottom pb-2 mb-2 text-start">
        <span class="text-muted">Cajón Asignado:</span> <strong class="text-success fs-5">${cajon}</strong>
    </div>
    <div class="d-flex justify-content-between border-bottom pb-2 mb-2 text-start">
        <span class="text-muted">Matrícula:</span> <strong class="text-dark">${matricula}</strong>
    </div>
    <div class="d-flex justify-content-between border-bottom pb-2 mb-2 text-start">
        <span class="text-muted">Tiempo:</span> <strong class="text-dark">${horas} Hora(s)</strong>
    </div>
    <div class="d-flex justify-content-between pb-2 mb-2 text-start">
        <span class="fw-bold text-dark fs-5">Total:</span> <strong class="text-danger fs-5">$${precio} MXN</strong>
    </div>

    <a href="LiberarServlet?id=${idReserva}&cajon=${cajon}" title="Simular Escaneo" style="text-decoration: none;">
        <div class="qr-container shadow-sm">
            <img src="https://api.qrserver.com/v1/create-qr-code/?size=180x180&data=Liberar-${cajon}" alt="Código QR">
        </div>
    </a>
</div>
</body>
</html>