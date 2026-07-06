package com.tap.daoimpl;


import com.tap.dao.OrderDAO;
import com.tap.db.DBConnection;
import com.tap.model.OrderTable;
import com.tap.utility.DBUtility;

import java.sql.*;
import java.util.*;

public class OrderDAOImpl implements OrderDAO {

 @Override
 public boolean insertOrder(OrderTable o) {
     String sql = "INSERT INTO OrderTable (UserID, RestaurantID, TotalAmount, Status, PaymentMethod) VALUES (?,?,?,?,?)";
     PreparedStatement ps = null;
     try {
         ps = DBConnection.getConnection().prepareStatement(sql);
         ps.setInt(1, o.getUserID());
         ps.setInt(2, o.getRestaurantID());
         ps.setDouble(3, o.getTotalAmount());
         ps.setString(4, o.getStatus());
         ps.setString(5, o.getPaymentMethod());
         return ps.executeUpdate() > 0;
     } catch (SQLException e) {
         e.printStackTrace();
         return false;
     } finally {
         DBUtility.closeResources(ps);
     }
 }

 @Override
 public OrderTable getOrderByID(int orderID) {
     String sql = "SELECT * FROM OrderTable WHERE OrderID = ?";
     PreparedStatement ps = null; ResultSet rs = null;
     try {
         ps = DBConnection.getConnection().prepareStatement(sql);
         ps.setInt(1, orderID);
         rs = ps.executeQuery();
         if (rs.next()) return mapOrder(rs);
     } catch (SQLException e) {
         e.printStackTrace();
     } finally {
         DBUtility.closeResources(ps, rs);
     }
     return null;
 }

 @Override
 public List<OrderTable> getOrdersByUser(int userID) {
     List<OrderTable> list = new ArrayList<>();
     String sql = "SELECT * FROM OrderTable WHERE UserID = ?";
     PreparedStatement ps = null; ResultSet rs = null;
     try {
         ps = DBConnection.getConnection().prepareStatement(sql);
         ps.setInt(1, userID);
         rs = ps.executeQuery();
         while (rs.next()) list.add(mapOrder(rs));
     } catch (SQLException e) {
         e.printStackTrace();
     } finally {
         DBUtility.closeResources(ps, rs);
     }
     return list;
 }

 @Override
 public List<OrderTable> getOrdersByRestaurant(int restaurantID) {
     List<OrderTable> list = new ArrayList<>();
     String sql = "SELECT * FROM OrderTable WHERE RestaurantID = ?";
     PreparedStatement ps = null; ResultSet rs = null;
     try {
         ps = DBConnection.getConnection().prepareStatement(sql);
         ps.setInt(1, restaurantID);
         rs = ps.executeQuery();
         while (rs.next()) list.add(mapOrder(rs));
     } catch (SQLException e) {
         e.printStackTrace();
     } finally {
         DBUtility.closeResources(ps, rs);
     }
     return list;
 }

 @Override
 public List<OrderTable> getAllOrders() {
     List<OrderTable> list = new ArrayList<>();
     String sql = "SELECT * FROM OrderTable ORDER BY OrderDate DESC";
     PreparedStatement ps = null; ResultSet rs = null;
     try {
         ps = DBConnection.getConnection().prepareStatement(sql);
         rs = ps.executeQuery();
         while (rs.next()) list.add(mapOrder(rs));
     } catch (SQLException e) {
         e.printStackTrace();
     } finally {
         DBUtility.closeResources(ps, rs);
     }
     return list;
 }

 @Override
 public boolean updateOrderStatus(int orderID, String status) {
     String sql = "UPDATE OrderTable SET Status = ? WHERE OrderID = ?";
     PreparedStatement ps = null;
     try {
         ps = DBConnection.getConnection().prepareStatement(sql);
         ps.setString(1, status);
         ps.setInt(2, orderID);
         return ps.executeUpdate() > 0;
     } catch (SQLException e) {
         e.printStackTrace();
         return false;
     } finally {
         DBUtility.closeResources(ps);
     }
 }

 private OrderTable mapOrder(ResultSet rs) throws SQLException {
     OrderTable o = new OrderTable();
     o.setOrderID(rs.getInt("OrderID"));
     o.setUserID(rs.getInt("UserID"));
     o.setRestaurantID(rs.getInt("RestaurantID"));
     o.setOrderDate(rs.getTimestamp("OrderDate"));
     o.setTotalAmount(rs.getDouble("TotalAmount"));
     o.setStatus(rs.getString("Status"));
      o.setPaymentMethod(rs.getString("PaymentMethod"));
      o.setAgentID(rs.getInt("AgentID"));
      return o;
 }

 @Override
 public List<OrderTable> getOrdersByAgent(int agentID) {
     List<OrderTable> list = new ArrayList<>();
     String sql = "SELECT * FROM OrderTable WHERE AgentID = ? ORDER BY OrderDate DESC";
     PreparedStatement ps = null; ResultSet rs = null;
     try {
         ps = DBConnection.getConnection().prepareStatement(sql);
         ps.setInt(1, agentID);
         rs = ps.executeQuery();
         while (rs.next()) list.add(mapOrder(rs));
     } catch (SQLException e) {
         e.printStackTrace();
     } finally { DBUtility.closeResources(ps, rs); }
     return list;
 }

 @Override
 public boolean assignAgent(int orderID, int agentID) {
     String sql = "UPDATE OrderTable SET AgentID = ? WHERE OrderID = ?";
     PreparedStatement ps = null;
     try {
         ps = DBConnection.getConnection().prepareStatement(sql);
         ps.setInt(1, agentID);
         ps.setInt(2, orderID);
         return ps.executeUpdate() > 0;
     } catch (SQLException e) {
         e.printStackTrace(); return false;
     } finally { DBUtility.closeResources(ps); }
 }
}