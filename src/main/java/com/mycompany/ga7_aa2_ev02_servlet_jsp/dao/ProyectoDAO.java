package com.mycompany.ga7_aa2_ev02_servlet_jsp.dao;



import com.mycompany.ga7_aa2_ev02_servlet_jsp.configuracion.ConexionDB;
import com.mycompany.ga7_aa2_ev02_servlet_jsp.modelo.Proyecto;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Clase DAO (Data Access Object) para la gestión de proyectos en la base de datos.
 * 
 * Esta clase implementa el patrón DAO para encapsular toda la lógica de acceso
 * a datos relacionada con la entidad Proyecto. Proporciona métodos para realizar
 * operaciones CRUD (Create, Read, Update, Delete) de manera segura utilizando
 * PreparedStatement para prevenir inyección SQL.
 * 
 * Evidencia: GA7-220501096-AA2-EV02
 * Programa: Análisis y Desarrollo de Software - SENA
 */
public class ProyectoDAO {
    
    // =================== CONSTANTES SQL ===================
    
    /**
     * SQL para insertar un nuevo proyecto
     */
    private static final String SQL_INSERTAR = 
        "INSERT INTO proyectos (nombreObra, direccionObra, nitCliente, nombreCliente, " +
        "emailContacto, telefonoContacto) VALUES (?, ?, ?, ?, ?, ?)";
    
    /**
     * SQL para obtener todos los proyectos ordenados por fecha de creación
     */
    private static final String SQL_LISTAR_TODOS = 
        "SELECT id, nombreObra, direccionObra, nitCliente, nombreCliente, " +
        "emailContacto, telefonoContacto, fechaCreacion, estado " +
        "FROM proyectos ORDER BY fechaCreacion DESC";
    
    /**
     * SQL para obtener un proyecto por su ID
     */
    private static final String SQL_OBTENER_POR_ID = 
        "SELECT id, nombreObra, direccionObra, nitCliente, nombreCliente, " +
        "emailContacto, telefonoContacto, fechaCreacion, estado " +
        "FROM proyectos WHERE id = ?";
    
    /**
     * SQL para actualizar un proyecto existente
     */
    private static final String SQL_ACTUALIZAR = 
        "UPDATE proyectos SET nombreObra = ?, direccionObra = ?, nitCliente = ?, " +
        "nombreCliente = ?, emailContacto = ?, telefonoContacto = ? WHERE id = ?";
    
    /**
     * SQL para eliminar un proyecto por su ID
     */
    private static final String SQL_ELIMINAR = 
        "DELETE FROM proyectos WHERE id = ?";
    
    /**
     * SQL para verificar si existe un proyecto con un NIT específico
     */
    private static final String SQL_EXISTE_NIT = 
        "SELECT COUNT(*) FROM proyectos WHERE nitCliente = ? AND id != ?";
    
    /**
     * SQL para contar el total de proyectos
     */
    private static final String SQL_CONTAR_PROYECTOS = 
        "SELECT COUNT(*) FROM proyectos";
    
    /**
     * SQL para buscar proyectos por nombre de obra
     */
    private static final String SQL_BUSCAR_POR_NOMBRE = 
        "SELECT id, nombreObra, direccionObra, nitCliente, nombreCliente, " +
        "emailContacto, telefonoContacto, fechaCreacion, estado " +
        "FROM proyectos WHERE nombreObra LIKE ? ORDER BY fechaCreacion DESC";
    
    /**
     * Logger para registrar operaciones y errores
     */
    private static final Logger LOGGER = Logger.getLogger(ProyectoDAO.class.getName());
    
    // =================== MÉTODOS CRUD ===================
    
    /**
     * Inserta un nuevo proyecto en la base de datos.
     * 
     * @param proyecto el objeto Proyecto a insertar (sin ID)
     * @return true si la inserción fue exitosa, false en caso contrario
     */
    public boolean crear(Proyecto proyecto) {
        if (proyecto == null || !proyecto.esValido()) {
            LOGGER.warning("Intento de insertar un proyecto nulo o inválido");
            return false;
        }
        
        Connection conexion = null;
        PreparedStatement statement = null;
        
        try {
            conexion = ConexionDB.obtenerConexion();
            statement = conexion.prepareStatement(SQL_INSERTAR, Statement.RETURN_GENERATED_KEYS);
            
            // Establecer parámetros del PreparedStatement
            statement.setString(1, proyecto.getNombreObra());
            statement.setString(2, proyecto.getDireccionObra());
            statement.setString(3, proyecto.getNitCliente());
            statement.setString(4, proyecto.getNombreCliente());
            statement.setString(5, proyecto.getEmailContacto());
            statement.setString(6, proyecto.getTelefonoContacto());
            
            // Ejecutar la inserción
            int filasAfectadas = statement.executeUpdate();
            
            if (filasAfectadas > 0) {
                // Obtener el ID generado automáticamente
                try (ResultSet generatedKeys = statement.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        proyecto.setId(generatedKeys.getInt(1));
                    }
                }
                
                LOGGER.info("Proyecto creado exitosamente: " + proyecto.getNombreObra() + 
                           " (ID: " + proyecto.getId() + ")");
                return true;
            }
            
            return false;
            
        } catch (SQLException | ClassNotFoundException e) {
            LOGGER.log(Level.SEVERE, "Error al crear proyecto: " + e.getMessage(), e);
            return false;
        } finally {
            cerrarRecursos(statement, conexion);
        }
    }
    
    /**
     * Obtiene todos los proyectos de la base de datos.
     * 
     * @return Lista de todos los proyectos, ordenados por fecha de creación descendente
     */
    public List<Proyecto> listarTodos() {
        List<Proyecto> proyectos = new ArrayList<>();
        Connection conexion = null;
        PreparedStatement statement = null;
        ResultSet resultSet = null;
        
        try {
            conexion = ConexionDB.obtenerConexion();
            statement = conexion.prepareStatement(SQL_LISTAR_TODOS);
            resultSet = statement.executeQuery();
            
            while (resultSet.next()) {
                Proyecto proyecto = mapearResultSetAProyecto(resultSet);
                proyectos.add(proyecto);
            }
            
            LOGGER.info("Se obtuvieron " + proyectos.size() + " proyectos de la base de datos");
            
        } catch (SQLException | ClassNotFoundException e) {
            LOGGER.log(Level.SEVERE, "Error al listar proyectos: " + e.getMessage(), e);
        } finally {
            cerrarRecursos(resultSet, statement, conexion);
        }
        
        return proyectos;
    }
    
    /**
     * Obtiene un proyecto específico por su ID.
     * 
     * @param id el identificador único del proyecto
     * @return el proyecto encontrado, o null si no existe
     */
    public Proyecto obtenerPorId(int id) {
        if (id <= 0) {
            LOGGER.warning("ID de proyecto inválido: " + id);
            return null;
        }
        
        Connection conexion = null;
        PreparedStatement statement = null;
        ResultSet resultSet = null;
        
        try {
            conexion = ConexionDB.obtenerConexion();
            statement = conexion.prepareStatement(SQL_OBTENER_POR_ID);
            statement.setInt(1, id);
            
            resultSet = statement.executeQuery();
            
            if (resultSet.next()) {
                Proyecto proyecto = mapearResultSetAProyecto(resultSet);
                LOGGER.info("Proyecto encontrado: " + proyecto.getNombreObra() + " (ID: " + id + ")");
                return proyecto;
            } else {
                LOGGER.warning("No se encontró proyecto con ID: " + id);
                return null;
            }
            
        } catch (SQLException | ClassNotFoundException e) {
            LOGGER.log(Level.SEVERE, "Error al obtener proyecto por ID: " + e.getMessage(), e);
            return null;
        } finally {
            cerrarRecursos(resultSet, statement, conexion);
        }
    }
    
    /**
     * Actualiza un proyecto existente en la base de datos.
     * 
     * @param proyecto el objeto Proyecto con los datos actualizados
     * @return true si la actualización fue exitosa, false en caso contrario
     */
    public boolean actualizar(Proyecto proyecto) {
        if (proyecto == null || !proyecto.esValido() || proyecto.getId() <= 0) {
            LOGGER.warning("Intento de actualizar un proyecto nulo, inválido o sin ID");
            return false;
        }
        
        Connection conexion = null;
        PreparedStatement statement = null;
        
        try {
            conexion = ConexionDB.obtenerConexion();
            statement = conexion.prepareStatement(SQL_ACTUALIZAR);
            
            // Establecer parámetros del PreparedStatement
            statement.setString(1, proyecto.getNombreObra());
            statement.setString(2, proyecto.getDireccionObra());
            statement.setString(3, proyecto.getNitCliente());
            statement.setString(4, proyecto.getNombreCliente());
            statement.setString(5, proyecto.getEmailContacto());
            statement.setString(6, proyecto.getTelefonoContacto());
            statement.setInt(7, proyecto.getId());
            
            // Ejecutar la actualización
            int filasAfectadas = statement.executeUpdate();
            
            if (filasAfectadas > 0) {
                LOGGER.info("Proyecto actualizado exitosamente: " + proyecto.getNombreObra() + 
                           " (ID: " + proyecto.getId() + ")");
                return true;
            } else {
                LOGGER.warning("No se encontró proyecto para actualizar con ID: " + proyecto.getId());
                return false;
            }
            
        } catch (SQLException | ClassNotFoundException e) {
            LOGGER.log(Level.SEVERE, "Error al actualizar proyecto: " + e.getMessage(), e);
            return false;
        } finally {
            cerrarRecursos(statement, conexion);
        }
    }
    
    /**
     * Elimina un proyecto de la base de datos.
     * 
     * @param id el identificador único del proyecto a eliminar
     * @return true si la eliminación fue exitosa, false en caso contrario
     */
    public boolean eliminar(int id) {
        if (id <= 0) {
            LOGGER.warning("ID de proyecto inválido para eliminación: " + id);
            return false;
        }
        
        Connection conexion = null;
        PreparedStatement statement = null;
        
        try {
            conexion = ConexionDB.obtenerConexion();
            statement = conexion.prepareStatement(SQL_ELIMINAR);
            statement.setInt(1, id);
            
            int filasAfectadas = statement.executeUpdate();
            
            if (filasAfectadas > 0) {
                LOGGER.info("Proyecto eliminado exitosamente (ID: " + id + ")");
                return true;
            } else {
                LOGGER.warning("No se encontró proyecto para eliminar con ID: " + id);
                return false;
            }
            
        } catch (SQLException | ClassNotFoundException e) {
            LOGGER.log(Level.SEVERE, "Error al eliminar proyecto: " + e.getMessage(), e);
            return false;
        } finally {
            cerrarRecursos(statement, conexion);
        }
    }
    
    // =================== MÉTODOS AUXILIARES ===================
    
    /**
     * Verifica si existe un proyecto con el NIT especificado (excluyendo un ID).
     * 
     * @param nitCliente el NIT a verificar
     * @param idExcluir ID a excluir de la búsqueda (útil para actualizaciones)
     * @return true si existe otro proyecto con el mismo NIT
     */
    public boolean existeProyectoConNit(String nitCliente, int idExcluir) {
        if (nitCliente == null || nitCliente.trim().isEmpty()) {
            return false;
        }
        
        Connection conexion = null;
        PreparedStatement statement = null;
        ResultSet resultSet = null;
        
        try {
            conexion = ConexionDB.obtenerConexion();
            statement = conexion.prepareStatement(SQL_EXISTE_NIT);
            statement.setString(1, nitCliente);
            statement.setInt(2, idExcluir);
            
            resultSet = statement.executeQuery();
            
            if (resultSet.next()) {
                return resultSet.getInt(1) > 0;
            }
            
        } catch (SQLException | ClassNotFoundException e) {
            LOGGER.log(Level.WARNING, "Error al verificar NIT duplicado: " + e.getMessage(), e);
        } finally {
            cerrarRecursos(resultSet, statement, conexion);
        }
        
        return false;
    }
    
    /**
     * Cuenta el total de proyectos en la base de datos.
     * 
     * @return el número total de proyectos
     */
    public int contarProyectos() {
        Connection conexion = null;
        PreparedStatement statement = null;
        ResultSet resultSet = null;
        
        try {
            conexion = ConexionDB.obtenerConexion();
            statement = conexion.prepareStatement(SQL_CONTAR_PROYECTOS);
            resultSet = statement.executeQuery();
            
            if (resultSet.next()) {
                return resultSet.getInt(1);
            }
            
        } catch (SQLException | ClassNotFoundException e) {
            LOGGER.log(Level.WARNING, "Error al contar proyectos: " + e.getMessage(), e);
        } finally {
            cerrarRecursos(resultSet, statement, conexion);
        }
        
        return 0;
    }
    
    /**
     * Busca proyectos por nombre de obra (búsqueda parcial).
     * 
     * @param nombreObra el nombre o parte del nombre a buscar
     * @return lista de proyectos que coinciden con la búsqueda
     */
    public List<Proyecto> buscarPorNombre(String nombreObra) {
        List<Proyecto> proyectos = new ArrayList<>();
        
        if (nombreObra == null || nombreObra.trim().isEmpty()) {
            return proyectos;
        }
        
        Connection conexion = null;
        PreparedStatement statement = null;
        ResultSet resultSet = null;
        
        try {
            conexion = ConexionDB.obtenerConexion();
            statement = conexion.prepareStatement(SQL_BUSCAR_POR_NOMBRE);
            statement.setString(1, "%" + nombreObra.trim() + "%");
            
            resultSet = statement.executeQuery();
            
            while (resultSet.next()) {
                Proyecto proyecto = mapearResultSetAProyecto(resultSet);
                proyectos.add(proyecto);
            }
            
            LOGGER.info("Búsqueda por nombre '" + nombreObra + "' retornó " + proyectos.size() + " resultados");
            
        } catch (SQLException | ClassNotFoundException e) {
            LOGGER.log(Level.SEVERE, "Error al buscar proyectos por nombre: " + e.getMessage(), e);
        } finally {
            cerrarRecursos(resultSet, statement, conexion);
        }
        
        return proyectos;
    }
    
    // =================== MÉTODOS PRIVADOS ===================
    
    /**
     * Mapea un ResultSet a un objeto Proyecto.
     * 
     * @param rs el ResultSet con los datos del proyecto
     * @return el objeto Proyecto creado
     * @throws SQLException si hay error al acceder a los datos
     */
    private Proyecto mapearResultSetAProyecto(ResultSet rs) throws SQLException {
        return new Proyecto(
            rs.getInt("id"),
            rs.getString("nombreObra"),
            rs.getString("direccionObra"),
            rs.getString("nitCliente"),
            rs.getString("nombreCliente"),
            rs.getString("emailContacto"),
            rs.getString("telefonoContacto"),
            rs.getTimestamp("fechaCreacion"),
            rs.getString("estado")
        );
    }
    
    /**
     * Cierra de manera segura los recursos de base de datos.
     * 
     * @param rs ResultSet a cerrar
     * @param stmt PreparedStatement a cerrar
     * @param conn Connection a cerrar
     */
    private void cerrarRecursos(ResultSet rs, PreparedStatement stmt, Connection conn) {
        try {
            if (rs != null) rs.close();
            if (stmt != null) stmt.close();
            if (conn != null) conn.close();
        } catch (SQLException e) {
            LOGGER.log(Level.WARNING, "Error al cerrar recursos: " + e.getMessage(), e);
        }
    }
    
    /**
     * Sobrecarga del método cerrarRecursos para casos sin ResultSet.
     * 
     * @param stmt PreparedStatement a cerrar
     * @param conn Connection a cerrar
     */
    private void cerrarRecursos(PreparedStatement stmt, Connection conn) {
        cerrarRecursos(null, stmt, conn);
    }
}