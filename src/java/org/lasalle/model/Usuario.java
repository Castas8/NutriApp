package org.lasalle.model;

public class Usuario {
    
    private int idUsuario;
    private String nombre;
    private String correo;
    private String password;
    private String nombreConsultorio;
    private String cedulaProfesional;
    private String institucion;
    private String telefono;
    private String estadoCuenta;
    private String fechaRegistro;
    
    public Usuario() {}
    
    public Usuario(int idUsuario, String nombre, String correo, String password, 
                   String nombreConsultorio, String cedulaProfesional, String institucion, 
                   String telefono, String estadoCuenta, String fechaRegistro) {
        this.idUsuario = idUsuario;
        this.nombre = nombre;
        this.correo = correo;
        this.password = password;
        this.nombreConsultorio = nombreConsultorio;
        this.cedulaProfesional = cedulaProfesional;
        this.institucion = institucion;
        this.telefono = telefono;
        this.estadoCuenta = estadoCuenta;
        this.fechaRegistro = fechaRegistro;
    }
    
    public int getIdUsuario() { return idUsuario; }
    public void setIdUsuario(int idUsuario) { this.idUsuario = idUsuario; }
    
    public String getNombre() { return nombre; }
    public void setNombre(String nombre) { this.nombre = nombre; }
    
    public String getCorreo() { return correo; }
    public void setCorreo(String correo) { this.correo = correo; }
    
    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }
    
    public String getNombreConsultorio() { return nombreConsultorio; }
    public void setNombreConsultorio(String nombreConsultorio) { this.nombreConsultorio = nombreConsultorio; }
    
    public String getCedulaProfesional() { return cedulaProfesional; }
    public void setCedulaProfesional(String cedulaProfesional) { this.cedulaProfesional = cedulaProfesional; }
    
    public String getInstitucion() { return institucion; }
    public void setInstitucion(String institucion) { this.institucion = institucion; }
    
    public String getTelefono() { return telefono; }
    public void setTelefono(String telefono) { this.telefono = telefono; }
    
    public String getEstadoCuenta() { return estadoCuenta; }
    public void setEstadoCuenta(String estadoCuenta) { this.estadoCuenta = estadoCuenta; }
    
    public String getFechaRegistro() { return fechaRegistro; }
    public void setFechaRegistro(String fechaRegistro) { this.fechaRegistro = fechaRegistro; }
}