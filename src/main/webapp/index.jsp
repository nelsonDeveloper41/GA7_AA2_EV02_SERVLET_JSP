<%-- 
    Document   : index
    Description: Página de inicio de la aplicación CartillasAceroWeb.
                 Presenta el sistema y redirige automáticamente a la gestión de proyectos.
    
    Evidencia: GA7-220501096-AA2-EV02
    Programa: Análisis y Desarrollo de Software - SENA
    
    Funcionalidades:
    - Página de bienvenida responsive con Bootstrap 5
    - Redirección automática después de 20 segundos
    - Enlaces directos a funcionalidades principales
    - Diseño moderno con iconografía Font Awesome
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    
    <!-- Metadatos académicos -->
    <meta name="author" content="[Nombre del Aprendiz] - SENA">
    <meta name="description" content="CartillasAceroWeb - Sistema de gestión de proyectos de construcción. Evidencia GA7-220501096-AA2-EV02">
    <meta name="keywords" content="SENA, Java Web, Servlets, JSP, CRUD, Proyectos, Construcción">
    
    <title>CartillasAceroWeb - Sistema de Gestión de Proyectos</title>
    
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    
    <!-- Font Awesome 6 -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <!-- CSS personalizado -->
    <link rel="stylesheet" href="css/estilos.css">
    
    <!-- Favicon -->
    <link rel="icon" type="image/x-icon" href="data:image/svg+xml,<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 100 100'><text y='.9em' font-size='90'>🏗️</text></svg>">
    
    <!-- Redirección automática después de 20 segundos -->
    <meta http-equiv="refresh" content="20;url=ProyectoServlet">
</head>

<body class="bg-light">
    <!-- Navbar principal -->
    <nav class="navbar navbar-expand-lg navbar-dark bg-primary">
        <div class="container">
            <a class="navbar-brand fw-bold" href="#">
                <i class="fas fa-building me-2"></i>
                CartillasAceroWeb
            </a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav ms-auto">
                    <li class="nav-item">
                        <a class="nav-link" href="ProyectoServlet">
                            <i class="fas fa-list me-1"></i>
                            Ver Proyectos
                        </a>
                    </li>
                </ul>
            </div>
        </div>
    </nav>

    <!-- Contenido principal -->
    <div class="container-fluid">
        <div class="row min-vh-100">
            <!-- Sección de bienvenida -->
            <div class="col-12 d-flex align-items-center justify-content-center">
                <div class="text-center">
                    
                    <!-- Hero Section -->
                    <div class="hero-section mb-5">
                        <div class="display-1 text-primary mb-4">
                            <i class="fas fa-hard-hat"></i>
                        </div>
                        <h1 class="display-4 fw-bold text-dark mb-3">
                            CartillasAceroWeb
                        </h1>
                        <p class="lead text-muted mb-4">
                            Sistema de gestión integral para proyectos de construcción con cartillas de acero
                        </p>
                        
                        <!-- Badge de tecnologías -->
                        <div class="mb-4">
                            <span class="badge bg-success me-2">
                                <i class="fab fa-java me-1"></i>Java Servlets
                            </span>
                            <span class="badge bg-info me-2">
                                <i class="fas fa-code me-1"></i>JSP
                            </span>
                            <span class="badge bg-warning text-dark me-2">
                                <i class="fas fa-database me-1"></i>MySQL
                            </span>
                            <span class="badge bg-secondary">
                                <i class="fas fa-layer-group me-1"></i>MVC
                            </span>
                        </div>
                    </div>

                    <!-- Contador de redirección -->
                    <div class="alert alert-info alert-countdown d-inline-block mb-4" role="alert">
                        <i class="fas fa-info-circle me-2"></i>
                        <strong>Redirigiendo automáticamente...</strong>
                        <br>
                        <small class="text-muted">
                            Serás redirigido a la gestión de proyectos en 
                            <span id="countdown" class="fw-bold text-primary">20</span> segundos
                        </small>
                    </div>

                    <!-- Botones de acción rápida -->
                    <div class="d-grid gap-2 d-md-block mb-5">
                        <a href="ProyectoServlet" class="btn btn-primary btn-lg px-4 me-md-2">
                            <i class="fas fa-list me-2"></i>
                            Ver Proyectos
                        </a>
                        <a href="ProyectoServlet?accion=nuevo" class="btn btn-success btn-lg px-4">
                            <i class="fas fa-plus me-2"></i>
                            Crear Proyecto
                        </a>
                    </div>

                    <!-- Características del sistema -->
                    <div class="row justify-content-center">
                        <div class="col-md-8">
                            <div class="row g-4">
                                <div class="col-md-4">
                                    <div class="card h-100 border-0 shadow-sm">
                                        <div class="card-body text-center">
                                            <div class="text-primary mb-3">
                                                <i class="fas fa-plus-circle fa-2x"></i>
                                            </div>
                                            <h5 class="card-title">Crear</h5>
                                            <p class="card-text text-muted">
                                                Registra nuevos proyectos de construcción con todos sus detalles
                                            </p>
                                        </div>
                                    </div>
                                </div>
                                
                                <div class="col-md-4">
                                    <div class="card h-100 border-0 shadow-sm">
                                        <div class="card-body text-center">
                                            <div class="text-success mb-3">
                                                <i class="fas fa-edit fa-2x"></i>
                                            </div>
                                            <h5 class="card-title">Gestionar</h5>
                                            <p class="card-text text-muted">
                                                Actualiza y administra la información de tus proyectos existentes
                                            </p>
                                        </div>
                                    </div>
                                </div>
                                
                                <div class="col-md-4">
                                    <div class="card h-100 border-0 shadow-sm">
                                        <div class="card-body text-center">
                                            <div class="text-info mb-3">
                                                <i class="fas fa-chart-line fa-2x"></i>
                                            </div>
                                            <h5 class="card-title">Monitorear</h5>
                                            <p class="card-text text-muted">
                                                Consulta el estado y avance de todos los proyectos en ejecución
                                            </p>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Footer -->
    <footer class="bg-dark text-light py-4 mt-auto">
        <div class="container">
            <div class="row">
                <div class="col-md-6">
                    <h6 class="fw-bold">
                        <i class="fas fa-graduation-cap me-2"></i>
                        Evidencia Académica
                    </h6>
                    <p class="mb-1">
                        <strong>Código:</strong> GA7-220501096-AA2-EV02
                    </p>
                    <p class="mb-1">
                        <strong>Título:</strong> Módulos de software codificados y probados
                    </p>
                    <p class="text-muted small">
                        Programa: Análisis y Desarrollo de Software - SENA
                    </p>
                </div>
                <div class="col-md-6 text-md-end">
                    <h6 class="fw-bold">
                        <i class="fas fa-code me-2"></i>
                        Tecnologías Implementadas
                    </h6>
                    <div class="d-flex flex-wrap justify-content-md-end gap-2">
                        <span class="badge bg-outline-light border">Java EE</span>
                        <span class="badge bg-outline-light border">Servlets</span>
                        <span class="badge bg-outline-light border">JSP</span>
                        <span class="badge bg-outline-light border">JDBC</span>
                        <span class="badge bg-outline-light border">MySQL</span>
                        <span class="badge bg-outline-light border">Bootstrap</span>
                    </div>
                    <p class="text-muted small mt-2">
                        <i class="fas fa-calendar me-1"></i>
                        ${pageContext.servletContext.contextPath} - <%= new java.util.Date().getYear() + 1900 %>
                    </p>
                </div>
            </div>
        </div>
    </footer>

    <!-- Bootstrap 5 JS Bundle -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    
    <!-- JavaScript personalizado -->
    <script src="js/scripts.js"></script>
    
    <!-- Script de contador regresivo -->
    <script>
        /**
         * Contador regresivo para la redirección automática
         * Mejora la experiencia de usuario mostrando el tiempo restante
         */
        document.addEventListener('DOMContentLoaded', function() {
            let seconds = 20;
            const countdownElement = document.getElementById('countdown');
            
            const countdownTimer = setInterval(function() {
                seconds--;
                if (countdownElement) {
                    countdownElement.textContent = seconds;
                }
                
                if (seconds <= 0) {
                    clearInterval(countdownTimer);
                    // Redirección manual como respaldo
                    window.location.href = 'ProyectoServlet';
                }
            }, 1000);
            
            // Añadir efecto de fade-in al cargar la página
            document.body.style.opacity = '0';
            document.body.style.transition = 'opacity 0.5s ease-in';
            setTimeout(function() {
                document.body.style.opacity = '1';
            }, 100);
        });
        
        /**
         * Manejo de errores de redirección
         */
        window.addEventListener('error', function(e) {
            console.warn('Error en la página de inicio:', e.message);
            // Intento de redirección alternativo
            setTimeout(function() {
                try {
                    window.location.href = 'ProyectoServlet';
                } catch (error) {
                    console.error('Error de redirección:', error);
                    // Mostrar mensaje de error al usuario
                    document.getElementById('countdown').innerHTML = 
                        '<a href="ProyectoServlet" class="text-decoration-none">Hacer clic aquí para continuar</a>';
                }
            }, 5000);
        });
    </script>
</body>
</html>