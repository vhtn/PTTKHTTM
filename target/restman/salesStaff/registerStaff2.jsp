<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
         import="dao.StaffAuthDAO2"%>
<%
    request.setCharacterEncoding("UTF-8");
    String error = null;
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String name = request.getParameter("name");
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        String birthday = request.getParameter("birthday");
        String address = request.getParameter("address");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String note = request.getParameter("note");

        if (name == null || name.trim().isEmpty()
                || username == null || username.trim().isEmpty()
                || password == null || password.length() < 6
                || email == null || email.trim().isEmpty()
                || phone == null || phone.trim().isEmpty()) {
            error = "Vui lòng điền các trường bắt buộc; mật khẩu phải có ít nhất 6 ký tự.";
        } else if (confirmPassword == null || !password.equals(confirmPassword)) {
            error = "Mật khẩu xác nhận không khớp.";
        } else if (username.trim().length() > 50 || phone.trim().length() > 10
                || email.trim().length() > 100) {
            error = "Tên đăng nhập, số điện thoại hoặc email vượt quá độ dài cho phép.";
        } else {
            try {
                new StaffAuthDAO2().registerSalesStaff(name.trim(), username.trim(), password,
                        birthday, address, email.trim(), phone.trim(), note);
                response.sendRedirect(request.getContextPath()
                        + "/salesStaff/loginStaff2.jsp?registered=1");
                return;
            } catch (java.text.ParseException e) {
                error = "Ngày sinh không hợp lệ.";
            } catch (java.sql.SQLIntegrityConstraintViolationException e) {
                error = "Tên đăng nhập, email hoặc số điện thoại đã được sử dụng.";
            } catch (Exception e) {
                application.log("Không thể đăng ký nhân viên.", e);
                error = "Không thể đăng ký lúc này. Vui lòng kiểm tra thông tin và thử lại.";
            }
        }
    }
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Đăng ký nhân viên - RestMan</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
<main class="container py-5" style="max-width: 620px;">
    <div class="card shadow-sm">
        <div class="card-body p-4">
            <h1 class="h3 mb-4 text-center">Đăng ký nhân viên bán hàng</h1>
            <% if (error != null) { %>
            <div class="alert alert-danger" role="alert"><%= error %></div>
            <% } %>
            <form method="post" action="registerStaff2.jsp">
                <div class="mb-3">
                    <label class="form-label" for="name">Họ tên *</label>
                    <input class="form-control" id="name" name="name" maxlength="255" required>
                </div>
                <div class="mb-3">
                    <label class="form-label" for="username">Tên đăng nhập *</label>
                    <input class="form-control" id="username" name="username" maxlength="50"
                           autocomplete="username" required>
                </div>
                <div class="row">
                    <div class="col-md-6 mb-3">
                        <label class="form-label" for="password">Mật khẩu * (ít nhất 6 ký tự)</label>
                        <input class="form-control" id="password" name="password" type="password"
                               minlength="6" autocomplete="new-password" required>
                    </div>
                    <div class="col-md-6 mb-3">
                        <label class="form-label" for="confirmPassword">Xác nhận mật khẩu *</label>
                        <input class="form-control" id="confirmPassword" name="confirmPassword"
                               type="password" minlength="6" autocomplete="new-password" required>
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-6 mb-3">
                        <label class="form-label" for="email">Email *</label>
                        <input class="form-control" id="email" name="email" type="email"
                               maxlength="100" required>
                    </div>
                    <div class="col-md-6 mb-3">
                        <label class="form-label" for="phone">Số điện thoại *</label>
                        <input class="form-control" id="phone" name="phone" maxlength="10"
                               pattern="[0-9]{10}" required>
                    </div>
                </div>
                <div class="mb-3">
                    <label class="form-label" for="birthday">Ngày sinh</label>
                    <input class="form-control" id="birthday" name="birthday" type="date">
                </div>
                <div class="mb-3">
                    <label class="form-label" for="address">Địa chỉ</label>
                    <input class="form-control" id="address" name="address" maxlength="255">
                </div>
                <div class="mb-3">
                    <label class="form-label" for="note">Ghi chú</label>
                    <input class="form-control" id="note" name="note" maxlength="255">
                </div>
                <button class="btn btn-success w-100" type="submit">Tạo tài khoản</button>
            </form>
            <p class="mt-3 mb-0 text-center">
                Đã có tài khoản? <a href="loginStaff2.jsp">Đăng nhập</a>
            </p>
        </div>
    </div>
</main>
</body>
</html>
