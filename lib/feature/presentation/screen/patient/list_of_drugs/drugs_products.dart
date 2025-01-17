import 'package:apotik_online/core/color/colors.dart';
import 'package:apotik_online/core/utils/api_endpoints.dart';
import 'package:apotik_online/core/utils/global_utils.dart';
import 'package:apotik_online/core/widget/container.dart';
import 'package:apotik_online/core/widget/text.dart';
import 'package:apotik_online/feature/domain/entity/cart_items_model.dart';
import 'package:apotik_online/feature/domain/entity/drugs_products_model.dart';
import 'package:apotik_online/feature/presentation/riverpod/auth_riverpod.dart';
import 'package:apotik_online/feature/presentation/riverpod/cart_items_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DrugsProductsList extends ConsumerStatefulWidget {
  const DrugsProductsList({
    super.key,
    required this.product,
  });
  final DrugsProductsModel product;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _DrugsProductsListState();
}

class _DrugsProductsListState extends ConsumerState<DrugsProductsList> {
  int qty = 1;
  bool expanded = false;
  @override
  Widget build(BuildContext context) {
    final DrugsProductsModel product = widget.product;

    return Card(
      elevation: 10,
      child: containerUtils(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOutCubic,
        padding: const EdgeInsets.all(8),
        color: Colors.grey[200],
        borderRadius: 12,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CachedNetworkImage(
                  imageUrl: '$baseUrl/${product.picture}',
                  height: 80,
                  width: 80,
                  fit: BoxFit.contain,
                  httpHeaders: const {
                    'Connection': 'keep-alive',
                    'Keep-Alive': 'timeout=60, max=100',
                  },
                  imageBuilder: (context, imageProvider) => ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image(
                      image: imageProvider,
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                    ),
                  ),
                  placeholder: (context, url) => Container(
                    height: 80,
                    color: grey,
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                  errorWidget: (context, url, error) => const Icon(
                    Icons.image_not_supported,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.name ?? '',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        formatNumber(product.price ?? 0, true),
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      expanded = !expanded;
                    });
                  },
                  icon: AnimatedRotation(
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                    turns: expanded ? 0.5 : 0.0,
                    child: const Icon(
                      Icons.expand_more,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ],
            ),
            AnimatedOpacity(
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
              opacity: expanded ? 1.0 : 0.0,
              child: expanded
                  ? Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product.description ?? 'Deskripsi tidak tersedia.',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.black54,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Text(
                                'Stok: ${formatNumber(product.stock ?? 0, false)}',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.black54,
                                ),
                              ),
                              const Spacer(),
                              SizedBox(
                                width: 65,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    button(Icons.remove),
                                    textUtils(
                                      text: qty.toString(),
                                      size: 16,
                                      weight: FontWeight.bold,
                                    ),
                                    button(Icons.add)
                                  ],
                                ),
                              ),
                              const SizedBox(
                                width: 16,
                              ),
                              ElevatedButton(
                                onPressed: widget.product.stock != 0
                                    ? () {
                                        final cartItems = ref
                                            .watch(cartItemsProvider)
                                            .cartItemsList;
                                        final profile =
                                            ref.watch(authProvider).profile!.id;
                                        final cartItem = cartItems.firstWhere(
                                          orElse: () => CartItemsModel(),
                                          (e) =>
                                              e.productId ==
                                                  widget.product.id &&
                                              e.userId == profile,
                                        );
                                        final cartQty = cartItem.qty ?? 0;
                                        if (cartQty < widget.product.stock!) {
                                          ref
                                              .read(cartItemsProvider.notifier)
                                              .createCartItems(
                                                model: CartItemsModel(
                                                  productId: product.id,
                                                  qty: qty,
                                                ),
                                              );
                                        }
                                      }
                                    : null,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                  textStyle: const TextStyle(fontSize: 12),
                                ),
                                child: textUtils(
                                  text: 'Beli',
                                  color: black,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }

  button(IconData icon) {
    final cartItems = ref.watch(cartItemsProvider).cartItemsList;
    final profile = ref.watch(authProvider).profile!.id;
    final cartItem = cartItems.firstWhere(
      orElse: () => CartItemsModel(),
      (e) => e.productId == widget.product.id && e.userId == profile,
    );
    final cartQty = cartItem.qty ?? 0;
    final maxQty = calculate(widget.product.stock!);
    return InkWell(
      onTap: () {
        setState(() {
          if (icon == Icons.add &&
              qty + cartQty < maxQty &&
              cartQty < widget.product.stock!) {
            qty += 1;
          } else if (icon != Icons.add && qty > 1) {
            qty -= 1;
          }
        });
      },
      child: Icon(
        icon,
        size: 16,
      ),
    );
  }

  int calculate(int a) {
    if (a <= 10) {
      return a;
    } else if (a < 20) {
      return 10;
    } else {
      int baseValue = 11; // Nilai awal untuk a > 60
      int increment = 1; // Penambahan sesuai pola
      int step = (a - 30) ~/ 10; // Menghitung kelipatan 10
      for (int i = 0; i < step; i++) {
        baseValue += increment;
        increment++; // Increment bertambah setiap langkah
      }
      return baseValue;
    }
  }
}
