package com.tap.utility;


import com.tap.daoimpl.*;
import com.tap.db.DBConnection;
import com.tap.model.*;

import java.util.*;

public class AppLauncher {

 static Scanner sc = new Scanner(System.in);
 static UserDAOImpl userDAO = new UserDAOImpl();
 static RestaurantDAOImpl restaurantDAO = new RestaurantDAOImpl();
 static MenuDAOImpl menuDAO = new MenuDAOImpl();
 static OrderDAOImpl orderDAO = new OrderDAOImpl();
 static OrderItemDAOImpl orderItemDAO = new OrderItemDAOImpl();

 public static void main(String[] args) {
     System.out.println("========== FOOD DELIVERY APP ==========");

     boolean running = true;
     while (running) {
         System.out.println("\n========== MAIN MENU ==========");
         System.out.println("1. User Management");
         System.out.println("2. Restaurant Management");
         System.out.println("3. Menu Management");
         System.out.println("4. Order Management");
         System.out.println("5. Order Item Management");
         System.out.println("0. Exit");
         System.out.print("Enter choice: ");
         int choice = sc.nextInt();

         switch (choice) {
             case 1: userMenu(); break;
             case 2: restaurantMenu(); break;
             case 3: menuMenu(); break;
             case 4: orderMenu(); break;
             case 5: orderItemMenu(); break;
             case 0:
                 running = false;
                 System.out.println("Goodbye!");
                 DBConnection.closeConnection();
                 break;
             default:
                 System.out.println("Invalid choice!");
         }
     }
 }

 // ─── USER MENU ─────────────────────────────────────────────
 static void userMenu() {
     System.out.println("\n--- USER MANAGEMENT ---");
     System.out.println("1. Register User");
     System.out.println("2. View User by ID");
     System.out.println("3. View User by Email");
     System.out.println("4. View All Users");
     System.out.println("5. Update User");
     System.out.println("6. Delete User");
     System.out.print("Enter choice: ");
     int ch = sc.nextInt();

     switch (ch) {
         case 1: registerUser(); break;
         case 2: viewUserByID(); break;
         case 3: viewUserByEmail(); break;
         case 4: viewAllUsers(); break;
         case 5: updateUser(); break;
         case 6: deleteUser(); break;
         default: System.out.println("Invalid choice!");
     }
 }

 static void registerUser() {
     sc.nextLine();
     User u = new User();
     System.out.print("Username: ");
     u.setUsername(sc.nextLine());
     System.out.print("Password: ");
     u.setPassword(sc.nextLine());
     System.out.print("Email: ");
     u.setEmail(sc.nextLine());
     System.out.print("Address: ");
     u.setAddress(sc.nextLine());
     System.out.print("Role (USER / RESTAURANT_ADMIN / ADMIN): ");
     u.setRole(sc.nextLine());

     boolean result = userDAO.insertUser(u);
     System.out.println(result ? "User registered successfully!" : "Registration failed!");
 }

 static void viewUserByID() {
     System.out.print("Enter User ID: ");
     int id = sc.nextInt();
     User u = userDAO.getUserByID(id);
     if (u != null) printUser(u);
     else System.out.println("User not found!");
 }

 static void viewUserByEmail() {
     sc.nextLine();
     System.out.print("Enter Email: ");
     String email = sc.nextLine();
     User u = userDAO.getUserByEmail(email);
     if (u != null) printUser(u);
     else System.out.println("User not found!");
 }

 static void viewAllUsers() {
     List<User> users = userDAO.getAllUsers();
     if (users.isEmpty()) { System.out.println("No users found!"); return; }
     System.out.println("\n--- ALL USERS ---");
     for (User u : users) printUser(u);
 }

 static void updateUser() {
     System.out.print("Enter User ID to update: ");
     int id = sc.nextInt(); sc.nextLine();
     User u = userDAO.getUserByID(id);
     if (u == null) { System.out.println("User not found!"); return; }

     System.out.print("New Username (" + u.getUsername() + "): ");
     String val = sc.nextLine();
     if (!val.isEmpty()) u.setUsername(val);

     System.out.print("New Email (" + u.getEmail() + "): ");
     val = sc.nextLine();
     if (!val.isEmpty()) u.setEmail(val);

     System.out.print("New Address (" + u.getAddress() + "): ");
     val = sc.nextLine();
     if (!val.isEmpty()) u.setAddress(val);

     System.out.print("New Role (" + u.getRole() + "): ");
     val = sc.nextLine();
     if (!val.isEmpty()) u.setRole(val);

     System.out.println(userDAO.updateUser(u) ? "User updated!" : "Update failed!");
 }

 static void deleteUser() {
     System.out.print("Enter User ID to delete: ");
     int id = sc.nextInt();
     System.out.println(userDAO.deleteUser(id) ? "User deleted!" : "Delete failed!");
 }

 static void printUser(User u) {
     System.out.println("ID: " + u.getUserID() +
         " | Name: " + u.getUsername() +
         " | Email: " + u.getEmail() +
         " | Role: " + u.getRole() +
         " | Address: " + u.getAddress());
 }

 // ─── RESTAURANT MENU ───────────────────────────────────────
 static void restaurantMenu() {
     System.out.println("\n--- RESTAURANT MANAGEMENT ---");
     System.out.println("1. Add Restaurant");
     System.out.println("2. View Restaurant by ID");
     System.out.println("3. View All Restaurants");
     System.out.println("4. View Restaurants by Admin");
     System.out.println("5. Update Restaurant");
     System.out.println("6. Delete Restaurant");
     System.out.print("Enter choice: ");
     int ch = sc.nextInt();

     switch (ch) {
         case 1: addRestaurant(); break;
         case 2: viewRestaurantByID(); break;
         case 3: viewAllRestaurants(); break;
         case 4: viewRestaurantsByAdmin(); break;
         case 5: updateRestaurant(); break;
         case 6: deleteRestaurant(); break;
         default: System.out.println("Invalid choice!");
     }
 }

 static void addRestaurant() {
     sc.nextLine();
     Restaurant r = new Restaurant();
     System.out.print("Restaurant Name: ");
     r.setName(sc.nextLine());
     System.out.print("Cuisine Type: ");
     r.setCuisineType(sc.nextLine());
     System.out.print("Delivery Time (mins): ");
     r.setDeliveryTime(sc.nextInt()); sc.nextLine();
     System.out.print("Address: ");
     r.setAddress(sc.nextLine());
     System.out.print("Admin User ID: ");
     r.setAdminUserID(sc.nextInt());
     System.out.print("Rating (e.g. 4.5): ");
     r.setRating(sc.nextDouble());
     r.setIsActive(1);

     System.out.println(restaurantDAO.insertRestaurant(r) ?
         "Restaurant added!" : "Failed to add!");
 }

 static void viewRestaurantByID() {
     System.out.print("Enter Restaurant ID: ");
     int id = sc.nextInt();
     Restaurant r = restaurantDAO.getRestaurantByID(id);
     if (r != null) printRestaurant(r);
     else System.out.println("Restaurant not found!");
 }

 static void viewAllRestaurants() {
     List<Restaurant> list = restaurantDAO.getAllRestaurants();
     if (list.isEmpty()) { System.out.println("No restaurants found!"); return; }
     System.out.println("\n--- ALL RESTAURANTS ---");
     for (Restaurant r : list) printRestaurant(r);
 }

 static void viewRestaurantsByAdmin() {
     System.out.print("Enter Admin User ID: ");
     int id = sc.nextInt();
     List<Restaurant> list = restaurantDAO.getRestaurantsByAdmin(id);
     if (list.isEmpty()) { System.out.println("No restaurants found!"); return; }
     for (Restaurant r : list) printRestaurant(r);
 }

 static void updateRestaurant() {
     System.out.print("Enter Restaurant ID to update: ");
     int id = sc.nextInt(); sc.nextLine();
     Restaurant r = restaurantDAO.getRestaurantByID(id);
     if (r == null) { System.out.println("Not found!"); return; }

     System.out.print("New Name (" + r.getName() + "): ");
     String val = sc.nextLine();
     if (!val.isEmpty()) r.setName(val);

     System.out.print("New Cuisine (" + r.getCuisineType() + "): ");
     val = sc.nextLine();
     if (!val.isEmpty()) r.setCuisineType(val);

     System.out.print("New Delivery Time (" + r.getDeliveryTime() + "): ");
     val = sc.nextLine();
     if (!val.isEmpty()) r.setDeliveryTime(Integer.parseInt(val));

     System.out.print("New Address (" + r.getAddress() + "): ");
     val = sc.nextLine();
     if (!val.isEmpty()) r.setAddress(val);

     System.out.print("New Rating (" + r.getRating() + "): ");
     val = sc.nextLine();
     if (!val.isEmpty()) r.setRating(Double.parseDouble(val));

     System.out.println(restaurantDAO.updateRestaurant(r) ?
         "Restaurant updated!" : "Update failed!");
 }

 static void deleteRestaurant() {
     System.out.print("Enter Restaurant ID to delete: ");
     int id = sc.nextInt();
     System.out.println(restaurantDAO.deleteRestaurant(id) ?
         "Restaurant deleted!" : "Delete failed!");
 }

 static void printRestaurant(Restaurant r) {
     System.out.println("ID: " + r.getRestaurantID() +
         " | Name: " + r.getName() +
         " | Cuisine: " + r.getCuisineType() +
         " | Delivery: " + r.getDeliveryTime() + " mins" +
         " | Rating: " + r.getRating() +
         " | Active: " + r.getIsActive());
 }

 // ─── MENU MENU ─────────────────────────────────────────────
 static void menuMenu() {
     System.out.println("\n--- MENU MANAGEMENT ---");
     System.out.println("1. Add Menu Item");
     System.out.println("2. View Menu Item by ID");
     System.out.println("3. View Menu by Restaurant");
     System.out.println("4. Update Menu Item");
     System.out.println("5. Soft Delete Menu Item");
     System.out.print("Enter choice: ");
     int ch = sc.nextInt();

     switch (ch) {
         case 1: addMenuItem(); break;
         case 2: viewMenuByID(); break;
         case 3: viewMenuByRestaurant(); break;
         case 4: updateMenuItem(); break;
         case 5: softDeleteMenuItem(); break;
         default: System.out.println("Invalid choice!");
     }
 }

 static void addMenuItem() {
     sc.nextLine();
     Menu m = new Menu();
     System.out.print("Restaurant ID: ");
     m.setRestaurantID(sc.nextInt()); sc.nextLine();
     System.out.print("Item Name: ");
     m.setItemName(sc.nextLine());
     System.out.print("Description: ");
     m.setDescription(sc.nextLine());
     System.out.print("Price: ");
     m.setPrice(sc.nextDouble()); sc.nextLine();
     System.out.print("Category: ");
     m.setCategory(sc.nextLine());
     m.setIsAvailable(1);

     System.out.println(menuDAO.insertMenu(m) ? "Menu item added!" : "Failed!");
 }

 static void viewMenuByID() {
     System.out.print("Enter Menu ID: ");
     int id = sc.nextInt();
     Menu m = menuDAO.getMenuByID(id);
     if (m != null) printMenu(m);
     else System.out.println("Item not found!");
 }

 static void viewMenuByRestaurant() {
     System.out.print("Enter Restaurant ID: ");
     int id = sc.nextInt();
     List<Menu> list = menuDAO.getMenuByRestaurant(id);
     if (list.isEmpty()) { System.out.println("No items found!"); return; }
     System.out.println("\n--- MENU ITEMS ---");
     for (Menu m : list) printMenu(m);
 }

 static void updateMenuItem() {
     System.out.print("Enter Menu ID to update: ");
     int id = sc.nextInt(); sc.nextLine();
     Menu m = menuDAO.getMenuByID(id);
     if (m == null) { System.out.println("Not found!"); return; }

     System.out.print("New Item Name (" + m.getItemName() + "): ");
     String val = sc.nextLine();
     if (!val.isEmpty()) m.setItemName(val);

     System.out.print("New Description (" + m.getDescription() + "): ");
     val = sc.nextLine();
     if (!val.isEmpty()) m.setDescription(val);

     System.out.print("New Price (" + m.getPrice() + "): ");
     val = sc.nextLine();
     if (!val.isEmpty()) m.setPrice(Double.parseDouble(val));

     System.out.print("New Category (" + m.getCategory() + "): ");
     val = sc.nextLine();
     if (!val.isEmpty()) m.setCategory(val);

     System.out.print("Available? (1=Yes / 0=No): ");
     val = sc.nextLine();
     if (!val.isEmpty()) m.setIsAvailable(Integer.parseInt(val));

     System.out.println(menuDAO.updateMenu(m) ? "Menu updated!" : "Update failed!");
 }

 static void softDeleteMenuItem() {
     System.out.print("Enter Menu ID to delete: ");
     int id = sc.nextInt();
     System.out.println(menuDAO.softDeleteMenu(id) ?
         "Item soft deleted!" : "Delete failed!");
 }

 static void printMenu(Menu m) {
     System.out.println("ID: " + m.getMenuID() +
         " | Item: " + m.getItemName() +
         " | Price: Rs." + m.getPrice() +
         " | Category: " + m.getCategory() +
         " | Available: " + m.getIsAvailable());
 }

 // ─── ORDER MENU ────────────────────────────────────────────
 static void orderMenu() {
     System.out.println("\n--- ORDER MANAGEMENT ---");
     System.out.println("1. Place Order");
     System.out.println("2. View Order by ID");
     System.out.println("3. View Orders by User");
     System.out.println("4. View Orders by Restaurant");
     System.out.println("5. Update Order Status");
     System.out.print("Enter choice: ");
     int ch = sc.nextInt();

     switch (ch) {
         case 1: placeOrder(); break;
         case 2: viewOrderByID(); break;
         case 3: viewOrdersByUser(); break;
         case 4: viewOrdersByRestaurant(); break;
         case 5: updateOrderStatus(); break;
         default: System.out.println("Invalid choice!");
     }
 }

 static void placeOrder() {
     sc.nextLine();
     OrderTable o = new OrderTable();
     System.out.print("User ID: ");
     o.setUserID(sc.nextInt());
     System.out.print("Restaurant ID: ");
     o.setRestaurantID(sc.nextInt());
     System.out.print("Total Amount: ");
     o.setTotalAmount(sc.nextDouble()); sc.nextLine();
     System.out.print("Payment Method (CASH / CARD / UPI / WALLET): ");
     o.setPaymentMethod(sc.nextLine());
     o.setStatus("PENDING");

     System.out.println(orderDAO.insertOrder(o) ? "Order placed!" : "Failed!");
 }

 static void viewOrderByID() {
     System.out.print("Enter Order ID: ");
     int id = sc.nextInt();
     OrderTable o = orderDAO.getOrderByID(id);
     if (o != null) printOrder(o);
     else System.out.println("Order not found!");
 }

 static void viewOrdersByUser() {
     System.out.print("Enter User ID: ");
     int id = sc.nextInt();
     List<OrderTable> list = orderDAO.getOrdersByUser(id);
     if (list.isEmpty()) { System.out.println("No orders found!"); return; }
     for (OrderTable o : list) printOrder(o);
 }

 static void viewOrdersByRestaurant() {
     System.out.print("Enter Restaurant ID: ");
     int id = sc.nextInt();
     List<OrderTable> list = orderDAO.getOrdersByRestaurant(id);
     if (list.isEmpty()) { System.out.println("No orders found!"); return; }
     for (OrderTable o : list) printOrder(o);
 }

 static void updateOrderStatus() {
     System.out.print("Enter Order ID: ");
     int id = sc.nextInt(); sc.nextLine();
     System.out.println("Status options: PENDING / CONFIRMED / PREPARING / OUT_FOR_DELIVERY / DELIVERED / CANCELLED");
     System.out.print("New Status: ");
     String status = sc.nextLine();
     System.out.println(orderDAO.updateOrderStatus(id, status) ?
         "Status updated!" : "Update failed!");
 }

 static void printOrder(OrderTable o) {
     System.out.println("OrderID: " + o.getOrderID() +
         " | UserID: " + o.getUserID() +
         " | RestaurantID: " + o.getRestaurantID() +
         " | Amount: Rs." + o.getTotalAmount() +
         " | Status: " + o.getStatus() +
         " | Payment: " + o.getPaymentMethod());
 }

 // ─── ORDER ITEM MENU ───────────────────────────────────────
 static void orderItemMenu() {
     System.out.println("\n--- ORDER ITEM MANAGEMENT ---");
     System.out.println("1. Add Item to Order");
     System.out.println("2. View Items by Order ID");
     System.out.print("Enter choice: ");
     int ch = sc.nextInt();

     switch (ch) {
         case 1: addOrderItem(); break;
         case 2: viewItemsByOrder(); break;
         default: System.out.println("Invalid choice!");
     }
 }

 static void addOrderItem() {
     OrderItem oi = new OrderItem();
     System.out.print("Order ID: ");
     oi.setOrderID(sc.nextInt());
     System.out.print("Menu ID: ");
     oi.setMenuID(sc.nextInt());
     System.out.print("Quantity: ");
     oi.setQuantity(sc.nextInt());
     System.out.print("Item Total: ");
     oi.setItemTotal(sc.nextDouble());

     System.out.println(orderItemDAO.insertOrderItem(oi) ?
         "Item added to order!" : "Failed!");
 }

 static void viewItemsByOrder() {
     System.out.print("Enter Order ID: ");
     int id = sc.nextInt();
     List<OrderItem> list = orderItemDAO.getItemsByOrder(id);
     if (list.isEmpty()) { System.out.println("No items found!"); return; }
     System.out.println("\n--- ORDER ITEMS ---");
     for (OrderItem oi : list) {
         System.out.println("ItemID: " + oi.getOrderItemID() +
             " | MenuID: " + oi.getMenuID() +
             " | Qty: " + oi.getQuantity() +
             " | Total: Rs." + oi.getItemTotal());
     }
 }
}