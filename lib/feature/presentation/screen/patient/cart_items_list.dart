import 'package:apotik_online/core/color/colors.dart';
import 'package:apotik_online/core/utils/api_endpoints.dart';
import 'package:apotik_online/core/utils/global_utils.dart';
import 'package:apotik_online/core/widget/container.dart';
import 'package:apotik_online/core/widget/text.dart';
import 'package:apotik_online/feature/domain/entity/cart_items_model.dart';
import 'package:apotik_online/feature/domain/entity/drugs_products_model.dart';
import 'package:apotik_online/feature/presentation/riverpod/cart_items_riverpod.dart';
import 'package:apotik_online/feature/presentation/riverpod/drugs_riverpod.dart';
import 'package:apotik_online/feature/presentation/riverpod/orders_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CartItemsList extends ConsumerStatefulWidget {
  const CartItemsList({
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CartItemsListState();
}

class _CartItemsListState extends ConsumerState<CartItemsList> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Consumer(
      builder: (context, ref, child) {
        final carts = ref.watch(cartItemsProvider).cartItemsList;
        if (carts.isEmpty) {
          return const Center(
            child: Text(
              'No data available',
            ),
          );
        } else {
          final products = ref.watch(drugsProvider).productsList;
          final cartItems = carts.where((e) => e.status == 'active').toList();
          return Column(
            children: [
              _isSelectionMode == true
                  ? topButton(size, context)
                  : const SizedBox.shrink(),
              Expanded(
                child: ListView.builder(
                  itemCount: cartItems.length,
                  itemBuilder: (context, index) {
                    final cartItem = cartItems[index];
                    final product = products.firstWhere(
                      (p) => p.id == cartItem.productId,
                    );
                    final isSelected = selectedList.contains(cartItem.id!);

                    return ListVewCart(
                      product: product,
                      cartItem: cartItem,
                      isSelected: isSelected,
                      isSelectionMode: _isSelectionMode,
                      onTap: _onItemTap,
                    );
                  },
                ),
              ),
            ],
          );
        }
      },
    );
  }

  List<int> selectedList = <int>[];

  bool _selectedAll = false;
  bool _isSelectionMode = false;
  _toggleSelectionMode() {
    if (!mounted) return;
    setState(() {
      selectedList.clear();
      _isSelectionMode = false;
      _selectedAll = false;
    });
  }

  void _selectAll() {
    if (selectedList.length ==
        ref.watch(cartItemsProvider).cartItemsList.length) {
      _toggleSelectionMode();
    } else {
      setState(() {
        selectedList.clear();
        _isSelectionMode = true;
        _selectedAll = true;
        selectedList.addAll(
            ref.watch(cartItemsProvider).cartItemsList.map((item) => item.id!));
      });
    }
  }

  void _onItemTap(int id) {
    setState(() {
      if (selectedList.contains(id)) {
        selectedList.remove(id);
        if (selectedList.isEmpty) {
          _isSelectionMode = false;
        } else {
          _selectedAll = false;
        }
      } else {
        selectedList.add(id);
        _isSelectionMode = true;
        if (selectedList.length ==
            ref.watch(cartItemsProvider).cartItemsList.length) {
          _selectedAll = true;
        }
      }
    });
  }

  topButton(Size size, BuildContext context) {
    return containerUtils(
      color: white,
      alignment: Alignment.topRight,
      width: size.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Checkbox(
            value: _selectedAll,
            onChanged: (select) => _selectAll(),
          ),
          IconButton(
            icon: Icon(color: black, Icons.delete),
            onPressed: () async {
              await ref
                  .read(cartItemsProvider.notifier)
                  .multiDeleteCartItems(id: selectedList)
                  .then((_) {
                _toggleSelectionMode();
              });
            },
          ),
          IconButton(
            icon: Icon(color: black, Icons.add_shopping_cart),
            onPressed: () async {
              await ref
                  .read(ordersProvider.notifier)
                  .createOrders(id: selectedList)
                  .then((_) {
                _toggleSelectionMode();
              });
            },
          ),
        ],
      ),
    );
  }
}

class ListVewCart extends ConsumerStatefulWidget {
  const ListVewCart({
    super.key,
    required this.product,
    required this.cartItem,
    required this.isSelected,
    required this.isSelectionMode,
    required this.onTap,
  });

  final DrugsProductsModel product;
  final CartItemsModel cartItem;
  final bool isSelected;
  final bool isSelectionMode;
  final Function(int) onTap;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ListVewCartState();
}

class _ListVewCartState extends ConsumerState<ListVewCart> {
  int qty = 0;
  bool edit = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        qty = widget.cartItem.qty!;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onLongPress: !widget.isSelectionMode && !edit
          ? () => widget.onTap(widget.cartItem.id!)
          : null,
      onTap: widget.isSelectionMode
          ? () => widget.onTap(widget.cartItem.id!)
          : null,
      child: Card(
        elevation: 5,
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CachedNetworkImage(
                imageUrl: '$baseUrl/${widget.product.picture!}',
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
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    textUtils(
                      text: widget.product.name ?? 'Unknown Product',
                      size: 16,
                      weight: FontWeight.bold,
                    ),
                    const SizedBox(height: 4),
                    textUtils(
                      text: widget.product.description ??
                          'No description available',
                      size: 14,
                      color: grey,
                      textOverflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: 80,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          edit
                              ? button(Icons.remove)
                              : textUtils(text: 'Quantity:'),
                          textUtils(text: qty.toString(), size: 14),
                          edit ? button(Icons.add) : const SizedBox()
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              widget.isSelectionMode
                  ? Checkbox(
                      value: widget.isSelected,
                      onChanged: (value) => widget.onTap(widget.cartItem.id!),
                    )
                  : SizedBox(
                      width: 120,
                      height: 80,
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              InkWell(
                                onTap: () {
                                  if (!edit) {
                                    setState(() {
                                      edit = true;
                                    });
                                  } else {
                                    if (qty != widget.cartItem.qty) {
                                      ref
                                          .read(cartItemsProvider.notifier)
                                          .updateCartItems(
                                            model: CartItemsModel(
                                              id: widget.cartItem.id,
                                              qty: qty,
                                            ),
                                          );
                                    }
                                    setState(() {
                                      edit = false;
                                    });
                                  }
                                },
                                child: Icon(
                                  edit ? Icons.save : Icons.edit,
                                  color: black,
                                ),
                              ),
                              const SizedBox(
                                width: 16,
                              ),
                              InkWell(
                                onTap: () {
                                  ref
                                      .read(cartItemsProvider.notifier)
                                      .deleteCartItems(
                                        model: CartItemsModel(
                                          id: widget.cartItem.id,
                                        ),
                                      );
                                },
                                child: Icon(
                                  Icons.delete,
                                  color: black,
                                ),
                              ),
                            ],
                          ),
                          textUtils(
                            text:
                                formatNumber(widget.product.price! * qty, true),
                            size: 14,
                            weight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ],
                      ),
                    )
            ],
          ),
        ),
      ),
    );
  }

  button(IconData icon) {
    return InkWell(
      onTap: () {
        setState(() {
          if (icon == Icons.add && qty < calculate(widget.product.stock!)) {
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
