package com.tap.daoimpl;


import com.tap.dao.RestaurantDAO;
import com.tap.db.DBConnection;
import com.tap.model.Restaurant;
import com.tap.utility.DBUtility;

import java.sql.*;
import java.util.*;

public class RestaurantDAOImpl implements RestaurantDAO {

	@Override
	public boolean insertRestaurant(Restaurant r) {

	    String sql = "INSERT INTO Restaurant "
	            + "(Name, CuisineType, DeliveryTime, Address, AdminUserID, "
	            + "Rating, IsActive, ImageURL, IsVeg, Badge, PriceForTwo) "
	            + "VALUES (?,?,?,?,?,?,?,?,?,?,?)";

	    PreparedStatement ps = null;

	    try {
	        ps = DBConnection.getConnection().prepareStatement(sql);

	        ps.setString(1, r.getName());
	        ps.setString(2, r.getCuisineType());
	        ps.setInt(3, r.getDeliveryTime());
	        ps.setString(4, r.getAddress());
	        ps.setInt(5, r.getAdminUserID());
	        ps.setDouble(6, r.getRating());
	        ps.setInt(7, r.getIsActive());

	        // New fields
	        ps.setString(8, r.getImageURL());
	        ps.setInt(9, r.getIsVeg());
	        ps.setString(10, r.getBadge());
	        ps.setString(11, r.getPriceForTwo());

	        return ps.executeUpdate() > 0;

	    } catch (SQLException e) {
	        e.printStackTrace();
	        return false;
	    } finally {
	        DBUtility.closeResources(ps);
	    }
	}
 @Override
 public Restaurant getRestaurantByID(int id) {
     String sql = "SELECT * FROM Restaurant WHERE RestaurantID = ?";
     PreparedStatement ps = null; ResultSet rs = null;
     try {
         ps = DBConnection.getConnection().prepareStatement(sql);
         ps.setInt(1, id);
         rs = ps.executeQuery();
         if (rs.next()) return mapRestaurant(rs);
     } catch (SQLException e) {
         e.printStackTrace();
     } finally {
         DBUtility.closeResources(ps, rs);
     }
     return null;
 }

 @Override
 public List<Restaurant> getAllRestaurants() {
     List<Restaurant> list = new ArrayList<>();
     String sql = "SELECT * FROM Restaurant";
     PreparedStatement ps = null; ResultSet rs = null;
     try {
         ps = DBConnection.getConnection().prepareStatement(sql);
         rs = ps.executeQuery();
         while (rs.next()) list.add(mapRestaurant(rs));
     } catch (SQLException e) {
         e.printStackTrace();
     } finally {
         DBUtility.closeResources(ps, rs);
     }
     return list;
 }

 @Override
 public List<Restaurant> getRestaurantsByAdmin(int adminUserID) {
     List<Restaurant> list = new ArrayList<>();
     String sql = "SELECT * FROM Restaurant WHERE AdminUserID = ?";
     PreparedStatement ps = null; ResultSet rs = null;
     try {
         ps = DBConnection.getConnection().prepareStatement(sql);
         ps.setInt(1, adminUserID);
         rs = ps.executeQuery();
         while (rs.next()) list.add(mapRestaurant(rs));
     } catch (SQLException e) {
         e.printStackTrace();
     } finally {
         DBUtility.closeResources(ps, rs);
     }
     return list;
 }

 @Override
 public boolean updateRestaurant(Restaurant r) {
     String sql = "UPDATE Restaurant SET Name=?, CuisineType=?, DeliveryTime=?, Address=?, AdminUserID=?, Rating=?, IsActive=?, ImageURL=?, IsVeg=?, Badge=?, PriceForTwo=? WHERE RestaurantID=?";
     PreparedStatement ps = null;
     try {
         ps = DBConnection.getConnection().prepareStatement(sql);
         ps.setString(1, r.getName());
         ps.setString(2, r.getCuisineType());
         ps.setInt(3, r.getDeliveryTime());
         ps.setString(4, r.getAddress());
         ps.setInt(5, r.getAdminUserID());
         ps.setDouble(6, r.getRating());
         ps.setInt(7, r.getIsActive());
         ps.setString(8, r.getImageURL());
         ps.setInt(9, r.getIsVeg());
         ps.setString(10, r.getBadge());
         ps.setString(11, r.getPriceForTwo());
         ps.setInt(12, r.getRestaurantID());
         return ps.executeUpdate() > 0;
     } catch (SQLException e) {
         e.printStackTrace();
         return false;
     } finally {
         DBUtility.closeResources(ps);
     }
 }

 @Override
 public boolean deleteRestaurant(int id) {
     String sql = "DELETE FROM Restaurant WHERE RestaurantID = ?";
     PreparedStatement ps = null;
     try {
         ps = DBConnection.getConnection().prepareStatement(sql);
         ps.setInt(1, id);
         return ps.executeUpdate() > 0;
     } catch (SQLException e) {
         e.printStackTrace();
         return false;
     } finally {
         DBUtility.closeResources(ps);
     }
 }

 private Restaurant mapRestaurant(ResultSet rs) throws SQLException {
     Restaurant r = new Restaurant();
     r.setRestaurantID(rs.getInt("RestaurantID"));
     r.setName(rs.getString("Name"));
     r.setCuisineType(rs.getString("CuisineType"));
     r.setDeliveryTime(rs.getInt("DeliveryTime"));
     r.setAddress(rs.getString("Address"));
     r.setAdminUserID(rs.getInt("AdminUserID"));
     r.setRating(rs.getDouble("Rating"));
     r.setIsActive(rs.getInt("IsActive"));
     
     r.setImageURL(rs.getString("ImageURL"));
     r.setIsVeg(rs.getInt("IsVeg"));
     r.setBadge(rs.getString("Badge"));
     r.setPriceForTwo(rs.getString("PriceForTwo"));

     return r;
 }
}