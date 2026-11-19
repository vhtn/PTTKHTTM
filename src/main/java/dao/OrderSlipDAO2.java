package dao;

import java.sql.CallableStatement;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import model.OrderDetails2;
import model.OrderSlip2;
import model.ReservationSlip2;
import model.Staff2;
import model.Table2;

public class OrderSlipDAO2 extends DAO2 {

    public OrderSlipDAO2() {
        super();
        // TODO Auto-generated constructor stub
    }

    /**
     * Lay phieu goi mon dang su dung cua ban @tableId
     * @param tableId ma ban an
     * @return doi tuong OrderSlip2 kem chi tiet mon da goi
     */
    public OrderSlip2 getOrderSlip(int tableId) {
        OrderSlip2 kq = null;
        String sql = "{call getOrderSlip2(?)}"; // su dung stored procedure
        try {
            CallableStatement cs = con.prepareCall(sql);
            cs.setInt(1, tableId);
            ResultSet rs = cs.executeQuery();
            if (rs.next()) {
                kq = new OrderSlip2();
                kq.setId(rs.getInt("id"));
                kq.setDate(rs.getTimestamp("date"));
                kq.setGuestCount(rs.getInt("guestCount"));
                kq.setStatus(rs.getString("status"));

                // Nhan vien ban hang
                Staff2 staff = new Staff2();
                staff.setId(rs.getInt("tblSalesStaff2_id"));
                kq.setSalesStaff(staff);

                // Ban an
                Table2 t = new Table2();
                t.setId(rs.getInt("tableId"));
                t.setNumber(rs.getString("tableNumber"));
                t.setCapacity(rs.getInt("tableCapacity"));
                t.setStatus(rs.getString("tableStatus"));
                t.setLocation(rs.getString("tableLocation"));
                kq.setTable(t);

                // Phieu dat ban (neu co)
                int resId = rs.getInt("tblReservationSlip2_id");
                if (!rs.wasNull()) {
                    ReservationSlip2 res = new ReservationSlip2();
                    res.setId(resId);
                    kq.setReservationSlip(res);
                }

                // Danh sach chi tiet mon goi (goi sang OrderDetailsDAO2)
                ArrayList<OrderDetails2> dsChiTiet = (new OrderDetailsDAO2()).getOrderDetails(kq);
                if (dsChiTiet != null) {
                    kq.setListOrderDetails(dsChiTiet);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            kq = null;
        }
        return kq;
    }

    /**
     * Cap nhat trang thai phieu goi mon
     * @param id ma phieu goi mon
     * @param status trang thai moi
     * @return thanh cong hay that bai
     */
    public boolean updateStatus(int id, String status) {
        String sqlGetTable = "SELECT tblTable2_id FROM tblOrderSlip2 WHERE id = ?";
        String sqlUpdateOrderSlip = "UPDATE tblOrderSlip2 SET status = ? WHERE id = ?";
        String sqlUpdateTable = "UPDATE tblTable2 SET status = 'Trống' WHERE id = ? AND NOT EXISTS "
                + "(SELECT 1 FROM tblOrderSlip2 WHERE tblTable2_id = ? AND status = 'Đang sử dụng')";
        try {
            int tableId;
            try (PreparedStatement psTable = con.prepareStatement(sqlGetTable)) {
                psTable.setInt(1, id);
                try (ResultSet rs = psTable.executeQuery()) {
                    if (!rs.next()) {
                        return false;
                    }
                    tableId = rs.getInt("tblTable2_id");
                }
            }

            try (PreparedStatement ps = con.prepareStatement(sqlUpdateOrderSlip)) {
            ps.setString(1, status);
            ps.setInt(2, id);
                if (ps.executeUpdate() != 1) {
                    return false;
                }
            }

            if ("Đã thanh toán".equals(status)) {
                try (PreparedStatement psTable = con.prepareStatement(sqlUpdateTable)) {
                    psTable.setInt(1, tableId);
                    psTable.setInt(2, tableId);
                    psTable.executeUpdate();
                }
            }
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}