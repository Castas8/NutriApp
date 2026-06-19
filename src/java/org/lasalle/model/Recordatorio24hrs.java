package org.lasalle.model;

public class Recordatorio24hrs {
    private int idRecordatorio;
    private int idPaciente;
    private String fecha;
    private String desayuno;
    private String colacionManana;
    private String comida;
    private String colacionTarde;
    private String cena;
    private String observaciones;

    public Recordatorio24hrs() {}

    public int getIdRecordatorio() { return idRecordatorio; }
    public void setIdRecordatorio(int idRecordatorio) { this.idRecordatorio = idRecordatorio; }

    public int getIdPaciente() { return idPaciente; }
    public void setIdPaciente(int idPaciente) { this.idPaciente = idPaciente; }

    public String getFecha() { return fecha; }
    public void setFecha(String fecha) { this.fecha = fecha; }

    public String getDesayuno() { return desayuno; }
    public void setDesayuno(String desayuno) { this.desayuno = desayuno; }

    public String getColacionManana() { return colacionManana; }
    public void setColacionManana(String colacionManana) { this.colacionManana = colacionManana; }

    public String getComida() { return comida; }
    public void setComida(String comida) { this.comida = comida; }

    public String getColacionTarde() { return colacionTarde; }
    public void setColacionTarde(String colacionTarde) { this.colacionTarde = colacionTarde; }

    public String getCena() { return cena; }
    public void setCena(String cena) { this.cena = cena; }

    public String getObservaciones() { return observaciones; }
    public void setObservaciones(String observaciones) { this.observaciones = observaciones; }
}