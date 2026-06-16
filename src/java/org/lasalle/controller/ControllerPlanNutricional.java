package org.lasalle.controller;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import org.lasalle.conection.ConexionMysql;
import org.lasalle.model.PlanNutricional;

public class ControllerPlanNutricional {

    private PlanNutricional fill(ResultSet rs) throws SQLException {
        PlanNutricional p = new PlanNutricional();
        p.setIdPlan(rs.getInt("id_plan"));
        p.setIdConsulta(rs.getInt("id_consulta"));
        p.setIdPaciente(rs.getInt("id_paciente"));
        p.setDesayunos(rs.getString("desayunos"));
        p.setComidas(rs.getString("comidas"));
        p.setCenas(rs.getString("cenas"));
        p.setColaciones(rs.getString("colaciones"));
        p.setCaloriasObjetivo(rs.getInt("calorias_objetivo"));
        p.setRecomendacionesIa(rs.getString("recomendaciones_ia"));
        p.setFechaGeneracion(rs.getString("fecha_generacion"));
        return p;
    }

    public List<PlanNutricional> getByPaciente(int idPaciente) throws SQLException {
        String sql = "SELECT * FROM planes_nutricionales WHERE id_paciente = ? ORDER BY fecha_generacion DESC";
        ConexionMysql connMysql = new ConexionMysql();
        Connection conn = connMysql.open();
        PreparedStatement pstm = conn.prepareStatement(sql);
        pstm.setInt(1, idPaciente);
        ResultSet rs = pstm.executeQuery();
        List<PlanNutricional> lista = new ArrayList<>();
        while (rs.next()) lista.add(fill(rs));
        rs.close();
        connMysql.close();
        return lista;
    }

    public PlanNutricional getById(int id) throws SQLException {
        String sql = "SELECT * FROM planes_nutricionales WHERE id_plan = ?";
        ConexionMysql connMysql = new ConexionMysql();
        Connection conn = connMysql.open();
        PreparedStatement pstm = conn.prepareStatement(sql);
        pstm.setInt(1, id);
        ResultSet rs = pstm.executeQuery();
        PlanNutricional p = null;
        if (rs.next()) p = fill(rs);
        rs.close();
        connMysql.close();
        return p;
    }

    public PlanNutricional insert(PlanNutricional p) throws SQLException {
        String sql = "INSERT INTO planes_nutricionales (id_consulta, id_paciente, desayunos, comidas, cenas, colaciones, calorias_objetivo, recomendaciones_ia) VALUES (?,?,?,?,?,?,?,?)";
        ConexionMysql connMysql = new ConexionMysql();
        Connection conn = connMysql.open();
        PreparedStatement pstm = conn.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS);
        pstm.setInt(1, p.getIdConsulta());
        pstm.setInt(2, p.getIdPaciente());
        pstm.setString(3, p.getDesayunos());
        pstm.setString(4, p.getComidas());
        pstm.setString(5, p.getCenas());
        pstm.setString(6, p.getColaciones());
        pstm.setInt(7, p.getCaloriasObjetivo());
        pstm.setString(8, p.getRecomendacionesIa());
        pstm.executeUpdate();
        ResultSet rs = pstm.getGeneratedKeys();
        if (rs.next()) p.setIdPlan(rs.getInt(1));
        rs.close();
        connMysql.close();
        return p;
    }

    public PlanNutricional update(PlanNutricional p) throws SQLException {
        String sql = "UPDATE planes_nutricionales SET desayunos=?, comidas=?, cenas=?, colaciones=?, calorias_objetivo=?, recomendaciones_ia=? WHERE id_plan=?";
        ConexionMysql connMysql = new ConexionMysql();
        Connection conn = connMysql.open();
        PreparedStatement pstm = conn.prepareStatement(sql);
        pstm.setString(1, p.getDesayunos());
        pstm.setString(2, p.getComidas());
        pstm.setString(3, p.getCenas());
        pstm.setString(4, p.getColaciones());
        pstm.setInt(5, p.getCaloriasObjetivo());
        pstm.setString(6, p.getRecomendacionesIa());
        pstm.setInt(7, p.getIdPlan());
        pstm.executeUpdate();
        connMysql.close();
        return p;
    }

    public boolean delete(int id) throws SQLException {
        String sql = "DELETE FROM planes_nutricionales WHERE id_plan = ?";
        ConexionMysql connMysql = new ConexionMysql();
        Connection conn = connMysql.open();
        PreparedStatement pstm = conn.prepareStatement(sql);
        pstm.setInt(1, id);
        int rows = pstm.executeUpdate();
        connMysql.close();
        return rows > 0;
    }
}