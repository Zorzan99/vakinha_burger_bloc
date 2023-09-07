import 'package:flutter/material.dart';
import 'package:vakinha_burger/app/core/provider/application_binding.dart';
import 'package:vakinha_burger/app/core/ui/theme/theme_config.dart';
import 'package:vakinha_burger/app/pages/auth/login/login_router.dart';
import 'package:vakinha_burger/app/pages/home/home_router.dart';
import 'package:vakinha_burger/app/pages/order/order_router.dart';
import 'package:vakinha_burger/app/pages/product_detail/product_detail_router.dart';
import 'package:vakinha_burger/app/pages/register/register_router.dart';
import 'package:vakinha_burger/app/pages/splash/splash_page.dart';

class Dw9DeliveryApp extends StatelessWidget {
  const Dw9DeliveryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ApplicationBinding(
      child: MaterialApp(
        title: 'Delivery App',
        theme: ThemeConfig.theme,
        routes: {
          '/': (context) => const SplashPage(),
          '/home': (context) => HomeRouter.page,
          '/productDetail': (context) => ProductDetailRouter.page,
          '/auth/login': (context) => LoginRouter.page,
          '/auth/register': (context) => RegisterRouter.page,
          '/order': (context) => OrderRouter.page,
        },
      ),
    );
  }
}
