package com.mycompany.ga7_aa2_ev02_servlet_jsp.configuracion;



import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Clase utilitaria para gestionar las conexiones a la base de datos MySQL.
 * 
 * Esta clase centraliza toda la configuración de conexión a la base de datos
 * del sistema CartillasAceroWeb, proporcionando métodos estáticos para
 * obtener conexiones de manera segura y eficiente.
 * 
 * Evidencia: GA7-220501096-AA2-EV02
 * Programa: Análisis y Desarrollo de Software - SENA
 */
public class ConexionDB {
    
    // =================== CONSTANTES DE CONFIGURACIÓN ===================
    
    /**
     * URL del servidor de base de datos MySQL
     */
    private static final String URL_SERVIDOR = "jdbc:mysql://localhost:3306/";
    
    /**
     * Nombre de la base de datos específica del proyecto
     */
    private static final String NOMBRE_BD = "cartillasAceroWebEV02";
    
    /**
     * URL completa de conexión a la base de datos
     */
    private static final String URL_COMPLETA = URL_SERVIDOR + NOMBRE_BD;
    
    /**
     * Usuario de la base de datos (por defecto en XAMPP)
     */
    private static final String USUARIO = "root";
    
    /**
     * Contraseña de la base de datos (vacía por defecto en XAMPP)
     */
    private static final String PASSWORD = "";
    
    /**
     * Driver JDBC para MySQL
     */
    private static final String DRIVER_MYSQL = "com.mysql.cj.jdbc.Driver";
    
    /**
     * Logger para registrar eventos y errores de conexión
     */
    private static final Logger LOGGER = Logger.getLogger(ConexionDB.class.getName());
    
    // =================== CONSTRUCTOR PRIVADO ===================
    
    /**
     * Constructor privado para prevenir instanciación de la clase utilitaria
     */
    private ConexionDB() {
        // Clase utilitaria - no debe ser instanciada
    }
    
    // =================== MÉTODOS PÚBLICOS ===================
    
    /**
     * Obtiene una nueva conexión a la base de datos principal.
     * 
     * Este método establece una conexión a la base de datos específica
     * del proyecto (cartillasAceroWebEV02). La conexión debe ser cerrada
     * por el código que la invoca para evitar fugas de memoria.
     * 
     * @return Connection objeto de conexión a la base de datos
     * @throws SQLException si ocurre un error al conectar con la base de datos
     * @throws ClassNotFoundException si no se encuentra el driver de MySQL
     */
    public static Connection obtenerConexion() throws SQLException, ClassNotFoundException {
        try {
            // Cargar el driver de MySQL
            Class.forName(DRIVER_MYSQL);
            
            // Establecer la conexión con parámetros adicionales para compatibilidad
            String urlConParametros = URL_COMPLETA + 
                "?useSSL=false" +           // Deshabilitar SSL para desarrollo local
                "&serverTimezone=UTC" +     // Configurar zona horaria
                "&allowPublicKeyRetrieval=true"; // Permitir recuperación de clave pública
            
            Connection conexion = DriverManager.getConnection(urlConParametros, USUARIO, PASSWORD);
            
            LOGGER.info("Conexión exitosa a la base de datos: " + NOMBRE_BD);
            return conexion;
            
        } catch (ClassNotFoundException e) {
            LOGGER.log(Level.SEVERE, "Error: No se encontró el driver de MySQL", e);
            throw e;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error al conectar con la base de datos: " + e.getMessage(), e);
            throw e;
        }
    }
    
    /**
     * Obtiene una conexión al servidor MySQL (sin especificar base de datos).
     * 
     * Este método es útil para operaciones administrativas como crear
     * la base de datos. Se conecta al servidor MySQL pero no a una
     * base de datos específica.
     * 
     * @return Connection objeto de conexión al servidor MySQL
     * @throws SQLException si ocurre un error al conectar con el servidor
     * @throws ClassNotFoundException si no se encuentra el driver de MySQL
     */
    public static Connection obtenerConexionServidor() throws SQLException, ClassNotFoundException {
        try {
            // Cargar el driver de MySQL
            Class.forName(DRIVER_MYSQL);
            
            // Conectar solo al servidor (sin base de datos específica)
            String urlServidor = URL_SERVIDOR + 
                "?useSSL=false" +
                "&serverTimezone=UTC" +
                "&allowPublicKeyRetrieval=true";
            
            Connection conexion = DriverManager.getConnection(urlServidor, USUARIO, PASSWORD);
            
            LOGGER.info("Conexión exitosa al servidor MySQL");
            return conexion;
            
        } catch (ClassNotFoundException e) {
            LOGGER.log(Level.SEVERE, "Error: No se encontró el driver de MySQL", e);
            throw e;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error al conectar con el servidor MySQL: " + e.getMessage(), e);
            throw e;
        }
    }
    
    /**
     * Cierra de manera segura una conexión a la base de datos.
     * 
     * Este método verifica que la conexión no sea nula y que esté abierta
     * antes de intentar cerrarla, registrando cualquier error que ocurra.
     * 
     * @param conexion la conexión a cerrar
     */
    public static void cerrarConexion(Connection conexion) {
        if (conexion != null) {
            try {
                if (!conexion.isClosed()) {
                    conexion.close();
                    LOGGER.info("Conexión cerrada correctamente");
                }
            } catch (SQLException e) {
                LOGGER.log(Level.WARNING, "Error al cerrar la conexión: " + e.getMessage(), e);
            }
        }
    }
    
    /**
     * Prueba la conectividad con la base de datos.
     * 
     * Este método intenta establecer una conexión y la cierra inmediatamente
     * para verificar que la configuración sea correcta.
     * 
     * @return true si la conexión es exitosa, false en caso contrario
     */
    public static boolean probarConexion() {
        Connection conexion = null;
        try {
            conexion = obtenerConexion();
            LOGGER.info("Prueba de conexión exitosa");
            return true;
        } catch (SQLException | ClassNotFoundException e) {
            LOGGER.log(Level.SEVERE, "Fallo en la prueba de conexión: " + e.getMessage(), e);
            return false;
        } finally {
            cerrarConexion(conexion);
        }
    }
    
    // =================== MÉTODOS DE INFORMACIÓN ===================
    
    /**
     * Obtiene el nombre de la base de datos configurada.
     * 
     * @return el nombre de la base de datos
     */
    public static String obtenerNombreBaseDatos() {
        return NOMBRE_BD;
    }
    
    /**
     * Obtiene la URL completa de conexión (sin credenciales).
     * 
     * @return la URL de conexión configurada
     */
    public static String obtenerUrlConexion() {
        return URL_COMPLETA;
    }
    
    /**
     * Obtiene información sobre la configuración de conexión.
     * 
     * @return String con los detalles de configuración (sin contraseña)
     */
    public static String obtenerInformacionConfiguracion() {
        return String.format(
            "Configuración de Base de Datos:%n" +
            "- Servidor: %s%n" +
            "- Base de Datos: %s%n" +
            "- Usuario: %s%n" +
            "- Driver: %s",
            URL_SERVIDOR, NOMBRE_BD, USUARIO, DRIVER_MYSQL
        );
    }
}