<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>SmartParking - Iniciar Sesión</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link rel="stylesheet" href="css/registro.css?v=2">
</head>
<body>

    <nav class="navbar">
        <div class="logo">
            SmartParking
        </div>
        <div>
            <a href="index.jsp" class="btn btn-primary text-uppercase fw-bold">Volver a Inicio</a>
        </div>
    </nav>
    <div class="contenedor-auth">
        <div class="tarjeta-auth">
            <h2>Crear una cuenta</h2>
            <p>Ingresa tus datos para comenzar a reservar plazas.</p>

            <%
                String errorReg = request.getParameter("error");
                if (errorReg != null) {
                    String mensajeError = "Error al procesar el registro.";
                    if (errorReg.equals("UsuarioExiste")) mensajeError = "El correo electrónico ya está registrado.";
                    if (errorReg.equals("ErrorGuardado")) mensajeError = "No se pudieron guardar los datos. Inténtalo más tarde.";
            %>
            <div class="CSSError">
                <%= mensajeError %>
            </div>
            <%
                }
            %>

            <form id="formRegistro" action="RegistroServlet" method="POST" class="formulario">
                <div class="grupo-input">
                    <label for="nombre">Nombre Completo</label>
                    <input type="text" id="nombre" name="nombre" placeholder="Ej. Eduardo Arévalo" required>
                </div>
                <div class="grupo-input">
                    <label for="email">Correo Electrónico</label>
                    <input type="email" id="email" name="email" placeholder="tu@correo.com" required>
                </div>
                <div class="grupo-input">
                    <label for="password">Contraseña</label>
                    <input type="password" id="password" name="password" placeholder="••••••••" required>
                </div>
                <button type="submit" class="btn-entrar">Registrarse</button>
            </form>
            <p class="auth-footer">¿Ya tienes cuenta? <a href="login.jsp">Inicia sesión aquí</a></p>
        </div>
    </div>
</body>
</html>