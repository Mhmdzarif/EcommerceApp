# ecommerce_application

~State management: Riverpod. Rationale: simple, testable, unidirectional flow with providers that are easy to scope and mock.

~Networking: Dio with interceptors for Authorization header, 401 handling (logout and redirect).

~Local storage: flutter_secure_storage for token persistence; shared_preferences optional for light flags.

~Routing: go_router with guarded routes for auth and admin.

~Prices: stored as integers in the smallest currency unit (cents). Displayed using locale-safe formatting via NumberFormat; conversion helpers included.

~Testing: unit tests for cart math and a widget test for catalog.

~Theming: Material 3 with light/dark support (toggle optional).

~Mobile-first layout; one breakpoint used in catalog grid.

~Edge cases covered: shimmers, pull-to-refresh, empty states, error snackbars, disabled buttons for out-of-stock, 401 -> logout, race conditions on order placement.