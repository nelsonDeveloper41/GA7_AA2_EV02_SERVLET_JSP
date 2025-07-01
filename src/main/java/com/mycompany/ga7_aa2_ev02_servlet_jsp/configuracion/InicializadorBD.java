package com.mycompany.ga7_aa2_ev02_servlet_jsp.configuracion;



import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Clase utilitaria para la inicialización automática de la base de datos.
 * 
 * Esta clase se encarga de crear automáticamente la base de datos y las tablas
 * necesarias para el sistema CartillasAceroWeb, así como insertar datos de
 * prueba iniciales para facilitar las demostraciones académicas.
 * 
 * Evidencia: GA7-220501096-AA2-EV02
 * Autor: [Nombre del Aprendiz]
 * Programa: Análisis y Desarrollo de Software - SENA
 */
public class InicializadorBD {
    
    // =================== CONSTANTES ===================
    
    /**
     * Logger para registrar el proceso de inicialización
     */
    private static final Logger LOGGER = Logger.getLogger(InicializadorBD.class.getName());
    
    /**
     * Script SQL para crear la base de datos
     */
    private static final String SQL_CREAR_BASE_DATOS = 
        "CREATE DATABASE IF NOT EXISTS cartillasAceroWebEV02 " +
        "CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci";
    
    /**
     * Script SQL para crear la tabla proyectos
     */
    private static final String SQL_CREAR_TABLA_PROYECTOS = 
        "CREATE TABLE IF NOT EXISTS proyectos (" +
        "id INT AUTO_INCREMENT PRIMARY KEY, " +
        "nombreObra VARCHAR(200) NOT NULL, " +
        "direccionObra VARCHAR(300) NOT NULL, " +
        "nitCliente VARCHAR(20) NOT NULL, " +
        "nombreCliente VARCHAR(200) NOT NULL, " +
        "emailContacto VARCHAR(100), " +
        "telefonoContacto VARCHAR(20), " +
        "fechaCreacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP, " +
        "estado VARCHAR(30) DEFAULT 'Activo', " +
        "INDEX idx_nitCliente (nitCliente), " +
        "INDEX idx_estado (estado)" +
        ") ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci";
    
    /**
     * Script SQL para insertar datos de prueba
     */
    private static final String SQL_INSERTAR_PROYECTO = 
        "INSERT INTO proyectos (nombreObra, direccionObra, nitCliente, nombreCliente, " +
        "emailContacto, telefonoContacto) VALUES (?, ?, ?, ?, ?, ?)";
    
    // =================== CONSTRUCTOR PRIVADO ===================
    
    /**
     * Constructor privado para prevenir instanciación de la clase utilitaria
     */
    private InicializadorBD() {
        // Clase utilitaria - no debe ser instanciada
    }
    
    // =================== MÉTODOS PÚBLICOS ===================
    
    /**
     * Inicializa completamente la base de datos del sistema.
     * 
     * Este método ejecuta todos los pasos necesarios para configurar
     * la base de datos desde cero:
     * 1. Crea la base de datos si no existe
     * 2. Crea las tablas necesarias
     * 3. Inserta datos de prueba iniciales
     * 
     * @return true si la inicialización fue exitosa, false en caso contrario
     */
    public static boolean inicializarSistema() {
        LOGGER.info("=== INICIANDO CONFIGURACIÓN DE BASE DE DATOS ===");
        
        try {
            // Paso 1: Crear base de datos
            if (!crearBaseDatos()) {
                LOGGER.severe("Error al crear la base de datos");
                return false;
            }
            
            // Paso 2: Crear tablas
            if (!crearTablas()) {
                LOGGER.severe("Error al crear las tablas");
                return false;
            }
            
            // Paso 3: Insertar datos de prueba
            if (!insertarDatosPrueba()) {
                LOGGER.warning("Error al insertar datos de prueba (no crítico)");
                // No retornamos false aquí porque los datos de prueba no son críticos
            }
            
            LOGGER.info("=== CONFIGURACIÓN DE BASE DE DATOS COMPLETADA EXITOSAMENTE ===");
            return true;
            
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error inesperado durante la inicialización", e);
            return false;
        }
    }
    
    /**
     * Crea la base de datos del sistema si no existe.
     * 
     * @return true si la base de datos fue creada o ya existía
     */
    public static boolean crearBaseDatos() {
        LOGGER.info("Paso 1: Creando base de datos...");
        
        Connection conexion = null;
        Statement statement = null;
        
        try {
            // Conectar al servidor MySQL (sin base de datos específica)
            conexion = ConexionDB.obtenerConexionServidor();
            statement = conexion.createStatement();
            
            // Ejecutar script de creación de base de datos
            statement.executeUpdate(SQL_CREAR_BASE_DATOS);
            
            LOGGER.info("✓ Base de datos 'cartillasAceroWebEV02' creada/verificada exitosamente");
            return true;
            
        } catch (SQLException | ClassNotFoundException e) {
            LOGGER.log(Level.SEVERE, "Error al crear la base de datos: " + e.getMessage(), e);
            return false;
        } finally {
            cerrarRecursos(null, statement, conexion);
        }
    }
    
    /**
     * Crea todas las tablas necesarias del sistema.
     * 
     * @return true si las tablas fueron creadas exitosamente
     */
    public static boolean crearTablas() {
        LOGGER.info("Paso 2: Creando tablas...");
        
        Connection conexion = null;
        Statement statement = null;
        
        try {
            // Conectar a la base de datos específica
            conexion = ConexionDB.obtenerConexion();
            statement = conexion.createStatement();
            
            // Crear tabla proyectos
            statement.executeUpdate(SQL_CREAR_TABLA_PROYECTOS);
            
            LOGGER.info("✓ Tabla 'proyectos' creada/verificada exitosamente");
            return true;
            
        } catch (SQLException | ClassNotFoundException e) {
            LOGGER.log(Level.SEVERE, "Error al crear las tablas: " + e.getMessage(), e);
            return false;
        } finally {
            cerrarRecursos(null, statement, conexion);
        }
    }
    
    /**
     * Inserta datos de prueba iniciales en el sistema.
     * 
     * @return true si los datos fueron insertados exitosamente
     */
    public static boolean insertarDatosPrueba() {
        LOGGER.info("Paso 3: Insertando datos de prueba...");
        
        Connection conexion = null;
        PreparedStatement statement = null;
        
        try {
            conexion = ConexionDB.obtenerConexion();
            
            // Verificar si ya existen datos
            if (yaExistenDatos(conexion)) {
                LOGGER.info("Los datos de prueba ya existen, omitiendo inserción");
                return true;
            }
            
            statement = conexion.prepareStatement(SQL_INSERTAR_PROYECTO);
            
            // Datos de prueba realistas para proyectos de construcción
            Object[][] datosPrueba = {
                {
                    "Edificio Residencial Alameda", 
                    "Calle 93 #15-47, Bogotá D.C.", 
                    "900123456-1", 
                    "Constructora Moderna S.A.S.", 
                    "proyectos@constructoramoderna.com", 
                    "3101234567"
                },
                {
                    "Centro Comercial Plaza Norte", 
                    "Autopista Norte Km 18, Chía, Cundinamarca", 
                    "800987654-3", 
                    "Ingeniería y Construcciones Ltda.", 
                    "info@ingenieriaconstrucciones.com", 
                    "3109876543"
                },
                {
                    "Puente Vehicular Río Magdalena", 
                    "Vía Girardot - Flandes, Cundinamarca", 
                    "890456789-2", 
                    "Obras Civiles del Tolima S.A.", 
                    "obras@civilestolima.gov.co", 
                    "3187654321"
                }
            };
            
            // Insertar cada proyecto de prueba
            for (Object[] proyecto : datosPrueba) {
                for (int i = 0; i < proyecto.length; i++) {
                    statement.setString(i + 1, (String) proyecto[i]);
                }
                statement.executeUpdate();
            }
            
            LOGGER.info("✓ " + datosPrueba.length + " proyectos de prueba insertados exitosamente");
            return true;
            
        } catch (SQLException | ClassNotFoundException e) {
            LOGGER.log(Level.WARNING, "Error al insertar datos de prueba: " + e.getMessage(), e);
            return false;
        } finally {
            cerrarRecursos(statement, null, conexion);
        }
    }
    
    /**
     * Verifica si ya existen datos en la tabla proyectos.
     * 
     * @param conexion la conexión a la base de datos
     * @return true si la tabla contiene registros
     */
    private static boolean yaExistenDatos(Connection conexion) throws SQLException {
        try (Statement stmt = conexion.createStatement();
             var rs = stmt.executeQuery("SELECT COUNT(*) FROM proyectos")) {
            
            if (rs.next()) {
                int count = rs.getInt(1);
                return count > 0;
            }
            return false;
        }
    }
    
    /**
     * Elimina todas las tablas del sistema (útil para testing).
     * ¡CUIDADO! Este método elimina todos los datos.
     * 
     * @return true si las tablas fueron eliminadas exitosamente
     */
    public static boolean limpiarBaseDatos() {
        LOGGER.warning("ADVERTENCIA: Eliminando todas las tablas del sistema");
        
        Connection conexion = null;
        Statement statement = null;
        
        try {
            conexion = ConexionDB.obtenerConexion();
            statement = conexion.createStatement();
            
            // Desactivar verificación de foreign keys temporalmente
            statement.executeUpdate("SET FOREIGN_KEY_CHECKS = 0");
            
            // Eliminar tabla proyectos
            statement.executeUpdate("DROP TABLE IF EXISTS proyectos");
            
            // Reactivar verificación de foreign keys
            statement.executeUpdate("SET FOREIGN_KEY_CHECKS = 1");
            
            LOGGER.info("✓ Base de datos limpiada exitosamente");
            return true;
            
        } catch (SQLException | ClassNotFoundException e) {
            LOGGER.log(Level.SEVERE, "Error al limpiar la base de datos: " + e.getMessage(), e);
            return false;
        } finally {
            cerrarRecursos(null, statement, conexion);
        }
    }
    
    /**
     * Reinicializa completamente el sistema (limpia y vuelve a crear todo).
     * 
     * @return true si la reinicialización fue exitosa
     */
    public static boolean reinicializarSistema() {
        LOGGER.info("=== REINICIALIZANDO SISTEMA COMPLETO ===");
        
        if (!limpiarBaseDatos()) {
            LOGGER.severe("Error durante la limpieza del sistema");
            return false;
        }
        
        return inicializarSistema();
    }
    
    // =================== MÉTODOS PRIVADOS ===================
    
    /**
     * Cierra de manera segura los recursos de base de datos.
     * 
     * @param ps PreparedStatement a cerrar
     * @param stmt Statement a cerrar  
     * @param conn Connection a cerrar
     */
    private static void cerrarRecursos(PreparedStatement ps, Statement stmt, Connection conn) {
        try {
            if (ps != null) ps.close();
            if (stmt != null) stmt.close();
            if (conn != null) conn.close();
        } catch (SQLException e) {
            LOGGER.log(Level.WARNING, "Error al cerrar recursos: " + e.getMessage(), e);
        }
    }
    
    // =================== MÉTODO PRINCIPAL PARA PRUEBAS ===================
    
    /**
     * Método principal para ejecutar la inicialización de manera independiente.
     * Útil para pruebas y configuración inicial del sistema.
     * 
     * @param args argumentos de línea de comandos (no utilizados)
     */
    public static void main(String[] args) {
        System.out.println("=== INICIALIZADOR DE BASE DE DATOS - CARTILLAS ACERO WEB ===");
        System.out.println("Evidencia: GA7-220501096-AA2-EV02");
        System.out.println();
        
        if (inicializarSistema()) {
            System.out.println("✅ Sistema inicializado correctamente");
            System.out.println("La aplicación web está lista para usarse");
        } else {
            System.out.println("❌ Error durante la inicialización");
            System.out.println("Revise los logs para más detalles");
        }
    }
}