package model;

import java.io.Serializable;
import java.math.BigDecimal;
import java.util.Date;

public class Bill2 implements Serializable {
    private int id;
    private Date date;
    private BigDecimal totalAmount;
    private BigDecimal discountPercent;
    private String status; // 'Chua thanh toan', 'Da thanh toan'
    private BigDecimal cashGiven;
    private BigDecimal changeAmount;
    private OrderSlip2 orderSlip;
    private MembershipCard2 membershipCard;
    private Staff2 salesStaff;

    public Bill2() {
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public Date getDate() { return date; }
    public void setDate(Date date) { this.date = date; }
    public BigDecimal getTotalAmount() { return totalAmount; }
    public void setTotalAmount(BigDecimal totalAmount) { this.totalAmount = totalAmount; }
    public BigDecimal getDiscountPercent() { return discountPercent; }
    public void setDiscountPercent(BigDecimal discountPercent) { this.discountPercent = discountPercent; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    public BigDecimal getCashGiven() { return cashGiven; }
    public void setCashGiven(BigDecimal cashGiven) { this.cashGiven = cashGiven; }
    public BigDecimal getChangeAmount() { return changeAmount; }
    public void setChangeAmount(BigDecimal changeAmount) { this.changeAmount = changeAmount; }
    public OrderSlip2 getOrderSlip() { return orderSlip; }
    public void setOrderSlip(OrderSlip2 orderSlip) { this.orderSlip = orderSlip; }
    public MembershipCard2 getMembershipCard() { return membershipCard; }
    public void setMembershipCard(MembershipCard2 membershipCard) { this.membershipCard = membershipCard; }
    public Staff2 getSalesStaff() { return salesStaff; }
    public void setSalesStaff(Staff2 salesStaff) { this.salesStaff = salesStaff; }

}