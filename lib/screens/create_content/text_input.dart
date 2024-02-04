import 'package:flutter/material.dart';

import '../../constants.dart';

class TextInput extends StatelessWidget {
  final String? hintText, title;
  final TextEditingController? controller;
  final Widget? prefixIcon;
  void Function(String)? onChanged;

  TextInput({
    Key? key,
    this.hintText,
    this.title,
    this.onChanged,
    this.prefixIcon,
    this.controller,
  }) : super(key: key);

  static const searchOutlineInputBorder = OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(12)),
    borderSide: BorderSide.none,
  );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          title != null && title != ""
              ? Text(
                  title!,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                )
              : const SizedBox(),
          const SizedBox(height: 8),
          TextFormField(
            controller: controller,
            onChanged: onChanged,
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
