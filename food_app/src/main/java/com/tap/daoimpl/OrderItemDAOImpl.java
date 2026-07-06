package com.tap.daoimpl;

import com.tap.dao.OrderItemDAO;
import com.tap.db.DBConnection;
import com.tap.model.OrderItem;
import com.tap.utility.DBUtility;

import java.sql.*;
import java.util.*;

public class OrderItemDAOImpl implements OrderItemDAO {

 @Override
 public boolean insertOrderItem(OrderItem oi) {
     String sql = "INSERT INTO OrderItem (OrderID, MenuID, Quantity, ItemTotal) VALUES (?,?,?,?)";
     PreparedStatement ps = null;
     try {
         ps = DBConnection.getConnection().prepareStatement(sql);
         ps.setInt(1, oi.getOrderID());
         ps.setInt(2, oi.getMenuID());
         ps.setInt(3, oi.getQuantity());
         ps.setDouble(4, oi.getItemTotal());
         return ps.executeUpdate() > 0;
     } catch (SQLException e) {
         e.printStackTrace();
         return false;
     } finally {
         DBUtility.closeResources(ps);
     }
 }

 @Override
 public List<OrderItem> getItemsByOrder(int orderID) {
     List<OrderItem> list = new ArrayList<>();
     String sql = "SELECT * FROM OrderItem WHERE OrderID = ?";
     PreparedStatement ps = null; ResultSet rs = null;
     try {
         ps = DBConnection.getConnection().prepareStatement(sql);
         ps.setInt(1, orderID);
         rs = ps.executeQuery();
         while (rs.next()) {
             OrderItem oi = new OrderItem();
             oi.setOrderItemID(rs.getInt("OrderItemID"));
             oi.setOrderID(rs.getInt("OrderID"));
             oi.setMenuID(rs.getInt("MenuID"));
             oi.setQuantity(rs.getInt("Quantity"));
             oi.setItemTotal(rs.getDouble("ItemTotal"));
             list.add(oi);
         }
     } catch (SQLException e) {
         e.printStackTrace();
     } finally {
         DBUtility.closeResources(ps, rs);
     }
     return list;
 }
}