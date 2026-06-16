package org.lasalle.conection;

import java.sql.Connection;
import java.sql.DriverManager;

public class ConexionMysql {
    
    Connection conn;
    
    public Connection open() {
        String user = "root";
        String password = "Casta12345";
        String db_name = "nutriconsulta";
        String url = "jdbc:mysql://localhost:3306/" + db_name
                + "?useSSL=false"
                + "&allowPublicKeyRetrieval=true"
                + "&serverTimezone=America/Mexico_City"
                + "&characterEncoding=UTF-8";
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection(url, user, password);
            System.out.println("Conexión exitosa");
            return conn;
        } catch (Exception e) {
            System.out.println("Error de conexión: " + e.getMessage());
            e.printStackTrace();
            return null;
        }
    }
    
    public void close() {
        if (conn != null) {
            try {
                conn.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }
}