package model;

import java.io.Serializable;

public class Customer2 implements Serializable {
    private int id;
    private String name;
    private String phone;

    public Customer2() {
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }
}