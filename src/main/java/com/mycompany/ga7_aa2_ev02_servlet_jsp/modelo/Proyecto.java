package com.mycompany.ga7_aa2_ev02_servlet_jsp.modelo;



import java.util.Date;

/**
 * Clase modelo que representa un Proyecto de construcción en el sistema CartillasAceroWeb.
 * 
 * Esta clase encapsula toda la información relacionada con un proyecto de obra,
 * incluyendo datos del cliente (empresa constructora), ubicación de la obra
 * y información de contacto básica.
 * 
 * Evidencia: GA7-220501096-AA2-EV02
 * Programa: Análisis y Desarrollo de Software - SENA
 */
public class Proyecto {
    
    // =================== ATRIBUTOS ===================
    
    /**
     * Identificador único del proyecto (clave primaria)
     */
    private int id;
    
    /**
     * Nombre descriptivo de la obra o proyecto de construcción
     */
    private String nombreObra;
    
    /**
     * Dirección física donde se ejecutará la obra
     */
    private String direccionObra;
    
    /**
     * Número de Identificación Tributaria (NIT) de la empresa cliente
     */
    private String nitCliente;
    
    /**
     * Razón social o nombre de la empresa constructora cliente
     */
    private String nombreCliente;
    
    /**
     * Correo electrónico de contacto para el proyecto
     */
    private String emailContacto;
    
    /**
     * Número telefónico de contacto para el proyecto
     */
    private String telefonoContacto;
    
    /**
     * Fecha y hora de creación del registro en el sistema
     */
    private Date fechaCreacion;
    
    /**
     * Estado actual del proyecto (Activo, Finalizado, Suspendido, etc.)
     */
    private String estado;
    
    // =================== CONSTRUCTORES ===================
    
    /**
     * Constructor vacío (requerido para frameworks y operaciones JDBC)
     */
    public Proyecto() {
        // Constructor por defecto
        this.estado = "Activo"; // Valor por defecto
        this.fechaCreacion = new Date(); // Fecha actual por defecto
    }
    
    /**
     * Constructor completo para crear un nuevo proyecto (sin ID, se auto-genera)
     * 
     * @param nombreObra Nombre del proyecto de construcción
     * @param direccionObra Dirección donde se ejecutará la obra
     * @param nitCliente NIT de la empresa cliente
     * @param nombreCliente Nombre de la empresa constructora
     * @param emailContacto Email de contacto
     * @param telefonoContacto Teléfono de contacto
     */
    public Proyecto(String nombreObra, String direccionObra, String nitCliente, 
                   String nombreCliente, String emailContacto, String telefonoContacto) {
        this.nombreObra = nombreObra;
        this.direccionObra = direccionObra;
        this.nitCliente = nitCliente;
        this.nombreCliente = nombreCliente;
        this.emailContacto = emailContacto;
        this.telefonoContacto = telefonoContacto;
        this.estado = "Activo";
        this.fechaCreacion = new Date();
    }
    
    /**
     * Constructor completo incluyendo ID (para cargar desde base de datos)
     */
    public Proyecto(int id, String nombreObra, String direccionObra, String nitCliente,
                   String nombreCliente, String emailContacto, String telefonoContacto,
                   Date fechaCreacion, String estado) {
        this.id = id;
        this.nombreObra = nombreObra;
        this.direccionObra = direccionObra;
        this.nitCliente = nitCliente;
        this.nombreCliente = nombreCliente;
        this.emailContacto = emailContacto;
        this.telefonoContacto = telefonoContacto;
        this.fechaCreacion = fechaCreacion;
        this.estado = estado;
    }
    
    // =================== MÉTODOS GETTER ===================
    
    /**
     * @return el identificador único del proyecto
     */
    public int getId() {
        return id;
    }
    
    /**
     * @return el nombre de la obra
     */
    public String getNombreObra() {
        return nombreObra;
    }
    
    /**
     * @return la dirección de la obra
     */
    public String getDireccionObra() {
        return direccionObra;
    }
    
    /**
     * @return el NIT del cliente
     */
    public String getNitCliente() {
        return nitCliente;
    }
    
    /**
     * @return el nombre del cliente
     */
    public String getNombreCliente() {
        return nombreCliente;
    }
    
    /**
     * @return el email de contacto
     */
    public String getEmailContacto() {
        return emailContacto;
    }
    
    /**
     * @return el teléfono de contacto
     */
    public String getTelefonoContacto() {
        return telefonoContacto;
    }
    
    /**
     * @return la fecha de creación del proyecto
     */
    public Date getFechaCreacion() {
        return fechaCreacion;
    }
    
    /**
     * @return el estado actual del proyecto
     */
    public String getEstado() {
        return estado;
    }
    
    // =================== MÉTODOS SETTER ===================
    
    /**
     * Establece el identificador único del proyecto
     * @param id el nuevo identificador
     */
    public void setId(int id) {
        this.id = id;
    }
    
    /**
     * Establece el nombre de la obra
     * @param nombreObra el nuevo nombre de la obra
     */
    public void setNombreObra(String nombreObra) {
        this.nombreObra = nombreObra;
    }
    
    /**
     * Establece la dirección de la obra
     * @param direccionObra la nueva dirección
     */
    public void setDireccionObra(String direccionObra) {
        this.direccionObra = direccionObra;
    }
    
    /**
     * Establece el NIT del cliente
     * @param nitCliente el nuevo NIT
     */
    public void setNitCliente(String nitCliente) {
        this.nitCliente = nitCliente;
    }
    
    /**
     * Establece el nombre del cliente
     * @param nombreCliente el nuevo nombre del cliente
     */
    public void setNombreCliente(String nombreCliente) {
        this.nombreCliente = nombreCliente;
    }
    
    /**
     * Establece el email de contacto
     * @param emailContacto el nuevo email
     */
    public void setEmailContacto(String emailContacto) {
        this.emailContacto = emailContacto;
    }
    
    /**
     * Establece el teléfono de contacto
     * @param telefonoContacto el nuevo teléfono
     */
    public void setTelefonoContacto(String telefonoContacto) {
        this.telefonoContacto = telefonoContacto;
    }
    
    /**
     * Establece la fecha de creación
     * @param fechaCreacion la nueva fecha de creación
     */
    public void setFechaCreacion(Date fechaCreacion) {
        this.fechaCreacion = fechaCreacion;
    }
    
    /**
     * Establece el estado del proyecto
     * @param estado el nuevo estado
     */
    public void setEstado(String estado) {
        this.estado = estado;
    }
    
    // =================== MÉTODOS UTILITARIOS ===================
    
    /**
     * Representación en cadena del objeto Proyecto
     * Útil para debugging y logging
     */
    @Override
    public String toString() {
        return "Proyecto{" +
                "id=" + id +
                ", nombreObra='" + nombreObra + '\'' +
                ", direccionObra='" + direccionObra + '\'' +
                ", nitCliente='" + nitCliente + '\'' +
                ", nombreCliente='" + nombreCliente + '\'' +
                ", emailContacto='" + emailContacto + '\'' +
                ", telefonoContacto='" + telefonoContacto + '\'' +
                ", fechaCreacion=" + fechaCreacion +
                ", estado='" + estado + '\'' +
                '}';
    }
    
    /**
     * Valida si los campos obligatorios del proyecto están completos
     * @return true si todos los campos obligatorios tienen valores válidos
     */
    public boolean esValido() {
        return nombreObra != null && !nombreObra.trim().isEmpty() &&
               direccionObra != null && !direccionObra.trim().isEmpty() &&
               nitCliente != null && !nitCliente.trim().isEmpty() &&
               nombreCliente != null && !nombreCliente.trim().isEmpty();
    }
    
    /**
     * Obtiene un resumen corto del proyecto para mostrar en listas
     * @return una cadena con el formato "Obra - Cliente"
     */
    public String getResumen() {
        return nombreObra + " - " + nombreCliente;
    }
}