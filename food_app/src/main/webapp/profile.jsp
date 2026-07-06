<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.tap.model.User" %>
<%
  User user = (User) session.getAttribute("user");
  if (user == null) {
    response.sendRedirect("login.jsp");
    return;
  }
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Zestora — My Profile</title>
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
  a:focus-visible, label:focus-visible, input:focus-visible, button:focus-visible{
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

  .profile-hero{
    position:relative;
    background: linear-gradient(135deg, var(--ink) 0%, #45291f 60%, var(--chili-dark) 130%);
    color: var(--paper);
    padding: 48px 40px 42px;
    overflow:hidden;
    text-align:center;
  }
  .profile-hero::before{
    content:"";
    position:absolute;
    top:-60px; right:-60px;
    width:280px; height:280px;
    background: radial-gradient(circle, rgba(255,182,39,0.3), transparent 70%);
  }
  .profile-hero-inner{
    position:relative;
    z-index:2;
  }
  .profile-hero .avatar{
    width: 80px;
    height: 80px;
    border-radius: 50%;
    background: var(--gold);
    color: var(--ink);
    display:flex;
    align-items:center;
    justify-content:center;
    margin: 0 auto 16px;
    font-family:'Archivo Black', sans-serif;
    font-size: 2rem;
  }
  .profile-hero h1{
    font-family:'Archivo Black', sans-serif;
    font-size: clamp(1.5rem, 3vw, 2rem);
    margin: 0 0 6px;
  }
  .profile-hero p{
    font-size: 0.96rem;
    opacity:0.85;
    margin:0;
  }
  .profile-hero .role-badge{
    display:inline-block;
    background: var(--teal);
    color:#fff;
    font-size:0.72rem;
    font-weight:800;
    text-transform:uppercase;
    letter-spacing:0.05em;
    padding:4px 12px;
    border-radius:999px;
    margin-top:10px;
  }

  main{
    max-width: 640px;
    margin: 0 auto;
    padding: 40px 20px 100px;
  }

  .profile-card{
    background: var(--card);
    border: 1px solid var(--line);
    border-radius: 18px;
    box-shadow: var(--shadow);
    overflow:hidden;
  }
  .profile-card .section{
    padding: 24px 28px;
  }
  .profile-card .section + .section{
    border-top: 1px solid var(--line);
  }
  .profile-card .section h2{
    font-family:'Archivo Black', sans-serif;
    font-size: 0.95rem;
    margin: 0 0 16px;
    display:flex;
    align-items:center;
    gap:8px;
    color: var(--muted);
    text-transform:uppercase;
    letter-spacing:0.04em;
  }
  .profile-card .section h2 svg{ width:18px; height:18px; color:var(--chili); }
  .detail-row{
    display:flex;
    justify-content: space-between;
    align-items:center;
    padding: 10px 0;
  }
  .detail-row + .detail-row{
    border-top: 1px solid var(--line);
  }
  .detail-row .label{
    font-size:0.84rem;
    color: var(--muted);
    font-weight:600;
  }
  .detail-row .value{
    font-size:0.92rem;
    font-weight:700;
    text-align:right;
    max-width:60%;
    word-break:break-word;
  }

  .logout-wrap{
    padding:20px 28px;
    text-align:center;
  }
  .logout-btn{
    display:inline-block;
    border:none;
    background: var(--chili);
    color:#fff;
    font-weight:800;
    font-size:0.9rem;
    padding: 12px 36px;
    border-radius: 999px;
    cursor:pointer;
    box-shadow: 0 8px 18px rgba(255,77,61,0.3);
    transition: background .15s ease;
  }
  .logout-btn:hover{ background: var(--chili-dark); }

  footer{
    background: var(--ink);
    color: rgba(255,247,236,0.6);
    padding: 24px 40px;
    text-align:center;
    font-size: 0.8rem;
  }

  @media (max-width: 600px){
    .navbar{ padding: 14px 20px; }
    .profile-hero{ padding: 38px 20px 34px; }
    main{ padding: 30px 16px 80px; }
    .profile-card .section{ padding: 20px; }
    .logout-wrap{ padding: 16px 20px; }
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
    <li><a href="profileServlet" class="nav-cta">Profile</a></li>
  </ul>
</nav>

<header class="profile-hero">
  <div class="profile-hero-inner">
    <div class="avatar"><%= user.getUsername().toUpperCase().charAt(0) %></div>
    <h1><%= user.getUsername() %></h1>
    <p>Member since <%= user.getCreateDate() != null ? new java.text.SimpleDateFormat("MMM yyyy").format(user.getCreateDate()) : "N/A" %></p>
    <span class="role-badge"><%= user.getRole().replace("_", " ") %></span>
  </div>
</header>

<main>
  <div class="profile-card">

    <div class="section">
      <h2><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="8" r="4"/><path d="M4 20c0-4 4-6 8-6s8 2 8 6"/></svg> Account Details</h2>
      <div class="detail-row">
        <span class="label">Full Name</span>
        <span class="value"><%= user.getUsername() %></span>
      </div>
      <div class="detail-row">
        <span class="label">Email</span>
        <span class="value"><%= user.getEmail() %></span>
      </div>
      <div class="detail-row">
        <span class="label">Role</span>
        <span class="value"><%= user.getRole().replace("_", " ") %></span>
      </div>
    </div>

    <div class="section">
      <h2><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M12 21s-7-7.2-7-12a7 7 0 1 1 14 0c0 4.8-7 12-7 12z"/><circle cx="12" cy="9" r="2.5"/></svg> Address</h2>
      <div class="detail-row">
        <span class="label">Delivery Address</span>
        <span class="value"><%= user.getAddress() != null ? user.getAddress() : "Not set" %></span>
      </div>
    </div>

    <div class="section">
      <h2><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="9"/><path d="M12 7v5l3 3"/></svg> Activity</h2>
      <div class="detail-row">
        <span class="label">Member Since</span>
        <span class="value"><%= user.getCreateDate() != null ? new java.text.SimpleDateFormat("dd MMM yyyy").format(user.getCreateDate()) : "N/A" %></span>
      </div>
      <div class="detail-row">
        <span class="label">Last Login</span>
        <span class="value"><%= user.getLastLoginDate() != null ? new java.text.SimpleDateFormat("dd MMM yyyy, h:mm a").format(user.getLastLoginDate()) : "N/A" %></span>
      </div>
    </div>

    <div class="logout-wrap">
      <a href="logoutServlet" class="logout-btn">Log out</a>
    </div>

  </div>
</main>

<footer>
  © 2026 Zestora. UI concept for a food delivery app.
</footer>

</body>
</html>
