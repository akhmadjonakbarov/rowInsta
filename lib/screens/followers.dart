import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:easy_upi_payment/easy_upi_payment.dart';
import 'package:logger/logger.dart';

import '../components/layouts/footer.dart';
import 'home.dart';

class AppFollowersScreen extends StatefulWidget {
  const AppFollowersScreen({Key? key}) : super(key: key);

  @override
  FollowersState createState() => FollowersState();
}

class FollowersState extends State<AppFollowersScreen> {
  final Logger logger = Logger();
  String? userName;
  Map<String, dynamic>? usrProfile;
  String? baseUrl;
  List<String>? prices = ['Select Your Plan', '99', '199', '299'];
  String selectedPrice = 'Select Your Plan';

  SharedPreferences? prefs;
  Future? prefsFuture;

  @override
  void initState() {
    super.initState();

    prefsFuture = initializePrefs();
  }

  Future<void> loadDotEnv() async {
    await dotenv.load();
    baseUrl = dotenv.env['API_BASE_URL'];
  }

  Future<void> initializePrefs() async {
    prefs = await SharedPreferences.getInstance();
    String? usrProfileString = prefs!.getString('usrProfile');
    if (usrProfileString != null) {
      usrProfile = jsonDecode(usrProfileString);
    }
    await loadDotEnv();
    await fetchPrice();
  }

  Future<void> fetchPrice() async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Grow Insta"),
          automaticallyImplyLeading: false,
          shape: const ContinuousRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(20.0),
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.notifications),
              onPressed: () {
                // Handle bell icon press
              },
            ),
          ],
        ),
        bottomNavigationBar: const CoustomNavigationBar(isSwitchOn: false),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Followers',
                textScaleFactor: 2,
              ),
              Container(
                padding: const EdgeInsets.only(left: 20, right: 10),
                width: 342,
                height: 107,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: const Color(0xFF9696E8),
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    if (usrProfile != null &&
                        usrProfile!['user'] != null &&
                        usrProfile!['user'].containsKey('profilePic'))
                      ClipRRect(
                        borderRadius: BorderRadius.circular(35),
                        child: Image.network(
                          baseUrl! +
                              usrProfile!['user']['profilePic'].toString(),
                          width: 70,
                          height: 70,
                        ),
                      ),
                    const SizedBox(
                      width: 20,
                    ),
                    Text(
                      usrProfile != null &&
                              usrProfile!['user'] != null &&
                              usrProfile!['user'].containsKey('usrName')
                          ? usrProfile!['user']['usrName'].toString()
                          : 'username',
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AppHomePage()),
                  );
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                      const Color.fromRGBO(119, 119, 255, 1)),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      side: BorderSide.none,
                    ),
                  ),
                  padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                    const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 20.0),
                  ),
                  elevation: MaterialStateProperty.all<double>(10.0),
                  shadowColor: MaterialStateProperty.all<Color>(
                      const Color.fromARGB(158, 119, 119, 255)),
                ),
                child: const Text(
                  'Change Username',
                  style: TextStyle(fontSize: 20.0, color: Colors.white),
                ),
              ),
              /* Price And Plan */
              Container(
                width: 342,
                height: 100,
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: const Color(0xFF9696E8),
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    const Text(
                      'Select Your Plan',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    DropdownButton<String>(
                      value: selectedPrice,
                      items: prices!.map((String itm) {
                        return DropdownMenuItem<String>(
                          value: itm,
                          child: Text(itm),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedPrice = value!;
                        });
                      },
                    )
                  ],
                ),
              ),
              TextButton(
                onPressed: () async {
                  await handlePayment();
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                      const Color.fromRGBO(119, 119, 255, 1)),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      side: BorderSide.none,
                    ),
                  ),
                  padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                    const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 20.0),
                  ),
                  elevation: MaterialStateProperty.all<double>(10.0),
                  shadowColor: MaterialStateProperty.all<Color>(
                      const Color.fromARGB(158, 119, 119, 255)),
                ),
                child: const Text(
                  'Proceed To Pay',
                  style: TextStyle(fontSize: 20.0, color: Colors.white),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ));
  }

  handlePayment() async {
    try {
      final res = await EasyUpiPaymentPlatform.instance.startPayment(
        const EasyUpiPaymentModel(
          payeeVpa: '9696227984@indianbk',
          payeeName: 'shivamdwivevedi',
          amount: 1.0,
          description: 'Tested',
          transactionRefId : 'A1B2C3'
        ),
      );

      logger.w(res);
    } on EasyUpiPaymentException catch (e) {
      logger.w("Error Occured: ${e.message}");
    }

  }
}