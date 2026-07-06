<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, com.tap.model.OrderTable, com.tap.daoimpl.RestaurantDAOImpl, com.tap.model.User" %>
<%
  User user = (User) session.getAttribute("user");
  if (user == null) {
    response.sendRedirect("login.jsp");
    return;
  }
  List<OrderTable> orders = (List<OrderTable>) request.getAttribute("orders");
  RestaurantDAOImpl restoDAO = new RestaurantDAOImpl();
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Zestora — My Orders</title>
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
  html{ scroll-behavior:smooth; }
  body{
    margin:0;
    background: var(--paper);
    color: var(--ink);
    font-family:'Inter', sans-serif;
    -webkit-font-smoothing: antialiased;
  }
  a{ color:inherit; text-decoration:none; }
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
  .logo{
    font-family:'Archivo Black', sans-serif;
    font-size: 1.55rem;
  }
  .logo .dot{ color: var(--gold); }
  .nav-links{
    display:flex;
    align-items:center;
    gap: 30px;
  }
  .nav-links a{
    font-weight:600;
    font-size: 0.95rem;
    opacity:0.92;
  }
  .nav-cta{
    background: var(--chili);
    color: #fff !important;
    padding: 10px 20px;
    border-radius: 999px;
    font-weight:700;
    font-size: 0.9rem;
    box-shadow: 0 6px 16px rgba(255,77,61,0.35);
  }
  .nav-cta:hover{ background: var(--chili-dark); }

  .orders-hero{
    position:relative;
    background: linear-gradient(135deg, var(--ink) 0%, #45291f 60%, var(--chili-dark) 130%);
    color: var(--paper);
    padding: 48px 40px 42px;
    overflow:hidden;
    text-align:center;
  }
  .orders-hero::before{
    content:"";
    position:absolute;
    top:-60px; right:-60px;
    width:280px; height:280px;
    background: radial-gradient(circle, rgba(255,182,39,0.3), transparent 70%);
  }
  .orders-hero-inner{
    position:relative;
    z-index:2;
  }
  .orders-hero h1{
    font-family:'Archivo Black', sans-serif;
    font-size: clamp(1.7rem, 3.4vw, 2.4rem);
    margin: 0 0 10px;
  }
  .orders-hero h1 em{ font-style:normal; color: var(--gold); }
  .orders-hero p{
    font-size: 0.96rem;
    opacity:0.85;
    margin:0;
  }

  main{
    max-width: 800px;
    margin: 0 auto;
    padding: 36px 20px 100px;
  }

  .order-card{
    background: var(--card);
    border: 1px solid var(--line);
    border-radius: 16px;
    box-shadow: var(--shadow);
    overflow:hidden;
    margin-bottom: 20px;
  }
  .order-header{
    display:flex;
    justify-content: space-between;
    align-items:center;
    padding: 18px 22px;
    background: var(--paper);
    border-bottom: 1px solid var(--line);
    flex-wrap:wrap;
    gap:8px;
  }
  .order-header .resto-name{
    font-family:'Archivo Black', sans-serif;
    font-size: 1rem;
  }
  .order-header .order-id{
    font-size:0.82rem;
    color: var(--muted);
    font-weight:600;
  }
  .order-body{
    padding: 18px 22px;
    display:flex;
    flex-wrap:wrap;
    gap: 16px 32px;
  }
  .order-body .item{
    display:flex;
    flex-direction:column;
    gap:2px;
  }
  .order-body .item .label{
    font-size:0.74rem;
    text-transform:uppercase;
    letter-spacing:0.04em;
    color: var(--muted);
    font-weight:700;
  }
  .order-body .item .value{
    font-size:0.92rem;
    font-weight:700;
  }
  .order-body .item .value.amount{ color: var(--chili-dark); }
  .order-body .item .value.paid{ color: var(--teal); }
  .order-body .item .value.preparing{ color: var(--gold); }
  .order-body .item .value.delivered{ color: var(--teal); }
  .order-body .item .value.cancelled{ color: var(--chili); }

  .empty-state{
    text-align:center;
    padding: 60px 20px;
  }
  .empty-state svg{
    width:56px; height:56px;
    color: var(--muted);
    margin-bottom:16px;
  }
  .empty-state h2{
    font-family:'Archivo Black', sans-serif;
    font-size:1.2rem;
    margin:0 0 8px;
  }
  .empty-state p{
    color: var(--muted);
    font-size:0.9rem;
    margin:0 0 24px;
  }
  .empty-state .btn{
    display:inline-block;
    background: var(--chili);
    color:#fff;
    font-weight:700;
    padding: 12px 28px;
    border-radius: 999px;
  }
  .empty-state .btn:hover{ background: var(--chili-dark); }

  footer{
    background: var(--ink);
    color: rgba(255,247,236,0.6);
    padding: 24px 40px;
    text-align:center;
    font-size: 0.8rem;
  }

  @media (max-width: 600px){
    .navbar{ padding: 14px 20px; }
    .orders-hero{ padding: 38px 20px 34px; }
    main{ padding: 24px 16px 80px; }
    .order-header, .order-body{ padding: 14px 16px; }
  }

  @media (prefers-reduced-motion: reduce){
    *{ transition:none !important; }
  }
</style>
</head>
<body>

<nav class="navbar">
  <a href="callRestaurantServlet" class="logo">Zest<span class="dot">ora</span></a>
  <ul class="nav-links">
    <li><a href="callRestaurantServlet">Home</a></li>
    <li><a href="orderHistory" class="nav-cta">Orders</a></li>
  </ul>
</nav>

<header class="orders-hero">
  <div class="orders-hero-inner">
    <h1>My <em>Orders</em></h1>
    <p>Track everything you've ordered on Zestora.</p>
  </div>
</header>

<main>
<%
  if (orders == null || orders.isEmpty()) {
%>
  <div class="empty-state">
    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5"><circle cx="9" cy="21" r="1"/><circle cx="20" cy="21" r="1"/><path d="M1 1h4l2.7 13.4a2 2 0 0 0 2 1.6h9.7a2 2 0 0 0 2-1.6L23 6H6"/></svg>
    <h2>No orders yet</h2>
    <p>Looks like you haven't placed any orders. Hungry? Let's fix that.</p>
    <a href="callRestaurantServlet" class="btn">Browse Restaurants</a>
  </div>
<%
  } else {
    for (OrderTable order : orders) {
      String restoName = "Restaurant";
      try {
        com.tap.model.Restaurant r = restoDAO.getRestaurantByID(order.getRestaurantID());
        if (r != null) restoName = r.getName();
      } catch (Exception e) {}
%>
  <div class="order-card">
    <div class="order-header">
      <span class="resto-name"><%= restoName %></span>
      <span class="order-id">#ZEST-<%= String.format("%05d", order.getOrderID()) %></span>
    </div>
    <div class="order-body">
      <div class="item">
        <span class="label">Date</span>
        <span class="value"><%= order.getOrderDate() != null ? new java.text.SimpleDateFormat("dd MMM yyyy").format(order.getOrderDate()) : "N/A" %></span>
      </div>
      <div class="item">
        <span class="label">Total</span>
        <span class="value amount">₹<%= String.format("%.0f", order.getTotalAmount()) %></span>
      </div>
      <div class="item">
        <span class="label">Payment</span>
        <span class="value paid"><%= order.getPaymentMethod() %></span>
      </div>
      <div class="item">
        <span class="label">Status</span>
        <span class="value <%= order.getStatus().toLowerCase() %>"><%= order.getStatus() %></span>
      </div>
    </div>
  </div>
<%
    }
  }
%>
</main>

<footer>
  © 2026 Zestora. UI concept for a food delivery app.
</footer>

</body>
</html>
