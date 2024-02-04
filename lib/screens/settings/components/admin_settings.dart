import 'package:flutter/material.dart';

import 'edit_admin_bottomsheet.dart';
import 'create_coupon_bottomsheet.dart';
import 'remove_coupon_bottomsheet.dart';

class AdminSettings extends StatefulWidget {
  const AdminSettings({super.key});

  @override
  State<AdminSettings> createState() => _AdminSettingsState();
}

class _AdminSettingsState extends State<AdminSettings> {
  List<Widget> tabs = [
    const EditAdmin(),
    const CreateCoupon(),
    const RemoveCoupon(),
  ];

  void openBottomSheet(BuildContext context, Widget tab) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (context) => DraggableScrollableSheet(
        minChildSize: 0.2,
        expand: false,
        builder: (_, controller) => ListView(
          controller: controller,
          children: [
            Icon(
              Icons.remove,
              color: Colors.grey[600],
            ),
            Expanded(
              child: tab,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: const Text('Edit Admin'),
          onTap: () {
            openBottomSheet(context, tabs[0]);
          },
        ),
        ListTile(
          title: const Text('Create Coupon'),
          onTap: () {
            openBottomSheet(context, tabs[1]);
          },
        ),
        ListTile(
          title: const Text('Enable/Disable Coupon'),
          onTap: () {
            openBottomSheet(context, tabs[2]);
          },
        ),
      ],
    );
  }
}
