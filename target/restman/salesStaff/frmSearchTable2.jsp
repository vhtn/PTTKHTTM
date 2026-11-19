<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" import="java.util.*,dao.*,model.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Tìm kiếm bàn ăn</title>
</head>
<%
    // lay id nhan vien ban hang
    Staff2 s = (Staff2)session.getAttribute("SalesStaff");
    if(s==null){
        response.sendRedirect("login2.jsp?err=timeout");
    }
    // lay danh sach ban an theo tu khoa tim kiem
    request.setCharacterEncoding("UTF-8");
    String key = request.getParameter("keyword");
    TableDAO2 dao = new TableDAO2();
    ArrayList<Table2> list = null;
    if (key != null && !key.trim().isEmpty()) {
        list = dao.searchTableByNumber(key.trim());
    } else {
        list = dao.getAllTable();
    }
%>
<body>
<h2>Tìm kiếm bàn ăn</h2>
<form name="timkiemban" action="frmSearchTable2.jsp" method="get">
    <table border="0">
        <tr>
            <td>Nhập số bàn:</td>
            <td><input type="text" name="keyword" value="<%= (key != null) ? key : "" %>" /></td>
            <td><input type="submit" value="Tìm kiếm" /></td>
        </tr>
    </table>
</form>
<br/>
<table style="border: 1px solid black; border-collapse: collapse;">
    <thead>
    <td style="border: 1px solid black; padding: 0 15px 0 15px;">T.T</td>
    <td style="border: 1px solid black; padding: 0 15px 0 15px;">Số bàn</td>
    <td style="border: 1px solid black; padding: 0 15px 0 15px;">Sức chứa</td>
    <td style="border: 1px solid black; padding: 0 15px 0 15px;">Trạng thái</td>
    <td style="border: 1px solid black; padding: 0 15px 0 15px;">Vị trí</td>
    <td style="border: 1px solid black; padding: 0 15px 0 15px;">Chọn</td>
    </thead>
    <%
        if (list != null && !list.isEmpty()) {
            for (int i = 0; i < list.size(); i++) {
                Table2 t = list.get(i);
    %>
    <tr>
        <td style="text-align: center; border: 1px solid black; padding: 0 15px 0 15px;"><%= (i + 1) %></td>
        <td style="text-align: center; border: 1px solid black; padding: 0 15px 0 15px;"><%= t.getNumber() %></td>
        <td style="text-align: center; border: 1px solid black; padding: 0 15px 0 15px;"><%= t.getCapacity() %> người</td>
        <td style="text-align: center; border: 1px solid black; padding: 0 15px 0 15px;"><%= t.getStatus() %></td>
        <td style="text-align: center; border: 1px solid black; padding: 0 15px 0 15px;"><%= t.getLocation() %></td>
        <td style="text-align: center; border: 1px solid black; padding: 0 15px 0 15px;">
            <a href="frmBillDetail2.jsp?tableId=<%= t.getId() %>">Chọn</a>
        </td>
    </tr>
    <%
        }
    } else {
    %>
    <tr>
        <td colspan="6" style="text-align: center; border: 1px solid black; padding: 0 15px 0 15px;">
            Không có bàn ăn nào phù hợp.
        </td>
    </tr>
    <%
        }
    %>
</table>
<br/>
<button type="button" onclick="window.location.href='frmSalesMain2.jsp'">Quay lại</button>
</body>
</html>