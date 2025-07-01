/**
 * scripts.js - JavaScript para CartillasAceroWeb
 * 
 * Archivo JavaScript sencillo con funcionalidades básicas para
 * el sistema de gestión de proyectos de construcción.
 * 
 * Evidencia: GA7-220501096-AA2-EV02
 * Autor: NELSON RODRIGUEZ
 * Programa: Análisis y Desarrollo de Software - SENA
 */

// =================== INICIALIZACIÓN ===================

/**
 * Inicializar cuando la página esté lista
 */
document.addEventListener('DOMContentLoaded', function() {
    console.log('CartillasAceroWeb - Iniciando sistema...');
    
    // Configurar validaciones básicas
    configurarValidaciones();
    
    // Auto-ocultar alertas
    ocultarAlertasAutomaticamente();
    
    // Configurar confirmaciones
    configurarConfirmaciones();
    
    console.log('Sistema listo - NELSON RODRIGUEZ');
});

// =================== VALIDACIONES BÁSICAS ===================

/**
 * Configurar validaciones simples en formularios
 */
function configurarValidaciones() {
    // Formatear NIT automáticamente
    const nitInput = document.getElementById('nitCliente');
    if (nitInput) {
        nitInput.addEventListener('input', function() {
            let valor = this.value.replace(/[^0-9]/g, '');
            if (valor.length > 9) {
                valor = valor.substring(0, 9) + '-' + valor.substring(9, 10);
            }
            this.value = valor;
        });
    }
    
    // Capitalizar nombres automáticamente
    const nombreInputs = document.querySelectorAll('input[name*="nombre"], input[name*="Cliente"]');
    nombreInputs.forEach(input => {
        input.addEventListener('blur', function() {
            this.value = capitalizarTexto(this.value);
        });
    });
    
    // Validar email básico
    const emailInput = document.getElementById('emailContacto');
    if (emailInput) {
        emailInput.addEventListener('blur', function() {
            if (this.value && !this.value.includes('@')) {
                this.setCustomValidity('Por favor ingresa un email válido');
            } else {
                this.setCustomValidity('');
            }
        });
    }
}

/**
 * Capitalizar primera letra de cada palabra
 */
function capitalizarTexto(texto) {
    return texto.toLowerCase().replace(/\b\w/g, l => l.toUpperCase());
}

// =================== CONFIRMACIONES ===================

/**
 * Configurar confirmaciones de eliminación
 */
function configurarConfirmaciones() {
    // Confirmación desde la lista de proyectos
    window.confirmarEliminacion = function(id, nombreObra) {
        const mensaje = `¿Estás seguro de eliminar el proyecto "${nombreObra}"?\n\nEsta acción no se puede deshacer.`;
        
        if (confirm(mensaje)) {
            window.location.href = `ProyectoServlet?accion=confirmarEliminar&id=${id}`;
        }
    };
    
    // Mostrar detalles en modal
    window.mostrarDetalles = function(id, nombreObra, direccionObra, nitCliente, nombreCliente, emailContacto, telefonoContacto, estado) {
        // Llenar datos del modal
        document.getElementById('detalleId').textContent = id;
        document.getElementById('detalleNombreObra').textContent = nombreObra;
        document.getElementById('detalleDireccionObra').textContent = direccionObra;
        document.getElementById('detalleNitCliente').textContent = nitCliente;
        document.getElementById('detalleNombreCliente').textContent = nombreCliente;
        document.getElementById('detalleEmailContacto').textContent = emailContacto || 'No especificado';
        document.getElementById('detalleTelefonoContacto').textContent = telefonoContacto || 'No especificado';
        
        // Mostrar estado con color
        const estadoElemento = document.getElementById('detalleEstado');
        let claseEstado = 'bg-secondary';
        if (estado === 'Activo') claseEstado = 'bg-success';
        else if (estado === 'Finalizado') claseEstado = 'bg-primary';
        else if (estado === 'Suspendido') claseEstado = 'bg-warning text-dark';
        
        estadoElemento.innerHTML = `<span class="badge ${claseEstado}">${estado}</span>`;
        
        // Mostrar modal
        const modal = new bootstrap.Modal(document.getElementById('modalDetalles'));
        modal.show();
    };
}

// =================== ALERTAS Y NOTIFICACIONES ===================

/**
 * Ocultar alertas automáticamente después de 5 segundos
 */
function ocultarAlertasAutomaticamente() {
    const alertas = document.querySelectorAll('.alert:not(.alert-countdown)');
    alertas.forEach(function(alerta) {
        setTimeout(function() {
            const bsAlert = new bootstrap.Alert(alerta);
            try {
                bsAlert.close();
            } catch (error) {
                // Si hay error, simplemente ocultar
                alerta.style.display = 'none';
            }
        }, 5000);
    });
}

// =================== EFECTOS SIMPLES ===================

/**
 * Mostrar loading en botones de envío
 */
document.addEventListener('submit', function(e) {
    const botonEnvio = e.target.querySelector('button[type="submit"]');
    if (botonEnvio) {
        botonEnvio.innerHTML = '<i class="fas fa-spinner fa-spin me-2"></i>Procesando...';
        botonEnvio.disabled = true;
    }
});

/**
 * Confirmar antes de limpiar formulario
 */
document.addEventListener('click', function(e) {
    if (e.target.type === 'reset') {
        if (!confirm('¿Estás seguro de limpiar todos los campos?')) {
            e.preventDefault();
        }
    }
});

// =================== NAVEGACIÓN ===================

/**
 * Atajos de teclado básicos
 */
document.addEventListener('keydown', function(e) {
    // ESC para cancelar
    if (e.key === 'Escape') {
        const botonCancelar = document.querySelector('a[href*="ProyectoServlet"]:not([href*="accion"])');
        if (botonCancelar) {
            window.location.href = botonCancelar.href;
        }
    }
});

/**
 * Prevenir pérdida de datos en formularios
 */
let formularioModificado = false;

document.addEventListener('input', function() {
    formularioModificado = true;
});

document.addEventListener('submit', function() {
    formularioModificado = false;
});

window.addEventListener('beforeunload', function(e) {
    if (formularioModificado) {
        e.preventDefault();
        e.returnValue = '¿Estás seguro de salir? Se perderán los cambios no guardados.';
    }
});

// =================== LOG ACADÉMICO ===================

console.log('=== CARTILLASACEROWEB INICIADO ===');
console.log('Desarrollador: NELSON RODRIGUEZ');
console.log('Evidencia: GA7-220501096-AA2-EV02');
console.log('Programa: Análisis y Desarrollo de Software - SENA');