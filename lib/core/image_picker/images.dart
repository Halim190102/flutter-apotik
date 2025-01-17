import 'package:apotik_online/core/color/colors.dart';
import 'package:apotik_online/core/widget/container.dart';
import 'package:apotik_online/core/widget/text.dart';
import 'package:apotik_online/feature/domain/entity/profile_model.dart';
import 'package:apotik_online/feature/presentation/riverpod/auth_riverpod.dart';
import 'package:apotik_online/feature/presentation/riverpod/image_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

showSource(BuildContext context, bool update) {
  return showModalBottomSheet(
    showDragHandle: true,
    isScrollControlled: true,
    backgroundColor: white,
    context: context,
    builder: (BuildContext context) {
      return ShowSource(update: update);
    },
  );
}

class ShowSource extends ConsumerStatefulWidget {
  const ShowSource({
    required this.update,
    super.key,
  });
  final bool update;

  @override
  ConsumerState<ShowSource> createState() => _ShowSourceState();
}

class _ShowSourceState extends ConsumerState<ShowSource> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _source('Galeri', size),
          _source('Kamera', size),
        ],
      ),
    );
  }

  _source(String source, Size size) {
    return InkWell(
      onTap: () async {
        final pickedImage = await _cropImage(
            source == 'Galeri' ? ImageSource.gallery : ImageSource.camera);
        if (widget.update) {
          if (pickedImage != null) {
            ref.read(authProvider.notifier).updateImage(
                  model: ProfileModel(
                    profilepict: pickedImage,
                  ),
                );
          }
        } else {
          final imageWatch = ref.watch(imageProvider);

          ref.read(imageProvider.notifier).state =
              imageWatch != '' ? imageWatch : pickedImage ?? '';
        }
        if (!mounted) return;
        Navigator.pop(context);
      },
      child: containerUtils(
        width: size.width * .45,
        height: size.height * .05,
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(vertical: 12),
        borderRadius: 10,
        color: greenCharum,
        child: textUtils(
          text: source,
          color: white,
        ),
      ),
    );
  }

  _pickImage(ImageSource source) async {
    final ImagePicker imagePicker = ImagePicker();
    XFile? file = await imagePicker.pickImage(
      source: source,
    );

    if (file != null) {
      return file;
    }
  }

  _cropImage(
    ImageSource source,
  ) async {
    XFile? xfile = await _pickImage(source);

    if (xfile != null) {
      final cropped = await ImageCropper()
          .cropImage(sourcePath: xfile.path, aspectRatioPresets: [
        CropAspectRatioPreset.square,
      ], uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Crop',
          toolbarColor: green,
          toolbarWidgetColor: white,
          cropGridColor: black,
          initAspectRatio: CropAspectRatioPreset.square,
          lockAspectRatio: true,
        ),
        IOSUiSettings(
          title: 'Crop',
          aspectRatioLockEnabled: true,
        )
      ]);

      if (cropped != null) {
        return cropped.path;
      } else {
        return null;
      }
    }
  }
}
