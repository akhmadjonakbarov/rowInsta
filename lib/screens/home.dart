import '../components/home_grid_expand.dart';
import '../components/layouts/footer.dart';
import '../components/profile.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:logger/logger.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppHomePage extends StatefulWidget {
  const AppHomePage({Key? key}) : super(key: key);

  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<AppHomePage> {
  String switchWidgetName = 'profile';
  final Logger logger = Logger();
  bool fetchingData = false;

  SharedPreferences? prefs;

  Map<String, dynamic>? usrProfile;

  // DONE : Code To Fetch And Store Data From API
  Future<void> fetchAndStoreData(String? method) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    http.Response? response;

    logger.i('Method Called');

    setState(() {
      fetchingData = true;
    });

    await dotenv.load();
    var baseUrl = dotenv.env['API_BASE_URL'];

    String? username = prefs.getString('userName');

    String apiUrl = '$baseUrl/api/v1/profile/$username';
    logger.i(apiUrl);

    if (method == 'post') {
      response = await http.post(Uri.parse(apiUrl));
    } else if (method == 'put') {
      response = await http.put(Uri.parse(apiUrl));
    } else {
      response = await http.get(Uri.parse(apiUrl));
    }

    if (response.statusCode == 200) {
      // Request successful, handle the response data
      // final responseData = jsonDecode(response.body);

      await prefs.remove('usrProfile');
      await prefs.setString('usrProfile', response.body);
    } else {
      // Request failed, handle the error
      logger.w('Request failed with status: ${response.statusCode}');
    }

    setState(() {
      fetchingData = false;
    });
  }

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [
      SystemUiOverlay.bottom,
    ]);

    fetchAndStoreData('put');
    initializePrefs();
  }

  Future<void> initializePrefs() async {
    prefs = await SharedPreferences.getInstance();
    String? usrProfileString = prefs!.getString('usrProfile');
    if (usrProfileString != null) {
      usrProfile = jsonDecode(usrProfileString);
    }
  }

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
            onPressed: () async {},
          ),
        ],
      ),
      bottomNavigationBar: const CoustomNavigationBar(isSwitchOn: true),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 40),
          Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
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
                ),
                fetchingData
                    ? Container(
                        width: 339,
                        height: 138,
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                        ),
                        child: const Center(
                          child: SizedBox(
                              width: 40,
                              height: 40,
                              child: CircularProgressIndicator()),
                        ),
                      )
                    : SwitchWidget(
                        widgetName: switchWidgetName,
                        fetchData: fetchAndStoreData),
              ],
            ),
          ),
          const SizedBox(height: 40),
          !fetchingData
              ? TextButton(
                  onPressed: () async {
                    if (switchWidgetName == 'username') {
                      await fetchAndStoreData('post');
                    }
                    setState(() {
                      switchWidgetName = (switchWidgetName == 'profile')
                          ? 'username'
                          : 'profile';
                    });
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
                  child: Text(
                    (switchWidgetName == "profile")
                        ? "Change Username"
                        : "Verify Profile",
                    style: const TextStyle(fontSize: 20.0, color: Colors.white),
                  ),
                )
              : const SizedBox(height: 40),
          const SizedBox(height: 40),
          const HomeGridExpand(),
        ],
      ),
    );
  }
}
