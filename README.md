# QuickBasket 🛒

A mini grocery delivery app built for OceanX Agency Android Assignment.

## Features
- 🔐 OTP-based login (fake OTP: **1234**)
- 🏠 Home screen with product grid, category filters, and live search
- 🛒 Cart with quantity steppers, delete, and bill summary
- 💳 Checkout with address input and payment selection
- ✅ Animated order success screen with order ID

## Tech Stack
| | |
|---|---|
| Language | Dart / Flutter |
| State Management | Provider |
| Local Storage | Hive (cart persistence) |
| Image Loading | CachedNetworkImage |
| Fonts | Google Fonts – Plus Jakarta Sans |
| Animations | AnimationController, AnimatedSwitcher, AnimatedContainer |

## Project Structure
```
lib/
├── main.dart
├── core/          # Theme, colors, constants, fake data
├── models/        # Product, CartItem (Hive), Order
├── providers/     # CartProvider, ProductProvider, AuthProvider
└── screens/
    ├── login/     # LoginScreen, OtpScreen
    ├── home/      # HomeScreen (grid, chips, search)
    ├── cart/      # CartScreen
    ├── checkout/  # CheckoutScreen
    └── success/   # OrderSuccessScreen
```

## How to Run
1. Clone the repo
2. Open in Android Studio (Hedgehog or later) or VS Code
3. Run `flutter pub get`
4. Run `flutter run` on an emulator (API 24+) or physical device
5. Login with any **10-digit** number, OTP: **1234**

## APK
A prebuilt debug APK is available at:
`build/app/outputs/flutter-apk/app-debug.apk`

---
*Generated for OceanX Agency – Flutter Android Assignment*  
*Project: QuickBasket Mini Grocery Delivery App*
