<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" import="java.util.*,java.math.*,dao.*,model.*"%>
<%!
    private String formatMoney(BigDecimal value) {
        return new java.text.DecimalFormat("#,##0.##",
                java.text.DecimalFormatSymbols.getInstance(java.util.Locale.GERMANY))
                .format(value.setScale(2, RoundingMode.HALF_UP));
    }
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Chi tiết món ăn | RestMan</title>
    <link href="../assets/restman.css" rel="stylesheet">
</head>

<%
    request.setCharacterEncoding("UTF-8");
    String idStr = request.getParameter("id");
    String keyword = request.getParameter("keyword");
    MenuItem2 item = null;
    MenuItemDAO2 menuItemDAO = new MenuItemDAO2();
    if (idStr != null && !idStr.trim().isEmpty()) {
        try {
            int id = Integer.parseInt(idStr.trim());
            item = menuItemDAO.getDishDetail(id);
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
        }
    }

    if (item instanceof Combo2) {
        Combo2 combo = (Combo2) item;
        comboDetailsList = menuItemDAO.getComboDetails(combo);
        if (comboDetailsList != null) {
            combo.setListComboDetails(comboDetailsList);
        }
    }
%>
<body class="bg-light">
<header class="site-header"><a class="site-brand" href="../index.jsp">RestMan</a></header>
<h2 class="page-title">Chi tiết thông tin món ăn</h2>
<main class="dish-detail-content">
<% if (item != null) { %>
<table class="dish-info-table" border="0">
    <tr>
        <td class="dish-info-image" rowspan="5">
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
<table class="data-table combo-components-table" style="border: 1px solid black; border-collapse: collapse;">
    <thead>
    <tr>
        <th>T.T</th>
        <th>Tên món</th>
        <th>Kích thước</th>
        <th>Đơn vị tính</th>
        <th>Số lượng</th>
    </tr>
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
<div class="search-table-footer">
    <button type="button" onclick="window.location.href='frmSearchDish2.jsp'">Quay lại</button>
</div>
</main>
</body>
</html>