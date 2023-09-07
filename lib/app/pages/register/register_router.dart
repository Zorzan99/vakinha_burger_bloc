import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vakinha_burger/app/pages/register/register_controller.dart';
import 'package:vakinha_burger/app/pages/register/register_page.dart';

class RegisterRouter {
  RegisterRouter._();

  static Widget get page => MultiProvider(
        providers: [
          Provider(
            create: (context) => RegisterController(
              context.read(),
            ),
          ),
        ],
        child: const RegisterPage(),
      );
}
