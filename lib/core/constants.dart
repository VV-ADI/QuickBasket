import '../models/product.dart';

class AppConstants {
  // Fake OTP
  static const String correctOtp = '1234';

  // Delivery fee
  static const double deliveryFee = 30.0;
  static const double freeDeliveryThreshold = 500.0;

  // Categories
  static const List<String> categories = [
    'All',
    'Fruits',
    'Dairy',
    'Snacks',
    'Beverages',
    'Bakery',
    'Vegetables',
  ];

  static const Map<String, String> categoryIcons = {
    'All': 'apps',
    'Fruits': 'nutrition',
    'Dairy': 'water_drop',
    'Snacks': 'cookie',
    'Beverages': 'local_cafe',
    'Bakery': 'bakery_dining',
    'Vegetables': 'eco',
  };

  // Fake Products (20+)
  static final List<Product> products = [
    // Fruits
    Product(
      id: 1,
      name: 'Fresh Red Apples, Premium Quality',
      category: 'Fruits',
      price: 120,
      unit: '1 kg',
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuBnzCvKfRD_9nqOsuiBS8_EKBqIC5NUWR3LkicMiJ88ypi2lKoOpqFaqseLA2e6v_BBIXMA1iIyhB1E1LkFlaFvS2r6ZjI-Tbc83uXFEUYDMzQ7nMdxF4KqMfApKpA1aMybMptdHCE64HF2njaTROa_OQMYn68mfg4D5XcDKtfttfQbF9-f2f9SqHHkJHHB4pS3O4CSyjDx7C0ql8EAJ8gjQdAQPlTHaWlTZrKXslnwsy0THBwuv5hG2UcXm7M-OP1bWE93ttJ8yeI',
      badge: 'Offer',
    ),
    Product(
      id: 2,
      name: 'Organic Bananas Robusta',
      category: 'Fruits',
      price: 65,
      unit: '6 pcs',
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuA_FpfYxmVWzPlpyNxyvU5IA2x5pCIsp0gjC_Xgn-O2wF05EZzMtquqGyvjtUP6wIZtHec9BymejSTfDlD0AT-Tc93jHv1UyIui8nLJiWhScB-k1Zt5vV3KKff4imUMxwrk5LjKp6VcT9f2Lcyfnciy6XSFQ-liT_2OAJCuz7v97M3Dm4scASDjCHF72WZ1PDDdalMz9EKB10yjqSZcYMUg0nchC2bnhM1U30Alv480LjSgYD2x_P2Hmbpe2OhYPsXu6XGt8yX9I2w',
    ),
    Product(
      id: 3,
      name: 'Fresh Pineapple',
      category: 'Fruits',
      price: 90,
      unit: '1 pc (Approx 800g)',
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuBS1VtR6M6ao1FVEzMBIgzPMyjdl8XZWn-Zcow1lloqsMJDJWxjw0n7udO-iZkZPbmHUKlsLn9Y2IMxIOuZClnDBDHqHUl4tGnI4CdLLXmGkmvf7iA1vi09sRHT2KbsPI01tUcAHPLQtPKD2OA0M0amkKAAkNbr5DfSX5jcFMCzC8HMJCw-I4IDACAy2Eb8enWu-ZhBr4crI-_wVnNcOSudvuvp9BFQUhZoUKKnemkaq4E2b6Tn0qfyfcyWGWcCx-qLxnsDqUbnPOE',
    ),
    Product(
      id: 4,
      name: 'Green Grapes Seedless',
      category: 'Fruits',
      price: 110,
      unit: '500g',
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuBN0TR7gRUq-DRv_ktF-141YNG4Pyb8-x8pOeahs-nn8_LdRu1re2gom4v33DEjWwSHBLPE58yy_w7SLkilt_Ty73Bf0XnMEG0YzYYsfibAMYhvZJNd50ZNsZrb7q68Ujuc0a0bG_oSFkcHybeGirWwQBoFTQNDPMz06AK8FPA7NoIHN0Qtqn68jja7A65UT-Kfg2ZK_f-Zp-13dx5q3uSyXu7Gr4HI6SMFaPXxR90ypz83Fn4bEhVOzi3darHmNC4B4fjQlqEG_4E',
    ),
    Product(
      id: 5,
      name: 'Alphonso Mangoes',
      category: 'Fruits',
      price: 250,
      unit: '4 pcs',
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuAEZQVbzsL-xfev4lCmyZVgcnuzRxiIL1X_HwsmhBamyEj4DJPV7jMFXwcFOJlNXfw3uJZwLAUU3P-O9sDtBylom4J98OVIRUC4QGHhPsrGnm9DLorISwyImjPSRI8cCnsCXhbn0kqFkahEcEzrlqctci9l3vldnfMIzcQEUKYsfdfHpa_43kkzCqDASdsCn3gxrt-PzmB_8smAQ1OaTWUHFEbkKwfkeQR4YOLq37rQ6G23m29Ppsf8_-mXfBo_jwV2QVVsXHfqT4Y',
    ),
    Product(
      id: 6,
      name: 'Kiran Watermelon',
      category: 'Fruits',
      price: 80,
      unit: '1 pc (2–3 kg)',
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuAu9qXWoFSbDkh788LYq74GF9-cdugfth8ChS9upZXPV_nw1Ldb_AMKgLFfslz6naYmGunmWOHGK4m-f7vcl_hWojmxMHEbbMcgu5h1SOm2hOWdTZjUJBB5PW0Vu5U-X-Hxyqanpy2xdatG4DElGsfAy7kx_gOpDJ4yvciQ53kZXX5tc7Tnol5tnCuQ_oxyItkhzGuBGdLogSjemZY69adH9Hh4LlKUmoL5gsDjadG5fJiGCdolx8xbxYXh5lKVOciLY6Y2h3teyLk',
    ),
    // Dairy
    Product(
      id: 7,
      name: 'Farm Fresh Milk',
      category: 'Dairy',
      price: 65,
      unit: '1L',
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuCT36zslnwqBY5HifEEkLre5wW5IUdCyIdKC63V6J3lTz2UCvxWYDy8D864rOqL3IksDUh545XgbD1ftrjxCZnQJquQV6EE9Fh6-oqEnUXu4P6i8qZlHLacLpBASwNyCLeKrS3a38phiBGBll4zzuVPRqrYRdT8NDu1MLTTgR_JJK_Hwe8pzJT2sxz35zk3T0d-mTEc82Xg1ngG60dbcr9KyEsmsiPI7KxBAMFhM52m2sicgz220JfblRnWcf4GTFT_aHGmO581MKs',
    ),
    Product(
      id: 8,
      name: 'Fresh Paneer',
      category: 'Dairy',
      price: 85,
      unit: '200g',
      imageUrl:
          'https://images.unsplash.com/photo-1631452180519-c014fe946bc7?w=400&q=80',
    ),
    Product(
      id: 9,
      name: 'Amul Butter Salted',
      category: 'Dairy',
      price: 55,
      unit: '100g',
      imageUrl:
          'https://images.unsplash.com/photo-1589985270826-4b7bb135bc9d?w=400&q=80',
    ),
    Product(
      id: 10,
      name: 'Greek Yogurt',
      category: 'Dairy',
      price: 75,
      unit: '400g',
      imageUrl:
          'https://images.unsplash.com/photo-1488477181946-6428a0291777?w=400&q=80',
    ),
    // Snacks
    Product(
      id: 11,
      name: "Lays Classic Salted",
      category: 'Snacks',
      price: 20,
      unit: '26g',
      imageUrl:
          'https://images.unsplash.com/photo-1566478989037-eec170784d0b?w=400&q=80',
    ),
    Product(
      id: 12,
      name: 'Marie Light Biscuits',
      category: 'Snacks',
      price: 30,
      unit: '200g',
      imageUrl:
          'https://images.unsplash.com/photo-1558961363-fa8fdf82db35?w=400&q=80',
    ),
    Product(
      id: 13,
      name: 'Dark Chocolate Bar',
      category: 'Snacks',
      price: 99,
      unit: '100g',
      imageUrl:
          'https://images.unsplash.com/photo-1606312619070-d48b4c652a52?w=400&q=80',
      badge: 'New',
    ),
    // Beverages
    Product(
      id: 14,
      name: 'Fresh Orange Juice',
      category: 'Beverages',
      price: 99,
      unit: '1L',
      imageUrl:
          'https://images.unsplash.com/photo-1621506289937-a8e4df240d0b?w=400&q=80',
    ),
    Product(
      id: 15,
      name: 'Mineral Water',
      category: 'Beverages',
      price: 20,
      unit: '1L',
      imageUrl:
          'https://images.unsplash.com/photo-1548839140-29a749e1cf4d?w=400&q=80',
    ),
    Product(
      id: 16,
      name: 'Cold Brew Coffee',
      category: 'Beverages',
      price: 120,
      unit: '300ml',
      imageUrl:
          'https://images.unsplash.com/photo-1461023058943-07fcbe16d735?w=400&q=80',
      badge: 'Offer',
    ),
    // Bakery
    Product(
      id: 17,
      name: 'Whole Wheat Bread',
      category: 'Bakery',
      price: 45,
      unit: '400g',
      imageUrl:
          'https://images.unsplash.com/photo-1509440159596-0249088772ff?w=400&q=80',
    ),
    Product(
      id: 18,
      name: 'Butter Croissant',
      category: 'Bakery',
      price: 55,
      unit: '2 pcs',
      imageUrl:
          'https://images.unsplash.com/photo-1555507036-ab1f4038808a?w=400&q=80',
    ),
    // Vegetables
    Product(
      id: 19,
      name: 'Fresh Tomatoes',
      category: 'Vegetables',
      price: 35,
      unit: '500g',
      imageUrl:
          'https://images.unsplash.com/photo-1546094096-0df4bcaad337?w=400&q=80',
    ),
    Product(
      id: 20,
      name: 'Baby Spinach',
      category: 'Vegetables',
      price: 40,
      unit: '250g',
      imageUrl:
          'https://images.unsplash.com/photo-1576045057995-568f588f82fb?w=400&q=80',
    ),
    Product(
      id: 21,
      name: 'Broccoli Head',
      category: 'Vegetables',
      price: 60,
      unit: '1 head (~500g)',
      imageUrl:
          'https://images.unsplash.com/photo-1459411621453-7b03977f4bfc?w=400&q=80',
    ),
    Product(
      id: 22,
      name: 'Carrots Premium',
      category: 'Vegetables',
      price: 30,
      unit: '500g',
      imageUrl:
          'https://images.unsplash.com/photo-1598170845058-32b9d6a5da37?w=400&q=80',
    ),
  ];
}
