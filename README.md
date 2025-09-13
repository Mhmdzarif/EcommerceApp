--EcommerceApp — Flutter + ASP.NET Core--

A mini ecommerce app implementing auth, catalog, cart, orders, and lightweight admin features. Built with Flutter (frontend) and ASP.NET Core + PostgreSQL(backend) with the use of springboot(maven) + JAVA 17.

--Features:--

~Auth: Register, login, JWT with role‑based access (USER, ADMIN).
~Catalog:Product list with “Out of stock” badge when stock == 0, pull‑to‑refresh.
~Product details:Name, price, stock, description, add to cart.
~Cart:Add/remove/update quantities, subtotal, tax, place order.
~Orders(User):View past orders.
~Admin:Add product, view all orders, view low‑stock items.

--SeededAccounts:--

Admin: admin@shop.com /Password: Admin123!
User: user@shop.com /Password: User123!

--Tech stack--
Frontend: Flutter (stable), Material 3, Dio, flutter_secure_storage.

Backend: ASP.NET Core (.NET 8), EF Core, PostgreSQL, JWT auth.

--Backend (ASP.NET Core)--
Prereqs: .NET 8 SDK, PostgreSQL 14+

Config: Edit EcommerceBackend/Ecommerce.api/appsettings.json

--API QUICKSTART--

Login (admin): POST http://localhost:5264/auth/login
Get products: GET http://localhost:5264/products
Create product (admin): POST http://localhost:5264/products
Create order (user): POST http://localhost:5264/orders

--How to run--
Open the EcommerceBackend/Ecommerce.api directory and type "dotnet run" in a terminal.
In a new window open FrontEnd/ directory and type "Flutter run"
Now the app should be working.
NOTE: if your computer is set to use another port you should fix it so it uses port 5264 as the api calls in this project are set to listen to this port.