package com.tap.servlets;

import com.tap.daoimpl.*;
import com.tap.model.*;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/agentServlet")
public class DeliveryAgentServlet extends HttpServlet {

    OrderDAOImpl orderDAO = new OrderDAOImpl();
    DeliveryAgentDAOImpl agentDAO = new DeliveryAgentDAOImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        handleRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        handleRequest(request, response);
    }

    private void handleRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        // Security check
        if (user == null || !"DELIVERY_AGENT".equals(user.getRole())) {
            response.sendRedirect("login.jsp");
            return;
        }

        DeliveryAgent agent = agentDAO.getAgentByUserID(user.getUserID());
        if (agent == null) {
            request.setAttribute("error", "No agent profile found for this account.");
            request.getRequestDispatcher("agentDashboard.jsp").forward(request, response);
            return;
        }
        request.setAttribute("agent", agent);

        String action = request.getParameter("action");
        if (action == null) action = "dashboard";

        switch (action) {
            case "dashboard":
                showDashboard(request, response, agent);
                break;
            case "updateStatus":
                updateStatus(request, response, agent);
                break;
            case "toggleAvailability":
                toggleAvailability(request, response, agent);
                break;
            case "updateProfile":
                updateProfile(request, response, agent);
                break;
            default:
                showDashboard(request, response, agent);
        }
    }

    private void showDashboard(HttpServletRequest request, HttpServletResponse response,
                                DeliveryAgent agent) throws ServletException, IOException {
        // Get only orders assigned to this agent
        List<OrderTable> myOrders = orderDAO.getOrdersByAgent(agent.getAgentID());
        request.setAttribute("myOrders", myOrders);
        request.getRequestDispatcher("agentDashboard.jsp").forward(request, response);
    }

    private void updateStatus(HttpServletRequest request, HttpServletResponse response,
                               DeliveryAgent agent) throws ServletException, IOException {
        int orderID = Integer.parseInt(request.getParameter("orderId"));
        String status = request.getParameter("status");

        OrderTable order = orderDAO.getOrderByID(orderID);

        // Security: only update if this order belongs to this agent
        if (order != null && order.getAgentID() == agent.getAgentID()) {
            orderDAO.updateOrderStatus(orderID, status);

            // If delivered, increment agent stats
            if ("DELIVERED".equals(status)) {
                agentDAO.incrementDeliveryCount(agent.getAgentID(), 30.00);
            }
        }
        response.sendRedirect("agentServlet?action=dashboard");
    }

    private void toggleAvailability(HttpServletRequest request, HttpServletResponse response,
                                     DeliveryAgent agent) throws ServletException, IOException {
        int newStatus = (agent.getIsAvailable() == 1) ? 0 : 1;
        agentDAO.updateAvailability(agent.getAgentID(), newStatus);
        response.sendRedirect("agentServlet?action=dashboard");
    }

    private void updateProfile(HttpServletRequest request, HttpServletResponse response,
                                DeliveryAgent agent) throws ServletException, IOException {
        agent.setFullName(request.getParameter("fullName"));
        agent.setPhone(request.getParameter("phone"));
        agent.setVehicleType(request.getParameter("vehicleType"));
        agent.setVehicleNumber(request.getParameter("vehicleNumber"));
        agentDAO.updateAgent(agent);
        response.sendRedirect("agentServlet?action=dashboard");
    }
}