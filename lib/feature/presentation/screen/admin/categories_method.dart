import 'package:apotik_online/core/color/colors.dart';
import 'package:apotik_online/core/utils/global_utils.dart';
import 'package:apotik_online/core/validator/validator.dart';
import 'package:apotik_online/core/widget/container.dart';
import 'package:apotik_online/core/widget/loading.dart';
import 'package:apotik_online/core/widget/text.dart';
import 'package:apotik_online/core/widget/text_field_input.dart';
import 'package:apotik_online/feature/domain/entity/drugs_categories_model.dart';
import 'package:apotik_online/feature/presentation/riverpod/drugs_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CategoriesScreen extends ConsumerStatefulWidget {
  const CategoriesScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CategoriesScreenState();
}

class _CategoriesScreenState extends ConsumerState<CategoriesScreen> {
  final TextEditingController _name = TextEditingController();

  final _key = GlobalKey<FormState>();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args = ModalRoute.of(context)!.settings.arguments as int?;
      if (args != null) {
        final drugsState = ref.read(drugsProvider);
        final category = drugsState.categoriesList.firstWhere(
          (e) => e.id == args,
        );
        if (category.name != null) {
          _name.text = category.name!;
        }
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _name.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as int?;

    return Consumer(
      builder: (context, ref, widget) {
        final drugsWatch = ref.watch(drugsProvider);
        if (drugsWatch.state == GlobalState.loading) {
          return const Loading();
        } else {
          return Scaffold(
            appBar: AppBar(),
            body: CustomScrollView(
              slivers: [
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: containerUtils(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 18, vertical: 12),
                    width: double.infinity,
                    child: Form(
                      key: _key,
                      child: Column(
                        children: [
                          _text(args),
                          const SizedBox(
                            height: 42,
                          ),
                          _form(),
                          const SizedBox(
                            height: 16,
                          ),
                          const SizedBox(
                            height: 32,
                          ),
                          _updatePasswordButton(drugsWatch, args),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }

  _form() {
    return TextFieldInput(
      radius: false,
      textEditingController: _name,
      isPass: false,
      valid: (e) => Validator.validateNama(e),
      hintText: 'Name',
      textInputType: TextInputType.text,
    );
  }

  _text(int? args) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: textUtils(
            text: '${args == null ? "Add new" : "Update"} category',
            weight: FontWeight.bold,
            size: 24,
          ),
        ),
        const SizedBox(height: 2),
        textUtils(
          text: '${args == null ? "Add new" : "Update"}  category for drugs',
        ),
      ],
    );
  }

  _updatePasswordButton(DrugsProvider drugsWatch, int? args) {
    return InkWell(
      onTap: () async {
        if (_key.currentState!.validate()) {
          final isCreate = args == null;
          final model = DrugsCategoriesModel(
            id: isCreate ? null : args,
            name: capitalizeEachWord(_name.text),
          );
          if (isCreate) {
            await ref
                .read(drugsProvider.notifier)
                .createCategories(model: model);
          } else {
            await ref
                .read(drugsProvider.notifier)
                .updateCategories(model: model);
          }
          if (drugsWatch.state == GlobalState.none &&
              (drugsWatch.message == 'Store data success' ||
                  drugsWatch.message == 'Update data success')) {
            if (!mounted) return;
            Navigator.of(context).pop();
          }
        }
      },
      child: containerUtils(
        width: double.infinity,
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(vertical: 12),
        borderRadius: 10,
        color: greenCharum,
        child: textUtils(
          text: '${args == null ? 'Create new' : 'Update'} category',
          color: white,
        ),
      ),
    );
  }
}
