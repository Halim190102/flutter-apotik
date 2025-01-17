import 'package:apotik_online/core/color/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextFieldInput extends StatefulWidget {
  const TextFieldInput({
    super.key,
    required this.textEditingController,
    required this.isPass,
    required this.hintText,
    required this.textInputType,
    required this.radius,
    this.function,
    this.delete,
    this.valid,
  });

  final TextEditingController textEditingController;
  final bool isPass;
  final String hintText;
  final TextInputType textInputType;
  final bool radius;
  final Function(String)? function;
  final Function()? delete;
  final String? Function(String?)? valid;

  @override
  State<TextFieldInput> createState() => _TextFieldInputState();
}

class _TextFieldInputState extends State<TextFieldInput> {
  bool _passwordVisible = true;
  bool submit = true;

  @override
  Widget build(BuildContext context) {
    final inputBorder = OutlineInputBorder(
      borderSide: BorderSide(color: grey),
      borderRadius: BorderRadius.circular(
        widget.radius ? 20 : 5,
      ),
    );
    return TextFormField(
      validator: widget.valid,
      autovalidateMode: widget.valid != null ? AutovalidateMode.disabled : null,
      onTap: () {
        setState(() {
          !submit;
        });
      },
      onChanged: widget.function,
      enableInteractiveSelection: false,
      controller: widget.textEditingController,
      decoration: InputDecoration(
        errorStyle: TextStyle(color: red, fontSize: 12),
        prefixIcon: widget.radius ? const Icon(CupertinoIcons.search) : null,
        fillColor: widget.radius ? lightGrey : white,
        labelText: widget.hintText,
        labelStyle: TextStyle(
          color: black,
        ),
        border: inputBorder,
        enabledBorder: inputBorder,
        focusedBorder: inputBorder,
        errorBorder: inputBorder,
        disabledBorder: inputBorder,
        filled: true,
        contentPadding: const EdgeInsets.all(8),
        suffixIcon: widget.delete != null
            ? GestureDetector(
                onTap: widget.delete,
                child: Icon(
                  Icons.close,
                  color: grey,
                ),
              )
            : widget.isPass
                ? GestureDetector(
                    onLongPress: () {
                      setState(() {
                        _passwordVisible = false;
                      });
                    },
                    onLongPressEnd: (_) {
                      setState(() {
                        _passwordVisible = true;
                      });
                    },
                    child: Icon(
                      _passwordVisible
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      color: grey,
                    ),
                  )
                : null,
      ),
      inputFormatters: widget.textInputType == TextInputType.number
          ? [FilteringTextInputFormatter.digitsOnly]
          : null,
      keyboardType: widget.textInputType,
      obscureText: widget.isPass ? _passwordVisible : false,
    );
  }
}

// class ImageTextField extends StatefulWidget {
//   const ImageTextField({
//     super.key,
//     required this.controller,
//   });

//   final TextEditingController controller;

//   @override
//   State<ImageTextField> createState() => _ImageTextFieldState();
// }

// class _ImageTextFieldState extends State<ImageTextField> {
//   // bool _image = false;
//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       alignment: AlignmentDirectional.topCenter,
//       children: [
//         TextFormField(
//           controller: widget.controller,
//           // validator: (e) {
//           //   e!.isEmpty ? _image = true : _image = false;
//           //   setState(() {});
//           //   return null;
//           // },
//           decoration: const InputDecoration(
//             filled: false,
//             border: InputBorder.none,
//             enabled: false,
//             contentPadding: EdgeInsets.zero,
//             errorStyle: TextStyle(fontSize: 0),
//           ),
//           style: const TextStyle(fontSize: 0),
//         ),
//         // if (_image)
//         //   Container(
//         //     margin: const EdgeInsets.only(top: 20),
//         //     child: Text(
//         //       'Image cannot be empty',
//         //       style: TextStyle(
//         //         color: red,
//         //         fontSize: 12,
//         //       ),
//         //     ),
//         //   ),
//       ],
//     );
//   }
// }
