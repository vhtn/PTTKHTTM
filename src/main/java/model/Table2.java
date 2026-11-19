package model;

import java.io.Serializable;

public class Table2 implements Serializable {
    private int id;
    private String number;
    private int capacity;
    private String status; // 'Trong', 'Dang su dung'
    private String location;

    public Table2() {
    }

    public Table2(int id, String number, int capacity, String status, String location) {
        this.id = id;
        this.number = number;
        this.capacity = capacity;
        this.status = status;
        this.location = location;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public String getNumber() { return number; }
    public void setNumber(String number) { this.number = number; }
    public int getCapacity() { return capacity; }
    public void setCapacity(int capacity) { this.capacity = capacity; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    public String getLocation() { return location; }
    public void setLocation(String location) { this.location = location; }
}