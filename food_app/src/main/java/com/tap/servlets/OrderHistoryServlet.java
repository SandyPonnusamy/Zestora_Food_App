package com.tap.servlets;

import java.io.IOException;
import java.util.List;

import com.tap.daoimpl.OrderDAOImpl;
import com.tap.model.OrderTable;
import com.tap.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/orderHistory")
public class OrderHistoryServlet extends HttpServlet {
	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		HttpSession session = req.getSession(false);
		User user = (session != null) ? (User) session.getAttribute("user") : null;
		if (user == null) {
			resp.sendRedirect("login.jsp");
			return;
		}

		OrderDAOImpl orderDAO = new OrderDAOImpl();
		List<OrderTable> orders = orderDAO.getOrdersByUser(user.getUserID());
		req.setAttribute("orders", orders);

		req.getRequestDispatcher("orders.jsp").forward(req, resp);
	}
}
