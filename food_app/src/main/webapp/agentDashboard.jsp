<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, com.tap.model.OrderTable, com.tap.model.DeliveryAgent, com.tap.model.User" %>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Zestora — Agent Dashboard</title>
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
  body{ margin:0; background:var(--paper); color:var(--ink); font-family:'Inter',sans-serif; -webkit-font-smoothing:antialiased; }
  a{ color:inherit; text-decoration:none; }
  ul{ margin:0; padding:0; list-style:none; }

  .navbar{
    position:sticky; top:0; z-index:100;
    display:flex; align-items:center; justify-content:space-between;
    padding:16px 40px; background:var(--ink); color:var(--paper);
  }
  .logo{ font-family:'Archivo Black',sans-serif; font-size:1.55rem; }
  .logo .dot{ color:var(--gold); }
  .agent-tag{
    background:rgba(27,153,139,0.2); color:var(--teal);
    font-size:0.72rem; font-weight:800; text-transform:uppercase;
    letter-spacing:0.04em; padding:4px 10px; border-radius:6px; margin-left:10px;
  }
  .logout-link{
    display:flex; align-items:center; gap:8px;
    font-weight:600; font-size:0.9rem;
    background:rgba(255,255,255,0.1); padding:9px 16px; border-radius:999px;
  }
  .logout-link:hover{ background:rgba(255,255,255,0.18); }

  .page-header{ max-width:1100px; margin:0 auto; padding:28px 40px 0; }
  .page-header h1{ font-family:'Archivo Black',sans-serif; font-size:clamp(1.4rem,3vw,1.9rem); margin:0 0 4px; }
  .page-header p{ font-size:0.9rem; color:var(--muted); margin:0; }

  /* availability toggle */
  .avail-bar{
    max-width:1100px; margin:18px auto 0; padding:0 40px;
    display:flex; align-items:center; gap:14px;
  }
  .avail-pill{
    display:inline-flex; align-items:center; gap:8px;
    padding:8px 18px; border-radius:999px;
    font-weight:700; font-size:0.84rem;
  }
  .avail-pill.online{ background:rgba(27,153,139,0.15); color:var(--teal); }
  .avail-pill.offline{ background:rgba(255,77,61,0.12); color:var(--chili); }
  .avail-pill::before{
    content:""; width:8px; height:8px;
    border-radius:50%; background:currentColor;
  }
  .toggle-btn{
    border:none; font-weight:700; font-size:0.82rem;
    padding:8px 18px; border-radius:999px; cursor:pointer;
  }
  .toggle-btn.go-online{ background:var(--teal); color:#fff; }
  .toggle-btn.go-offline{ background:var(--chili); color:#fff; }

  /* stats */
  .stats-row{
    max-width:1100px; margin:20px auto 0; padding:0 40px;
    display:grid; grid-template-columns:repeat(3,1fr); gap:16px;
  }
  .stat-card{
    background:var(--card); border:1px solid var(--line);
    border-radius:14px; padding:16px 18px; box-shadow:var(--shadow);
  }
  .stat-card .label{ font-size:0.74rem; color:var(--muted); text-transform:uppercase; letter-spacing:0.04em; font-weight:700; margin-bottom:6px; }
  .stat-card .value{ font-family:'Archivo Black',sans-serif; font-size:1.5rem; }
  .stat-card.teal .value{ color:var(--teal); }
  .stat-card.gold .value{ color:var(--gold); }
  .stat-card.chili .value{ color:var(--chili); }

  /* tabs */
  .tabs-bar{
    max-width:1100px; margin:24px auto 0; padding:0 40px;
    display:flex; gap:10px; border-bottom:1px solid var(--line);
  }
  .tab-link{
    padding:12px 18px; font-weight:700; font-size:0.9rem;
    color:var(--muted); border-bottom:3px solid transparent; margin-bottom:-1px;
  }

  main{ max-width:1100px; margin:0 auto; padding:26px 40px 90px; }

  .tab-panel{ display:none; }
  .tab-panel#tab-orders{ display:block; }
  .tab-panel:target{ display:block; }
  #tab-orders:target ~ #tab-earnings,
  #tab-orders:target ~ #tab-profile{ display:none; }
  #tab-earnings:target ~ #tab-orders,
  #tab-profile:target ~ #tab-orders{ display:none; }
  #tab-profile:target ~ #tab-earnings{ display:none; }
  #tab-earnings:target ~ #tab-profile{ display:none; }

  .section-title{ font-family:'Archivo Black',sans-serif; font-size:1.05rem; margin:0 0 16px; }

  /* order cards */
  .order-card{
    background:var(--card); border:1px solid var(--line);
    border-radius:14px; padding:18px 20px; margin-bottom:14px;
    box-shadow:var(--shadow);
    display:grid; grid-template-columns:1fr auto; gap:12px; align-items:start;
  }
  .order-card .order-id{ font-family:'Archivo Black',sans-serif; font-size:0.95rem; margin:0 0 4px; }
  .order-card .order-meta{ font-size:0.82rem; color:var(--muted); margin:0 0 10px; }
  .order-status{
    font-size:0.72rem; font-weight:800; text-transform:uppercase;
    padding:4px 10px; border-radius:999px;
  }
  .order-status.PENDING{ background:rgba(255,182,39,0.2); color:#a87100; }
  .order-status.CONFIRMED{ background:rgba(27,153,139,0.15); color:var(--teal); }
  .order-status.PREPARING{ background:rgba(255,77,61,0.12); color:var(--chili-dark); }
  .order-status.OUT_FOR_DELIVERY{ background:rgba(43,27,23,0.1); color:var(--ink); }
  .order-status.DELIVERED{ background:rgba(27,153,139,0.25); color:var(--teal); }
  .order-status.CANCELLED{ background:rgba(255,77,61,0.2); color:var(--chili-dark); }

  .status-form{ display:flex; gap:8px; align-items:center; margin-top:10px; }
  .status-form select{
    font-family:'Inter',sans-serif; font-size:0.8rem;
    padding:7px 10px; border-radius:8px;
    border:1.5px solid var(--line); background:var(--paper); color:var(--ink);
  }

  .btn{
    display:inline-block; border:none;
    font-weight:700; font-size:0.82rem;
    padding:8px 16px; border-radius:999px; cursor:pointer;
  }
  .btn-primary{ background:var(--chili); color:#fff; }
  .btn-primary:hover{ background:var(--chili-dark); }
  .btn-secondary{ background:var(--line); color:var(--ink); }
  .btn-secondary:hover{ background:rgba(43,27,23,0.18); }
  .btn-sm{ padding:6px 13px; font-size:0.76rem; }

  /* earnings list */
  .earnings-table{
    width:100%; background:var(--card); border:1px solid var(--line);
    border-radius:14px; overflow:hidden; box-shadow:var(--shadow); border-collapse:collapse;
  }
  .earnings-table th{
    text-align:left; font-size:0.74rem; text-transform:uppercase;
    letter-spacing:0.03em; color:var(--muted); padding:12px 16px;
    background:rgba(43,27,23,0.03); border-bottom:1px solid var(--line);
  }
  .earnings-table td{
    padding:12px 16px; font-size:0.86rem;
    border-bottom:1px dashed var(--line); vertical-align:middle;
  }
  .earnings-table tr:last-child td{ border-bottom:none; }

  /* profile form */
  .profile-form{
    max-width:480px; background:var(--card);
    border:1px solid var(--line); border-radius:14px;
    padding:24px; box-shadow:var(--shadow);
  }
  .form-group{ margin-bottom:14px; }
  .form-group label{
    display:block; font-size:0.76rem; font-weight:700;
    color:var(--muted); text-transform:uppercase;
    letter-spacing:0.03em; margin-bottom:6px;
  }
  .form-group input, .form-group select{
    width:100%; border:1.5px solid var(--line); border-radius:10px;
    padding:10px 12px; font-family:'Inter',sans-serif;
    font-size:0.88rem; color:var(--ink); background:var(--paper);
  }
  .form-group input:focus, .form-group select:focus{
    border-color:var(--chili); outline:none;
  }
  .form-row{ display:grid; grid-template-columns:1fr 1fr; gap:12px; }

  .empty-state{
    text-align:center; padding:50px 20px; color:var(--muted);
    font-size:0.9rem; background:var(--card);
    border-radius:14px; border:1px solid var(--line);
  }

  @media(max-width:700px){
    .navbar{ padding:14px 20px; }
    .page-header,.avail-bar,.stats-row,.tabs-bar,main{ padding-left:20px; padding-right:20px; }
    .stats-row{ grid-template-columns:1fr 1fr; }
    .form-row{ grid-template-columns:1fr; }
    .order-card{ grid-template-columns:1fr; }
  }
  @media(prefers-reduced-motion:reduce){ *{ transition:none !important; } }
</style>
</head>
<body>

<%
    String error = (String) request.getAttribute("error");
    DeliveryAgent agent = (DeliveryAgent) request.getAttribute("agent");
    List<OrderTable> myOrders = (List<OrderTable>) request.getAttribute("myOrders");
%>
<% if (agent == null) { %>
  <nav class="navbar">
    <a href="agentServlet?action=dashboard" class="logo">Zest<span class="dot">ora</span><span class="agent-tag">Agent</span></a>
    <a href="logoutServlet" class="logout-link">Logout</a>
  </nav>
  <main style="max-width:600px; margin:60px auto; padding:0 20px; text-align:center;">
    <div style="background:var(--card); border:1px solid var(--line); border-radius:18px; padding:48px 30px; box-shadow:var(--shadow);">
      <h2 style="font-family:'Archivo Black',sans-serif; font-size:1.3rem; margin:0 0 10px;">Profile incomplete</h2>
      <p style="color:var(--muted); font-size:0.92rem; margin:0 0 20px;">
        <%= error != null ? error : "Your delivery agent profile is not set up yet." %>
      </p>
      <p style="color:var(--muted); font-size:0.85rem; margin:0 0 24px;">
        Please contact support to complete your registration.
      </p>
      <a href="login.jsp" class="btn btn-primary" style="display:inline-block; padding:12px 28px; border-radius:999px;">Go to Login</a>
    </div>
  </main>
<% } else {
    int totalOrders = (myOrders != null) ? myOrders.size() : 0;

    int activeOrders = 0;
    int deliveredOrders = 0;
    if (myOrders != null) {
        for (OrderTable o : myOrders) {
            if ("DELIVERED".equals(o.getStatus())) deliveredOrders++;
            else if (!"CANCELLED".equals(o.getStatus())) activeOrders++;
        }
    }
%>

<nav class="navbar">
  <a href="agentServlet?action=dashboard" class="logo">Zest<span class="dot">ora</span><span class="agent-tag">Agent</span></a>
  <a href="logoutServlet" class="logout-link">Logout</a>
</nav>

<div class="page-header">
  <h1>Hi, <%= agent.getFullName() %></h1>
  <p><%= agent.getVehicleType() %> · <%= agent.getVehicleNumber() %></p>
</div>

<div class="avail-bar">
  <span class="avail-pill <%= agent.getIsAvailable()==1 ? "online" : "offline" %>">
    <%= agent.getIsAvailable()==1 ? "Online — accepting orders" : "Offline" %>
  </span>
  <form action="agentServlet" method="post">
    <input type="hidden" name="action" value="toggleAvailability">
    <button type="submit" class="toggle-btn <%= agent.getIsAvailable()==1 ? "go-offline" : "go-online" %>">
      <%= agent.getIsAvailable()==1 ? "Go Offline" : "Go Online" %>
    </button>
  </form>
</div>

<div class="stats-row">
  <div class="stat-card chili">
    <div class="label">Active orders</div>
    <div class="value"><%= activeOrders %></div>
  </div>
  <div class="stat-card teal">
    <div class="label">Delivered</div>
    <div class="value"><%= deliveredOrders %></div>
  </div>
  <div class="stat-card gold">
    <div class="label">Total earnings</div>
    <div class="value">₹<%= String.format("%.0f", agent.getTotalEarnings()) %></div>
  </div>
</div>

<div class="tabs-bar">
  <a href="#tab-orders" class="tab-link">My Orders</a>
  <a href="#tab-earnings" class="tab-link">Earnings</a>
  <a href="#tab-profile" class="tab-link">Profile</a>
</div>

<main>

  <!-- ====== ORDERS TAB ====== -->
  <div class="tab-panel" id="tab-orders">
    <div class="section-title">Assigned orders</div>

    <% if (myOrders == null || myOrders.isEmpty()) { %>
      <div class="empty-state">No orders assigned yet. Stay online to receive orders.</div>
    <% } else {
         for (OrderTable o : myOrders) {
           if (!"DELIVERED".equals(o.getStatus()) && !"CANCELLED".equals(o.getStatus())) { %>
      <div class="order-card">
        <div>
          <p class="order-id">Order #<%= o.getOrderID() %></p>
          <p class="order-meta">
            ₹<%= o.getTotalAmount() %> &nbsp;·&nbsp;
            <%= o.getPaymentMethod() %> &nbsp;·&nbsp;
            <%= o.getOrderDate() %>
          </p>
          <span class="order-status <%= o.getStatus() %>"><%= o.getStatus() %></span>

          <form action="agentServlet" method="post" class="status-form">
            <input type="hidden" name="action" value="updateStatus">
            <input type="hidden" name="orderId" value="<%= o.getOrderID() %>">
            <select name="status">
              <option value="CONFIRMED"       <%= "CONFIRMED".equals(o.getStatus())?"selected":"" %>>Confirmed</option>
              <option value="PREPARING"       <%= "PREPARING".equals(o.getStatus())?"selected":"" %>>Preparing</option>
              <option value="OUT_FOR_DELIVERY" <%= "OUT_FOR_DELIVERY".equals(o.getStatus())?"selected":"" %>>Out for delivery</option>
              <option value="DELIVERED"       <%= "DELIVERED".equals(o.getStatus())?"selected":"" %>>Delivered</option>
              <option value="CANCELLED"       <%= "CANCELLED".equals(o.getStatus())?"selected":"" %>>Cancelled</option>
            </select>
            <button type="submit" class="btn btn-primary btn-sm">Update</button>
          </form>
        </div>
      </div>
    <% } } } %>
  </div>

  <!-- ====== EARNINGS TAB ====== -->
  <div class="tab-panel" id="tab-earnings">
    <div class="section-title">Earnings history</div>

    <div class="stat-card gold" style="max-width:260px; margin-bottom:20px;">
      <div class="label">Total earnings</div>
      <div class="value">₹<%= String.format("%.2f", agent.getTotalEarnings()) %></div>
    </div>

    <% if (myOrders == null || myOrders.isEmpty()) { %>
      <div class="empty-state">No deliveries completed yet.</div>
    <% } else { %>
    <table class="earnings-table">
      <thead>
        <tr>
          <th>Order ID</th>
          <th>Date</th>
          <th>Order Amount</th>
          <th>Status</th>
          <th>Delivery Fee</th>
        </tr>
      </thead>
      <tbody>
      <% for (OrderTable o : myOrders) {
           if ("DELIVERED".equals(o.getStatus())) { %>
        <tr>
          <td>#<%= o.getOrderID() %></td>
          <td><%= o.getOrderDate() %></td>
          <td>₹<%= o.getTotalAmount() %></td>
          <td><span class="order-status DELIVERED">Delivered</span></td>
          <td style="color:var(--teal); font-weight:700;">₹30.00</td>
        </tr>
      <% } } %>
      </tbody>
    </table>
    <% } %>
  </div>

  <!-- ====== PROFILE TAB ====== -->
  <div class="tab-panel" id="tab-profile">
    <div class="section-title">My profile</div>

    <form action="agentServlet" method="post" class="profile-form">
      <input type="hidden" name="action" value="updateProfile">

      <div class="form-group">
        <label>Full name</label>
        <input type="text" name="fullName" value="<%= agent.getFullName() %>" required>
      </div>

      <div class="form-group">
        <label>Phone</label>
        <input type="tel" name="phone" value="<%= agent.getPhone() %>" required>
      </div>

      <div class="form-row">
        <div class="form-group">
          <label>Vehicle type</label>
          <select name="vehicleType">
            <option value="Bike"    <%= "Bike".equals(agent.getVehicleType())?"selected":"" %>>Bike</option>
            <option value="Scooter" <%= "Scooter".equals(agent.getVehicleType())?"selected":"" %>>Scooter</option>
            <option value="Cycle"   <%= "Cycle".equals(agent.getVehicleType())?"selected":"" %>>Cycle</option>
            <option value="Car"     <%= "Car".equals(agent.getVehicleType())?"selected":"" %>>Car</option>
          </select>
        </div>
        <div class="form-group">
          <label>Vehicle number</label>
          <input type="text" name="vehicleNumber" value="<%= agent.getVehicleNumber() %>">
        </div>
      </div>

      <button type="submit" class="btn btn-primary">Save profile</button>
    </form>
  </div>

</main>
<% } %>
</body>
</html>