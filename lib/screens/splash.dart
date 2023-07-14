import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:ota_update/ota_update.dart';

import 'dart:async';

class AppSplashScreen extends StatefulWidget {
  const AppSplashScreen({Key? key}) : super(key: key);

  @override
  State<AppSplashScreen> createState() => _AppSplashScreenState();
}

class _AppSplashScreenState extends State<AppSplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  // late OtaEvent currentEvent;

  Logger logger = Logger();

  @override
  void initState() {
    super.initState();
    // tryOtaUpdate();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );

    _animation = Tween<double>(begin: 1.0, end: 2.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 1.0, curve: Curves.easeInOut),
      ),
    );

    _animationController.forward();

    Future.delayed(const Duration(seconds: 5), () {
      Navigator.pushReplacementNamed(context, '/');
    });
  }
/* 
  Future<void> tryOtaUpdate() async {
    try {
      logger.d('ABI Platform: ${await OtaUpdate().getAbi()}');
      //LINK CONTAINS APK OF FLUTTER HELLO WORLD FROM FLUTTER SDK EXAMPLES
      OtaUpdate()
          .execute(
        'https://growinsta.in/growInsta.apk',
        destinationFilename: 'growInsta.apk',
        //FOR NOW ANDROID ONLY - ABILITY TO VALIDATE CHECKSUM OF FILE:
        sha256checksum:
            'd6da28451a1e15cf7a75f2c3f151befad3b80ad0bb232ab15c20897e54f21478',
      )
          .listen(
        (OtaEvent event) {
          setState(() => currentEvent = event);
        },
      );
      // ignore: avoid_catches_without_on_clauses
    } catch (e) {
      logger.d('Failed to make OTA update. Details: $e');
    }
  }
 */
  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: _animation.value,
          alignment: Alignment.center,
          child: Image.asset(
            'lib/assets/splash.png',
            fit: BoxFit.cover,
            height: MediaQuery.of(context).size.height,
          ),
        );
      },
    );
  }
}
