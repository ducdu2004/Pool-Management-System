<!DOCTYPE html>
<html lang="vi">
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
    <%@ page contentType="text/html" pageEncoding="UTF-8" %>
    <head>
        <meta charset="UTF-8">
        <title>Lịch Bảo Trì Hồ Bơi</title>
    </head>
    <body>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/AddMaintenanceSchedule.css">
        <h1>CHỈNH SỬA LỊCH BẢO TRÌ HỒ BƠI</h1>

        <!-- Nút quay lại bên trái -->
        <div class="btn-container btn-back">
            <button class="btn"><a href="ServletMaintenanceSchedule">Quay lại</a></button>
        </div>

        <form action="ServletMaintenanceSchedule?service=UpdateMaintenanceSchedule" method="post">
            <div class="form-row">
                <div class="form-group">
                    <label for="pool">Hồ bơi</label>
                    <c:choose>
                        <c:when test="${position == 'Manager'}">
                            <select name="poolID" id="pool" required>
                                <c:forEach var="pool" items="${pools}">
                                    <c:if test="${pool.poolID == poolID}">
                                    <option value="${pool.poolID}" ${pool.poolID == schedule.poolID ? 'selected' : ''}>
                                        ${pool.name}
                                    </option>
                                    </c:if>
                                </c:forEach>
                            </select>
                        </c:when>
                        <c:otherwise>
                            <select name="poolID" id="pool" required>
                                <c:forEach var="pool" items="${pools}">
                                    <option value="${pool.poolID}" ${pool.poolID == schedule.poolID ? 'selected' : ''}>
                                        ${pool.name}
                                    </option>
                                </c:forEach>
                            </select>
                        </c:otherwise>
                    </c:choose>
                </div>

                <div class="form-group">
                    <label for="title">Tiêu đề</label>
                    <input type="text" name="title" id="title" value="${schedule.title}" required>
                </div>
            </div>

            <div class="form-row">
                <div class="form-group">
                    <label for="startDate">Ngày bắt đầu</label>
                    <input type="datetime-local" name="startDate" id="startDate"
                           value="${schedule.startDate}" required>
                </div>
                <div class="form-group">
                    <label for="endDate">Ngày kết thúc</label>
                    <input type="datetime-local" name="endDate" id="endDate"
                           value="${schedule.endDate}" required>
                </div>
            </div>

            <div class="form-group">
                <label for="description">Mô tả</label>
                <textarea name="description" id="description" required>${schedule.description}</textarea>
            </div>

            <div class="form-row">
                <div class="form-group">
                    <label for="status">Trạng thái</label>
                    <select name="status" id="status" required>
                        <option value="Scheduled" ${schedule.status == 'Scheduled' ? 'selected' : ''}>Đã lên lịch</option>
                        <option value="InProgress" ${schedule.status == 'InProgress' ? 'selected' : ''}>Đang thực hiện</option>
                        <option value="Completed" ${schedule.status == 'Completed' ? 'selected' : ''}>Đã hoàn thành</option>
                    </select>
                </div>
            </div>

            <div class="btn-container center">
                <button type="submit" name="submit" class="btn">Chỉnh sửa</button>
            </div>

            <input type="hidden" name="maintenanceID" value="${schedule.maintenanceID}" />
        </form>
    </body>
</html>
