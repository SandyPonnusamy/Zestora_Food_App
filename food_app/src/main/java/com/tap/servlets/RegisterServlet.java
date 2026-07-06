package com.tap.servlets;

import java.io.IOException;

import org.mindrot.jbcrypt.BCrypt;

import com.tap.daoimpl.DeliveryAgentDAOImpl;
import com.tap.daoimpl.UserDAOImpl;
import com.tap.model.DeliveryAgent;
import com.tap.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/callRegisterServlet")
public class RegisterServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // Read form fields (must match the "name" attributes in your registration form)
        String username = req.getParameter("username");
        String email = req.getParameter("email");
        String password = req.getParameter("password");
        String address = req.getParameter("address");
        String role = req.getParameter("role");

        // Hash the password BEFORE setting it on the User object
        String hashedPassword = BCrypt.hashpw(password, BCrypt.gensalt(12));

        // Build User object using setters (safer than relying on constructor order)
        User user = new User();
        user.setUsername(username);
        user.setEmail(email);
        user.setPassword(hashedPassword);   // store the HASH, not raw password
        user.setAddress(address);
        user.setRole(role);

        UserDAOImpl userDAO = new UserDAOImpl();
        boolean isRegistered = userDAO.insertUser(user);

        if (isRegistered) {
            // If registering as delivery agent, also create a DeliveryAgent record
            if ("DELIVERY_AGENT".equals(role)) {
                User createdUser = userDAO.getUserByEmail(email);
                if (createdUser != null) {
                    DeliveryAgent agent = new DeliveryAgent();
                    agent.setUserID(createdUser.getUserID());
                    agent.setFullName(username);
                    agent.setPhone("");
                    agent.setVehicleType("");
                    agent.setVehicleNumber("");
                    new DeliveryAgentDAOImpl().insertAgent(agent);
                }
            }
            // Registration Successful
            resp.sendRedirect("login.jsp");
        } else {
            // Registration Failed
            req.setAttribute("error", "Registration failed. Please try again.");
            req.getRequestDispatcher("register.html").forward(req, resp);
        }
    }
}