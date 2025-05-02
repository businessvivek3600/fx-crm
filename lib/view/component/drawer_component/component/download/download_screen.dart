import 'package:flutter/material.dart';

class DownloadScreen extends StatefulWidget {
  const DownloadScreen({super.key});

  @override
  State<DownloadScreen> createState() => _DownloadScreenState();
}

class _DownloadScreenState extends State<DownloadScreen> {
  final List<Map<String, String>> downloads = [
    {"title": "MT5 for PC", "subtitle": "Download Desktop Window Terminal"},
    {"title": "MT5 for PC", "subtitle": "Download Desktop Mac Terminal"},
    {
      "title": "MT5 for Android",
      "subtitle": "Download Android Mobile Terminal",
    },
    {"title": "MT5 for IOS", "subtitle": "Download iOS Mobile Terminal"},
    {"title": "Business Plan", "subtitle": "Download Plan"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F1C2E), // Dark background gradient look
      appBar: AppBar(
        title: const Text(
          "Downloads",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.white,
      ),
      body: Padding(
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
            Expanded(
              child: GridView.builder(
                itemCount: downloads.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 1.2,
                ),
                itemBuilder: (context, index) {
                  final item = downloads[index];
                  return DownloadCard(
                    title: item['title']!,
                    subtitle: item['subtitle']!,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DownloadCard extends StatelessWidget {
  final String title;
  final String subtitle;

  const DownloadCard({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          // Handle download logic here
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.download_rounded, size: 30, color: Colors.white),
              const SizedBox(height: 10),
              Text(
                title,
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 5),
              Text(
                subtitle,
                style: TextStyle(fontSize: 12, color: Colors.white70),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
