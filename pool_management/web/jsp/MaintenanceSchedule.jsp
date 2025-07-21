<!DOCTYPE html>
<html lang="vi">
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
    <%@ page contentType="text/html" pageEncoding="UTF-8" %>
    <head>
        <meta charset="UTF-8">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/MaintenanceSchedule.css">
        <title>Lịch Bảo Trì</title>
    </head>
    <body>
        <jsp:include page="headerAdmin.jsp" /> 
        <div class="container">
            <h1>LỊCH BẢO TRÌ</h1>

            <div class="top-bar">
                <button class="btn blue">Quay lại</button>
            </div>

            <div class="controls-wrapper">
                <div class="controls">
                    <form action="ServletMaintenanceSchedule">
                        <input type="text" name="poolName" placeholder="Tìm kiếm theo tên hồ bơi" value="${poolName}">
                        <select name="status">
                            <option value="">Tất cả</option>
                            <option value="Scheduled" ${status == 'Scheduled' ? 'selected' : ''}>Đã lên lịch</option>
                            <option value="Completed" ${status == 'Completed' ? 'selected' : ''}>Đã hoàn thành</option>
                            <option value="Cancelled" ${status == 'Cancelled' ? 'selected' : ''}>Đã hủy</option>
                        </select>
                        <input type="date" name="date" value="${date}" class="search-date">
                        <button class="btn blue" type="submit">Tìm kiếm</button>   
                    </div>
                    </form>
                    <div>
                        <button class="btn green">Thêm lịch bảo trì</button>
                    </div>
            </div>

                <table id="maintenance-table">
                    <thead>
                        <tr>
                            <th>Hồ bơi</th>
                            <th>Tiêu đề</th>
                            <th>Ngày bắt đầu</th>
                            <th>Ngày kết thúc</th>
                            <th>Mô tả</th>
                            <th>Trạng thái</th>
                            <th></th>
                            <th></th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="m" items="${schedules}">
                            <tr>
                                <td>${m.poolName}</td>
                                <td>${m.title}</td>
                                <td>${m.startDate}</td>
                                <td>${m.endDate}</td>
                                <td>${m.description}</td>
                                <td class="status ${m.status.toLowerCase()}">${m.status}</td>
                                <td class="icon">✏️</td>
                                <td class="icon">🗑️</td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>

                <div class="paginationN" id="maintenance-pagination"></div>

                <div class="statistics">
                    <h2>THỐNG KÊ</h2>
                    <p>📄 Tổng cộng: ${TotalMaintenanceSchedule} lịch bảo trì</p>
                </div>
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

        window.onload = function () {
            paginateTable("maintenance-table", "maintenance-pagination", 10);
        };
    </script>
</html>
