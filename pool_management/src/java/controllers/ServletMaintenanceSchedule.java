/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controllers;

import dal.EmployeeDAO;
import dal.MaintenanceScheduleDAO;
import dal.SwimmingPoolDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.util.Vector;
import models.Employee;
import models.MaintenanceSchedules;
import models.Users;

/**
 *
 * @author THIS PC
 */
@WebServlet(name = "ServletMaintenanceSchedule", urlPatterns = {"/ServletMaintenanceSchedule"})
public class ServletMaintenanceSchedule extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        HttpSession session = request.getSession(true);

        String service = request.getParameter("service");
        if (service == null) {
            service = "listMaintenanceSchedule";
        }

        Users user = (Users) session.getAttribute("user");
        if (user == null) {
            response.sendRedirect("jsp/LoginUser.jsp");
            return;
        }

        int UserID = user.getUserID();
        int RoleID = user.getRoleID();

        MaintenanceScheduleDAO DAO = new MaintenanceScheduleDAO();
        EmployeeDAO eDAO = new EmployeeDAO();
        SwimmingPoolDAO swDAO = new SwimmingPoolDAO();

        int poolID = 0;
        String position = "";

        if (RoleID != 1 && RoleID != 3) {
            response.sendRedirect("jsp/LoginUser.jsp");
            return;
        }

        if (RoleID == 3) {
            Employee employee = eDAO.getEmployeeInfoByUserID(UserID);
            poolID = employee.getPoolID();
            position = employee.getPosition().trim();

            if (!position.equals("Manager")) {
                response.sendRedirect("jsp/LoginUser.jsp");
                return;
            }
        }

        if (service.equals("DeleteMaintenanceSchedule")) {
            int maintenanceID = Integer.parseInt(request.getParameter("maintenanceID"));
            DAO.deleteMaintenanceSchedule(maintenanceID);
            response.sendRedirect("ServletMaintenanceSchedule");
        }

        if (service.equals("UpdateMaintenanceSchedule")) {
            String submit = request.getParameter("submit");
            if (submit == null) {
                int maintenanceID = Integer.parseInt(request.getParameter("maintenanceID"));

                MaintenanceSchedules schedule = DAO.getMaintenanceScheduleByID(maintenanceID);

                request.setAttribute("schedule", schedule);
                request.setAttribute("poolID", poolID);
                request.setAttribute("pools", swDAO.getAllPools());
                request.setAttribute("position", position);

                request.getRequestDispatcher("jsp/UpdateMaintenanceSchedule.jsp").forward(request, response);
            } else {
                int maintenanceID = Integer.parseInt(request.getParameter("maintenanceID"));
                poolID = Integer.parseInt(request.getParameter("poolID"));
                String title = request.getParameter("title");
                Timestamp startDate = Timestamp.valueOf(LocalDateTime.parse(request.getParameter("startDate")));
                Timestamp endDate = Timestamp.valueOf(LocalDateTime.parse(request.getParameter("endDate")));
                String description = request.getParameter("description");
                String status = request.getParameter("status");

                MaintenanceSchedules m = new MaintenanceSchedules(maintenanceID, poolID, title,
                        startDate, endDate, description, status);

                DAO.updateMaintenanceSchedule(m);

                response.sendRedirect("ServletMaintenanceSchedule");
            }
        }

        if (service.equals("AddMaintenanceSchedule")) {
            String submit = request.getParameter("submit");
            if (submit == null) {
                request.setAttribute("poolID", poolID);
                request.setAttribute("position", position);
                request.setAttribute("pools", swDAO.getAllPools());
                request.getRequestDispatcher("jsp/AddMaintenanceSchedule.jsp").forward(request, response);
            } else {
                poolID = Integer.parseInt(request.getParameter("poolID"));
                String title = request.getParameter("title");
                Timestamp startDate = Timestamp.valueOf(LocalDateTime.parse(request.getParameter("startDate")));
                Timestamp endDate = Timestamp.valueOf(LocalDateTime.parse(request.getParameter("endDate")));
                String description = request.getParameter("description"),
                        status = "Scheduled";
                Timestamp createdAt = new Timestamp(System.currentTimeMillis());

                MaintenanceSchedules m = new MaintenanceSchedules(poolID, title, startDate, endDate, description, status, createdAt);

                DAO.insertMaintenanceSchedule(m);
                response.sendRedirect("ServletMaintenanceSchedule");
            }
        }

        if (service.equals("listMaintenanceSchedule")) {
            String poolName = request.getParameter("poolName");
            String status = request.getParameter("status");
            String date = request.getParameter("date");

            int TotalMaintenanceSchedule = DAO.getTotalMaintenanceSchedules(poolID);

            Vector<MaintenanceSchedules> schedules = DAO.maintenanceSchedule(poolID, poolName, status, date);
            request.setAttribute("schedules", schedules);
            request.setAttribute("poolName", poolName);
            request.setAttribute("status", status);
            request.setAttribute("date", date);
            request.setAttribute("TotalMaintenanceSchedule", TotalMaintenanceSchedule);
            request.setAttribute("position", position);
            request.setAttribute("RoleID", RoleID);

            request.getRequestDispatcher("jsp/MaintenanceSchedule.jsp").forward(request, response);
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
