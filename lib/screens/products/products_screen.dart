import 'package:Sharey/models/Lesson.dart';
import 'package:Sharey/providers/auth_user_provider.dart';
import 'package:Sharey/screens/home/components/special_offers.dart';
import 'package:Sharey/services/lesson_services.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../components/product_card.dart';
import '../../models/Coupon.dart';
import '../../models/User.dart';
import '../details/details_screen.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  static String routeName = "/products";

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  LessonService lessonService = LessonService();
  List<Lesson> initLessons = [];
  List<Coupon> initCoupons = [];
  String title = "Products";

  bool isLoading = true;

  void didChangeDependencies() async {
    super.didChangeDependencies();

    // Get the arguments
    ProductsArguments? args =
        ModalRoute.of(context)?.settings.arguments as ProductsArguments?;

    // Check if the arguments are not null
    if (args != null) {
      // Update the user in the widget
      if (args.lessons != null) {
        setState(() {
          initLessons = args.lessons!;
          title = "Lessons";
        });
      } else if (args.coupons != null) {
        setState(() {
          initCoupons = args.coupons!;
          title = "Coupons";
        });
      }

      // Trigger a rebuild after user data is fetched
      print("lessonslist screen1: ${initLessons.toList()}");
    }
  }

  void likeLesson(Lesson lesson) async {
    User authUser =
        Provider.of<AuthUserProvider>(context, listen: false).authUser!;

    await lessonService.likeLesson(lesson.id!, authUser.id!);
  }

  void unlikeLesson(Lesson lesson) async {
    User authUser =
        Provider.of<AuthUserProvider>(context, listen: false).authUser!;

    await lessonService.unlikeLesson(lesson.id!, authUser.id!);
  }

  @override
  Widget build(BuildContext context) {
    print("lessonslist screen2: ${initLessons.toList()}");
    print("initCoupons screen2: ${initCoupons.toList()}");
    AuthUserProvider authUserProvider =
        Provider.of<AuthUserProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: GridView.builder(
            itemCount: initLessons.isNotEmpty
                ? initLessons.length
                : initCoupons.length,
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 200,
              childAspectRatio: initLessons.isNotEmpty ? 0.7 : 1.2,
              mainAxisSpacing: 20,
              crossAxisSpacing: 16,
            ),
            itemBuilder: (context, index) => initLessons.isNotEmpty
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: ProductCard(
                      isFavourite: initLessons[index]
                          .likes
                          .contains(authUserProvider.authUser!.id),
                      lesson: initLessons[index],
                      onFavouritePress: () {
                        setState(() {
                          if (initLessons[index]
                              .likes
                              .contains(authUserProvider.authUser!.id)) {
                            initLessons[index]
                                .likes
                                .remove(authUserProvider.authUser!.id);
                            unlikeLesson(initLessons[index]);
                          } else {
                            initLessons[index]
                                .likes
                                .add(authUserProvider.authUser!.id!);
                            likeLesson(initLessons[index]);
                          }
                        });
                      },
                      onPress: () => Navigator.pushNamed(
                        context,
                        DetailsScreen.routeName,
                        arguments:
                            ProductDetailsArguments(lesson: initLessons[index]),
                      ),
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: SpecialOfferCard(
                      coupon: initCoupons[index],
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}

class ProductsArguments {
  final List<Lesson>? lessons;
  final List<Coupon>? coupons;

  ProductsArguments({this.lessons, this.coupons});
}
