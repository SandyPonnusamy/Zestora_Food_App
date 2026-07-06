package com.tap.servlets;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import com.tap.daoimpl.MenuDAOImpl;
import com.tap.daoimpl.RestaurantDAOImpl;
import com.tap.model.Cart;
import com.tap.model.CartItem;
import com.tap.model.Menu;
import com.tap.model.OrderItem;
import com.tap.model.Restaurant;
import com.tap.model.User;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/cartServlet")
public class CartServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        HttpSession session = req.getSession();
        Cart cart = (Cart) session.getAttribute("cart");
        String action = req.getParameter("action");

        // Require login for first-time add-to-cart. If the user is not
        // logged in, save the return URL (with anchor for scroll position)
        // and redirect to login. After successful login, LoginServlet
        // reads loginReturnUrl from session and redirects back here.
        if ("add".equals(action)) {
            User user = (User) session.getAttribute("user");
            if (user == null) {
                int returnMenuId = Integer.parseInt(req.getParameter("menuId"));
                int returnRestaurantId = Integer.parseInt(req.getParameter("restaurantId"));
                String returnUrl = "menu?restaurantID=" + returnRestaurantId + "#item-" + returnMenuId;
                session.setAttribute("loginReturnUrl", returnUrl);
                resp.sendRedirect("login.jsp");
                return;
            }
            Integer restaurantIdObj = (Integer) session.getAttribute("restaurantId");
            int restaurantId = (restaurantIdObj != null) ? restaurantIdObj : -1;
            int newRestaurantId = Integer.parseInt(req.getParameter("restaurantId"));

            if (cart == null || restaurantId != newRestaurantId) {
                cart = new Cart();
                session.setAttribute("cart", cart);
                session.setAttribute("restaurantId", newRestaurantId);
            }

            int menuId = addItemToCart(req, cart);

            // Redirect back to the SAME menu page (not the cart) so multiple
            // items can be added one after another. A plain HTML form always
            // triggers a full page reload on submit — that part can't be
            // avoided without JavaScript — but adding the #item-<id> anchor
            // makes the browser scroll straight back to the item you just
            // clicked instead of jumping to the top of the page.
            resp.sendRedirect("menu?restaurantID=" + newRestaurantId + "#item-" + menuId);
            return;
        }

        if (cart == null) {
            // Nothing to increase/decrease/remove — just show the (empty) cart.
            showCart(req, resp, cart);
            return;
        }

        int menuId = Integer.parseInt(req.getParameter("menuId"));

        if ("increase".equals(action)) {
            increaseQuantity(req, cart);
        } else if ("decrease".equals(action)) {
            decreaseQuantity(req, cart);
        } else if ("remove".equals(action)) {
            deleteItemFromCart(req, cart);
        }

        // Same idea as the "add" redirect above: a plain form POST always
        // reloads the page — that part is unavoidable without JS — but
        // redirecting to cartServlet#item-<menuId> (a GET, handled by doGet
        // below) makes the browser scroll straight back to the row you just
        // clicked +/- on, instead of resetting to the top of the cart.
        // If the item was just removed, the anchor simply won't match
        // anything and the browser falls back to the top — which is fine.
        resp.sendRedirect("cartServlet#item-" + menuId);
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // Allows visiting /cartServlet directly (e.g. a "View Cart" link) and
        // still seeing whatever is currently in the session cart.
        HttpSession session = req.getSession();
        Cart cart = (Cart) session.getAttribute("cart");
        showCart(req, resp, cart);
    }

    /**
     * Converts the session Cart (Map<menuId, CartItem>) into the
     * cartItems/cartMenus/restaurant/totals attributes that cart.jsp expects,
     * then forwards to it.
     */
    private void showCart(HttpServletRequest req, HttpServletResponse resp, Cart cart)
            throws ServletException, IOException {

        List<OrderItem> cartItems = new ArrayList<>();
        List<Menu> cartMenus = new ArrayList<>();
        Restaurant restaurant = null;
        double itemTotal = 0;

        if (cart != null && !cart.isEmpty()) {
            for (CartItem ci : cart.getItems().values()) {
                double lineTotal = ci.getPrice() * ci.getQuantity();
                itemTotal += lineTotal;

                // orderID isn't relevant before checkout; menuId doubles as a
                // stand-in orderItemID so the qty +/- and remove forms still work.
                OrderItem oi = new OrderItem(ci.getMenuId(), 0, ci.getMenuId(), ci.getQuantity(), lineTotal);
                cartItems.add(oi);

                Menu m = new Menu();
                m.setMenuID(ci.getMenuId());
                m.setRestaurantID(ci.getRestaurantId());
                m.setItemName(ci.getName());
                m.setPrice(ci.getPrice());
                m.setCategory("");
                cartMenus.add(m);
            }

            Integer restaurantId = (Integer) req.getSession().getAttribute("restaurantId");
            if (restaurantId != null) {
                restaurant = new RestaurantDAOImpl().getRestaurantByID(restaurantId);
            }
        }

        double deliveryFee = (itemTotal > 0) ? 30.0 : 0.0;
        double packagingFee = (itemTotal > 0) ? 10.0 : 0.0;
        double discount = 0.0;
        double taxes = Math.round(itemTotal * 0.05 * 100) / 100.0;
        double grandTotal = itemTotal + deliveryFee + packagingFee + taxes - discount;

        req.setAttribute("cartItems", cartItems);
        req.setAttribute("cartMenus", cartMenus);
        req.setAttribute("restaurant", restaurant);
        req.setAttribute("itemTotal", itemTotal);
        req.setAttribute("deliveryFee", deliveryFee);
        req.setAttribute("packagingFee", packagingFee);
        req.setAttribute("discount", discount);
        req.setAttribute("taxes", taxes);
        req.setAttribute("grandTotal", grandTotal);

        RequestDispatcher dispatcher = req.getRequestDispatcher("cart.jsp");
        dispatcher.forward(req, resp);
    }

    private int addItemToCart(HttpServletRequest req, Cart cart) {

        int menuId = Integer.parseInt(req.getParameter("menuId"));
        int quantity = Integer.parseInt(req.getParameter("quantity"));

        MenuDAOImpl menuDAOImpl = new MenuDAOImpl();
        Menu menu = menuDAOImpl.getMenuByID(menuId);

        CartItem cartItem = new CartItem(
                menu.getMenuID(),
                menu.getRestaurantID(),
                menu.getItemName(),
                menu.getPrice(),
                quantity
        );

        // FIX 5: this was calling the STATIC-looking "Cart.addItem(...)" on the class,
        // not on the actual cart instance — should be cart.addItem(...)
        cart.addItem(cartItem);

        return menuId;
    }

    private void increaseQuantity(HttpServletRequest req, Cart cart) {
        int menuId = Integer.parseInt(req.getParameter("menuId"));
        CartItem item = cart.getItems().get(menuId);
        if (item != null) {
            cart.updateQuantity(menuId, item.getQuantity() + 1);
        }
    }

    private void decreaseQuantity(HttpServletRequest req, Cart cart) {
        int menuId = Integer.parseInt(req.getParameter("menuId"));
        CartItem item = cart.getItems().get(menuId);
        if (item != null) {
            // Minimum quantity is 1 — decreasing never removes the item.
            // Use the dedicated "Remove" button to delete it instead.
            int newQuantity = Math.max(1, item.getQuantity() - 1);
            cart.updateQuantity(menuId, newQuantity);
        }
    }

    private void deleteItemFromCart(HttpServletRequest req, Cart cart) {
        int menuId = Integer.parseInt(req.getParameter("menuId"));
        cart.removeItem(menuId);
    }

}