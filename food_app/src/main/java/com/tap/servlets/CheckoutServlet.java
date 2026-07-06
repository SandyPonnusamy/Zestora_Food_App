package com.tap.servlets;

import java.io.IOException;

import com.tap.daoimpl.UserDAOImpl;
import com.tap.model.Cart;
import com.tap.model.User;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/checkout")
public class CheckoutServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        refreshUser(req);
        RequestDispatcher dispatcher = req.getRequestDispatcher("checkout.jsp");
        dispatcher.forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        HttpSession session = req.getSession();
        refreshUser(req);

        String fullAddress = req.getParameter("fullAddress");
        if (fullAddress != null && !fullAddress.trim().isEmpty()) {
            session.setAttribute("deliveryAddress", fullAddress);
            session.setAttribute("deliveryCity", req.getParameter("city"));
            session.setAttribute("deliveryPincode", req.getParameter("pincode"));
            session.setAttribute("deliveryPhone", req.getParameter("phone"));
            session.setAttribute("deliveryNote", req.getParameter("deliveryNote"));

            Cart cart = (Cart) session.getAttribute("cart");
            if (cart == null || cart.isEmpty()) {
                resp.sendRedirect("cartServlet");
                return;
            }

            resp.sendRedirect("confirm.jsp");
        } else {
            RequestDispatcher dispatcher = req.getRequestDispatcher("checkout.jsp");
            dispatcher.forward(req, resp);
        }
    }

    private void refreshUser(HttpServletRequest req) {
        HttpSession session = req.getSession();
        User sessionUser = (User) session.getAttribute("user");
        if (sessionUser != null) {
            UserDAOImpl userDAO = new UserDAOImpl();
            User freshUser = userDAO.getUserByID(sessionUser.getUserID());
            if (freshUser != null) {
                session.setAttribute("user", freshUser);
                session.setAttribute("userName", freshUser.getUsername());
                session.setAttribute("role", freshUser.getRole());
            }
        }
    }
    
    
}
