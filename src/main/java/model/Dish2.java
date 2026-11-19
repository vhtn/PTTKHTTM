package model;

public class Dish2 extends MenuItem2 {
    private String size;
    private String unit;
    private String category;

    public Dish2() {
        super();
    }

    public String getSize() { return size; }
    public void setSize(String size) { this.size = size; }
    public String getUnit() { return unit; }
    public void setUnit(String unit) { this.unit = unit; }
    public String getCategory() { return category; }
    public void setCategory(String category) { this.category = category; }
}