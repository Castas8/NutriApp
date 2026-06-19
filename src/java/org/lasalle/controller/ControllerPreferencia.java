package org.lasalle.controller;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import org.lasalle.conection.ConexionMysql;
import org.lasalle.model.Preferencia;

public class ControllerPreferencia {

    private Preferencia fill(ResultSet rs) throws SQLException {
        Preferencia p = new Preferencia();
        p.setIdPreferencia(rs.getInt("id_preferencia"));
        p.setIdPaciente(rs.getInt("id_paciente"));
        p.setAlimentosGustan(rs.getString("alimentos_gustan"));
        p.setAlimentosNoGustan(rs.getString("alimentos_no_gustan"));
        p.setRestriccionEspecial(rs.getString("restriccion_especial"));
        p.setFrecuenciaAlimentos(rs.getString("frecuencia_alimentos"));
        p.setFechaActualizacion(rs.getString("fecha_actualizacion"));
        return p;
    }

    public Preferencia getByPaciente(int idPaciente) throws SQLException {
        String sql = "SELECT * FROM preferencias WHERE id_paciente = ?";
        ConexionMysql connMysql = new ConexionMysql();
        Connection conn = connMysql.open();
        PreparedStatement pstm = conn.prepareStatement(sql);
        pstm.setInt(1, idPaciente);
        ResultSet rs = pstm.executeQuery();
        Preferencia p = null;
        if (rs.next()) p = fill(rs);
        rs.close();
        connMysql.close();
        return p;
    }

    public Preferencia insert(Preferencia p) throws SQLException {
        String sql = "INSERT INTO preferencias (id_paciente, alimentos_gustan, alimentos_no_gustan, restriccion_especial, frecuencia_alimentos) VALUES (?,?,?,?,?)";
        ConexionMysql connMysql = new ConexionMysql();
        Connection conn = connMysql.open();
        PreparedStatement pstm = conn.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS);
        pstm.setInt(1, p.getIdPaciente());
        pstm.setString(2, p.getAlimentosGustan());
        pstm.setString(3, p.getAlimentosNoGustan());
        pstm.setString(4, p.getRestriccionEspecial());
        pstm.setString(5, p.getFrecuenciaAlimentos());
        pstm.executeUpdate();
        ResultSet rs = pstm.getGeneratedKeys();
        if (rs.next()) p.setIdPreferencia(rs.getInt(1));
        rs.close();
        connMysql.close();
        return p;
    }

    public Preferencia update(Preferencia p) throws SQLException {
        String sql = "UPDATE preferencias SET alimentos_gustan=?, alimentos_no_gustan=?, restriccion_especial=?, frecuencia_alimentos=? WHERE id_preferencia=?";
        ConexionMysql connMysql = new ConexionMysql();
        Connection conn = connMysql.open();
        PreparedStatement pstm = conn.prepareStatement(sql);
        pstm.setString(1, p.getAlimentosGustan());
        pstm.setString(2, p.getAlimentosNoGustan());
        pstm.setString(3, p.getRestriccionEspecial());
        pstm.setString(4, p.getFrecuenciaAlimentos());
        pstm.setInt(5, p.getIdPreferencia());
        pstm.executeUpdate();
        connMysql.close();
        return p;
    }

    public boolean delete(int id) throws SQLException {
        String sql = "DELETE FROM preferencias WHERE id_preferencia = ?";
        ConexionMysql connMysql = new ConexionMysql();
        Connection conn = connMysql.open();
        PreparedStatement pstm = conn.prepareStatement(sql);
        pstm.setInt(1, id);
        int rows = pstm.executeUpdate();
        connMysql.close();
        return rows > 0;
    }
}