<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" import="java.util.*,java.text.SimpleDateFormat,java.math.*,dao.*,model.*"%>
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
    <title>Chi tiết phiếu gọi món</title>
</head>
<%
    // lay id nhan vien ban hang
    Staff2 s = (Staff2)session.getAttribute("SalesStaff");
    if(s==null){
        response.sendRedirect("login2.jsp?err=timeout");
    }
    // lay danh sach chi tiet phieu goi mon theo id ban an
    request.setCharacterEncoding("UTF-8");
    String tableIdStr = request.getParameter("tableId");
    OrderSlip2 orderSlip = null;
    if (tableIdStr != null && !tableIdStr.trim().isEmpty()) {
        try {
            int tableId = Integer.parseInt(tableIdStr.trim());
            orderSlip = (new OrderSlipDAO2()).getOrderSlip(tableId);
            session.setAttribute("currentOrderSlip", orderSlip);
            session.removeAttribute("currentCard");
        } catch (Exception e) {
            e.printStackTrace();
        }
    } else {
        orderSlip = (OrderSlip2) session.getAttribute("currentOrderSlip");
    }

    SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm");
    String currentDateStr = sdf.format(new Date());
%>
<body>
<h2>Chi tiết phiếu gọi món</h2>
<% if (orderSlip != null) { %>
<p>Số bàn: <strong><%= (orderSlip.getTable() != null && orderSlip.getTable().getNumber() != null) ? orderSlip.getTable().getNumber() : ("Bàn " + tableIdStr) %></strong></p>
<p>Ngày: <strong><%= currentDateStr %></strong></p>

<table style="border: 1px solid black; border-collapse: collapse;">
    <thead>
    <td style="border: 1px solid black; padding: 0 15px 0 15px;">T.T</td>
    <td style="border: 1px solid black; padding: 0 15px 0 15px;">Tên món</td>
    <td style="border: 1px solid black; padding: 0 15px 0 15px;">Số lượng</td>
    <td style="border: 1px solid black; padding: 0 15px 0 15px;">Đơn giá (VNĐ)</td>
    <td style="border: 1px solid black; padding: 0 15px 0 15px;">Thành tiền (VNĐ)</td>
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
<p>Tổng tiền: <strong><%= formatMoney(orderSlip.getTotalAmount()) %> VNĐ</strong></p>

<button type="button" onclick="window.location.href='frmBill2.jsp'">Xác nhận thanh toán</button>
<button type="button" onclick="window.location.href='frmSearchTable2.jsp'">Quay lại</button>
<% } else { %>
<h4>Bàn này chưa có phiếu gọi món nào cần thanh toán!</h4>
<button type="button" onclick="window.location.href='frmSearchTable2.jsp'">Quay lại</button>
<% } %>
</body>
</html>