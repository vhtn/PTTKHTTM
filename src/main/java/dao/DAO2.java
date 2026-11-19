package dao;

import java.sql.Connection;
import java.sql.DriverManager;

public class DAO2 {
    public static Connection con;

    public DAO2() {
        if (con == null) {
            String dbUrl = "jdbc:mysql://localhost:3306/restman?autoReconnect=true&useSSL=false&allowPublicKeyRetrieval=true&useUnicode=true&characterEncoding=UTF-8";
            String dbClass = "com.mysql.cj.jdbc.Driver";
            try {
                Class.forName(dbClass);
                con = DriverManager.getConnection(dbUrl, "root", "SQL@thanh2308");
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }
}