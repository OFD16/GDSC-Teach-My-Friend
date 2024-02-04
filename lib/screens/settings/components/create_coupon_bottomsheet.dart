import 'dart:math';

import 'package:Sharey/screens/create_content/text_input.dart';
import 'package:Sharey/services/coupon_services.dart';
import 'package:Sharey/services/user_services.dart';
import 'package:flutter/material.dart';

import '../../../models/Coupon.dart';
import '../../../models/User.dart';
import '../../create_content/components/custom_content_card.dart';

class CreateCoupon extends StatefulWidget {
  const CreateCoupon({super.key});

  @override
  State<CreateCoupon> createState() => _CreateCouponState();
}

class _CreateCouponState extends State<CreateCoupon> {
  final CouponService _couponServices = CouponService();
  final UserService _userServices = UserService();
  bool isBrandSearching = false, isBrandExist = false, isCouponCreated = false;
  bool isCouponOwnerSearching = false;

  final TextEditingController _brandController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _pricePointController = TextEditingController();
  final TextEditingController _countController = TextEditingController();
  final TextEditingController _couponOwnerController = TextEditingController();
  String brandId = "s", id = "";
  List<User> findedUsers = [];
  List<String> couponOwners = [];
  List<String> images = [];

  @override
  void initState() {
    super.initState();
  }

  void searchBrand() async {
    setState(() {
      isBrandSearching = true;
    });
    Coupon? _coupon =
        await _couponServices.findCouponByBrand(_brandController.text);

    setState(() {
      if (_coupon != null) {
        brandId = _coupon.id!;
        isBrandExist = true;
      } else {
        brandId = generateRandomId();
        isBrandExist = false;
      }
      isBrandSearching = false;
    });
  }

  String generateRandomId({int length = 20}) {
    const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    final random = Random();
    return String.fromCharCodes(
      Iterable.generate(
        length,
        (_) => chars.codeUnitAt(random.nextInt(chars.length)),
      ),
    );
  }

  void searchUser() async {
    setState(() {
      isCouponOwnerSearching = true;
    });

    List<User> users =
        await _userServices.searchUsers(_couponOwnerController.text);
    setState(() {
      if (users.isNotEmpty) {
        findedUsers = users;
      }
      isCouponOwnerSearching = false;
    });
  }

  void createCoupon() async {
    setState(() {
      isCouponCreated = true;
    });
    Coupon coupon = Coupon(
      brand: _brandController.text,
      brandId: brandId,
      count: int.parse(_countController.text),
      couponOwners: couponOwners,
      description: _descriptionController.text,
      id: generateRandomId(),
      images: images,
      pricePoint: int.parse(_pricePointController.text),
      title: _titleController.text,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    await _couponServices.createCoupon(coupon);
    if (mounted) {
      setState(() {
        isCouponCreated = false;
      });

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextInput(
          title: "Coupon Brand",
          hintText: "Brand Name",
          controller: _brandController,
          onFinish: () => searchBrand(),
          trailing: isBrandSearching
              ? const CircularProgressIndicator()
              : Icon(
                  isBrandExist ? Icons.check_circle : Icons.circle_outlined,
                  color: Colors.green,
                ),
        ),
        TextInput(
          title: "Coupon Title",
          hintText: "Coupon Title",
          controller: _titleController,
        ),
        TextInput(
          title: "Coupon Description",
          hintText: "Coupon Description",
          controller: _descriptionController,
        ),
        Row(
          children: [
            Expanded(
              child: TextInput(
                title: "Coupon Price Point",
                hintText: "Coupon Price Point",
                controller: _pricePointController,
                keyboardType: TextInputType.number,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: TextInput(
                title: "Coupon Count",
                hintText: "Coupon Count",
                controller: _countController,
                keyboardType: TextInputType.number,
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Coupon Images",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              CustomContentCard(
                imagePath: "coupon_images",
                onImageUploaded: (data) {
                  setState(() {
                    images = data["imageUrls"];
                  });
                },
              ),
            ],
          ),
        ),
        TextInput(
          title: "Coupon Owners",
          hintText: "Coupon Owners",
          controller: _couponOwnerController,
          onFinish: () => searchUser(),
          trailing: isCouponOwnerSearching
              ? const CircularProgressIndicator()
              : Icon(
                  isCouponOwnerSearching
                      ? Icons.check_circle
                      : Icons.circle_outlined,
                  color: Colors.green,
                ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                ...findedUsers
                    .map((user) => Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: ChoiceChip(
                            label: Text("${user.firstName} ${user.lastName}"),
                            selected: couponOwners.contains(user.id),
                            onSelected: (bool selected) {
                              setState(() {
                                if (selected) {
                                  couponOwners.add(user.id!);
                                } else {
                                  couponOwners.remove(user.id);
                                }
                              });
                            },
                          ),
                        ))
                    .toList(),
              ],
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(20),
          child: ElevatedButton(
            onPressed: () => createCoupon(),
            child: isCouponCreated
                ? const CircularProgressIndicator()
                : const Text('Create Coupon'),
          ),
        )
      ],
    );
  }
}
