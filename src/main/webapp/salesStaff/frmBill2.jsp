<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" import="java.util.*,java.text.SimpleDateFormat,java.math.*,dao.*,model.*"%>
<%!
    private BigDecimal calcFinalAmount(BigDecimal totalAmount, BigDecimal discountPercent) {
        return totalAmount.multiply(BigDecimal.valueOf(100).subtract(discountPercent))
                .divide(BigDecimal.valueOf(100), 2, RoundingMode.HALF_UP);
    }

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
    <title>Hóa đơn bán hàng</title>
</head>
<%
    // lay id nhan vien ban hang
    Staff2 s = (Staff2)session.getAttribute("SalesStaff");
    if(s==null){
        response.sendRedirect("login2.jsp?err=timeout");
    }
    request.setCharacterEncoding("UTF-8");

    // 1. Kiem tra session phieu goi mon
    OrderSlip2 orderSlip = (OrderSlip2) session.getAttribute("currentOrderSlip");
    if (orderSlip == null) {
        response.sendRedirect("frmSearchTable2.jsp");
        return;
    }

    // 2. Kiem tra ma the thanh vien
    String cardCode = request.getParameter("cardCode");
    MembershipCard2 card = null;
    BigDecimal discountPercent = BigDecimal.ZERO;
    if (cardCode != null) {
        if (!cardCode.trim().isEmpty()) {
            card = (new MembershipCardDAO2()).getCardByCode(cardCode.trim());
            if (card != null && "Hoạt động".equalsIgnoreCase(card.getStatus())) {
                session.setAttribute("currentCard", card);
            } else {
                session.removeAttribute("currentCard");
            }
        } else {
            session.removeAttribute("currentCard");
        }
    } else {
        card = (MembershipCard2) session.getAttribute("currentCard");
    }

    if (card != null) {
        discountPercent = card.getDiscountPercent();
    }

    // 3. Tinh toan tien hoa don (lam tron ve VND, khop voi doSaveBill2.jsp)
    BigDecimal totalAmount = orderSlip.getTotalAmount();
    BigDecimal finalAmount = calcFinalAmount(totalAmount, discountPercent);
    BigDecimal discountAmount = totalAmount.subtract(finalAmount);

    SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm");
    String currentDateStr = sdf.format(new Date());
%>
<body>
<h2>Hóa đơn bán hàng</h2>
<table border="0">
    <tr>
        <td><strong>Nhà hàng RestMan</strong> - Số 2 - Phố A - Phường B, Thành phố C (DĐ: 0908123xxx)</td>
    </tr>
    <tr>
        <td>Số hóa đơn: <strong><%= orderSlip.getId() %></strong> | Ngày: <strong><%= currentDateStr %></strong></td>
    </tr>
</table>
<br/>

<!-- Form kiem tra ma the thanh vien -->
<form name="kiemtrathe" action="frmBill2.jsp" method="get">
    <table border="0">
        <tr>
            <td>Mã thẻ thành viên (nếu có):</td>
            <td><input type="text" name="cardCode" value="<%= (cardCode != null) ? cardCode : (card != null ? card.getCode() : "") %>" /></td>
            <td><input type="submit" value="Kiểm tra" /></td>
        </tr>
    </table>
</form>

<% if (card != null) { %>
<p style="color: green;">Thẻ hợp lệ - Khách hàng: <strong><%= card.getCustomer().getName() %></strong> | Hạng: <strong><%= card.getRankLevel() %></strong> (Giảm <%= card.getDiscountPercent().intValue() %>%)</p>
<% } else if (cardCode != null && !cardCode.trim().isEmpty()) { %>
<p style="color: red;">Không tìm thấy mã thẻ hoặc thẻ đang bị khoá!</p>
<% } %>

<!-- Form luu va in hoa don -->
<form name="thanhtoan" action="doSaveBill2.jsp" method="post">
    <input type="hidden" name="cardCode" value="<%= card != null ? card.getCode() : "" %>" />
    <input type="hidden" name="discountPercent" value="<%= discountPercent.toPlainString() %>" />
    <input type="hidden" name="totalAmount" value="<%= totalAmount.toPlainString() %>" />
    <input type="hidden" name="finalAmount" value="<%= finalAmount.toPlainString() %>" />

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
                Không có thông tin món ăn.
            </td>
        </tr>
        <%
            }
        %>
    </table>
    <br/>

    <table border="0">
        <tr>
            <td>Tổng tiền:</td>
            <td><strong><%= formatMoney(totalAmount) %> VNĐ</strong></td>
        </tr>
        <tr>
            <td>Giảm giá (<%= discountPercent.intValue() %>%):</td>
            <td><strong><%= formatMoney(discountAmount) %> VNĐ</strong></td>
        </tr>
        <tr>
            <td>Tổng cộng phải thanh toán:</td>
            <td><strong><%= formatMoney(finalAmount) %> VNĐ</strong></td>
        </tr>
        <tr>
            <td>Tiền khách đưa:</td>
            <td>
                <input type="number" id="cashGiven" name="cashGiven" step="0.01" min="<%= finalAmount.toPlainString() %>"
                       required oninput="calculateChange()" /> VNĐ
            </td>
        </tr>
        <tr>
            <td>Tiền thừa trả lại khách:</td>
            <td><strong id="changeText">0 VNĐ</strong></td>
        </tr>
    </table>
    <br/>

    <input type="submit" value="In hoá đơn" />
    <button type="button" onclick="window.location.href='frmBillDetail2.jsp?tableId=<%= orderSlip.getTable().getId() %>'">Quay lại</button>
</form>

<script type="text/javascript">
    document.forms["thanhtoan"].addEventListener("submit", function(event) {
        event.preventDefault();
        var form = this;
        var submitButton = form.querySelector('input[type="submit"]');
        submitButton.disabled = true;

        // Gui dang application/x-www-form-urlencoded de request.getParameter() doc duoc
        // (FormData se gui multipart/form-data, JSP khong parse duoc -> cashGiven = null)
        fetch(form.action, {
            method: "POST",
            headers: { "Content-Type": "application/x-www-form-urlencoded; charset=UTF-8" },
            body: new URLSearchParams(new FormData(form)).toString()
        }).then(function(response) {
            if (!response.ok) {
                return response.text().then(function(message) {
                    throw new Error(message || "Không thể lưu hóa đơn.");
                });
            }
            if ((response.headers.get("Content-Type") || "").indexOf("application/pdf") === -1) {
                throw new Error("Máy chủ không trả về file PDF hóa đơn.");
            }
            return response.blob();
        }).then(function(pdf) {
            var downloadUrl = window.URL.createObjectURL(pdf);
            var link = document.createElement("a");
            link.href = downloadUrl;
            link.download = "hoa-don-<%= orderSlip.getId() %>.pdf";
            document.body.appendChild(link);
            link.click();
            document.body.removeChild(link);
            window.setTimeout(function() {
                window.URL.revokeObjectURL(downloadUrl);
            }, 1000);

            alert("Thanh toán và lưu hóa đơn thành công!");
            window.location.href = "frmSalesMain2.jsp";
        }).catch(function(error) {
            alert(error.message);
            submitButton.disabled = false;
        });
    });

    function calculateChange() {
        var finalAmount = <%= finalAmount.toPlainString() %>;
        var cashGivenInput = document.getElementById("cashGiven").value;
        var cashGiven = parseFloat(cashGivenInput) || 0;
        var change = cashGiven - finalAmount;

        var changeText = document.getElementById("changeText");
        if (cashGivenInput === "" || cashGiven < finalAmount) {
            changeText.innerText = "0 VNĐ";
            changeText.style.color = "red";
        } else {
            changeText.innerText = change.toLocaleString('vi-VN') + " VNĐ";
            changeText.style.color = "blue";
        }
    }
</script>
</body>
</html>