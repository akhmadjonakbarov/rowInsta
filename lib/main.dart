import 'package:flutter/material.dart';

import 'package:flutter/services.dart';


import './screens/splash.dart';
import './screens/home.dart';
import './screens/download.dart';
import './screens/followers.dart';
import './screens/comments.dart';
import './screens/views.dart';
import './screens/likes.dart';


void main() {
   debugPrint = (String? message, {int? wrapWidth}) {};
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [
    SystemUiOverlay.bottom, //This line is used for showing the bottom bar
  ]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const customColor = MaterialColor(0xFF7777FF, <int, Color>{
      50: Color(0xFFE8E8FF),
      100: Color(0xFFC1C1FF),
      200: Color(0xFF9A9AFF),
      300: Color(0xFF7373FF),
      400: Color(0xFF4D4DFF),
      500: Color(0xFF2626FF),
      600: Color(0xFF1F1FFF),
      700: Color(0xFF1919FF),
      800: Color(0xFF1212FF),
      900: Color(0xFF0B0BFF),
    });

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Grow Insta',
      theme: ThemeData(
        primarySwatch: customColor,
      ),
      initialRoute: '/splash',
      routes: {
        '/': (context) => const AppHomePage(),
        '/splash': (context) => const AppSplashScreen(),
        '/download': (context) => const AppDownloadScreen(),
        '/Followers': (context) => const AppFollowersScreen(),
        '/Likes': (context) => const AppLikesScreen(),
        '/Views': (context) => const AppViewsScreen(),
        '/Comments': (context) => const AppCommentsScreen(),
      },
    );
  }
}
