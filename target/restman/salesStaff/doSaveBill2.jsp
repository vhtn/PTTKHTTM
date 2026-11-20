<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" import="java.util.*,java.io.*,java.text.*,java.math.*,dao.*,model.*"%>
<%!
    private String toPdfText(String value) {
        if (value == null) {
            return "";
        }
        String normalized = Normalizer.normalize(value.replace('đ', 'd').replace('Đ', 'D'),
                Normalizer.Form.NFD);
        StringBuilder text = new StringBuilder();
        for (int i = 0; i < normalized.length(); i++) {
            char character = normalized.charAt(i);
            if (Character.getType(character) != Character.NON_SPACING_MARK) {
                if (character >= 32 && character <= 126) {
                    text.append(character);
                } else if (Character.isWhitespace(character)) {
                    text.append(' ');
                } else {
                    text.append('?');
                }
            }
        }
        return text.toString().replace("\\", "\\\\").replace("(", "\\(").replace(")", "\\)");
    }

    private void addPdfText(StringBuilder content, int x, int y, int fontSize, String text) {
        content.append("BT /F1 ").append(fontSize).append(" Tf ")
                .append(x).append(' ').append(y).append(" Td (")
                .append(toPdfText(text)).append(") Tj ET\n");
    }

    private void addPdfLine(StringBuilder content, int x1, int y1, int x2, int y2) {
        content.append(x1).append(' ').append(y1).append(" m ")
                .append(x2).append(' ').append(y2).append(" l S\n");
    }

    // Tinh so tien phai thanh toan (lam tron ve VND) - dung chung cho trang hoa don va PDF
    private BigDecimal calcFinalAmount(BigDecimal totalAmount, BigDecimal discountPercent) {
        return totalAmount.multiply(BigDecimal.valueOf(100).subtract(discountPercent))
                .divide(BigDecimal.valueOf(100), 2, RoundingMode.HALF_UP);
    }

    private String formatMoney(BigDecimal value) {
        return new java.text.DecimalFormat("#,##0.##",
                java.text.DecimalFormatSymbols.getInstance(java.util.Locale.GERMANY))
                .format(value.setScale(2, RoundingMode.HALF_UP));
    }

    private byte[] createInvoicePdf(OrderSlip2 orderSlip, BigDecimal discountPercent,
                                    BigDecimal cashGiven, BigDecimal changeAmount, Date billDate) throws IOException {
        ArrayList<OrderDetails2> details = orderSlip.getListOrderDetails();
        int detailCount = details == null ? 0 : details.size();
        int pageHeight = Math.max(842, 470 + detailCount * 22);
        int y = pageHeight - 55;
        StringBuilder content = new StringBuilder();

        addPdfText(content, 190, y, 18, "HOA DON BAN HANG");
        y -= 28;
        addPdfText(content, 40, y, 10,
                "Nha hang RestMan - So 2 - Pho A - Phuong B, Thanh pho C");
        y -= 18;
        addPdfText(content, 40, y, 10, "So hoa don: " + orderSlip.getId()
                + "     Ngay: " + new SimpleDateFormat("dd/MM/yyyy HH:mm").format(billDate));
        if (orderSlip.getTable() != null) {
            y -= 16;
            addPdfText(content, 40, y, 10, "Ban: " + orderSlip.getTable().getNumber());
        }

        y -= 28;
        addPdfLine(content, 40, y + 12, 555, y + 12);
        addPdfText(content, 42, y, 9, "STT");
        addPdfText(content, 85, y, 9, "Ten mon");
        addPdfText(content, 345, y, 9, "SL");
        addPdfText(content, 390, y, 9, "Don gia (VND)");
        addPdfText(content, 490, y, 9, "Thanh tien (VND)");
        y -= 8;
        addPdfLine(content, 40, y, 555, y);

        if (details != null) {
            for (int i = 0; i < details.size(); i++) {
                OrderDetails2 detail = details.get(i);
                y -= 20;
                addPdfText(content, 45, y, 9, String.valueOf(i + 1));
                String itemName = detail.getMenuItem() == null ? "" : detail.getMenuItem().getName();
                if (itemName != null && itemName.length() > 38) {
                    itemName = itemName.substring(0, 35) + "...";
                }
                addPdfText(content, 85, y, 9, itemName);
                addPdfText(content, 350, y, 9, String.valueOf(detail.getQuantity()));
                addPdfText(content, 390, y, 9, formatMoney(detail.getPrice()));
                addPdfText(content, 490, y, 9, formatMoney(detail.getAmount()));
            }
        }

        BigDecimal totalAmount = orderSlip.getTotalAmount();
        BigDecimal payableAmount = calcFinalAmount(totalAmount, discountPercent);
        BigDecimal discountAmount = totalAmount.subtract(payableAmount);
        y -= 30;
        addPdfLine(content, 40, y + 15, 555, y + 15);
        addPdfText(content, 330, y, 10, "Tong tien:");
        addPdfText(content, 470, y, 10, formatMoney(totalAmount) + " VND");
        y -= 18;
        addPdfText(content, 330, y, 10, "Giam gia (" + discountPercent.intValue() + "%):");
        addPdfText(content, 470, y, 10, formatMoney(discountAmount) + " VND");
        y -= 18;
        addPdfText(content, 330, y, 10, "Phai thanh toan:");
        addPdfText(content, 470, y, 10, formatMoney(payableAmount) + " VND");
        y -= 18;
        addPdfText(content, 330, y, 10, "Tien khach dua:");
        addPdfText(content, 470, y, 10, formatMoney(cashGiven) + " VND");
        y -= 18;
        addPdfText(content, 330, y, 10, "Tien thua:");
        addPdfText(content, 470, y, 10, formatMoney(changeAmount) + " VND");

        byte[] contentBytes = content.toString().getBytes("US-ASCII");
        ByteArrayOutputStream pdf = new ByteArrayOutputStream();
        writePdf(pdf, "%PDF-1.4\n");
        int[] objectOffsets = new int[6];
        objectOffsets[1] = pdf.size();
        writePdf(pdf, "1 0 obj\n<< /Type /Catalog /Pages 2 0 R >>\nendobj\n");
        objectOffsets[2] = pdf.size();
        writePdf(pdf, "2 0 obj\n<< /Type /Pages /Kids [3 0 R] /Count 1 >>\nendobj\n");
        objectOffsets[3] = pdf.size();
        writePdf(pdf, "3 0 obj\n<< /Type /Page /Parent 2 0 R /MediaBox [0 0 595 "
                + pageHeight + "] /Resources << /Font << /F1 4 0 R >> >> /Contents 5 0 R >>\nendobj\n");
        objectOffsets[4] = pdf.size();
        writePdf(pdf, "4 0 obj\n<< /Type /Font /Subtype /Type1 /BaseFont /Helvetica "
                + "/Encoding /WinAnsiEncoding >>\nendobj\n");
        objectOffsets[5] = pdf.size();
        writePdf(pdf, "5 0 obj\n<< /Length " + contentBytes.length + " >>\nstream\n");
        pdf.write(contentBytes);
        writePdf(pdf, "endstream\nendobj\n");

        int xrefOffset = pdf.size();
        writePdf(pdf, "xref\n0 6\n0000000000 65535 f \n");
        for (int i = 1; i < objectOffsets.length; i++) {
            writePdf(pdf, String.format("%010d 00000 n \n", objectOffsets[i]));
        }
        writePdf(pdf, "trailer\n<< /Size 6 /Root 1 0 R >>\nstartxref\n"
                + xrefOffset + "\n%%EOF\n");
        return pdf.toByteArray();
    }

    private void writePdf(ByteArrayOutputStream output, String value) throws IOException {
        output.write(value.getBytes("US-ASCII"));
    }
%>
<%
    request.setCharacterEncoding("UTF-8");

    // 1. Lay du lieu tu Session & Form
    OrderSlip2 orderSlip = (OrderSlip2) session.getAttribute("currentOrderSlip");
    MembershipCard2 card = (MembershipCard2) session.getAttribute("currentCard");
    Staff2 salesStaff = (Staff2) session.getAttribute("SalesStaff");

    if (salesStaff == null || !"SalesStaff".equalsIgnoreCase(salesStaff.getPosition())) {
        response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
        response.setContentType("text/plain; charset=UTF-8");
        response.getWriter().write("Vui lòng đăng nhập bằng tài khoản nhân viên bán hàng.");
        return;
    }

    String cardCode = request.getParameter("cardCode");
    if (cardCode != null) {
        cardCode = cardCode.trim();
        if (cardCode.isEmpty()) {
            card = null;
            session.removeAttribute("currentCard");
        } else {
            card = (new MembershipCardDAO2()).getCardByCode(cardCode);
            if (card == null || !"Hoạt động".equalsIgnoreCase(card.getStatus())) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.setContentType("text/plain; charset=UTF-8");
                response.getWriter().write("Không tìm thấy mã thẻ hoặc thẻ đang bị khóa.");
                return;
            }
            session.setAttribute("currentCard", card);
        }
    }

    if (orderSlip == null) {
        response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
        response.setContentType("text/plain; charset=UTF-8");
        response.getWriter().write("Không tìm thấy phiếu gọi món.");
        return;
    }

    BigDecimal discountPercent = card != null ? card.getDiscountPercent() : BigDecimal.ZERO;
    BigDecimal finalAmount = BigDecimal.ZERO;
    BigDecimal cashGiven = BigDecimal.ZERO;
    BigDecimal changeAmount = BigDecimal.ZERO;
    boolean validInput = true;

    try {
        finalAmount = calcFinalAmount(orderSlip.getTotalAmount(), discountPercent);
        cashGiven = new BigDecimal(request.getParameter("cashGiven").trim());
        changeAmount = cashGiven.subtract(finalAmount);
        if (discountPercent.compareTo(BigDecimal.ZERO) < 0
                || discountPercent.compareTo(BigDecimal.valueOf(100)) > 0
                || cashGiven.compareTo(finalAmount) < 0) {
            validInput = false;
        }
    } catch (Exception e) {
        e.printStackTrace();
        validInput = false;
    }

    if (!validInput) {
        response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
        response.setContentType("text/plain; charset=UTF-8");
        response.getWriter().write("Số tiền khách đưa (" + formatMoney(cashGiven)
                + " VNĐ) phải lớn hơn hoặc bằng số cần thanh toán ("
                + formatMoney(finalAmount) + " VNĐ). Mức giảm đang áp dụng: "
                + discountPercent.intValue() + "%.");
        return;
    }

    // 2. Khoi tao doi tuong Bill2
    Bill2 bill = new Bill2();
    bill.setDate(new Date());
    bill.setTotalAmount(finalAmount);
    bill.setDiscountPercent(discountPercent);
    bill.setStatus("Đã thanh toán");
    bill.setCashGiven(cashGiven);
    bill.setChangeAmount(changeAmount);
    bill.setOrderSlip(orderSlip);
    bill.setSalesStaff(salesStaff);
    if (card != null) {
        bill.setMembershipCard(card);
    }

    byte[] invoicePdf;
    try {
        invoicePdf = createInvoicePdf(orderSlip, discountPercent, cashGiven, changeAmount, bill.getDate());
    } catch (Exception e) {
        e.printStackTrace();
        response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        response.setContentType("text/plain; charset=UTF-8");
        response.getWriter().write("Không thể tạo file PDF hóa đơn.");
        return;
    }

    // 3. Luu hoa don, cap nhat trang thai phieu va cong diem trong cung transaction
    boolean saved = false;
    java.sql.Connection connection = DAO2.con;
    boolean originalAutoCommit = true;
    boolean transactionStarted = false;
    try {
        if (connection == null) {
            throw new java.sql.SQLException("Không có kết nối cơ sở dữ liệu.");
        }
        originalAutoCommit = connection.getAutoCommit();
        connection.setAutoCommit(false);
        transactionStarted = true;

        if (card != null) {
            if (!(new MembershipCardDAO2()).updatePoint(card.getId(), bill.getTotalAmount())) {
                throw new java.sql.SQLException("Không cập nhật được điểm thẻ thành viên.");
            }
        }
        if (!(new BillDAO2()).saveBill(bill)) {
            throw new java.sql.SQLException("Không lưu được hóa đơn.");
        }
        if (!(new OrderSlipDAO2()).updateStatus(orderSlip.getId(), "Đã thanh toán")) {
            throw new java.sql.SQLException("Không cập nhật được trạng thái phiếu gọi món.");
        }

        connection.commit();
        saved = true;
    } catch (Exception e) {
        if (transactionStarted) {
            try {
                connection.rollback();
            } catch (Exception rollbackException) {
                e.addSuppressed(rollbackException);
            }
        }
        application.log("Không thể hoàn tất giao dịch thanh toán.", e);
    } finally {
        if (transactionStarted) {
            try {
                connection.setAutoCommit(originalAutoCommit);
            } catch (Exception e) {
                application.log("Không thể khôi phục auto-commit sau thanh toán.", e);
                saved = false;
            }
        }
    }

    if (saved) {
        session.removeAttribute("currentOrderSlip");
        session.removeAttribute("currentCard");
        response.resetBuffer();
        response.setContentType("application/pdf");
        response.setHeader("Content-Disposition",
                "attachment; filename=\"hoa-don-" + orderSlip.getId() + ".pdf\"");
        response.setContentLength(invoicePdf.length);
        response.getOutputStream().write(invoicePdf);
    } else {
        response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        response.setContentType("text/plain; charset=UTF-8");
        response.getWriter().write("Lỗi thanh toán và lưu hóa đơn!");
    }
%>