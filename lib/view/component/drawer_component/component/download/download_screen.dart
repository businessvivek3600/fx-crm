import 'package:flutter/material.dart';
import 'package:fx_crm/controller/app_controller.dart';
import 'package:fx_crm/widgets/bg_container.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';

class DownloadScreen extends StatefulWidget {
  const DownloadScreen({super.key});

  @override
  State<DownloadScreen> createState() => _DownloadScreenState();
}

class _DownloadScreenState extends State<DownloadScreen> {
  final AppController controller = Get.find<AppController>();

  @override
  void initState() {
    super.initState();
    controller.fetchDownloadData(); // 🔁 Fetch downloads when screen opens
  }

  @override
  Widget build(BuildContext context) {
    return BackgroundContainer(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          title: const Text(
            'Download',
            style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.2),
          ),
        ),
        body: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          final download = controller.downloadDataModel.value?.data;

          if (download == null) {
            return const Center(
              child: Text(
                "No downloads available",
                style: TextStyle(color: Colors.white),
              ),
            );
          }

          // Create dynamic list of available download items
          List<Map<String, String>> downloadItems = [];

          if (download.mt5Mac != null) {
            downloadItems.add({
              "title": "MetaTrader 5 for Mac",
              "url": download.mt5Mac!,
            });
          }
          if (download.mt5Android != null) {
            downloadItems.add({
              "title": "MetaTrader 5 for Android",
              "url": download.mt5Android!,
            });
          }
          if (download.mt5Ios != null) {
            downloadItems.add({
              "title": "MetaTrader 5 for iOS",
              "url": download.mt5Ios!,
            });
          }
          if (download.pdf != null) {
            downloadItems.add({"title": "PDF Guide", "url": download.pdf!});
          }

          // Optionally include Windows if it's not null
          if (download.mt5Window != null) {
            downloadItems.insert(0, {
              "title": "MetaTrader 5 for Windows",
              "url": download.mt5Window!,
            });
          }

          if (downloadItems.isEmpty) {
            return const Center(
              child: Text(
                "No downloads available",
                style: TextStyle(color: Colors.white),
              ),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Download Link For Meta Trader 5",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),

                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: downloadItems.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 1.2,
                  ),
                  itemBuilder: (context, index) {
                    final item = downloadItems[index];
                    return DownloadCard(
                      title: item["title"] ?? '',
                      subtitle: '', // Optional subtitle
                      url: item["url"] ?? '',
                    );
                  },
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}

class DownloadCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String url;

  const DownloadCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.url,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () async {
          final uri = Uri.tryParse(url);
          if (uri != null) {
            // Check if it's a downloadable file or a URL to open
            if (url.contains("http") && !url.contains("pdf")) {
              await downloadFile(url);
            } else {
              if (await canLaunchUrl(uri)) {
                await launchUrl(uri, mode: LaunchMode.externalApplication);
              } else {
                Get.snackbar("Error", "Could not open download link");
              }
            }
          } else {
            Get.snackbar("Error", "Invalid URL");
          }
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min, // 👈 Prevents overflow
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.download_rounded,
                  size: 28,
                  color: Colors.white,
                ),
                const SizedBox(height: 8),
                Flexible(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                ),
                if (subtitle.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(fontSize: 11, color: Colors.white70),
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> downloadFile(String url) async {
    // Request storage permission (Android)
    if (await Permission.storage.request().isGranted) {
      try {
        // Get the directory to save file
        final dir = await getExternalStorageDirectory();
        final fileName = url.split('/').last;
        final savePath = "${dir!.path}/$fileName";

        // Create Dio instance
        Dio dio = Dio();

        // Start download
        await dio.download(
          url,
          savePath,
          onReceiveProgress: (received, total) {
            if (total != -1) {
              print(
                "Downloading: ${(received / total * 100).toStringAsFixed(0)}%",
              );
            }
          },
        );

        // Notify user of successful download
        Get.snackbar("Download Completed", "File saved to $savePath");
      } catch (e) {
        Get.snackbar("Download Failed", "Error: $e");
      }
    } else {
      Get.snackbar(
        "Permission Denied",
        "Please grant storage permission to download.",
      );
    }
  }
}
