/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Until;

import dal.MaintenanceScheduleDAO;
import dal.NotificationDAO;
import dal.SendEmailDAO;
import java.sql.Timestamp;
import java.time.LocalDate;
import java.time.temporal.ChronoUnit;
import java.util.Vector;
import models.MaintenanceSchedules;
import models.Notifications;
import models.Users;
import org.quartz.Job;
import org.quartz.JobExecutionContext;
import org.quartz.JobExecutionException;

/**
 *
 * @author THIS PC
 */
public class AutoNotification implements Job {

    @Override
    public void execute(JobExecutionContext context) throws JobExecutionException {
        NotificationDAO notiDAO = new NotificationDAO();
        MaintenanceScheduleDAO scheduleDAO = new MaintenanceScheduleDAO();
        SendEmailDAO emailDAO = new SendEmailDAO();
        notiDAO.checkExpiringUserPackagesAndNotify();

        Vector<MaintenanceSchedules> schedules = scheduleDAO.getAllSchedules();

        LocalDate today = LocalDate.now();

        for (MaintenanceSchedules m : schedules) {
            LocalDate start = m.getStartDate().toLocalDateTime().toLocalDate();
            LocalDate end = m.getEndDate().toLocalDateTime().toLocalDate();

            long daysUntilStart = ChronoUnit.DAYS.between(today, start);
            long daysOfMaintenance = ChronoUnit.DAYS.between(start, end) + 1;

            // ✅ TH1: Gửi thông báo và email nếu còn 2 ngày
            if (daysUntilStart == 2 && "Scheduled".equals(m.getStatus())) {
                Vector<Users> user = scheduleDAO.getUsersByPoolID(m.getPoolID());
                for (Users u : user) {
                    Notifications n = new Notifications(u.getUserID(),
                            "Lịch bảo trì sắp tới", "Bể bơi " + m.getPoolName() + " sẽ bảo trì từ " + start + " đến " + end + ". Vui lòng lưu ý.",
                    false, new Timestamp(System.currentTimeMillis()));
                    notiDAO.insertNotification(n);
                    try {
                        String Title = "Lịch bảo trì sắp tới";
                        String Content ="Bể bơi " + m.getPoolName() + " sẽ bảo trì từ " + start + " đến hết " + end + " và gói bơi của bạn sẽ được cộng tưng ứng với số ngày bảo trì. Vui lòng lưu ý.";
                        emailDAO.sendEmailMaintenanceSchedule(u.getEmail(),Title, Content);
                    } catch (Exception e) {
                        e.printStackTrace();
                    }
                }
            }

            // ✅ TH2: Đến ngày StartDate → Chuyển sang InProgress
            if (daysUntilStart == 0 && "Scheduled".equals(m.getStatus())) {
                scheduleDAO.updateStatus(m.getMaintenanceID(), "InProgress");
            }

            // ✅ TH3: Đến ngày EndDate → Chuyển sang Completed và cộng thời gian gói
            if (today.isEqual(end) && "InProgress".equals(m.getStatus())) {
                scheduleDAO.updateStatus(m.getMaintenanceID(), "Completed");
                scheduleDAO.extendUserPackagesByPool(m.getPoolID(), (int) daysOfMaintenance);
            }
        }
    }
}

