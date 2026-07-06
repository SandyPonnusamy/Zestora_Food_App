package com.tap.servlets;

import org.mindrot.jbcrypt.BCrypt;

import com.tap.daoimpl.UserDAOImpl;
import com.tap.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/callLoginServlet")
public class LoginServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        String password = request.getParameter("password");

        UserDAOImpl userDAO = new UserDAOImpl();
        User user = userDAO.getUserByEmail(email);

        if (user == null || !BCrypt.checkpw(password, user.getPassword())) {
            request.setAttribute("error", "Invalid email or password");
            request.getRequestDispatcher("login.jsp").forward(request, response);
            return;
        }

        HttpSession session = request.getSession();
        session.setAttribute("user", user);

        // Role-based redirect
        switch (user.getRole()) {
            case "RESTAURANT_ADMIN":
                response.sendRedirect("adminServlet?action=dashboard");
                break;
            case "ADMIN":
                response.sendRedirect("adminPlatformServlet?action=dashboard");
                break;
            case "DELIVERY_AGENT":
                response.sendRedirect("agentServlet?action=dashboard");
                break;
            default: // USER
                response.sendRedirect("callRestaurantServlet");
        }
    }
}