package org.lasalle.conection;
import java.sql.Connection;
import java.sql.DriverManager;
public class ConexionMysql {
    
    Connection conn;
    
    public Connection open() {
        String user     = System.getenv("MYSQLUSER")     != null ? System.getenv("MYSQLUSER")     : "root";
        String password = System.getenv("MYSQLPASSWORD") != null ? System.getenv("MYSQLPASSWORD") : "Casta12345";
        String host     = System.getenv("MYSQLHOST")     != null ? System.getenv("MYSQLHOST")     : "localhost";
        String port     = System.getenv("MYSQLPORT")     != null ? System.getenv("MYSQLPORT")     : "3306";
        String db       = System.getenv("MYSQLDATABASE") != null ? System.getenv("MYSQLDATABASE") : "nutriconsulta";
        
        String url = "jdbc:mysql://" + host + ":" + port + "/" + db
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
