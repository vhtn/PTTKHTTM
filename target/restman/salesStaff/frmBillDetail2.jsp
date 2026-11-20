<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" import="java.util.*,java.text.SimpleDateFormat,java.math.*,dao.*,model.*"%>
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
    <title>Chi tiết phiếu gọi món | RestMan</title>
    <link href="../assets/restman.css" rel="stylesheet">
</head>
<%
    // lay id nhan vien ban hang
    Staff2 s = (Staff2)session.getAttribute("SalesStaff");
    if(s==null){
        response.sendRedirect("../staff/frmLogin2.jsp?err=timeout");
    }
    // lay danh sach chi tiet phieu goi mon theo id ban an
    request.setCharacterEncoding("UTF-8");
    String tableIdStr = request.getParameter("tableId");
    OrderSlip2 orderSlip = null;
    if (tableIdStr != null && !tableIdStr.trim().isEmpty()) {
        try {
            int tableId = Integer.parseInt(tableIdStr.trim());
            orderSlip = (new OrderSlipDAO2()).getOrderSlip(tableId);
            if (orderSlip != null) {
                ArrayList<OrderDetails2> details =
                        (new OrderDetailsDAO2()).getOrderDetails(orderSlip);
                if (details == null) {
                    orderSlip = null;
                    session.removeAttribute("currentOrderSlip");
                } else {
                    orderSlip.setListOrderDetails(details);
                    session.setAttribute("currentOrderSlip", orderSlip);
                }
            } else {
                session.removeAttribute("currentOrderSlip");
            }
            session.removeAttribute("currentCard");
        } catch (Exception e) {
            e.printStackTrace();
            session.removeAttribute("currentOrderSlip");
            session.removeAttribute("currentCard");
        }
    } else {
        orderSlip = (OrderSlip2) session.getAttribute("currentOrderSlip");
    }

    SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm");
    String currentDateStr = sdf.format(new Date());
%>
<body class="bg-light">
<header class="site-header"><a class="site-brand" href="../index.jsp">RestMan</a></header>
<h2 class="page-title">Chi tiết hoá đơn</h2>
<main class="order-detail-content">
<% if (orderSlip != null) { %>
<div class="order-detail-meta">
    <span>Số bàn: <strong><%= (orderSlip.getTable() != null && orderSlip.getTable().getNumber() != null) ? orderSlip.getTable().getNumber() : ("Bàn " + tableIdStr) %></strong></span>
    <span>Thời gian: <strong><%= currentDateStr %></strong></span>
</div>

<table class="order-detail-table" style="border: 1px solid black; border-collapse: collapse;">
    <thead>
    <tr>
        <td>T.T</td>
        <td>Tên món</td>
        <td>Số lượng</td>
        <td>Đơn giá (VNĐ)</td>
        <td>Thành tiền (VNĐ)</td>
    </tr>
    </thead>
    <%
        ArrayList<OrderDetails2> listDetails = orderSlip.getListOrderDetails();
        if (listDetails != null && !listDetails.isEmpty()) {
            for (int i = 0; i < listDetails.size(); i++) {
                OrderDetails2 detail = listDetails.get(i);
    %>
    <tr>
        <td style="text-align: center; border: 1px solid black; padding: 0 15px 0 15px;"><%= (i + 1) %></td>
        <td style="border: 1px solid black; padding: 0 15px 0 15px;"><%= detail.getMenuItem().getName() %></td>
        <td style="text-align: center; border: 1px solid black; padding: 0 15px 0 15px;"><%= detail.getQuantity() %></td>
        <td style="text-align: right; border: 1px solid black; padding: 0 15px 0 15px;"><%= formatMoney(detail.getPrice()) %></td>
        <td style="text-align: right; border: 1px solid black; padding: 0 15px 0 15px;"><%= formatMoney(detail.getAmount()) %></td>
    </tr>
    <%
        }
    } else {
    %>
    <tr>
        <td colspan="5" style="text-align: center; border: 1px solid black; padding: 0 15px 0 15px;">
            Chưa có món ăn nào trong phiếu.
        </td>
    </tr>
    <%
        }
    %>
</table>
<div class="order-detail-total">Tổng tiền: <strong><%= formatMoney(orderSlip.getTotalAmount()) %> VNĐ</strong></div>

<div class="order-detail-actions">
    <button type="button" onclick="window.location.href='frmSearchTable2.jsp'">Quay lại</button>
    <button type="button" onclick="window.location.href='frmBill2.jsp'">Xác nhận thanh toán</button>
</div>
<% } else { %>
<h4>Bàn này chưa có phiếu gọi món nào cần thanh toán!</h4>
<button type="button" onclick="window.location.href='frmSearchTable2.jsp'">Quay lại</button>
<% } %>
</main>
</body>
</html>