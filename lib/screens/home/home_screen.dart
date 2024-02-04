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
  late List<String> initCouponIDs = [];
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
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: initCouponIDs.length,
                      itemBuilder: (BuildContext context, int index) {
                        return DiscountBanner(
                          couponID: initCouponIDs[index],
                        );
                      },
                    ),
              Categories(selected: 4),
              const SpecialOffers(),
              const SizedBox(height: 20),
              PopularProducts(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
