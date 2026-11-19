package model;

import java.io.Serializable;
import java.math.BigDecimal;

public class OrderDetails2 implements Serializable {
    private int id;
    private int quantity;
    private BigDecimal price;
    private BigDecimal amount;
    private OrderSlip2 orderSlip;
    private MenuItem2 menuItem;

    public OrderDetails2() {
    }

    public OrderDetails2(int id, int quantity, BigDecimal price, BigDecimal amount, MenuItem2 menuItem) {
        this.id = id;
        this.quantity = quantity;
        this.price = price;
        this.amount = amount;
        this.menuItem = menuItem;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }
    public BigDecimal getPrice() { return price; }
    public void setPrice(BigDecimal price) { this.price = price; }
    public BigDecimal getAmount() { return amount; }
    public void setAmount(BigDecimal amount) { this.amount = amount; }
    public OrderSlip2 getOrderSlip() { return orderSlip; }
    public void setOrderSlip(OrderSlip2 orderSlip) { this.orderSlip = orderSlip; }
    public MenuItem2 getMenuItem() { return menuItem; }
    public void setMenuItem(MenuItem2 menuItem) { this.menuItem = menuItem; }
}