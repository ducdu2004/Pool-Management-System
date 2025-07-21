/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import java.util.Vector;
import models.MaintenanceSchedules;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Date;
import models.Users;

/**
 *
 * @author THIS PC
 */
public class MaintenanceScheduleDAO extends DBContext {

    public Vector<MaintenanceSchedules> getAllSchedules() {
        Vector<MaintenanceSchedules> list = new Vector<>();
        String sql = "SELECT m.*, s.name as poolName FROM MaintenanceSchedules m JOIN SwimmingPools s ON m.poolID = s.poolID";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                MaintenanceSchedules m = new MaintenanceSchedules();
                m.setMaintenanceID(rs.getInt("maintenanceID"));
                m.setPoolID(rs.getInt("poolID"));
                m.setPoolName(rs.getString("poolName"));
                m.setStartDate(rs.getTimestamp("startDate"));
                m.setEndDate(rs.getTimestamp("endDate"));
                m.setStatus(rs.getString("status"));
                list.add(m);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public Vector<MaintenanceSchedules> maintenanceSchedule(int poolID, String poolName, String status, String date) {
        Vector<MaintenanceSchedules> list = new Vector<>();
        String sql = "SELECT m.*, s.name as poolName FROM MaintenanceSchedules m "
                + "JOIN SwimmingPools s ON m.poolID = s.poolID WHERE 1=1";

        if (poolID > 0) {
            sql += " AND m.poolID = ?";
        }

        if (poolName != null && !poolName.trim().isEmpty()) {
            sql += " AND s.name LIKE ?";
        }

        if (status != null && !status.trim().isEmpty()) {
            sql += " AND m.status = ?";
        }

        if (date != null && !date.trim().isEmpty()) {
            sql += " AND (CONVERT(DATE, m.startDate) = ? OR CONVERT(DATE, m.endDate) = ?)";
        }

        sql += " ORDER BY m.maintenanceID DESC";

        try {
            PreparedStatement ps = connection.prepareStatement(sql);

            int i = 1;
            if (poolID > 0) {
                ps.setInt(i++, poolID);
            }
            if (poolName != null && !poolName.trim().isEmpty()) {
                ps.setString(i++, "%" + poolName + "%");
            }
            if (status != null && !status.trim().isEmpty()) {
                ps.setString(i++, status);
            }
            if (date != null && !date.trim().isEmpty()) {
                ps.setDate(i++, Date.valueOf(date));
                ps.setDate(i++, Date.valueOf(date));
            }

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                MaintenanceSchedules m = new MaintenanceSchedules();
                m.setMaintenanceID(rs.getInt("maintenanceID"));
                m.setPoolName(rs.getString("poolName"));
                m.setTitle(rs.getString("title"));
                m.setStartDate(rs.getTimestamp("startDate"));
                m.setEndDate(rs.getTimestamp("endDate"));
                m.setDescription(rs.getString("description"));
                m.setStatus(rs.getString("status"));
                list.add(m);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public int getTotalMaintenanceSchedules(int poolID) {
        int total = 0;
        String sql = "SELECT COUNT(*) FROM MaintenanceSchedules WHERE 1=1";

        if (poolID > 0) {
            sql += " AND poolID = ?";
        }

        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            if (poolID > 0) {
                ps.setInt(1, poolID);
            }

            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                total = rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return total;
    }

    public void insertMaintenanceSchedule(MaintenanceSchedules m) {
        String sql = "INSERT INTO [dbo].[MaintenanceSchedules]\n"
                + "           ([PoolID]\n"
                + "           ,[Title]\n"
                + "           ,[Startdate]\n"
                + "           ,[Enddate]\n"
                + "           ,[Description]\n"
                + "           ,[Status]\n"
                + "           ,[CreatedAt])\n"
                + "     VALUES (?,?,?,?,?,?,?)";

        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, m.getPoolID());
            ps.setString(2, m.getTitle());
            ps.setTimestamp(3, m.getStartDate());
            ps.setTimestamp(4, m.getEndDate());
            ps.setString(5, m.getDescription());
            ps.setString(6, m.getStatus());
            ps.setTimestamp(7, m.getCreatedAt());
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void updateMaintenanceSchedule(MaintenanceSchedules m) {
        String sql = "UPDATE MaintenanceSchedules SET PoolID = ?, Title = ?, StartDate = ?, EndDate = ?, "
                + "Description = ?, Status = ? WHERE MaintenanceID = ?";

        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, m.getPoolID());
            ps.setString(2, m.getTitle());
            ps.setTimestamp(3, m.getStartDate());
            ps.setTimestamp(4, m.getEndDate());
            ps.setString(5, m.getDescription());
            ps.setString(6, m.getStatus());
            ps.setInt(7, m.getMaintenanceID());
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public MaintenanceSchedules getMaintenanceScheduleByID(int id) {
        String sql = "SELECT * FROM MaintenanceSchedules WHERE MaintenanceID = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return new MaintenanceSchedules(
                        rs.getInt(1),
                        rs.getInt(2),
                        rs.getString(3),
                        rs.getTimestamp(4),
                        rs.getTimestamp(5),
                        rs.getString(6),
                        rs.getString(7)
                );
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public void deleteMaintenanceSchedule(int maintenanceID) {
        String sql = "DELETE FROM MaintenanceSchedules WHERE MaintenanceID = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, maintenanceID);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public Vector<Users> getUsersByPoolID(int poolID) {
        Vector<Users> list = new Vector<>();
        String sql = "SELECT DISTINCT u.* FROM Users u JOIN UserPackages up ON u.userID = up.userID WHERE up.poolID = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, poolID);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Users u = new Users();
                u.setUserID(rs.getInt("userID"));
                u.setEmail(rs.getString("email"));
                list.add(u);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public void updateStatus(int maintenanceID, String newStatus) {
        String sql = "UPDATE MaintenanceSchedules SET status = ? WHERE maintenanceID = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);

            ps.setString(1, newStatus);
            ps.setInt(2, maintenanceID);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void extendUserPackagesByPool(int poolID, int daysToAdd) {
        String sql = "UPDATE UserPackages SET EndDate = DATEADD(DAY, ?, EndDate) WHERE PoolID = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, daysToAdd);
            ps.setInt(2, poolID);

            ps.executeUpdate();            
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

}
