package dao;

import model.Staff2;

public class StaffDAO2 extends DAO2{
    public StaffDAO2() {
        super();
    }

    public boolean checkLogin(Staff2 staff) {
        boolean check = false;
        if(staff.getUsername().contains("true") ||
                staff.getUsername().contains("=")||
                staff.getPassword().contains("true") ||
                staff.getPassword().contains("=")) return false;
        String sql = "{call checkLogin(?,?)}";
        try{
            java.sql.CallableStatement cs = con.prepareCall(sql);
            cs.setString(1, staff.getUsername());
            cs.setString(2, staff.getPassword());
            java.sql.ResultSet rs = cs.executeQuery();
            if(rs.next()) {
                staff.setId(rs.getInt("id"));
                staff.setName(rs.getString("name"));
                staff.setPosition(rs.getString("position"));
                check = true;
            }
        } catch (Exception e) {
            e.printStackTrace();
            check = false;
        }
        return check;
    }
}
