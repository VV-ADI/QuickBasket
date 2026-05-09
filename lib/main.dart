import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'core/theme.dart';
import 'models/cart_item.dart';
import 'providers/auth_provider.dart';
import 'providers/cart_provider.dart';
import 'providers/product_provider.dart';
import 'screens/login/register_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  Hive.registerAdapter(CartItemAdapter());

  final cartProvider = CartProvider();
  await cartProvider.init();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ProductProvider()),
        ChangeNotifierProvider.value(value: cartProvider),
      ],
      child: const QuickBasketApp(),
    ),
  );
}

class QuickBasketApp extends StatelessWidget {
  const QuickBasketApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'QuickBasket',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: const RegisterScreen(),
    );
  }
}
