package model;

import java.io.Serializable;
import java.math.BigDecimal;

public class ComboDetails2 implements Serializable {
    private int id;
    private int quantity;
    private BigDecimal price;
    private BigDecimal amount;
    private Combo2 combo;
    private Dish2 dish;

    public ComboDetails2() {
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }
    public BigDecimal getPrice() { return price; }
    public void setPrice(BigDecimal price) { this.price = price; }
    public BigDecimal getAmount() { return amount; }
    public void setAmount(BigDecimal amount) { this.amount = amount; }
    public Combo2 getCombo() { return combo; }
    public void setCombo(Combo2 combo) { this.combo = combo; }
    public Dish2 getDish() { return dish; }
    public void setDish(Dish2 dish) { this.dish = dish; }
}