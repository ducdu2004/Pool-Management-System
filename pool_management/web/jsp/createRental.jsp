<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Tạo đơn thuê đồ</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/rentalManager.css">
</head>
<body>
    <%@include file="header.jsp"%>

    <div class="container">
        <h2>Tạo đơn thuê đồ mới</h2>

        <c:if test="${not empty error}">
            <p class="error">${error}</p>
        </c:if>

        <form action="RentalManager" method="post">
            <input type="hidden" name="action" value="createRental">

            <div class="form-group">
                <label for="customerName">Tên khách hàng</label>
                <input type="text" id="customerName" name="customerName" required placeholder="Nhập tên khách hàng">
            </div>

            <div class="form-group">
                <label for="phoneNumber">Số điện thoại</label>
                <input type="tel" id="phoneNumber" name="phoneNumber" required placeholder="Nhập số điện thoại (10 số)">
            </div>

            <div class="form-group">
                <label for="productID">Sản phẩm</label>
                <select id="productID" name="productID" required>
                    <option value="">Chọn sản phẩm</option>
                    <c:forEach var="product" items="${availableProducts}">
                        <option value="${product.productID}" data-price="${product.rentalPrice}">${product.productName} (VND ${product.rentalPrice}/giờ)</option>
                    </c:forEach>
                </select>
            </div>

            <div class="form-group">
                <label for="rentalPrice">Giá thuê/giờ</label>
                <input type="number" id="rentalPrice" name="rentalPrice" readonly>
            </div>

            <div class="form-group">
                <label for="startDate">Thời gian bắt đầu</label>
                <input type="datetime-local" id="startDate" name="startDate" required>
            </div>

            <div class="form-group">
                <label for="endDate">Thời gian kết thúc</label>
                <input type="datetime-local" id="endDate" name="endDate" required>
            </div>

            <div class="form-group">
                <button type="submit">Tạo đơn thuê</button>
            </div>
        </form>
    </div>

    <script>
        // Auto-fill rental price based on selected product
        document.getElementById('productID').addEventListener('change', function() {
            var selectedOption = this.options[this.selectedIndex];
            var price = selectedOption.getAttribute('data-price');
            document.getElementById('rentalPrice').value = price || '';
        });
    </script>

    <%@include file="footer.jsp"%>
</body>
</html>