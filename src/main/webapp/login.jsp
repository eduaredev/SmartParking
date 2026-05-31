<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>SmartParking - Iniciar Sesión</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link rel="stylesheet" href="css/login.css?v=2">
</head>
<body class="bg-gris">

    <nav class="navbar">
        <div class="logo">
            SmartParking
        </div>
        <div class="nav-actions">
            <a href="index.jsp" class="btn btn-primary text-uppercase fw-bold">Volver al Inicio</a>
        </div>
    </nav>

    <div class="contenedor-auth">
        <div class="tarjeta-auth">
            <h2>¡Hola de nuevo!</h2>
            <p>Ingresa tus credenciales para acceder a tu panel.</p>

            <%
                String mensaje = request.getParameter("mensaje");
                if (mensaje != null && mensaje.equals("RegistroExitoso")) {
            %>
            <div class="CSSExito">
                ¡Cuenta creada con éxito! Por favor, inicia sesión.
            </div>
            <%
                }
            %>

            <%
                // Aqui declaramos la variable error que le puse en el LoginServlet, para poder validar con las demas variables que tambien
                // se declararon en el LoginServlet en el response.sendRedirect("");
                String error = request.getParameter("error");
                if(error != null){
                    String mensajeError = "Ocurrio un error";
                    if(error.equals("CredencialesInvalidas")) mensajeError = "Correo o contraseña incorrectos";
                    if(error.equals("TokenInvalido")) mensajeError = "Error de autenticación de Google";
                    if(error.equals("DatosIncompletos")) mensajeError = "Complete todos los campos";

            %>
                <div class="CSSError">
                    <%= mensajeError %>
                </div>
            <%
                }
            %>

            <form id="formLogin" action="LoginServlet" method="POST" class="formulario">

                <div class="grupo-input">
                    <label for="email">Correo Electrónico</label>
                    <input type="email" id="email" name="email" placeholder="tu@correo.com" required>
                </div>

                <div class="grupo-input">
                    <label for="password">Contraseña</label>
                    <input type="password" id="password" name="password" placeholder="••••••••" required>
                </div>

                <button type="submit" class="btn-entrar">Iniciar Sesión</button>
            </form>

            <div class='separador'>
                <span style="background: white; padding: 0 10px; position: relative; z-index: 2; font-size: 0.9rem;">---- O ingresa con ----</span>
            </div>

            <button id="btnGoogle" type="button" class="btn-google">
                <img src="https://developers.google.com/identity/images/g-logo.png" alt="Google" style="width: 20px;">
                Continuar con Google
            </button>

            <p class="auth-footer">¿Aún no tienes cuenta? <a href="registro.jsp">Regístrate aquí</a></p>
        </div>
    </div>

        <script type="module" src="js/env.js"></script>
        <script type="module" src="js/login.js"></script>
</body>
</html>