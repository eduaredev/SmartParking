<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>SmartParking - Crear Cuenta</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="css/registro.css">
</head>
<body class="bg-gris">
    <nav class="navbar">
        <div class="logo">
            <img src="img/LogoSmartparking.jpg" alt="Logo SmartParking" class="logo-img">
            SmartParking
        </div>
        <div class="nav-actions">
            <a href="index.jsp" class="link-login">Volver a Inicio</a>
        </div>
    </nav>
    <div class="contenedor-auth">
        <div class="tarjeta-auth">
            <h2>Crear una cuenta</h2>
            <p>Ingresa tus datos para comenzar a reservar plazas.</p>
            <form id="formRegistro" class="formulario">
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
                <button type="submit" class="btn-naranja btn-block">Registrarse</button>
            </form>
            <p class="auth-footer">¿Ya tienes cuenta? <a href="login.jsp">Inicia sesión aquí</a></p>
        </div>
    </div>
    <script type="module" src="js/env.js"></script>
    <script type="module" src="js/registro.js"></script>
</body>
</html>