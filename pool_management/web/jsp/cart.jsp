<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Giỏ Hàng</title>
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/seller.css">
    <style>
        .shopping-cart { margin-bottom: 50px; padding-top: 20px; }
        .table th, .table td { vertical-align: middle; }
        .btn-dark, .btn-primary, .btn-danger, .btn-outline-dark { transition: all 0.3s; }
        .btn-dark:hover, .btn-primary:hover, .btn-danger:hover, .btn-outline-dark:hover { opacity: 0.9; }
    </style>
</head>
<body>
    <header>
        <h1>Giỏ Hàng</h1>
        <a href="${pageContext.request.contextPath}/Seller" class="back-link">Quay lại Seller Dashboard</a>
    </header>
    <div class="container shopping-cart">
        <h2 class="text-center mb-4">Giỏ Hàng Của Bạn</h2>
        <c:if test="${not empty param.message}">
            <p class="message">${param.message}</p>
        </c:if>
        <div class="row">
            <div class="col-lg-12 p-4 bg-white rounded shadow-sm">
                <div class="table-responsive">
                    <table class="table">
                        <thead class="bg-light">
                            <tr>
                                <th>Sản Phẩm</th>
                                <th>Đơn Giá</th>
                                <th>Số Lượng</th>
                                <th>Tổng Cộng</th>
                                <th>Hành Động</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${cartItems}" var="item">
                                <tr>
                                    <td>
                                        <div class="d-flex align-items-center">
                                            <img src="${pageContext.request.contextPath}/images/products/${item.productImage}" alt="${item.productName}" width="70" class="img-fluid rounded shadow-sm mr-3">
                                            <h5 class="mb-0">${item.productName}</h5>
                                        </div>
                                    </td>
                                    <td><strong>${item.price} VND</strong></td>
                                    <td>
                                        <div class="d-flex align-items-center">
                                            <a href="${pageContext.request.contextPath}/Seller?action=decrease&productID=${item.productID}" class="btn btn-outline-dark btn-sm mr-2">-</a>
                                            <strong>${item.quantity}</strong>
                                            <a href="${pageContext.request.contextPath}/Seller?action=increase&productID=${item.productID}" class="btn btn-outline-dark btn-sm ml-2">+</a>
                                        </div>
                                    </td>
                                    <td><strong>${item.price * item.quantity} VND</strong></td>
                                    <td>
                                        <a href="${pageContext.request.contextPath}/Seller?action=removeFromCart&productID=${item.productID}" class="btn btn-danger btn-sm">Xóa</a>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
        <div class="row mt-4">
            <div class="col-lg-6 offset-lg-6">
                <div class="bg-white rounded shadow-sm p-4">
                    <h5 class="text-uppercase mb-3">Tổng Thanh Toán</h5>
                    <ul class="list-unstyled">
                        <li class="d-flex justify-content-between py-2 border-bottom">
                            <strong>Tổng tiền hàng</strong>
                            <strong>${total} VND</strong>
                        </li>
                    </ul>
                    <a href="${pageContext.request.contextPath}/Seller?action=checkout" class="btn btn-dark btn-block mt-3">Tiến Hành Thanh Toán</a>
                </div>
            </div>
        </div>
    </div>
    <script src="https://code.jquery.com/jquery-3.2.1.slim.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.12.9/umd/popper.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/js/bootstrap.min.js"></script>
</body>
</html>