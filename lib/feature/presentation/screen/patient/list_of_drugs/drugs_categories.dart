import 'package:apotik_online/core/widget/container.dart';
import 'package:apotik_online/feature/domain/entity/drugs_categories_model.dart';
import 'package:apotik_online/feature/presentation/riverpod/drugs_riverpod.dart';
import 'package:apotik_online/feature/presentation/screen/patient/list_of_drugs/drugs_products.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DrugsCategoriesList extends ConsumerStatefulWidget {
  const DrugsCategoriesList({
    super.key,
    required this.category,
  });
  final DrugsCategoriesModel category;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _DrugsCategoriesListState();
}

class _DrugsCategoriesListState extends ConsumerState<DrugsCategoriesList> {
  bool expanded = false;
  @override
  Widget build(BuildContext context) {
    final DrugsCategoriesModel category = widget.category;

    final products = ref
        .watch(drugsProvider)
        .productsList
        .where((e) => e.categoryId == category.id)
        .toList();

    return Card(
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
                    turns: expanded ? 0.5 : 0.0,
                    child: const Icon(
                      Icons.expand_more,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            AnimatedOpacity(
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
              opacity: expanded ? 1.0 : 0.0,
              child: expanded
                  ? ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        final product = products[index];

                        return DrugsProductsList(
                          product: product,
                        );
                      },
                    )
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }
}
