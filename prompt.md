# 🛒 QuickBasket – Mini Grocery Delivery App
## AI Code Generation Prompt (Kotlin Android)

---

## PROJECT OVERVIEW

Build a fully functional **Mini Grocery Delivery Android App** in **Kotlin** using **XML layouts**,
inspired by Blinkit. Users can browse products by category, add to cart, and place an order.
No real backend is needed — use hardcoded/fake data.

---

## TECH STACK

- **Language:** Kotlin (only)
- **UI:** XML layouts (no Jetpack Compose)
- **Architecture:** MVVM (ViewModel + LiveData)
- **Navigation:** Android Navigation Component (single Activity)
- **RecyclerView:** For all lists (products, categories, cart items)
- **Local Storage:** Room Database (for cart persistence)
- **Image Loading:** Glide
- **Build:** Gradle (Kotlin DSL preferred)
- **Min SDK:** 24 | **Target SDK:** 34

---

## APP SCREENS & FEATURES

### Screen 1: Login / OTP (`LoginActivity` + `OtpFragment`)
- EditText for 10-digit mobile number input
- "Send OTP" Button → navigates to OTP screen
- 4 separate EditText boxes for OTP entry (auto-focus next box on input)
- Fake OTP hardcoded as **1234**
- On correct OTP → navigate to HomeFragment
- Input validation: empty field, invalid number length, wrong OTP toast

### Screen 2: Home Screen (`HomeFragment`)
- Top SearchView (filters products by name in real-time)
- Horizontal RecyclerView for **Category chips** (Fruits, Dairy, Snacks, Beverages, Bakery, Vegetables)
- Clicking a category filters the product grid below
- Vertical Grid RecyclerView (2 columns) for **Products**
  - Each card: product image (use drawable placeholders), name, weight/unit, price (₹), "+ Add" button
  - Clicking "+ Add" shows quantity stepper (– 1 +) inline on the card
  - Cart badge on toolbar icon showing live item count
- Bottom Navigation Bar: Home | Cart | Profile (Profile is placeholder)

### Screen 3: Cart Screen (`CartFragment`)
- RecyclerView list of added items
  - Each row: product image, name, price per unit, quantity stepper (– qty +), subtotal, remove (✕) button
- If cart is empty: show centered empty state illustration + "Shop Now" button
- Sticky bottom card: **Bill Summary**
  - Item total, Delivery fee (flat ₹30, free above ₹500), Grand Total
- "Proceed to Checkout" Button (disabled if cart empty)

### Screen 4: Checkout Screen (`CheckoutFragment`)
- Delivery address input (multi-line EditText)
- Payment method selector:
  - RadioButton: Cash on Delivery (COD)
  - RadioButton: Online Payment (show "Coming Soon" toast if selected)
- Order summary section (read-only, item count + total)
- Validation: address must not be empty
- "Place Order" Button → navigates to OrderSuccessFragment

### Screen 5: Order Success (`OrderSuccessFragment`)
- Animated checkmark (use AnimatedVectorDrawable or simple scale animation)
- Order ID (randomly generated, e.g. `#OX-${random 5-digit number}`)
- Estimated delivery time: "Arriving in 20–30 mins"
- Mini order summary (item count, total paid)
- "Back to Home" button → clears backstack, goes to HomeFragment
- Auto-clear cart after order placed

---

## DATA MODELS

```kotlin
// Product.kt
data class Product(
    val id: Int,
    val name: String,
    val category: String,
    val price: Double,
    val unit: String,         // e.g. "500g", "1L", "dozen"
    val imageRes: Int         // drawable resource id
)

// CartItem.kt
@Entity(tableName = "cart")
data class CartItem(
    @PrimaryKey val productId: Int,
    val name: String,
    val price: Double,
    val imageRes: Int,
    val unit: String,
    var quantity: Int
)

// Order.kt (in-memory only)
data class Order(
    val orderId: String,
    val items: List<CartItem>,
    val total: Double,
    val address: String,
    val paymentMethod: String
)
```

---

## FAKE PRODUCT DATA (seed at least 20 products)

```kotlin
val fakeProducts = listOf(
    Product(1,  "Banana",         "Fruits",     29.0,  "dozen",  R.drawable.ic_banana),
    Product(2,  "Apple",          "Fruits",     120.0, "1kg",    R.drawable.ic_apple),
    Product(3,  "Whole Milk",     "Dairy",      60.0,  "1L",     R.drawable.ic_milk),
    Product(4,  "Paneer",         "Dairy",      85.0,  "200g",   R.drawable.ic_paneer),
    Product(5,  "Bread",          "Bakery",     40.0,  "400g",   R.drawable.ic_bread),
    Product(6,  "Croissant",      "Bakery",     55.0,  "2 pcs",  R.drawable.ic_croissant),
    Product(7,  "Lays Classic",   "Snacks",     20.0,  "26g",    R.drawable.ic_chips),
    Product(8,  "Biscuits",       "Snacks",     30.0,  "100g",   R.drawable.ic_biscuit),
    Product(9,  "Orange Juice",   "Beverages",  99.0,  "1L",     R.drawable.ic_juice),
    Product(10, "Mineral Water",  "Beverages",  20.0,  "1L",     R.drawable.ic_water),
    Product(11, "Tomato",         "Vegetables", 35.0,  "500g",   R.drawable.ic_tomato),
    Product(12, "Spinach",        "Vegetables", 25.0,  "250g",   R.drawable.ic_spinach),
    // ... add 8 more similarly
)
```

> Use simple colored rectangle drawables with text as image placeholders if no real assets exist.

---

## PROJECT STRUCTURE

```
app/
└── src/main/
    ├── java/com/oceanx/quickbasket/
    │   ├── MainActivity.kt
    │   ├── auth/
    │   │   ├── LoginActivity.kt
    │   │   └── OtpFragment.kt
    │   ├── data/
    │   │   ├── model/
    │   │   │   ├── Product.kt
    │   │   │   ├── CartItem.kt
    │   │   │   └── Order.kt
    │   │   ├── db/
    │   │   │   ├── AppDatabase.kt
    │   │   │   └── CartDao.kt
    │   │   └── repository/
    │   │       ├── ProductRepository.kt
    │   │       └── CartRepository.kt
    │   ├── ui/
    │   │   ├── home/
    │   │   │   ├── HomeFragment.kt
    │   │   │   ├── HomeViewModel.kt
    │   │   │   ├── ProductAdapter.kt
    │   │   │   └── CategoryAdapter.kt
    │   │   ├── cart/
    │   │   │   ├── CartFragment.kt
    │   │   │   ├── CartViewModel.kt
    │   │   │   └── CartAdapter.kt
    │   │   ├── checkout/
    │   │   │   ├── CheckoutFragment.kt
    │   │   │   └── CheckoutViewModel.kt
    │   │   └── success/
    │   │       └── OrderSuccessFragment.kt
    │   └── utils/
    │       ├── Constants.kt
    │       └── Extensions.kt
    └── res/
        ├── layout/
        │   ├── activity_main.xml
        │   ├── activity_login.xml
        │   ├── fragment_otp.xml
        │   ├── fragment_home.xml
        │   ├── fragment_cart.xml
        │   ├── fragment_checkout.xml
        │   ├── fragment_order_success.xml
        │   ├── item_product.xml
        │   ├── item_category.xml
        │   └── item_cart.xml
        ├── navigation/
        │   └── nav_graph.xml
        └── values/
            ├── colors.xml       (navy #0D1B40, green #2EC66E, white #FFFFFF)
            ├── strings.xml
            └── themes.xml
```

---

## UI DESIGN TOKENS

```xml
<!-- colors.xml -->
<color name="navy_dark">#0D1B40</color>
<color name="navy_medium">#1A2E5A</color>
<color name="green_primary">#2EC66E</color>
<color name="green_light">#E8F9EF</color>
<color name="text_primary">#1A1A2E</color>
<color name="text_secondary">#6B7280</color>
<color name="background">#F8F9FA</color>
<color name="card_white">#FFFFFF</color>
<color name="error_red">#EF4444</color>
```

- Card corner radius: **16dp**
- Button corner radius: **12dp**
- Elevation on cards: **4dp**
- Font: Default system font is fine; use bold weights for prices and headings
- Bottom Nav tint: navy for selected, gray for unselected

---

## ROOM DATABASE SETUP

```kotlin
@Database(entities = [CartItem::class], version = 1)
abstract class AppDatabase : RoomDatabase() {
    abstract fun cartDao(): CartDao
    
    companion object {
        @Volatile private var INSTANCE: AppDatabase? = null
        fun getInstance(context: Context) = INSTANCE ?: synchronized(this) {
            Room.databaseBuilder(context, AppDatabase::class.java, "quickbasket_db")
                .build().also { INSTANCE = it }
        }
    }
}

@Dao
interface CartDao {
    @Query("SELECT * FROM cart") fun getAllItems(): LiveData<List<CartItem>>
    @Insert(onConflict = OnConflictStrategy.REPLACE) suspend fun insert(item: CartItem)
    @Update suspend fun update(item: CartItem)
    @Delete suspend fun delete(item: CartItem)
    @Query("DELETE FROM cart") suspend fun clearAll()
    @Query("SELECT SUM(price * quantity) FROM cart") fun getTotal(): LiveData<Double>
}
```

---

## NAVIGATION GRAPH (`nav_graph.xml`)

```
LoginActivity
    └── OtpFragment
            ↓ (on success)
MainActivity
    ├── HomeFragment (startDestination)
    │       └── → CartFragment
    ├── CartFragment
    │       └── → CheckoutFragment
    ├── CheckoutFragment
    │       └── → OrderSuccessFragment
    └── OrderSuccessFragment
            └── → HomeFragment (popUpTo HomeFragment, inclusive=false)
```

---

## BONUS FEATURES TO IMPLEMENT

- [ ] MVVM with ViewModel + LiveData throughout (not optional — treat as required)
- [ ] Room DB for cart persistence across app restarts
- [ ] Search filters product list reactively as user types
- [ ] Category filter chips work independently and together with search
- [ ] Cart badge on Home toolbar updates live
- [ ] Smooth RecyclerView item animations (fade-in on add to cart)
- [ ] Empty cart state with illustration
- [ ] Dark mode support via `night/` resource folder

---

## GRADLE DEPENDENCIES (`build.gradle.kts` — app level)

```kotlin
dependencies {
    // Core
    implementation("androidx.core:core-ktx:1.12.0")
    implementation("androidx.appcompat:appcompat:1.6.1")
    implementation("com.google.android.material:material:1.11.0")
    implementation("androidx.constraintlayout:constraintlayout:2.1.4")

    // Navigation
    implementation("androidx.navigation:navigation-fragment-ktx:2.7.6")
    implementation("androidx.navigation:navigation-ui-ktx:2.7.6")

    // ViewModel + LiveData
    implementation("androidx.lifecycle:lifecycle-viewmodel-ktx:2.7.0")
    implementation("androidx.lifecycle:lifecycle-livedata-ktx:2.7.0")

    // Room
    implementation("androidx.room:room-runtime:2.6.1")
    implementation("androidx.room:room-ktx:2.6.1")
    kapt("androidx.room:room-compiler:2.6.1")

    // Glide
    implementation("com.github.bumptech.glide:glide:4.16.0")
    kapt("com.github.bumptech.glide:compiler:4.16.0")

    // Coroutines
    implementation("org.jetbrains.kotlinx:kotlinx-coroutines-android:1.7.3")
}
```

---

## README TEMPLATE (include in repo)

```markdown
# QuickBasket 🛒

A mini grocery delivery app built for OceanX Agency Android Assignment.

## Features
- OTP-based login (fake OTP: 1234)
- Browse products by category
- Search products in real-time
- Add/remove items from cart
- Cart persisted with Room DB
- Checkout with address + payment selection
- Order success screen with order ID

## Tech Stack
Kotlin | MVVM | XML Layouts | Room DB | LiveData | Navigation Component | Glide

## How to Run
1. Clone the repo
2. Open in Android Studio Hedgehog or later
3. Run on emulator (API 24+) or physical device
4. Login with any 10-digit number, OTP: 1234
```

---

## SUBMISSION CHECKLIST

- [ ] GitHub repo with clean commit history
- [ ] APK file (debug build is fine)
- [ ] Screen recording (all 5 screens demonstrated)
- [ ] README.md with features, tech stack, how to run

---

*Generated for OceanX Agency – Kotlin Android Assignment*
*Project: QuickBasket Mini Grocery Delivery App*
