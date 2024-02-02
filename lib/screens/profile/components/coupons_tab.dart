import 'package:Sharey/models/Coupon.dart';
import '../../../constants.dart';

import 'package:Sharey/screens/home/components/discount_banner.dart';
import 'package:Sharey/screens/profile/components/empty_status.dart';
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
  bool isLoading = false;

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
    setState(() {
      isLoading = true;
    });
    couponService.getUserCoupons(id).then((value) {
      setState(() {
        coupons = value;
        isLoading = false;
      });
    });
    return coupons;
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(
          child: Padding(
        padding: EdgeInsets.all(30),
        child: CircularProgressIndicator(color: kPrimaryColor),
      ));
    }

    if (coupons.isEmpty) {
      return const EmptyStatus();
    }
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
