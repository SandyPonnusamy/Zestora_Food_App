package com.tap.dao;


import com.tap.model.OrderTable;
import java.util.List;

public interface OrderDAO {
 boolean insertOrder(OrderTable order);
 OrderTable getOrderByID(int orderID);
 List<OrderTable> getOrdersByUser(int userID);
 List<OrderTable> getOrdersByRestaurant(int restaurantID);
 List<OrderTable> getAllOrders();
 boolean updateOrderStatus(int orderID, String status);
 boolean assignAgent(int orderID, int agentID);
 List<OrderTable> getOrdersByAgent(int agentID);
}