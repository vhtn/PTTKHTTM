<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" import="java.util.*,java.math.*,dao.*,model.*"%>
<%!
    private String formatMoney(BigDecimal value) {
        return new java.text.DecimalFormat("#,##0.00",
                java.text.DecimalFormatSymbols.getInstance(java.util.Locale.GERMANY))
                .format(value.setScale(2, RoundingMode.HALF_UP));
    }
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Chi tiết thông tin món ăn</title>
</head>
<%
    request.setCharacterEncoding("UTF-8");
    String idStr = request.getParameter("id");
    MenuItem2 item = null;
    if (idStr != null && !idStr.trim().isEmpty()) {
        try {
            int id = Integer.parseInt(idStr.trim());
            item = (new MenuItemDAO2()).getDishDetail(id);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    String sizeStr = "";
    String unitStr = "";
    boolean isCombo = false;
    ArrayList<ComboDetails2> comboDetailsList = null;

    if (item != null) {
        if (item instanceof Dish2) {
            Dish2 d = (Dish2) item;
            sizeStr = (d.getSize() != null) ? d.getSize() : "";
            unitStr = (d.getUnit() != null) ? d.getUnit() : "";
        } else if (item instanceof Combo2) {
            Combo2 c = (Combo2) item;
            isCombo = true;
            sizeStr = (c.getPortion() != null) ? c.getPortion() : "";
            unitStr = "Set";
            comboDetailsList = c.getListComboDetails();
        }
    }
%>
<body>
<h2>Chi tiết thông tin món ăn</h2>
<% if (item != null) { %>
<table border="0">
    <tr>
        <td rowspan="5" style="padding-right: 20px;">
            <% if (item.getImage() != null && !item.getImage().trim().isEmpty()) { %>
            <img src="images/<%= item.getImage() %>" alt="<%= item.getName() %>" style="max-width: 200px; max-height: 180px;"/>
            <% } else { %>
            <span>(Không có hình ảnh)</span>
            <% } %>
        </td>
        <td>Tên món:</td>
        <td><strong><%= item.getName() %></strong></td>
    </tr>
    <tr>
        <td><%= isCombo ? "Khẩu phần:" : "Kích thước:" %></td>
        <td><%= sizeStr %></td>
    </tr>
    <tr>
        <td>Đơn giá:</td>
        <td><%= formatMoney(item.getPrice()) %> VNĐ</td>
    </tr>
    <% if (!isCombo) { %>
    <tr>
        <td>Đơn vị tính:</td>
        <td><%= unitStr %></td>
    </tr>
    <% } %>
    <tr>
        <td>Mô tả:</td>
        <td><%= (item.getDescription() != null) ? item.getDescription() : "" %></td>
    </tr>
</table>

<% if (isCombo) { %>
<h3>Thành phần</h3>
<table style="border: 1px solid black; border-collapse: collapse;">
    <thead>
    <td style="border: 1px solid black; padding: 0 15px 0 15px;">T.T</td>
    <td style="border: 1px solid black; padding: 0 15px 0 15px;">Tên món</td>
    <td style="border: 1px solid black; padding: 0 15px 0 15px;">Kích thước</td>
    <td style="border: 1px solid black; padding: 0 15px 0 15px;">Đơn vị tính</td>
    <td style="border: 1px solid black; padding: 0 15px 0 15px;">Số lượng</td>
    </thead>
    <%
        if (comboDetailsList != null && !comboDetailsList.isEmpty()) {
            for (int i = 0; i < comboDetailsList.size(); i++) {
                ComboDetails2 cd = comboDetailsList.get(i);
                Dish2 d = cd.getDish();
                String subName = (d != null) ? d.getName() : "";
                String subSize = (d != null && d.getSize() != null) ? d.getSize() : "";
                String subUnit = (d != null && d.getUnit() != null) ? d.getUnit() : "";
    %>
    <tr>
        <td style="text-align: center; border: 1px solid black; padding: 0 15px 0 15px;"><%= (i + 1) %></td>
        <td style="border: 1px solid black; padding: 0 15px 0 15px;"><%= subName %></td>
        <td style="text-align: center; border: 1px solid black; padding: 0 15px 0 15px;"><%= subSize %></td>
        <td style="text-align: center; border: 1px solid black; padding: 0 15px 0 15px;"><%= subUnit %></td>
        <td style="text-align: right; border: 1px solid black; padding: 0 15px 0 15px;"><%= cd.getQuantity() %></td>
    </tr>
    <%
        }
    } else {
    %>
    <tr>
        <td colspan="5" style="text-align: center; border: 1px solid black; padding: 0 15px 0 15px;">
            Chưa có thông tin thành phần chi tiết.
        </td>
    </tr>
    <%
        }
    %>
</table>
<% } %>
<% } else { %>
<h4>Không tìm thấy món ăn yêu cầu!</h4>
<% } %>
<br/>
<button type="button" onclick="window.location.href='frmSearchDish2.jsp'">Quay lại</button>
</body>
</html>