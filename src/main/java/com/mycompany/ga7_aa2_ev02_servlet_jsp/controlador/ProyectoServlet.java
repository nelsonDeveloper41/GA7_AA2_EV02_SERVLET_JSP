package com.mycompany.ga7_aa2_ev02_servlet_jsp.controlador;



import com.mycompany.ga7_aa2_ev02_servlet_jsp.dao.ProyectoDAO;
import com.mycompany.ga7_aa2_ev02_servlet_jsp.modelo.Proyecto;
import com.mycompany.ga7_aa2_ev02_servlet_jsp.configuracion.InicializadorBD;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Servlet controlador principal para la gestión de proyectos.
 * 
 * Este servlet implementa el patrón MVC (Modelo-Vista-Controlador) actuando
 * como el controlador central que orquesta todas las operaciones CRUD sobre
 * los proyectos. Maneja tanto peticiones GET (para mostrar vistas) como
 * POST (para procesar formularios y modificar datos).
 * 
 * Mapeo de URLs:
 * - GET /ProyectoServlet → Listar todos los proyectos
 * - GET /ProyectoServlet?accion=nuevo → Mostrar formulario de creación
 * - GET /ProyectoServlet?accion=editar&id=X → Mostrar formulario de edición
 * - GET /ProyectoServlet?accion=confirmarEliminar&id=X → Confirmar eliminación
 * - POST /ProyectoServlet → Procesar formularios (crear/actualizar/eliminar)
 * 
 * Evidencia: GA7-220501096-AA2-EV02
 * Programa: Análisis y Desarrollo de Software - SENA
 */
@WebServlet(name = "ProyectoServlet", urlPatterns = {"/ProyectoServlet"})
public class ProyectoServlet extends HttpServlet {
    
    // =================== CONSTANTES ===================
    
    /**
     * Logger para registrar operaciones del servlet
     */
    private static final Logger LOGGER = Logger.getLogger(ProyectoServlet.class.getName());
    
    /**
     * Rutas de las páginas JSP
     */
    private static final String JSP_LISTA = "/listaProyectos.jsp";
    private static final String JSP_FORMULARIO = "/formProyecto.jsp";
    private static final String JSP_CONFIRMAR_ELIMINAR = "/confirmarEliminar.jsp";
    
    /**
     * Parámetros de petición
     */
    private static final String PARAM_ACCION = "accion";
    private static final String PARAM_ID = "id";
    
    /**
     * Acciones disponibles
     */
    private static final String ACCION_NUEVO = "nuevo";
    private static final String ACCION_EDITAR = "editar";
    private static final String ACCION_CONFIRMAR_ELIMINAR = "confirmarEliminar";
    private static final String ACCION_CREAR = "crear";
    private static final String ACCION_ACTUALIZAR = "actualizar";
    private static final String ACCION_ELIMINAR = "eliminar";
    
    /**
     * Atributos de request para pasar datos a las vistas
     */
    private static final String ATTR_PROYECTOS = "proyectos";
    private static final String ATTR_PROYECTO = "proyecto";
    private static final String ATTR_MENSAJE = "mensaje";
    private static final String ATTR_ERROR = "error";
    
    // =================== INSTANCIA DAO ===================
    
    /**
     * Instancia del DAO para operaciones de base de datos
     */
    private final ProyectoDAO proyectoDAO = new ProyectoDAO();
    
    // =================== INICIALIZACIÓN DEL SERVLET ===================
    
    /**
     * Inicializa el servlet y configura la base de datos si es necesario.
     */
    @Override
    public void init() throws ServletException {
        super.init();
        LOGGER.info("=== INICIANDO SERVLET DE PROYECTOS ===");
        
        // Verificar e inicializar la base de datos si es necesario
        try {
            if (!InicializadorBD.inicializarSistema()) {
                LOGGER.warning("No se pudo inicializar la base de datos automáticamente");
            }
        } catch (Exception e) {
            LOGGER.log(Level.WARNING, "Error durante la inicialización de BD: " + e.getMessage(), e);
        }
        
        LOGGER.info("Servlet ProyectoServlet inicializado correctamente");
    }
    
    // =================== MANEJO DE PETICIONES GET ===================
    
    /**
     * Maneja las peticiones HTTP GET.
     * 
     * Las peticiones GET se usan para mostrar vistas (páginas) al usuario:
     * - Sin parámetros: Muestra la lista de proyectos
     * - accion=nuevo: Muestra formulario para crear proyecto
     * - accion=editar&id=X: Muestra formulario pre-llenado para editar
     * - accion=confirmarEliminar&id=X: Muestra página de confirmación
     * 
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException si ocurre un error específico del servlet
     * @throws IOException si ocurre un error de I/O
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Configurar codificación para caracteres especiales
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");
        
        String accion = request.getParameter(PARAM_ACCION);
        
        LOGGER.info("GET - Procesando acción: " + (accion != null ? accion : "listar"));
        
        try {
            if (accion == null) {
                // Sin parámetro de acción: mostrar lista de proyectos
                mostrarListaProyectos(request, response);
                
            } else {
                switch (accion) {
                    case ACCION_NUEVO:
                        mostrarFormularioNuevo(request, response);
                        break;
                        
                    case ACCION_EDITAR:
                        mostrarFormularioEditar(request, response);
                        break;
                        
                    case ACCION_CONFIRMAR_ELIMINAR:
                        mostrarConfirmacionEliminacion(request, response);
                        break;
                        
                    default:
                        LOGGER.warning("Acción GET no reconocida: " + accion);
                        mostrarListaProyectos(request, response);
                        break;
                }
            }
            
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error en doGet: " + e.getMessage(), e);
            manejarError(request, response, "Error interno del servidor: " + e.getMessage());
        }
    }
    
    // =================== MANEJO DE PETICIONES POST ===================
    
    /**
     * Maneja las peticiones HTTP POST.
     * 
     * Las peticiones POST se usan para procesar formularios y modificar datos:
     * - accion=crear: Crea un nuevo proyecto
     * - accion=actualizar: Actualiza un proyecto existente
     * - accion=eliminar: Elimina un proyecto
     * 
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException si ocurre un error específico del servlet
     * @throws IOException si ocurre un error de I/O
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Configurar codificación para caracteres especiales
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");
        
        String accion = request.getParameter(PARAM_ACCION);
        
        LOGGER.info("POST - Procesando acción: " + accion);
        
        try {
            if (accion == null) {
                LOGGER.warning("Petición POST sin parámetro de acción");
                response.sendRedirect("ProyectoServlet");
                return;
            }
            
            switch (accion) {
                case ACCION_CREAR:
                    procesarCreacion(request, response);
                    break;
                    
                case ACCION_ACTUALIZAR:
                    procesarActualizacion(request, response);
                    break;
                    
                case ACCION_ELIMINAR:
                    procesarEliminacion(request, response);
                    break;
                    
                default:
                    LOGGER.warning("Acción POST no reconocida: " + accion);
                    response.sendRedirect("ProyectoServlet");
                    break;
            }
            
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error en doPost: " + e.getMessage(), e);
            manejarError(request, response, "Error al procesar la solicitud: " + e.getMessage());
        }
    }
    
    // =================== MÉTODOS PARA MOSTRAR VISTAS (GET) ===================
    
    /**
     * Muestra la lista de todos los proyectos.
     */
    private void mostrarListaProyectos(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        List<Proyecto> proyectos = proyectoDAO.listarTodos();
        
        request.setAttribute(ATTR_PROYECTOS, proyectos);
        
        LOGGER.info("Mostrando lista con " + proyectos.size() + " proyectos");
        
        RequestDispatcher dispatcher = request.getRequestDispatcher(JSP_LISTA);
        dispatcher.forward(request, response);
    }
    
    /**
     * Muestra el formulario para crear un nuevo proyecto.
     */
    private void mostrarFormularioNuevo(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // No se pasa proyecto, el JSP detectará que es nuevo
        LOGGER.info("Mostrando formulario para nuevo proyecto");
        
        RequestDispatcher dispatcher = request.getRequestDispatcher(JSP_FORMULARIO);
        dispatcher.forward(request, response);
    }
    
    /**
     * Muestra el formulario para editar un proyecto existente.
     */
    private void mostrarFormularioEditar(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String idParam = request.getParameter(PARAM_ID);
        
        try {
            int id = Integer.parseInt(idParam);
            Proyecto proyecto = proyectoDAO.obtenerPorId(id);
            
            if (proyecto != null) {
                request.setAttribute(ATTR_PROYECTO, proyecto);
                
                LOGGER.info("Mostrando formulario de edición para proyecto ID: " + id);
                
                RequestDispatcher dispatcher = request.getRequestDispatcher(JSP_FORMULARIO);
                dispatcher.forward(request, response);
            } else {
                LOGGER.warning("Proyecto no encontrado para edición: ID " + id);
                request.setAttribute(ATTR_ERROR, "Proyecto no encontrado");
                mostrarListaProyectos(request, response);
            }
            
        } catch (NumberFormatException e) {
            LOGGER.warning("ID inválido para edición: " + idParam);
            request.setAttribute(ATTR_ERROR, "ID de proyecto inválido");
            mostrarListaProyectos(request, response);
        }
    }
    
    /**
     * Muestra la página de confirmación para eliminar un proyecto.
     */
    private void mostrarConfirmacionEliminacion(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String idParam = request.getParameter(PARAM_ID);
        
        try {
            int id = Integer.parseInt(idParam);
            Proyecto proyecto = proyectoDAO.obtenerPorId(id);
            
            if (proyecto != null) {
                request.setAttribute(ATTR_PROYECTO, proyecto);
                
                LOGGER.info("Mostrando confirmación de eliminación para proyecto ID: " + id);
                
                RequestDispatcher dispatcher = request.getRequestDispatcher(JSP_CONFIRMAR_ELIMINAR);
                dispatcher.forward(request, response);
            } else {
                LOGGER.warning("Proyecto no encontrado para eliminación: ID " + id);
                request.setAttribute(ATTR_ERROR, "Proyecto no encontrado");
                mostrarListaProyectos(request, response);
            }
            
        } catch (NumberFormatException e) {
            LOGGER.warning("ID inválido para eliminación: " + idParam);
            request.setAttribute(ATTR_ERROR, "ID de proyecto inválido");
            mostrarListaProyectos(request, response);
        }
    }
    
    // =================== MÉTODOS PARA PROCESAR FORMULARIOS (POST) ===================
    
    /**
     * Procesa la creación de un nuevo proyecto.
     */
    private void procesarCreacion(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        
        Proyecto proyecto = construirProyectoDesdeRequest(request);
        
        if (proyecto != null && proyecto.esValido()) {
            if (proyectoDAO.crear(proyecto)) {
                LOGGER.info("Proyecto creado exitosamente: " + proyecto.getNombreObra());
                // Patrón POST-redirect-GET para evitar reenvío de formulario
                response.sendRedirect("ProyectoServlet");
            } else {
                LOGGER.warning("Error al crear proyecto: " + proyecto.getNombreObra());
                response.sendRedirect("ProyectoServlet?error=No se pudo crear el proyecto");
            }
        } else {
            LOGGER.warning("Datos inválidos para crear proyecto");
            response.sendRedirect("ProyectoServlet?error=Datos de proyecto inválidos");
        }
    }
    
    /**
     * Procesa la actualización de un proyecto existente.
     */
    private void procesarActualizacion(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        
        String idParam = request.getParameter(PARAM_ID);
        
        try {
            int id = Integer.parseInt(idParam);
            Proyecto proyecto = construirProyectoDesdeRequest(request);
            
            if (proyecto != null && proyecto.esValido()) {
                proyecto.setId(id);
                
                if (proyectoDAO.actualizar(proyecto)) {
                    LOGGER.info("Proyecto actualizado exitosamente: ID " + id);
                    response.sendRedirect("ProyectoServlet");
                } else {
                    LOGGER.warning("Error al actualizar proyecto: ID " + id);
                    response.sendRedirect("ProyectoServlet?error=No se pudo actualizar el proyecto");
                }
            } else {
                LOGGER.warning("Datos inválidos para actualizar proyecto: ID " + id);
                response.sendRedirect("ProyectoServlet?error=Datos de proyecto inválidos");
            }
            
        } catch (NumberFormatException e) {
            LOGGER.warning("ID inválido para actualización: " + idParam);
            response.sendRedirect("ProyectoServlet?error=ID de proyecto inválido");
        }
    }
    
    /**
     * Procesa la eliminación de un proyecto.
     */
    private void procesarEliminacion(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        
        String idParam = request.getParameter(PARAM_ID);
        
        try {
            int id = Integer.parseInt(idParam);
            
            if (proyectoDAO.eliminar(id)) {
                LOGGER.info("Proyecto eliminado exitosamente: ID " + id);
                response.sendRedirect("ProyectoServlet");
            } else {
                LOGGER.warning("Error al eliminar proyecto: ID " + id);
                response.sendRedirect("ProyectoServlet?error=No se pudo eliminar el proyecto");
            }
            
        } catch (NumberFormatException e) {
            LOGGER.warning("ID inválido para eliminación: " + idParam);
            response.sendRedirect("ProyectoServlet?error=ID de proyecto inválido");
        }
    }
    
    // =================== MÉTODOS AUXILIARES ===================
    
    /**
     * Construye un objeto Proyecto a partir de los parámetros del request.
     * 
     * @param request el request HTTP con los parámetros del formulario
     * @return objeto Proyecto construido, o null si hay errores
     */
    private Proyecto construirProyectoDesdeRequest(HttpServletRequest request) {
        try {
            String nombreObra = obtenerParametroLimpio(request, "nombreObra");
            String direccionObra = obtenerParametroLimpio(request, "direccionObra");
            String nitCliente = obtenerParametroLimpio(request, "nitCliente");
            String nombreCliente = obtenerParametroLimpio(request, "nombreCliente");
            String emailContacto = obtenerParametroLimpio(request, "emailContacto");
            String telefonoContacto = obtenerParametroLimpio(request, "telefonoContacto");
            
            return new Proyecto(nombreObra, direccionObra, nitCliente, 
                              nombreCliente, emailContacto, telefonoContacto);
            
        } catch (Exception e) {
            LOGGER.log(Level.WARNING, "Error al construir proyecto desde request: " + e.getMessage(), e);
            return null;
        }
    }
    
    /**
     * Obtiene un parámetro del request y lo limpia (trim).
     * 
     * @param request el request HTTP
     * @param nombreParametro el nombre del parámetro
     * @return el valor del parámetro limpio, o cadena vacía si es null
     */
    private String obtenerParametroLimpio(HttpServletRequest request, String nombreParametro) {
        String valor = request.getParameter(nombreParametro);
        return valor != null ? valor.trim() : "";
    }
    
    /**
     * Maneja errores mostrando una página de error básica.
     * 
     * @param request el request HTTP
     * @param response el response HTTP
     * @param mensajeError el mensaje de error a mostrar
     */
    private void manejarError(HttpServletRequest request, HttpServletResponse response, 
                             String mensajeError) throws ServletException, IOException {
        
        request.setAttribute(ATTR_ERROR, mensajeError);
        
        try {
            mostrarListaProyectos(request, response);
        } catch (Exception e) {
            // Si no se puede mostrar la lista, enviar error HTTP
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, mensajeError);
        }
    }
    
    /**
     * Información del servlet.
     */
    @Override
    public String getServletInfo() {
        return "ProyectoServlet - Controlador principal para gestión de proyectos de CartillasAceroWeb";
    }
}