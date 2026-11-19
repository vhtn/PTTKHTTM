package model;

import java.io.Serializable;
import java.math.BigDecimal;
import java.util.Date;

public class MembershipCard2 implements Serializable {
    private int id;
    private String code;
    private Date date;
    private String status; // 'Hoat dong', 'Khoa'
    private String rankLevel; // 'Vang', 'Bac', 'Dong'
    private Integer point;
    private Customer2 customer;
    private Staff2 salesStaff;

    public MembershipCard2() {
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public String getCode() { return code; }
    public void setCode(String code) { this.code = code; }
    public Date getDate() { return date; }
    public void setDate(Date date) { this.date = date; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    public String getRankLevel() { return rankLevel; }
    public void setRankLevel(String rankLevel) { this.rankLevel = rankLevel; }
    public Integer getPoint() { return point; }
    public void setPoint(Integer point) { this.point = point; }
    public Customer2 getCustomer() { return customer; }
    public void setCustomer(Customer2 customer) { this.customer = customer; }
    public Staff2 getSalesStaff() { return salesStaff; }
    public void setSalesStaff(Staff2 salesStaff) { this.salesStaff = salesStaff; }

    public BigDecimal getDiscountPercent() {
        if ("Vàng".equalsIgnoreCase(rankLevel)) return BigDecimal.valueOf(15);
        if ("Bạc".equalsIgnoreCase(rankLevel)) return BigDecimal.valueOf(10);
        if ("Đồng".equalsIgnoreCase(rankLevel)) return BigDecimal.valueOf(5);
        return BigDecimal.ZERO;
    }
}