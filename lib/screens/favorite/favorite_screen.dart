import 'package:Sharey/components/product_card.dart';
import 'package:Sharey/models/Product.dart';
import 'package:Sharey/models/User.dart';
import 'package:Sharey/providers/auth_user_provider.dart';
import 'package:Sharey/screens/home/home_screen.dart';
import 'package:Sharey/services/lesson_services.dart';
import 'package:Sharey/services/user_services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/Lesson.dart';
import '../details/details_screen.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  LessonService lessonService = LessonService();
  UserService userService = UserService();
  List<Lesson> favouriteLessons = [];
  User? user;
  bool loading = false;

  void getFavourites() async {
    try {
      User user =
          Provider.of<AuthUserProvider>(context, listen: false).authUser!;

      User? updatedUser = await userService.getUser(user.id!);

      List<Lesson> lessons =
          await lessonService.getFavouriteLessons(updatedUser!.favourites!);
      print("lessons: $lessons");
      setState(() {
        user = updatedUser;
        favouriteLessons = lessons;
      });
    } catch (e) {
      print('Error getting favourites: $e');
    }
  }

  void likeLesson(Lesson lesson) async {
    setState(() {
      loading = true;
    });
    User authUser =
        Provider.of<AuthUserProvider>(context, listen: false).authUser!;

    await lessonService.likeLesson(lesson.id!, authUser.id!);
    setState(() {
      loading = false;
    });
  }

  void unlikeLesson(Lesson lesson) async {
    setState(() {
      loading = true;
    });
    User authUser =
        Provider.of<AuthUserProvider>(context, listen: false).authUser!;

    await lessonService.unlikeLesson(lesson.id!, authUser.id!);
    setState(() {
      loading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getFavourites();
  }

  @override
  Widget build(BuildContext context) {
    User authUser =
        Provider.of<AuthUserProvider>(context, listen: false).authUser!;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favourites'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: favouriteLessons.isNotEmpty
            ? GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: 0.75,
                ),
                itemCount: favouriteLessons.length,
                itemBuilder: (context, index) {
                  return ProductCard(
                    lesson: favouriteLessons[index],
                    onFavouritePress: () {
                      setState(() {
                        if (favouriteLessons[index]
                            .likes
                            .contains(authUser.id)) {
                          favouriteLessons[index].likes.remove(authUser.id);
                          unlikeLesson(favouriteLessons[index]);
                        } else {
                          favouriteLessons[index].likes.add(authUser.id!);
                          likeLesson(favouriteLessons[index]);
                        }
                      });
                    },
                    onPress: () => Navigator.pushNamed(
                      context,
                      DetailsScreen.routeName,
                      arguments: ProductDetailsArguments(
                          lesson: favouriteLessons[index]),
                    ),
                    isFavourite:
                        favouriteLessons[index].likes.contains(authUser.id),
                  );
                },
              )
            : Center(
                child: Column(
                  children: [
                    const Text('No favourite lessons'),
                    const SizedBox(height: 20),
                    const Image(
                      image: AssetImage('assets/images/not_found.png'),
                      fit: BoxFit.cover,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, HomeScreen.routeName);
                      },
                      child: const Text('Lets find some lessons!'),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
