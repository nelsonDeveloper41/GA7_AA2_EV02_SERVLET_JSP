<%-- 
    Document   : formProyecto
    Author     : NELSON RODRIGUEZ
    Description: Formulario unificado para crear y editar proyectos de construcción.
                 Implementa validación HTML5, JavaScript y manejo de errores.
    
    Evidencia: GA7-220501096-AA2-EV02
    Programa: Análisis y Desarrollo de Software - SENA
    
    Funcionalidades:
    - Formulario unificado (crear/editar) con detección automática de modo
    - Validación HTML5 completa y JavaScript avanzado
    - Pre-llenado de datos en modo edición usando JSTL/EL
    - Diseño responsive con Bootstrap 5 y UX mejorada
    - Manejo de errores y mensajes informativos
    - Integración completa con ProyectoServlet
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="jakarta.tags.core" %>
<%@taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    
    <!-- Metadatos académicos -->
    <meta name="author" content="NELSON RODRIGUEZ - SENA">
    <meta name="description" content="Formulario de gestión de proyectos de construcción - CartillasAceroWeb">
    <meta name="keywords" content="SENA, Java Web, Servlets, JSP, CRUD, Formulario, Proyecto">
    
    <!-- Título dinámico según el modo (crear/editar) -->
    <title>
        <c:choose>
            <c:when test="${not empty proyecto}">
                Editar Proyecto - CartillasAceroWeb
            </c:when>
            <c:otherwise>
                Nuevo Proyecto - CartillasAceroWeb
            </c:otherwise>
        </c:choose>
    </title>
    
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    
    <!-- Font Awesome 6 -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <!-- CSS personalizado -->
    <link rel="stylesheet" href="css/estilos.css">
    
    <!-- Favicon -->
    <link rel="icon" type="image/x-icon" href="data:image/svg+xml,<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 100 100'><text y='.9em' font-size='90'>🏗️</text></svg>">
</head>

<body class="bg-light">
    <!-- Navbar principal -->
    <nav class="navbar navbar-expand-lg navbar-dark bg-primary shadow">
        <div class="container-fluid">
            <a class="navbar-brand fw-bold" href="index.jsp">
                <i class="fas fa-building me-2"></i>
                CartillasAceroWeb
            </a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav me-auto">
                    <li class="nav-item">
                        <a class="nav-link" href="ProyectoServlet">
                            <i class="fas fa-list me-1"></i>
                            Proyectos
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link active" href="#">
                            <i class="fas fa-edit me-1"></i>
                            <c:choose>
                                <c:when test="${not empty proyecto}">Editar</c:when>
                                <c:otherwise>Nuevo</c:otherwise>
                            </c:choose>
                        </a>
                    </li>
                </ul>
                <ul class="navbar-nav">
                    <li class="nav-item dropdown">
                        <a class="nav-link dropdown-toggle" href="#" role="button" data-bs-toggle="dropdown">
                            <i class="fas fa-user me-1"></i>
                            NELSON RODRIGUEZ
                        </a>
                        <ul class="dropdown-menu">
                            <li><a class="dropdown-item" href="#"><i class="fas fa-cog me-2"></i>Configuración</a></li>
                            <li><hr class="dropdown-divider"></li>
                            <li><a class="dropdown-item" href="#"><i class="fas fa-sign-out-alt me-2"></i>Cerrar Sesión</a></li>
                        </ul>
                    </li>
                </ul>
            </div>
        </div>
    </nav>

    <!-- Contenedor principal -->
    <div class="container py-4">
        
        <!-- Breadcrumb -->
        <nav aria-label="breadcrumb" class="mb-4">
            <ol class="breadcrumb">
                <li class="breadcrumb-item">
                    <a href="index.jsp" class="text-decoration-none">
                        <i class="fas fa-home"></i> Inicio
                    </a>
                </li>
                <li class="breadcrumb-item">
                    <a href="ProyectoServlet" class="text-decoration-none">
                        <i class="fas fa-list"></i> Proyectos
                    </a>
                </li>
                <li class="breadcrumb-item active" aria-current="page">
                    <i class="fas fa-edit"></i>
                    <c:choose>
                        <c:when test="${not empty proyecto}">Editar Proyecto</c:when>
                        <c:otherwise>Nuevo Proyecto</c:otherwise>
                    </c:choose>
                </li>
            </ol>
        </nav>

        <!-- Manejo de mensajes de éxito y error -->
        <c:if test="${not empty mensaje}">
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                <i class="fas fa-check-circle me-2"></i>
                <strong>¡Éxito!</strong> ${mensaje}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>
        
        <c:if test="${not empty error}">
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                <i class="fas fa-exclamation-triangle me-2"></i>
                <strong>Error:</strong> ${error}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <!-- Header de la página -->
        <div class="row mb-4">
            <div class="col-12">
                <div class="card border-0 shadow-sm">
                    <div class="card-body text-center">
                        <div class="mb-3">
                            <c:choose>
                                <c:when test="${not empty proyecto}">
                                    <i class="fas fa-edit fa-3x text-warning"></i>
                                    <h2 class="h3 mt-3 mb-1 text-dark">Editar Proyecto</h2>
                                    <p class="text-muted">
                                        Modifica la información del proyecto de construcción
                                        <strong>"${proyecto.nombreObra}"</strong>
                                    </p>
                                </c:when>
                                <c:otherwise>
                                    <i class="fas fa-plus-circle fa-3x text-success"></i>
                                    <h2 class="h3 mt-3 mb-1 text-dark">Nuevo Proyecto</h2>
                                    <p class="text-muted">
                                        Registra un nuevo proyecto de construcción en el sistema
                                    </p>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Formulario principal -->
        <div class="row justify-content-center">
            <div class="col-lg-8">
                <div class="card border-0 shadow">
                    <div class="card-header bg-primary text-white">
                        <h5 class="mb-0">
                            <i class="fas fa-building me-2"></i>
                            Información del Proyecto
                        </h5>
                    </div>
                    
                    <div class="card-body p-4">
                        <!-- Formulario unificado para crear/editar -->
                        <form id="formProyecto" method="POST" action="ProyectoServlet" novalidate>
                            
                            <!-- Campo hidden para el ID en modo edición -->
                            <c:if test="${not empty proyecto}">
                                <input type="hidden" name="id" value="${proyecto.id}">
                                <input type="hidden" name="accion" value="actualizar">
                            </c:if>
                            <c:if test="${empty proyecto}">
                                <input type="hidden" name="accion" value="crear">
                            </c:if>
                            
                            <!-- Sección: Información del Proyecto -->
                            <fieldset class="mb-4">
                                <legend class="h6 text-primary border-bottom pb-2 mb-3">
                                    <i class="fas fa-info-circle me-1"></i>
                                    Datos del Proyecto
                                </legend>
                                
                                <div class="row">
                                    <!-- Nombre de Obra -->
                                    <div class="col-md-6 mb-3">
                                        <label for="nombreObra" class="form-label fw-bold">
                                            <i class="fas fa-building text-primary me-1"></i>
                                            Nombre de la Obra <span class="text-danger">*</span>
                                        </label>
                                        <input type="text" 
                                               class="form-control" 
                                               id="nombreObra" 
                                               name="nombreObra" 
                                               value="${proyecto.nombreObra}"
                                               placeholder="Ej: Torre Empresarial San Martín"
                                               required 
                                               maxlength="200"
                                               pattern="[A-Za-zÀ-ÿ0-9\s\-\.\,]+"
                                               title="Solo letras, números, espacios y signos básicos de puntuación">
                                        <div class="invalid-feedback">
                                            Por favor, ingresa un nombre válido para la obra (máximo 200 caracteres).
                                        </div>
                                        <div class="form-text">
                                            <i class="fas fa-info-circle me-1"></i>
                                            Nombre descriptivo y único del proyecto de construcción
                                        </div>
                                    </div>
                                    
                                    <!-- Dirección de Obra -->
                                    <div class="col-md-6 mb-3">
                                        <label for="direccionObra" class="form-label fw-bold">
                                            <i class="fas fa-map-marker-alt text-danger me-1"></i>
                                            Dirección de la Obra <span class="text-danger">*</span>
                                        </label>
                                        <input type="text" 
                                               class="form-control" 
                                               id="direccionObra" 
                                               name="direccionObra" 
                                               value="${proyecto.direccionObra}"
                                               placeholder="Ej: Calle 100 #15-25, Bogotá D.C."
                                               required 
                                               maxlength="300"
                                               title="Dirección completa donde se ejecutará la obra">
                                        <div class="invalid-feedback">
                                            Por favor, ingresa la dirección completa de la obra (máximo 300 caracteres).
                                        </div>
                                        <div class="form-text">
                                            <i class="fas fa-map me-1"></i>
                                            Ubicación exacta donde se desarrollará el proyecto
                                        </div>
                                    </div>
                                </div>
                            </fieldset>
                            
                            <!-- Sección: Información del Cliente -->
                            <fieldset class="mb-4">
                                <legend class="h6 text-success border-bottom pb-2 mb-3">
                                    <i class="fas fa-user-tie me-1"></i>
                                    Datos del Cliente
                                </legend>
                                
                                <div class="row">
                                    <!-- NIT Cliente -->
                                    <div class="col-md-6 mb-3">
                                        <label for="nitCliente" class="form-label fw-bold">
                                            <i class="fas fa-id-card text-info me-1"></i>
                                            NIT del Cliente <span class="text-danger">*</span>
                                        </label>
                                        <input type="text" 
                                               class="form-control" 
                                               id="nitCliente" 
                                               name="nitCliente" 
                                               value="${proyecto.nitCliente}"
                                               placeholder="Ej: 900123456-7"
                                               required 
                                               maxlength="20"
                                               pattern="[0-9\-]+"
                                               title="Solo números y guiones (Ej: 123456789-0)">
                                        <div class="invalid-feedback">
                                            Por favor, ingresa un NIT válido (solo números y guiones).
                                        </div>
                                        <div class="form-text">
                                            <i class="fas fa-building me-1"></i>
                                            Número de Identificación Tributaria de la empresa cliente
                                        </div>
                                    </div>
                                    
                                    <!-- Nombre Cliente -->
                                    <div class="col-md-6 mb-3">
                                        <label for="nombreCliente" class="form-label fw-bold">
                                            <i class="fas fa-user-tie text-success me-1"></i>
                                            Nombre del Cliente <span class="text-danger">*</span>
                                        </label>
                                        <input type="text" 
                                               class="form-control" 
                                               id="nombreCliente" 
                                               name="nombreCliente" 
                                               value="${proyecto.nombreCliente}"
                                               placeholder="Ej: Constructora ABC S.A.S."
                                               required 
                                               maxlength="200"
                                               pattern="[A-Za-zÀ-ÿ0-9\s\-\.\,]+"
                                               title="Solo letras, números, espacios y signos básicos de puntuación">
                                        <div class="invalid-feedback">
                                            Por favor, ingresa el nombre completo del cliente (máximo 200 caracteres).
                                        </div>
                                        <div class="form-text">
                                            <i class="fas fa-handshake me-1"></i>
                                            Razón social o nombre completo de la empresa constructora
                                        </div>
                                    </div>
                                </div>
                            </fieldset>
                            
                            <!-- Sección: Información de Contacto -->
                            <fieldset class="mb-4">
                                <legend class="h6 text-warning border-bottom pb-2 mb-3">
                                    <i class="fas fa-address-book me-1"></i>
                                    Datos de Contacto <span class="text-muted">(Opcionales)</span>
                                </legend>
                                
                                <div class="row">
                                    <!-- Email Contacto -->
                                    <div class="col-md-6 mb-3">
                                        <label for="emailContacto" class="form-label fw-bold">
                                            <i class="fas fa-envelope text-primary me-1"></i>
                                            Email de Contacto
                                        </label>
                                        <input type="email" 
                                               class="form-control" 
                                               id="emailContacto" 
                                               name="emailContacto" 
                                               value="${proyecto.emailContacto}"
                                               placeholder="Ej: contacto@constructora-abc.com"
                                               maxlength="100"
                                               title="Dirección de correo electrónico válida">
                                        <div class="invalid-feedback">
                                            Por favor, ingresa un email válido (máximo 100 caracteres).
                                        </div>
                                        <div class="form-text">
                                            <i class="fas fa-at me-1"></i>
                                            Correo electrónico principal para comunicaciones del proyecto
                                        </div>
                                    </div>
                                    
                                    <!-- Teléfono Contacto -->
                                    <div class="col-md-6 mb-3">
                                        <label for="telefonoContacto" class="form-label fw-bold">
                                            <i class="fas fa-phone text-success me-1"></i>
                                            Teléfono de Contacto
                                        </label>
                                        <input type="tel" 
                                               class="form-control" 
                                               id="telefonoContacto" 
                                               name="telefonoContacto" 
                                               value="${proyecto.telefonoContacto}"
                                               placeholder="Ej: +57 301 2345678"
                                               maxlength="20"
                                               pattern="[0-9\+\-\s\(\)]+"
                                               title="Solo números, espacios, paréntesis, guiones y signo más">
                                        <div class="invalid-feedback">
                                            Por favor, ingresa un teléfono válido (solo números y signos básicos).
                                        </div>
                                        <div class="form-text">
                                            <i class="fas fa-mobile-alt me-1"></i>
                                            Número telefónico principal para contacto directo
                                        </div>
                                    </div>
                                </div>
                            </fieldset>
                            
                            <!-- Información adicional para modo edición -->
                            <c:if test="${not empty proyecto}">
                                <fieldset class="mb-4">
                                    <legend class="h6 text-info border-bottom pb-2 mb-3">
                                        <i class="fas fa-info-circle me-1"></i>
                                        Información del Sistema
                                    </legend>
                                    
                                    <div class="row">
                                        <div class="col-md-4 mb-3">
                                            <label class="form-label fw-bold text-muted">ID del Proyecto:</label>
                                            <div class="form-control-plaintext">
                                                <span class="badge bg-primary fs-6">${proyecto.id}</span>
                                            </div>
                                        </div>
                                        <div class="col-md-4 mb-3">
                                            <label class="form-label fw-bold text-muted">Fecha de Creación:</label>
                                            <div class="form-control-plaintext">
                                                <fmt:formatDate value="${proyecto.fechaCreacion}" pattern="dd/MM/yyyy HH:mm"/>
                                            </div>
                                        </div>
                                        <div class="col-md-4 mb-3">
                                            <label class="form-label fw-bold text-muted">Estado Actual:</label>
                                            <div class="form-control-plaintext">
                                                <c:choose>
                                                    <c:when test="${proyecto.estado eq 'Activo'}">
                                                        <span class="badge bg-success">
                                                            <i class="fas fa-check me-1"></i>
                                                            ${proyecto.estado}
                                                        </span>
                                                    </c:when>
                                                    <c:when test="${proyecto.estado eq 'Finalizado'}">
                                                        <span class="badge bg-primary">
                                                            <i class="fas fa-flag-checkered me-1"></i>
                                                            ${proyecto.estado}
                                                        </span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge bg-secondary">${proyecto.estado}</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                        </div>
                                    </div>
                                </fieldset>
                            </c:if>
                            
                            <!-- Botones de acción -->
                            <div class="row">
                                <div class="col-12">
                                    <div class="d-grid gap-2 d-md-flex justify-content-md-end">
                                        <!-- Botón Cancelar -->
                                        <a href="ProyectoServlet" class="btn btn-outline-secondary btn-lg me-md-2">
                                            <i class="fas fa-times me-2"></i>
                                            Cancelar
                                        </a>
                                        
                                        <!-- Botón Reset (solo en modo crear) -->
                                        <c:if test="${empty proyecto}">
                                            <button type="reset" class="btn btn-outline-warning btn-lg me-md-2">
                                                <i class="fas fa-undo me-2"></i>
                                                Limpiar
                                            </button>
                                        </c:if>
                                        
                                        <!-- Botón Guardar -->
                                        <button type="submit" class="btn btn-success btn-lg" id="btnGuardar">
                                            <i class="fas fa-save me-2"></i>
                                            <c:choose>
                                                <c:when test="${not empty proyecto}">
                                                    Actualizar Proyecto
                                                </c:when>
                                                <c:otherwise>
                                                    Crear Proyecto
                                                </c:otherwise>
                                            </c:choose>
                                        </button>
                                    </div>
                                </div>
                            </div>
                        </form>
                    </div>
                </div>
                
                <!-- Card de ayuda e información -->
                <div class="card border-0 shadow-sm mt-4">
                    <div class="card-header bg-light">
                        <h6 class="mb-0">
                            <i class="fas fa-question-circle text-info me-2"></i>
                            Ayuda e Información
                        </h6>
                    </div>
                    <div class="card-body">
                        <div class="row">
                            <div class="col-md-6">
                                <h6 class="text-primary">
                                    <i class="fas fa-exclamation-circle me-1"></i>
                                    Campos Obligatorios
                                </h6>
                                <ul class="list-unstyled">
                                    <li><i class="fas fa-check text-success me-1"></i> Nombre de la Obra</li>
                                    <li><i class="fas fa-check text-success me-1"></i> Dirección de la Obra</li>
                                    <li><i class="fas fa-check text-success me-1"></i> NIT del Cliente</li>
                                    <li><i class="fas fa-check text-success me-1"></i> Nombre del Cliente</li>
                                </ul>
                            </div>
                            <div class="col-md-6">
                                <h6 class="text-warning">
                                    <i class="fas fa-lightbulb me-1"></i>
                                    Consejos de Uso
                                </h6>
                                <ul class="list-unstyled">
                                    <li><i class="fas fa-info text-info me-1"></i> Los campos opcionales mejoran la comunicación</li>
                                    <li><i class="fas fa-info text-info me-1"></i> Verifica los datos antes de guardar</li>
                                    <li><i class="fas fa-info text-info me-1"></i> El NIT debe incluir el dígito verificador</li>
                                    <li><i class="fas fa-info text-info me-1"></i> La dirección debe ser completa y precisa</li>
                                </ul>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Footer -->
    <footer class="bg-dark text-light py-4 mt-5">
        <div class="container">
            <div class="row">
                <div class="col-md-6">
                    <h6 class="fw-bold">
                        <i class="fas fa-graduation-cap me-2"></i>
                        Evidencia Académica SENA
                    </h6>
                    <p class="mb-1">
                        <strong>Desarrollador:</strong> NELSON RODRIGUEZ
                    </p>
                    <p class="mb-1">
                        <strong>Código:</strong> GA7-220501096-AA2-EV02
                    </p>
                    <p class="text-muted small">
                        Programa: Análisis y Desarrollo de Software
                    </p>
                </div>
                <div class="col-md-6 text-md-end">
                    <h6 class="fw-bold">
                        <i class="fas fa-code me-2"></i>
                        Tecnologías Implementadas
                    </h6>
                    <div class="d-flex flex-wrap justify-content-md-end gap-2">
                        <span class="badge bg-outline-light border">JSP</span>
                        <span class="badge bg-outline-light border">JSTL</span>
                        <span class="badge bg-outline-light border">Servlets</span>
                        <span class="badge bg-outline-light border">Bootstrap 5</span>
                        <span class="badge bg-outline-light border">HTML5</span>
                        <span class="badge bg-outline-light border">JavaScript</span>
                    </div>
                    <p class="text-muted small mt-2">
                        <i class="fas fa-clock me-1"></i>
                        Formulario CRUD unificado con validación completa
                    </p>
                </div>
            </div>
        </div>
    </footer>

    <!-- Bootstrap 5 JS Bundle -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    
    <!-- JavaScript personalizado -->
    <script src="js/scripts.js"></script>
    
    <!-- Scripts específicos del formulario -->
    <script>
        /**
         * Inicialización del formulario y validaciones
         */
        document.addEventListener('DOMContentLoaded', function() {
            const form = document.getElementById('formProyecto');
            const btnGuardar = document.getElementById('btnGuardar');
            
            // Configurar validación HTML5 personalizada
            form.addEventListener('submit', function(event) {
                if (!form.checkValidity()) {
                    event.preventDefault();
                    event.stopPropagation();
                    
                    // Scroll al primer campo con error
                    const firstInvalid = form.querySelector(':invalid');
                    if (firstInvalid) {
                        firstInvalid.scrollIntoView({ behavior: 'smooth', block: 'center' });
                        firstInvalid.focus();
                    }
                } else {
                    // Mostrar loading en el botón
                    btnGuardar.innerHTML = '<i class="fas fa-spinner fa-spin me-2"></i>Guardando...';
                    btnGuardar.disabled = true;
                }
                
                form.classList.add('was-validated');
            });
            
            // Validación en tiempo real
            const inputs = form.querySelectorAll('input[required]');
            inputs.forEach(input => {
                input.addEventListener('blur', function() {
                    if (this.checkValidity()) {
                        this.classList.remove('is-invalid');
                        this.classList.add('is-valid');
                    } else {
                        this.classList.remove('is-valid');
                        this.classList.add('is-invalid');
                    }
                });
                
                input.addEventListener('input', function() {
                    if (this.classList.contains('was-validated')) {
                        if (this.checkValidity()) {
                            this.classList.remove('is-invalid');
                            this.classList.add('is-valid');
                        } else {
                            this.classList.remove('is-valid');
                            this.classList.add('is-invalid');
                        }
                    }
                });
            });
            
            // Validación específica para NIT
            const nitInput = document.getElementById('nitCliente');
            if (nitInput) {
                nitInput.addEventListener('input', function() {
                    // Formateo automático del NIT
                    let value = this.value.replace(/[^0-9]/g, '');
                    if (value.length > 9) {
                        value = value.substring(0, 9) + '-' + value.substring(9, 10);
                    }
                    this.value = value;
                });
            }
            
            // Validación específica para teléfono
            const telefonoInput = document.getElementById('telefonoContacto');
            if (telefonoInput) {
                telefonoInput.addEventListener('input', function() {
                    // Permitir solo números, espacios, paréntesis, guiones y signo más
                    this.value = this.value.replace(/[^0-9\+\-\s\(\)]/g, '');
                });
            }
            
            // Confirmación antes de limpiar formulario
            const resetBtn = form.querySelector('button[type="reset"]');
            if (resetBtn) {
                resetBtn.addEventListener('click', function(e) {
                    if (!confirm('¿Estás seguro de que deseas limpiar todos los campos del formulario?')) {
                        e.preventDefault();
                    } else {
                        // Remover clases de validación
                        form.classList.remove('was-validated');
                        inputs.forEach(input => {
                            input.classList.remove('is-valid', 'is-invalid');
                        });
                    }
                });
            }
            
            // Auto-ocultar alertas después de 5 segundos
            setTimeout(function() {
                const alertas = document.querySelectorAll('.alert');
                alertas.forEach(function(alerta) {
                    const bsAlert = new bootstrap.Alert(alerta);
                    bsAlert.close();
                });
            }, 5000);
            
            // Enfocar en el primer campo al cargar
            const firstInput = form.querySelector('input[type="text"]');
            if (firstInput) {
                firstInput.focus();
            }
        });
        
        /**
         * Funciones de utilidad
         */
        
        // Validar email en tiempo real
        function validarEmail(email) {
            const regex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
            return regex.test(email);
        }
        
        // Validar NIT colombiano básico
        function validarNIT(nit) {
            const regex = /^\d{8,10}-?\d$/;
            return regex.test(nit);
        }
        
        // Capitalizar primera letra de cada palabra
        function capitalizarTexto(texto) {
            return texto.toLowerCase().replace(/\b\w/g, l => l.toUpperCase());
        }
        
        // Aplicar capitalización automática a campos de texto
        document.querySelectorAll('input[type="text"]:not(#nitCliente)').forEach(input => {
            input.addEventListener('blur', function() {
                if (this.value.trim()) {
                    this.value = capitalizarTexto(this.value.trim());
                }
            });
        });
        
        /**
         * Manejo de errores globales
         */
        window.addEventListener('error', function(e) {
            console.error('Error en formProyecto.jsp:', e.message);
        });
        
        // Prevenir pérdida de datos no guardados
        let formModified = false;
        document.getElementById('formProyecto').addEventListener('input', function() {
            formModified = true;
        });
        
        window.addEventListener('beforeunload', function(e) {
            if (formModified) {
                e.preventDefault();
                e.returnValue = '¿Estás seguro de que deseas salir? Los cambios no guardados se perderán.';
            }
        });
        
        // Remover confirmación al enviar formulario
        document.getElementById('formProyecto').addEventListener('submit', function() {
            formModified = false;
        });
    </script>
</body>
</html>