<!DOCTYPE html>
<html lang="en">
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
    <%@ page contentType="text/html" pageEncoding="UTF-8" %>
    <head>
        <meta charset="UTF-8">
        <title>Revenue Report</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/PaymentManager.css">

    </head>
    <body>
        <div class="container">
            <div class="header">
                <h1>Payment Manager</h1>
            </div>

            <button class="btn-back">Back</button>



            <div class="filter-section">
                <div class="filter-left">
                    <div class="filter-group">

                    </div>
                    <div class="filter-group">

                    </div>
                </div>

                <div class="button-group">
                    <button class="btn-blue" type="submit">View revenue chart</button>
                    <button class="btn-blue">Analysis</button>
                </div>
            </div>
        </form>

        <section>
            <h2>Total Revenue</h2>
            <table>
                <thead>
                    <tr>
                        <th>Total</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td class="highlight">${total}</td>
                    </tr>
                </tbody>
            </table>
        </section>

        <section>
            <h2>Revenue By Pool</h2>
            <form action="ServletRevenueReport" class="search-form">
                <div class="search-group">
                    <input type="text" name="PoolName" value="${PoolName}" placeholder="Search By Name" class="search-input">
                    <span class="search-icon"></span>
                </div>
                <button type="submit" class="search-button">Search</button>
            </form>
            <table id="pool-table">
                <thead>
                    <tr>
                        <th>Swimming pool</th>
                        <th>Revenue</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="SP" items="${listSP}">
                        <tr>
                            <td>${SP.swimmingpool}</td>
                            <td>${SP.revenue}</td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table> 
            <div id="pool-pagination" class="pagination"></div>
        </section>

        <section>
            <h2>Revenue By Product</h2>
            <form action="ServletRevenueReport" method="get" class="search-form">
                <div class="search-group">
                    <input type="text" name="productName" value="${productName}" placeholder="Search By Product" class="search-input">
                    <span class="search-icon"></span>
                </div>

                <div class="search-group">
                    <label class="search-label">Status</label>
                    <select name="Status">
                        <option value="all" ${Status == 'all' ? 'selected' : ''}>Tất cả</option>
                        <option value="true" ${Status == 'true' ? 'selected' : ''}>Bán</option>
                        <option value="false" ${Status == 'false' ? 'selected' : ''}>Cho thuê</option>
                    </select>
                </div>

                <div class="search-group">
                    <label class="search-label">Order Date</label>
                    <input type="date" name="OrderDate" value="${OrderDate}" class="search-date">
                </div>

                <button type="submit" class="search-button">Search</button>
            </form>
            <table id="product-table">
                <thead>
                    <tr>
                        <th>User name</th>
                        <th>Product Name</th>
                        <th>Quantity</th>
                        <th>Status</th>
                        <th>Total</th>
                        <th>Order Date</th>
                        <th>Swimming pool</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="p" items="${listP}">
                        <tr>
                            <td>${p.userName}</td>
                            <td>${p.productName}</td>
                            <td>${p.quantity}</td>
                            <td>
                                <c:if test="${p.status == true}">Bán</c:if>
                                <c:if test="${p.status == false}">Cho thuê</c:if>
                                </td>
                                <td>${p.total}</td>
                            <td>${p.orderDate}</td>
                            <td>${p.swimmingpool}</td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
                <div id="product-pagination" class="pagination"></div>
        </section>



        <section>
            <h2>Revenue By Package</h2>
            <form action="ServletRevenueReport" method="get" class="search-form">
                <div class="search-group">
                    <input type="text" name="Packagename" value="${Packagename}" placeholder="Search By Package" class="search-input">
                    <span class="search-icon"></span>
                </div>

                <div class="search-group">
                    <label class="search-label">Payment Time</label>
                    <input type="date" name="paymentTime" value="${paymentTime}" class="search-date">
                </div>

                <button type="submit" class="search-button">Search</button>
            </form>
            <table id="package-table">
                <thead>
                    <tr>
                        <th>User name</th>
                        <th>Package name</th>
                        <th>Swimming pool</th>
                        <th>Payment Method</th>
                        <th>Total</th>
                        <th>Status</th>
                        <th>Payment Time</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="pk" items="${listPK}">
                        <tr>
                            <td>${pk.userName}</td>
                            <td>${pk.packageName}</td>
                            <td>${pk.swimmingpool}</td>
                            <td>${pk.paymentMethod}</td>
                            <td>${pk.total}</td>
                            <td>${pk.status}</td>
                            <td>${pk.paymentTime}</td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
            <div id="package-pagination" class="pagination"></div>
        </section>
        <section>
            <h2>Revenue By Trainer Bookings</h2>
            <form action="ServletRevenueReport" method="get" class="search-form">
                <div class="search-group">
                    <input type="text" name="Username" value="${Username}" placeholder="Search By User" class="search-input">
                    <span class="search-icon"></span>
                </div>
                <div class="search-group">
                    <input type="text" name="Trainername" value="${Trainername}" placeholder="Search By Trainer" class="search-input">
                    <span class="search-icon"></span>
                </div>

                <div class="search-group">
                    <label class="search-label">Payment Date</label>
                    <input type="date" name="PaymentDate" value="${PaymentDate}" class="search-date">
                </div>

                <button type="submit" class="search-button">Search</button>
            </form>
            <table id="trainer-booking-table">
                <thead>
                    <tr>
                        <th>User name</th>
                        <th>Trainer name</th>
                        <th>Swimming pool</th>
                        <th>Class Name</th>
                        <th>Payment Method</th>
                        <th>Total</th>
                        <th>Payment Date</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="Rb" items="${listRB}">
                        <tr>
                            <td>${Rb.userName}</td>
                            <td>${Rb.trainerName}</td>
                            <td>${Rb.swimmingPool}</td>
                            <td>${Rb.className}</td>
                            <td>${Rb.paymentMethod}</td>
                            <td>${Rb.total}</td>
                            <td>${Rb.paymentDate}</td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table> 
                <div id="trainer-booking-pagination" class="pagination"></div>
        </section>
    </div>
</body>

<script>
    function paginateTable(tableId, paginationId, rowsPerPage) {
        const table = document.getElementById(tableId);
        const tbody = table.querySelector("tbody");
        const rows = Array.from(tbody.querySelectorAll("tr"));
        const pagination = document.getElementById(paginationId);
        const totalPages = Math.ceil(rows.length / rowsPerPage);
        let currentPage = 1;

        function showPage(page) {
            const start = (page - 1) * rowsPerPage;
            const end = page * rowsPerPage;

            rows.forEach((row, index) => {
                row.style.display = (index >= start && index < end) ? "" : "none";
            });

            renderPagination();
        }

        function renderPagination() {
            pagination.innerHTML = "";
            for (let i = 1; i <= totalPages; i++) {
                const btn = document.createElement("button");
                btn.innerText = i;
                btn.className = (i === currentPage) ? "active-page" : "";
                btn.onclick = function () {
                    currentPage = i;
                    showPage(currentPage);
                };
                pagination.appendChild(btn);
            }
        }

        showPage(currentPage);
    }

    // Gọi hàm khi trang tải xong
    window.onload = function () {
        paginateTable("product-table", "product-pagination", 10); // 5 dòng mỗi trang
        paginateTable("pool-table", "pool-pagination", 10);
        paginateTable("package-table", "package-pagination", 10);
        paginateTable("trainer-booking-table", "trainer-booking-pagination", 10);
    };
</script>

</html>
