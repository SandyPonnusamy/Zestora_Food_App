package com.tap.daoimpl;

import com.tap.dao.DeliveryAgentDAO;
import com.tap.db.DBConnection;
import com.tap.model.DeliveryAgent;
import com.tap.utility.DBUtility;

import java.sql.*;
import java.util.*;

public class DeliveryAgentDAOImpl implements DeliveryAgentDAO {

    @Override
    public boolean insertAgent(DeliveryAgent a) {
        String sql = "INSERT INTO DeliveryAgent (UserID, FullName, Phone, VehicleType, VehicleNumber) VALUES (?,?,?,?,?)";
        PreparedStatement ps = null;
        try {
            ps = DBConnection.getConnection().prepareStatement(sql);
            ps.setInt(1, a.getUserID());
            ps.setString(2, a.getFullName());
            ps.setString(3, a.getPhone());
            ps.setString(4, a.getVehicleType());
            ps.setString(5, a.getVehicleNumber());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace(); return false;
        } finally { DBUtility.closeResources(ps); }
    }

    @Override
    public DeliveryAgent getAgentByID(int agentID) {
        String sql = "SELECT * FROM DeliveryAgent WHERE AgentID = ?";
        PreparedStatement ps = null; ResultSet rs = null;
        try {
            ps = DBConnection.getConnection().prepareStatement(sql);
            ps.setInt(1, agentID);
            rs = ps.executeQuery();
            if (rs.next()) return mapAgent(rs);
        } catch (SQLException e) {
            e.printStackTrace();
        } finally { DBUtility.closeResources(ps, rs); }
        return null;
    }

    @Override
    public DeliveryAgent getAgentByUserID(int userID) {
        String sql = "SELECT * FROM DeliveryAgent WHERE UserID = ?";
        PreparedStatement ps = null; ResultSet rs = null;
        try {
            ps = DBConnection.getConnection().prepareStatement(sql);
            ps.setInt(1, userID);
            rs = ps.executeQuery();
            if (rs.next()) return mapAgent(rs);
        } catch (SQLException e) {
            e.printStackTrace();
        } finally { DBUtility.closeResources(ps, rs); }
        return null;
    }

    @Override
    public List<DeliveryAgent> getAllAgents() {
        List<DeliveryAgent> list = new ArrayList<>();
        String sql = "SELECT * FROM DeliveryAgent";
        PreparedStatement ps = null; ResultSet rs = null;
        try {
            ps = DBConnection.getConnection().prepareStatement(sql);
            rs = ps.executeQuery();
            while (rs.next()) list.add(mapAgent(rs));
        } catch (SQLException e) {
            e.printStackTrace();
        } finally { DBUtility.closeResources(ps, rs); }
        return list;
    }

    @Override
    public List<DeliveryAgent> getAvailableAgents() {
        List<DeliveryAgent> list = new ArrayList<>();
        String sql = "SELECT * FROM DeliveryAgent WHERE IsAvailable = 1";
        PreparedStatement ps = null; ResultSet rs = null;
        try {
            ps = DBConnection.getConnection().prepareStatement(sql);
            rs = ps.executeQuery();
            while (rs.next()) list.add(mapAgent(rs));
        } catch (SQLException e) {
            e.printStackTrace();
        } finally { DBUtility.closeResources(ps, rs); }
        return list;
    }

    @Override
    public boolean updateAgent(DeliveryAgent a) {
        String sql = "UPDATE DeliveryAgent SET FullName=?, Phone=?, VehicleType=?, VehicleNumber=?, IsAvailable=? WHERE AgentID=?";
        PreparedStatement ps = null;
        try {
            ps = DBConnection.getConnection().prepareStatement(sql);
            ps.setString(1, a.getFullName());
            ps.setString(2, a.getPhone());
            ps.setString(3, a.getVehicleType());
            ps.setString(4, a.getVehicleNumber());
            ps.setInt(5, a.getIsAvailable());
            ps.setInt(6, a.getAgentID());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace(); return false;
        } finally { DBUtility.closeResources(ps); }
    }

    @Override
    public boolean updateAvailability(int agentID, int isAvailable) {
        String sql = "UPDATE DeliveryAgent SET IsAvailable=? WHERE AgentID=?";
        PreparedStatement ps = null;
        try {
            ps = DBConnection.getConnection().prepareStatement(sql);
            ps.setInt(1, isAvailable);
            ps.setInt(2, agentID);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace(); return false;
        } finally { DBUtility.closeResources(ps); }
    }

    @Override
    public DeliveryAgent getAgentWithLeastOrders() {
        // Among available agents, pick the one with fewest ACTIVE (non-delivered) orders
        String sql = "SELECT da.*, COUNT(o.OrderID) AS activeOrders " +
                     "FROM DeliveryAgent da " +
                     "LEFT JOIN OrderTable o ON da.AgentID = o.AgentID " +
                     "AND o.Status NOT IN ('DELIVERED','CANCELLED') " +
                     "WHERE da.IsAvailable = 1 " +
                     "GROUP BY da.AgentID " +
                     "ORDER BY activeOrders ASC " +
                     "LIMIT 1";
        PreparedStatement ps = null; ResultSet rs = null;
        try {
            ps = DBConnection.getConnection().prepareStatement(sql);
            rs = ps.executeQuery();
            if (rs.next()) return mapAgent(rs);
        } catch (SQLException e) {
            e.printStackTrace();
        } finally { DBUtility.closeResources(ps, rs); }
        return null;
    }

    @Override
    public boolean incrementDeliveryCount(int agentID, double fee) {
        String sql = "UPDATE DeliveryAgent SET TotalDeliveries = TotalDeliveries + 1, TotalEarnings = TotalEarnings + ? WHERE AgentID = ?";
        PreparedStatement ps = null;
        try {
            ps = DBConnection.getConnection().prepareStatement(sql);
            ps.setDouble(1, fee);
            ps.setInt(2, agentID);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace(); return false;
        } finally { DBUtility.closeResources(ps); }
    }

    private DeliveryAgent mapAgent(ResultSet rs) throws SQLException {
        DeliveryAgent a = new DeliveryAgent();
        a.setAgentID(rs.getInt("AgentID"));
        a.setUserID(rs.getInt("UserID"));
        a.setFullName(rs.getString("FullName"));
        a.setPhone(rs.getString("Phone"));
        a.setVehicleType(rs.getString("VehicleType"));
        a.setVehicleNumber(rs.getString("VehicleNumber"));
        a.setIsAvailable(rs.getInt("IsAvailable"));
        a.setTotalDeliveries(rs.getInt("TotalDeliveries"));
        a.setTotalEarnings(rs.getDouble("TotalEarnings"));
        a.setCreatedAt(rs.getTimestamp("CreatedAt"));
        return a;
    }
}