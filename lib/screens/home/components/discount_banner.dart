import 'package:Sharey/models/Coupon.dart';
import 'package:Sharey/services/coupon_services.dart';
import 'package:flutter/material.dart';

class DiscountBanner extends StatefulWidget {
  const DiscountBanner({
    required this.couponID,
    Key? key,
    this.couponData,
  }) : super(key: key);

  final String couponID;
  final Coupon? couponData;
  @override
  State<DiscountBanner> createState() => _DiscountBannerState();
}

class _DiscountBannerState extends State<DiscountBanner> {
  CouponService couponService = CouponService();
  late Coupon coupon;

  @override
  void initState() {
    super.initState();
    if (widget.couponData != null) {
      coupon = widget.couponData!;
    } else {
      coupon = Coupon(
          id: '1',
          title: 'test',
          description: 'test',
          count: 4,
          pricePoint: 20,
          images: [],
          createdAt: DateTime.now(),
          updatedAt: DateTime.now());
      _fetchCoupon();
    }
  }

  Future<void> _fetchCoupon() async {
    Coupon? initCoupon = await couponService.getCoupon(widget.couponID);
    if (mounted) {
      setState(() {
        if (initCoupon != null && mounted) {
          coupon = initCoupon;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 16,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF4A3298),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text.rich(
        TextSpan(
          style: const TextStyle(color: Colors.white),
          children: [
            TextSpan(text: "${coupon.description}\n"),
            TextSpan(
              text: coupon.title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
