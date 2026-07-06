package com.tap.daoimpl;

import com.tap.dao.UserDAO;
import com.tap.db.DBConnection;
import com.tap.model.User;
import com.tap.utility.DBUtility;

import java.sql.*;
import java.util.*;

public class UserDAOImpl implements UserDAO {

    @Override
    public boolean insertUser(User user) {
        String sql = "INSERT INTO User (username, password, email, address, role) VALUES (?, ?, ?, ?, ?)";
        PreparedStatement ps = null;
        try {
            Connection conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, user.getUsername());
            ps.setString(2, user.getPassword());
            ps.setString(3, user.getEmail());
            ps.setString(4, user.getAddress());
            ps.setString(5, user.getRole());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            DBUtility.closeResources(ps);
        }
    }

    @Override
    public User getUserByID(int userID) {
        String sql = "SELECT * FROM User WHERE userID = ?";
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            Connection conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, userID);
            rs = ps.executeQuery();
            if (rs.next()) return mapUser(rs);
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtility.closeResources(ps, rs);
        }
        return null;
    }

    @Override
    public User getUserByEmail(String email) {
        String sql = "SELECT * FROM User WHERE email = ?";
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            Connection conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, email);
            rs = ps.executeQuery();
            if (rs.next()) return mapUser(rs);
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtility.closeResources(ps, rs);
        }
        return null;
    }

    @Override
    public List<User> getAllUsers() {
        String sql = "SELECT * FROM User";
        List<User> users = new ArrayList<>();
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            Connection conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();
            while (rs.next()) users.add(mapUser(rs));
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtility.closeResources(ps, rs);
        }
        return users;
    }

    @Override
    public boolean updateUser(User user) {
        String sql = "UPDATE User SET username=?, email=?, address=?, role=? WHERE userID=?";
        PreparedStatement ps = null;
        try {
            Connection conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, user.getUsername());
            ps.setString(2, user.getEmail());
            ps.setString(3, user.getAddress());
            ps.setString(4, user.getRole());
            ps.setInt(5, user.getUserID());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            DBUtility.closeResources(ps);
        }
    }

    @Override
    public boolean deleteUser(int userID) {
        String sql = "DELETE FROM User WHERE userID = ?";
        PreparedStatement ps = null;
        try {
            Connection conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, userID);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            DBUtility.closeResources(ps);
        }
    }

    private User mapUser(ResultSet rs) throws SQLException {
        User u = new User();
        u.setUserID(rs.getInt("userID"));
        u.setUsername(rs.getString("username"));
        u.setPassword(rs.getString("password"));
        u.setEmail(rs.getString("email"));
        u.setAddress(rs.getString("address"));
        u.setRole(rs.getString("role"));
        u.setCreateDate(rs.getTimestamp("createDate"));
        u.setLastLoginDate(rs.getTimestamp("lastLoginDate"));
        return u;
    }
}