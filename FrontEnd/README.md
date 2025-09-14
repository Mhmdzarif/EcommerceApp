# Flutter Mini-Ecommerce App

## Features
- User registration and login (token persisted securely)
- Product catalog with out-of-stock badge
- Product details with add-to-cart (stock-aware)
- Cart with quantity controls, subtotal, tax, and total
- Place order (atomic stock decrement handled by backend)
- View past orders
- Admin: add product, view all orders, view low-stock items
- Skeletons/shimmers, pull-to-refresh, empty/error states
- Auth expiry and error handling
- Responsive Material 3 UI

## Tech Stack
- **Flutter** (stable, null-safe Dart)
- **State management:** Riverpod
- **Networking:** Dio
- **Local storage:** flutter_secure_storage
- **Routing:** GoRouter
- **Form validation:** Client-side (register/login/add-product)
- **Testing:** flutter_test (unit, widget)

## API Contract
- `POST /auth/register` `{ email, password }` → `201 { id, email }`
- `POST /auth/login` `{ email, password }` → `200 { token }`
- `GET /products` → `200`
- `POST /products` (admin only) → `201`
- `POST /orders` `{ items: [{ productId, quantity }] }` → `201`
- `GET /orders/me` → `200`
- `GET /admin/orders` → `200`
- `GET /admin/low-stock` → `200`
- Prices are in cents (int, smallest currency unit)

## How to Run
1. Copy `.env.example` to `.env` and set your API base URL
2. Run `flutter pub get`
3. Run `flutter run` (or use your IDE)

## Testing
- Run `flutter test` to execute unit and widget tests
- Cart logic and catalog screen are covered

## Assumptions & Trade-offs
- Backend handles atomic stock decrement and returns clear errors
- Only one breakpoint (mobile-first, responsive)
- Minimal admin features for demo
- No payment integration

## State Management Choice
- **Riverpod** for simplicity, testability, and scalability

## Time Spent
- (Fill in your actual time spent here)

## Optional
- Add a screen recording (GIF/MP4) to demo flows
