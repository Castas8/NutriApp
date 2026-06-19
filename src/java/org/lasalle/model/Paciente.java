package org.lasalle.model;

public class Paciente {
    
    private int idPaciente;
    private int idUsuario;
    private String nombreCompleto;
    private String fechaNacimiento;
    private int edad;
    private String genero;
    private String ocupacion;
    private String estadoCivil;
    private String telefono;
    private String motivoConsulta;
    private String enfermedadesPatologicas;
    private String enfermedadesHeredofamiliares;
    private String operacionesPrevias;
    private boolean consumeTabaco;
    private boolean consumeAlcohol;
    private String otrasSustancias;
    private String objetivo;
    private String nivelActividad;
    private String medicamentos;
    private String estatus;
    private String fechaRegistro;

    public Paciente() {}

    public int getIdPaciente() { return idPaciente; }
    public void setIdPaciente(int idPaciente) { this.idPaciente = idPaciente; }

    public int getIdUsuario() { return idUsuario; }
    public void setIdUsuario(int idUsuario) { this.idUsuario = idUsuario; }

    public String getNombreCompleto() { return nombreCompleto; }
    public void setNombreCompleto(String nombreCompleto) { this.nombreCompleto = nombreCompleto; }

    public String getFechaNacimiento() { return fechaNacimiento; }
    public void setFechaNacimiento(String fechaNacimiento) { this.fechaNacimiento = fechaNacimiento; }

    public int getEdad() { return edad; }
    public void setEdad(int edad) { this.edad = edad; }

    public String getGenero() { return genero; }
    public void setGenero(String genero) { this.genero = genero; }

    public String getOcupacion() { return ocupacion; }
    public void setOcupacion(String ocupacion) { this.ocupacion = ocupacion; }

    public String getEstadoCivil() { return estadoCivil; }
    public void setEstadoCivil(String estadoCivil) { this.estadoCivil = estadoCivil; }

    public String getTelefono() { return telefono; }
    public void setTelefono(String telefono) { this.telefono = telefono; }

    public String getMotivoConsulta() { return motivoConsulta; }
    public void setMotivoConsulta(String motivoConsulta) { this.motivoConsulta = motivoConsulta; }

    public String getEnfermedadesPatologicas() { return enfermedadesPatologicas; }
    public void setEnfermedadesPatologicas(String enfermedadesPatologicas) { this.enfermedadesPatologicas = enfermedadesPatologicas; }

    public String getEnfermedadesHeredofamiliares() { return enfermedadesHeredofamiliares; }
    public void setEnfermedadesHeredofamiliares(String enfermedadesHeredofamiliares) { this.enfermedadesHeredofamiliares = enfermedadesHeredofamiliares; }

    public String getOperacionesPrevias() { return operacionesPrevias; }
    public void setOperacionesPrevias(String operacionesPrevias) { this.operacionesPrevias = operacionesPrevias; }

    public boolean isConsumeTabaco() { return consumeTabaco; }
    public void setConsumeTabaco(boolean consumeTabaco) { this.consumeTabaco = consumeTabaco; }

    public boolean isConsumeAlcohol() { return consumeAlcohol; }
    public void setConsumeAlcohol(boolean consumeAlcohol) { this.consumeAlcohol = consumeAlcohol; }

    public String getOtrasSustancias() { return otrasSustancias; }
    public void setOtrasSustancias(String otrasSustancias) { this.otrasSustancias = otrasSustancias; }

    public String getObjetivo() { return objetivo; }
    public void setObjetivo(String objetivo) { this.objetivo = objetivo; }

    public String getNivelActividad() { return nivelActividad; }
    public void setNivelActividad(String nivelActividad) { this.nivelActividad = nivelActividad; }

    public String getMedicamentos() { return medicamentos; }
    public void setMedicamentos(String medicamentos) { this.medicamentos = medicamentos; }

    public String getEstatus() { return estatus; }
    public void setEstatus(String estatus) { this.estatus = estatus; }

    public String getFechaRegistro() { return fechaRegistro; }
    public void setFechaRegistro(String fechaRegistro) { this.fechaRegistro = fechaRegistro; }
}