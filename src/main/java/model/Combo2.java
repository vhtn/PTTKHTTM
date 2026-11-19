package model;

import java.util.ArrayList;
import java.util.Date;

public class Combo2 extends MenuItem2 {
    private String portion;
    private Date startDate;
    private Date endDate;
    private ArrayList<ComboDetails2> listComboDetails;

    public Combo2() {
        super();
        listComboDetails = new ArrayList<ComboDetails2>();
    }

    public String getPortion() { return portion; }
    public void setPortion(String portion) { this.portion = portion; }
    public Date getStartDate() { return startDate; }
    public void setStartDate(Date startDate) { this.startDate = startDate; }
    public Date getEndDate() { return endDate; }
    public void setEndDate(Date endDate) { this.endDate = endDate; }
    public ArrayList<ComboDetails2> getListComboDetails() { return listComboDetails; }
    public void setListComboDetails(ArrayList<ComboDetails2> listComboDetails) {
        this.listComboDetails = listComboDetails;
    }
}