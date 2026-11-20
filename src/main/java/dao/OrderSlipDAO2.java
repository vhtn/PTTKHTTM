package dao;

import java.sql.CallableStatement;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
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
     * Lay phieu goi mon dang su dung cua ban
     * @param tableId ma ban an
     * @return OrderSlip2 neu tim thay, null neu khong co phieu
     */
    public OrderSlip2 getOrderSlip(int tableId) {
        OrderSlip2 orderSlip = null;
        try (CallableStatement statement = con.prepareCall("{call getOrderSlip2(?)}")) {
            statement.setInt(1, tableId);
            try (ResultSet rs = statement.executeQuery()) {
                if (rs.next()) {
                    orderSlip = new OrderSlip2();
                    orderSlip.setId(rs.getInt("id"));
                    orderSlip.setDate(rs.getTimestamp("date"));
                    orderSlip.setGuestCount(rs.getInt("guestCount"));
                    orderSlip.setStatus(rs.getString("status"));

                    Staff2 staff = new Staff2();
                    staff.setId(rs.getInt("tblSalesStaff2_id"));
                    orderSlip.setSalesStaff(staff);

                    Table2 table = new Table2();
                    table.setId(rs.getInt("tableId"));
                    table.setNumber(rs.getString("tableNumber"));
                    table.setCapacity(rs.getInt("tableCapacity"));
                    table.setStatus(rs.getString("tableStatus"));
                    table.setLocation(rs.getString("tableLocation"));
                    orderSlip.setTable(table);

                    int reservationId = rs.getInt("tblReservationSlip2_id");
                    if (!rs.wasNull()) {
                        ReservationSlip2 reservation = new ReservationSlip2();
                        reservation.setId(reservationId);
                        orderSlip.setReservationSlip(reservation);
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return orderSlip;
    }

    /**
     * Danh dau phieu goi mon da thanh toan
     * @param id ma phieu goi mon
     * @return thanh cong hay that bai
     */
    public boolean updateStatus(int id) {
        String sqlUpdateOrderSlip = "UPDATE tblOrderSlip2 SET status = 'Đã thanh toán' WHERE id = ?";
        try {
            try (PreparedStatement ps = con.prepareStatement(sqlUpdateOrderSlip)) {
                ps.setInt(1, id);
                if (ps.executeUpdate() != 1) {
                    return false;
                }
            }
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}