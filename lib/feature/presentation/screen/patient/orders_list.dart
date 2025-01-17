import 'package:apotik_online/core/color/colors.dart';
import 'package:apotik_online/core/utils/api_endpoints.dart';
import 'package:apotik_online/feature/domain/entity/drugs_products_model.dart';
import 'package:apotik_online/feature/domain/entity/orders_model.dart';
import 'package:apotik_online/feature/presentation/riverpod/cart_items_riverpod.dart';
import 'package:apotik_online/feature/presentation/riverpod/drugs_riverpod.dart';
import 'package:apotik_online/feature/presentation/riverpod/orders_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OrdersList extends ConsumerStatefulWidget {
  const OrdersList({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _OrdersListState();
}

class _OrdersListState extends ConsumerState<OrdersList> {
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final orders = ref.watch(ordersProvider).ordersList;
        if (orders.isEmpty) {
          return const Center(
            child: Text(
              'No data available',
            ),
          );
        } else {
          final products = ref.watch(drugsProvider).productsList;
          final cartItems = ref.watch(cartItemsProvider).cartItemsList;

          return ListView.builder(
            itemCount: orders.length,
            padding: const EdgeInsets.all(8),
            itemBuilder: (context, index) {
              final order = orders[index];

              final orderCartItems = cartItems
                  .where((cartItem) =>
                      order.pivot
                          ?.any((pivot) => pivot.cartItemId == cartItem.id) ??
                      false)
                  .toList();

              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                elevation: 6,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Order #${_formatDate(order.createdAt)}",
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          order.status == 'approved' ||
                                  order.status == 'pending'
                              ? _button(Icons.cancel, order)
                              : _button(Icons.delete, order),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Total: Rp ${order.totalPrice}",
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
                                ),
                          ),
                          _buildStatusBadge(order.status),
                        ],
                      ),
                      const Divider(),
                      ...orderCartItems.map((cartItem) {
                        final product = products.firstWhere(
                            (product) => product.id == cartItem.productId,
                            orElse: () => DrugsProductsModel());

                        return ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: product.picture != null
                                ? Image.network(
                                    "$baseUrl/${product.picture!}",
                                    width: 50,
                                    height: 50,
                                    fit: BoxFit.cover,
                                  )
                                : const Icon(Icons.image_not_supported,
                                    size: 50),
                          ),
                          title: Text(
                            product.name ?? "Produk Tidak Ditemukan",
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          subtitle: Text(
                            "Qty: ${cartItem.qty}, Harga: Rp ${cartItem.price}",
                            style: const TextStyle(
                                fontSize: 12, color: Colors.grey),
                          ),
                        );
                      }),
                      if (order.messages != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            "Note: ${order.messages}",
                            style: TextStyle(
                              fontStyle: FontStyle.italic,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }

  InkWell _button(IconData icon, OrdersModel order) {
    return InkWell(
      onTap: () {
        if (icon == Icons.cancel) {
          ref.read(ordersProvider.notifier).cancelled(
                model: OrdersModel(
                  id: order.id,
                ),
              );
        } else {
          ref.read(ordersProvider.notifier).deleteOrders(
                model: OrdersModel(
                  id: order.id,
                ),
              );
        }
      },
      child: Icon(
        size: 18,
        icon,
        color: black,
      ),
    );
  }

  // Format tanggal
  String _formatDate(DateTime? dateTime) {
    if (dateTime == null) return "-";
    return "${dateTime.day}-${dateTime.month}-${dateTime.year}";
  }

  // Widget Badge Status
  Widget _buildStatusBadge(String? status) {
    final Map<String, Color> statusColors = {
      "approved": Colors.blue,
      "pending": Colors.orange,
      "finished": Colors.green,
      "cancelled": Colors.red,
    };
    final color = statusColors[status] ?? Colors.blue;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status ?? "Unknown",
        style: TextStyle(color: color, fontWeight: FontWeight.bold),
      ),
    );
  }
}
