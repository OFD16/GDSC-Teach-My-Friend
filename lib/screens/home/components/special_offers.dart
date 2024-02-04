import 'package:Sharey/helpers/index.dart';
import 'package:Sharey/local_storage/auth_storage.dart';
import 'package:Sharey/models/Coupon.dart';
import 'package:Sharey/screens/products/products_screen.dart';
import 'package:Sharey/services/coupon_services.dart';
import 'package:Sharey/services/user_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../../models/User.dart';
import '../../../providers/auth_user_provider.dart';
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
    List<Coupon> coupons =
        await couponService.getAvailableCoupons(isFiltered: true);
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

class SpecialOfferCard extends StatefulWidget {
  const SpecialOfferCard({
    Key? key,
    required this.coupon,
    this.press,
  }) : super(key: key);

  final Coupon coupon;
  final GestureTapCallback? press;

  @override
  State<SpecialOfferCard> createState() => _SpecialOfferCardState();
}

class _SpecialOfferCardState extends State<SpecialOfferCard> {
  User? authUser;

  // Set authUser to context
  void setInitUser(BuildContext context) async {
    AuthUserProvider authUserProvider =
        Provider.of<AuthUserProvider>(context, listen: false);

    authUser = authUserProvider.authUser;
  }

  void initState() {
    super.initState();
    setInitUser(context); // Pass the context parameter
  }

  void getCoupon() async {
    if (authUser!.points! >= widget.coupon.pricePoint!) {
      Coupon updatedCoupon = widget.coupon;
      updatedCoupon.couponOwners!.add(authUser!.id!);
      AuthUserProvider authUserProvider =
          Provider.of<AuthUserProvider>(context, listen: false);

      User updatedUser = authUser!;
      updatedUser.points = authUser!.points! - widget.coupon.pricePoint!;

      await CouponService().updateCoupon(updatedCoupon.id!, updatedCoupon);
      await UserService().updateUser(updatedUser);

      authUserProvider.setAuthUser(updatedUser);
      AuthStorage().setAuthUser(updatedUser);

      setState(() {
        authUser!.points = authUser!.points! - widget.coupon.pricePoint!;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('You do not have enough points to get this coupon.'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void openDialog() {
    print("authUser: $authUser");
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Builder(
          builder: (BuildContext context) => AlertDialog(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Text(
                //   "Get this coupon",
                //   style: TextStyle(
                //     color: widget.coupon.couponOwners?.length ==
                //             widget.coupon.count
                //         ? Colors.red
                //         : Colors.black,
                //     fontSize: 20,
                //   ),
                // ),
                Row(
                  children: [
                    Text(
                      "Your Points: ${authUser!.points! > 0 ? authUser!.points : 0}",
                      style: const TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    SvgPicture.asset(
                      "assets/icons/point.svg",
                      width: 20,
                      height: 20,
                    ),
                  ],
                ),
              ],
            ),
            content: Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Coupon owners ${widget.coupon.couponOwners?.length} of ${widget.coupon.count},",
                    style: TextStyle(
                      color: widget.coupon.couponOwners?.length ==
                              widget.coupon.count
                          ? Colors.red
                          : Colors.black,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    "You can get this coupon for ${widget.coupon.pricePoint} points.",
                    style: TextStyle(
                      color: widget.coupon.couponOwners?.length ==
                              widget.coupon.count
                          ? Colors.red
                          : Colors.black,
                      fontSize: 16,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () {
                            getCoupon();
                            Navigator.pop(context);
                          },
                          child: const SizedBox(
                            child: Column(
                              children: [
                                Icon(Icons.sell),
                                Text("Get This Coupon"),
                              ],
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: const SizedBox(
                            child: Column(
                              children: [
                                Icon(Icons.cancel),
                                Text("Not Now"),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20),
      child: GestureDetector(
        onTap: () => {
          if (widget.press != null)
            {widget.press!()}
          else
            {
              if (widget.coupon.couponOwners!.contains(authUser!.id))
                {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('You already have this coupon.'),
                      duration: Duration(seconds: 2),
                    ),
                  ),
                }
              else
                {
                  openDialog(),
                },
            }
        },
        child: SizedBox(
          width: 242,
          height: 100,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Stack(
              children: [
                isLink(widget.coupon.images![0])
                    ? Image.network(widget.coupon.images![0],
                        fit: BoxFit.fitWidth)
                    : Image.asset(
                        widget.coupon.images![0],
                        fit: BoxFit.fitWidth,
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
                          text: "${widget.coupon.title}\n",
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text:
                              "${widget.coupon.brand} ${widget.coupon.couponOwners?.length}/${widget.coupon.count}",
                        ),
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
