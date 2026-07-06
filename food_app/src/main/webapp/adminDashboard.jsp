<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, java.util.ArrayList, com.tap.model.*, com.tap.daoimpl.OrderDAOImpl" %>
<%
  User admin = (User) session.getAttribute("user");
  if (admin == null || !"RESTAURANT_ADMIN".equals(admin.getRole())) {
    response.sendRedirect("login.jsp");
    return;
  }
  List<Restaurant> myRestaurants = (List<Restaurant>) request.getAttribute("myRestaurants");
  Restaurant manageRestaurant = (Restaurant) request.getAttribute("manageRestaurant");
  List<Menu> menuItems = (List<Menu>) request.getAttribute("menuItems");
  List<OrderTable> orders = (List<OrderTable>) request.getAttribute("orders");
  String errorMsg = (String) request.getAttribute("error");

  OrderTable viewOrder = (OrderTable) request.getAttribute("order");
  List<OrderItem> viewOrderItems = (List<OrderItem>) request.getAttribute("orderItems");

  int totalMenuItems = menuItems != null ? menuItems.size() : 0;
  int totalOrders = orders != null ? orders.size() : 0;
  int pendingOrders = 0;
  double totalRevenue = 0;
  if (orders != null) {
    for (OrderTable o : orders) {
      if ("PENDING".equals(o.getStatus()) || "CONFIRMED".equals(o.getStatus()) || "PREPARING".equals(o.getStatus())) {
        pendingOrders++;
      }
      if ("DELIVERED".equals(o.getStatus())) {
        totalRevenue += o.getTotalAmount();
      }
    }
  }
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Zestora — Admin Dashboard</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link href="https://fonts.googleapis.com/css2?family=Archivo+Black&family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
<style>
  :root{
    --ink:#2B1B17;
    --paper:#FFF7EC;
    --card:#FFFFFF;
    --chili:#FF4D3D;
    --chili-dark:#E0331F;
    --gold:#FFB627;
    --teal:#1B998B;
    --line: rgba(43,27,23,0.10);
    --muted: rgba(43,27,23,0.6);
    --shadow: 0 14px 30px rgba(43,27,23,0.10);
  }

  *{ box-sizing:border-box; }
  body{
    margin:0;
    background: var(--paper);
    color: var(--ink);
    font-family:'Inter', sans-serif;
    -webkit-font-smoothing: antialiased;
  }
  a{ color:inherit; text-decoration:none; }
  img{ max-width:100%; display:block; }
  ul{ margin:0; padding:0; list-style:none; }

  .navbar{
    position: sticky;
    top:0;
    z-index: 100;
    display:flex;
    align-items:center;
    justify-content: space-between;
    padding: 16px 40px;
    background: var(--ink);
    color: var(--paper);
  }
  .logo{ font-family:'Archivo Black', sans-serif; font-size: 1.55rem; }
  .logo .dot{ color: var(--gold); }
  .admin-tag{
    background: rgba(255,182,39,0.18);
    color: var(--gold);
    font-size: 0.72rem;
    font-weight:800;
    text-transform:uppercase;
    letter-spacing:0.04em;
    padding: 4px 10px;
    border-radius: 6px;
    margin-left: 10px;
  }
  .logout-link{
    display:flex;
    align-items:center;
    gap:8px;
    font-weight:600;
    font-size: 0.9rem;
    background: rgba(255,255,255,0.1);
    padding: 9px 16px;
    border-radius: 999px;
  }
  .logout-link:hover{ background: rgba(255,255,255,0.18); }

  .page-header{
    max-width: 1200px;
    margin: 0 auto;
    padding: 30px 40px 0;
  }
  .page-header h1{
    font-family:'Archivo Black', sans-serif;
    font-size: clamp(1.5rem, 3vw, 1.9rem);
    margin: 0 0 4px;
  }
  .page-header p{ font-size: 0.9rem; color: var(--muted); margin:0; }

  .stats-row{
    max-width: 1200px;
    margin: 22px auto 0;
    padding: 0 40px;
    display:grid;
    grid-template-columns: repeat(4, 1fr);
    gap: 16px;
  }
  .stat-card{
    background: var(--card);
    border: 1px solid var(--line);
    border-radius: 14px;
    padding: 16px 18px;
    box-shadow: var(--shadow);
  }
  .stat-card .label{
    font-size: 0.74rem;
    color: var(--muted);
    text-transform:uppercase;
    letter-spacing:0.04em;
    font-weight:700;
    margin-bottom:6px;
  }
  .stat-card .value{
    font-family:'Archivo Black', sans-serif;
    font-size: 1.5rem;
  }
  .stat-card.chili .value{ color: var(--chili); }
  .stat-card.teal .value{ color: var(--teal); }
  .stat-card.gold .value{ color: var(--gold); }

  .tabs-bar{
    max-width: 1200px;
    margin: 26px auto 0;
    padding: 0 40px;
    display:flex;
    gap: 10px;
    border-bottom: 1px solid var(--line);
  }
  .tab-link{
    padding: 12px 18px;
    font-weight:700;
    font-size: 0.9rem;
    color: var(--muted);
    border-bottom: 3px solid transparent;
    margin-bottom: -1px;
  }

  main{
    max-width: 1200px;
    margin: 0 auto;
    padding: 28px 40px 90px;
    position:relative;
  }

  .tab-panel{ display:none; }
  .tab-panel:target{ display:block; }

  #tab-menu{ display:block; }
  #tab-orders:target, #tab-profile:target{ display:block; }
  #tab-orders:target ~ #tab-menu,
  #tab-profile:target ~ #tab-menu{ display:none; }
  #tab-profile:target ~ #tab-orders{ display:none; }
  #tab-orders:target ~ #tab-profile{ display:none; }

  .section-title{
    font-family:'Archivo Black', sans-serif;
    font-size: 1.1rem;
    margin: 0 0 16px;
    display:flex;
    align-items:center;
    justify-content: space-between;
  }

  .btn{
    display:inline-block;
    border:none;
    font-weight:700;
    font-size: 0.84rem;
    padding: 9px 18px;
    border-radius: 999px;
    cursor:pointer;
    font-family:'Inter', sans-serif;
  }
  .btn-primary{ background: var(--chili); color:#fff; }
  .btn-primary:hover{ background: var(--chili-dark); }
  .btn-secondary{ background: var(--line); color: var(--ink); }
  .btn-secondary:hover{ background: rgba(43,27,23,0.18); }
  .btn-sm{ padding: 6px 13px; font-size: 0.76rem; }

  .data-table{
    width:100%;
    background: var(--card);
    border: 1px solid var(--line);
    border-radius: 14px;
    overflow:hidden;
    box-shadow: var(--shadow);
    border-collapse: collapse;
  }
  .data-table th{
    text-align:left;
    font-size: 0.74rem;
    text-transform:uppercase;
    letter-spacing:0.03em;
    color: var(--muted);
    padding: 12px 16px;
    background: rgba(43,27,23,0.03);
    border-bottom: 1px solid var(--line);
  }
  .data-table td{
    padding: 12px 16px;
    font-size: 0.88rem;
    border-bottom: 1px dashed var(--line);
    vertical-align:middle;
  }
  .data-table tr:last-child td{ border-bottom:none; }
  .data-table img.thumb{
    width: 44px; height:44px;
    border-radius: 8px;
    object-fit:cover;
  }
  .status-pill{
    display:inline-block;
    font-size: 0.72rem;
    font-weight:800;
    text-transform:uppercase;
    padding: 3px 10px;
    border-radius: 999px;
  }
  .status-pill.active{ background: rgba(27,153,139,0.15); color: var(--teal); }
  .status-pill.inactive{ background: rgba(255,77,61,0.12); color: var(--chili); }
  .status-pill.available{ background: rgba(27,153,139,0.15); color: var(--teal); }
  .status-pill.unavailable{ background: rgba(255,77,61,0.12); color: var(--chili); }

  .order-status{
    font-size: 0.72rem;
    font-weight:800;
    text-transform:uppercase;
    padding: 4px 10px;
    border-radius: 999px;
  }
  .order-status.PENDING{ background: rgba(255,182,39,0.2); color:#a87100; }
  .order-status.CONFIRMED{ background: rgba(27,153,139,0.15); color: var(--teal); }
  .order-status.PREPARING{ background: rgba(255,77,61,0.12); color: var(--chili-dark); }
  .order-status.OUT_FOR_DELIVERY{ background: rgba(43,27,23,0.1); color: var(--ink); }
  .order-status.DELIVERED{ background: rgba(27,153,139,0.25); color: var(--teal); }
  .order-status.CANCELLED{ background: rgba(255,77,61,0.2); color: var(--chili-dark); }

  .status-form select{
    font-family:'Inter', sans-serif;
    font-size: 0.8rem;
    padding: 6px 10px;
    border-radius: 8px;
    border: 1.5px solid var(--line);
    background: var(--paper);
    color: var(--ink);
  }
  .status-form{ display:flex; gap:8px; }

  .row-actions{ display:flex; gap:8px; }
  .icon-btn{
    border:none;
    background: var(--line);
    color: var(--ink);
    width: 32px; height:32px;
    border-radius: 8px;
    cursor:pointer;
    display:inline-flex;
    align-items:center;
    justify-content:center;
    font-size:0.8rem;
    font-weight:700;
    text-decoration:none;
  }
  .icon-btn.danger:hover{ background: var(--chili); color:#fff; }
  .icon-btn.edit:hover{ background: var(--teal); color:#fff; }

  .badge-pill{
    display:inline-block;
    font-size: 0.68rem;
    font-weight:700;
    padding: 2px 8px;
    border-radius: 4px;
  }
  .badge-pill.bestseller{ background:rgba(255,182,39,0.2); color:#a87100; }

  .modal-overlay{
    display:none;
    position:fixed;
    inset:0;
    background: rgba(43,27,23,0.55);
    align-items:center;
    justify-content:center;
    z-index:999;
    padding: 16px;
  }
  .modal-overlay:target{ display:flex; }
  .modal-box{
    background: var(--paper);
    border-radius:16px;
    padding:28px;
    max-width:520px;
    width:100%;
    box-shadow: 0 16px 50px rgba(0,0,0,0.35);
    max-height: 90vh;
    overflow-y:auto;
  }
  .modal-box h3{
    margin:0 0 18px;
    font-family:'Archivo Black', sans-serif;
    font-size:1.15rem;
  }
  .form-group{ margin-bottom: 14px; }
  .form-group label{
    display:block;
    font-size: 0.76rem;
    font-weight:700;
    color: var(--muted);
    text-transform:uppercase;
    letter-spacing:0.03em;
    margin-bottom: 6px;
  }
  .form-group input, .form-group select, .form-group textarea{
    width:100%;
    border: 1.5px solid var(--line);
    border-radius: 10px;
    padding: 10px 12px;
    font-family:'Inter', sans-serif;
    font-size: 0.88rem;
    color: var(--ink);
    background: var(--card);
  }
  .form-group input:focus, .form-group select:focus, .form-group textarea:focus{
    border-color: var(--chili);
    outline:none;
  }
  .form-row{ display:grid; grid-template-columns: 1fr 1fr; gap: 12px; }
  .form-row-3{ display:grid; grid-template-columns: 1fr 1fr 1fr; gap: 12px; }
  .modal-actions{
    display:flex;
    gap:10px;
    justify-content:flex-end;
    margin-top: 18px;
  }

  .empty-state{
    text-align:center;
    padding: 50px 20px;
    color: var(--muted);
    font-size: 0.9rem;
    background: var(--card);
    border-radius: 14px;
    border: 1px solid var(--line);
  }

  .restaurant-grid{
    display:grid;
    grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
    gap: 16px;
  }
  .restaurant-card{
    background: var(--card);
    border: 1px solid var(--line);
    border-radius: 14px;
    overflow:hidden;
    box-shadow: var(--shadow);
    transition: transform 0.15s;
  }
  .restaurant-card:hover{ transform: translateY(-3px); }
  .restaurant-card .card-img{
    height: 140px;
    background: var(--line);
    overflow:hidden;
  }
  .restaurant-card .card-img img{
    width:100%; height:100%;
    object-fit:cover;
  }
  .restaurant-card .card-body{
    padding: 16px;
  }
  .restaurant-card .card-body h3{
    font-family:'Archivo Black', sans-serif;
    font-size:1rem;
    margin:0 0 4px;
  }
  .restaurant-card .card-body p{
    font-size:0.84rem;
    color:var(--muted);
    margin:0 0 12px;
  }
  .restaurant-card .card-footer{
    display:flex;
    justify-content:space-between;
    align-items:center;
  }

  .back-link{
    display:inline-flex;
    align-items:center;
    gap:6px;
    font-weight:600;
    font-size:0.88rem;
    color:var(--muted);
    margin-bottom:16px;
  }
  .back-link:hover{ color:var(--ink); }

  @media (max-width: 900px){
    .stats-row{ grid-template-columns: repeat(2, 1fr); }
    .form-row, .form-row-3{ grid-template-columns: 1fr; }
  }
  @media (max-width: 700px){
    .navbar{ padding: 14px 20px; }
    .page-header, .stats-row, .tabs-bar, main{ padding-left:20px; padding-right:20px; }
    .data-table{ display:block; overflow-x:auto; }
  }
</style>
</head>
<body>

<nav class="navbar">
  <a href="adminServlet?action=dashboard" class="logo">Zest<span class="dot">ora</span><span class="admin-tag">Admin</span></a>
  <a href="logoutServlet" class="logout-link">Logout</a>
</nav>

<% if (manageRestaurant != null) { %>
  <%-- ============ MANAGING A SPECIFIC RESTAURANT ============ --%>
<div class="page-header">
  <a href="adminServlet?action=dashboard" class="back-link">&larr; My Restaurants</a>
  <h1><%= manageRestaurant.getName() %></h1>
  <p><%= manageRestaurant.getCuisineType() %> &middot; <%= manageRestaurant.getDeliveryTime() %> min &middot; <%= manageRestaurant.getIsActive()==1 ? "Active" : "Inactive" %></p>
</div>

<div class="stats-row">
  <div class="stat-card">
    <div class="label">Menu items</div>
    <div class="value"><%= totalMenuItems %></div>
  </div>
  <div class="stat-card chili">
    <div class="label">Total orders</div>
    <div class="value"><%= totalOrders %></div>
  </div>
  <div class="stat-card gold">
    <div class="label">Active orders</div>
    <div class="value"><%= pendingOrders %></div>
  </div>
  <div class="stat-card teal">
    <div class="label">Revenue (delivered)</div>
    <div class="value">₹<%= String.format("%.0f", totalRevenue) %></div>
  </div>
</div>

<div class="tabs-bar">
  <a href="#tab-menu" class="tab-link">Menu</a>
  <a href="#tab-orders" class="tab-link">Orders</a>
  <a href="#tab-profile" class="tab-link">Restaurant Profile</a>
</div>

<main>

  <%-- VIEW ORDER ITEMS OVERLAY --%>
  <% if (viewOrder != null) { %>
  <div class="card" style="margin-bottom:24px;">
    <a href="adminServlet?action=manageRestaurant&restaurantID=<%= manageRestaurant.getRestaurantID() %>#tab-orders" class="back-link">&larr; Back to orders</a>
    <h2>Order #<%= viewOrder.getOrderID() %> — Items</h2>
    <p style="font-size:0.88rem;color:var(--muted);margin:0 0 14px;">
      Amount: ₹<%= String.format("%.0f", viewOrder.getTotalAmount()) %> &middot;
      Status: <%= viewOrder.getStatus() %> &middot;
      Payment: <%= viewOrder.getPaymentMethod() %>
    </p>
    <% if (viewOrderItems == null || viewOrderItems.isEmpty()) { %>
      <div class="empty-state">No items found for this order.</div>
    <% } else { %>
    <table class="data-table">
      <thead>
        <tr><th>Item ID</th><th>Menu ID</th><th>Qty</th><th>Total</th></tr>
      </thead>
      <tbody>
      <% for (OrderItem oi : viewOrderItems) { %>
        <tr>
          <td><%= oi.getOrderItemID() %></td>
          <td><%= oi.getMenuID() %></td>
          <td><%= oi.getQuantity() %></td>
          <td>₹<%= String.format("%.0f", oi.getItemTotal()) %></td>
        </tr>
      <% } %>
      </tbody>
    </table>
    <% } %>
  </div>
  <% } %>

  <!-- ============ MENU TAB ============ -->
  <div class="tab-panel" id="tab-menu">
    <div class="section-title">
      Menu items
      <a href="#add-item-modal" class="btn btn-primary">+ Add dish</a>
    </div>

    <% if (menuItems == null || menuItems.isEmpty()) { %>
      <div class="empty-state">No menu items yet. Add your first dish to get started.</div>
    <% } else { %>
    <table class="data-table">
      <thead>
        <tr>
          <th></th>
          <th>Item</th>
          <th>Category</th>
          <th>Price</th>
          <th>Status</th>
          <th>Actions</th>
        </tr>
      </thead>
      <tbody>
      <% for (Menu m : menuItems) { %>
        <tr>
          <td><img class="thumb" src="<%= (m.getImageURL()!=null && !m.getImageURL().isEmpty()) ? m.getImageURL() : "https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?w=100&h=100&fit=crop" %>" alt="<%= m.getItemName() %>"></td>
          <td><strong><%= m.getItemName() %></strong><br><span style="font-size:0.78rem;color:var(--muted);"><%= m.getDescription() != null ? m.getDescription() : "" %></span></td>
          <td><%= m.getCategory() %></td>
          <td>₹<%= m.getPrice() %></td>
          <td>
            <span class="status-pill <%= m.getIsAvailable()==1 ? "available" : "unavailable" %>">
              <%= m.getIsAvailable()==1 ? "Available" : "Sold out" %>
            </span>
          </td>
          <td>
            <div class="row-actions">
              <a href="#edit-item-modal-<%= m.getMenuID() %>" class="icon-btn edit" title="Edit">E</a>
              <form action="adminServlet" method="post">
                <input type="hidden" name="action" value="deleteMenuItem">
                <input type="hidden" name="menuId" value="<%= m.getMenuID() %>">
                <button type="submit" class="icon-btn danger" title="Delete">X</button>
              </form>
            </div>
          </td>
        </tr>
      <% } %>
      </tbody>
    </table>
    <% } %>
  </div>

  <!-- ============ ORDERS TAB ============ -->
  <div class="tab-panel" id="tab-orders">
    <div class="section-title">Orders</div>

    <% if (orders == null || orders.isEmpty()) { %>
      <div class="empty-state">No orders yet for this restaurant.</div>
    <% } else { %>
    <table class="data-table">
      <thead>
        <tr>
          <th>Order ID</th>
          <th>Date</th>
          <th>Amount</th>
          <th>Payment</th>
          <th>Status</th>
          <th>Update status</th>
          <th></th>
        </tr>
      </thead>
      <tbody>
      <% for (OrderTable o : orders) { %>
        <tr>
          <td>#<%= o.getOrderID() %></td>
          <td><%= o.getOrderDate() %></td>
          <td>₹<%= o.getTotalAmount() %></td>
          <td><%= o.getPaymentMethod() %></td>
          <td><span class="order-status <%= o.getStatus() %>"><%= o.getStatus() %></span></td>
          <td>
            <form action="adminServlet" method="post" class="status-form">
              <input type="hidden" name="action" value="updateOrderStatus">
              <input type="hidden" name="orderId" value="<%= o.getOrderID() %>">
              <select name="status">
                <option value="PENDING" <%= "PENDING".equals(o.getStatus())?"selected":"" %>>Pending</option>
                <option value="CONFIRMED" <%= "CONFIRMED".equals(o.getStatus())?"selected":"" %>>Confirmed</option>
                <option value="PREPARING" <%= "PREPARING".equals(o.getStatus())?"selected":"" %>>Preparing</option>
                <option value="OUT_FOR_DELIVERY" <%= "OUT_FOR_DELIVERY".equals(o.getStatus())?"selected":"" %>>Out for delivery</option>
                <option value="DELIVERED" <%= "DELIVERED".equals(o.getStatus())?"selected":"" %>>Delivered</option>
                <option value="CANCELLED" <%= "CANCELLED".equals(o.getStatus())?"selected":"" %>>Cancelled</option>
              </select>
              <button type="submit" class="btn btn-secondary btn-sm">Update</button>
            </form>
          </td>
          <td>
            <a href="adminServlet?action=viewOrderItems&orderId=<%= o.getOrderID() %>" class="btn btn-secondary btn-sm">View items</a>
          </td>
        </tr>
      <% } %>
      </tbody>
    </table>
    <% } %>
  </div>

  <!-- ============ RESTAURANT PROFILE TAB ============ -->
  <div class="tab-panel" id="tab-profile">
    <div class="section-title">Restaurant profile</div>

    <form action="adminServlet" method="post" style="max-width:520px; background:var(--card); border:1px solid var(--line); border-radius:14px; padding:24px; box-shadow:var(--shadow);">
      <input type="hidden" name="action" value="updateRestaurant">
      <input type="hidden" name="restaurantID" value="<%= manageRestaurant.getRestaurantID() %>">

      <div class="form-group">
        <label>Restaurant name</label>
        <input type="text" name="name" value="<%= manageRestaurant.getName() %>" required>
      </div>

      <div class="form-row">
        <div class="form-group">
          <label>Cuisine type</label>
          <input type="text" name="cuisineType" value="<%= manageRestaurant.getCuisineType() %>" required>
        </div>
        <div class="form-group">
          <label>Delivery time (mins)</label>
          <input type="number" name="deliveryTime" value="<%= manageRestaurant.getDeliveryTime() %>" required>
        </div>
      </div>

      <div class="form-group">
        <label>Address</label>
        <textarea name="address" rows="2" required><%= manageRestaurant.getAddress() %></textarea>
      </div>

      <div class="form-group">
        <label>Status</label>
        <select name="isActive">
          <option value="1" <%= manageRestaurant.getIsActive()==1 ? "selected" : "" %>>Active (visible to customers)</option>
          <option value="0" <%= manageRestaurant.getIsActive()==0 ? "selected" : "" %>>Inactive (hidden)</option>
        </select>
      </div>

      <button type="submit" class="btn btn-primary">Save changes</button>
    </form>
  </div>

</main>

  <%-- ADD MENU ITEM MODAL --%>
  <div class="modal-overlay" id="add-item-modal">
    <div class="modal-box">
      <h3>Add dish</h3>
      <form action="adminServlet" method="post">
        <input type="hidden" name="action" value="addMenuItem">
        <input type="hidden" name="restaurantID" value="<%= manageRestaurant.getRestaurantID() %>">
        <div class="form-group">
          <label>Dish name</label>
          <input type="text" name="itemName" required>
        </div>
        <div class="form-group">
          <label>Description</label>
          <textarea name="description" rows="2"></textarea>
        </div>
        <div class="form-row">
          <div class="form-group">
            <label>Price (₹)</label>
            <input type="number" step="0.01" name="price" required>
          </div>
          <div class="form-group">
            <label>Category</label>
            <input type="text" name="category" placeholder="e.g. Main Course" required>
          </div>
        </div>
        <div class="form-group">
          <label>Image URL</label>
          <input type="text" name="imageURL" placeholder="https://...">
        </div>
        <div class="modal-actions">
          <a href="#close" class="btn btn-secondary">Cancel</a>
          <button type="submit" class="btn btn-primary">Add dish</button>
        </div>
      </form>
    </div>
  </div>

  <%-- EDIT MENU ITEM MODALS --%>
  <% if (menuItems != null) { for (Menu m : menuItems) { %>
  <div class="modal-overlay" id="edit-item-modal-<%= m.getMenuID() %>">
    <div class="modal-box">
      <h3>Edit <%= m.getItemName() %></h3>
      <form action="adminServlet" method="post">
        <input type="hidden" name="action" value="updateMenuItem">
        <input type="hidden" name="menuId" value="<%= m.getMenuID() %>">
        <div class="form-group">
          <label>Dish name</label>
          <input type="text" name="itemName" value="<%= m.getItemName() %>" required>
        </div>
        <div class="form-group">
          <label>Description</label>
          <textarea name="description" rows="2"><%= m.getDescription() %></textarea>
        </div>
        <div class="form-row">
          <div class="form-group">
            <label>Price (₹)</label>
            <input type="number" step="0.01" name="price" value="<%= m.getPrice() %>" required>
          </div>
          <div class="form-group">
            <label>Category</label>
            <input type="text" name="category" value="<%= m.getCategory() %>" required>
          </div>
        </div>
        <div class="form-group">
          <label>Image URL</label>
          <input type="text" name="imageURL" value="<%= m.getImageURL()!=null?m.getImageURL():"" %>">
        </div>
        <div class="form-group">
          <label>Availability</label>
          <select name="isAvailable">
            <option value="1" <%= m.getIsAvailable()==1 ? "selected" : "" %>>Available</option>
            <option value="0" <%= m.getIsAvailable()==0 ? "selected" : "" %>>Sold out</option>
          </select>
        </div>
        <div class="modal-actions">
          <a href="#close" class="btn btn-secondary">Cancel</a>
          <button type="submit" class="btn btn-primary">Save changes</button>
        </div>
      </form>
    </div>
  </div>
  <% } } %>

<% } else { %>
  <%-- ============ MY RESTAURANTS OVERVIEW ============ --%>
<div class="page-header">
  <h1>My Restaurants</h1>
  <p>Manage your restaurants, menus, and orders.</p>
</div>

<%
  int totalOwned = myRestaurants != null ? myRestaurants.size() : 0;
  int totalAllOrders = 0;
  OrderDAOImpl od = new OrderDAOImpl();
  double totalAllRevenue = 0;
  if (myRestaurants != null) {
    for (Restaurant r : myRestaurants) {
      List<OrderTable> ros = od.getOrdersByRestaurant(r.getRestaurantID());
      totalAllOrders += ros.size();
      for (OrderTable o : ros) {
        if ("DELIVERED".equals(o.getStatus())) totalAllRevenue += o.getTotalAmount();
      }
    }
  }
%>
<div class="stats-row">
  <div class="stat-card">
    <div class="label">Your restaurants</div>
    <div class="value"><%= totalOwned %></div>
  </div>
  <div class="stat-card chili">
    <div class="label">Total orders</div>
    <div class="value"><%= totalAllOrders %></div>
  </div>
  <div class="stat-card teal">
    <div class="label">Revenue (delivered)</div>
    <div class="value">₹<%= String.format("%.0f", totalAllRevenue) %></div>
  </div>
  <div class="stat-card gold">
    <div class="label"></div>
    <div class="value" style="font-size:1rem;"><a href="#add-restaurant-modal" class="btn btn-primary">+ Add restaurant</a></div>
  </div>
</div>

<main>
  <% if (errorMsg != null) { %>
    <div style="background:rgba(255,77,61,0.1);border:1px solid var(--chili);border-radius:10px;padding:14px 18px;margin-bottom:20px;color:var(--chili-dark);font-weight:600;">
      <%= errorMsg %>
    </div>
  <% } %>

  <% if (myRestaurants == null || myRestaurants.isEmpty()) { %>
    <div class="empty-state">
      <p style="font-size:1.1rem;font-weight:600;margin:0 0 8px;">No restaurants yet</p>
      <p style="margin:0 0 20px;">Create your first restaurant to start receiving orders.</p>
      <a href="#add-restaurant-modal" class="btn btn-primary">+ Add restaurant</a>
    </div>
  <% } else { %>
  <div class="section-title">Your restaurants</div>
  <div class="restaurant-grid">
    <% for (Restaurant r : myRestaurants) { %>
    <div class="restaurant-card" style="position:relative;">
      <a href="adminServlet?action=manageRestaurant&restaurantID=<%= r.getRestaurantID() %>" style="display:block;">
        <div class="card-img">
          <img src="<%= r.getImageURL() != null ? r.getImageURL() : "https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?w=400&h=200&fit=crop" %>" alt="<%= r.getName() %>">
        </div>
        <div class="card-body">
          <h3><%= r.getName() %></h3>
          <p><%= r.getCuisineType() %> &middot; <%= r.getDeliveryTime() %> min</p>
          <div class="card-footer">
            <span style="font-size:0.88rem;font-weight:700;"><%= r.getRating() %> <span style="color:var(--gold);">★</span></span>
            <span class="status-pill <%= r.getIsActive()==1 ? "active" : "inactive" %>"><%= r.getIsActive()==1 ? "Active" : "Inactive" %></span>
          </div>
        </div>
      </a>
      <div style="padding:0 16px 14px;display:flex;gap:8px;border-top:1px solid var(--line);padding-top:10px;margin-top:2px;">
        <a href="#edit-restaurant-<%= r.getRestaurantID() %>" class="btn btn-secondary btn-sm" style="flex:1;text-align:center;">Edit</a>
        <form action="adminServlet" method="post" style="flex:1;">
          <input type="hidden" name="action" value="deleteMyRestaurant">
          <input type="hidden" name="restaurantID" value="<%= r.getRestaurantID() %>">
          <button type="submit" class="btn btn-secondary btn-sm" style="width:100%;background:rgba(255,77,61,0.1);color:var(--chili);" onclick="return confirm('Delete <%= r.getName() %>? This cannot be undone.');">Delete</button>
        </form>
      </div>
    </div>
    <% } %>
  </div>
  <% } %>

  <%-- ADD RESTAURANT MODAL --%>
  <div class="modal-overlay" id="add-restaurant-modal">
    <div class="modal-box">
      <h3>Add new restaurant</h3>
      <form action="adminServlet" method="post">
        <input type="hidden" name="action" value="addRestaurant">
        <div class="form-group">
          <label>Restaurant name</label>
          <input type="text" name="name" required>
        </div>
        <div class="form-row">
          <div class="form-group">
            <label>Cuisine type</label>
            <input type="text" name="cuisineType" placeholder="e.g. North Indian" required>
          </div>
          <div class="form-group">
            <label>Delivery time (min)</label>
            <input type="number" name="deliveryTime" required>
          </div>
        </div>
        <div class="form-group">
          <label>Address</label>
          <textarea name="address" rows="2" required></textarea>
        </div>
        <div class="form-row-3">
          <div class="form-group">
            <label>Rating</label>
            <input type="number" step="0.1" name="rating" value="0">
          </div>
          <div class="form-group">
            <label>Is Active</label>
            <select name="isActive">
              <option value="1">Active</option>
              <option value="0">Inactive</option>
            </select>
          </div>
          <div class="form-group">
            <label>Is Veg</label>
            <select name="isVeg">
              <option value="0">Non-Veg</option>
              <option value="1">Pure Veg</option>
            </select>
          </div>
        </div>
        <div class="form-row">
          <div class="form-group">
            <label>Image URL</label>
            <input type="text" name="imageURL" placeholder="https://...">
          </div>
          <div class="form-group">
            <label>Price for two (₹)</label>
            <input type="text" name="priceForTwo" placeholder="e.g. 600">
          </div>
        </div>
        <div class="form-group">
          <label>Badge</label>
          <input type="text" name="badge" placeholder="e.g. Bestseller">
        </div>
        <div class="modal-actions">
          <a href="#close" class="btn btn-secondary">Cancel</a>
          <button type="submit" class="btn btn-primary">Add restaurant</button>
        </div>
      </form>
    </div>
  </div>

  <%-- EDIT RESTAURANT MODALS --%>
  <% if (myRestaurants != null) { for (Restaurant r : myRestaurants) { %>
  <div class="modal-overlay" id="edit-restaurant-<%= r.getRestaurantID() %>">
    <div class="modal-box">
      <h3>Edit <%= r.getName() %></h3>
      <form action="adminServlet" method="post">
        <input type="hidden" name="action" value="editRestaurant">
        <input type="hidden" name="restaurantID" value="<%= r.getRestaurantID() %>">
        <div class="form-group">
          <label>Restaurant name</label>
          <input type="text" name="name" value="<%= r.getName() %>" required>
        </div>
        <div class="form-row">
          <div class="form-group">
            <label>Cuisine type</label>
            <input type="text" name="cuisineType" value="<%= r.getCuisineType() %>" required>
          </div>
          <div class="form-group">
            <label>Delivery time (min)</label>
            <input type="number" name="deliveryTime" value="<%= r.getDeliveryTime() %>" required>
          </div>
        </div>
        <div class="form-group">
          <label>Address</label>
          <textarea name="address" rows="2" required><%= r.getAddress() %></textarea>
        </div>
        <div class="form-row-3">
          <div class="form-group">
            <label>Rating</label>
            <input type="number" step="0.1" name="rating" value="<%= r.getRating() %>">
          </div>
          <div class="form-group">
            <label>Is Active</label>
            <select name="isActive">
              <option value="1" <%= r.getIsActive()==1 ? "selected" : "" %>>Active</option>
              <option value="0" <%= r.getIsActive()==0 ? "selected" : "" %>>Inactive</option>
            </select>
          </div>
          <div class="form-group">
            <label>Is Veg</label>
            <select name="isVeg">
              <option value="0" <%= r.getIsVeg()==0 ? "selected" : "" %>>Non-Veg</option>
              <option value="1" <%= r.getIsVeg()==1 ? "selected" : "" %>>Pure Veg</option>
            </select>
          </div>
        </div>
        <div class="form-row">
          <div class="form-group">
            <label>Image URL</label>
            <input type="text" name="imageURL" value="<%= r.getImageURL()!=null?r.getImageURL():"" %>">
          </div>
          <div class="form-group">
            <label>Price for two (₹)</label>
            <input type="text" name="priceForTwo" value="<%= r.getPriceForTwo()!=null?r.getPriceForTwo():"" %>">
          </div>
        </div>
        <div class="form-group">
          <label>Badge</label>
          <input type="text" name="badge" value="<%= r.getBadge()!=null?r.getBadge():"" %>">
        </div>
        <div class="modal-actions">
          <a href="#close" class="btn btn-secondary">Cancel</a>
          <button type="submit" class="btn btn-primary">Save changes</button>
        </div>
      </form>
    </div>
  </div>
  <% } } %>
</main>
<% } %>

</body>
</html>
