package com.tap.servlets;

import com.tap.daoimpl.*;
import com.tap.model.*;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/adminPlatformServlet")
public class AdminPlatformServlet extends HttpServlet {

    RestaurantDAOImpl restaurantDAO = new RestaurantDAOImpl();
    MenuDAOImpl menuDAO = new MenuDAOImpl();
    OrderDAOImpl orderDAO = new OrderDAOImpl();
    OrderItemDAOImpl orderItemDAO = new OrderItemDAOImpl();
    UserDAOImpl userDAO = new UserDAOImpl();

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
        User admin = (User) session.getAttribute("user");

        if (admin == null || !"ADMIN".equals(admin.getRole())) {
            response.sendRedirect("login.jsp");
            return;
        }

        String action = request.getParameter("action");
        if (action == null) action = "dashboard";

        switch (action) {
            case "dashboard":
                showDashboard(request, response);
                break;
            case "addRestaurant":
                addRestaurant(request, response);
                break;
            case "editRestaurant":
                editRestaurant(request, response);
                break;
            case "updateRestaurant":
                updateRestaurant(request, response);
                break;
            case "deleteRestaurant":
                deleteRestaurant(request, response);
                break;
            case "manageMenu":
                manageMenu(request, response);
                break;
            case "addMenuItem":
                addMenuItem(request, response);
                break;
            case "updateMenuItem":
                updateMenuItem(request, response);
                break;
            case "deleteMenuItem":
                deleteMenuItem(request, response);
                break;
            case "viewOrderItems":
                viewOrderItems(request, response);
                break;
            default:
                showDashboard(request, response);
        }
    }

    private void showDashboard(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Restaurant> restaurants = restaurantDAO.getAllRestaurants();
        List<User> users = userDAO.getAllUsers();
        List<OrderTable> orders = orderDAO.getAllOrders();

        request.setAttribute("restaurants", restaurants);
        request.setAttribute("users", users);
        request.setAttribute("orders", orders);
        request.getRequestDispatcher("adminPlatform.jsp").forward(request, response);
    }

    private void addRestaurant(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Restaurant r = new Restaurant();
        r.setName(request.getParameter("name"));
        r.setCuisineType(request.getParameter("cuisineType"));
        r.setDeliveryTime(Integer.parseInt(request.getParameter("deliveryTime")));
        r.setAddress(request.getParameter("address"));
        r.setAdminUserID(Integer.parseInt(request.getParameter("adminUserID")));
        r.setRating(Double.parseDouble(request.getParameter("rating")));
        r.setIsActive(Integer.parseInt(request.getParameter("isActive")));
        r.setImageURL(request.getParameter("imageURL"));
        r.setIsVeg(Integer.parseInt(request.getParameter("isVeg")));
        r.setBadge(request.getParameter("badge"));
        r.setPriceForTwo(request.getParameter("priceForTwo"));

        restaurantDAO.insertRestaurant(r);
        response.sendRedirect("adminPlatformServlet?action=dashboard");
    }

    private void editRestaurant(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int restaurantID = Integer.parseInt(request.getParameter("restaurantID"));
        Restaurant restaurant = restaurantDAO.getRestaurantByID(restaurantID);
        if (restaurant == null) {
            response.sendRedirect("adminPlatformServlet?action=dashboard");
            return;
        }
        request.setAttribute("editRestaurant", restaurant);
        showDashboard(request, response);
    }

    private void updateRestaurant(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Restaurant r = restaurantDAO.getRestaurantByID(
            Integer.parseInt(request.getParameter("restaurantID")));
        if (r == null) {
            response.sendRedirect("adminPlatformServlet?action=dashboard");
            return;
        }
        r.setName(request.getParameter("name"));
        r.setCuisineType(request.getParameter("cuisineType"));
        r.setDeliveryTime(Integer.parseInt(request.getParameter("deliveryTime")));
        r.setAddress(request.getParameter("address"));
        r.setAdminUserID(Integer.parseInt(request.getParameter("adminUserID")));
        r.setRating(Double.parseDouble(request.getParameter("rating")));
        r.setIsActive(Integer.parseInt(request.getParameter("isActive")));
        r.setImageURL(request.getParameter("imageURL"));
        r.setIsVeg(Integer.parseInt(request.getParameter("isVeg")));
        r.setBadge(request.getParameter("badge"));
        r.setPriceForTwo(request.getParameter("priceForTwo"));

        restaurantDAO.updateRestaurant(r);
        response.sendRedirect("adminPlatformServlet?action=dashboard");
    }

    private void deleteRestaurant(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int restaurantID = Integer.parseInt(request.getParameter("restaurantID"));
        restaurantDAO.deleteRestaurant(restaurantID);
        response.sendRedirect("adminPlatformServlet?action=dashboard");
    }

    private void manageMenu(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int restaurantID = Integer.parseInt(request.getParameter("restaurantID"));
        Restaurant restaurant = restaurantDAO.getRestaurantByID(restaurantID);
        List<Menu> menuItems = menuDAO.getMenuByRestaurant(restaurantID);

        request.setAttribute("manageRestaurant", restaurant);
        request.setAttribute("manageMenuItems", menuItems);
        showDashboard(request, response);
    }

    private void addMenuItem(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int restaurantID = Integer.parseInt(request.getParameter("restaurantID"));
        Menu m = new Menu();
        m.setRestaurantID(restaurantID);
        m.setItemName(request.getParameter("itemName"));
        m.setDescription(request.getParameter("description"));
        m.setPrice(Double.parseDouble(request.getParameter("price")));
        m.setCategory(request.getParameter("category"));
        m.setImageURL(request.getParameter("imageURL"));
        m.setIsAvailable(1);

        menuDAO.insertMenu(m);
        response.sendRedirect("adminPlatformServlet?action=manageMenu&restaurantID=" + restaurantID);
    }

    private void updateMenuItem(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int menuId = Integer.parseInt(request.getParameter("menuId"));
        Menu m = menuDAO.getMenuByID(menuId);
        if (m == null) {
            response.sendRedirect("adminPlatformServlet?action=dashboard");
            return;
        }
        m.setItemName(request.getParameter("itemName"));
        m.setDescription(request.getParameter("description"));
        m.setPrice(Double.parseDouble(request.getParameter("price")));
        m.setCategory(request.getParameter("category"));
        m.setImageURL(request.getParameter("imageURL"));
        m.setIsAvailable(Integer.parseInt(request.getParameter("isAvailable")));

        menuDAO.updateMenu(m);
        response.sendRedirect("adminPlatformServlet?action=manageMenu&restaurantID=" + m.getRestaurantID());
    }

    private void deleteMenuItem(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int menuId = Integer.parseInt(request.getParameter("menuId"));
        Menu m = menuDAO.getMenuByID(menuId);
        if (m != null) {
            int restaurantID = m.getRestaurantID();
            menuDAO.softDeleteMenu(menuId);
            response.sendRedirect("adminPlatformServlet?action=manageMenu&restaurantID=" + restaurantID);
        } else {
            response.sendRedirect("adminPlatformServlet?action=dashboard");
        }
    }

    private void viewOrderItems(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int orderId = Integer.parseInt(request.getParameter("orderId"));
        OrderTable order = orderDAO.getOrderByID(orderId);
        List<OrderItem> items = orderItemDAO.getItemsByOrder(orderId);

        request.setAttribute("viewOrder", order);
        request.setAttribute("viewOrderItems", items);
        showDashboard(request, response);
    }
}
