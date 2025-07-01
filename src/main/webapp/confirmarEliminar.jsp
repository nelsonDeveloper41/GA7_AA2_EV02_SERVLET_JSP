<%-- 
    Author     : NELSON RODRIGUEZ
    Description: Página de confirmación para eliminación de proyectos de construcción.
                 Implementa confirmación segura con detalles completos del proyecto.
    
    Evidencia: GA7-220501096-AA2-EV02
    Programa: Análisis y Desarrollo de Software - SENA
    
    Funcionalidades:
    - Confirmación segura antes de eliminar proyecto
    - Visualización completa de datos del proyecto a eliminar
    - Formulario POST para eliminación definitiva
    - Diseño modal-like responsivo con Bootstrap 5
    - Prevención de eliminaciones accidentales
    - Navegación clara con opciones de cancelar
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
    <meta name="description" content="Confirmación de eliminación de proyectos - CartillasAceroWeb">
    <meta name="keywords" content="SENA, Java Web, Servlets, JSP, CRUD, Eliminar, Confirmación">
    
    <title>Confirmar Eliminación - CartillasAceroWeb</title>
    
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    
    <!-- Font Awesome 6 -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <!-- CSS personalizado -->
    <link rel="stylesheet" href="css/estilos.css">
    
    <!-- Favicon -->
    <link rel="icon" type="image/x-icon" href="data:image/svg+xml,<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 100 100'><text y='.9em' font-size='90'>⚠️</text></svg>">
    
    <!-- Estilos específicos para la página de confirmación -->
    <style>
        .modal-overlay {
            background: linear-gradient(135deg, rgba(220, 53, 69, 0.1), rgba(0, 0, 0, 0.3));
            backdrop-filter: blur(5px);
        }
        
        .confirmation-card {
            animation: slideInDown 0.5s ease-out;
            box-shadow: 0 20px 60px rgba(220, 53, 69, 0.2);
        }
        
        @keyframes slideInDown {
            from {
                opacity: 0;
                transform: translateY(-50px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
        
        .danger-icon {
            animation: pulse 2s infinite;
        }
        
        @keyframes pulse {
            0% { transform: scale(1); }
            50% { transform: scale(1.1); }
            100% { transform: scale(1); }
        }
        
        .project-info-card {
            border-left: 5px solid #dc3545;
            background: linear-gradient(45deg, #fff5f5, #ffffff);
        }
        
        .btn-confirm-delete {
            background: linear-gradient(45deg, #dc3545, #c82333);
            border: none;
            transition: all 0.3s ease;
        }
        
        .btn-confirm-delete:hover {
            background: linear-gradient(45deg, #c82333, #bd2130);
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(220, 53, 69, 0.4);
        }
    </style>
</head>

<body class="modal-overlay d-flex align-items-center justify-content-center min-vh-100">
    
    <!-- Verificar que el proyecto existe -->
    <c:choose>
        <c:when test="${empty proyecto}">
            <!-- Error: No se encontró el proyecto -->
            <div class="container">
                <div class="row justify-content-center">
                    <div class="col-md-6">
                        <div class="card border-danger">
                            <div class="card-header bg-danger text-white text-center">
                                <h4 class="mb-0">
                                    <i class="fas fa-exclamation-triangle me-2"></i>
                                    Error
                                </h4>
                            </div>
                            <div class="card-body text-center">
                                <i class="fas fa-times-circle fa-5x text-danger mb-3"></i>
                                <h5 class="text-danger">Proyecto No Encontrado</h5>
                                <p class="text-muted">
                                    El proyecto que intentas eliminar no existe o no se pudo cargar.
                                </p>
                                <a href="ProyectoServlet" class="btn btn-primary">
                                    <i class="fas fa-arrow-left me-2"></i>
                                    Volver a la Lista
                                </a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </c:when>
        
        <c:otherwise>
            <!-- Confirmación de eliminación -->
            <div class="container">
                <div class="row justify-content-center">
                    <div class="col-lg-8 col-md-10">
                        <div class="card confirmation-card border-0 shadow-lg">
                            
                            <!-- Header de advertencia -->
                            <div class="card-header bg-danger text-white text-center py-4">
                                <div class="danger-icon mb-3">
                                    <i class="fas fa-exclamation-triangle fa-4x"></i>
                                </div>
                                <h3 class="mb-2">
                                    <i class="fas fa-trash-alt me-2"></i>
                                    Confirmar Eliminación
                                </h3>
                                <p class="mb-0 lead">
                                    Esta acción es <strong>irreversible</strong>
                                </p>
                            </div>
                            
                            <div class="card-body p-4">
                                <!-- Mensaje principal de advertencia -->
                                <div class="alert alert-danger border-0 mb-4" role="alert">
                                    <div class="d-flex align-items-center">
                                        <i class="fas fa-exclamation-circle fa-2x me-3"></i>
                                        <div>
                                            <h5 class="alert-heading mb-2">
                                                ¿Estás completamente seguro?
                                            </h5>
                                            <p class="mb-0">
                                                Vas a eliminar permanentemente este proyecto del sistema. 
                                                <strong>Esta acción NO se puede deshacer</strong> y se perderán 
                                                todos los datos asociados.
                                            </p>
                                        </div>
                                    </div>
                                </div>
                                
                                <!-- Información completa del proyecto a eliminar -->
                                <div class="project-info-card card mb-4">
                                    <div class="card-header bg-light">
                                        <h5 class="mb-0 text-dark">
                                            <i class="fas fa-building me-2 text-primary"></i>
                                            Información del Proyecto a Eliminar
                                        </h5>
                                    </div>
                                    <div class="card-body">
                                        <div class="row">
                                            <!-- Columna izquierda: Datos del proyecto -->
                                            <div class="col-md-6">
                                                <h6 class="text-primary mb-3">
                                                    <i class="fas fa-info-circle me-1"></i>
                                                    Datos del Proyecto
                                                </h6>
                                                <table class="table table-borderless table-sm">
                                                    <tr>
                                                        <td class="fw-bold text-muted">ID:</td>
                                                        <td>
                                                            <span class="badge bg-primary fs-6">${proyecto.id}</span>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td class="fw-bold text-muted">Nombre de Obra:</td>
                                                        <td class="fw-bold text-dark">${proyecto.nombreObra}</td>
                                                    </tr>
                                                    <tr>
                                                        <td class="fw-bold text-muted">Dirección:</td>
                                                        <td>${proyecto.direccionObra}</td>
                                                    </tr>
                                                    <tr>
                                                        <td class="fw-bold text-muted">Estado:</td>
                                                        <td>
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
                                                                <c:when test="${proyecto.estado eq 'Suspendido'}">
                                                                    <span class="badge bg-warning text-dark">
                                                                        <i class="fas fa-pause me-1"></i>
                                                                        ${proyecto.estado}
                                                                    </span>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <span class="badge bg-secondary">${proyecto.estado}</span>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td class="fw-bold text-muted">Fecha Creación:</td>
                                                        <td>
                                                            <fmt:formatDate value="${proyecto.fechaCreacion}" 
                                                                          pattern="dd/MM/yyyy HH:mm"/>
                                                        </td>
                                                    </tr>
                                                </table>
                                            </div>
                                            
                                            <!-- Columna derecha: Datos del cliente -->
                                            <div class="col-md-6">
                                                <h6 class="text-success mb-3">
                                                    <i class="fas fa-user-tie me-1"></i>
                                                    Datos del Cliente
                                                </h6>
                                                <table class="table table-borderless table-sm">
                                                    <tr>
                                                        <td class="fw-bold text-muted">NIT:</td>
                                                        <td>
                                                            <span class="badge bg-info text-dark">${proyecto.nitCliente}</span>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td class="fw-bold text-muted">Nombre Cliente:</td>
                                                        <td class="fw-bold text-dark">${proyecto.nombreCliente}</td>
                                                    </tr>
                                                    <tr>
                                                        <td class="fw-bold text-muted">Email:</td>
                                                        <td>
                                                            <c:choose>
                                                                <c:when test="${not empty proyecto.emailContacto}">
                                                                    <a href="mailto:${proyecto.emailContacto}" 
                                                                       class="text-decoration-none">
                                                                        ${proyecto.emailContacto}
                                                                    </a>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <span class="text-muted">No especificado</span>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td class="fw-bold text-muted">Teléfono:</td>
                                                        <td>
                                                            <c:choose>
                                                                <c:when test="${not empty proyecto.telefonoContacto}">
                                                                    <span class="text-nowrap">
                                                                        <i class="fas fa-phone me-1"></i>
                                                                        ${proyecto.telefonoContacto}
                                                                    </span>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <span class="text-muted">No especificado</span>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </td>
                                                    </tr>
                                                </table>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                
                                <!-- Información adicional de advertencia -->
                                <div class="alert alert-warning border-0 mb-4" role="alert">
                                    <h6 class="alert-heading">
                                        <i class="fas fa-info-circle me-2"></i>
                                        Consecuencias de la eliminación:
                                    </h6>
                                    <ul class="mb-0">
                                        <li>Se eliminará toda la información del proyecto mostrada arriba</li>
                                        <li>Se perderán todos los datos de contacto asociados</li>
                                        <li>Esta operación no podrá ser revertida</li>
                                        <li>El ID del proyecto (${proyecto.id}) no podrá ser reutilizado</li>
                                    </ul>
                                </div>
                                
                                <!-- Checkbox de confirmación -->
                                <div class="form-check mb-4 p-3 bg-light rounded">
                                    <input class="form-check-input" type="checkbox" id="confirmarEliminacion" required>
                                    <label class="form-check-label fw-bold" for="confirmarEliminacion">
                                        <i class="fas fa-check-square me-2 text-danger"></i>
                                        He leído y entiendo que esta acción eliminará permanentemente 
                                        el proyecto "<strong>${proyecto.nombreObra}</strong>" y no podrá ser recuperado.
                                    </label>
                                </div>
                            </div>
                            
                            <!-- Footer con botones de acción -->
                            <div class="card-footer bg-light py-4">
                                <div class="row">
                                    <div class="col-12">
                                        <div class="d-flex flex-column flex-md-row gap-3 justify-content-center">
                                            
                                            <!-- Botón Cancelar -->
                                            <a href="ProyectoServlet" class="btn btn-outline-secondary btn-lg">
                                                <i class="fas fa-arrow-left me-2"></i>
                                                No, Cancelar y Volver
                                            </a>
                                            
                                            <!-- Botón Volver a Lista -->
                                            <a href="ProyectoServlet" class="btn btn-outline-primary btn-lg">
                                                <i class="fas fa-list me-2"></i>
                                                Ir a la Lista
                                            </a>
                                            
                                            <!-- Formulario para eliminación definitiva -->
                                            <form id="formEliminar" method="POST" action="ProyectoServlet" class="d-inline">
                                                <input type="hidden" name="accion" value="eliminar">
                                                <input type="hidden" name="id" value="${proyecto.id}">
                                                
                                                <button type="submit" 
                                                        id="btnEliminar"
                                                        class="btn btn-confirm-delete btn-lg text-white"
                                                        disabled>
                                                    <i class="fas fa-trash-alt me-2"></i>
                                                    Sí, Eliminar Definitivamente
                                                </button>
                                            </form>
                                        </div>
                                    </div>
                                </div>
                                
                                <!-- Información adicional en el footer -->
                                <div class="row mt-4">
                                    <div class="col-12">
                                        <div class="text-center">
                                            <small class="text-muted">
                                                <i class="fas fa-graduation-cap me-1"></i>
                                                <strong>Desarrollado por:</strong> NELSON RODRIGUEZ - 
                                                <strong>Evidencia:</strong> GA7-220501096-AA2-EV02 - 
                                                <strong>SENA</strong> Análisis y Desarrollo de Software
                                            </small>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </c:otherwise>
    </c:choose>

    <!-- Bootstrap 5 JS Bundle -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    
    <!-- JavaScript personalizado -->
    <script src="js/scripts.js"></script>
    
    <!-- Scripts específicos de confirmación -->
    <script>
        /**
         * Configuración de la página de confirmación de eliminación
         */
        document.addEventListener('DOMContentLoaded', function() {
            const checkbox = document.getElementById('confirmarEliminacion');
            const btnEliminar = document.getElementById('btnEliminar');
            const formEliminar = document.getElementById('formEliminar');
            
            // Habilitar/deshabilitar botón según checkbox
            if (checkbox && btnEliminar) {
                checkbox.addEventListener('change', function() {
                    btnEliminar.disabled = !this.checked;
                    
                    if (this.checked) {
                        btnEliminar.classList.remove('btn-outline-danger');
                        btnEliminar.classList.add('btn-confirm-delete');
                    } else {
                        btnEliminar.classList.add('btn-outline-danger');
                        btnEliminar.classList.remove('btn-confirm-delete');
                    }
                });
            }
            
            // Confirmación adicional al enviar formulario
            if (formEliminar) {
                formEliminar.addEventListener('submit', function(e) {
                    e.preventDefault();
                    
                    // Triple confirmación para seguridad
                    const nombreProyecto = '${proyecto.nombreObra}';
                    const confirmaciones = [
                        `¿Estás absolutamente seguro de eliminar el proyecto "${nombreProyecto}"?`,
                        `Esta acción eliminará PERMANENTEMENTE toda la información. ¿Continuar?`,
                        `ÚLTIMA OPORTUNIDAD: ¿Confirmas la eliminación definitiva?`
                    ];
                    
                    let confirmar = true;
                    for (let i = 0; i < confirmaciones.length && confirmar; i++) {
                        confirmar = confirm(confirmaciones[i]);
                    }
                    
                    if (confirmar) {
                        // Mostrar loading en el botón
                        btnEliminar.innerHTML = '<i class="fas fa-spinner fa-spin me-2"></i>Eliminando...';
                        btnEliminar.disabled = true;
                        
                        // Enviar formulario después de un breve delay
                        setTimeout(() => {
                            this.submit();
                        }, 1000);
                    } else {
                        // Restablecer checkbox si el usuario cancela
                        checkbox.checked = false;
                        btnEliminar.disabled = true;
                        btnEliminar.classList.add('btn-outline-danger');
                        btnEliminar.classList.remove('btn-confirm-delete');
                    }
                });
            }
            
            // Prevenir cierre accidental de la página
            window.addEventListener('beforeunload', function(e) {
                if (checkbox && checkbox.checked) {
                    e.preventDefault();
                    e.returnValue = '¿Estás seguro de salir? La eliminación no se ha completado.';
                }
            });
            
            // Efecto de enfoque en checkbox
            if (checkbox) {
                setTimeout(() => {
                    checkbox.scrollIntoView({ behavior: 'smooth', block: 'center' });
                    checkbox.focus();
                }, 500);
            }
            
            // Protección contra eliminación por error (ESC para cancelar)
            document.addEventListener('keydown', function(e) {
                if (e.key === 'Escape') {
                    window.location.href = 'ProyectoServlet';
                }
            });
        });
        
        /**
         * Funciones de utilidad
         */
        
        // Contador regresivo opcional para el botón (mayor seguridad)
        function iniciarContadorSeguridad() {
            const btnEliminar = document.getElementById('btnEliminar');
            let segundos = 5;
            
            const interval = setInterval(() => {
                btnEliminar.innerHTML = `<i class="fas fa-clock me-2"></i>Esperar ${segundos}s`;
                segundos--;
                
                if (segundos < 0) {
                    clearInterval(interval);
                    btnEliminar.innerHTML = '<i class="fas fa-trash-alt me-2"></i>Sí, Eliminar Definitivamente';
                    btnEliminar.disabled = false;
                }
            }, 1000);
        }
        
        // Animación de advertencia en el checkbox
        function resaltarCheckbox() {
            const checkbox = document.getElementById('confirmarEliminacion');
            if (checkbox) {
                checkbox.style.animation = 'pulse 0.5s ease-in-out 3';
            }
        }
        
        /**
         * Manejo de errores globales
         */
        window.addEventListener('error', function(e) {
            console.error('Error en confirmarEliminar.jsp:', e.message);
        });
        
        // Log para debugging
        console.log('Página de confirmación de eliminación cargada');
        console.log('Proyecto a eliminar: ${proyecto.id} - ${proyecto.nombreObra}');
        
        // Analíticas básicas (tiempo en página)
        const tiempoInicio = Date.now();
        window.addEventListener('beforeunload', function() {
            const tiempoEnPagina = Math.round((Date.now() - tiempoInicio) / 1000);
            console.log(`Tiempo en página de confirmación: ${tiempoEnPagina} segundos`);
        });
    </script>
</body>
</html>