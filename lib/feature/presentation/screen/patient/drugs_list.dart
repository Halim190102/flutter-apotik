import 'package:apotik_online/feature/presentation/riverpod/drugs_riverpod.dart';
import 'package:apotik_online/feature/presentation/screen/patient/list_of_drugs/drugs_categories.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DrugsList extends ConsumerStatefulWidget {
  const DrugsList({
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DrugsListState();
}

class _DrugsListState extends ConsumerState<DrugsList> {
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final categories = ref.watch(drugsProvider).categoriesList;
        if (categories.isEmpty) {
          return const Center(
            child: Text(
              'No data available',
            ),
          );
        } else {
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    final category = categories[index];

                    return DrugsCategoriesList(
                      category: category,
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
}
