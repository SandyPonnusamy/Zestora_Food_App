package com.tap.dao;

import com.tap.model.DeliveryAgent;
import java.util.List;

public interface DeliveryAgentDAO {
    boolean insertAgent(DeliveryAgent agent);
    DeliveryAgent getAgentByID(int agentID);
    DeliveryAgent getAgentByUserID(int userID);
    List<DeliveryAgent> getAllAgents();
    List<DeliveryAgent> getAvailableAgents();
    boolean updateAgent(DeliveryAgent agent);
    boolean updateAvailability(int agentID, int isAvailable);

    // Auto-assign: agent with fewest active orders
    DeliveryAgent getAgentWithLeastOrders();

    // After delivery completed
    boolean incrementDeliveryCount(int agentID, double fee);
}