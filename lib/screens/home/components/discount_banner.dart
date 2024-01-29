import 'package:Sharey/models/Coupon.dart';
import 'package:Sharey/services/coupon_services.dart';
import 'package:flutter/material.dart';

class DiscountBanner extends StatefulWidget {
  const DiscountBanner({
    required this.couponID,
    Key? key,
  }) : super(key: key);

  final String couponID;
  @override
  State<DiscountBanner> createState() => _DiscountBannerState();
}

class _DiscountBannerState extends State<DiscountBanner> {
  CouponService couponService = CouponService();
  Coupon coupon = Coupon(
      id: '1',
      title: 'test',
      description: 'test',
      count: 4,
      pricePoint: 20,
      images: [],
      createdAt: DateTime.now(),
      updatedAt: DateTime.now());

  Future<void> _fetchCoupon() async {
    Coupon? initCoupon = await couponService.getCoupon(widget.couponID);
    setState(() {
      if (initCoupon != null) {
        coupon = initCoupon;
      }
    });
  }

  void initState() {
    super.initState();
    _fetchCoupon();
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
          style: TextStyle(color: Colors.white),
          children: [
            TextSpan(text: "${coupon.description}\n"),
            TextSpan(
              text: coupon.title,
              style: TextStyle(
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
