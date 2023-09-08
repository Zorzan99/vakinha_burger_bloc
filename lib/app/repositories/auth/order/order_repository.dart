import 'package:vakinha_burger/app/dto/order_dto.dart';
import 'package:vakinha_burger/app/models/payment_type_model.dart';

abstract interface class OrderRepository {
  Future<List<PaymentTypeModel>> getAllPaymentsType();
  Future<void> saveOrder(OrderDto order);
}
