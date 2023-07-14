import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:logger/logger.dart';

class SwitchWidget extends StatefulWidget {
  final String widgetName;
  final Future<void> Function(String?) fetchData;

  const SwitchWidget(
      {Key? key, required this.widgetName, required this.fetchData})
      : super(key: key);

  @override
  ProfileState createState() => ProfileState();
}

class ProfileState extends State<SwitchWidget> {
  Map<String, dynamic>? usrProfile;
  final Logger logger = Logger();
  String? userProfileJson;
  String? baseUrl;

  // Function To Update

  @override
  void initState() {
    super.initState();
    initializeUserProfile();
  }

  @override
  void didUpdateWidget(covariant SwitchWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.widgetName != oldWidget.widgetName) {
      initializeUserProfile();
    }
  }

  Future<void> initializeUserProfile() async {
    await dotenv.load();
    baseUrl = dotenv.env['API_BASE_URL'];
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userProfileJson = prefs.getString('usrProfile');

    if (userProfileJson != null) {
      setState(() {
        usrProfile = Map<String, dynamic>.from(jsonDecode(userProfileJson!));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    switch (widget.widgetName) {
      case 'profile':
        {
          return Container(
            width: 339,
            height: 138,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
            ),
            child: Column(children: [
              Row(children: [
                Text(
                  usrProfile != null &&
                          usrProfile!['user'] != null &&
                          usrProfile!['user'].containsKey('usrName')
                      ? usrProfile!['user']['usrName'].toString()
                      : 'username',
                  textScaleFactor: 2,
                ),
                const Spacer(),
                GestureDetector(
                    onTap: () async {
                      widget.fetchData('put').then((_) {
                        // Handle the result of fetchData here, if needed.
                        // You can use setState() here to update the state if necessary.
                      });
                    },
                    child: Image.asset('lib/assets/vector/refreshCirlce.png'))
              ]),
              const SizedBox(height: 10),
              Row(
                children: [
                  if (usrProfile != null &&
                      usrProfile!['user'] != null &&
                      usrProfile!['user'].containsKey('profilePic'))
                    ClipRRect(
                      borderRadius: BorderRadius.circular(35),
                      child: Image.network(
                        baseUrl! + usrProfile!['user']['profilePic'].toString(),
                        width: 70,
                        height: 70,
                      ),
                    ),
                  const Spacer(),
                  Column(children: [
                    Text(
                      usrProfile != null &&
                              usrProfile!['user'] != null &&
                              usrProfile!['user'].containsKey('post')
                          ? usrProfile!['user']['post'].toString()
                          : '0',
                    ),
                    const Text('Post'),
                  ]),
                  const Spacer(),
                  Column(
                    children: [
                      Text(
                        usrProfile != null &&
                                usrProfile!['user'] != null &&
                                usrProfile!['user'].containsKey('follower')
                            ? usrProfile!['user']['follower'].toString()
                            : '0',
                      ),
                      const Text('Follower')
                    ],
                  ),
                  const Spacer(),
                  Column(
                    children: [
                      Text(
                        usrProfile != null &&
                                usrProfile!['user'] != null &&
                                usrProfile!['user'].containsKey('following')
                            ? usrProfile!['user']['following'].toString()
                            : '0',
                      ),
                      const Text('Following')
                    ],
                  )
                ],
              )
            ]),
          );
        }
      case 'username':
        {
          return Container(
            width: 339,
            height: 138,
            padding: const EdgeInsets.only(left: 10, right: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Enter Username'),
                const SizedBox(height: 10),

                /* Input User Name */
                TextField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'User Name',
                    filled: true,
                    fillColor: Color.fromRGBO(236, 236, 253, 1),
                  ),
                  onChanged: (value) async {
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    prefs.setString('userName', value);
                  },
                ),
              ],
            ),
          );
        }
      default:
        {
          return const Text('home');
        }
    }
  }
}
