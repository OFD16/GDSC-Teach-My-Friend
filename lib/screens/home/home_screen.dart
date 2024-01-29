import 'package:Sharey/services/feed_services.dart';
import 'package:flutter/material.dart';

import 'components/categories.dart';
import 'components/discount_banner.dart';
import 'components/home_header.dart';
import 'components/popular_product.dart';
import 'components/special_offers.dart';

class HomeScreen extends StatefulWidget {
  static String routeName = "/home";

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  FeedService couponService = FeedService();
  late List<String> initCouponIDs = []; //"8BwXMNVrrYCI5gZY4let"
  bool isLoading = true;

  Future<void> _fetchFeed() async {
    setState(() {
      isLoading = true;
    });
    List<String> ids = await couponService.getCouponList();
    setState(() {
      initCouponIDs = ids;
      isLoading = false;
    });
  }

  void initState() {
    super.initState();
    _fetchFeed();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            children: [
              const HomeHeader(),
              isLoading
                  ? const Column(
                      children: [
                        CircularProgressIndicator(),
                        Text("Loading..."),
                      ],
                    )
                  : DiscountBanner(
                      couponID: initCouponIDs[0],
                    ),
              const Categories(),
              const SpecialOffers(),
              const SizedBox(height: 20),
              const PopularProducts(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
