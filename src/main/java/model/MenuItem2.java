package model;

import java.io.Serializable;
import java.math.BigDecimal;

public class MenuItem2 implements Serializable {
    private int id;
    private String name;
    private String image;
    private BigDecimal price;
    private String status; // 'Tam het', 'Ngung phuc vu', 'Con phuc vu'
    private String description;

    public MenuItem2() {
    }

    public MenuItem2(int id, String name, String image, BigDecimal price, String status, String description) {
        this.id = id;
        this.name = name;
        this.image = image;
        this.price = price;
        this.status = status;
        this.description = description;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public String getImage() { return image; }
    public void setImage(String image) { this.image = image; }
    public BigDecimal getPrice() { return price; }
    public void setPrice(BigDecimal price) { this.price = price; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
}