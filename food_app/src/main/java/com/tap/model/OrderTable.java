package com.tap.model;

import java.util.Date;

public class OrderTable {
 private int orderID;
 private int userID;
 private int restaurantID;
 private Date orderDate;
 private double totalAmount;
 private String status;
 private String paymentMethod;
 private int agentID;

 public OrderTable() {}

 public OrderTable(int orderID, int userID, int restaurantID, Date orderDate,
                   double totalAmount, String status, String paymentMethod) {
     this.orderID = orderID;
     this.userID = userID;
     this.restaurantID = restaurantID;
     this.orderDate = orderDate;
     this.totalAmount = totalAmount;
     this.status = status;
     this.paymentMethod = paymentMethod;
 }

 public int getOrderID() { return orderID; }
 public void setOrderID(int orderID) { this.orderID = orderID; }

 public int getUserID() { return userID; }
 public void setUserID(int userID) { this.userID = userID; }

 public int getRestaurantID() { return restaurantID; }
 public void setRestaurantID(int restaurantID) { this.restaurantID = restaurantID; }

 public Date getOrderDate() { return orderDate; }
 public void setOrderDate(Date orderDate) { this.orderDate = orderDate; }

 public double getTotalAmount() { return totalAmount; }
 public void setTotalAmount(double totalAmount) { this.totalAmount = totalAmount; }

 public String getStatus() { return status; }
 public void setStatus(String status) { this.status = status; }

 public String getPaymentMethod() { return paymentMethod; }
 public void setPaymentMethod(String paymentMethod) { this.paymentMethod = paymentMethod; }

 public int getAgentID() { return agentID; }
 public void setAgentID(int agentID) { this.agentID = agentID; }
}