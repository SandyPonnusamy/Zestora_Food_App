<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, com.tap.model.OrderItem, com.tap.model.OrderTable, com.tap.model.User" %>
<%
  User admin = (User) session.getAttribute("user");
  if (admin == null || !"RESTAURANT_ADMIN".equals(admin.getRole())) {
    response.sendRedirect("login.jsp");
    return;
  }
  OrderTable order = (OrderTable) request.getAttribute("order");
  List<OrderItem> orderItems = (List<OrderItem>) request.getAttribute("orderItems");
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Zestora — Order Items</title>
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
  }
  a{ color:inherit; text-decoration:none; }
  .navbar{
    display:flex;
    align-items:center;
    justify-content: space-between;
    padding: 16px 40px;
    background: var(--ink);
    color: var(--paper);
  }
  .logo{ font-family:'Archivo Black', sans-serif; font-size:1.55rem; }
  .logo .dot{ color: var(--gold); }
  .back-link{
    display:flex;
    align-items:center;
    gap:8px;
    font-weight:600;
    font-size:0.9rem;
  }
  main{
    max-width:700px;
    margin:0 auto;
    padding:40px 20px 90px;
  }
  .card{
    background: var(--card);
    border:1px solid var(--line);
    border-radius:16px;
    padding:24px;
    box-shadow:var(--shadow);
  }
  .card h2{
    font-family:'Archivo Black', sans-serif;
    font-size:1.1rem;
    margin:0 0 16px;
  }
  table{ width:100%; border-collapse:collapse; }
  th{
    text-align:left;
    font-size:0.74rem;
    text-transform:uppercase;
    color:var(--muted);
    padding:10px 12px;
    border-bottom:1px solid var(--line);
  }
  td{
    padding:10px 12px;
    font-size:0.88rem;
    border-bottom:1px dashed var(--line);
  }
  tr:last-child td{ border-bottom:none; }
  .btn{
    display:inline-block;
    border:none;
    background:var(--chili);
    color:#fff;
    font-weight:700;
    font-size:0.84rem;
    padding:9px 18px;
    border-radius:999px;
    cursor:pointer;
  }
</style>
</head>
<body>
<nav class="navbar">
  <a href="adminServlet?action=dashboard" class="logo">Zest<span class="dot">ora</span><span style="font-size:0.72rem;margin-left:10px;color:var(--gold);text-transform:uppercase;letter-spacing:0.04em;">Admin</span></a>
  <a href="adminServlet?action=dashboard" class="back-link">&larr; Back to dashboard</a>
</nav>
<main>
  <div class="card">
    <h2>Order #<%= order != null ? order.getOrderID() : "N/A" %> — Items</h2>
    <% if (orderItems == null || orderItems.isEmpty()) { %>
      <p style="color:var(--muted);font-size:0.9rem;">No items found for this order.</p>
    <% } else { %>
    <table>
      <thead>
        <tr>
          <th>Item ID</th>
          <th>Menu ID</th>
          <th>Qty</th>
          <th>Total</th>
        </tr>
      </thead>
      <tbody>
      <% for (OrderItem oi : orderItems) { %>
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
    <div style="margin-top:18px;">
      <a href="adminServlet?action=dashboard" class="btn">Back to Dashboard</a>
    </div>
  </div>
</main>
</body>
</html>
