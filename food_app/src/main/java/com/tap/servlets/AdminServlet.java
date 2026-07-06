package com.tap.servlets;

import com.tap.daoimpl.*;
import com.tap.model.*;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/adminServlet")
public class AdminServlet extends HttpServlet {

    RestaurantDAOImpl restaurantDAO = new RestaurantDAOImpl();
    MenuDAOImpl menuDAO = new MenuDAOImpl();
    OrderDAOImpl orderDAO = new OrderDAOImpl();
    OrderItemDAOImpl orderItemDAO = new OrderItemDAOImpl();

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

        if (admin == null || !"RESTAURANT_ADMIN".equals(admin.getRole())) {
            response.sendRedirect("login.jsp");
            return;
        }

        List<Restaurant> myRestaurants = restaurantDAO.getRestaurantsByAdmin(admin.getUserID());
        request.setAttribute("myRestaurants", myRestaurants);

        String action = request.getParameter("action");
        if (action == null) action = "dashboard";

        switch (action) {
            case "manageRestaurant":
                manageRestaurant(request, response, myRestaurants);
                break;
            case "addRestaurant":
                addRestaurant(request, response, admin);
                break;
            case "editRestaurant":
                editRestaurant(request, response, myRestaurants);
                break;
            case "deleteMyRestaurant":
                deleteMyRestaurant(request, response, myRestaurants);
                break;
            case "addMenuItem":
                addMenuItem(request, response, myRestaurants);
                break;
            case "updateMenuItem":
                updateMenuItem(request, response, myRestaurants);
                break;
            case "deleteMenuItem":
                deleteMenuItem(request, response, myRestaurants);
                break;
            case "updateOrderStatus":
                updateOrderStatus(request, response, myRestaurants);
                break;
            case "updateRestaurant":
                updateRestaurantProfile(request, response, myRestaurants);
                break;
            case "viewOrderItems":
                viewOrderItems(request, response, myRestaurants);
                break;
            default:
                request.getRequestDispatcher("adminDashboard.jsp").forward(request, response);
        }
    }

    private Restaurant findRestaurant(List<Restaurant> list, int id) {
        for (Restaurant r : list) {
            if (r.getRestaurantID() == id) return r;
        }
        return null;
    }

    private void manageRestaurant(HttpServletRequest request, HttpServletResponse response,
                                  List<Restaurant> myRestaurants) throws ServletException, IOException {
        if (myRestaurants.isEmpty()) {
            request.setAttribute("error", "No restaurant assigned to this admin.");
            request.getRequestDispatcher("adminDashboard.jsp").forward(request, response);
            return;
        }
        int rid = Integer.parseInt(request.getParameter("restaurantID"));
        Restaurant r = findRestaurant(myRestaurants, rid);
        if (r == null) {
            response.sendRedirect("adminServlet?action=dashboard");
            return;
        }
        List<Menu> menuItems = menuDAO.getMenuByRestaurant(rid);
        List<OrderTable> orders = orderDAO.getOrdersByRestaurant(rid);
        request.setAttribute("manageRestaurant", r);
        request.setAttribute("menuItems", menuItems);
        request.setAttribute("orders", orders);
        request.getRequestDispatcher("adminDashboard.jsp").forward(request, response);
    }

    private void addRestaurant(HttpServletRequest request, HttpServletResponse response,
                               User admin) throws ServletException, IOException {
        Restaurant r = new Restaurant();
        r.setName(request.getParameter("name"));
        r.setCuisineType(request.getParameter("cuisineType"));
        r.setDeliveryTime(Integer.parseInt(request.getParameter("deliveryTime")));
        r.setAddress(request.getParameter("address"));
        r.setAdminUserID(admin.getUserID());
        r.setRating(Double.parseDouble(request.getParameter("rating")));
        r.setIsActive(Integer.parseInt(request.getParameter("isActive")));
        r.setImageURL(request.getParameter("imageURL"));
        r.setIsVeg(Integer.parseInt(request.getParameter("isVeg")));
        r.setBadge(request.getParameter("badge"));
        r.setPriceForTwo(request.getParameter("priceForTwo"));

        restaurantDAO.insertRestaurant(r);
        response.sendRedirect("adminServlet?action=dashboard");
    }

    private void editRestaurant(HttpServletRequest request, HttpServletResponse response,
                                List<Restaurant> myRestaurants) throws ServletException, IOException {
        int rid = Integer.parseInt(request.getParameter("restaurantID"));
        Restaurant r = findRestaurant(myRestaurants, rid);
        if (r == null) {
            response.sendRedirect("adminServlet?action=dashboard");
            return;
        }
        r.setName(request.getParameter("name"));
        r.setCuisineType(request.getParameter("cuisineType"));
        r.setDeliveryTime(Integer.parseInt(request.getParameter("deliveryTime")));
        r.setAddress(request.getParameter("address"));
        r.setRating(Double.parseDouble(request.getParameter("rating")));
        r.setIsActive(Integer.parseInt(request.getParameter("isActive")));
        r.setIsVeg(Integer.parseInt(request.getParameter("isVeg")));
        r.setImageURL(request.getParameter("imageURL"));
        r.setPriceForTwo(request.getParameter("priceForTwo"));
        r.setBadge(request.getParameter("badge"));

        restaurantDAO.updateRestaurant(r);
        response.sendRedirect("adminServlet?action=dashboard");
    }

    private void deleteMyRestaurant(HttpServletRequest request, HttpServletResponse response,
                                    List<Restaurant> myRestaurants) throws ServletException, IOException {
        int rid = Integer.parseInt(request.getParameter("restaurantID"));
        Restaurant r = findRestaurant(myRestaurants, rid);
        if (r != null) {
            restaurantDAO.deleteRestaurant(rid);
        }
        response.sendRedirect("adminServlet?action=dashboard");
    }

    private void addMenuItem(HttpServletRequest request, HttpServletResponse response,
                             List<Restaurant> myRestaurants) throws ServletException, IOException {
        int rid = Integer.parseInt(request.getParameter("restaurantID"));
        Restaurant r = findRestaurant(myRestaurants, rid);
        if (r == null) {
            response.sendRedirect("adminServlet?action=dashboard");
            return;
        }
        Menu m = new Menu();
        m.setRestaurantID(rid);
        m.setItemName(request.getParameter("itemName"));
        m.setDescription(request.getParameter("description"));
        m.setPrice(Double.parseDouble(request.getParameter("price")));
        m.setCategory(request.getParameter("category"));
        m.setImageURL(request.getParameter("imageURL"));
        m.setIsAvailable(1);

        menuDAO.insertMenu(m);
        response.sendRedirect("adminServlet?action=manageRestaurant&restaurantID=" + rid);
    }

    private void updateMenuItem(HttpServletRequest request, HttpServletResponse response,
                                List<Restaurant> myRestaurants) throws ServletException, IOException {
        int menuId = Integer.parseInt(request.getParameter("menuId"));
        Menu m = menuDAO.getMenuByID(menuId);
        if (m == null) {
            response.sendRedirect("adminServlet?action=dashboard");
            return;
        }
        Restaurant r = findRestaurant(myRestaurants, m.getRestaurantID());
        if (r == null) {
            response.sendRedirect("adminServlet?action=dashboard");
            return;
        }
        m.setItemName(request.getParameter("itemName"));
        m.setDescription(request.getParameter("description"));
        m.setPrice(Double.parseDouble(request.getParameter("price")));
        m.setCategory(request.getParameter("category"));
        m.setImageURL(request.getParameter("imageURL"));
        m.setIsAvailable(Integer.parseInt(request.getParameter("isAvailable")));

        menuDAO.updateMenu(m);
        response.sendRedirect("adminServlet?action=manageRestaurant&restaurantID=" + m.getRestaurantID());
    }

    private void deleteMenuItem(HttpServletRequest request, HttpServletResponse response,
                                List<Restaurant> myRestaurants) throws ServletException, IOException {
        int menuId = Integer.parseInt(request.getParameter("menuId"));
        Menu m = menuDAO.getMenuByID(menuId);
        if (m != null) {
            Restaurant r = findRestaurant(myRestaurants, m.getRestaurantID());
            if (r != null) {
                int rid = m.getRestaurantID();
                menuDAO.softDeleteMenu(menuId);
                response.sendRedirect("adminServlet?action=manageRestaurant&restaurantID=" + rid);
                return;
            }
        }
        response.sendRedirect("adminServlet?action=dashboard");
    }

    private void updateOrderStatus(HttpServletRequest request, HttpServletResponse response,
                                   List<Restaurant> myRestaurants) throws ServletException, IOException {
        int orderId = Integer.parseInt(request.getParameter("orderId"));
        OrderTable order = orderDAO.getOrderByID(orderId);
        if (order == null) {
            response.sendRedirect("adminServlet?action=dashboard");
            return;
        }
        Restaurant r = findRestaurant(myRestaurants, order.getRestaurantID());
        if (r == null) {
            response.sendRedirect("adminServlet?action=dashboard");
            return;
        }
        String status = request.getParameter("status");
        orderDAO.updateOrderStatus(orderId, status);
        response.sendRedirect("adminServlet?action=manageRestaurant&restaurantID=" + order.getRestaurantID());
    }

    private void viewOrderItems(HttpServletRequest request, HttpServletResponse response,
                                List<Restaurant> myRestaurants) throws ServletException, IOException {
        int orderId = Integer.parseInt(request.getParameter("orderId"));
        OrderTable order = orderDAO.getOrderByID(orderId);
        if (order == null) {
            response.sendRedirect("adminServlet?action=dashboard");
            return;
        }
        Restaurant r = findRestaurant(myRestaurants, order.getRestaurantID());
        if (r == null) {
            response.sendRedirect("adminServlet?action=dashboard");
            return;
        }
        List<OrderItem> items = orderItemDAO.getItemsByOrder(orderId);
        request.setAttribute("order", order);
        request.setAttribute("orderItems", items);
        request.setAttribute("manageRestaurant", r);
        request.setAttribute("menuItems", menuDAO.getMenuByRestaurant(r.getRestaurantID()));
        request.setAttribute("orders", orderDAO.getOrdersByRestaurant(r.getRestaurantID()));
        request.getRequestDispatcher("adminDashboard.jsp").forward(request, response);
    }

    private void updateRestaurantProfile(HttpServletRequest request, HttpServletResponse response,
                                         List<Restaurant> myRestaurants) throws ServletException, IOException {
        int rid = Integer.parseInt(request.getParameter("restaurantID"));
        Restaurant r = findRestaurant(myRestaurants, rid);
        if (r == null) {
            response.sendRedirect("adminServlet?action=dashboard");
            return;
        }
        r.setName(request.getParameter("name"));
        r.setCuisineType(request.getParameter("cuisineType"));
        r.setDeliveryTime(Integer.parseInt(request.getParameter("deliveryTime")));
        r.setAddress(request.getParameter("address"));
        r.setIsActive(Integer.parseInt(request.getParameter("isActive")));

        restaurantDAO.updateRestaurant(r);
        response.sendRedirect("adminServlet?action=manageRestaurant&restaurantID=" + rid);
    }
}
