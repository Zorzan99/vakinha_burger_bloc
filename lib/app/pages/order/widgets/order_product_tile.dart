// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vakinha_burger/app/core/extensions/formatter_extension.dart';
import 'package:vakinha_burger/app/core/ui/styles/colors_app.dart';
import 'package:vakinha_burger/app/core/ui/styles/text_styles.dart';
import 'package:vakinha_burger/app/core/ui/widgets/delivery_increment_decrement_button.dart';

import 'package:vakinha_burger/app/dto/order_product_dto.dart';
import 'package:vakinha_burger/app/pages/order/order_controller.dart';

class OrderProductTile extends StatelessWidget {
  final int index;
  final OrderProductDto orderProduct;

  const OrderProductTile({
    Key? key,
    required this.index,
    required this.orderProduct,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final products = orderProduct.product;
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        children: [
          Image.network(
            products.image,
            width: 100,
            height: 100,
            fit: BoxFit.cover,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    products.name,
                    style: context.textStyles.textRegular.copyWith(
                      fontSize: 16,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        (orderProduct.amount * products.price).currencyPTBR,
                        style: context.textStyles.textMedium.copyWith(
                          fontSize: 14,
                          color: context.colors.secondary,
                        ),
                      ),
                      DeliveryIncrementDecrementButton.compact(
                        decrementTap: () {
                          context
                              .read<OrderController>()
                              .decrementProduct(index);
                        },
                        incrementTap: () {
                          context
                              .read<OrderController>()
                              .incrementProduct(index);
                        },
                        amout: orderProduct.amount,
                      )
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
