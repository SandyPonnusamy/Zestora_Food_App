package com.tap.servlets;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

import com.tap.daoimpl.DeliveryAgentDAOImpl;
import com.tap.daoimpl.OrderDAOImpl;
import com.tap.daoimpl.OrderItemDAOImpl;
import com.tap.daoimpl.UserDAOImpl;
import com.tap.db.DBConnection;
import com.tap.model.Cart;
import com.tap.model.CartItem;
import com.tap.model.DeliveryAgent;
import com.tap.model.OrderItem;
import com.tap.model.User;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/confirm")
public class ConfirmServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession();
        Cart cart = (Cart) session.getAttribute("cart");
        User user = (User) session.getAttribute("user");
        Integer restaurantId = (Integer) session.getAttribute("restaurantId");

        if (cart == null || cart.isEmpty() || user == null || restaurantId == null) {
            resp.sendRedirect("cartServlet");
            return;
        }

        String paymentMethod = req.getParameter("paymentMethod");
        if (paymentMethod == null || paymentMethod.trim().isEmpty()) {
            paymentMethod = "UPI";
        }

        String delAddr = (String) session.getAttribute("deliveryAddress");
        String delCity = (String) session.getAttribute("deliveryCity");
        String delPcode = (String) session.getAttribute("deliveryPincode");
        String delPhone = (String) session.getAttribute("deliveryPhone");
        String fullAddress = delAddr;
        if (delCity != null && !delCity.trim().isEmpty()) {
            fullAddress += ", " + delCity;
        }
        if (delPcode != null && !delPcode.trim().isEmpty()) {
            fullAddress += " - " + delPcode;
        }

        double grandTotal = cart.getGrandTotal() + 30.0 + 15.0 + Math.round(cart.getGrandTotal() * 0.05 * 100) / 100.0;

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);

            String sql = "INSERT INTO OrderTable (UserID, RestaurantID, TotalAmount, Status, PaymentMethod) VALUES (?, ?, ?, 'Pending', ?)";
            ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            ps.setInt(1, user.getUserID());
            ps.setInt(2, restaurantId);
            ps.setDouble(3, grandTotal);
            ps.setString(4, paymentMethod);

            int affected = ps.executeUpdate();
            if (affected == 0) {
                conn.rollback();
                session.setAttribute("orderError", "Failed to create order. Please try again.");
                resp.sendRedirect("confirm.jsp");
                return;
            }

            rs = ps.getGeneratedKeys();
            int orderId = 0;
            if (rs.next()) {
                orderId = rs.getInt(1);
            }
            rs.close();
            ps.close();

            OrderItemDAOImpl orderItemDAO = new OrderItemDAOImpl();
            for (CartItem ci : cart.getItems().values()) {
                OrderItem oi = new OrderItem(0, orderId, ci.getMenuId(), ci.getQuantity(), ci.getPrice() * ci.getQuantity());
                orderItemDAO.insertOrderItem(oi);
            }

            if (user.getAddress() == null || user.getAddress().trim().isEmpty()) {
                UserDAOImpl userDAO = new UserDAOImpl();
                user.setAddress(fullAddress);
                userDAO.updateUser(user);
            }

            conn.commit();

            // Auto-assign delivery agent
            DeliveryAgentDAOImpl agentDAO = new DeliveryAgentDAOImpl();
            DeliveryAgent assignedAgent = agentDAO.getAgentWithLeastOrders();
            if (assignedAgent != null) {
                OrderDAOImpl orderDAO = new OrderDAOImpl();
                orderDAO.assignAgent(orderId, assignedAgent.getAgentID());
            }

            cart.clear();
            session.removeAttribute("deliveryAddress");
            session.removeAttribute("deliveryCity");
            session.removeAttribute("deliveryPincode");
            session.removeAttribute("deliveryPhone");
            session.removeAttribute("deliveryNote");
            session.setAttribute("orderId", orderId);
            session.setAttribute("orderSuccess", true);

            resp.sendRedirect("orderSuccess.jsp");

        } catch (SQLException e) {
            try {
                if (conn != null) conn.rollback();
            } catch (SQLException ignored) {}
            e.printStackTrace();
            session.setAttribute("orderError", "Something went wrong. Please try again.");
            resp.sendRedirect("confirm.jsp");

        } finally {
            try {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
            } catch (SQLException ignored) {}
        }
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        resp.sendRedirect("cartServlet");
    }
}
