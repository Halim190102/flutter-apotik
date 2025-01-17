import 'package:apotik_online/core/color/colors.dart';
import 'package:apotik_online/core/widget/container.dart';
import 'package:apotik_online/feature/domain/entity/drugs_categories_model.dart';
import 'package:apotik_online/feature/presentation/riverpod/drugs_riverpod.dart';
import 'package:apotik_online/feature/presentation/screen/admin/list_of_drugs/drugs_products.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DrugsCategoriesList extends ConsumerStatefulWidget {
  const DrugsCategoriesList({
    super.key,
    required this.category,
    required this.isSelected,
    required this.isSelectionMode,
    required this.onTap,
  });
  final DrugsCategoriesModel category;
  final bool isSelected;
  final bool isSelectionMode;
  final Function(int) onTap;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _DrugsCategoriesListState();
}

class _DrugsCategoriesListState extends ConsumerState<DrugsCategoriesList> {
  @override
  void didUpdateWidget(covariant DrugsCategoriesList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isSelectionMode != oldWidget.isSelectionMode) {
      setState(() {
        expanded = false;
      });
    }
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
        ref
            .watch(drugsProvider)
            .productsList
            .where((e) => e.categoryId == widget.category.id)
            .length) {
      _toggleSelectionMode();
    } else {
      setState(() {
        selectedList.clear();
        _isSelectionMode = true;
        _selectedAll = true;
        selectedList.addAll(ref
            .watch(drugsProvider)
            .productsList
            .where((e) => e.categoryId == widget.category.id)
            .map((item) => item.id!));
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
            ref
                .watch(drugsProvider)
                .productsList
                .where((e) => e.categoryId == widget.category.id)
                .length) {
          _selectedAll = true;
        }
      }
    });
  }

  bool expanded = false;
  @override
  Widget build(BuildContext context) {
    final DrugsCategoriesModel category = widget.category;
    final bool isSelected = widget.isSelected;
    final bool isSelectionMode = widget.isSelectionMode;
    final Function(int) onTap = widget.onTap;

    final products = ref
        .watch(drugsProvider)
        .productsList
        .where((e) => e.categoryId == category.id)
        .toList();

    return InkWell(
      onLongPress: !isSelectionMode
          ? () {
              onTap(category.id!);
              _toggleSelectionMode();
              expanded = false;
              setState(() {});
            }
          : null,
      onTap: isSelectionMode ? () => onTap(category.id!) : null,
      child: Card(
        elevation: 5,
        child: containerUtils(
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOutCubic,
          borderRadius: 12,
          padding: const EdgeInsets.all(12),
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    category.name ?? '',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  isSelectionMode
                      ? Checkbox(
                          value: isSelected,
                          onChanged: (value) => onTap(category.id!),
                        )
                      : _isSelectionMode
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Checkbox(
                                  value: _selectedAll,
                                  onChanged: (select) => _selectAll(),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () async {
                                    await ref
                                        .read(drugsProvider.notifier)
                                        .multiDeleteProducts(id: selectedList)
                                        .then((_) {
                                      _toggleSelectionMode();
                                    });
                                  },
                                ),
                              ],
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
                                        Navigator.pushNamed(
                                          context,
                                          '/categories',
                                          arguments: category.id,
                                        );
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
                                            .deleteCategories(
                                              model: DrugsCategoriesModel(
                                                id: category.id,
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
                                    Navigator.pushNamed(
                                      context,
                                      '/products',
                                      arguments: [category.id],
                                    );
                                  },
                                  icon: const Icon(Icons.add),
                                ),
                                IconButton(
                                  onPressed: () {
                                    if (products.isNotEmpty) {
                                      setState(() {
                                        expanded = !expanded;
                                      });
                                    }
                                  },
                                  icon: AnimatedRotation(
                                    duration: const Duration(milliseconds: 500),
                                    curve: Curves.easeInOut,
                                    turns: expanded && !isSelectionMode
                                        ? 0.5
                                        : 0.0,
                                    child: const Icon(
                                      Icons.expand_more,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                ],
              ),
              const SizedBox(height: 10),
              AnimatedOpacity(
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeInOut,
                opacity: expanded ? 1.0 : 0.0,
                child: expanded && !isSelectionMode
                    ? ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: products.length,
                        itemBuilder: (context, index) {
                          final product = products[index];
                          final isSelected = selectedList.contains(product.id!);

                          return DrugsProductsList(
                            product: product,
                            isSelected: isSelected,
                            isSelectionMode: _isSelectionMode,
                            onTap: _onItemTap,
                          );
                        },
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
