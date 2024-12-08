import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerScreen extends StatefulWidget {
  final String videoUrl;
  final Function onComplete;

  const VideoPlayerScreen({super.key, required this.videoUrl, required this.onComplete});

  @override
  VideoPlayerScreenState createState() => VideoPlayerScreenState();
}

class VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _controller;
  bool _isPlaying = true;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset(widget.videoUrl)
      ..initialize().then((_) {
        setState(() {
          _isPlaying = true; // Video başladığında oynatılıyor
        });
        _controller.play();
      });

     _controller.addListener(() {
  if ( 
      _controller.value.position >= _controller.value.duration) {
    widget.onComplete(); // Video tamamlandığında tamamlanma fonksiyonunu çağır
    Navigator.pop(context, true); // Sonucu true olarak geri gönder ve sayfaya geri dön
  }
});
}

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  // Oynatma/Durdurma
  void _playPause() {
    setState(() {
      if (_controller.value.isPlaying) {
        _controller.pause();
        _isPlaying = false;
      } else {
        _controller.play();
        _isPlaying = true;
      }
    });
  }

  // 10 saniye ileri sarma
  void fastForward() {
  if (_controller.value.isInitialized) {  // Kontrolcünün başlatıldığından emin olun
    final currentPosition = _controller.value.position;
    final maxPosition = _controller.value.duration;
    final newPosition = currentPosition + const Duration(seconds: 10);

    // Yeni pozisyon max süreden büyük olmasın
    if (newPosition < maxPosition) {
      _controller.seekTo(newPosition);
    } else {
      _controller.seekTo(maxPosition); // Eğer süreyi geçerse videonun sonuna git
    }

    setState(() {
    // Eğer yeni pozisyon maksimum süreden küçükse ileri sar, aksi halde son pozisyona git
    _controller.seekTo(newPosition < maxPosition ? newPosition : maxPosition);
  });
  }
}

  // 10 saniye geri sarma
  void rewind() {
  if (_controller.value.isInitialized) {  // Kontrolcünün başlatıldığından emin olun
    final currentPosition = _controller.value.position;
    final newPosition = currentPosition - const Duration(seconds: 10);

    // Yeni pozisyon 0'dan küçük olmasın
    if (newPosition > Duration.zero) {
      _controller.seekTo(newPosition);
    } else {
      _controller.seekTo(Duration.zero); // Eğer negatif bir pozisyon olursa videonun başına git
    }
     setState(() {
    // Eğer yeni pozisyon sıfırdan büyükse geri sar, aksi halde başa dön
    _controller.seekTo(newPosition > Duration.zero ? newPosition : Duration.zero);
  });
  }
}


  // Video ilerleme çubuğu
  Widget _buildVideoProgressIndicator() {
    return VideoProgressIndicator(
      _controller,
      allowScrubbing: true, // Kullanıcıya sürükleyerek ilerletme olanağı
      colors: const VideoProgressColors(
        playedColor: Colors.blue, // Oynatılan kısmın rengi
        backgroundColor: Colors.grey, // Oynatılmamış kısmın rengi
      ),
    );
  }

  @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: const Text('Antrenman Videosu'),
    ),
    body: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Video ekranı
        if (_controller.value.isInitialized)
          AspectRatio(
            aspectRatio: _controller.value.aspectRatio,
            child: VideoPlayer(_controller),
          )
        else
          const CircularProgressIndicator(), // Video yüklenirken gösterilen yükleme çubuğu

        // Video ilerleme çubuğu
        _buildVideoProgressIndicator(),

        // Kontrol butonları
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              onPressed: rewind, // 10 saniye geri sarma
              icon: const Icon(Icons.replay_10),
            ),
            IconButton(
              onPressed: _playPause, // Oynatma/Durdurma
              icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
            ),
            IconButton(
              onPressed: fastForward, // 10 saniye ileri sarma
              icon: const Icon(Icons.forward_10),
            ),
          ],
        ),
      ],
    ),
  );
}
}
