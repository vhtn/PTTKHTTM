package dao;

import java.math.BigDecimal;
import java.sql.CallableStatement;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.Calendar;
import java.util.Date;
import model.Customer2;
import model.MembershipCard2;
import model.Staff2;

public class MembershipCardDAO2 extends DAO2 {

    public MembershipCardDAO2() {
        super();
        // TODO Auto-generated constructor stub
    }

    /**
     * Kiem tra va lay thong tin the thanh vien theo ma the @code
     * @param code ma the thanh vien
     * @return doi tuong MembershipCard2 neu hop le, null neu khong ton tai/bi khoa
     */
    public MembershipCard2 getCardByCode(String code) {
        MembershipCard2 kq = null;
        String sql = "{call getCardByCode2(?)}"; // su dung stored procedure
        try (CallableStatement cs = con.prepareCall(sql)) {
            cs.setString(1, code);
            try (ResultSet rs = cs.executeQuery()) {
                if (rs.next()) {
                    kq = new MembershipCard2();
                    kq.setId(rs.getInt("id"));
                    kq.setCode(rs.getString("code"));
                    kq.setDate(rs.getDate("date"));
                    kq.setStatus(rs.getString("status"));
                    kq.setRankLevel(rs.getString("rank_level"));
                    int points = rs.getInt("point");
                    kq.setPoint(rs.wasNull() ? null : points);

                    Customer2 customer = new Customer2();
                    customer.setId(rs.getInt("customerId"));
                    customer.setName(rs.getString("name"));
                    customer.setPhone(rs.getString("phone"));
                    kq.setCustomer(customer);

                    Staff2 staff = new Staff2();
                    staff.setId(rs.getInt("tblSalesStaff2_id"));
                    kq.setSalesStaff(staff);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            kq = null;
        }
        if (kq != null) {
            try {
                if (!resetIfInactive(kq.getId(), kq.getDate())) {
                    kq.setPoint(0);
                    kq.setRankLevel("Chưa có");
                }
            } catch (SQLException e) {
                e.printStackTrace();
                return null;
            }
        }
        return kq;
    }

    /**
     * Cap nhat diem tich luy cho the thanh vien
     * @param cardId ma the thanh vien
     * @param paidAmount so tien cuoi cung khach thanh toan sau giam gia
     * @return thanh cong hay that bai
     */
    public boolean updatePoint(int cardId, BigDecimal paidAmount) {
        if (paidAmount == null || paidAmount.signum() < 0) {
            return false;
        }

        try {
            int pointsToAdd = paidAmount.divideToIntegralValue(BigDecimal.valueOf(100000)).intValueExact();
            int currentPoints;
            Date cardDate;
            try (PreparedStatement ps = con.prepareStatement(
                    "SELECT point, date FROM tblMembershipCard2 WHERE id = ? FOR UPDATE")) {
                ps.setInt(1, cardId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (!rs.next()) {
                        return false;
                    }
                    currentPoints = rs.getInt("point");
                    if (rs.wasNull()) {
                        currentPoints = 0;
                    }
                    cardDate = rs.getDate("date");
                }
            }

            if (!isInactive(cardId, cardDate)) {
                currentPoints = Math.addExact(currentPoints, pointsToAdd);
            } else {
                currentPoints = pointsToAdd;
            }

            String rank = getRankForPoints(currentPoints);
            try (PreparedStatement ps = con.prepareStatement(
                    "UPDATE tblMembershipCard2 SET point = ?, rank_level = ? WHERE id = ?")) {
                ps.setInt(1, currentPoints);
                ps.setString(2, rank);
                ps.setInt(3, cardId);
                return ps.executeUpdate() == 1;
            }
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    private boolean resetIfInactive(int cardId, Date cardDate) throws SQLException {
        if (!isInactive(cardId, cardDate)) {
            return true;
        }

        try (PreparedStatement ps = con.prepareStatement(
                "UPDATE tblMembershipCard2 SET point = 0, rank_level = 'Chưa có' WHERE id = ?")) {
            ps.setInt(1, cardId);
            if (ps.executeUpdate() != 1) {
                throw new SQLException("Không thể đặt lại điểm thẻ thành viên.");
            }
        }
        return false;
    }

    private boolean isInactive(int cardId, Date cardDate) throws SQLException {
        Timestamp lastUse;
        try (PreparedStatement ps = con.prepareStatement(
                "SELECT MAX(date) AS lastUse FROM tblBill2 "
                        + "WHERE tblMembershipCard2_id = ? AND status = 'Đã thanh toán'")) {
            ps.setInt(1, cardId);
            try (ResultSet rs = ps.executeQuery()) {
                rs.next();
                lastUse = rs.getTimestamp("lastUse");
            }
        }

        Date activityDate = lastUse != null ? lastUse : cardDate;
        if (activityDate == null) {
            return false;
        }

        Calendar expirationDate = Calendar.getInstance();
        expirationDate.add(Calendar.MONTH, -6);
        return !activityDate.after(expirationDate.getTime());
    }

    private String getRankForPoints(int points) {
        if (points >= 1000) return "Vàng";
        if (points >= 500) return "Bạc";
        if (points >= 100) return "Đồng";
        return "Chưa có";
    }
}