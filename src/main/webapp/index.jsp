<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <base href="<%= request.getContextPath() %>/">

    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />
    <meta name="description" content="Encuentra y reserva tu lugar de estacionamiento con SmartParking." />
    <title>SMARTPARKING - Inicio</title>

    <link rel="icon" type="image/x-icon" href="assets/favicon.ico" />
    <script src="https://use.fontawesome.com/releases/v6.3.0/js/all.js" crossorigin="anonymous"></script>
    <link href="https://fonts.googleapis.com/css?family=Montserrat:400,700" rel="stylesheet" type="text/css" />
    <link href="https://fonts.googleapis.com/css?family=Roboto+Slab:400,100,300,700" rel="stylesheet" type="text/css" />
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link href="css/styles.css" rel="stylesheet" />
</head>

<body id="page-top">

<nav class="navbar navbar-expand-lg navbar-dark bg-dark fixed-top" id="mainNav">
    <div class="container-fluid px-4">
        <a class="navbar-brand" href="#page-top">SmartParking</a>

        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarResponsive" aria-controls="navbarResponsive" aria-expanded="false" aria-label="Toggle navigation">
            Menú
            <i class="fas fa-bars ms-1"></i>
        </button>
        <div class="collapse navbar-collapse" id="navbarResponsive">
            <ul class="navbar-nav text-uppercase ms-auto py-4 py-lg-0">
                <li class="nav-item"><a class="nav-link" href="#services">Servicios</a></li>
                <li class="nav-item"><a class="nav-link" href="#portfolio">Nuestras Plazas</a></li>

                <li class="nav-item">
                    <a class="btn btn-login text-uppercase fw-bold" href="login.jsp">Iniciar Sesión</a>
                </li>
                <li class="nav-item">
                    <a class="btn btn-primary text-uppercase fw-bold" href="registro.jsp">Registrarse</a>
                </li>
            </ul>
        </div>
    </div>
</nav>

<header class="masthead">
    <div class="container">
        <div class="masthead-subheading">¡ BIENVENIDO !</div>
        <div class="masthead-heading text-uppercase">Reserva y disfruta tu lugar</div>
        <a class="btn btn-primary btn-xl text-uppercase" href="login.jsp">Comenzar Ahora</a>
    </div>
</header>

<section class="page-section" id="services">
    <div class="container">
        <div class="text-center">
            <h2 class="section-heading text-uppercase">Nuestros Servicios</h2>
            <h3 class="section-subheading text-muted">La mejor tecnología para tu comodidad.</h3>
        </div>
        <div class="row text-center">
            <div class="col-md-4">
                    <span class="fa-stack fa-4x">
                        <i class="fas fa-circle fa-stack-2x text-primary"></i>
                        <i class="fas fa-map-marked-alt fa-stack-1x fa-inverse"></i>
                    </span>
                <h4 class="my-3">Rutas en Tiempo Real</h4>
                <p class="text-muted">Encuentra la plaza más cercana y deja que te guiemos hasta tu lugar exacto de estacionamiento.</p>
            </div>
            <div class="col-md-4">
                    <span class="fa-stack fa-4x">
                        <i class="fas fa-circle fa-stack-2x text-primary"></i>
                        <i class="fas fa-clock fa-stack-1x fa-inverse"></i>
                    </span>
                <h4 class="my-3">Ahorro de Tiempo</h4>
                <p class="text-muted">Evita dar vueltas buscando lugar. Reserva desde la aplicación antes de salir de casa.</p>
            </div>
            <div class="col-md-4">
                    <span class="fa-stack fa-4x">
                        <i class="fas fa-circle fa-stack-2x text-primary"></i>
                        <i class="fas fa-shield-alt fa-stack-1x"></i>
                    </span>
                <h4 class="my-3">Seguridad Total</h4>
                <p class="text-muted">Mantén tu vehículo en plazas verificadas y gestiona tus pagos de forma segura.</p>
            </div>
        </div>
    </div>
</section>

<section class="page-section bg-light" id="portfolio">
    <div class="container">
        <div class="text-center">
            <h2 class="section-heading text-uppercase">Nuestras Plazas</h2>
            <h3 class="section-subheading text-muted">Estacionamientos disponibles en la red SmartParking.</h3>
        </div>
        <div class="row">
            <div class="col-lg-4 col-sm-6 mb-4">
                <div class="portfolio-item shadow-sm rounded bg-white">
                    <img class="img-fluid rounded-top" src="assets/img/portfolio/Andamar.jpg" alt="Andamar" style="width: 100%; object-fit: cover; height: 250px;" />
                    <div class="portfolio-caption p-4 text-center">
                        <div class="portfolio-caption-heading fw-bold" style="font-size: 1.2rem;">Centro Comercial Andamar</div>
                        <div class="portfolio-caption-subheading text-muted">Boca del Río</div>
                    </div>
                </div>
            </div>

            <div class="col-lg-4 col-sm-6 mb-4">
                <div class="portfolio-item shadow-sm rounded bg-white">
                    <img class="img-fluid rounded-top" src="assets/img/portfolio/Americas.png" alt="Américas" style="width: 100%; object-fit: cover; height: 250px;" />
                    <div class="portfolio-caption p-4 text-center">
                        <div class="portfolio-caption-heading fw-bold" style="font-size: 1.2rem;">Plaza Las Américas</div>
                        <div class="portfolio-caption-subheading text-muted">Boca del Río</div>
                    </div>
                </div>
            </div>

            <div class="col-lg-4 col-sm-6 mb-4">
                <div class="portfolio-item shadow-sm rounded bg-white">
                    <img class="img-fluid rounded-top" src="assets/img/portfolio/Dorado.png" alt="El Dorado" style="width: 100%; object-fit: cover; height: 250px;" />
                    <div class="portfolio-caption p-4 text-center">
                        <div class="portfolio-caption-heading fw-bold" style="font-size: 1.2rem;">Centro Comercial El Dorado</div>
                        <div class="portfolio-caption-subheading text-muted">Riviera Veracruzana</div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</section>

<footer class="footer py-4">
    <div class="container">
        <div class="row align-items-center">
            <div class="col-lg-4 text-lg-start">Copyright &copy; SmartParking 2026</div>
            <div class="col-lg-4 my-3 my-lg-0">
                <a class="btn btn-dark btn-social mx-2" href="#!" aria-label="Twitter"><i class="fab fa-twitter"></i></a>
                <a class="btn btn-dark btn-social mx-2" href="#!" aria-label="Facebook"><i class="fab fa-facebook-f"></i></a>
                <a class="btn btn-dark btn-social mx-2" href="#!" aria-label="LinkedIn"><i class="fab fa-linkedin-in"></i></a>
            </div>
            <div class="col-lg-4 text-lg-end">
                <a class="link-dark text-decoration-none me-3" href="#!">Políticas de Privacidad</a>
                <a class="link-dark text-decoration-none" href="#!">Términos de Uso</a>
            </div>
        </div>
    </div>
</footer>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="js/scripts.js"></script>
</body>
</html>