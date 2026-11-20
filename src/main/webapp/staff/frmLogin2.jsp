<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" import="java.util.ArrayList,dao.*,model.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Đăng nhập nhân viên | RestMan</title>
    <link href="../assets/restman.css" rel="stylesheet">
</head>
<body>
<header class="site-header"><a class="site-brand" href="../index.jsp">RestMan</a></header>

<div class="login-shell"><div class="login-card">
<h2 class="page-title">Đăng nhập</h2>
<%
    if(request.getParameter("err") !=null &&
            request.getParameter("err").equalsIgnoreCase("timeout")){
%> <div class="alert">Hết phiên làm việc. Vui lòng đăng nhập lại!</div><%
}else if(request.getParameter("err") !=null &&
        request.getParameter("err").equalsIgnoreCase("fail")){
%> <div class="alert">Sai tên đăng nhập/mật khẩu!</div><%
    }
%>
<form name="dangnhap" action="doLogin2.jsp" method="post">
    <table class="login-form-table" border="0">
        <tr>
            <td>Tên đăng nhập:</td>
            <td><input type="text" name="username" id="username"
                       required /></td>
        </tr>
        <tr>
            <td>Mật khẩu:</td>
            <td><input type="password" name="password" id="password"
                       required /></td>
        </tr>
        <tr>
            <td></td>
            <td><input type="submit" value="Đăng nhập" /></td>
        </tr>
    </table>
</form>
</div></div>
</body>
</html>