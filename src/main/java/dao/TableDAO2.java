package dao;

import java.sql.CallableStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import model.Table2;

public class TableDAO2 extends DAO2 {

    public TableDAO2() {
        super();
        // TODO Auto-generated constructor stub
    }

    /**
     * Lay danh sach tat ca ban an dang su dung can thanh toan
     * @return danh sach doi tuong Table2
     */
    public ArrayList<Table2> getAllTable() {
        ArrayList<Table2> kq = null;
        String sql = "{call getAllTable2()}"; // su dung stored procedure
        try {
            CallableStatement cs = con.prepareCall(sql);
            ResultSet rs = cs.executeQuery();
            while (rs.next()) {
                if (kq == null) kq = new ArrayList<Table2>();
                Table2 t = new Table2();
                t.setId(rs.getInt("id"));
                t.setNumber(rs.getString("number"));
                t.setCapacity(rs.getInt("capacity"));
                t.setStatus(rs.getString("status"));
                t.setLocation(rs.getString("location"));
                kq.add(t);
            }
        } catch (Exception e) {
            e.printStackTrace();
            kq = null;
        }
        return kq;
    }

    /**
     * Tim kiem ban an dang su dung theo so ban @number
     * @param number so ban can tim
     * @return danh sach doi tuong Table2 phu hop
     */
    public ArrayList<Table2> searchTableByNumber(String number) {
        ArrayList<Table2> kq = null;
        String sql = "{call searchTableByNumber2(?)}"; // su dung stored procedure
        try {
            CallableStatement cs = con.prepareCall(sql);
            cs.setString(1, number);
            ResultSet rs = cs.executeQuery();
            while (rs.next()) {
                if (kq == null) kq = new ArrayList<Table2>();
                Table2 t = new Table2();
                t.setId(rs.getInt("id"));
                t.setNumber(rs.getString("number"));
                t.setCapacity(rs.getInt("capacity"));
                t.setStatus(rs.getString("status"));
                t.setLocation(rs.getString("location"));
                kq.add(t);
            }
        } catch (Exception e) {
            e.printStackTrace();
            kq = null;
        }
        return kq;
    }
}