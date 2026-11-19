<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" import="java.util.*,java.math.*,dao.*,model.*"%>
<%!
    private String formatMoney(BigDecimal value) {
        return new java.text.DecimalFormat("#,##0.00",
                java.text.DecimalFormatSymbols.getInstance(java.util.Locale.GERMANY))
                .format(value.setScale(2, RoundingMode.HALF_UP));
    }

    private String escapeHtml(String value) {
        if (value == null) return "";
        return value.replace("&", "&amp;").replace("\"", "&quot;")
                .replace("<", "&lt;").replace(">", "&gt;").replace("'", "&#39;");
    }
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Tìm kiếm thông tin món ăn</title>
</head>
<%
    request.setCharacterEncoding("UTF-8");
    String key = request.getParameter("keyword");
    MenuItemDAO2 dao = new MenuItemDAO2();
    ArrayList<MenuItem2> list = null;
    if (key != null && !key.trim().isEmpty()) {
        list = dao.getDish(key.trim());
    } else {
        list = dao.getAllDish();
    }
%>
<body>
<h2>Tìm kiếm thông tin món ăn</h2>
<form name="timkiemmon" action="frmSearchDish2.jsp" method="get">
    <table border="0">
        <tr>
            <td>Nhập tên món:</td>
            <td><input type="text" name="keyword" value="<%= escapeHtml(key) %>" /></td>
            <td><input type="submit" value="Tìm kiếm" /></td>
        </tr>
    </table>
</form>
<br/>
<table style="border: 1px solid black; border-collapse: collapse;">
    <thead>
    <td style="border: 1px solid black; padding: 0 15px 0 15px;">T.T</td>
    <td style="border: 1px solid black; padding: 0 15px 0 15px;">Tên món</td>
    <td style="border: 1px solid black; padding: 0 15px 0 15px;">Đơn giá (VNĐ)</td>
    <td style="border: 1px solid black; padding: 0 15px 0 15px;">Hình ảnh</td>
    <td style="border: 1px solid black; padding: 0 15px 0 15px;">Chọn</td>
    </thead>
    <%
        if (list != null && !list.isEmpty()) {
            for (int i = 0; i < list.size(); i++) {
                MenuItem2 item = list.get(i);
    %>
    <tr>
        <td style="text-align: center; border: 1px solid black; padding: 0 15px 0 15px;"><%= (i + 1) %></td>
        <td style="border: 1px solid black; padding: 0 15px 0 15px;"><%= item.getName() %></td>
        <td style="text-align: right; border: 1px solid black; padding: 0 15px 0 15px;"><%= formatMoney(item.getPrice()) %></td>
        <td style="text-align: center; border: 1px solid black; padding: 0 15px 0 15px;">
            <% if (item.getImage() != null && !item.getImage().trim().isEmpty()) { %>
            <img src="images/<%= item.getImage() %>" alt="<%= item.getName() %>" style="max-height: 35px; max-width: 60px;"/>
            <% } %>
        </td>
        <td style="text-align: center; border: 1px solid black; padding: 0 15px 0 15px;">
            <a href="frmDishDetail2.jsp?id=<%= item.getId() %>&amp;keyword=<%= java.net.URLEncoder.encode(key != null ? key : "", "UTF-8") %>">Chọn</a>
        </td>
    </tr>
    <%
        }
    } else {
    %>
    <tr>
        <td colspan="5" style="text-align: center; border: 1px solid black; padding: 0 15px 0 15px;">
            Không tìm thấy món ăn nào.
        </td>
    </tr>
    <%
        }
    %>
</table>
<br/>
<button type="button" onclick="window.location.href='frmCustomerMain2.jsp'">Quay lại</button>
</body>
</html>