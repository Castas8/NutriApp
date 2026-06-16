package org.lasalle.model;

public class Preferencia {
    private int idPreferencia;
    private int idPaciente;
    private String alimentosGustan;
    private String alimentosNoGustan;
    private String restriccionEspecial;
    private String frecuenciaAlimentos;
    private String fechaActualizacion;

    public Preferencia() {}

    public int getIdPreferencia() { return idPreferencia; }
    public void setIdPreferencia(int idPreferencia) { this.idPreferencia = idPreferencia; }

    public int getIdPaciente() { return idPaciente; }
    public void setIdPaciente(int idPaciente) { this.idPaciente = idPaciente; }

    public String getAlimentosGustan() { return alimentosGustan; }
    public void setAlimentosGustan(String alimentosGustan) { this.alimentosGustan = alimentosGustan; }

    public String getAlimentosNoGustan() { return alimentosNoGustan; }
    public void setAlimentosNoGustan(String alimentosNoGustan) { this.alimentosNoGustan = alimentosNoGustan; }

    public String getRestriccionEspecial() { return restriccionEspecial; }
    public void setRestriccionEspecial(String restriccionEspecial) { this.restriccionEspecial = restriccionEspecial; }

    public String getFrecuenciaAlimentos() { return frecuenciaAlimentos; }
    public void setFrecuenciaAlimentos(String frecuenciaAlimentos) { this.frecuenciaAlimentos = frecuenciaAlimentos; }

    public String getFechaActualizacion() { return fechaActualizacion; }
    public void setFechaActualizacion(String fechaActualizacion) { this.fechaActualizacion = fechaActualizacion; }
}