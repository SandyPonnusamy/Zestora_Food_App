<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@
page import="java.util.Map, com.tap.model.Cart, com.tap.model.CartItem, com.tap.model.Restaurant, com.tap.model.User, com.tap.daoimpl.RestaurantDAOImpl"
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Zestora — Confirm Order</title>
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
  a:focus-visible, button:focus-visible, input:focus-visible{
    outline: 3px solid var(--chili-dark);
    outline-offset: 2px;
  }

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

  .addr-box{
    border: 1.5px solid var(--teal);
    background: rgba(27,153,139,0.04);
    border-radius: 12px;
    padding: 14px 16px;
    display:flex;
    gap: 12px;
    align-items:flex-start;
  }
  .addr-box svg{ width:18px; height:18px; color: var(--teal); flex-shrink:0; margin-top:2px; }
  .addr-box strong{ display:block; font-size: 0.9rem; margin-bottom:3px; }
  .addr-box span{ font-size: 0.83rem; color: var(--muted); line-height:1.5; }
  .addr-box .edit-link{
    margin-left:auto;
    font-size: 0.78rem;
    font-weight:700;
    color: var(--chili);
    flex-shrink:0;
  }

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

  .confirm-btn{
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
  .confirm-btn:hover{ background: var(--chili-dark); }

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
  }

  @media (prefers-reduced-motion: reduce){
    *{ transition:none !important; }
  }
</style>
</head>
<body>

<%
    String orderError = (String) session.getAttribute("orderError");
    if (orderError != null) {
        session.removeAttribute("orderError");
    }

    Cart cart = (Cart) session.getAttribute("cart");
    Integer restaurantId = (Integer) session.getAttribute("restaurantId");
    User loggedInUser = (User) session.getAttribute("user");

    Restaurant restaurant = null;
    if (restaurantId != null) {
        RestaurantDAOImpl restaurantDAO = new RestaurantDAOImpl();
        restaurant = restaurantDAO.getRestaurantByID(restaurantId);
    }

    Map<Integer, CartItem> items = (cart != null) ? cart.getItems() : new java.util.HashMap<>();

    double itemTotal    = (cart != null) ? cart.getGrandTotal() : 0.0;
    double deliveryFee  = itemTotal > 0 ? 30.0 : 0.0;
    double packagingFee = itemTotal > 0 ? 15.0 : 0.0;
    double discount     = 0.0;
    double taxes        = Math.round(itemTotal * 0.05 * 100) / 100.0;
    double grandTotal   = itemTotal + deliveryFee + packagingFee + taxes - discount;

    String delAddr  = (String) session.getAttribute("deliveryAddress");
    String delCity  = (String) session.getAttribute("deliveryCity");
    String delPcode = (String) session.getAttribute("deliveryPincode");
    String delPhone = (String) session.getAttribute("deliveryPhone");
    String delNote  = (String) session.getAttribute("deliveryNote");
%>

<nav class="navbar">
  <a href="callRestaurantServlet" class="logo">Zest<span class="dot">ora</span></a>
  <a href="checkout" class="back-link">
    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M15 18l-6-6 6-6"/></svg>
    Back
  </a>
</nav>

<div class="checkout-steps">
  <div class="step done">
    <span class="step-circle">&#10003;</span>
    <span class="step-label">Cart</span>
  </div>
  <div class="step-divider"></div>
  <div class="step done">
    <span class="step-circle">&#10003;</span>
    <span class="step-label">Delivery</span>
  </div>
  <div class="step-divider"></div>
  <div class="step active">
    <span class="step-circle">3</span>
    <span class="step-label">Confirm</span>
  </div>
  <div class="step-divider"></div>
  <div class="step">
    <span class="step-circle">4</span>
    <span class="step-label">Done</span>
  </div>
</div>

<div class="page-header">
  <h1>Confirm your order</h1>
  <p>Review your details and choose a payment method.</p>
</div>

<% if (orderError != null) { %>
<div style="max-width:1000px; margin:18px auto 0; padding:0 40px;">
  <div style="background:#FFE8E5; border:1px solid var(--chili); border-radius:12px; padding:12px 16px; font-size:0.88rem; color:var(--chili-dark);">
    <%= orderError %>
  </div>
</div>
<% } %>

<form action="confirm" method="post">
<main>

  <div>

    <div class="panel">
      <h3>
        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M21 10c0 7-9 12-9 12s-9-5-9-12a9 9 0 1 1 18 0z"/><circle cx="12" cy="10" r="3"/></svg>
        Delivery to
      </h3>
      <div class="addr-box">
        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M21 10c0 7-9 12-9 12s-9-5-9-12a9 9 0 1 1 18 0z"/><circle cx="12" cy="10" r="3"/></svg>
        <div>
          <strong><%= loggedInUser != null ? loggedInUser.getUsername() : "Guest" %></strong>
          <span>
            <%= delAddr != null ? delAddr : "" %><br>
            <%= delCity != null ? delCity : "" %> <%= delPcode != null ? "- " + delPcode : "" %><br>
            Phone: <%= delPhone != null ? delPhone : "" %>
            <% if (delNote != null && !delNote.isEmpty()) { %>
              <br>Note: <%= delNote %>
            <% } %>
          </span>
        </div>
        <a href="checkout" class="edit-link">Edit</a>
      </div>
    </div>

    <div class="panel">
      <h3>
        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="2" y="6" width="20" height="13" rx="2"/><path d="M2 10h20"/></svg>
        Payment method
      </h3>

      <label class="pay-option">
        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="2" y="6" width="20" height="13" rx="2"/><path d="M2 10h20"/></svg>
        <div>
          UPI
          <span class="pay-sub">Google Pay, PhonePe, Paytm</span>
        </div>
        <input type="radio" name="paymentMethod" value="UPI" checked>
      </label>
      <label class="pay-option">
        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="2" y="6" width="20" height="13" rx="2"/><path d="M2 10h20"/></svg>
        <div>
          Credit / Debit Card
          <span class="pay-sub">Visa, Mastercard, RuPay</span>
        </div>
        <input type="radio" name="paymentMethod" value="CARD">
      </label>
      <label class="pay-option">
        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M3 7h18v10H3z"/><path d="M7 7V5a2 2 0 0 1 2-2h6a2 2 0 0 1 2 2v2"/></svg>
        <div>
          Cash on Delivery
          <span class="pay-sub">Pay when your order arrives</span>
        </div>
        <input type="radio" name="paymentMethod" value="CASH">
      </label>
    </div>

  </div>

  <div>

    <div class="panel">
      <h3>
        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="9" cy="21" r="1"/><circle cx="20" cy="21" r="1"/><path d="M1 1h4l2.7 13.4a2 2 0 0 0 2 1.6h9.7a2 2 0 0 0 2-1.6L23 6H6"/></svg>
        Order summary
      </h3>

      <% if (restaurant != null) { %>
      <div class="cart-restaurant">
        <img src="<%= restaurant.getImageURL() %>" alt="<%= restaurant.getName() %>">
        <div>
          <h4><%= restaurant.getName() %></h4>
          <span><%= restaurant.getCuisineType() %> &middot; Est. <%= restaurant.getDeliveryTime() %> min</span>
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
        <span class="item-price">&#8377;<%= String.format("%.0f", item.getPrice() * item.getQuantity()) %></span>
      </div>
<%
    }
%>
    </div>

    <aside class="summary-card">
      <h3>Bill details</h3>

      <div class="summary-row">
        <span>Item total</span>
        <span>&#8377;<%= String.format("%.2f", itemTotal) %></span>
      </div>
      <div class="summary-row">
        <span>Delivery fee</span>
        <span>&#8377;<%= String.format("%.2f", deliveryFee) %></span>
      </div>
      <div class="summary-row">
        <span>Packaging fee</span>
        <span>&#8377;<%= String.format("%.2f", packagingFee) %></span>
      </div>
      <div class="summary-row discount">
        <span>Discount</span>
        <span>&#8722;&#8377;<%= String.format("%.2f", discount) %></span>
      </div>
      <div class="summary-row">
        <span>Taxes &amp; charges</span>
        <span>&#8377;<%= String.format("%.2f", taxes) %></span>
      </div>

      <div class="summary-divider"></div>

      <div class="summary-total">
        <span>To pay</span>
        <span>&#8377;<%= String.format("%.2f", grandTotal) %></span>
      </div>

      <button type="submit" class="confirm-btn">Confirm &amp; Place Order &#8377;<%= String.format("%.2f", grandTotal) %></button>

      <div class="secure-note">
        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="3" y="11" width="18" height="11" rx="2"/><path d="M7 11V7a5 5 0 0 1 10 0v4"/></svg>
        Safe &amp; secure checkout
      </div>
    </aside>

  </div>

</main>
</form>

</body>
</html>
