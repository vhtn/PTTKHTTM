package dao;

import java.sql.CallableStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import model.MenuItem2;
import model.OrderDetails2;
import model.OrderSlip2;

public class OrderDetailsDAO2 extends DAO2 {

    public OrderDetailsDAO2() {
        super();
    }

    /**
     * Lay danh sach chi tiet mon an trong phieu goi mon
     * @param orderSlip doi tuong OrderSlip2
     * @return danh sach OrderDetails2
     */
    public ArrayList<OrderDetails2> getOrderDetails(OrderSlip2 orderSlip) {
        ArrayList<OrderDetails2> kq = null;
        String sql = "{call getOrderDetails2(?)}"; // su dung stored procedure
        try {
            CallableStatement cs = con.prepareCall(sql);
            cs.setInt(1, orderSlip.getId());
            ResultSet rs = cs.executeQuery();
            while (rs.next()) {
                if (kq == null) kq = new ArrayList<OrderDetails2>();
                MenuItem2 item = new MenuItem2(
                        rs.getInt("m_id"),
                        rs.getString("name"),
                        rs.getString("image"),
                        rs.getBigDecimal("m_price"),
                        rs.getString("m_status"),
                        rs.getString("description")
                );
                OrderDetails2 detail = new OrderDetails2(
                        rs.getInt("id"),
                        rs.getInt("quantity"),
                        rs.getBigDecimal("price"),
                        rs.getBigDecimal("amount"),
                        item
                );
                kq.add(detail);
            }
        } catch (Exception e) {
            e.printStackTrace();
            kq = null;
        }
        return kq;
    }
}