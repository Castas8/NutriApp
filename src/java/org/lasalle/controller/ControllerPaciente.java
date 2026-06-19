package org.lasalle.controller;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import org.lasalle.conection.ConexionMysql;
import org.lasalle.model.Paciente;

public class ControllerPaciente {

    private Paciente fill(ResultSet rs) throws SQLException {
        Paciente p = new Paciente();
        p.setIdPaciente(rs.getInt("id_paciente"));
        p.setIdUsuario(rs.getInt("id_usuario"));
        p.setNombreCompleto(rs.getString("nombre_completo"));
        p.setFechaNacimiento(rs.getString("fecha_nacimiento"));
        p.setEdad(rs.getInt("edad"));
        p.setGenero(rs.getString("genero"));
        p.setOcupacion(rs.getString("ocupacion"));
        p.setEstadoCivil(rs.getString("estado_civil"));
        p.setTelefono(rs.getString("telefono"));
        p.setMotivoConsulta(rs.getString("motivo_consulta"));
        p.setEnfermedadesPatologicas(rs.getString("enfermedades_patologicas"));
        p.setEnfermedadesHeredofamiliares(rs.getString("enfermedades_heredofamiliares"));
        p.setOperacionesPrevias(rs.getString("operaciones_previas"));
        p.setConsumeTabaco(rs.getBoolean("consume_tabaco"));
        p.setConsumeAlcohol(rs.getBoolean("consume_alcohol"));
        p.setOtrasSustancias(rs.getString("otras_sustancias"));
        p.setObjetivo(rs.getString("objetivo"));
        p.setNivelActividad(rs.getString("nivel_actividad"));
        p.setMedicamentos(rs.getString("medicamentos"));
        p.setEstatus(rs.getString("estatus"));
        p.setFechaRegistro(rs.getString("fecha_registro"));
        return p;
    }

    public List<Paciente> getAll() throws SQLException {
        String sql = "SELECT * FROM pacientes";
        ConexionMysql connMysql = new ConexionMysql();
        Connection conn = connMysql.open();
        PreparedStatement pstm = conn.prepareStatement(sql);
        ResultSet rs = pstm.executeQuery();
        List<Paciente> lista = new ArrayList<>();
        while (rs.next()) {
            lista.add(fill(rs));
        }
        rs.close();
        connMysql.close();
        return lista;
    }

    public List<Paciente> getByUsuario(int idUsuario) throws SQLException {
        String sql = "SELECT * FROM pacientes WHERE id_usuario = ?";
        ConexionMysql connMysql = new ConexionMysql();
        Connection conn = connMysql.open();
        PreparedStatement pstm = conn.prepareStatement(sql);
        pstm.setInt(1, idUsuario);
        ResultSet rs = pstm.executeQuery();
        List<Paciente> lista = new ArrayList<>();
        while (rs.next()) {
            lista.add(fill(rs));
        }
        rs.close();
        connMysql.close();
        return lista;
    }

    public Paciente getById(int id) throws SQLException {
        String sql = "SELECT * FROM pacientes WHERE id_paciente = ?";
        ConexionMysql connMysql = new ConexionMysql();
        Connection conn = connMysql.open();
        PreparedStatement pstm = conn.prepareStatement(sql);
        pstm.setInt(1, id);
        ResultSet rs = pstm.executeQuery();
        Paciente p = null;
        if (rs.next()) {
            p = fill(rs);
        }
        rs.close();
        connMysql.close();
        return p;
    }

    public Paciente insert(Paciente p) throws SQLException {
        String sql = "INSERT INTO pacientes (id_usuario, nombre_completo, fecha_nacimiento, edad, genero, ocupacion, estado_civil, telefono, motivo_consulta, enfermedades_patologicas, enfermedades_heredofamiliares, operaciones_previas, consume_tabaco, consume_alcohol, otras_sustancias, objetivo, nivel_actividad, medicamentos, estatus) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,'en_proceso')";
        ConexionMysql connMysql = new ConexionMysql();
        Connection conn = connMysql.open();
        PreparedStatement pstm = conn.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS);
        pstm.setInt(1, p.getIdUsuario());
        pstm.setString(2, p.getNombreCompleto());
        pstm.setString(3, p.getFechaNacimiento());
        pstm.setInt(4, p.getEdad());
        pstm.setString(5, p.getGenero());
        pstm.setString(6, p.getOcupacion());
        pstm.setString(7, p.getEstadoCivil());
        pstm.setString(8, p.getTelefono());
        pstm.setString(9, p.getMotivoConsulta());
        pstm.setString(10, p.getEnfermedadesPatologicas());
        pstm.setString(11, p.getEnfermedadesHeredofamiliares());
        pstm.setString(12, p.getOperacionesPrevias());
        pstm.setBoolean(13, p.isConsumeTabaco());
        pstm.setBoolean(14, p.isConsumeAlcohol());
        pstm.setString(15, p.getOtrasSustancias());
        pstm.setString(16, p.getObjetivo());
        pstm.setString(17, p.getNivelActividad());
        pstm.setString(18, p.getMedicamentos());
        pstm.executeUpdate();
        ResultSet rs = pstm.getGeneratedKeys();
        if (rs.next()) {
            p.setIdPaciente(rs.getInt(1));
        }
        rs.close();
        connMysql.close();
        return p;
    }

    public Paciente update(Paciente p) throws SQLException {
        String sql = "UPDATE pacientes SET nombre_completo=?, fecha_nacimiento=?, edad=?, genero=?, ocupacion=?, estado_civil=?, telefono=?, motivo_consulta=?, enfermedades_patologicas=?, enfermedades_heredofamiliares=?, operaciones_previas=?, consume_tabaco=?, consume_alcohol=?, otras_sustancias=?, objetivo=?, nivel_actividad=?, medicamentos=?, estatus=? WHERE id_paciente=?";
        ConexionMysql connMysql = new ConexionMysql();
        Connection conn = connMysql.open();
        PreparedStatement pstm = conn.prepareStatement(sql);
        pstm.setString(1, p.getNombreCompleto());
        pstm.setString(2, p.getFechaNacimiento());
        pstm.setInt(3, p.getEdad());
        pstm.setString(4, p.getGenero());
        pstm.setString(5, p.getOcupacion());
        pstm.setString(6, p.getEstadoCivil());
        pstm.setString(7, p.getTelefono());
        pstm.setString(8, p.getMotivoConsulta());
        pstm.setString(9, p.getEnfermedadesPatologicas());
        pstm.setString(10, p.getEnfermedadesHeredofamiliares());
        pstm.setString(11, p.getOperacionesPrevias());
        pstm.setBoolean(12, p.isConsumeTabaco());
        pstm.setBoolean(13, p.isConsumeAlcohol());
        pstm.setString(14, p.getOtrasSustancias());
        pstm.setString(15, p.getObjetivo());
        pstm.setString(16, p.getNivelActividad());
        pstm.setString(17, p.getMedicamentos());
        pstm.setString(18, p.getEstatus());
        pstm.setInt(19, p.getIdPaciente());
        pstm.executeUpdate();
        connMysql.close();
        return p;
    }

    public boolean delete(int id) throws SQLException {
        String sql = "DELETE FROM pacientes WHERE id_paciente = ?";
        ConexionMysql connMysql = new ConexionMysql();
        Connection conn = connMysql.open();
        PreparedStatement pstm = conn.prepareStatement(sql);
        pstm.setInt(1, id);
        int rows = pstm.executeUpdate();
        connMysql.close();
        return rows > 0;
    }

    public List<Paciente> buscar(String nombre) throws SQLException {
        String sql = "SELECT * FROM pacientes WHERE nombre_completo LIKE ?";
        ConexionMysql connMysql = new ConexionMysql();
        Connection conn = connMysql.open();
        PreparedStatement pstm = conn.prepareStatement(sql);
        pstm.setString(1, "%" + nombre + "%");
        ResultSet rs = pstm.executeQuery();
        List<Paciente> lista = new ArrayList<>();
        while (rs.next()) {
            lista.add(fill(rs));
        }
        rs.close();
        connMysql.close();
        return lista;
    }
}