import 'package:apotik_online/core/color/colors.dart';
import 'package:apotik_online/core/utils/api_endpoints.dart';
import 'package:apotik_online/core/utils/global_utils.dart';
import 'package:apotik_online/core/widget/container.dart';
// import 'package:apotik_online/core/widget/text.dart';
import 'package:apotik_online/feature/domain/entity/drugs_products_model.dart';
import 'package:apotik_online/feature/presentation/riverpod/drugs_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DrugsProductsList extends ConsumerStatefulWidget {
  const DrugsProductsList({
    super.key,
    required this.product,
    required this.isSelected,
    required this.isSelectionMode,
    required this.onTap,
  });
  final DrugsProductsModel product;
  final bool isSelected;
  final bool isSelectionMode;
  final Function(int) onTap;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _DrugsProductsListState();
}

class _DrugsProductsListState extends ConsumerState<DrugsProductsList> {
  @override
  void didUpdateWidget(covariant DrugsProductsList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isSelectionMode != oldWidget.isSelectionMode) {
      if (mounted) {
        setState(() {
          expanded = false;
        });
      }
    }
  }

  bool expanded = false;
  @override
  Widget build(BuildContext context) {
    final DrugsProductsModel product = widget.product;
    final bool isSelected = widget.isSelected;
    final bool isSelectionMode = widget.isSelectionMode;
    final Function(int) onTap = widget.onTap;
    return InkWell(
      onLongPress:
          !isSelectionMode && !expanded ? () => onTap(product.id!) : null,
      onTap: isSelectionMode ? () => onTap(product.id!) : null,
      child: Card(
        elevation: 10,
        child: containerUtils(
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOutCubic,
          margin: const EdgeInsets.symmetric(vertical: 5),
          padding: const EdgeInsets.all(8),
          color: Colors.grey[200],
          borderRadius: 10,
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
                  isSelectionMode
                      ? Checkbox(
                          value: isSelected,
                          onChanged: (value) => onTap(product.id!),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            PopupMenuButton(
                              color: white,
                              itemBuilder: (context) => [
                                PopupMenuItem(
                                  value: 1,
                                  onTap: () {
                                    Navigator.pushNamed(context, '/products',
                                        arguments: [
                                          product.categoryId,
                                          product.id
                                        ]);
                                  },
                                  child: const ListTile(
                                    leading: Icon(
                                      Icons.edit,
                                    ),
                                    title: Text('Edit'),
                                  ),
                                ),
                                PopupMenuItem(
                                  value: 2,
                                  onTap: () {
                                    ref
                                        .read(drugsProvider.notifier)
                                        .deleteProducts(
                                          model: DrugsProductsModel(
                                            id: product.id,
                                          ),
                                        );
                                  },
                                  child: const ListTile(
                                    leading: Icon(
                                      Icons.delete,
                                    ),
                                    title: Text('Delete'),
                                  ),
                                ),
                              ],
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
                ],
              ),
              AnimatedOpacity(
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeInOut,
                opacity: expanded ? 1.0 : 0.0,
                child: expanded && !isSelectionMode
                    ? Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product.description ??
                                  'Deskripsi tidak tersedia.',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: black,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'Stok: ${formatNumber(product.stock ?? 0, false)}',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: black,
                              ),
                            ),
                          ],
                        ),
                      )
                    : const SizedBox.shrink(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
