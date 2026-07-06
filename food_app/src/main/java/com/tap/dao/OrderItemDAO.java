package com.tap.dao;


import com.tap.model.OrderItem;
import java.util.List;

public interface OrderItemDAO {
 boolean insertOrderItem(OrderItem orderItem);
 List<OrderItem> getItemsByOrder(int orderID);
}