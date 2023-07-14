import 'package:flutter/material.dart';

class HomeGridExpand extends StatelessWidget {
  const HomeGridExpand({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        width: double.infinity,
        // height: 361,
        padding: const EdgeInsets.all(0),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(19),
            topRight: Radius.circular(19),
          ),
          gradient: LinearGradient(
            colors: [
              Color.fromRGBO(119, 119, 255, 1),
              Color.fromRGBO(155, 155, 255, 1),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: [0.0, 1.0],
            transform: GradientRotation(225 * 3.1415927 / 180),
          ),
        ),
        child: Wrap(
          spacing: 40,
          runSpacing: 40,
          children: [
            buildButton(context, 'lib/assets/vector/Follower.png', 'Followers'),
            buildButton(context, 'lib/assets/vector/Likes.png', 'Likes'),
            buildButton(context, 'lib/assets/vector/Views.png', 'Views'),
            buildButton(context, 'lib/assets/vector/Comments.png', 'Comments'),
          ],
        ),
      ),
    );
  }

  Widget buildButton(BuildContext context, String icon, String label) {
    return FractionallySizedBox(
      widthFactor: 0.4, // Modify this value to fit your needs
      child: GestureDetector(
        onTap: () {
          navigateToRoute(context, label);
        },
        child: Container(
          width: 70,
          height: 70,
          margin: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
            boxShadow: const [
              BoxShadow(
                color: Color.fromRGBO(11, 11, 22, 0.38),
                blurRadius: 52,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                icon,
                width: 40,
                height: 40,
              ),
              const SizedBox(height: 8),
              Text(label),
            ],
          ),
        ),
      ),
    );
  }

  void navigateToRoute(BuildContext context, String label) {
    String routeName;
    switch (label) {
      case 'Followers':
        routeName = '/Followers';
        break;
      case 'Likes':
        routeName = '/Likes';
        break;
      case 'Views':
        routeName = '/Views';
        break;
      case 'Comments':
        routeName = '/Comments';
        break;
      default:
        routeName = '/';
        break;
    }
    Navigator.pushNamed(context, routeName);
  }
}
