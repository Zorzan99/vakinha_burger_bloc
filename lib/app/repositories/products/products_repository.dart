import 'package:vakinha_burger/app/models/product_model.dart';

abstract interface class ProductsRepository {
  Future<List<ProductModel>> findAllProducts();
}
