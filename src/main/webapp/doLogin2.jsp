<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" import="java.util.ArrayList,dao.*,model.*"%>
<%
        String username = (String)request.getParameter("username");
        String password = (String)request.getParameter("password");
        Staff2 staff = new Staff2();
    staff.setUsername(username);
    staff.setPassword(password);
    StaffDAO2 dao = new StaffDAO2();
    boolean kq = dao.checkLogin(staff);
    if(kq && (staff.getPosition().equalsIgnoreCase("SalesStaff"))){
        session.setAttribute("SalesStaff", staff);
        response.sendRedirect("salesStaff\\frmSalesMain2.jsp");
    }else{
        response.sendRedirect("gddangnhap.jsp?err=fail");
    }
%>