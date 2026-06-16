package org.lasalle.controller;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import org.lasalle.conection.ConexionMysql;
import org.lasalle.model.Usuario;

public class ControllerUsuario {

    private Usuario fill(ResultSet rs) throws SQLException {
        Usuario u = new Usuario();
        u.setIdUsuario(rs.getInt("id_usuario"));
        u.setNombre(rs.getString("nombre"));
        u.setCorreo(rs.getString("correo"));
        u.setPassword(rs.getString("password_hash"));
        u.setNombreConsultorio(rs.getString("nombre_consultorio"));
        u.setCedulaProfesional(rs.getString("cedula_profesional"));
        u.setInstitucion(rs.getString("institucion"));
        u.setTelefono(rs.getString("telefono"));
        u.setEstadoCuenta(rs.getString("estado_cuenta"));
        u.setFechaRegistro(rs.getString("fecha_registro"));
        return u;
    }

    public List<Usuario> getAll() throws SQLException {
        String sql = "SELECT * FROM usuarios";
        ConexionMysql connMysql = new ConexionMysql();
        Connection conn = connMysql.open();
        PreparedStatement pstm = conn.prepareStatement(sql);
        ResultSet rs = pstm.executeQuery();
        List<Usuario> lista = new ArrayList<>();
        while (rs.next()) {
            lista.add(fill(rs));
        }
        rs.close();
        connMysql.close();
        return lista;
    }

    public Usuario getById(int id) throws SQLException {
        String sql = "SELECT * FROM usuarios WHERE id_usuario = ?";
        ConexionMysql connMysql = new ConexionMysql();
        Connection conn = connMysql.open();
        PreparedStatement pstm = conn.prepareStatement(sql);
        pstm.setInt(1, id);
        ResultSet rs = pstm.executeQuery();
        Usuario u = null;
        if (rs.next()) {
            u = fill(rs);
        }
        rs.close();
        connMysql.close();
        return u;
    }

    public Usuario login(String correo, String password) throws SQLException {
        String sql = "SELECT * FROM usuarios WHERE correo = ? AND password_hash = ? AND estado_cuenta = 'aprobado'";
        ConexionMysql connMysql = new ConexionMysql();
        Connection conn = connMysql.open();
        PreparedStatement pstm = conn.prepareStatement(sql);
        pstm.setString(1, correo);
        pstm.setString(2, password);
        ResultSet rs = pstm.executeQuery();
        Usuario u = null;
        if (rs.next()) {
            u = fill(rs);
        }
        rs.close();
        connMysql.close();
        return u;
    }

    public Usuario insert(Usuario u) throws SQLException {
        String sql = "INSERT INTO usuarios (nombre, correo, password_hash, nombre_consultorio, cedula_profesional, institucion, telefono, estado_cuenta) VALUES (?, ?, ?, ?, ?, ?, ?, 'pendiente')";
        ConexionMysql connMysql = new ConexionMysql();
        Connection conn = connMysql.open();
        PreparedStatement pstm = conn.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS);
        pstm.setString(1, u.getNombre());
        pstm.setString(2, u.getCorreo());
        pstm.setString(3, u.getPassword());
        pstm.setString(4, u.getNombreConsultorio());
        pstm.setString(5, u.getCedulaProfesional());
        pstm.setString(6, u.getInstitucion());
        pstm.setString(7, u.getTelefono());
        pstm.executeUpdate();
        ResultSet rs = pstm.getGeneratedKeys();
        if (rs.next()) {
            u.setIdUsuario(rs.getInt(1));
        }
        rs.close();
        connMysql.close();
        return u;
    }

    public Usuario update(Usuario u) throws SQLException {
        String sql = "UPDATE usuarios SET nombre=?, nombre_consultorio=?, telefono=? WHERE id_usuario=?";
        ConexionMysql connMysql = new ConexionMysql();
        Connection conn = connMysql.open();
        PreparedStatement pstm = conn.prepareStatement(sql);
        pstm.setString(1, u.getNombre());
        pstm.setString(2, u.getNombreConsultorio());
        pstm.setString(3, u.getTelefono());
        pstm.setInt(4, u.getIdUsuario());
        pstm.executeUpdate();
        connMysql.close();
        return u;
    }

    public boolean delete(int id) throws SQLException {
        String sql = "DELETE FROM usuarios WHERE id_usuario = ?";
        ConexionMysql connMysql = new ConexionMysql();
        Connection conn = connMysql.open();
        PreparedStatement pstm = conn.prepareStatement(sql);
        pstm.setInt(1, id);
        int rows = pstm.executeUpdate();
        connMysql.close();
        return rows > 0;
    }

    public boolean aprobar(int id) throws SQLException {
        String sql = "UPDATE usuarios SET estado_cuenta='aprobado' WHERE id_usuario=?";
        ConexionMysql connMysql = new ConexionMysql();
        Connection conn = connMysql.open();
        PreparedStatement pstm = conn.prepareStatement(sql);
        pstm.setInt(1, id);
        pstm.executeUpdate();
        connMysql.close();
        return true;
    }

    public boolean rechazar(int id) throws SQLException {
        String sql = "UPDATE usuarios SET estado_cuenta='rechazado' WHERE id_usuario=?";
        ConexionMysql connMysql = new ConexionMysql();
        Connection conn = connMysql.open();
        PreparedStatement pstm = conn.prepareStatement(sql);
        pstm.setInt(1, id);
        pstm.executeUpdate();
        connMysql.close();
        return true;
    }
}