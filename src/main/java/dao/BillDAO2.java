package dao;

import java.math.BigDecimal;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import model.Bill2;

public class BillDAO2 extends DAO2 {

    public BillDAO2() {
        super();
    }

    public boolean saveBill(Bill2 bill) {
        if (bill == null || bill.getOrderSlip() == null) {
            return false;
        }

        String sqlFindBill = "SELECT id FROM tblBill2 WHERE tblOrderSlip2_id = ? FOR UPDATE";
        String sqlInsertBill = "INSERT INTO tblBill2(date, totalAmount, discountPercent, status, cashGiven, "
                + "changeAmount, tblOrderSlip2_id, tblSalesStaff2_id, tblMembershipCard2_id) "
                + "VALUES(?, ?, ?, 'Đã thanh toán', ?, ?, ?, ?, ?)";
        String sqlUpdateBill = "UPDATE tblBill2 SET date = ?, totalAmount = ?, discountPercent = ?, "
                + "status = 'Đã thanh toán', cashGiven = ?, changeAmount = ?, tblSalesStaff2_id = ?, "
                + "tblMembershipCard2_id = ? WHERE id = ?";

        try {
            int orderSlipId = bill.getOrderSlip().getId();
            int staffId = getSalesStaffId(bill);
            int existingBillId = 0;

            try (PreparedStatement psFind = con.prepareStatement(sqlFindBill)) {
                psFind.setInt(1, orderSlipId);
                try (ResultSet rs = psFind.executeQuery()) {
                    if (rs.next()) {
                        existingBillId = rs.getInt("id");
                    }
                }
            }

            Timestamp now = new Timestamp(System.currentTimeMillis());
            if (existingBillId == 0) {
                try (PreparedStatement psInsert = con.prepareStatement(sqlInsertBill)) {
                    psInsert.setTimestamp(1, now);
                    psInsert.setBigDecimal(2, bill.getTotalAmount());
                    setNullableDecimal(psInsert, 3, bill.getDiscountPercent());
                    setNullableDecimal(psInsert, 4, bill.getCashGiven());
                    setNullableDecimal(psInsert, 5, bill.getChangeAmount());
                    psInsert.setInt(6, orderSlipId);
                    psInsert.setInt(7, staffId);
                    setMembershipCard(psInsert, 8, bill);
                    return psInsert.executeUpdate() == 1;
                }
            }

            try (PreparedStatement psUpdate = con.prepareStatement(sqlUpdateBill)) {
                psUpdate.setTimestamp(1, now);
                psUpdate.setBigDecimal(2, bill.getTotalAmount());
                setNullableDecimal(psUpdate, 3, bill.getDiscountPercent());
                setNullableDecimal(psUpdate, 4, bill.getCashGiven());
                setNullableDecimal(psUpdate, 5, bill.getChangeAmount());
                psUpdate.setInt(6, staffId);
                setMembershipCard(psUpdate, 7, bill);
                psUpdate.setInt(8, existingBillId);
                return psUpdate.executeUpdate() == 1;
            }
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    private int getSalesStaffId(Bill2 bill) throws SQLException {
        if (bill.getSalesStaff() != null) {
            return bill.getSalesStaff().getId();
        }
        throw new SQLException("Khong tim thay nhan vien thanh toan");
    }

    private void setMembershipCard(PreparedStatement ps, int index, Bill2 bill) throws SQLException {
        if (bill.getMembershipCard() != null) {
            ps.setInt(index, bill.getMembershipCard().getId());
        } else {
            ps.setNull(index, java.sql.Types.INTEGER);
        }
    }

    private void setNullableDecimal(PreparedStatement ps, int index, BigDecimal value) throws SQLException {
        if (value != null) {
            ps.setBigDecimal(index, value);
        } else {
            ps.setNull(index, java.sql.Types.DECIMAL);
        }
    }
}
