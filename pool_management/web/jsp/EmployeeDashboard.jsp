<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Employee Dashboard</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/EmployeeDashboard.css">
</head>
<body>
    <%@include file="header.jsp"%>

    <h2>Dashboard Employee</h2>
    <div class="content">
        <!-- Employee profile -->
        <div class="card"><a href="${pageContext.request.contextPath}/EmployeeProfile">Thông tin nhân viên</a></div>

        <!-- Warehouse manager -->
        <div class="card"><a href="ServletWarehouseManager">Quản lý kho</a></div>

        <!-- Seller -->
        <div class="card"><a href="${pageContext.request.contextPath}/Seller">Bán Hàng</a></div>

        <!-- Employee schedule -->
        <div class="card"><a href="${pageContext.request.contextPath}/EmployeeSchedule">Lịch trình nhân viên</a></div>

        <!-- Rental manager -->
        <div class="card"><a href="${pageContext.request.contextPath}/RentalManager">Quản lý thuê đồ</a></div>
    </div>

    <%@include file="footer.jsp"%>
</body>
</html>