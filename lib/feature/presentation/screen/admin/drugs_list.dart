import 'package:apotik_online/core/color/colors.dart';
import 'package:apotik_online/core/widget/container.dart';
import 'package:apotik_online/feature/presentation/riverpod/drugs_riverpod.dart';
import 'package:apotik_online/feature/presentation/screen/admin/list_of_drugs/drugs_categories.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DrugsList extends ConsumerStatefulWidget {
  const DrugsList({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DrugsListState();
}

class _DrugsListState extends ConsumerState<DrugsList> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

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
              topButton(size, context),
              Expanded(
                child: ListView.builder(
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    final category = categories[index];
                    final isSelected = selectedList.contains(category.id!);

                    return DrugsCategoriesList(
                      category: category,
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

  topButton(Size size, BuildContext context) {
    return containerUtils(
      color: white,
      alignment: Alignment.topRight,
      width: size.width,
      child: _isSelectionMode == true
          ? Row(
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
                        .read(drugsProvider.notifier)
                        .multiDeleteCategories(id: selectedList)
                        .then((_) {
                      _toggleSelectionMode();
                    });
                  },
                ),
              ],
            )
          : IconButton(
              onPressed: () {
                Navigator.pushNamed(context, '/categories');
              },
              icon: Icon(
                color: black,
                Icons.add,
              ),
            ),
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
    if (selectedList.length == ref.watch(drugsProvider).categoriesList.length) {
      _toggleSelectionMode();
    } else {
      setState(() {
        selectedList.clear();
        _isSelectionMode = true;
        _selectedAll = true;
        selectedList.addAll(
            ref.watch(drugsProvider).categoriesList.map((item) => item.id!));
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
            ref.watch(drugsProvider).categoriesList.length) {
          _selectedAll = true;
        }
      }
    });
  }
}
