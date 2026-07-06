<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Zestora — Order Placed</title>
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
    display:flex;
    flex-direction:column;
    align-items:center;
    justify-content:center;
    min-height:100vh;
    padding:40px 20px;
    text-align:center;
  }
  .card{
    background: var(--card);
    border: 1px solid var(--line);
    border-radius: 20px;
    padding: 48px 40px;
    box-shadow: var(--shadow);
    max-width: 460px;
    width:100%;
  }
  .check-icon{
    width: 64px;
    height: 64px;
    border-radius:50%;
    background: var(--teal);
    display:flex;
    align-items:center;
    justify-content:center;
    margin: 0 auto 20px;
  }
  .check-icon svg{ width:32px; height:32px; stroke:#fff; }
  h1{
    font-family:'Archivo Black', sans-serif;
    font-size: 1.5rem;
    margin: 0 0 6px;
  }
  p{ color: var(--muted); font-size: 0.9rem; margin: 0 0 24px; line-height:1.6; }
  .order-id{
    background: var(--paper);
    border-radius: 10px;
    padding: 12px 16px;
    font-size: 0.88rem;
    margin-bottom: 24px;
  }
  .order-id strong{ display:block; font-size: 1.1rem; color: var(--chili); margin-top:4px; }
  .btn{
    display:inline-block;
    background: var(--ink);
    color: var(--paper);
    font-weight:700;
    font-size: 0.9rem;
    padding: 12px 28px;
    border-radius: 999px;
    transition: background .15s ease;
  }
  .btn:hover{ background: var(--chili); }
</style>
</head>
<body>
<%
    Integer orderId = (Integer) session.getAttribute("orderId");
    Boolean success = (Boolean) session.getAttribute("orderSuccess");
    if (success == null || !success) {
        response.sendRedirect("callRestaurantServlet");
        return;
    }
    session.removeAttribute("orderSuccess");
    session.removeAttribute("orderId");
%>
<div class="card">
  <div class="check-icon">
    <svg viewBox="0 0 24 24" fill="none" stroke="white" stroke-width="3"><path d="M5 13l4 4L19 7"/></svg>
  </div>
  <h1>Order Placed!</h1>
  <p>Your order has been placed successfully.<br>We'll start preparing it right away.</p>
  <div class="order-id">
    Order ID
    <strong>#ZEST-<%= String.format("%05d", orderId) %></strong>
  </div>
  <a href="callRestaurantServlet" class="btn">Back to Home</a>
</div>
</body>
</html>
