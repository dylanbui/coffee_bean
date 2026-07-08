import 'package:flutter/material.dart';
import 'package:app_video_player/app_video_player.dart';

class AppVideoPlayerTest extends StatelessWidget {
  const AppVideoPlayerTest({super.key});

  @override
  Widget build(BuildContext context) {
    // Link MP4 mẫu để demo
    const String demoMp4Url = "https://test-videos.co.uk/vids/bigbuckbunny/mp4/h264/1080/Big_Buck_Bunny_1080_10s_30MB.mp4";
    // Future YouTube Support: const String youtubeUrl = "https://www.youtube.com/watch?v=aqz-KE-bpKQ";

    return Scaffold(
      appBar: AppBar(
        title: const Text("Coffee Bean Video Player Test"),
        backgroundColor: Colors.brown,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text("1. Server Video (MP4) - Không autoplay, hiện Thumbnail", 
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ),
            // Video từ Server - Bọc AspectRatio để giữ size cố định khi loading
            const AspectRatio(
              aspectRatio: 16 / 9,
              child: AppVideoPlayer(
                url: demoMp4Url,
                enableSeekOverlay: true,
              ),
            ),

            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text("Mô phỏng nội dung Course Detail:", style: TextStyle(color: Colors.grey)),
            ),
            Container(
              padding: const EdgeInsets.all(16.0),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Hướng dẫn pha Espresso chuẩn", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  Text("Trong bài học này, chúng ta sẽ tìm hiểu về nhiệt độ nước và áp suất máy pha..."),
                  Divider(height: 32),
                  Text("Comments (12)", style: TextStyle(fontWeight: FontWeight.bold)),
                  ListTile(
                    leading: CircleAvatar(child: Text("U1")),
                    title: Text("Bài học rất bổ ích!"),
                    subtitle: Text("2 giờ trước"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
