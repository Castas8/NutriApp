package org.lasalle.controller;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import org.lasalle.conection.ConexionMysql;
import org.lasalle.model.Consulta;

public class ControllerConsulta {

    private Consulta fill(ResultSet rs) throws SQLException {
        Consulta c = new Consulta();
        c.setIdConsulta(rs.getInt("id_consulta"));
        c.setIdPaciente(rs.getInt("id_paciente"));
        c.setFechaConsulta(rs.getString("fecha_consulta"));
        c.setPesoKg(rs.getDouble("peso_kg"));
        c.setTallaCm(rs.getInt("talla_cm"));
        c.setImc(rs.getDouble("imc"));
        c.setPorcentajeMusculo(rs.getDouble("porcentaje_musculo"));
        c.setPorcentajeGrasa(rs.getDouble("porcentaje_grasa"));
        c.setGrasaVisceral(rs.getDouble("grasa_visceral"));
        c.setBodyAge(rs.getInt("body_age"));
        c.setCircBrazoRelajado(rs.getDouble("circ_brazo_relajado"));
        c.setCircBrazoContraido(rs.getDouble("circ_brazo_contraido"));
        c.setCircCintura(rs.getDouble("circ_cintura"));
        c.setCircCadera(rs.getDouble("circ_cadera"));
        c.setCircPecho(rs.getDouble("circ_pecho"));
        c.setPlicoTriceps(rs.getDouble("plico_triceps"));
        c.setPlicoBiceps(rs.getDouble("plico_biceps"));
        c.setPlicoAbdominal(rs.getDouble("plico_abdominal"));
        c.setPlicoSubescapular(rs.getDouble("plico_subescapular"));
        c.setNotasClinicas(rs.getString("notas_clinicas"));
        c.setTipoConsulta(rs.getString("tipo_consulta"));
        return c;
    }

    public List<Consulta> getByPaciente(int idPaciente) throws SQLException {
        String sql = "SELECT * FROM consultas WHERE id_paciente = ? ORDER BY fecha_consulta DESC";
        ConexionMysql connMysql = new ConexionMysql();
        Connection conn = connMysql.open();
        PreparedStatement pstm = conn.prepareStatement(sql);
        pstm.setInt(1, idPaciente);
        ResultSet rs = pstm.executeQuery();
        List<Consulta> lista = new ArrayList<>();
        while (rs.next()) {
            lista.add(fill(rs));
        }
        rs.close();
        connMysql.close();
        return lista;
    }
    
    public List<Consulta> getAll() throws SQLException {
        String sql = "SELECT c.*, p.nombre_completo FROM consultas c " +
                "JOIN pacientes p ON c.id_paciente = p.id_paciente " +
                "ORDER BY c.fecha_consulta DESC";
        ConexionMysql connMysql = new ConexionMysql();
        Connection conn = connMysql.open();
        PreparedStatement pstm = conn.prepareStatement(sql);
        ResultSet rs = pstm.executeQuery();
        List<Consulta> lista = new ArrayList<>();
        while (rs.next()) {
            Consulta c = fill(rs);
            c.setNombreCompleto(rs.getString("nombre_completo"));
            lista.add(c);
        }
        rs.close();
        connMysql.close();
        return lista;
}

    public Consulta getById(int id) throws SQLException {
        String sql = "SELECT * FROM consultas WHERE id_consulta = ?";
        ConexionMysql connMysql = new ConexionMysql();
        Connection conn = connMysql.open();
        PreparedStatement pstm = conn.prepareStatement(sql);
        pstm.setInt(1, id);
        ResultSet rs = pstm.executeQuery();
        Consulta c = null;
        if (rs.next()) {
            c = fill(rs);
        }
        rs.close();
        connMysql.close();
        return c;
    }

    public Consulta insert(Consulta c) throws SQLException {
        String sql = "INSERT INTO consultas (id_paciente, peso_kg, talla_cm, imc, porcentaje_musculo, porcentaje_grasa, grasa_visceral, body_age, circ_brazo_relajado, circ_brazo_contraido, circ_cintura, circ_cadera, circ_pecho, plico_triceps, plico_biceps, plico_abdominal, plico_subescapular, notas_clinicas, tipo_consulta) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
        ConexionMysql connMysql = new ConexionMysql();
        Connection conn = connMysql.open();
        PreparedStatement pstm = conn.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS);
        pstm.setInt(1, c.getIdPaciente());
        pstm.setDouble(2, c.getPesoKg());
        pstm.setInt(3, c.getTallaCm());
        pstm.setDouble(4, c.getImc());
        pstm.setDouble(5, c.getPorcentajeMusculo());
        pstm.setDouble(6, c.getPorcentajeGrasa());
        pstm.setDouble(7, c.getGrasaVisceral());
        pstm.setInt(8, c.getBodyAge());
        pstm.setDouble(9, c.getCircBrazoRelajado());
        pstm.setDouble(10, c.getCircBrazoContraido());
        pstm.setDouble(11, c.getCircCintura());
        pstm.setDouble(12, c.getCircCadera());
        pstm.setDouble(13, c.getCircPecho());
        pstm.setDouble(14, c.getPlicoTriceps());
        pstm.setDouble(15, c.getPlicoBiceps());
        pstm.setDouble(16, c.getPlicoAbdominal());
        pstm.setDouble(17, c.getPlicoSubescapular());
        pstm.setString(18, c.getNotasClinicas());
        pstm.setString(19, c.getTipoConsulta());
        pstm.executeUpdate();
        ResultSet rs = pstm.getGeneratedKeys();
        if (rs.next()) {
            c.setIdConsulta(rs.getInt(1));
        }
        rs.close();
        connMysql.close();
        return c;
    }

    public Consulta update(Consulta c) throws SQLException {
        String sql = "UPDATE consultas SET peso_kg=?, talla_cm=?, imc=?, porcentaje_musculo=?, porcentaje_grasa=?, grasa_visceral=?, body_age=?, circ_brazo_relajado=?, circ_brazo_contraido=?, circ_cintura=?, circ_cadera=?, circ_pecho=?, plico_triceps=?, plico_biceps=?, plico_abdominal=?, plico_subescapular=?, notas_clinicas=?, tipo_consulta=? WHERE id_consulta=?";
        ConexionMysql connMysql = new ConexionMysql();
        Connection conn = connMysql.open();
        PreparedStatement pstm = conn.prepareStatement(sql);
        pstm.setDouble(1, c.getPesoKg());
        pstm.setInt(2, c.getTallaCm());
        pstm.setDouble(3, c.getImc());
        pstm.setDouble(4, c.getPorcentajeMusculo());
        pstm.setDouble(5, c.getPorcentajeGrasa());
        pstm.setDouble(6, c.getGrasaVisceral());
        pstm.setInt(7, c.getBodyAge());
        pstm.setDouble(8, c.getCircBrazoRelajado());
        pstm.setDouble(9, c.getCircBrazoContraido());
        pstm.setDouble(10, c.getCircCintura());
        pstm.setDouble(11, c.getCircCadera());
        pstm.setDouble(12, c.getCircPecho());
        pstm.setDouble(13, c.getPlicoTriceps());
        pstm.setDouble(14, c.getPlicoBiceps());
        pstm.setDouble(15, c.getPlicoAbdominal());
        pstm.setDouble(16, c.getPlicoSubescapular());
        pstm.setString(17, c.getNotasClinicas());
        pstm.setString(18, c.getTipoConsulta());
        pstm.setInt(19, c.getIdConsulta());
        pstm.executeUpdate();
        connMysql.close();
        return c;
    }

    public boolean delete(int id) throws SQLException {
        String sql = "DELETE FROM consultas WHERE id_consulta = ?";
        ConexionMysql connMysql = new ConexionMysql();
        Connection conn = connMysql.open();
        PreparedStatement pstm = conn.prepareStatement(sql);
        pstm.setInt(1, id);
        int rows = pstm.executeUpdate();
        connMysql.close();
        return rows > 0;
    }
}