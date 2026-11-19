package model;

import java.io.Serializable;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Date;

public class OrderSlip2 implements Serializable {
    private int id;
    private Date date;
    private int guestCount;
    private String status; // 'Dat truoc', 'Dang su dung', 'Da thanh toan'
    private Table2 table;
    private Staff2 salesStaff;
    private ReservationSlip2 reservationSlip;
    private ArrayList<OrderDetails2> listOrderDetails;

    public OrderSlip2() {
        listOrderDetails = new ArrayList<OrderDetails2>();
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public Date getDate() { return date; }
    public void setDate(Date date) { this.date = date; }
    public int getGuestCount() { return guestCount; }
    public void setGuestCount(int guestCount) { this.guestCount = guestCount; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    public Table2 getTable() { return table; }
    public void setTable(Table2 table) { this.table = table; }
    public Staff2 getSalesStaff() { return salesStaff; }
    public void setSalesStaff(Staff2 salesStaff) { this.salesStaff = salesStaff; }
    public ReservationSlip2 getReservationSlip() { return reservationSlip; }
    public void setReservationSlip(ReservationSlip2 reservationSlip) { this.reservationSlip = reservationSlip; }
    public ArrayList<OrderDetails2> getListOrderDetails() { return listOrderDetails; }
    public void setListOrderDetails(ArrayList<OrderDetails2> listOrderDetails) {
        this.listOrderDetails = listOrderDetails;
    }

    public BigDecimal getTotalAmount() {
        BigDecimal total = BigDecimal.ZERO;
        if (listOrderDetails != null) {
            for (OrderDetails2 detail : listOrderDetails) {
                if (detail.getAmount() != null) {
                    total = total.add(detail.getAmount());
                }
            }
        }
        return total;
    }
}