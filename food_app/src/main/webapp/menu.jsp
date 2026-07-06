<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%@ page import="java.util.List,com.tap.model.Menu" %>
<%@ page import="com.tap.model.Cart" %>
<%@ page import="com.tap.model.Restaurant" %>
<%@ page import="com.tap.daoimpl.RestaurantDAOImpl" %>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Zestora — Spice Garden Menu</title>
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

  .resto-header{
    position:relative;
    background: linear-gradient(135deg, var(--ink) 0%, #45291f 60%, var(--chili-dark) 130%);
    color: var(--paper);
    padding: 40px 40px 32px;
    overflow:hidden;
  }
  .resto-header::before{
    content:"";
    position:absolute;
    top:-60px; right:-60px;
    width:280px; height:280px;
    background: radial-gradient(circle, rgba(255,182,39,0.3), transparent 70%);
  }
  .resto-header-inner{
    max-width: 1100px;
    margin: 0 auto;
    position:relative;
    z-index:2;
    display:flex;
    gap: 24px;
    align-items:flex-end;
    flex-wrap:wrap;
  }
  .resto-thumb{
    width: 110px;
    height: 110px;
    border-radius: 16px;
    overflow:hidden;
    border: 3px solid rgba(255,255,255,0.2);
    flex-shrink:0;
    box-shadow: 0 10px 24px rgba(0,0,0,0.3);
  }
  .resto-thumb img{ width:100%; height:100%; object-fit:cover; }
  .resto-info h1{
    font-family:'Archivo Black', sans-serif;
    font-size: clamp(1.5rem, 3vw, 2.1rem);
    margin: 0 0 6px;
  }
  .resto-meta{
    display:flex;
    align-items:center;
    flex-wrap:wrap;
    gap: 14px;
    font-size: 0.88rem;
    opacity:0.9;
  }
  .resto-meta .pill{
    display:flex;
    align-items:center;
    gap:5px;
  }
  .resto-meta .rating-pill{
    background: var(--teal);
    color:#fff;
    font-weight:700;
    padding: 4px 10px;
    border-radius: 6px;
  }
  .resto-meta .rating-pill::before{ content:"★ "; }
  .resto-meta svg{ width:14px; height:14px; color: var(--gold); }

  .menu-tabs{
    max-width: 1100px;
    margin: 0 auto;
    padding: 24px 40px 0;
    display:flex;
    gap: 12px;
    overflow-x:auto;
    scrollbar-width:none;
  }
  .menu-tabs::-webkit-scrollbar{ display:none; }
  .tab-chip{
    flex:0 0 auto;
    background: var(--card);
    border: 1px solid var(--line);
    padding: 9px 18px;
    border-radius: 999px;
    font-weight:600;
    font-size: 0.86rem;
    cursor:pointer;
    font-family:'Inter',sans-serif;
    color: var(--ink);
  }
  .tab-chip.active{
    background: var(--chili);
    color:#fff;
    border-color: var(--chili);
  }

  main{
    max-width: 1100px;
    margin: 0 auto;
    padding: 28px 40px 90px;
  }
  .section-block{ margin-bottom: 38px; }
  .section-title{
    font-family:'Archivo Black', sans-serif;
    font-size: 1.2rem;
    margin: 0 0 16px;
    display:flex;
    align-items:center;
    gap:10px;
  }
  .section-title .count{
    font-family:'Inter',sans-serif;
    font-weight:600;
    font-size: 0.85rem;
    color: var(--muted);
  }

  .menu-grid{
    display:grid;
    grid-template-columns: repeat(auto-fill, minmax(260px, 1fr));
    gap: 20px;
  }

  .item-card{
    background: var(--card);
    border: 1px solid var(--line);
    border-radius: 14px;
    overflow:hidden;
    display:flex;
    flex-direction:column;
    box-shadow: var(--shadow);
    transition: transform .2s ease, box-shadow .2s ease;
  }
  .item-card:hover{
    transform: translateY(-4px);
    box-shadow: 0 18px 32px rgba(43,27,23,0.16);
  }
  .item-img-wrap{
    position:relative;
    aspect-ratio: 4/3;
    overflow:hidden;
    background:#eee;
  }
  .item-img-wrap img{
    width:100%; height:100%;
    object-fit:cover;
    transition: transform .4s ease;
  }
  .item-card:hover .item-img-wrap img{ transform: scale(1.07); }

  .veg-dot{
    position:absolute;
    top:10px; left:10px;
    width: 20px; height:20px;
    border-radius: 4px;
    background: rgba(255,255,255,0.95);
    display:flex;
    align-items:center;
    justify-content:center;
    border: 1.5px solid var(--teal);
  }
  .veg-dot.nonveg{ border-color: var(--chili); }
  .veg-dot::after{
    content:"";
    width:8px; height:8px;
    border-radius:50%;
    background: var(--teal);
  }
  .veg-dot.nonveg::after{ background: var(--chili); }

  .item-badge{
    position:absolute;
    top:10px; right:10px;
    background: var(--gold);
    color: var(--ink);
    font-size: 0.66rem;
    font-weight:800;
    text-transform: uppercase;
    letter-spacing: 0.03em;
    padding: 4px 9px;
    border-radius: 999px;
  }
  .item-badge.spicy{ background: var(--chili); color:#fff; }

  .item-rating{
    position:absolute;
    bottom:10px; left:10px;
    background: var(--ink);
    color: var(--gold);
    font-weight:700;
    font-size: 0.78rem;
    padding: 4px 10px 4px 8px;
    border-radius: 5px 10px 10px 5px;
    display:flex;
    align-items:center;
    gap:4px;
    box-shadow: 0 3px 8px rgba(0,0,0,0.3);
  }
  .item-rating::before{ content:"★"; color: var(--gold); }

  .item-body{
    padding: 14px 16px 16px;
    display:flex;
    flex-direction:column;
    gap: 8px;
    flex:1;
  }
  .item-top{
    display:flex;
    justify-content: space-between;
    align-items:flex-start;
    gap: 8px;
  }
  .item-top h3{
    margin:0;
    font-family:'Archivo Black', sans-serif;
    font-size: 0.98rem;
    line-height:1.3;
  }
  .item-price{
    flex-shrink:0;
    font-size: 0.92rem;
    font-weight:800;
    color: var(--chili-dark);
    white-space:nowrap;
  }
  .item-desc{
    font-size: 0.8rem;
    color: var(--muted);
    line-height:1.5;
    margin:0;
    display:-webkit-box;
    -webkit-line-clamp: 2;
    -webkit-box-orient: vertical;
    overflow:hidden;
  }

  .item-footer{
    margin-top: auto;
    display:flex;
    align-items:center;
    justify-content: space-between;
    border-top: 1px dashed var(--line);
    padding-top: 10px;
  }
  .item-footer .category-tag{
    font-size: 0.7rem;
    font-weight:700;
    color: var(--teal);
    text-transform: uppercase;
    letter-spacing: 0.04em;
  }
  .add-btn{
    display:inline-block;
    border:none;
    background: var(--ink);
    color: var(--paper);
    font-weight:700;
    font-size: 0.78rem;
    padding: 7px 16px;
    border-radius: 8px;
    cursor:pointer;
    text-align:center;
    line-height:1.4;
  }
  .add-btn:hover{ background: var(--chili); }
  .add-btn.unavailable{
    background: var(--line);
    color: var(--muted);
    cursor:not-allowed;
  }
  .item-footer form{
    display:flex;
    align-items:center;
    margin:0;
  }

  @media (max-width: 760px){
    .navbar{ padding: 14px 20px; }
    .resto-header{ padding: 32px 20px 26px; }
    .resto-thumb{ width:84px; height:84px; }
    .menu-tabs{ padding: 20px 20px 0; }
    main{ padding: 24px 20px 70px; }
  }

  .cart-icon-link{
    position:relative;
    display:flex;
    align-items:center;
    justify-content:center;
    width: 38px;
    height: 38px;
    border-radius: 999px;
    background: rgba(255,255,255,0.1);
    color: var(--paper);
  }
  .cart-icon-link:hover{ background: rgba(255,255,255,0.18); }
  .cart-icon-link svg{ width:19px; height:19px; }
  .cart-count-badge{
    position:absolute;
    top:-6px; right:-6px;
    min-width: 18px;
    height: 18px;
    padding: 0 4px;
    border-radius: 999px;
    background: var(--chili);
    color:#fff;
    font-size: 0.68rem;
    font-weight:800;
    display:flex;
    align-items:center;
    justify-content:center;
    line-height:1;
    box-shadow: 0 0 0 2px var(--ink);
  }
  /* Pure-CSS popup: the overlay is hidden by default and only shown when
     its #id matches the URL fragment (the :target pseudo-class). Clicking
     an <a href="#confirm-switch-123"> "opens" it; clicking <a href="#">
     points at nothing, so no element is :target, which "closes" it again.
     No JavaScript involved anywhere in this. */
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
  .modal-overlay:target{
    display:flex;
  }
  .modal-box{
    background: var(--paper);
    border-radius:16px;
    padding:26px;
    max-width:380px;
    width:100%;
    text-align:center;
    box-shadow: 0 16px 50px rgba(0,0,0,0.35);
  }
  .modal-box h3{
    margin:0 0 10px;
    font-family:'Archivo Black', sans-serif;
    font-size:1.1rem;
  }
  .modal-box p{
    margin:0;
    color: var(--muted);
    font-size:0.92rem;
    line-height:1.5;
  }
  .modal-actions{
    display:flex;
    gap:10px;
    justify-content:center;
    margin-top:20px;
  }
  .modal-btn{
    padding:10px 18px;
    border-radius:10px;
    font-weight:700;
    font-size:0.9rem;
    cursor:pointer;
    border:none;
    text-decoration:none;
    display:inline-block;
  }
  .modal-btn.cancel{ background:#eee; color:var(--ink); }
  .modal-btn.confirm{ background:var(--chili); color:#fff; }

  @media (prefers-reduced-motion: reduce){
    *{ transition:none !important; }
  }
</style>
</head>
<body>

<%@ page import="com.tap.model.Cart" %>
<%
  Cart sessionCart = (Cart) session.getAttribute("cart");
  int initialCartCount = (sessionCart != null) ? sessionCart.getTotalItemCount() : 0;

  Integer sessionRestaurantId = (Integer) session.getAttribute("restaurantId");
  int currentRestaurantId = Integer.parseInt(request.getParameter("restaurantID"));

  // True only when the cart already has items AND they belong to a
  // different restaurant than the one being viewed right now.
  boolean needsSwitchConfirm = sessionCart != null && !sessionCart.isEmpty()
        && sessionRestaurantId != null && sessionRestaurantId != currentRestaurantId;

  String oldRestaurantName = "";
  String currentRestaurantName = "";
  if (needsSwitchConfirm) {
      RestaurantDAOImpl restaurantDAOImpl = new RestaurantDAOImpl();
      Restaurant oldR = restaurantDAOImpl.getRestaurantByID(sessionRestaurantId);
      Restaurant newR = restaurantDAOImpl.getRestaurantByID(currentRestaurantId);
      oldRestaurantName = (oldR != null) ? oldR.getName() : "the other restaurant";
      currentRestaurantName = (newR != null) ? newR.getName() : "this restaurant";
  }
%>
<nav class="navbar">
  <a href="#" class="logo">Zest<span class="dot">ora</span></a>
  <div style="display:flex; align-items:center; gap:12px;">
    <a href="callRestaurantServlet" class="back-link">
      <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M15 18l-6-6 6-6"/></svg>
      Back to restaurants
    </a>
    <a href="cartServlet" id="cartIconLink" class="cart-icon-link">
      <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="9" cy="21" r="1"/><circle cx="20" cy="21" r="1"/><path d="M1 1h4l2.7 13.4a2 2 0 0 0 2 1.6h9.7a2 2 0 0 0 2-1.6L23 6H6"/></svg>
      <span id="cartCount" class="cart-count-badge" style="<%= initialCartCount == 0 ? "display:none;" : "" %>"><%= initialCartCount %></span>
    </a>
  </div>
</nav>

<header class="resto-header">
  <div class="resto-header-inner">
    <div class="resto-thumb">
      <img src="https://images.unsplash.com/photo-1565557623262-b51c2513a641?w=200&h=200&fit=crop" alt="Spice Garden">
    </div>
    <div class="resto-info">
      <h1>Spice Garden</h1>
      <div class="resto-meta">
        <span class="pill rating-pill">4.5</span>
        <span class="pill">North Indian · Mughlai</span>
        <span class="pill">
          <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="9"/><path d="M12 7v5l3 3"/></svg>
          28-33 min
        </span>
        <span class="pill">MG Road, Bangalore</span>
      </div>
    </div>
  </div>
</header>

<%
  String currentMenuCategory = request.getParameter("category");
%>
<form class="menu-tabs" action="menu" method="GET">
  <input type="hidden" name="restaurantID" value="<%= request.getParameter("restaurantID") %>">
  <button type="submit" name="category" value="" class="tab-chip <%= (currentMenuCategory == null || currentMenuCategory.isEmpty()) ? "active" : "" %>">All</button>
  <button type="submit" name="category" value="Starters" class="tab-chip <%= "Starters".equals(currentMenuCategory) ? "active" : "" %>">Starters</button>
  <button type="submit" name="category" value="Main Course" class="tab-chip <%= "Main Course".equals(currentMenuCategory) ? "active" : "" %>">Main Course</button>
  <button type="submit" name="category" value="Breads" class="tab-chip <%= "Breads".equals(currentMenuCategory) ? "active" : "" %>">Breads</button>
  <button type="submit" name="category" value="Desserts" class="tab-chip <%= "Desserts".equals(currentMenuCategory) ? "active" : "" %>">Desserts</button>
  <button type="submit" name="category" value="Beverages" class="tab-chip <%= "Beverages".equals(currentMenuCategory) ? "active" : "" %>">Beverages</button>
</form>

<main>

  <div class="section-block">
<%
List<Menu> allMenuByRestaurant = (List<Menu>)request.getAttribute("allMenuByRestaurant");
int itemCount = (allMenuByRestaurant != null) ? allMenuByRestaurant.size() : 0;
String catTitle = (currentMenuCategory != null && !currentMenuCategory.isEmpty()) ? currentMenuCategory : "All Items";
%>
    <h2 class="section-title"><%= catTitle %> <span class="count">(<%= itemCount %> items)</span></h2>
    <div class="menu-grid">

<%
if (allMenuByRestaurant != null) {
    for (Menu menu : allMenuByRestaurant) {
%>
      <article class="item-card" id="item-<%= menu.getMenuID() %>">
        <div class="item-img-wrap">
<img src="<%= (menu.getImageURL() != null && !menu.getImageURL().isEmpty()) ? menu.getImageURL() : "https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?w=400&h=300&fit=crop" %>" alt="<%= menu.getItemName() %>">

          <% if (menu.getIsAvailable() == 0) { %>
            <span class="item-badge spicy">Sold Out</span>
          <% } %>

          <span class="item-rating">4.5</span>
        </div>
        <div class="item-body">
          <div class="item-top">
            <h3><%= menu.getItemName() %></h3>
            <span class="item-price">₹<%= menu.getPrice() %></span>
          </div>
          <p class="item-desc"><%= menu.getDescription() %></p>
          <div class="item-footer">
            <span class="category-tag"><%= menu.getCategory() %></span>

            <% if (menu.getIsAvailable() == 1) {
                 if (needsSwitchConfirm) { %>
              <a href="#confirm-switch-<%= menu.getMenuID() %>" class="add-btn">Add +</a>
                 <% } else { %>
              <form action="cartServlet" method="post">
                <input type="hidden" name="menuId" value="<%= menu.getMenuID() %>">
                <input type="hidden" name="restaurantId" value="<%= menu.getRestaurantID() %>">
                <input type="hidden" name="quantity" value="1">
                <input type="hidden" name="action" value="add">
                <button type="submit" class="add-btn">Add +</button>
              </form>
                 <% }
               } else { %>
              <button class="add-btn unavailable" disabled>Sold out</button>
            <% } %>

          </div>
        </div>
      </article>
<%
    }
}
%>

    </div>
  </div>

</main>

<%
// IMPORTANT — structural fix: these modals must NOT live inside .item-card.
// .item-card:hover applies a CSS transform, and any ancestor with a
// transform becomes a new "containing block" for position:fixed children.
// With the modal nested inside the card, every time the cursor crossed the
// card's hover boundary (extremely easy to do while reaching for buttons
// inside the popup) the card's hover-transform toggled on/off, and the
// "fixed" modal — anchored to that transformed ancestor instead of the
// viewport — visibly shifted by the same few pixels each time. That was
// the "dancing." Rendering them here, as flat siblings at the bottom of
// <body>, guarantees they're never inside anything with a transform, so
// position:fixed is always relative to the real viewport and stays put.
if (allMenuByRestaurant != null) {
    for (Menu menu : allMenuByRestaurant) {
        if (menu.getIsAvailable() == 1 && needsSwitchConfirm) {
%>
  <div class="modal-overlay" id="confirm-switch-<%= menu.getMenuID() %>">
    <div class="modal-box">
      <h3>Switch restaurant?</h3>
      <p>
        Your cart has items from <strong><%= oldRestaurantName %></strong>.
        Adding food from <strong><%= currentRestaurantName %></strong> will clear your old cart.
      </p>
      <div class="modal-actions">
        <a href="#close-modal" class="modal-btn cancel">Cancel</a>
        <form action="cartServlet" method="post">
          <input type="hidden" name="menuId" value="<%= menu.getMenuID() %>">
          <input type="hidden" name="restaurantId" value="<%= menu.getRestaurantID() %>">
          <input type="hidden" name="quantity" value="1">
          <input type="hidden" name="action" value="add">
          <input type="hidden" name="confirmSwitch" value="yes">
          <button type="submit" class="modal-btn confirm">Yes, switch &amp; add</button>
        </form>
      </div>
    </div>
  </div>
<%
        }
    }
}
%>

</body>
</html>