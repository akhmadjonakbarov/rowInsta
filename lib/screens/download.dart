import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../components/layouts/footer.dart';

class AppDownloadScreen extends StatefulWidget {
  const AppDownloadScreen({Key? key}) : super(key: key);

  @override
  DownloadState createState() => DownloadState();
}

class DownloadState extends State<AppDownloadScreen> {
  String? videoLink;
  String? baseUrl;
  final Logger logger = Logger();
  String? downloadData;
  VideoPlayerController? _videoPlayerController;
  late ChewieController chewieController;

  Future<void> _initializeVideoPlayer() async {
    await _videoPlayerController!.initialize();
    setState(() {});
  }

  Future<void> postVideo(String videoLink) async {
    await dotenv.load();
    baseUrl = dotenv.env['API_BASE_URL'];

    final requestBody = jsonEncode({
      'url': videoLink,
    });

    // Send the POST request to the server
    final response = await http.post(
      Uri.parse('$baseUrl/api/v1/download'),
      headers: {'Content-Type': 'application/json'},
      body: requestBody,
    );

    // Check if the request was successful (HTTP 200-299 status code)
    if (response.statusCode >= 200 && response.statusCode < 300) {
      // Parse the response JSON
      final responseData = jsonDecode(response.body);
      final downloadLink = responseData['downloadLink'];
      logger.i(downloadLink);

      // Return the download link
      downloadData = downloadLink;

      if (downloadData != null) {
        _videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(
            'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4'));
        await _videoPlayerController!.initialize();
        setState(() {});
      }
    } else {
      // Request failed, throw an exception or return an error message
      logger.e('Failed to post video: $response');
    }
  }

  Future<void> downloadVideo(String downloadUrl) async {
   
  }

/*   @override
  void dispose() {
    _videoPlayerController?.dispose();
    super.dispose();
  } */

  @override
  void initState() {
    super.initState();
    if (downloadData != null) {
      _videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(
          'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4'));
      _initializeVideoPlayer();
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
            const SizedBox(height: 10),
            const Text("DOWNLOADER"),
            Container(
              width: 323,
              height: 120,
              padding: const EdgeInsets.only(
                left: 10,
                right: 10,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: const Color(0xFF9696E8),
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Paste Post Link",
                      style: TextStyle(
                          // Add your desired text style here
                          ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Input Field",
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      onChanged: (value) async {
                        setState(() {
                          videoLink = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
            TextButton(
              onPressed: () async {
                await postVideo(videoLink!);
              },
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all<Color>(const Color(0xFF7777FF)),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
              ),
              child: const Text(
                'Verify',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ),
            downloadVideoWidget(),
          ],
        ),
      ),
    );
  }

  // Downlaod Video Widget
  Widget downloadVideoWidget() {
    logger.w(downloadData);
    if (downloadData == null) {
      return const Text("");
    } else if (_videoPlayerController != null &&
        _videoPlayerController!.value.isInitialized) {
      return Column(
        children: [
          AspectRatio(
            aspectRatio: _videoPlayerController!.value.aspectRatio,
            child: VideoPlayer(_videoPlayerController!),
          ),
          const SizedBox(height: 10),
          TextButton(
            onPressed: () async {
              // Download Video From Network
              FileDownloader.downloadFile( url: downloadData!,
              onProgress: (fileName, progress) {
                  logger.w('FILE fileName HAS PROGRESS $progress');
              },
              onDownloadCompleted: (String path) {
                logger.w('FILE DOWNLOADED TO PATH: $path');
              },
              onDownloadError: (String error) {
                logger.d('DOWNLOAD ERROR: $error');
              });
            
              
            },
            style: ButtonStyle(
              backgroundColor:
                  MaterialStateProperty.all<Color>(const Color(0xFF7777FF)),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
            ),
            child: const Text(
              'Download',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ),
          const SizedBox(height: 10),
        ],
      );
    } else {
      // return const CircularProgressIndicator();
      return const Text("Loading...");
    }
  }
}
