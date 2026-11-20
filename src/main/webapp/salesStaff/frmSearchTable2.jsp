<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" import="java.util.*,dao.*,model.*"%>
<%!
    private boolean isValidSearchText(String value) {
        return value != null && value.matches("[\\p{L}\\p{N} ]*");
    }
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Tìm kiếm bàn ăn | RestMan</title>
    <link href="../assets/restman.css" rel="stylesheet">
</head>
<%
    // lay id nhan vien ban hang
    Staff2 s = (Staff2)session.getAttribute("SalesStaff");
    if(s==null){
        response.sendRedirect("../staff/frmLogin2.jsp?err=timeout");
        return;
    }
    // lay danh sach ban an theo tu khoa tim kiem
    request.setCharacterEncoding("UTF-8");
    String key = request.getParameter("keyword");
    TableDAO2 dao = new TableDAO2();
    ArrayList<Table2> list = null;
    boolean invalidKeyword = key != null && !key.trim().isEmpty() && !isValidSearchText(key);
    if (invalidKeyword) {
        list = dao.getAllTable();
    } else if (key != null && !key.trim().isEmpty()) {
        list = dao.searchTableByNumber(key.trim());
    } else {
        list = dao.getAllTable();
    }
%>
<body class="bg-light">
<% if (invalidKeyword) { %>
<script type="text/javascript">alert("Dữ liệu không phù hợp");</script>
<% } %>
<header class="site-header"><a class="site-brand" href="../index.jsp">RestMan</a></header>
<main class="search-table-content">
<h2 class="page-title">Tìm kiếm bàn ăn</h2>
<form class="dish-search-form" name="timkiemban" action="frmSearchTable2.jsp" method="get">
    <label for="keyword">Nhập số bàn:</label>
    <input type="text" id="keyword" name="keyword" value="<%= (key != null) ? key : "" %>" />
    <input type="submit" value="Tìm kiếm" />
</form>
<div class="table-results-scroll">
<table class="data-table table-results-table" style="border: 1px solid black; border-collapse: collapse;">
    <thead>
    <tr>
        <th>T.T</th>
        <th>Số bàn</th>
        <th>Sức chứa</th>
        <th>Trạng thái</th>
        <th>Vị trí</th>
        <th>Thao tác</th>
    </tr>
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
</div>
<div class="search-table-footer">
    <button type="button" onclick="window.location.href='frmSalesMain2.jsp'">Quay lại</button>
</div>
</main>
</body>
</html>