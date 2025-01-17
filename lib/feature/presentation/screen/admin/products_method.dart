import 'dart:io';

import 'package:apotik_online/core/color/colors.dart';
import 'package:apotik_online/core/image_picker/images.dart';
import 'package:apotik_online/core/utils/api_endpoints.dart';
import 'package:apotik_online/core/utils/global_utils.dart';
import 'package:apotik_online/core/validator/validator.dart';
import 'package:apotik_online/core/widget/container.dart';
import 'package:apotik_online/core/widget/loading.dart';
import 'package:apotik_online/core/widget/text.dart';
import 'package:apotik_online/core/widget/text_field_input.dart';
import 'package:apotik_online/feature/domain/entity/drugs_products_model.dart';
import 'package:apotik_online/feature/presentation/riverpod/drugs_riverpod.dart';
import 'package:apotik_online/feature/presentation/riverpod/image_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProductsScreen extends ConsumerStatefulWidget {
  const ProductsScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends ConsumerState<ProductsScreen> {
  final TextEditingController _name = TextEditingController();
  final TextEditingController _description = TextEditingController();
  final TextEditingController _price = TextEditingController(text: 'Rp. 0');
  final TextEditingController _stock = TextEditingController(text: '0');

  final _key = GlobalKey<FormState>();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args = ModalRoute.of(context)!.settings.arguments as List<int?>;
      if (args.length > 1) {
        final drugsState = ref.watch(drugsProvider);
        final product =
            drugsState.productsList.firstWhere((e) => e.id == args[1]);
        if (product.name != null) {
          _name.text = product.name!;
        }
        if (product.description != null) {
          _description.text = product.description!;
        }
        if (product.stock != null) {
          _stock.text = formatNumber(product.stock!, false);
        }
        if (product.price != null) {
          _price.text = formatNumber(product.price!, true);
        }
        if (product.picture != null) {
          setState(() {
            url = product.picture!;
          });
        }
      }
    });
    super.initState();
  }

  String url = '';

  String _cleanText(String text) {
    return text.replaceAll('Rp. ', '').replaceAll('.', '');
  }

  void _onPriceChanged() {
    final currentText = _cleanText(_price.text);
    final formatted = currentText.isNotEmpty
        ? formatNumber(int.parse(currentText), true)
        : 'Rp. 0';
    _price.value = TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }

  void _onStockChanged() {
    final currentText = _cleanText(_stock.text);
    final formatted = currentText.isNotEmpty
        ? formatNumber(int.parse(currentText), false)
        : '0';
    _stock.value = TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _name.dispose();
    _description.dispose();
    _price.dispose();
    _stock.dispose();
  }

  String category(int id) {
    return ref
        .watch(drugsProvider)
        .categoriesList
        .firstWhere((e) => e.id == id)
        .name!;
  }

  @override
  void deactivate() {
    ref.invalidate(imageProvider);
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as List<int?>;

    return Consumer(
      builder: (context, ref, widget) {
        final drugsWatch = ref.watch(drugsProvider);
        if (drugsWatch.state == GlobalState.loading) {
          return const Loading();
        } else {
          final imageFile = ref.watch(imageProvider);

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
                            height: 30,
                          ),
                          _picture(imageFile, args, drugsWatch),
                          if (imageFile.isNotEmpty)
                            TextButton(
                              onPressed: () {
                                ref.invalidate(imageProvider);
                              },
                              child: textUtils(
                                text: 'Hapus Foto',
                              ),
                            ),
                          _form(),
                          const SizedBox(
                            height: 16,
                          ),
                          const SizedBox(
                            height: 32,
                          ),
                          _updatePasswordButton(drugsWatch, args, imageFile),
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

  _picture(String imageFile, List<int?> args, DrugsProvider drugsWatch) {
    double radius = 120;
    return InkWell(
      onTap: () {
        showSource(context, false);
      },
      child: args.length > 1 && imageFile == ''
          ? containerUtils(
              borderRadius: 12,
              borderColor: black,
              height: radius,
              width: radius,
              child: url != ''
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        '$baseUrl/$url',
                        headers: const {
                          'Connection': 'keep-alive',
                          'Keep-Alive': 'timeout=60, max=100',
                        },
                        width: radius,
                        height: radius,
                        fit: BoxFit.cover,
                      ),
                    )
                  : Icon(
                      Icons.medication,
                      size: radius,
                      color: grey,
                    ),
            )
          : Stack(
              alignment: Alignment.bottomRight,
              children: [
                containerUtils(
                  borderRadius: 12,
                  borderColor: black,
                  width: radius,
                  height: radius,
                  child: imageFile.isNotEmpty
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.file(
                            File(imageFile),
                            width: radius,
                            height: radius,
                            fit: BoxFit.cover,
                          ),
                        )
                      : Icon(
                          Icons.medication,
                          color: grey,
                          size: radius,
                        ),
                ),
                imageFile.isNotEmpty
                    ? const SizedBox()
                    : Positioned(
                        bottom: 2.5,
                        right: 2.5,
                        child: CircleAvatar(
                          backgroundColor: greenCharum,
                          radius: 12,
                          child: Icon(
                            Icons.add,
                            color: white,
                            size: 16,
                          ),
                        ),
                      )
              ],
            ),
    );
  }

  _form() {
    return Column(
      children: [
        const SizedBox(
          height: 24,
        ),
        TextFieldInput(
          radius: false,
          textEditingController: _name,
          isPass: false,
          valid: (e) => Validator.validateNama(e),
          hintText: 'Name',
          textInputType: TextInputType.text,
        ),
        const SizedBox(
          height: 24,
        ),
        TextFieldInput(
          radius: false,
          textEditingController: _description,
          isPass: false,
          valid: (e) => Validator.validateDescription(e),
          hintText: 'Description',
          textInputType: TextInputType.text,
        ),
        const SizedBox(
          height: 24,
        ),
        TextFieldInput(
          function: (_) => _onPriceChanged(),
          radius: false,
          textEditingController: _price,
          isPass: false,
          valid: (e) => Validator.validatePrice(e),
          hintText: 'Price',
          textInputType: TextInputType.number,
        ),
        const SizedBox(
          height: 24,
        ),
        TextFieldInput(
          function: (_) => _onStockChanged(),
          radius: false,
          textEditingController: _stock,
          isPass: false,
          valid: (e) => Validator.validateStock(e),
          hintText: 'Stock',
          textInputType: TextInputType.number,
        ),
      ],
    );
  }

  _text(List<int?> args) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: textUtils(
            text:
                "${args.length <= 1 ? "Add new" : "Update"} product in ${category(args[0]!)}",
            weight: FontWeight.bold,
            size: 24,
          ),
        ),
        const SizedBox(height: 2),
        textUtils(
          text: "${args.length <= 1 ? "Add new" : "Update"} product for drugs",
        ),
      ],
    );
  }

  _updatePasswordButton(
      DrugsProvider drugsWatch, List<int?> args, String imageFile) {
    return InkWell(
      onTap: () async {
        if (_key.currentState!.validate()) {
          final isCreate = args.length <= 1;
          final model = DrugsProductsModel(
              id: isCreate ? null : args[1],
              name: capitalizeEachWord(_name.text),
              description: capitalizeEachWord(_description.text),
              price: int.parse(_cleanText(_price.text)),
              stock: int.parse(_cleanText(_stock.text)),
              categoryId: args[0],
              picture: isCreate
                  ? imageFile
                  : (imageFile.isNotEmpty ? imageFile : null));
          if (isCreate) {
            await ref.read(drugsProvider.notifier).createProducts(model: model);
          } else {
            await ref.read(drugsProvider.notifier).updateProducts(model: model);
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
          text: '${args.length <= 1 ? 'Create new' : 'Update'} product',
          color: white,
        ),
      ),
    );
  }
}
