<%-- 
    Document   : listaProyectos
    Author     : NELSON RODRIGUEZ
    Description: Vista principal para mostrar la lista de proyectos de construcción.
                 Implementa una tabla responsive con operaciones CRUD completas.
    
    Evidencia: GA7-220501096-AA2-EV02
    Programa: Análisis y Desarrollo de Software - SENA
    
    Funcionalidades:
    - Lista paginada de proyectos con tabla responsive
    - Botones de acción: Crear, Editar, Eliminar
    - Manejo de mensajes de éxito y error
    - Confirmación JavaScript para eliminaciones
    - Búsqueda y filtros en tiempo real
    - Diseño moderno con Bootstrap 5
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
    <meta name="description" content="Sistema de gestión de proyectos de construcción - Lista de proyectos">
    <meta name="keywords" content="SENA, Java Web, Servlets, JSP, CRUD, Proyectos, Bootstrap">
    
    <title>Lista de Proyectos - CartillasAceroWeb</title>
    
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    
    <!-- Font Awesome 6 -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <!-- DataTables CSS para tablas avanzadas -->
    <link rel="stylesheet" href="https://cdn.datatables.net/1.13.4/css/dataTables.bootstrap5.min.css">
    
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
                        <a class="nav-link active" href="ProyectoServlet">
                            <i class="fas fa-list me-1"></i>
                            Proyectos
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
    <div class="container-fluid py-4">
        
        <!-- Breadcrumb -->
        <nav aria-label="breadcrumb" class="mb-4">
            <ol class="breadcrumb">
                <li class="breadcrumb-item">
                    <a href="index.jsp" class="text-decoration-none">
                        <i class="fas fa-home"></i> Inicio
                    </a>
                </li>
                <li class="breadcrumb-item active" aria-current="page">
                    <i class="fas fa-list"></i> Lista de Proyectos
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
        
        <c:if test="${not empty param.mensaje}">
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                <i class="fas fa-info-circle me-2"></i>
                ${param.mensaje}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>
        
        <c:if test="${not empty param.error}">
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                <i class="fas fa-times-circle me-2"></i>
                ${param.error}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <!-- Header de la página -->
        <div class="row mb-4">
            <div class="col-lg-6">
                <h2 class="h3 mb-0 text-dark">
                    <i class="fas fa-building me-2 text-primary"></i>
                    Gestión de Proyectos
                </h2>
                <p class="text-muted mt-1">
                    Administra todos los proyectos de construcción registrados en el sistema
                </p>
            </div>
            <div class="col-lg-6 text-lg-end">
                <a href="ProyectoServlet?accion=nuevo" class="btn btn-success btn-lg">
                    <i class="fas fa-plus me-2"></i>
                    Nuevo Proyecto
                </a>
            </div>
        </div>

        <!-- Estadísticas rápidas -->
        <div class="row mb-4">
            <div class="col-md-3">
                <div class="card border-0 shadow-sm">
                    <div class="card-body text-center">
                        <div class="text-primary mb-2">
                            <i class="fas fa-project-diagram fa-2x"></i>
                        </div>
                        <h5 class="card-title">
                            <c:choose>
                                <c:when test="${empty proyectos}">0</c:when>
                                <c:otherwise>${proyectos.size()}</c:otherwise>
                            </c:choose>
                        </h5>
                        <p class="card-text text-muted">Total Proyectos</p>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card border-0 shadow-sm">
                    <div class="card-body text-center">
                        <div class="text-success mb-2">
                            <i class="fas fa-check-circle fa-2x"></i>
                        </div>
                        <h5 class="card-title">
                            <c:set var="activos" value="0"/>
                            <c:forEach var="proyecto" items="${proyectos}">
                                <c:if test="${proyecto.estado eq 'Activo'}">
                                    <c:set var="activos" value="${activos + 1}"/>
                                </c:if>
                            </c:forEach>
                            ${activos}
                        </h5>
                        <p class="card-text text-muted">Proyectos Activos</p>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card border-0 shadow-sm">
                    <div class="card-body text-center">
                        <div class="text-warning mb-2">
                            <i class="fas fa-clock fa-2x"></i>
                        </div>
                        <h5 class="card-title">
                            <fmt:formatDate value="<%= new java.util.Date() %>" pattern="MMM"/>
                        </h5>
                        <p class="card-text text-muted">Mes Actual</p>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card border-0 shadow-sm">
                    <div class="card-body text-center">
                        <div class="text-info mb-2">
                            <i class="fas fa-calendar fa-2x"></i>
                        </div>
                        <h5 class="card-title">
                            <fmt:formatDate value="<%= new java.util.Date() %>" pattern="yyyy"/>
                        </h5>
                        <p class="card-text text-muted">Año en Curso</p>
                    </div>
                </div>
            </div>
        </div>

        <!-- Tabla de proyectos -->
        <div class="card border-0 shadow">
            <div class="card-header bg-white py-3">
                <div class="row align-items-center">
                    <div class="col-md-6">
                        <h5 class="mb-0">
                            <i class="fas fa-table me-2 text-primary"></i>
                            Lista de Proyectos
                        </h5>
                    </div>
                    <div class="col-md-6 text-md-end">
                        <!-- Buscador en tiempo real -->
                        <div class="input-group" style="max-width: 300px; margin-left: auto;">
                            <span class="input-group-text">
                                <i class="fas fa-search"></i>
                            </span>
                            <input type="text" id="buscador" class="form-control" 
                                   placeholder="Buscar proyectos...">
                        </div>
                    </div>
                </div>
            </div>
            
            <div class="card-body p-0">
                <!-- Verificar si hay proyectos -->
                <c:choose>
                    <c:when test="${empty proyectos}">
                        <!-- Estado vacío -->
                        <div class="text-center py-5">
                            <div class="mb-4">
                                <i class="fas fa-folder-open fa-5x text-muted"></i>
                            </div>
                            <h4 class="text-muted mb-3">No hay proyectos registrados</h4>
                            <p class="text-muted mb-4">
                                Comienza creando tu primer proyecto de construcción
                            </p>
                            <a href="ProyectoServlet?accion=nuevo" class="btn btn-primary btn-lg">
                                <i class="fas fa-plus me-2"></i>
                                Crear Primer Proyecto
                            </a>
                        </div>
                    </c:when>
                    
                    <c:otherwise>
                        <!-- Tabla con datos -->
                        <div class="table-responsive">
                            <table id="tablaProyectos" class="table table-hover table-striped mb-0">
                                <thead class="table-dark">
                                    <tr>
                                        <th scope="col" class="text-center">#</th>
                                        <th scope="col">
                                            <i class="fas fa-building me-1"></i>
                                            Nombre de Obra
                                        </th>
                                        <th scope="col">
                                            <i class="fas fa-map-marker-alt me-1"></i>
                                            Dirección
                                        </th>
                                        <th scope="col">
                                            <i class="fas fa-id-card me-1"></i>
                                            NIT Cliente
                                        </th>
                                        <th scope="col">
                                            <i class="fas fa-user-tie me-1"></i>
                                            Cliente
                                        </th>
                                        <th scope="col">
                                            <i class="fas fa-envelope me-1"></i>
                                            Contacto
                                        </th>
                                        <th scope="col">
                                            <i class="fas fa-calendar me-1"></i>
                                            Fecha Creación
                                        </th>
                                        <th scope="col">
                                            <i class="fas fa-info-circle me-1"></i>
                                            Estado
                                        </th>
                                        <th scope="col" class="text-center">
                                            <i class="fas fa-cogs me-1"></i>
                                            Acciones
                                        </th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="proyecto" items="${proyectos}" varStatus="status">
                                        <tr>
                                            <td class="text-center fw-bold">
                                                ${proyecto.id}
                                            </td>
                                            <td>
                                                <div class="fw-bold text-dark">${proyecto.nombreObra}</div>
                                                <small class="text-muted">Proyecto #${proyecto.id}</small>
                                            </td>
                                            <td>
                                                <div class="text-truncate" style="max-width: 200px;" 
                                                     title="${proyecto.direccionObra}">
                                                    ${proyecto.direccionObra}
                                                </div>
                                            </td>
                                            <td>
                                                <span class="badge bg-info text-dark">
                                                    ${proyecto.nitCliente}
                                                </span>
                                            </td>
                                            <td>
                                                <div class="fw-semibold">${proyecto.nombreCliente}</div>
                                                <c:if test="${not empty proyecto.telefonoContacto}">
                                                    <small class="text-muted">
                                                        <i class="fas fa-phone me-1"></i>
                                                        ${proyecto.telefonoContacto}
                                                    </small>
                                                </c:if>
                                            </td>
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
                                            <td>
                                                <fmt:formatDate value="${proyecto.fechaCreacion}" 
                                                              pattern="dd/MM/yyyy"/>
                                                <br>
                                                <small class="text-muted">
                                                    <fmt:formatDate value="${proyecto.fechaCreacion}" 
                                                                  pattern="HH:mm"/>
                                                </small>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${proyecto.estado eq 'Activo'}">
                                                        <span class="badge bg-success">
                                                            <i class="fas fa-check me-1"></i>
                                                            Activo
                                                        </span>
                                                    </c:when>
                                                    <c:when test="${proyecto.estado eq 'Finalizado'}">
                                                        <span class="badge bg-primary">
                                                            <i class="fas fa-flag-checkered me-1"></i>
                                                            Finalizado
                                                        </span>
                                                    </c:when>
                                                    <c:when test="${proyecto.estado eq 'Suspendido'}">
                                                        <span class="badge bg-warning text-dark">
                                                            <i class="fas fa-pause me-1"></i>
                                                            Suspendido
                                                        </span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge bg-secondary">
                                                            ${proyecto.estado}
                                                        </span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td class="text-center">
                                                <div class="btn-group" role="group">
                                                    <!-- Botón Ver/Detalles -->
                                                    <button type="button" class="btn btn-outline-info btn-sm" 
                                                            title="Ver detalles" 
                                                            onclick="mostrarDetalles(${proyecto.id}, '${proyecto.nombreObra}', '${proyecto.direccionObra}', '${proyecto.nitCliente}', '${proyecto.nombreCliente}', '${proyecto.emailContacto}', '${proyecto.telefonoContacto}', '${proyecto.estado}')">
                                                        <i class="fas fa-eye"></i>
                                                    </button>
                                                    
                                                    <!-- Botón Editar -->
                                                    <a href="ProyectoServlet?accion=editar&id=${proyecto.id}" 
                                                       class="btn btn-outline-warning btn-sm" 
                                                       title="Editar proyecto">
                                                        <i class="fas fa-edit"></i>
                                                    </a>
                                                    
                                                    <!-- Botón Eliminar -->
                                                    <button type="button" class="btn btn-outline-danger btn-sm" 
                                                            title="Eliminar proyecto"
                                                            onclick="confirmarEliminacion(${proyecto.id}, '${proyecto.nombreObra}')">
                                                        <i class="fas fa-trash"></i>
                                                    </button>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>

    <!-- Modal para mostrar detalles del proyecto -->
    <div class="modal fade" id="modalDetalles" tabindex="-1">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header bg-primary text-white">
                    <h5 class="modal-title">
                        <i class="fas fa-info-circle me-2"></i>
                        Detalles del Proyecto
                    </h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <div class="row">
                        <div class="col-md-6">
                            <h6 class="text-primary">
                                <i class="fas fa-building me-1"></i>
                                Información del Proyecto
                            </h6>
                            <table class="table table-borderless">
                                <tr>
                                    <td class="fw-bold">ID:</td>
                                    <td id="detalleId"></td>
                                </tr>
                                <tr>
                                    <td class="fw-bold">Nombre de Obra:</td>
                                    <td id="detalleNombreObra"></td>
                                </tr>
                                <tr>
                                    <td class="fw-bold">Dirección:</td>
                                    <td id="detalleDireccionObra"></td>
                                </tr>
                                <tr>
                                    <td class="fw-bold">Estado:</td>
                                    <td id="detalleEstado"></td>
                                </tr>
                            </table>
                        </div>
                        <div class="col-md-6">
                            <h6 class="text-success">
                                <i class="fas fa-user-tie me-1"></i>
                                Información del Cliente
                            </h6>
                            <table class="table table-borderless">
                                <tr>
                                    <td class="fw-bold">NIT:</td>
                                    <td id="detalleNitCliente"></td>
                                </tr>
                                <tr>
                                    <td class="fw-bold">Nombre Cliente:</td>
                                    <td id="detalleNombreCliente"></td>
                                </tr>
                                <tr>
                                    <td class="fw-bold">Email:</td>
                                    <td id="detalleEmailContacto"></td>
                                </tr>
                                <tr>
                                    <td class="fw-bold">Teléfono:</td>
                                    <td id="detalleTelefonoContacto"></td>
                                </tr>
                            </table>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">
                        <i class="fas fa-times me-1"></i>
                        Cerrar
                    </button>
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
                        <i class="fas fa-chart-bar me-2"></i>
                        Resumen del Sistema
                    </h6>
                    <p class="mb-1">
                        <strong>Total Proyectos:</strong> 
                        <c:choose>
                            <c:when test="${empty proyectos}">0</c:when>
                            <c:otherwise>${proyectos.size()}</c:otherwise>
                        </c:choose>
                    </p>
                    <p class="text-muted small">
                        <i class="fas fa-clock me-1"></i>
                        Última actualización: <fmt:formatDate value="<%= new java.util.Date() %>" pattern="dd/MM/yyyy HH:mm"/>
                    </p>
                </div>
            </div>
        </div>
    </footer>

    <!-- Bootstrap 5 JS Bundle -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    
    <!-- jQuery -->
    <script src="https://code.jquery.com/jquery-3.7.0.min.js"></script>
    
    <!-- DataTables JS -->
    <script src="https://cdn.datatables.net/1.13.4/js/jquery.dataTables.min.js"></script>
    <script src="https://cdn.datatables.net/1.13.4/js/dataTables.bootstrap5.min.js"></script>
    
    <!-- JavaScript personalizado -->
    <script src="js/scripts.js"></script>
    
    <!-- Scripts específicos de la página -->
    <script>
        /**
         * Inicialización de componentes al cargar la página
         */
        document.addEventListener('DOMContentLoaded', function() {
            // Inicializar DataTables si hay datos
            if (document.getElementById('tablaProyectos')) {
                $('#tablaProyectos').DataTable({
                    language: {
                        url: 'https://cdn.datatables.net/plug-ins/1.13.4/i18n/es-ES.json'
                    },
                    responsive: true,
                    pageLength: 10,
                    order: [[0, 'desc']], // Ordenar por ID descendente
                    columnDefs: [
                        { orderable: false, targets: -1 } // Desactivar ordenamiento en columna de acciones
                    ]
                });
            }
            
            // Configurar buscador personalizado
            const buscador = document.getElementById('buscador');
            if (buscador) {
                buscador.addEventListener('input', function() {
                    const tabla = $('#tablaProyectos').DataTable();
                    tabla.search(this.value).draw();
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
        });
        
        /**
         * Confirma la eliminación de un proyecto con SweetAlert2 o modal nativo
         */
        function confirmarEliminacion(id, nombreObra) {
            const mensaje = `¿Estás seguro de que deseas eliminar el proyecto "${nombreObra}"?\\n\\nEsta acción no se puede deshacer.`;
            
            if (confirm(mensaje)) {
                // Enviar al servlet para confirmar eliminación
                window.location.href = `ProyectoServlet?accion=confirmarEliminar&id=${id}`;
            }
        }
        
        /**
         * Muestra los detalles completos de un proyecto en un modal
         */
        function mostrarDetalles(id, nombreObra, direccionObra, nitCliente, nombreCliente, emailContacto, telefonoContacto, estado) {
            // Llenar los campos del modal
            document.getElementById('detalleId').textContent = id;
            document.getElementById('detalleNombreObra').textContent = nombreObra;
            document.getElementById('detalleDireccionObra').textContent = direccionObra;
            document.getElementById('detalleNitCliente').textContent = nitCliente;
            document.getElementById('detalleNombreCliente').textContent = nombreCliente;
            document.getElementById('detalleEmailContacto').textContent = emailContacto || 'No especificado';
            document.getElementById('detalleTelefonoContacto').textContent = telefonoContacto || 'No especificado';
            
            // Formatear estado con badge
            const estadoElement = document.getElementById('detalleEstado');
            let badgeClass = 'bg-secondary';
            if (estado === 'Activo') badgeClass = 'bg-success';
            else if (estado === 'Finalizado') badgeClass = 'bg-primary';
            else if (estado === 'Suspendido') badgeClass = 'bg-warning text-dark';
            
            estadoElement.innerHTML = `<span class="badge ${badgeClass}">${estado}</span>`;
            
            // Mostrar el modal
            const modal = new bootstrap.Modal(document.getElementById('modalDetalles'));
            modal.show();
        }
        
        /**
         * Manejo de errores globales de JavaScript
         */
        window.addEventListener('error', function(e) {
            console.error('Error en listaProyectos.jsp:', e.message);
        });
        
        /**
         * Funciones de utilidad para mejorar UX
         */
        
        // Agregar efecto de loading a los botones de acción
        document.addEventListener('click', function(e) {
            if (e.target.matches('a[href*="ProyectoServlet"]')) {
                const btn = e.target.closest('a');
                if (btn) {
                    btn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Cargando...';
                    btn.classList.add('disabled');
                }
            }
        });
        
        // Tooltips para botones de acción
        const tooltipTriggerList = [].slice.call(document.querySelectorAll('[title]'));
        const tooltipList = tooltipTriggerList.map(function (tooltipTriggerEl) {
            return new bootstrap.Tooltip(tooltipTriggerEl);
        });
    </script>
</body>
</html>