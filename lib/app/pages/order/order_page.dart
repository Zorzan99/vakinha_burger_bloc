// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:validatorless/validatorless.dart';

import 'package:vakinha_burger/app/core/extensions/formatter_extension.dart';
import 'package:vakinha_burger/app/core/ui/base_state/base_state.dart';
import 'package:vakinha_burger/app/core/ui/styles/text_styles.dart';
import 'package:vakinha_burger/app/core/ui/widgets/delivery_app_bar.dart';
import 'package:vakinha_burger/app/core/ui/widgets/delivery_button.dart';
import 'package:vakinha_burger/app/dto/order_product_dto.dart';
import 'package:vakinha_burger/app/models/payment_type_model.dart';
import 'package:vakinha_burger/app/pages/order/order_controller.dart';
import 'package:vakinha_burger/app/pages/order/order_state.dart';
import 'package:vakinha_burger/app/pages/order/widgets/order_field.dart';
import 'package:vakinha_burger/app/pages/order/widgets/order_product_tile.dart';
import 'package:vakinha_burger/app/pages/order/widgets/payment_types_field.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({
    Key? key,
  }) : super(key: key);

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends BaseState<OrderPage, OrderController> {
  final formKey = GlobalKey<FormState>();
  final addressEC = TextEditingController();
  final documentEC = TextEditingController();
  final paymentTypeValid = ValueNotifier<bool>(true);
  int? paymentTypeId;
  @override
  void onReady() {
    final products =
        ModalRoute.of(context)!.settings.arguments as List<OrderProductDto>;
    controller.load(products);
    super.onReady();
  }

  void _showConfirmProductDialog(OrderConfirmDeleteProductState state) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
                "Você tem certeza que deseja excluir o produto ${state.orderProduct.product.name}?"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  controller.cancelDeleteProcecss();
                },
                child: Text(
                  'Cancelar',
                  style:
                      context.textStyles.textBold.copyWith(color: Colors.red),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  controller.decrementProduct(state.index);
                },
                child: Text(
                  'Confirmar',
                  style: context.textStyles.textBold,
                ),
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<OrderController, OrderState>(
      listener: (context, state) {
        state.status.matchAny(
            any: () => hideLoader(),
            loading: () => showLoader(),
            error: () {
              hideLoader();
              showError(state.errorMessage ?? 'Erro não informado');
            },
            confirmRemoveProduct: () {
              hideLoader();
              if (state is OrderConfirmDeleteProductState) {
                _showConfirmProductDialog(state);
              }
            },
            emptyBag: () {
              showInfo(
                  'Sua sacola está vazia, por favor selecione um produto para realizar seu pedido');
              Navigator.pop(context, <OrderProductDto>[]);
            },
            success: () {
              hideLoader();
              Navigator.of(context).popAndPushNamed(
                '/order/completed',
                result: <OrderProductDto>[],
              );
            });
      },
      child: WillPopScope(
        onWillPop: () async {
          Navigator.of(context).pop(controller.state.orderProducts);
          return false;
        },
        child: Scaffold(
          appBar: DeliveryAppBar(),
          body: Form(
            key: formKey,
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    child: Row(
                      children: [
                        Text(
                          'Carrinho',
                          style: context.textStyles.textTitle,
                        ),
                        IconButton(
                            onPressed: () {
                              controller.emptyBag();
                            },
                            icon: Image.asset('assets/images/trashRegular.png'))
                      ],
                    ),
                  ),
                ),
                BlocSelector<OrderController, OrderState,
                    List<OrderProductDto>>(
                  selector: (state) => state.orderProducts,
                  builder: (context, orderProducts) {
                    return SliverList(
                      delegate: SliverChildBuilderDelegate(
                        childCount: orderProducts.length,
                        (context, index) {
                          final orderProduct = orderProducts[index];
                          return Column(
                            children: [
                              OrderProductTile(
                                  index: index, orderProduct: orderProduct),
                              const Divider(
                                color: Colors.grey,
                              ),
                            ],
                          );
                        },
                      ),
                    );
                  },
                ),
                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Total do pedido',
                              style: context.textStyles.textExtraBold.copyWith(
                                fontSize: 16,
                              ),
                            ),
                            BlocSelector<OrderController, OrderState, double>(
                              selector: (state) => state.totalOrder,
                              builder: (context, totalOrder) {
                                return Text(
                                  totalOrder.currencyPTBR,
                                  style:
                                      context.textStyles.textExtraBold.copyWith(
                                    fontSize: 16,
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      const Divider(
                        color: Colors.grey,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      OrderField(
                        title: 'Endereço de entrega',
                        controller: addressEC,
                        validator:
                            Validatorless.required('Endereço obrigatório'),
                        hintText: 'Digite o endereço',
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      OrderField(
                        title: 'CPF',
                        controller: documentEC,
                        validator: Validatorless.required('CPF obrigatório'),
                        hintText: 'Digite o CPF',
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      BlocSelector<OrderController, OrderState,
                          List<PaymentTypeModel>>(
                        selector: (state) => state.paymentTypes,
                        builder: (context, paymentTypes) {
                          return ValueListenableBuilder(
                            valueListenable: paymentTypeValid,
                            builder: (_, paymentTypeValid, child) {
                              return PaymentTypesField(
                                paymentTypes: paymentTypes,
                                valueChanged: (value) {
                                  paymentTypeId = value;
                                },
                                valid: paymentTypeValid,
                                valueSelected: paymentTypeId.toString(),
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const Divider(
                        color: Colors.grey,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: DeliveryButton(
                          width: double.infinity,
                          heigth: 48,
                          label: 'FINALIZAR',
                          onPressed: () {
                            final valid =
                                formKey.currentState?.validate() ?? false;
                            final paymentTypeSelected = paymentTypeId != null;
                            paymentTypeValid.value = paymentTypeSelected;

                            if (valid && paymentTypeSelected) {
                              controller.saveOrder(
                                address: addressEC.text,
                                document: documentEC.text,
                                paymentMethodId: paymentTypeId!,
                              );
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
