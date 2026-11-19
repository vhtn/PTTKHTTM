<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" import="java.util.*,dao.*,model.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Trang chủ nhân viên bán hàng</title>
</head>
<body>
<%
    Staff2 staff = (Staff2)session.getAttribute("SalesStaff");
    if(staff==null){
        response.sendRedirect("login2.jsp?err=timeout");
    }
%>
<h2>Trang chủ nhân viên bán hàng</h2>
<button type="button" onclick="window.location.href='frmSearchTable2.jsp'">
    Thanh toán hóa đơn
</button>
</body>
</html>