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
     * Lay danh sach mon da goi trong phieu
     * @param orderSlipId ma phieu goi mon
     * @return danh sach chi tiet mon, null neu truy van that bai
     */
    public ArrayList<OrderDetails2> getOrderDetails(int orderSlipId) {
        if (orderSlipId <= 0) {
            throw new IllegalArgumentException("Mã phiếu gọi món phải lớn hơn 0.");
        }
        ArrayList<OrderDetails2> details = new ArrayList<OrderDetails2>();
        try {
            try (CallableStatement statement = con.prepareCall("{call getOrderDetails2(?)}")) {
                statement.setInt(1, orderSlipId);
                try (ResultSet rs = statement.executeQuery()) {
                    while (rs.next()) {
                        MenuItem2 item = new MenuItem2(
                                rs.getInt("m_id"),
                                rs.getString("name"),
                                rs.getString("image"),
                                rs.getBigDecimal("m_price"),
                                rs.getString("m_status"),
                                rs.getString("description")
                        );
                        details.add(new OrderDetails2(
                                rs.getInt("id"),
                                rs.getInt("quantity"),
                                rs.getBigDecimal("price"),
                                rs.getBigDecimal("amount"),
                                item
                        ));
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
        return details;
    }
}