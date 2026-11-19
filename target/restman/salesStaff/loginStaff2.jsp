<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
         import="dao.StaffAuthDAO2,model.Staff2"%>
<%
    request.setCharacterEncoding("UTF-8");
    String error = null;
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        if (username == null || username.trim().isEmpty()
                || password == null || password.isEmpty()) {
            error = "Vui lòng nhập tên đăng nhập và mật khẩu.";
        } else {
            try {
                Staff2 staff = new StaffAuthDAO2().authenticateSalesStaff(username.trim(), password);
                if (staff == null) {
                    error = "Thông tin đăng nhập không hợp lệ hoặc tài khoản không thuộc nhân viên bán hàng.";
                } else {
                    request.changeSessionId();
                    session.setAttribute("salesStaff", staff);
                    response.sendRedirect(request.getContextPath() + "/salesStaff/frmSalesMain2.jsp");
                    return;
                }
            } catch (Exception e) {
                application.log("Không thể xác thực nhân viên.", e);
                error = "Không thể đăng nhập lúc này. Vui lòng thử lại sau.";
            }
        }
    }
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Đăng nhập nhân viên - RestMan</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
<main class="container py-5" style="max-width: 460px;">
    <div class="card shadow-sm">
        <div class="card-body p-4">
            <h1 class="h3 mb-4 text-center">Đăng nhập nhân viên</h1>
            <% if (error != null) { %>
            <div class="alert alert-danger" role="alert"><%= error %></div>
            <% } %>
            <form method="post" action="loginStaff2.jsp">
                <div class="mb-3">
                    <label class="form-label" for="username">Tên đăng nhập</label>
                    <input class="form-control" id="username" name="username" maxlength="50"
                           autocomplete="username" required>
                </div>
                <div class="mb-3">
                    <label class="form-label" for="password">Mật khẩu</label>
                    <input class="form-control" id="password" name="password" type="password"
                           autocomplete="current-password" required>
                </div>
                <button class="btn btn-success w-100" type="submit">Đăng nhập</button>
            </form>
            <p class="mt-3 mb-0 text-center">
                Chưa có tài khoản? <a href="registerStaff2.jsp">Đăng ký nhân viên</a>
            </p>
        </div>
    </div>
</main>
</body>
</html>
