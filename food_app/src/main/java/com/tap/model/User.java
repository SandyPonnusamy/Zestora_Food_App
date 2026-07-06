// model/User.java
package com.tap.model;

import java.util.Date;

public class User {
    private int userID;
    private String username;
    private String password;
    private String email;
    private String address;
    private String role; // USER, ADMIN, RESTAURANT_ADMIN, DELIVERY_AGENT
    private Date createDate;
    private Date lastLoginDate;

    public User() {}

    public User(int userID, String username, String password, String email,
                String address, String role, Date createDate, Date lastLoginDate) {
        this.userID = userID;
        this.username = username;
        this.password = password;
        this.email = email;
        this.address = address;
        this.role = role;
        this.createDate = createDate;
        this.lastLoginDate = lastLoginDate;
    }

    // Getters & Setters
    public int getUserID() { return userID; }
    public void setUserID(int userID) { this.userID = userID; }

    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }

    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getAddress() { return address; }
    public void setAddress(String address) { this.address = address; }

    public String getRole() { return role; }
    public void setRole(String role) { this.role = role; }

    public Date getCreateDate() { return createDate; }
    public void setCreateDate(Date createDate) { this.createDate = createDate; }

    public Date getLastLoginDate() { return lastLoginDate; }
    public void setLastLoginDate(Date lastLoginDate) { this.lastLoginDate = lastLoginDate; }
}