<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%@
page import = "java.util.List , com.tap.model.Restaurant"
 %>
<%
  List<Restaurant> allRestaurants = (List<Restaurant>)request.getAttribute("allRestaurants");
  if (allRestaurants == null) allRestaurants = new java.util.ArrayList<>();
%>
    
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Zestora — Food delivery near you</title>
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
  a:focus-visible, label:focus-visible, input:focus-visible{
    outline: 3px solid var(--chili-dark);
    outline-offset: 2px;
  }

  /* ================= NAVBAR (CSS-only mobile toggle) ================= */
  #navToggle{ display:none; }

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
    display:flex;
    align-items:center;
    gap:8px;
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
    position:relative;
    padding: 6px 2px;
  }
  .nav-links a::after{
    content:"";
    position:absolute;
    left:0; bottom:-3px;
    width:0%; height:2px;
    background: var(--gold);
    transition: width .2s ease;
  }
  .nav-links a:hover::after{ width:100%; }
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
  .nav-toggle-label{ display:none; background:none; border:none; color:var(--paper); font-size:1.6rem; cursor:pointer; line-height:1; }

  /* ================= HERO ================= */
  .hero{
    position:relative;
    background: linear-gradient(135deg, var(--ink) 0%, #45291f 60%, var(--chili-dark) 130%);
    color: var(--paper);
    padding: 64px 40px 56px;
    overflow:hidden;
  }
  .hero::before{
    content:"";
    position:absolute;
    top:-60px; right:-60px;
    width:320px; height:320px;
    background: radial-gradient(circle, rgba(255,182,39,0.35), transparent 70%);
  }
  .hero-inner{
    max-width: 1280px;
    margin: 0 auto;
    position:relative;
    z-index:2;
  }
  .hero h1{
    font-family:'Archivo Black', sans-serif;
    font-size: clamp(2rem, 4vw, 3.1rem);
    line-height:1.12;
    margin: 0 0 14px;
    max-width: 700px;
  }
  .hero h1 em{ font-style:normal; color: var(--gold); }
  .hero p.sub{
    font-size: 1.02rem;
    opacity:0.85;
    max-width: 540px;
    margin: 0 0 28px;
  }

  .search-row{
    display:flex;
    flex-wrap:wrap;
    gap: 12px;
    max-width: 720px;
  }
  .location-pill{
    display:flex;
    align-items:center;
    gap:8px;
    background: rgba(255,255,255,0.95);
    color: var(--ink);
    border-radius: 999px;
    padding: 13px 18px;
    font-size: 0.9rem;
    font-weight:700;
    flex: 0 0 auto;
    white-space:nowrap;
    border: none;
    font-family:'Inter',sans-serif;
    min-width: 170px;
    cursor: text;
  }
  .location-pill svg{ width:16px; height:16px; color:var(--chili); flex-shrink:0; }
  .location-pill:focus{ outline: 3px solid var(--chili-dark); outline-offset: 2px; }
  .search-box{
    flex: 1 1 280px;
    display:flex;
    background: rgba(255,255,255,0.95);
    border-radius: 999px;
    overflow:hidden;
  }
  .search-box input{
    flex:1;
    border:none;
    background:transparent;
    padding: 13px 18px;
    font-family:'Inter',sans-serif;
    font-size: 0.92rem;
    color: var(--ink);
  }
  .search-box button{
    border:none;
    background: var(--chili);
    color:#fff;
    font-weight:700;
    padding: 0 26px;
    cursor:pointer;
    font-size:0.9rem;
  }
  .search-box button:hover{ background: var(--chili-dark); }

  .stat-row{
    display:flex;
    flex-wrap:wrap;
    gap: 36px;
    margin-top: 38px;
  }
  .stat-row div{
    display:flex;
    flex-direction:column;
    gap:2px;
  }
  .stat-row .num{
    font-family:'Archivo Black', sans-serif;
    font-size: 1.5rem;
    color: var(--gold);
  }
  .stat-row .label{
    font-size: 0.78rem;
    opacity:0.78;
    text-transform: uppercase;
    letter-spacing: 0.05em;
  }

  /* ================= CATEGORY STRIP ================= */
  .categories{
    max-width: 1280px;
    margin: 0 auto;
    padding: 30px 40px 6px;
    display:flex;
    gap: 14px;
    overflow-x:auto;
    scrollbar-width: none;
  }
  .categories::-webkit-scrollbar{ display:none; }
  .cat-chip{
    flex: 0 0 auto;
    display:flex;
    align-items:center;
    gap:8px;
    background: var(--card);
    border: 1px solid var(--line);
    padding: 10px 18px;
    border-radius: 999px;
    font-weight:600;
    font-size: 0.88rem;
    cursor:pointer;
    font-family:'Inter',sans-serif;
    color: var(--ink);
  }
  .cat-chip.active{
    background: var(--ink);
    color: var(--paper);
    border-color: var(--ink);
  }
  .cat-chip .emoji{ font-size: 1.05rem; }

  /* ================= MAIN / FILTER BAR ================= */
  main{
    max-width: 1280px;
    margin: 0 auto;
    padding: 24px 40px 90px;
  }
  .toolbar{
    display:flex;
    flex-wrap:wrap;
    align-items:center;
    justify-content: space-between;
    gap: 16px;
    margin-bottom: 26px;
    padding-bottom: 18px;
    border-bottom: 1px solid var(--line);
  }
  .toolbar h2{
    font-family:'Archivo Black', sans-serif;
    font-size: 1.4rem;
    margin:0;
  }
  .toolbar h2 span{ color: var(--muted); font-family:'Inter',sans-serif; font-weight:600; font-size: 0.95rem; }
  .sort-group{
    display:flex;
    gap: 10px;
    flex-wrap:wrap;
  }
  .sort-btn{
    border: 1px solid var(--line);
    background: var(--card);
    padding: 8px 16px;
    border-radius: 999px;
    font-size: 0.83rem;
    font-weight:600;
    color: var(--ink);
    cursor:pointer;
    font-family:'Inter',sans-serif;
  }
  .sort-btn.active{ background: var(--teal); color:#fff; border-color: var(--teal); }
  .cat-form, .sort-form{ display:inline; }

  /* ================= GRID / CARDS ================= */
  .grid{
    display:grid;
    grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
    gap: 28px;
  }
  .card{
    background: var(--card);
    border-radius: 16px;
    overflow:hidden;
    border:1px solid var(--line);
    display:flex;
    flex-direction:column;
    box-shadow: var(--shadow);
    transition: transform .2s ease, box-shadow .2s ease;
  }
  .card:hover{
    transform: translateY(-6px);
    box-shadow: 0 20px 36px rgba(43,27,23,0.18);
  }
  .card-img-wrap{
    position:relative;
    aspect-ratio: 4/3;
    overflow:hidden;
    background:#eee;
  }
  .card-img-wrap img{
    width:100%; height:100%;
    object-fit:cover;
    transition: transform .4s ease;
  }
  .card:hover .card-img-wrap img{ transform: scale(1.08); }

  .badge{
    position:absolute;
    top:12px; left:12px;
    background: var(--gold);
    color: var(--ink);
    font-size: 0.7rem;
    font-weight:800;
    text-transform: uppercase;
    letter-spacing: 0.03em;
    padding: 5px 10px;
    border-radius: 999px;
  }
  .badge.promo{ background: var(--chili); color:#fff; }

  .veg-dot{
    position:absolute;
    top:12px; right:12px;
    width: 22px; height:22px;
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
    width:9px; height:9px;
    border-radius:50%;
    background: var(--teal);
  }
  .veg-dot.nonveg::after{ background: var(--chili); }

  .rating-stub{
    position:absolute;
    bottom:12px; left:12px;
    background: var(--ink);
    color: var(--gold);
    font-weight:700;
    font-size: 0.85rem;
    padding: 5px 11px 5px 9px;
    border-radius: 5px 12px 12px 5px;
    display:flex;
    align-items:center;
    gap:5px;
    box-shadow: 0 3px 8px rgba(0,0,0,0.3);
  }
  .rating-stub::before{ content:"★"; color: var(--gold); }

  .card-body{
    padding: 16px 18px 18px;
    display:flex;
    flex-direction:column;
    gap: 10px;
    flex:1;
  }
  .card-top{
    display:flex;
    justify-content: space-between;
    align-items:flex-start;
    gap: 8px;
  }
  .card-top h3{
    margin:0;
    font-family:'Archivo Black', sans-serif;
    font-size: 1.08rem;
    line-height:1.25;
  }
  .price-tag{
    flex-shrink:0;
    font-size: 0.78rem;
    font-weight:700;
    color: var(--muted);
    white-space:nowrap;
    background: var(--paper);
    padding: 4px 9px;
    border-radius: 6px;
  }
  .cuisine{
    font-size: 0.84rem;
    color: var(--muted);
    font-weight:500;
  }
  .meta-row{
    display:flex;
    align-items:center;
    gap:6px;
    font-size: 0.84rem;
    color: var(--muted);
  }
  .meta-row svg{ width:14px; height:14px; flex-shrink:0; color: var(--chili); }

  .eta-stub{
    margin-top: auto;
    display:flex;
    align-items:center;
    justify-content: space-between;
    border-top: 1px dashed var(--line);
    padding-top: 12px;
  }
  .eta-stub .label{
    color: var(--muted);
    font-weight:700;
    text-transform: uppercase;
    font-size: 0.68rem;
    letter-spacing: 0.06em;
  }
  .eta-stub .time{
    font-weight:800;
    color: var(--teal);
    font-size: 0.92rem;
  }
  .order-btn{
    border:none;
    background: var(--ink);
    color: var(--paper);
    font-weight:700;
    font-size: 0.78rem;
    padding: 8px 14px;
    border-radius: 8px;
    cursor:pointer;
  }
  .order-btn:hover{ background: var(--chili); }

  /* ================= FOOTER ================= */
  footer{
    background: var(--ink);
    color: rgba(255,247,236,0.85);
    padding: 56px 40px 28px;
  }
  .footer-grid{
    max-width: 1280px;
    margin: 0 auto;
    display:grid;
    grid-template-columns: 1.4fr 1fr 1fr 1fr;
    gap: 36px;
    padding-bottom: 32px;
    border-bottom: 1px solid rgba(255,255,255,0.12);
  }
  .footer-grid .logo{ color: var(--paper); margin-bottom: 10px; }
  .footer-grid p{ font-size: 0.88rem; line-height:1.6; opacity:0.75; max-width: 280px; }
  .footer-grid h4{
    font-size: 0.82rem;
    text-transform: uppercase;
    letter-spacing: 0.05em;
    color: var(--gold);
    margin: 0 0 14px;
  }
  .footer-grid ul li{ margin-bottom: 10px; font-size: 0.88rem; opacity:0.82; }
  .footer-grid ul li a:hover{ color: var(--gold); }
  .footer-bottom{
    max-width: 1280px;
    margin: 0 auto;
    padding-top: 22px;
    display:flex;
    justify-content: space-between;
    flex-wrap:wrap;
    gap: 12px;
    font-size: 0.8rem;
    opacity:0.65;
  }

  /* ================= RESPONSIVE ================= */
  @media (max-width: 900px){
    .footer-grid{ grid-template-columns: 1fr 1fr; }
  }
  @media (max-width: 760px){
    .navbar{ padding: 14px 20px; flex-wrap: wrap; }
    .nav-links{
      order: 3;
      width: 100%;
      max-height: 0;
      overflow: hidden;
      flex-direction: column;
      align-items: flex-start;
      gap: 0;
      transition: max-height .25s ease;
    }
    .nav-links li{ width:100%; padding: 10px 0; }
    #navToggle:checked ~ .navbar .nav-links,
    .navbar:has(#navToggle:checked) .nav-links{
      max-height: 240px;
      margin-top: 14px;
    }
    .nav-toggle-label{ display:block; }
    .hero{ padding: 44px 20px 40px; }
    .categories{ padding: 24px 20px 4px; }
    main{ padding: 22px 20px 70px; }
    .footer-grid{ grid-template-columns: 1fr; padding: 0 0 28px; gap:28px; }
    footer{ padding: 40px 20px 24px; }
  }

  @media (prefers-reduced-motion: reduce){
    *{ transition:none !important; animation:none !important; }
  }
</style>
</head>
<body>

<input type="checkbox" id="navToggle">
<nav class="navbar">
  <a href="#home" class="logo">Zest<span class="dot">ora</span></a>
  <label class="nav-toggle-label" for="navToggle" aria-label="Toggle menu">☰</label>
  <ul class="nav-links">
    <li><a href="#home">Home</a></li>
    <li><a href="login.jsp">Login</a></li>
    <li><a href="register.html">Sign up</a></li>
    <li><a href="profileServlet">Profile</a></li>
    <li><a href="orderHistory" class="nav-cta">Orders</a></li>
  </ul>
</nav>

<header class="hero" id="home">
  <div class="hero-inner">
    <h1>Good food, <em>delivered fast</em>, straight to your door.</h1>
    <p class="sub">Order from handpicked restaurants near you — biryani to bowls, ramen to ragi rotis. Track every step from kitchen to doorstep.</p>

    <form class="search-row" action="callRestaurantServlet" method="GET">
      <label class="location-pill">
        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M12 21s-7-7.2-7-12a7 7 0 1 1 14 0c0 4.8-7 12-7 12z"/><circle cx="12" cy="9" r="2.5"/></svg>
        <input type="text" name="location" list="locations" placeholder="Koramangala" value="<%= request.getParameter("location") != null ? request.getParameter("location") : "" %>" style="border:none;background:transparent;font:inherit;color:inherit;width:140px;padding:0;outline:none;">
      </label>
      <datalist id="locations">
        <option value="Koramangala">
        <option value="Indiranagar">
        <option value="HSR Layout">
        <option value="BTM Layout">
        <option value="Whitefield">
        <option value="Marathahalli">
        <option value="Jayanagar">
        <option value="Domlur">
        <option value="Church Street">
        <option value="MG Road">
        <option value="Electronic City">
        <option value="JP Nagar">
      </datalist>
      <div class="search-box">
        <input type="text" name="search" placeholder="Search restaurants, cuisines or dishes" aria-label="Search restaurants, cuisines or dishes" value="<%= request.getParameter("search") != null ? request.getParameter("search") : "" %>">
        <button type="submit">Search</button>
      </div>
    </form>

    <div class="stat-row">
      <div><span class="num">25 min</span><span class="label">Avg. delivery</span></div>
      <div><span class="num">4.4★</span><span class="label">Avg. rating</span></div>
      <div><span class="num">50k+</span><span class="label">Orders served</span></div>
    </div>
  </div>
</header>

<%
  String currentCategory = request.getParameter("category");
  String currentSort = request.getParameter("sort");
  String currentSearch = request.getParameter("search");
  String currentLocation = request.getParameter("location");
%>
<form class="cat-form" action="callRestaurantServlet" method="GET">
  <input type="hidden" name="search" value="<%= currentSearch != null ? currentSearch : "" %>">
  <input type="hidden" name="location" value="<%= currentLocation != null ? currentLocation : "" %>">
  <input type="hidden" name="sort" value="<%= currentSort != null ? currentSort : "" %>">
  <div class="categories">
    <button type="submit" name="category" value="" class="cat-chip <%= (currentCategory == null || currentCategory.isEmpty()) ? "active" : "" %>"><span class="emoji">🍽️</span> All</button>
    <button type="submit" name="category" value="North Indian" class="cat-chip <%= "North Indian".equals(currentCategory) ? "active" : "" %>"><span class="emoji">🍛</span> North Indian</button>
    <button type="submit" name="category" value="Chinese" class="cat-chip <%= "Chinese".equals(currentCategory) ? "active" : "" %>"><span class="emoji">🥡</span> Chinese</button>
    <button type="submit" name="category" value="Italian" class="cat-chip <%= "Italian".equals(currentCategory) ? "active" : "" %>"><span class="emoji">🍕</span> Italian</button>
    <button type="submit" name="category" value="South Indian" class="cat-chip <%= "South Indian".equals(currentCategory) ? "active" : "" %>"><span class="emoji">🥘</span> South Indian</button>
    <button type="submit" name="category" value="Desserts" class="cat-chip <%= "Desserts".equals(currentCategory) ? "active" : "" %>"><span class="emoji">🍰</span> Desserts</button>
    <button type="submit" name="category" value="Healthy" class="cat-chip <%= "Healthy".equals(currentCategory) ? "active" : "" %>"><span class="emoji">🥗</span> Healthy</button>
    <button type="submit" name="category" value="Seafood" class="cat-chip <%= "Seafood".equals(currentCategory) ? "active" : "" %>"><span class="emoji">🦐</span> Seafood</button>
  </div>
</form>

<main>
  <div class="toolbar">
    <h2>Restaurants near you <span>(<%= allRestaurants.size() %>)</span></h2>
    <form class="sort-form" action="callRestaurantServlet" method="GET">
      <input type="hidden" name="search" value="<%= currentSearch != null ? currentSearch : "" %>">
      <input type="hidden" name="location" value="<%= currentLocation != null ? currentLocation : "" %>">
      <input type="hidden" name="category" value="<%= currentCategory != null ? currentCategory : "" %>">
      <div class="sort-group">
        <button type="submit" name="sort" value="recommended" class="sort-btn <%= (currentSort == null || "recommended".equals(currentSort)) ? "active" : "" %>">Recommended</button>
        <button type="submit" name="sort" value="toprated" class="sort-btn <%= "toprated".equals(currentSort) ? "active" : "" %>">Top rated</button>
        <button type="submit" name="sort" value="fastest" class="sort-btn <%= "fastest".equals(currentSort) ? "active" : "" %>">Fastest delivery</button>
      </div>
    </form>
  </div>

  <div class="grid">
<%
	for (Restaurant restaurant : allRestaurants){
%>

<a href="menu?restaurantID=<%= restaurant.getRestaurantID()%>&restaurantName=<%=restaurant.getName()%>">
<article class="card">
    <div class="card-img-wrap">
         <img src="<%= restaurant.getImageURL() != null ? restaurant.getImageURL() : "https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?w=500&h=375&fit=crop" %>"
              alt="<%= restaurant.getName() %>">

        <% if (restaurant.getBadge() != null && !restaurant.getBadge().isEmpty()) { %>
            <span class="badge"><%= restaurant.getBadge() %></span>
        <% } %>

        <% if(restaurant.getIsVeg() == 1) { %>
            <span class="veg-dot" title="Pure veg"></span>
        <% } else { %>
            <span class="veg-dot nonveg" title="Non-veg available"></span>
        <% } %>

        <span class="rating-stub"><%= restaurant.getRating() %></span>
    </div>

    <div class="card-body">
        <div class="card-top">
            <h3><%= restaurant.getName() %></h3>
            <span class="price-tag"><%= restaurant.getPriceForTwo() != null ? restaurant.getPriceForTwo() : "" %> for two</span>
        </div>

        <div class="cuisine"><%= restaurant.getCuisineType() %></div>

        <div class="meta-row">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                <path d="M12 21s-7-7.2-7-12a7 7 0 1 1 14 0c0 4.8-7 12-7 12z"/>
                <circle cx="12" cy="9" r="2.5"/>
            </svg>
            <%= restaurant.getAddress() %>
        </div>

        <div class="eta-stub">
            <div>
                <div class="label">Delivery in</div>
                <div class="time"><%= restaurant.getDeliveryTime() %> mins</div>
            </div>
            <button class="order-btn">Order now</button>
        </div>
    </div>
</article>
</a>
<% 
	}

%>
    

    
  </div>
</main>

<footer>
  <div class="footer-grid">
    <div>
      <div class="logo">Zest<span class="dot">ora</span></div>
      <p>Connecting you to the best kitchens in town — fresh, fast and reliably on time, every single order.</p>
    </div>
    <div>
      <h4>Company</h4>
      <ul>
        <li><a href="#">About us</a></li>
        <li><a href="#">Careers</a></li>
        <li><a href="#">Press</a></li>
      </ul>
    </div>
    <div>
      <h4>For partners</h4>
      <ul>
        <li><a href="#">Add your restaurant</a></li>
        <li><a href="#">Delivery partner app</a></li>
        <li><a href="#">Partner help</a></li>
      </ul>
    </div>
    <div>
      <h4>Support</h4>
      <ul>
        <li><a href="#">Help centre</a></li>
        <li><a href="orderHistory">Order issues</a></li>
        <li><a href="#">Contact us</a></li>
      </ul>
    </div>
  </div>
  <div class="footer-bottom">
    <span>© 2026 Zestora. UI concept for a food delivery app.</span>
  </div>
</footer>

</body>
</html>