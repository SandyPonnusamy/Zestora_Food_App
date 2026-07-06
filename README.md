# Zestora 🍽️

**Zestora** is a full-stack food delivery web application built with Java (Jakarta EE), JSP, and MySQL. It connects hungry customers with nearby restaurants through a seamless ordering experience with real-time order tracking and role-based dashboards.

---

## ✨ Features

### For Customers
- **Browse restaurants** — Explore by cuisine, rating, delivery time, and price
- **Menu browsing** — View items with descriptions, prices, and images per restaurant
- **Shopping cart** — Add/remove items, update quantities with persistence
- **Secure checkout** — UPI, card, or cash on delivery
- **Order history** — Track past orders with status updates
- **User profiles** — Manage personal details and preferences

### For Restaurant Admins
- **Dashboard** — Overview of menu items, orders, and revenue
- **Menu management** — Add, edit, delete dishes with availability toggling
- **Order management** — View incoming orders and update status (Confirmed → Preparing → Out for Delivery → Delivered)
- **Restaurant profile** — Edit restaurant details, toggle active status

### For Delivery Agents
- **Assigned deliveries** — View pending delivery tasks
- **Status updates** — Mark orders as out for delivery or delivered

### For Platform Admins
- **User management** — View and manage all users
- **Restaurant oversight** — Monitor all restaurants and their activity
- **Order monitoring** — Track orders across the platform

### Technical Highlights
- **Role-based access control** — USER, RESTAURANT_ADMIN, DELIVERY_AGENT, ADMIN
- **Secure password storage** — bcrypt hashing (jbcrypt)
- **Cart persistence** — Session-based cart with quantity clamping
- **Responsive UI** — Custom design system with dark/light aesthetic
- **CSS-only animations** — Parallax scrolling, floating elements, hover effects (zero JS)

---

## 🏗 Tech Stack

| Layer | Technology |
|-------|-----------|
| **Frontend** | JSP, HTML5, CSS3 (custom design system) |
| **Backend** | Java 21, Jakarta EE (Servlets), JSP |
| **Database** | MySQL (JDBC) |
| **Authentication** | bcrypt (jbcrypt 0.4) |
| **Server** | Apache Tomcat 10.1 |
| **IDE** | Eclipse (dynamic web project) |

---

## 📁 Project Structure

```
src/
├── main/
│   ├── java/com/tap/
│   │   ├── db/DBConnection.java        # Singleton DB connection
│   │   ├── utility/
│   │   │   ├── DBUtility.java          # Resource close helpers
│   │   │   └── AppLauncher.java        # App entry point
│   │   ├── model/                      # POJOs
│   │   │   ├── User.java
│   │   │   ├── Restaurant.java
│   │   │   ├── Menu.java
│   │   │   ├── Cart.java               # HashMap-based cart
│   │   │   ├── CartItem.java
│   │   │   ├── OrderTable.java
│   │   │   ├── OrderItem.java
│   │   │   └── DeliveryAgent.java
│   │   ├── dao/                        # DAO interfaces
│   │   │   ├── UserDAO.java
│   │   │   ├── RestaurantDAO.java
│   │   │   ├── MenuDAO.java
│   │   │   ├── OrderDAO.java
│   │   │   ├── OrderItemDAO.java
│   │   │   └── DeliveryAgentDAO.java
│   │   ├── daoimpl/                    # DAO implementations
│   │   │   ├── UserDAOImpl.java
│   │   │   ├── RestaurantDAOImpl.java
│   │   │   ├── MenuDAOImpl.java
│   │   │   ├── OrderDAOImpl.java
│   │   │   ├── OrderItemDAOImpl.java
│   │   │   └── DeliveryAgentDAOImpl.java
│   │   └── servlets/                   # Controllers
│   │       ├── LoginServlet.java
│   │       ├── RegisterServlet.java
│   │       ├── LogoutServlet.java
│   │       ├── ProfileServlet.java
│   │       ├── RestaurantServlet.java
│   │       ├── MenuServlet.java
│   │       ├── CartServlet.java
│   │       ├── CheckoutServlet.java
│   │       ├── ConfirmServlet.java
│   │       ├── OrderHistoryServlet.java
│   │       ├── AdminServlet.java
│   │       ├── AdminPlatformServlet.java
│   │       └── DeliveryAgentServlet.java
│   └── webapp/                         # JSP views & static assets
│       ├── index.jsp                   # Landing page
│       ├── login.jsp                   # Login page
│       ├── register.html               # Registration page
│       ├── restaurant.jsp / Restaurant.html
│       ├── menu.jsp / menu.html
│       ├── cart.jsp
│       ├── checkout.jsp
│       ├── confirm.jsp
│       ├── profile.jsp
│       ├── orders.jsp / orderSuccess.jsp
│       ├── adminDashboard.jsp
│       ├── adminPlatform.jsp
│       ├── adminOrderDetails.jsp
│       ├── agentDashboard.jsp
│       └── WEB-INF/
│           ├── web.xml
│           └── lib/
│               ├── mysql-connector-j-9.7.0.jar
│               └── jbcrypt-0.4.jar
```

---

## 🚀 Getting Started

### Prerequisites
- **Java 21+** (JDK)
- **Apache Tomcat 10.1+**
- **MySQL 8+**
- **Eclipse IDE** (for development — or deploy the built WAR manually)

### Setup

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/zestora.git
   cd zestora
   ```

2. **Set up the database**
   ```sql
   CREATE DATABASE food_app;
   USE food_app;
   -- Run the SQL script (provided separately or inferred from DAO implementations)
   ```

3. **Configure database credentials**  
   Update `DBConnection.java` with your MySQL host, username, and password.

4. **Deploy to Tomcat**
   - Import as an existing dynamic web project in Eclipse
   - Add Tomcat 10.1 as the runtime server
   - Deploy and run on the server

5. **Access the application**  
   Open `http://localhost:8080/food_app/`

---

## 🧠 Architecture

Zestora follows the **MVC (Model-View-Controller)** pattern:

- **Model** — POJOs in `com.tap.model` represent the domain entities
- **DAO** — Interfaces in `com.tap.dao` define data access contracts; implementations in `com.tap.daoimpl` handle MySQL queries
- **View** — JSP files in `src/main/webapp` render the UI
- **Controller** — Servlets in `com.tap.servlets` handle HTTP requests, orchestrate business logic, and forward to views

### Database Schema

The database uses the following core tables:
- `users` — User accounts with roles
- `restaurants` — Restaurant profiles linked to admin users
- `menu` — Menu items per restaurant
- `orders` — Order headers with status tracking
- `order_items` — Line items per order
- `delivery_agents` — Agent profiles linked to users

### Order Status Flow

```
PENDING → CONFIRMED → PREPARING → OUT_FOR_DELIVERY → DELIVERED
                                                      ↘ CANCELLED
```

---

## 🎨 Design System

Zestora features a custom design system with CSS custom properties:

| Token | Value | Usage |
|-------|-------|-------|
| `--ink` | `#2B1B17` | Primary text / dark backgrounds |
| `--paper` | `#FFF7EC` | Page background |
| `--card` | `#FFFFFF` | Card surfaces |
| `--chili` | `#FF4D3D` | Primary accent / CTA |
| `--gold` | `#FFB627` | Secondary accent / highlights |
| `--teal` | `#1B998B` | Success / ratings |

The interface is fully responsive with breakpoints at 1100px, 860px, and 600px, and respects `prefers-reduced-motion`.

---

## 📸 Screenshots

> *Add screenshots of the landing page, restaurant listing, cart, admin dashboard, and agent dashboard here.*

---

## 🤝 Contributing

Contributions are welcome! Feel free to open issues or submit pull requests.

---

## 📄 License

This project is for educational purposes. All restaurant names, images, and data are placeholders used for demonstration.

---

<p align="center">Built with ❤ for food lovers.</p>
