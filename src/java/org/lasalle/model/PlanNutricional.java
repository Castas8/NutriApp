package org.lasalle.model;

public class PlanNutricional {
    private int idPlan;
    private int idConsulta;
    private int idPaciente;
    private String desayunos;
    private String comidas;
    private String cenas;
    private String colaciones;
    private int caloriasObjetivo;
    private String recomendacionesIa;
    private String fechaGeneracion;

    public PlanNutricional() {}

    public int getIdPlan() { return idPlan; }
    public void setIdPlan(int idPlan) { this.idPlan = idPlan; }

    public int getIdConsulta() { return idConsulta; }
    public void setIdConsulta(int idConsulta) { this.idConsulta = idConsulta; }

    public int getIdPaciente() { return idPaciente; }
    public void setIdPaciente(int idPaciente) { this.idPaciente = idPaciente; }

    public String getDesayunos() { return desayunos; }
    public void setDesayunos(String desayunos) { this.desayunos = desayunos; }

    public String getComidas() { return comidas; }
    public void setComidas(String comidas) { this.comidas = comidas; }

    public String getCenas() { return cenas; }
    public void setCenas(String cenas) { this.cenas = cenas; }

    public String getColaciones() { return colaciones; }
    public void setColaciones(String colaciones) { this.colaciones = colaciones; }

    public int getCaloriasObjetivo() { return caloriasObjetivo; }
    public void setCaloriasObjetivo(int caloriasObjetivo) { this.caloriasObjetivo = caloriasObjetivo; }

    public String getRecomendacionesIa() { return recomendacionesIa; }
    public void setRecomendacionesIa(String recomendacionesIa) { this.recomendacionesIa = recomendacionesIa; }

    public String getFechaGeneracion() { return fechaGeneracion; }
    public void setFechaGeneracion(String fechaGeneracion) { this.fechaGeneracion = fechaGeneracion; }
}