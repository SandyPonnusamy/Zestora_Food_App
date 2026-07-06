package com.tap.servlets;

import java.util.ArrayList;
import java.util.List;
import java.io.IOException;

import com.tap.daoimpl.MenuDAOImpl;
import com.tap.model.Menu;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;


@WebServlet("/menu")
public class MenuServlet extends HttpServlet {

	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

		MenuDAOImpl menuDaoImpl = new MenuDAOImpl();

		String restaurantIdParam = req.getParameter("restaurantID");

		if (restaurantIdParam == null || restaurantIdParam.isEmpty()) {
			resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing restaurantID parameter");
			return;
		}

		int restaurantID = Integer.parseInt(restaurantIdParam);
		List<Menu> allMenuByRestaurant = menuDaoImpl.getMenuByRestaurant(restaurantID);

		String category = req.getParameter("category");
		if (category != null && !category.trim().isEmpty()) {
			List<Menu> filtered = new ArrayList<>();
			for (Menu m : allMenuByRestaurant) {
				if (category.equals(m.getCategory())) {
					filtered.add(m);
				}
			}
			allMenuByRestaurant = filtered;
		}

		req.setAttribute("allMenuByRestaurant", allMenuByRestaurant);

		RequestDispatcher rd = req.getRequestDispatcher("menu.jsp");
		rd.forward(req, resp);
	}
}