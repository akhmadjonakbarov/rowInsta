import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../screens/download.dart';
import '../../screens/home.dart';

class CoustomNavigationBar extends StatelessWidget {
  final bool isSwitchOn;

  const CoustomNavigationBar({Key? key, required this.isSwitchOn})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color backgroundColor =
        isSwitchOn ? Colors.white : const Color.fromARGB(255, 119, 119, 255);
    final Color textColor =
        isSwitchOn ? const Color.fromARGB(255, 119, 119, 255) : Colors.white;

    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 15.0),
        child: Row(
          children: [
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AppHomePage()),
                );
              },
              child: InkWell(
                child: Image.asset(
                  'lib/assets/vector/home.png',
                  width: 31,
                  height: 31,
                  color: textColor, // Set the desired color for the image
                ),
              ),
            ),
            const Spacer(),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AppDownloadScreen(),
                  ),
                );
              },
              child: InkWell(
                child: Image.asset(
                  'lib/assets/vector/download.png',
                  width: 31,
                  height: 31,
                  color: textColor, // Set the desired color for the image
                ),
              ),
            ),
            const Spacer(),
            InkWell(
              onTap: _openWhatsAppChat,
              child: Image.asset(
                'lib/assets/vector/whatsapp.png',
                width: 31,
                height: 31,
                color: textColor, // Set the desired color for the image
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openWhatsAppChat() async {
    var contact = "+919696227984";
    var whatsappUrl =
        "whatsapp://send?phone=$contact&text=Hi, I need some help";

    try {
      await launchUrl(Uri.parse(whatsappUrl));
    } catch (e) {
      //To handle error and display error message
      throw "Unable to open WhatsApp";
    }
  }
}
