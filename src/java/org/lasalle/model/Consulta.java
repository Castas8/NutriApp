package org.lasalle.model;

public class Consulta {
    
    private int idConsulta;
    private int idPaciente;
    private String fechaConsulta;
    private double pesoKg;
    private int tallaCm;
    private double imc;
    private double porcentajeMusculo;
    private double porcentajeGrasa;
    private double grasaVisceral;
    private int bodyAge;
    private double circBrazoRelajado;
    private double circBrazoContraido;
    private double circCintura;
    private double circCadera;
    private double circPecho;
    private double plicoTriceps;
    private double plicoBiceps;
    private double plicoAbdominal;
    private double plicoSubescapular;
    private String notasClinicas;
    private String tipoConsulta;

    public Consulta() {}

    public int getIdConsulta() { return idConsulta; }
    public void setIdConsulta(int idConsulta) { this.idConsulta = idConsulta; }

    public int getIdPaciente() { return idPaciente; }
    public void setIdPaciente(int idPaciente) { this.idPaciente = idPaciente; }

    public String getFechaConsulta() { return fechaConsulta; }
    public void setFechaConsulta(String fechaConsulta) { this.fechaConsulta = fechaConsulta; }

    public double getPesoKg() { return pesoKg; }
    public void setPesoKg(double pesoKg) { this.pesoKg = pesoKg; }

    public int getTallaCm() { return tallaCm; }
    public void setTallaCm(int tallaCm) { this.tallaCm = tallaCm; }

    public double getImc() { return imc; }
    public void setImc(double imc) { this.imc = imc; }

    public double getPorcentajeMusculo() { return porcentajeMusculo; }
    public void setPorcentajeMusculo(double porcentajeMusculo) { this.porcentajeMusculo = porcentajeMusculo; }

    public double getPorcentajeGrasa() { return porcentajeGrasa; }
    public void setPorcentajeGrasa(double porcentajeGrasa) { this.porcentajeGrasa = porcentajeGrasa; }

    public double getGrasaVisceral() { return grasaVisceral; }
    public void setGrasaVisceral(double grasaVisceral) { this.grasaVisceral = grasaVisceral; }

    public int getBodyAge() { return bodyAge; }
    public void setBodyAge(int bodyAge) { this.bodyAge = bodyAge; }

    public double getCircBrazoRelajado() { return circBrazoRelajado; }
    public void setCircBrazoRelajado(double circBrazoRelajado) { this.circBrazoRelajado = circBrazoRelajado; }

    public double getCircBrazoContraido() { return circBrazoContraido; }
    public void setCircBrazoContraido(double circBrazoContraido) { this.circBrazoContraido = circBrazoContraido; }

    public double getCircCintura() { return circCintura; }
    public void setCircCintura(double circCintura) { this.circCintura = circCintura; }

    public double getCircCadera() { return circCadera; }
    public void setCircCadera(double circCadera) { this.circCadera = circCadera; }

    public double getCircPecho() { return circPecho; }
    public void setCircPecho(double circPecho) { this.circPecho = circPecho; }

    public double getPlicoTriceps() { return plicoTriceps; }
    public void setPlicoTriceps(double plicoTriceps) { this.plicoTriceps = plicoTriceps; }

    public double getPlicoBiceps() { return plicoBiceps; }
    public void setPlicoBiceps(double plicoBiceps) { this.plicoBiceps = plicoBiceps; }

    public double getPlicoAbdominal() { return plicoAbdominal; }
    public void setPlicoAbdominal(double plicoAbdominal) { this.plicoAbdominal = plicoAbdominal; }

    public double getPlicoSubescapular() { return plicoSubescapular; }
    public void setPlicoSubescapular(double plicoSubescapular) { this.plicoSubescapular = plicoSubescapular; }

    public String getNotasClinicas() { return notasClinicas; }
    public void setNotasClinicas(String notasClinicas) { this.notasClinicas = notasClinicas; }

    public String getTipoConsulta() { return tipoConsulta; }
    public void setTipoConsulta(String tipoConsulta) { this.tipoConsulta = tipoConsulta; }
}