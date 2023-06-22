import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nike_app/common/di/locator.dart';
import 'package:nike_app/common/extensions/int_extension.dart';
import 'package:nike_app/common/widgets/cached_images.dart';
import 'package:nike_app/features/feature_order/presentation/blocs/order_history_bloc/order_history_bloc.dart';

class OrderHistoryScreen extends StatelessWidget {
  const OrderHistoryScreen({super.key});
  static const routeName = '/order_history_screen';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('لیست سفارشات'),
        centerTitle: true,
      ),
      body: BlocProvider(
        create: (context) {
          final bloc = OrderHistoryBloc(locator());
          bloc.add(OrderHistoryStarted());
          return bloc;
        },
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: BlocBuilder<OrderHistoryBloc, OrderHistoryState>(
              builder: (context, state) {
            if (state is OrderHistoryLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (state is OrderHistorySuccess) {
              final orderList = state.orderList;
              return ListView.builder(
                  itemCount: orderList.length,
                  padding: const EdgeInsets.only(bottom: 50),
                  itemBuilder: (context, index) {
                    var order = orderList[index];
                    return Container(
                      margin: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                      decoration: BoxDecoration(
                        border:
                            Border.all(width: 1, color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            height: 56,
                            child: Row(
                              children: [
                                const Text(
                                  'شناسه سفارش',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                                Text(
                                  order.id.toString(),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14),
                                ),
                              ],
                            ),
                          ),
                          const Divider(
                            height: 1,
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            height: 56,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'مبلغ',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                                Text(
                                  order.payablePrice.withPriceLabel,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14),
                                ),
                              ],
                            ),
                          ),
                          const Divider(
                            height: 1,
                          ),
                          SizedBox(
                            height: 132,
                            child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                padding:
                                    const EdgeInsets.fromLTRB(16, 8, 16, 8),
                                itemCount: order.items.length,
                                itemBuilder: (context, index) {
                                  return Container(
                                    height: 100,
                                    width: 100,
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 4),
                                    child: CachedImage(
                                      imageUrl: order.items[index].imageUrl,
                                      borderRadius: 8,
                                    ),
                                  );
                                }),
                          )
                        ],
                      ),
                    );
                  });
            }
            if (state is OrderHistoryError) {
              return Center(
                child: Text(state.error),
              );
            }
            return const Center(
              child: Text('state is not valid'),
            );
          }),
        ),
      ),
    );
  }
}
