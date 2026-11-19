package dao;

import java.sql.CallableStatement;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
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
        try {
            CallableStatement cs = con.prepareCall(sql);
            cs.setString(1, code);
            ResultSet rs = cs.executeQuery();
            if (rs.next()) {
                kq = new MembershipCard2();
                kq.setId(rs.getInt("id"));
                kq.setCode(rs.getString("code"));
                kq.setDate(rs.getDate("date"));
                kq.setStatus(rs.getString("status"));
                kq.setRankLevel(rs.getString("rank_level"));
                int points = rs.getInt("point");
                kq.setPoint(rs.wasNull() ? null : points);

                // Khach hang so huu the
                Customer2 customer = new Customer2();
                customer.setId(rs.getInt("customerId"));
                customer.setName(rs.getString("name"));
                customer.setPhone(rs.getString("phone"));
                kq.setCustomer(customer);

                // Nhan vien tao the
                Staff2 staff = new Staff2();
                staff.setId(rs.getInt("tblSalesStaff2_id"));
                kq.setSalesStaff(staff);
            }
        } catch (Exception e) {
            e.printStackTrace();
            kq = null;
        }
        return kq;
    }

    /**
     * Cap nhat diem tich luy cho the thanh vien
     * @param cardId ma the thanh vien
     * @param totalPoints tong diem moi
     * @return thanh cong hay that bai
     */
    public boolean updatePoint(int cardId, int totalPoints) {
        String sql = "UPDATE tblMembershipCard2 SET point = ? WHERE id = ?";
        try {
            try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, totalPoints);
            ps.setInt(2, cardId);
                return ps.executeUpdate() == 1;
            }
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}