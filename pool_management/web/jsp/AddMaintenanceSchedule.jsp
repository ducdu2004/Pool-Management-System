<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
    <%@ page contentType="text/html" pageEncoding="UTF-8" %>
    <head>
        <meta charset="UTF-8">
        <title>Lập Lịch Bảo Trì Hồ Bơi</title>
    </head>
    <body>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/AddMaintenanceSchedule.css">
        <h1>LẬP LỊCH BẢO TRÌ HỒ BƠI</h1>

        <!-- Nút quay lại bên trái -->
        <div class="btn-container btn-back">
            <button class="btn"><a href="ServletMaintenanceSchedule">Quay lại</a></button>
        </div>

        <form action="ServletMaintenanceSchedule?service=AddMaintenanceSchedule" method="post">
            <div class="form-row">
                <div class="form-group">
                    <label for="pool">Hồ bơi</label>
                    <c:choose>
                        <c:when test="${position == 'Manager'}">
                            <select name="poolID" id="pool" required>
                                <c:forEach var="pool" items="${pools}">
                                    <c:if test="${pool.poolID == poolID}">
                                        <option value="${pool.poolID}">${pool.name}</option>
                                    </c:if>
                                </c:forEach>
                            </select>
                        </c:when>
                        <c:otherwise>
                            <select name="poolID" id="pool" required>
                                <c:forEach var="pool" items="${pools}">
                                    <option value="${pool.poolID}">${pool.name}</option>
                                </c:forEach>
                            </select>
                        </c:otherwise>
                    </c:choose>
                </div>

                <div class="form-group">
                    <label for="title">Tiêu đề</label>
                    <input type="text" name="title" id="title" required>
                </div>
            </div>

            <div class="form-row">
                <div class="form-group">
                    <label for="startDate">Ngày bắt đầu</label>
                    <input type="datetime-local" name="startDate" id="startDate" required>
                </div>
                <div class="form-group">
                    <label for="endDate">Ngày kết thúc</label>
                    <input type="datetime-local" name="endDate" id="endDate" required>
                </div>
            </div>

            <div class="form-group">
                <label for="description">Mô tả</label>
                <textarea name="description" id="description" required></textarea>
            </div>

            <!-- Nút thêm căn giữa -->
            <div class="btn-container center">
                <button type="submit" name="submit" class="btn">Thêm</button>
            </div>
        </form>
    </body>
</html>
