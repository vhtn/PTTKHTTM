package model;

import java.io.Serializable;
import java.util.Date;

public class ReservationSlip2 implements Serializable {
    private int id;
    private int guestCount;
    private Date bookingDate;
    private String status;
    private Customer2 customer;
    private Table2 table;
    private Staff2 salesStaff;

    public ReservationSlip2() {
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public int getGuestCount() { return guestCount; }
    public void setGuestCount(int guestCount) { this.guestCount = guestCount; }
    public Date getBookingDate() { return bookingDate; }
    public void setBookingDate(Date bookingDate) { this.bookingDate = bookingDate; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    public Customer2 getCustomer() { return customer; }
    public void setCustomer(Customer2 customer) { this.customer = customer; }
    public Table2 getTable() { return table; }
    public void setTable(Table2 table) { this.table = table; }
    public Staff2 getSalesStaff() { return salesStaff; }
    public void setSalesStaff(Staff2 salesStaff) { this.salesStaff = salesStaff; }
}