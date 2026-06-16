package org.lasalle.controller;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import org.lasalle.conection.ConexionMysql;
import org.lasalle.model.Recordatorio24hrs;

public class ControllerRecordatorio24hrs {

    private Recordatorio24hrs fill(ResultSet rs) throws SQLException {
        Recordatorio24hrs r = new Recordatorio24hrs();
        r.setIdRecordatorio(rs.getInt("id_recordatorio"));
        r.setIdPaciente(rs.getInt("id_paciente"));
        r.setFecha(rs.getString("fecha"));
        r.setDesayuno(rs.getString("desayuno"));
        r.setColacionManana(rs.getString("colacion_manana"));
        r.setComida(rs.getString("comida"));
        r.setColacionTarde(rs.getString("colacion_tarde"));
        r.setCena(rs.getString("cena"));
        r.setObservaciones(rs.getString("observaciones"));
        return r;
    }

    public List<Recordatorio24hrs> getByPaciente(int idPaciente) throws SQLException {
        String sql = "SELECT * FROM recordatorio_24hrs WHERE id_paciente = ?";
        ConexionMysql connMysql = new ConexionMysql();
        Connection conn = connMysql.open();
        PreparedStatement pstm = conn.prepareStatement(sql);
        pstm.setInt(1, idPaciente);
        ResultSet rs = pstm.executeQuery();
        List<Recordatorio24hrs> lista = new ArrayList<>();
        while (rs.next()) lista.add(fill(rs));
        rs.close();
        connMysql.close();
        return lista;
    }

    public Recordatorio24hrs insert(Recordatorio24hrs r) throws SQLException {
        String sql = "INSERT INTO recordatorio_24hrs (id_paciente, fecha, desayuno, colacion_manana, comida, colacion_tarde, cena, observaciones) VALUES (?,?,?,?,?,?,?,?)";
        ConexionMysql connMysql = new ConexionMysql();
        Connection conn = connMysql.open();
        PreparedStatement pstm = conn.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS);
        pstm.setInt(1, r.getIdPaciente());
        pstm.setString(2, r.getFecha());
        pstm.setString(3, r.getDesayuno());
        pstm.setString(4, r.getColacionManana());
        pstm.setString(5, r.getComida());
        pstm.setString(6, r.getColacionTarde());
        pstm.setString(7, r.getCena());
        pstm.setString(8, r.getObservaciones());
        pstm.executeUpdate();
        ResultSet rs = pstm.getGeneratedKeys();
        if (rs.next()) r.setIdRecordatorio(rs.getInt(1));
        rs.close();
        connMysql.close();
        return r;
    }

    public Recordatorio24hrs update(Recordatorio24hrs r) throws SQLException {
        String sql = "UPDATE recordatorio_24hrs SET fecha=?, desayuno=?, colacion_manana=?, comida=?, colacion_tarde=?, cena=?, observaciones=? WHERE id_recordatorio=?";
        ConexionMysql connMysql = new ConexionMysql();
        Connection conn = connMysql.open();
        PreparedStatement pstm = conn.prepareStatement(sql);
        pstm.setString(1, r.getFecha());
        pstm.setString(2, r.getDesayuno());
        pstm.setString(3, r.getColacionManana());
        pstm.setString(4, r.getComida());
        pstm.setString(5, r.getColacionTarde());
        pstm.setString(6, r.getCena());
        pstm.setString(7, r.getObservaciones());
        pstm.setInt(8, r.getIdRecordatorio());
        pstm.executeUpdate();
        connMysql.close();
        return r;
    }

    public boolean delete(int id) throws SQLException {
        String sql = "DELETE FROM recordatorio_24hrs WHERE id_recordatorio = ?";
        ConexionMysql connMysql = new ConexionMysql();
        Connection conn = connMysql.open();
        PreparedStatement pstm = conn.prepareStatement(sql);
        pstm.setInt(1, id);
        int rows = pstm.executeUpdate();
        connMysql.close();
        return rows > 0;
    }
}