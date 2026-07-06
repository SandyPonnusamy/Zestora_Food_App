package com.tap.servlets;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.List;

import com.tap.daoimpl.RestaurantDAOImpl;
import com.tap.model.Restaurant;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;


@WebServlet("/callRestaurantServlet")
public class RestaurantServlet extends HttpServlet{
	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

		RestaurantDAOImpl restaurantDAOImpl = new RestaurantDAOImpl();
		List<Restaurant> allRestaurants = restaurantDAOImpl.getAllRestaurants();
		
		String search = req.getParameter("search");
		String location = req.getParameter("location");
		String category = req.getParameter("category");
		String sort = req.getParameter("sort");

		String q = search != null ? search.trim().toLowerCase() : "";
		String loc = location != null ? location.trim().toLowerCase() : "";

		List<Restaurant> filtered = new ArrayList<>();
		for (Restaurant r : allRestaurants) {
			boolean matchSearch = q.isEmpty() ||
				r.getName().toLowerCase().contains(q) ||
				r.getCuisineType().toLowerCase().contains(q);
			boolean matchLocation = loc.isEmpty() ||
				r.getAddress().toLowerCase().contains(loc);
			boolean matchCategory = category == null || category.isEmpty() ||
				r.getCuisineType().equalsIgnoreCase(category);
			if (matchSearch && matchLocation && matchCategory) {
				filtered.add(r);
			}
		}

		if (sort != null) {
			switch (sort) {
				case "recommended":
					Collections.sort(filtered, Comparator.comparingInt(r -> {
						String b = r.getBadge();
						if (b == null) return 3;
						switch (b.toLowerCase()) {
							case "bestseller": return 0;
							case "top rated": return 1;
							default: return 2;
						}
					}));
					break;
				case "toprated":
					Collections.sort(filtered, Comparator.comparingDouble(Restaurant::getRating).reversed());
					break;
				case "fastest":
					Collections.sort(filtered, Comparator.comparingInt(Restaurant::getDeliveryTime));
					break;
			}
		}
		allRestaurants = filtered;
		
		req.setAttribute("allRestaurants", allRestaurants);
		
		RequestDispatcher rd = req.getRequestDispatcher("restaurant.jsp");
		rd.forward(req, resp);
	}
}
