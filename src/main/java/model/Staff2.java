package model;

import java.io.Serializable;
import java.util.Date;

public class Staff2 implements Serializable {
    private int id;
    private String name;
    private String username;
    private String password;
    private Date birthday;
    private String address;
    private String email;
    private String phone;
    private String position;
    private String note;

    public Staff2() {
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }
    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }
    public Date getBirthday() { return birthday; }
    public void setBirthday(Date birthday) { this.birthday = birthday; }
    public String getAddress() { return address; }
    public void setAddress(String address) { this.address = address; }
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }
    public String getPosition() { return position; }
    public void setPosition(String position) { this.position = position; }
    public String getNote() { return note; }
    public void setNote(String note) { this.note = note; }
}