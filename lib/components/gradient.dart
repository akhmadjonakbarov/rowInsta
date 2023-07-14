import 'package:flutter/material.dart';

class CustomGradient extends StatelessWidget {
  const CustomGradient({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 349,
      height: 148,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: const Color.fromRGBO(255, 217, 15, 1),
          width: 2,
        ),
        gradient: const LinearGradient(
          colors: [
            Color.fromRGBO(255, 217, 15, 1),
            Color.fromRGBO(173, 0, 255, 1),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
    );
  }
}
