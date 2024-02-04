import 'package:flutter/material.dart';

import '../../constants.dart';

class TextInput extends StatelessWidget {
  final String? hintText, title, initialValue;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final Widget? prefixIcon;
  final Widget? trailing;
  void Function(String)? onChanged;
  void Function()? onFinish;

  TextInput({
    Key? key,
    this.initialValue,
    this.hintText,
    this.title,
    this.onChanged,
    this.onFinish,
    this.prefixIcon,
    this.trailing,
    this.controller,
    this.keyboardType = TextInputType.text,
  }) : super(key: key);

  static const searchOutlineInputBorder = OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(12)),
    borderSide: BorderSide.none,
  );

  @override
  Widget build(BuildContext context) {
    if (controller != null && initialValue != null) {
      controller!.text = initialValue!;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              title != null && title != ""
                  ? Text(
                      title!,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    )
                  : const SizedBox(),
              trailing ?? const SizedBox(),
            ],
          ),
          const SizedBox(height: 8),
          TextFormField(
            initialValue: controller != null ? null : initialValue,
            controller: controller,
            keyboardType: keyboardType,
            onChanged: onChanged,
            onEditingComplete: onFinish,
            onSaved: (v) => {
              onFinish,
            },
            decoration: InputDecoration(
              filled: true,
              fillColor: kSecondaryColor.withOpacity(0.1),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              border: searchOutlineInputBorder,
              focusedBorder: searchOutlineInputBorder,
              enabledBorder: searchOutlineInputBorder,
              hintText: hintText ?? "Title of your content",
              prefixIcon: prefixIcon,
            ),
          ),
        ],
      ),
    );
  }
}
