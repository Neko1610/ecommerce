🛒 E-Commerce Fullstack App

Fullstack E-Commerce System gồm Mobile App (Flutter), Backend (Spring Boot) và Admin Dashboard.

🚀 Features
User (Mobile)
Login / Register (Firebase Auth)
Browse products by category
Search products
Product details
Cart & Checkout
Order history
Address management
Admin (Dashboard)
CRUD Category (upload image Cloudinary)
CRUD Product
Manage Users
Manage Voucher
Dashboard statistics
Backend API
RESTful API
Firebase Authentication + JWT
MySQL Database
Cloudinary image upload
🧱 Tech Stack
Frontend Mobile: Flutter
Admin Dashboard: React / NextJS
Backend: Spring Boot
Database: MySQL
Auth: Firebase + JWT
Storage: Cloudinary
📁 Project Structure
ecommerce-system/
│
├── mobile_app/
├── backend/
├── admin_dashboard/
└── README.md
⚙️ Setup
1. Clone
git clone https://github.com/your-username/ecommerce-system.git
cd ecommerce-system
2. Backend
cd backend
./mvnw spring-boot:run

Config (application.properties):

spring.datasource.url=jdbc:mysql://localhost:3306/ecommerce
spring.datasource.username=root
spring.datasource.password=yourpassword

jwt.secret=your_secret
cloudinary.cloud_name=xxx
cloudinary.api_key=xxx
cloudinary.api_secret=xxx
3. Mobile App
cd mobile_app
flutter pub get
flutter run
4. Admin Dashboard
cd admin_dashboard
npm install
npm run dev
🔐 Auth Flow
Firebase Login → ID Token → Backend Verify → JWT → API Access
📡 API
POST /auth/login
GET /products
POST /products
PUT /products/{id}
DELETE /products/{id}
🖼 Image Upload
Upload via backend
Store on Cloudinary
Save URL to database
💰 Currency
Default: USD ($)
🛠 Roadmap
Payment (Stripe / VNPay)
Push Notification
Dark Mode
Product Reviews
👨‍💻 Author

Bảo Nguyễn

📄 License

MIT License
