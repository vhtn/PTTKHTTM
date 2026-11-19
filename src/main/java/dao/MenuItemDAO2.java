package dao;

import java.sql.CallableStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import model.Combo2;
import model.ComboDetails2;
import model.Dish2;
import model.MenuItem2;

public class MenuItemDAO2 extends DAO2 {

    public MenuItemDAO2() {
        super();
        // TODO Auto-generated constructor stub
    }

    /**
     * Lay toan bo mon an con phuc vu (gom ca mon le va combo)
     * @return danh sach mon an con phuc vu
     */
    public ArrayList<MenuItem2> getAllDish() {
        ArrayList<MenuItem2> kq = null;
        String sql = "{call getAllDish2()}"; // su dung stored procedure
        try {
            CallableStatement cs = con.prepareCall(sql);
            ResultSet rs = cs.executeQuery();
            while (rs.next()) {
                if (kq == null) kq = new ArrayList<MenuItem2>();
                MenuItem2 item = new MenuItem2();
                setMenuItemFields(item, rs);
                kq.add(item);
            }
        } catch (Exception e) {
            e.printStackTrace();
            kq = null;
        }
        return kq;
    }

    /**
     * Tim mon an con phuc vu co ten chua tu khoa @keyword
     * @param keyword tu khoa tim kiem
     * @return danh sach mon an phu hop
     */
    public ArrayList<MenuItem2> getDish(String keyword) {
        ArrayList<MenuItem2> kq = null;
        String sql = "{call getDish2(?)}"; // su dung stored procedure
        try {
            CallableStatement cs = con.prepareCall(sql);
            cs.setString(1, keyword);
            ResultSet rs = cs.executeQuery();
            while (rs.next()) {
                if (kq == null) kq = new ArrayList<MenuItem2>();
                MenuItem2 item = new MenuItem2();
                setMenuItemFields(item, rs);
                kq.add(item);
            }
        } catch (Exception e) {
            e.printStackTrace();
            kq = null;
        }
        return kq;
    }

    /**
     * Lay chi tiet mot mon an hoac combo theo @id
     * @param id ma mon an
     * @return doi tuong Dish2 hoac Combo2 (kem danh sach mon thanh phan)
     */
    public MenuItem2 getDishDetail(int id) {
        MenuItem2 kq = null;
        String sql = "{call getDishDetail2(?)}"; // su dung stored procedure
        try {
            CallableStatement cs = con.prepareCall(sql);
            cs.setInt(1, id);
            ResultSet rs = cs.executeQuery();
            if (rs.next()) {
                if (rs.getObject("dishId") != null) {
                    Dish2 dish = new Dish2();
                    setMenuItemFields(dish, rs);
                    dish.setSize(rs.getString("dishSize"));
                    dish.setUnit(rs.getString("dishUnit"));
                    dish.setCategory(rs.getString("dishCategory"));
                    kq = dish;
                } else if (rs.getObject("comboId") != null) {
                    Combo2 combo = new Combo2();
                    setMenuItemFields(combo, rs);
                    combo.setPortion(rs.getString("comboPortion"));
                    combo.setStartDate(rs.getDate("comboStartDate"));
                    combo.setEndDate(rs.getDate("comboEndDate"));
                    ArrayList<ComboDetails2> dsChiTiet = getComboDetails(combo);
                    if (dsChiTiet != null) {
                        combo.setListComboDetails(dsChiTiet);
                    }
                    kq = combo;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            kq = null;
        }
        return kq;
    }

    /**
     * Lay danh sach cac mon thanh phan cua combo
     * @param combo doi tuong Combo2
     * @return danh sach ComboDetails2
     */
    public ArrayList<ComboDetails2> getComboDetails(Combo2 combo) {
        ArrayList<ComboDetails2> kq = null;
        String sql = "{call getComboDetails2(?)}"; // su dung stored procedure
        try {
            CallableStatement cs = con.prepareCall(sql);
            cs.setInt(1, combo.getId());
            ResultSet rs = cs.executeQuery();
            while (rs.next()) {
                if (kq == null) kq = new ArrayList<ComboDetails2>();
                Dish2 dish = new Dish2();
                setMenuItemFields(dish, rs);
                dish.setSize(rs.getString("size"));
                dish.setUnit(rs.getString("unit"));
                dish.setCategory(rs.getString("category"));

                ComboDetails2 detail = new ComboDetails2();
                detail.setId(rs.getInt("detailId"));
                detail.setQuantity(rs.getInt("quantity"));
                detail.setPrice(rs.getBigDecimal("detailPrice"));
                detail.setAmount(rs.getBigDecimal("detailAmount"));
                detail.setCombo(combo);
                detail.setDish(dish);
                kq.add(detail);
            }
        } catch (Exception e) {
            e.printStackTrace();
            kq = null;
        }
        return kq;
    }

    private void setMenuItemFields(MenuItem2 item, ResultSet rs) throws SQLException {
        item.setId(rs.getInt("id"));
        item.setName(rs.getString("name"));
        item.setImage(rs.getString("image"));
        item.setPrice(rs.getBigDecimal("price"));
        item.setStatus(rs.getString("status"));
        item.setDescription(rs.getString("description"));
    }
}
