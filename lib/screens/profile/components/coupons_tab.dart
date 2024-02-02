import 'package:Sharey/models/Coupon.dart';
import 'package:Sharey/screens/home/components/discount_banner.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/auth_user_provider.dart';
import '../../../services/coupon_services.dart';

class CouponsTab extends StatefulWidget {
  const CouponsTab({super.key});

  @override
  State<CouponsTab> createState() => _CouponsTabState();
}

class _CouponsTabState extends State<CouponsTab> {
  CouponService couponService = CouponService();
  late AuthUserProvider authUserProvider;
  List<Coupon> coupons = [];

  @override
  void initState() {
    super.initState();
    authUserProvider = Provider.of<AuthUserProvider>(context, listen: false);
    String? userId = authUserProvider.authUser?.id;

    if (userId != null) {
      getCoupons(userId);
    }
  }

  Future<List<Coupon>> getCoupons(String id) async {
    couponService.getUserCoupons(id).then((value) {
      setState(() {
        coupons = value;
      });
    });
    return coupons;
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: coupons.length,
      itemBuilder: (context, index) {
        Coupon? coupon = coupons[index];
        return DiscountBanner(couponID: coupon.id!, couponData: coupon);
      },
    );
  }
}
