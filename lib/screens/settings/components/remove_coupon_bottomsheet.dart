import 'package:Sharey/screens/home/components/special_offers.dart';
import 'package:flutter/material.dart';

import '../../../models/Coupon.dart';
import '../../../services/coupon_services.dart';

class RemoveCoupon extends StatefulWidget {
  const RemoveCoupon({super.key});

  @override
  State<RemoveCoupon> createState() => _RemoveCouponState();
}

class _RemoveCouponState extends State<RemoveCoupon> {
  final CouponService _couponServices = CouponService();
  List<Coupon> coupons = [];

  @override
  void initState() {
    super.initState();
    getCoupons();
  }

  void getCoupons() async {
    final List<Coupon> _coupons = await _couponServices.getAvailableCoupons();
    if (mounted) {
      setState(() {
        coupons = _coupons;
      });
    }
  }

  void disableCoupon(Coupon coupon) async {
    final bool result = await _couponServices.removeCoupon(coupon);
    if (result) {
      getCoupons();
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 10),
        const Text(
          'Enable/Disable Coupon',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        Column(
          children: [
            ...List.generate(
              coupons.length,
              (index) => Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SpecialOfferCard(
                        coupon: coupons[index],
                        press: () {},
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 20),
                        child: coupons[index].enable
                            ? InkWell(
                                onTap: () {
                                  disableCoupon(coupons[index]);
                                  setState(() {
                                    coupons[index].enable = false;
                                  });
                                },
                                child: const Column(
                                  children: [
                                    Icon(
                                      Icons.remove_circle,
                                      color: Colors.red,
                                    ),
                                    Text('Remove'),
                                  ],
                                ),
                              )
                            : InkWell(
                                onTap: () {
                                  disableCoupon(coupons[index]);
                                  setState(() {
                                    coupons[index].enable = true;
                                  });
                                },
                                child: const Column(
                                  children: [
                                    Icon(
                                      Icons.add_circle,
                                      color: Colors.green,
                                    ),
                                    Text('Enable'),
                                  ],
                                ),
                              ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        )
      ],
    );
  }
}
      // Open popup to remove coupon
      // press: () {
      //                     showDialog(
      //                       context: context,
      //                       builder: (BuildContext context) {
      //                         return AlertDialog(
      //                           title: const Text('Enable/Disable Coupon'),
      //                           content: const Text(
      //                               'Are you sure you want to remove this coupon?'),
      //                           actions: [
      //                             TextButton(
      //                               onPressed: () {
      //                                 Navigator.pop(context);
      //                               },
      //                               child: const Text('Cancel'),
      //                             ),
      //                             TextButton(
      //                               onPressed: () {
      //                                 disableCoupon(coupons[index]);
      //                                 setState(() {
      //                                   if (coupons[index].enable) {
      //                                     coupons[index].enable = false;
      //                                   } else {
      //                                     coupons[index].enable = true;
      //                                   }
      //                                 });
      //                               },
      //                               child: const Text('Remove'),
      //                             ),
      //                           ],
      //                         );
      //                       },
      //                     );
      //                   },