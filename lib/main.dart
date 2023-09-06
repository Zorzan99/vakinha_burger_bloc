import 'package:flutter/material.dart';
import 'package:vakinha_burger/app/core/config/env/env.dart';
import 'package:vakinha_burger/app/dw9_delivery_app.dart';

Future<void> main() async {
  await Env.i.load();
  runApp(const Dw9DeliveryApp());
}
