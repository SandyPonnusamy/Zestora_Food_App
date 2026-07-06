package com.tap.daoimpl;
import com.tap.dao.MenuDAO;
import com.tap.db.DBConnection;
import com.tap.model.Menu;
import com.tap.utility.DBUtility;
import java.sql.*;
import java.util.*;
public class MenuDAOImpl implements MenuDAO {

 @Override
 public boolean insertMenu(Menu m) {
     String sql = "INSERT INTO Menu (RestaurantID, ItemName, Description, Price, IsAvailable, Category, ImageURL) VALUES (?,?,?,?,?,?,?)";
     PreparedStatement ps = null;
     try {
         ps = DBConnection.getConnection().prepareStatement(sql);
         ps.setInt(1, m.getRestaurantID());
         ps.setString(2, m.getItemName());
         ps.setString(3, m.getDescription());
         ps.setDouble(4, m.getPrice());
         ps.setInt(5, m.getIsAvailable());
         ps.setString(6, m.getCategory());
         ps.setString(7, m.getImageURL());
         return ps.executeUpdate() > 0;
     } catch (SQLException e) {
         e.printStackTrace();
         return false;
     } finally {
         DBUtility.closeResources(ps);
     }
 }

 @Override
 public Menu getMenuByID(int menuID) {
     String sql = "SELECT * FROM Menu WHERE MenuID = ? AND DeletedAt IS NULL";
     PreparedStatement ps = null; ResultSet rs = null;
     try {
         ps = DBConnection.getConnection().prepareStatement(sql);
         ps.setInt(1, menuID);
         rs = ps.executeQuery();
         if (rs.next()) return mapMenu(rs);
     } catch (SQLException e) {
         e.printStackTrace();
     } finally {
         DBUtility.closeResources(ps, rs);
     }
     return null;
 }

 @Override
 public List<Menu> getMenuByRestaurant(int restaurantID) {
     List<Menu> list = new ArrayList<>();
     String sql = "SELECT * FROM Menu WHERE RestaurantID = ? AND DeletedAt IS NULL";
     PreparedStatement ps = null; ResultSet rs = null;
     try {
         ps = DBConnection.getConnection().prepareStatement(sql);
         ps.setInt(1, restaurantID);
         rs = ps.executeQuery();
         while (rs.next()) list.add(mapMenu(rs));
     } catch (SQLException e) {
         e.printStackTrace();
     } finally {
         DBUtility.closeResources(ps, rs);
     }
     return list;
 }

 @Override
 public boolean updateMenu(Menu m) {
     String sql = "UPDATE Menu SET ItemName=?, Description=?, Price=?, IsAvailable=?, Category=?, ImageURL=? WHERE MenuID=?";
     PreparedStatement ps = null;
     try {
         ps = DBConnection.getConnection().prepareStatement(sql);
         ps.setString(1, m.getItemName());
         ps.setString(2, m.getDescription());
         ps.setDouble(3, m.getPrice());
         ps.setInt(4, m.getIsAvailable());
         ps.setString(5, m.getCategory());
         ps.setString(6, m.getImageURL());
         ps.setInt(7, m.getMenuID());
         return ps.executeUpdate() > 0;
     } catch (SQLException e) {
         e.printStackTrace();
         return false;
     } finally {
         DBUtility.closeResources(ps);
     }
 }

 @Override
 public boolean softDeleteMenu(int menuID) {
     String sql = "UPDATE Menu SET DeletedAt = NOW() WHERE MenuID = ?";
     PreparedStatement ps = null;
     try {
         ps = DBConnection.getConnection().prepareStatement(sql);
         ps.setInt(1, menuID);
         return ps.executeUpdate() > 0;
     } catch (SQLException e) {
         e.printStackTrace();
         return false;
     } finally {
         DBUtility.closeResources(ps);
     }
 }

 private Menu mapMenu(ResultSet rs) throws SQLException {
     Menu m = new Menu();
     m.setMenuID(rs.getInt("MenuID"));
     m.setRestaurantID(rs.getInt("RestaurantID"));
     m.setItemName(rs.getString("ItemName"));
     m.setDescription(rs.getString("Description"));
     m.setPrice(rs.getDouble("Price"));
     m.setIsAvailable(rs.getInt("IsAvailable"));
     m.setCategory(rs.getString("Category"));
     m.setImageURL(rs.getString("ImageURL"));
     m.setCreatedAt(rs.getTimestamp("CreatedAt"));
     m.setUpdatedAt(rs.getTimestamp("UpdatedAt"));
     m.setDeletedAt(rs.getTimestamp("DeletedAt"));
     return m;
 }
}