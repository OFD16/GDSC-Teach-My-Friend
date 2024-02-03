import 'package:Sharey/helpers/index.dart';
import 'package:Sharey/models/Coupon.dart';
import 'package:Sharey/screens/products/products_screen.dart';
import 'package:Sharey/services/coupon_services.dart';
import 'package:flutter/material.dart';

import 'section_title.dart';

class SpecialOffers extends StatefulWidget {
  const SpecialOffers({
    Key? key,
  }) : super(key: key);

  @override
  State<SpecialOffers> createState() => _SpecialOffersState();
}

class _SpecialOffersState extends State<SpecialOffers> {
  CouponService couponService = CouponService();

  List<Coupon> initCoupons = [];

  bool isLoading = true;

  Future<void> _fetchFeed() async {
    setState(() {
      isLoading = true;
    });
    List<Coupon> coupons = await couponService.getAvailableCoupons();
    setState(() {
      initCoupons = coupons;
      isLoading = false;
    });
  }

  void initState() {
    super.initState();
    _fetchFeed();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SectionTitle(
            title: "Special for you",
            press: () {
              Navigator.pushNamed(
                context,
                ProductsScreen.routeName,
                arguments: ProductsArguments(coupons: initCoupons),
              );
            },
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              ...List.generate(
                initCoupons.length,
                (index) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 20),
                    child: SpecialOfferCard(
                      coupon: initCoupons[index],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class SpecialOfferCard extends StatelessWidget {
  const SpecialOfferCard({
    Key? key,
    required this.coupon,
    this.press,
  }) : super(key: key);

  final Coupon coupon;
  final GestureTapCallback? press;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20),
      child: GestureDetector(
        onTap: press,
        child: SizedBox(
          width: 242,
          height: 100,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Stack(
              children: [
                isLink(coupon.images![0])
                    ? Image.network(coupon.images![0], fit: BoxFit.cover)
                    : Image.asset(
                        coupon.images![0],
                        fit: BoxFit.cover,
                      ),
                Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black54,
                        Colors.black38,
                        Colors.black26,
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 10,
                  ),
                  child: Text.rich(
                    TextSpan(
                      style: const TextStyle(color: Colors.white),
                      children: [
                        TextSpan(
                          text: "${coupon.title}\n",
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                            text:
                                "${coupon.brand} ${coupon.couponOwners?.length}/${coupon.count}"),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
