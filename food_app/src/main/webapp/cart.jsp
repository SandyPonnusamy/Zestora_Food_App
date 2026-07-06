<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@
page import="java.util.List, com.tap.model.OrderItem, com.tap.model.Menu, com.tap.model.Restaurant"
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Zestora — Your Cart</title>
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
  a:focus-visible, button:focus-visible{
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

  /* ================= PAGE HEADER ================= */
  .page-header{
    max-width: 1100px;
    margin: 0 auto;
    padding: 32px 40px 0;
  }
  .page-header h1{
    font-family:'Archivo Black', sans-serif;
    font-size: clamp(1.6rem, 3vw, 2.1rem);
    margin: 0 0 6px;
  }
  .page-header p{
    font-size: 0.92rem;
    color: var(--muted);
    margin:0;
  }

  /* ================= LAYOUT ================= */
  main{
    max-width: 1100px;
    margin: 0 auto;
    padding: 22px 40px 90px;
    display:grid;
    grid-template-columns: 1.7fr 1fr;
    gap: 28px;
    align-items:start;
  }

  /* ================= RESTAURANT STRIP ================= */
  .cart-restaurant{
    display:flex;
    align-items:center;
    gap: 14px;
    background: var(--card);
    border: 1px solid var(--line);
    border-radius: 14px;
    padding: 14px 18px;
    margin-bottom: 18px;
    box-shadow: var(--shadow);
  }
  .cart-restaurant img{
    width: 54px;
    height: 54px;
    border-radius: 10px;
    object-fit:cover;
    flex-shrink:0;
  }
  .cart-restaurant h2{
    font-family:'Archivo Black', sans-serif;
    font-size: 1.02rem;
    margin: 0 0 3px;
  }
  .cart-restaurant span{
    font-size: 0.8rem;
    color: var(--muted);
  }

  /* ================= CART ITEMS ================= */
  .cart-items{
    background: var(--card);
    border: 1px solid var(--line);
    border-radius: 16px;
    overflow:hidden;
    box-shadow: var(--shadow);
  }

  .cart-item{
    display:flex;
    align-items:center;
    gap: 16px;
    padding: 18px 20px;
    border-bottom: 1px dashed var(--line);
  }
  .cart-item:last-child{ border-bottom:none; }

  .cart-item-img{
    position:relative;
    width: 76px;
    height: 76px;
    border-radius: 12px;
    overflow:hidden;
    flex-shrink:0;
    background:#eee;
  }
  .cart-item-img img{
    width:100%; height:100%;
    object-fit:cover;
  }
  .veg-dot{
    position:absolute;
    top:6px; left:6px;
    width: 16px; height:16px;
    border-radius: 3px;
    background: rgba(255,255,255,0.95);
    display:flex;
    align-items:center;
    justify-content:center;
    border: 1.3px solid var(--teal);
  }
  .veg-dot.nonveg{ border-color: var(--chili); }
  .veg-dot::after{
    content:"";
    width:6px; height:6px;
    border-radius:50%;
    background: var(--teal);
  }
  .veg-dot.nonveg::after{ background: var(--chili); }

  .cart-item-info{
    flex:1;
    min-width:0;
  }
  .cart-item-info h3{
    font-family:'Archivo Black', sans-serif;
    font-size: 0.96rem;
    margin: 0 0 4px;
  }
  .cart-item-info .item-note{
    font-size: 0.78rem;
    color: var(--muted);
    margin: 0 0 8px;
  }
  .cart-item-info .unit-price{
    font-size: 0.82rem;
    color: var(--muted);
    font-weight:600;
  }

  .qty-control{
    display:flex;
    align-items:center;
    gap: 0;
    border: 1.5px solid var(--chili);
    border-radius: 999px;
    overflow:hidden;
    flex-shrink:0;
  }
  .qty-control button{
    border:none;
    background: var(--card);
    color: var(--chili);
    width: 30px;
    height: 30px;
    font-size: 1.05rem;
    font-weight:700;
    cursor:pointer;
    display:flex;
    align-items:center;
    justify-content:center;
  }
  .qty-control button:hover{ background: rgba(255,77,61,0.08); }
  .qty-control .qty-num{
    width: 32px;
    text-align:center;
    font-weight:700;
    font-size: 0.88rem;
  }

  .item-total{
    width: 70px;
    text-align:right;
    font-weight:800;
    font-size: 0.94rem;
    color: var(--chili-dark);
    flex-shrink:0;
  }

  .remove-btn{
    border:none;
    background:none;
    color: var(--muted);
    cursor:pointer;
    flex-shrink:0;
    padding: 4px;
    display:flex;
  }
  .remove-btn:hover{ color: var(--chili); }
  .remove-btn svg{ width:18px; height:18px; }

  /* ================= ADD MORE ITEMS ================= */
  .add-more{
    display:flex;
    align-items:center;
    justify-content: center;
    gap: 8px;
    padding: 16px;
    font-size: 0.86rem;
    font-weight:700;
    color: var(--chili);
    background: rgba(255,77,61,0.04);
    border-top: 1px dashed var(--line);
  }
  .add-more svg{ width:16px; height:16px; }

  /* ================= COUPON ROW ================= */
  .coupon-box{
    background: var(--card);
    border: 1px solid var(--line);
    border-radius: 14px;
    padding: 16px 18px;
    margin-top: 18px;
    display:flex;
    align-items:center;
    justify-content: space-between;
    gap: 12px;
    box-shadow: var(--shadow);
  }
  .coupon-box .coupon-left{
    display:flex;
    align-items:center;
    gap: 12px;
  }
  .coupon-box .coupon-icon{
    width: 38px;
    height: 38px;
    border-radius: 10px;
    background: rgba(255,182,39,0.18);
    display:flex;
    align-items:center;
    justify-content:center;
    flex-shrink:0;
  }
  .coupon-box .coupon-icon svg{ width:19px; height:19px; color: var(--gold); }
  .coupon-box h4{
    font-size: 0.88rem;
    margin: 0 0 2px;
  }
  .coupon-box span{
    font-size: 0.76rem;
    color: var(--muted);
  }
  .apply-btn{
    border: 1.5px solid var(--chili);
    background: none;
    color: var(--chili);
    font-weight:700;
    font-size: 0.8rem;
    padding: 8px 16px;
    border-radius: 999px;
    cursor:pointer;
    flex-shrink:0;
  }
  .apply-btn:hover{ background: var(--chili); color:#fff; }

  /* ================= ORDER SUMMARY ================= */
  .summary-card{
    background: var(--card);
    border: 1px solid var(--line);
    border-radius: 16px;
    padding: 22px 22px 20px;
    box-shadow: var(--shadow);
    position: sticky;
    top: 90px;
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

  .payment-select{
    margin-bottom: 18px;
  }
  .payment-select h4{
    font-size: 0.78rem;
    text-transform: uppercase;
    letter-spacing: 0.04em;
    color: var(--muted);
    margin: 0 0 10px;
  }
  .pay-option{
    display:flex;
    align-items:center;
    gap: 10px;
    border: 1.5px solid var(--line);
    border-radius: 10px;
    padding: 10px 12px;
    margin-bottom: 9px;
    font-size: 0.86rem;
    font-weight:600;
    cursor:pointer;
  }
  .pay-option input[type="radio"]{
    margin-left:auto;
    width:16px;
    height:16px;
    accent-color: var(--chili);
    cursor:pointer;
  }
  .pay-option:has(input:checked){
    border-color: var(--chili);
    background: rgba(255,77,61,0.05);
  }
  .pay-option svg{ width:17px; height:17px; color: var(--teal); flex-shrink:0; }

  .checkout-btn{
    width:100%;
    border:none;
    background: var(--ink);
    color: var(--paper);
    font-weight:800;
    font-size: 0.96rem;
    padding: 14px 0;
    border-radius: 999px;
    cursor:pointer;
    transition: background .15s ease;
  }
  .checkout-btn:hover{ background: var(--chili); }

  .delivery-note{
    display:flex;
    align-items:center;
    gap: 8px;
    margin-top: 14px;
    font-size: 0.78rem;
    color: var(--teal);
    font-weight:600;
    justify-content:center;
  }
  .delivery-note svg{ width:15px; height:15px; }

  /* ================= EMPTY STATE ================= */
  .empty-cart{
    text-align:center;
    padding: 60px 20px;
    background: var(--card);
    border-radius: 16px;
    border: 1px solid var(--line);
    grid-column: 1 / -1;
  }
  .empty-cart svg{ width:64px; height:64px; color: var(--line); margin: 0 auto 16px; }
  .empty-cart h3{ font-family:'Archivo Black', sans-serif; margin: 0 0 8px; }
  .empty-cart p{ color: var(--muted); font-size: 0.88rem; margin: 0 0 18px; }
  .empty-cart a{
    display:inline-block;
    background: var(--chili);
    color:#fff;
    font-weight:700;
    font-size: 0.86rem;
    padding: 10px 22px;
    border-radius: 999px;
  }

  /* ================= RESPONSIVE ================= */
  @media (max-width: 860px){
    main{ grid-template-columns: 1fr; }
    .summary-card{ position:static; }
  }
  @media (max-width: 600px){
    .navbar{ padding: 14px 20px; }
    .page-header{ padding: 26px 20px 0; }
    main{ padding: 18px 20px 70px; }
    .cart-item{ padding: 14px; gap: 12px; }
    .cart-item-img{ width:64px; height:64px; }
    .item-total{ width:56px; font-size:0.86rem; }
  }

  @media (prefers-reduced-motion: reduce){
    *{ transition:none !important; }
  }
</style>
</head>
<body>

<%
    // Expected request attributes set by your CartServlet:
    // - "cartItems"  -> List<OrderItem>  (each OrderItem also needs linked Menu info)
    // - "cartMenus"  -> List<Menu>       (parallel list, same index as cartItems, for name/category/veg etc.)
    // - "restaurant" -> Restaurant       (the single restaurant this cart belongs to)
    // - "itemTotal", "deliveryFee", "packagingFee", "discount", "taxes", "grandTotal" -> Double

    List<OrderItem> cartItems = (List<OrderItem>) request.getAttribute("cartItems");
    List<Menu> cartMenus = (List<Menu>) request.getAttribute("cartMenus");
    Restaurant restaurant = (Restaurant) request.getAttribute("restaurant");

    Double itemTotal    = (Double) request.getAttribute("itemTotal");
    Double deliveryFee   = (Double) request.getAttribute("deliveryFee");
    Double packagingFee  = (Double) request.getAttribute("packagingFee");
    Double discount      = (Double) request.getAttribute("discount");
    Double taxes         = (Double) request.getAttribute("taxes");
    Double grandTotal    = (Double) request.getAttribute("grandTotal");

    boolean isEmpty = (cartItems == null || cartItems.isEmpty());
%>

<nav class="navbar">
  <a href="callRestaurantServlet" class="logo">Zest<span class="dot">ora</span></a>
  <a href="<%= restaurant != null ? "menu?restaurantID=" + restaurant.getRestaurantID() : "callRestaurantServlet" %>" class="back-link">
    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M15 18l-6-6 6-6"/></svg>
    Continue ordering
  </a>
</nav>

<div class="page-header">
  <h1>Your Cart</h1>
  <p>Review your items before checkout.</p>
</div>

<% if (isEmpty) { %>

<main style="display:block;">
  <div class="empty-cart">
    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="9" cy="21" r="1"/><circle cx="20" cy="21" r="1"/><path d="M1 1h4l2.7 13.4a2 2 0 0 0 2 1.6h9.7a2 2 0 0 0 2-1.6L23 6H6"/></svg>
    <h3>Your cart is empty</h3>
    <p>Looks like you haven't added anything yet.</p>
    <a href="callRestaurantServlet">Browse restaurants</a>
  </div>
</main>

<% } else { %>

<main>

  <!-- LEFT: Items -->
  <div>

    <div class="cart-restaurant">
      <img src="<%= restaurant.getImageURL() %>" alt="<%= restaurant.getName() %>">
      <div>
        <h2><%= restaurant.getName() %></h2>
        <span><%= restaurant.getCuisineType() %> · <%= restaurant.getAddress() %></span>
      </div>
    </div>

    <div class="cart-items">

<%
    for (int i = 0; i < cartItems.size(); i++) {
        OrderItem orderItem = cartItems.get(i);
        Menu menu = cartMenus.get(i);
%>
      <div class="cart-item" id="item-<%= menu.getMenuID() %>">
        <div class="cart-item-img">
          <img src="https://images.unsplash.com/photo-1601050690597-df0568f70950?w=200&h=200&fit=crop" alt="<%= menu.getItemName() %>">
          <span class="veg-dot" title="Veg"></span>
        </div>
        <div class="cart-item-info">
          <h3><%= menu.getItemName() %></h3>
          <p class="item-note"><%= menu.getCategory() %></p>
          <span class="unit-price">₹<%= menu.getPrice() %> each</span>
        </div>
        <form action="cartServlet" method="post" style="display:flex;">
          <input type="hidden" name="menuId" value="<%= menu.getMenuID() %>">
          <div class="qty-control">
            <button type="submit" name="action" value="decrease" aria-label="Decrease quantity" <%= orderItem.getQuantity() <= 1 ? "disabled" : "" %>>−</button>
            <span class="qty-num"><%= orderItem.getQuantity() %></span>
            <button type="submit" name="action" value="increase" aria-label="Increase quantity">+</button>
          </div>
        </form>
        <div class="item-total">₹<%= orderItem.getItemTotal() %></div>
        <form action="cartServlet" method="post">
          <input type="hidden" name="menuId" value="<%= menu.getMenuID() %>">
          <input type="hidden" name="action" value="remove">
          <button type="submit" class="remove-btn" aria-label="Remove item">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M3 6h18M8 6V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2m3 0l-1 14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2L4 6"/></svg>
          </button>
        </form>
      </div>
<%
    }
%>
      <a href="menu?restaurantID=<%= restaurant.getRestaurantID() %>" class="add-more">
        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M12 5v14M5 12h14"/></svg>
        Add more items from <%= restaurant.getName() %>
      </a>

    </div>

    <div class="coupon-box">
      <div class="coupon-left">
        <div class="coupon-icon">
          <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M3 12l9-9 9 9-9 9-9-9z"/><circle cx="12" cy="12" r="2"/></svg>
        </div>
        <div>
          <h4>Apply coupon</h4>
          <span>Save more on this order</span>
        </div>
      </div>
      <button class="apply-btn">Apply</button>
    </div>

  </div>

  <!-- RIGHT: Summary -->
  <aside class="summary-card">
    <h3>Order Summary</h3>

    <div class="summary-row">
      <span>Item total</span>
      <span>₹<%= itemTotal %></span>
    </div>
    <div class="summary-row">
      <span>Delivery fee</span>
      <span>₹<%= deliveryFee %></span>
    </div>
    <div class="summary-row">
      <span>Packaging fee</span>
      <span>₹<%= packagingFee %></span>
    </div>
    <div class="summary-row discount">
      <span>Discount</span>
      <span>−₹<%= discount %></span>
    </div>
    <div class="summary-row">
      <span>Taxes & charges</span>
      <span>₹<%= taxes %></span>
    </div>

    <div class="summary-divider"></div>

    <div class="summary-total">
      <span>To pay</span>
      <span>₹<%= grandTotal %></span>
    </div>

    <form action="checkout" method="post">
      <div class="payment-select">
        <h4>Payment method</h4>
        <label class="pay-option">
          <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="2" y="6" width="20" height="13" rx="2"/><path d="M2 10h20"/></svg>
          UPI
          <input type="radio" name="paymentMethod" value="UPI" checked>
        </label>
        <label class="pay-option">
          <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="2" y="6" width="20" height="13" rx="2"/><path d="M2 10h20"/></svg>
          Credit / Debit Card
          <input type="radio" name="paymentMethod" value="CARD">
        </label>
        <label class="pay-option">
          <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M3 7h18v10H3z"/><path d="M7 7V5a2 2 0 0 1 2-2h6a2 2 0 0 1 2 2v2"/></svg>
          Cash on Delivery
          <input type="radio" name="paymentMethod" value="CASH">
        </label>
      </div>

      <button type="submit" class="checkout-btn">Place Order · ₹<%= grandTotal %></button>
    </form>

    <div class="delivery-note">
      <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="9"/><path d="M12 7v5l3 3"/></svg>
      Estimated delivery in <%= restaurant.getDeliveryTime() %> min
    </div>
  </aside>

</main>

<% } %>

</body>
</html>