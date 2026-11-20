<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" import="java.util.*,dao.*,model.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Trang chủ nhân viên | RestMan</title>
    <link href="../assets/restman.css" rel="stylesheet">
</head>
<body class="bg-light">
<header class="site-header"><a class="site-brand" href="../index.jsp">RestMan</a></header>
<%
    Staff2 staff = (Staff2)session.getAttribute("SalesStaff");
    if(staff==null){
        response.sendRedirect("../staff/frmLogin2.jsp?err=timeout");
        return;
    }
%>
<main class="portal-home">
    <h2 class="page-title">Trang chủ nhân viên bán hàng</h2>
    <a class="btn" href="frmSearchTable2.jsp">Thanh toán hóa đơn</a>
</main>
</body>
</html>