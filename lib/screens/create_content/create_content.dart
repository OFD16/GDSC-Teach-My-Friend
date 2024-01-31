import 'package:Sharey/services/feed_services.dart';
import 'package:flutter/material.dart';

class CreateContentScreen extends StatefulWidget {
  static String routeName = "/create_content";

  const CreateContentScreen({Key? key}) : super(key: key);

  @override
  State<CreateContentScreen> createState() => _CreateContentScreenState();
}

class _CreateContentScreenState extends State<CreateContentScreen> {
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

  @override
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
            children: [Text("Create Content")],
          ),
        ),
      ),
    );
  }
}
