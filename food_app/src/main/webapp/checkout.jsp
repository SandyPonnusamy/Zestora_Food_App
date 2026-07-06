<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@
page import="java.util.Map, java.util.HashMap, com.tap.model.Cart, com.tap.model.CartItem, com.tap.model.Restaurant, com.tap.model.User, com.tap.daoimpl.RestaurantDAOImpl"
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Zestora — Checkout</title>
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
  img{ max-width:100%; display:block; }
  ul{ margin:0; padding:0; list-style:none; }
  a:focus-visible, button:focus-visible, input:focus-visible{
    outline: 3px solid var(--chili-dark);
    outline-offset: 2px;
  }

  /* ================= NAVBAR ================= */
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
  .back-link{
    display:flex;
    align-items:center;
    gap:8px;
    font-weight:600;
    font-size: 0.9rem;
    background: rgba(255,255,255,0.1);
    padding: 9px 16px;
    border-radius: 999px;
  }
  .back-link:hover{ background: rgba(255,255,255,0.18); }
  .back-link svg{ width:16px; height:16px; }

  /* ================= PROGRESS STEPS ================= */
  .checkout-steps{
    max-width: 1000px;
    margin: 0 auto;
    padding: 26px 40px 0;
    display:flex;
    align-items:center;
    justify-content:center;
    gap: 10px;
  }
  .step{
    display:flex;
    align-items:center;
    gap: 8px;
    font-size: 0.82rem;
    font-weight:700;
    color: var(--muted);
  }
  .step-circle{
    width: 26px;
    height:26px;
    border-radius:50%;
    background: var(--line);
    color: var(--muted);
    display:flex;
    align-items:center;
    justify-content:center;
    font-size: 0.78rem;
    flex-shrink:0;
  }
  .step.done .step-circle{ background: var(--teal); color:#fff; }
  .step.active .step-circle{ background: var(--chili); color:#fff; }
  .step.active{ color: var(--ink); }
  .step-divider{
    width: 36px;
    height: 2px;
    background: var(--line);
    border-radius:2px;
  }

  /* ================= PAGE HEADER ================= */
  .page-header{
    max-width: 1000px;
    margin: 0 auto;
    padding: 22px 40px 0;
  }
  .page-header h1{
    font-family:'Archivo Black', sans-serif;
    font-size: clamp(1.5rem, 3vw, 1.9rem);
    margin: 0 0 6px;
  }
  .page-header p{
    font-size: 0.9rem;
    color: var(--muted);
    margin:0;
  }

  /* ================= LAYOUT ================= */
  main{
    max-width: 1000px;
    margin: 0 auto;
    padding: 22px 40px 90px;
    display:grid;
    grid-template-columns: 1.2fr 1.3fr;
    gap: 26px;
    align-items:start;
  }

  .panel{
    background: var(--card);
    border: 1px solid var(--line);
    border-radius: 16px;
    padding: 22px 24px;
    box-shadow: var(--shadow);
    margin-bottom: 20px;
  }
  .panel h3{
    font-family:'Archivo Black', sans-serif;
    font-size: 1.02rem;
    margin: 0 0 16px;
    display:flex;
    align-items:center;
    gap:9px;
  }
  .panel h3 svg{ width:18px; height:18px; color: var(--chili); }

  /* ================= DELIVERY ADDRESS ================= */
  .addr-box{
    border: 1.5px solid var(--chili);
    background: rgba(255,77,61,0.04);
    border-radius: 12px;
    padding: 14px 16px;
    display:flex;
    gap: 12px;
    align-items:flex-start;
  }
  .addr-box svg{ width:18px; height:18px; color: var(--chili); flex-shrink:0; margin-top:2px; }
  .addr-box strong{ display:block; font-size: 0.9rem; margin-bottom:3px; }
  .addr-box span{ font-size: 0.83rem; color: var(--muted); line-height:1.5; }
  .edit-addr-link{
    margin-left:auto;
    font-size: 0.78rem;
    font-weight:700;
    color: var(--teal);
    text-decoration:underline;
    flex-shrink:0;
    cursor:pointer;
    background:none;
    border:none;
  }

  .form-group{ margin-bottom: 14px; }
  .form-group label{
    display:block;
    font-size: 0.78rem;
    font-weight:700;
    color: var(--muted);
    text-transform:uppercase;
    letter-spacing:0.03em;
    margin-bottom: 6px;
  }
  .form-group input, .form-group textarea{
    width:100%;
    border: 1.5px solid var(--line);
    border-radius: 10px;
    padding: 10px 12px;
    font-family:'Inter', sans-serif;
    font-size: 0.9rem;
    color: var(--ink);
    background: var(--paper);
  }
  .form-group input:focus, .form-group textarea:focus{
    border-color: var(--chili);
    outline:none;
  }
  .form-row{
    display:grid;
    grid-template-columns: 1fr 1fr;
    gap: 14px;
  }

  /* ================= RESTAURANT STRIP ================= */
  .cart-restaurant{
    display:flex;
    align-items:center;
    gap: 12px;
    margin-bottom: 14px;
  }
  .cart-restaurant img{
    width: 44px;
    height: 44px;
    border-radius: 9px;
    object-fit:cover;
    flex-shrink:0;
  }
  .cart-restaurant h4{
    font-family:'Archivo Black', sans-serif;
    font-size: 0.92rem;
    margin: 0 0 2px;
  }
  .cart-restaurant span{
    font-size: 0.76rem;
    color: var(--muted);
  }

  /* ================= ORDER ITEMS LIST ================= */
  .order-item-row{
    display:flex;
    justify-content: space-between;
    align-items:center;
    padding: 10px 0;
    border-bottom: 1px dashed var(--line);
    font-size: 0.86rem;
  }
  .order-item-row:last-child{ border-bottom:none; }
  .order-item-row .qty-tag{
    display:inline-flex;
    align-items:center;
    justify-content:center;
    background: var(--ink);
    color: var(--paper);
    font-size: 0.7rem;
    font-weight:800;
    width: 20px;
    height:20px;
    border-radius: 5px;
    margin-right:8px;
  }
  .order-item-row .item-name{ font-weight:600; }
  .order-item-row .item-price{ font-weight:700; color: var(--chili-dark); }

  /* ================= PAYMENT METHOD ================= */
  .pay-option{
    display:flex;
    align-items:center;
    gap: 10px;
    border: 1.5px solid var(--line);
    border-radius: 10px;
    padding: 12px 14px;
    margin-bottom: 10px;
    font-size: 0.88rem;
    font-weight:600;
    cursor:pointer;
  }
  .pay-option input[type="radio"]{
    margin-left:auto;
    width:17px;
    height:17px;
    accent-color: var(--chili);
    cursor:pointer;
  }
  .pay-option:has(input:checked){
    border-color: var(--chili);
    background: rgba(255,77,61,0.05);
  }
  .pay-option svg{ width:18px; height:18px; color: var(--teal); flex-shrink:0; }
  .pay-option .pay-sub{
    font-size: 0.74rem;
    font-weight:500;
    color: var(--muted);
    display:block;
    margin-top:1px;
  }

  /* ================= SUMMARY SIDEBAR ================= */
  .summary-card{
    background: var(--card);
    border: 1px solid var(--line);
    border-radius: 16px;
    padding: 22px 22px 20px;
    box-shadow: var(--shadow);
    position: sticky;
    top: 24px;
  }
  .summary-card h3{
    font-family:'Archivo Black', sans-serif;
    font-size: 1.05rem;
    margin: 0 0 16px;
  }
  .summary-row{
    display:flex;
    justify-content: space-between;
    font-size: 0.88rem;
    color: var(--muted);
    margin-bottom: 12px;
  }
  .summary-row span:last-child{
    color: var(--ink);
    font-weight:600;
  }
  .summary-row.discount span:last-child{ color: var(--teal); }
  .summary-divider{
    height:1px;
    background: var(--line);
    margin: 14px 0;
  }
  .summary-total{
    display:flex;
    justify-content: space-between;
    font-size: 1.02rem;
    font-weight:800;
    margin-bottom: 20px;
  }
  .summary-total span:last-child{ color: var(--chili-dark); }

  .place-order-btn{
    width:100%;
    border:none;
    background: var(--chili);
    color: #fff;
    font-weight:800;
    font-size: 0.96rem;
    padding: 15px 0;
    border-radius: 999px;
    cursor:pointer;
    transition: background .15s ease;
    box-shadow: 0 10px 22px rgba(255,77,61,0.35);
  }
  .place-order-btn:hover{ background: var(--chili-dark); }

  .secure-note{
    display:flex;
    align-items:center;
    gap: 7px;
    margin-top: 14px;
    font-size: 0.76rem;
    color: var(--muted);
    justify-content:center;
  }
  .secure-note svg{ width:14px; height:14px; color: var(--teal); }

  /* ================= RESPONSIVE ================= */
  @media (max-width: 860px){
    main{ grid-template-columns: 1fr; }
    .summary-card{ position:static; }
    .checkout-steps{ padding: 22px 20px 0; }
    .step span.step-label{ display:none; }
  }
  @media (max-width: 600px){
    .navbar{ padding: 14px 20px; }
    .page-header{ padding: 22px 20px 0; }
    main{ padding: 18px 20px 70px; }
    .panel{ padding: 18px; }
    .form-row{ grid-template-columns: 1fr; }
  }

  @media (prefers-reduced-motion: reduce){
    *{ transition:none !important; }
  }
</style>
</head>
<body>

<%
    Cart cart = (Cart) session.getAttribute("cart");
    Integer restaurantId = (Integer) session.getAttribute("restaurantId");
    User loggedInUser = (User) session.getAttribute("user");

    Restaurant restaurant = null;
    if (restaurantId != null) {
        RestaurantDAOImpl restaurantDAO = new RestaurantDAOImpl();
        restaurant = restaurantDAO.getRestaurantByID(restaurantId);
    }

    Map<Integer, CartItem> items = (cart != null) ? cart.getItems() : new HashMap<>();

    double itemTotal    = (cart != null) ? cart.getGrandTotal() : 0.0;
    double deliveryFee  = itemTotal > 0 ? 30.0 : 0.0;
    double packagingFee = itemTotal > 0 ? 15.0 : 0.0;
    double discount     = 0.0;
    double taxes        = itemTotal * 0.05;
    double grandTotal   = itemTotal + deliveryFee + packagingFee + taxes - discount;

    String userAddress = (loggedInUser != null && loggedInUser.getAddress() != null)
                            ? loggedInUser.getAddress() : "";
    String userName = (loggedInUser != null) ? loggedInUser.getUsername() : "";
%>

<nav class="navbar">
  <a href="callRestaurantServlet" class="logo">Zest<span class="dot">ora</span></a>
  <a href="cartServlet" class="back-link">
    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M15 18l-6-6 6-6"/></svg>
    Back to cart
  </a>
</nav>

<div class="checkout-steps">
  <div class="step done">
    <span class="step-circle">✓</span>
    <span class="step-label">Cart</span>
  </div>
  <div class="step-divider"></div>
  <div class="step active">
    <span class="step-circle">2</span>
    <span class="step-label">Checkout</span>
  </div>
  <div class="step-divider"></div>
  <div class="step">
    <span class="step-circle">3</span>
    <span class="step-label">Confirmed</span>
  </div>
</div>

<div class="page-header">
  <h1>Checkout</h1>
  <p>Confirm your delivery details and place your order.</p>
</div>

<form action="checkout" method="post" id="checkoutForm">
<main>

  <!-- LEFT: Details -->
  <div>

    <!-- Delivery Address -->
    <div class="panel">
      <h3>
        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M21 10c0 7-9 12-9 12s-9-5-9-12a9 9 0 1 1 18 0z"/><circle cx="12" cy="10" r="3"/></svg>
        Delivery address
      </h3>

      <div class="addr-box" style="margin-bottom:16px;">
        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M21 10c0 7-9 12-9 12s-9-5-9-12a9 9 0 1 1 18 0z"/><circle cx="12" cy="10" r="3"/></svg>
        <div>
          <strong><%= userName.isEmpty() ? "Deliver to" : userName %></strong>
          <span><%= userAddress.isEmpty() ? "No saved address -- please enter below." : userAddress %></span>
        </div>
      </div>

      <div class="form-group">
        <label for="fullAddress">Full address</label>
        <textarea id="fullAddress" name="fullAddress" rows="2" placeholder="House no, street, area" required><%= userAddress %></textarea>
      </div>

      <div class="form-row">
        <div class="form-group">
          <label for="city">City</label>
          <input type="text" id="city" name="city" placeholder="Bangalore" required>
        </div>
        <div class="form-group">
          <label for="pincode">Pincode</label>
          <input type="text" id="pincode" name="pincode" placeholder="560001" pattern="[0-9]{6}" required>
        </div>
      </div>

      <div class="form-group">
        <label for="phone">Contact number</label>
        <input type="tel" id="phone" name="phone" placeholder="+91 98765 43210" pattern="[0-9+ ]{10,15}" required>
      </div>

      <div class="form-group" style="margin-bottom:0;">
        <label for="deliveryNote">Delivery instructions (optional)</label>
        <input type="text" id="deliveryNote" name="deliveryNote" placeholder="e.g. Ring the bell, leave at door">
      </div>
    </div>

  </div>

  <!-- RIGHT: Order Details + Bill -->
  <div>

    <!-- Order Summary List -->
    <div class="panel">
      <h3>
        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="9" cy="21" r="1"/><circle cx="20" cy="21" r="1"/><path d="M1 1h4l2.7 13.4a2 2 0 0 0 2 1.6h9.7a2 2 0 0 0 2-1.6L23 6H6"/></svg>
        Order items
      </h3>

      <% if (restaurant != null) { %>
      <div class="cart-restaurant">
        <img src="<%= restaurant.getImageURL() %>" alt="<%= restaurant.getName() %>">
        <div>
          <h4><%= restaurant.getName() %></h4>
          <span><%= restaurant.getCuisineType() %> · Estimated <%= restaurant.getDeliveryTime() %> min</span>
        </div>
      </div>
      <% } %>

<%
    for (CartItem item : items.values()) {
%>
      <div class="order-item-row">
        <span class="item-name">
          <span class="qty-tag"><%= item.getQuantity() %></span><%= item.getName() %>
        </span>
        <span class="item-price">₹<%= item.getPrice() * item.getQuantity() %></span>
      </div>
<%
    }
%>
    </div>

    <aside class="summary-card">
    <h3>Bill details</h3>

    <div class="summary-row">
      <span>Item total</span>
      <span>₹<%= String.format("%.2f", itemTotal) %></span>
    </div>
    <div class="summary-row">
      <span>Delivery fee</span>
      <span>₹<%= String.format("%.2f", deliveryFee) %></span>
    </div>
    <div class="summary-row">
      <span>Packaging fee</span>
      <span>₹<%= String.format("%.2f", packagingFee) %></span>
    </div>
    <div class="summary-row discount">
      <span>Discount</span>
      <span>−₹<%= String.format("%.2f", discount) %></span>
    </div>
    <div class="summary-row">
      <span>Taxes & charges</span>
      <span>₹<%= String.format("%.2f", taxes) %></span>
    </div>

    <div class="summary-divider"></div>

    <div class="summary-total">
      <span>To pay</span>
      <span>₹<%= String.format("%.2f", grandTotal) %></span>
    </div>

    <button type="submit" class="place-order-btn">Place Order · ₹<%= String.format("%.2f", grandTotal) %></button>

    <div class="secure-note">
      <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="3" y="11" width="18" height="11" rx="2"/><path d="M7 11V7a5 5 0 0 1 10 0v4"/></svg>
      Safe & secure checkout
    </div>
  </aside>

  </div>

</main>
</form>

<script>
document.getElementById('checkoutForm').addEventListener('submit', function(e) {
  var pincode = document.getElementById('pincode').value;
  if (!/^[0-9]{6}$/.test(pincode)) {
    e.preventDefault();
    alert('Please enter a valid 6-digit pincode.');
  }
});
</script>

</body>
</html>