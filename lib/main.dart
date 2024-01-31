import 'package:Sharey/screens/init_screen.dart';
import 'package:Sharey/screens/splash/splash_screen.dart';

import 'package:flutter/material.dart';

import 'routes.dart';
import 'theme.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';

import 'providers/auth_user_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    /// Providers are above [MyApp] instead of inside it, so that tests
    /// can use [MyApp] while mocking the providers
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthUserProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  // Check if user is logged in
  final _auth = FirebaseAuth.instance;
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sharey',
      theme: AppTheme.lightTheme(context),
      initialRoute: _auth.currentUser != null
          ? InitScreen.routeName
          : SplashScreen.routeName,
      routes: routes,
    );
  }
}
