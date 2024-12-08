import 'package:flutter/material.dart';
import 'package:flutter_application_1/sabitler/video_kismi.dart';
import 'package:flutter_application_1/sayfalar/alt_menuler/meydan_okuma.dart';
import 'package:flutter_application_1/sayfalar/alt_menuler/oneriler.dart';
import 'package:flutter_application_1/sayfalar/alt_menuler/profil.dart';

class AnaSayfasi extends StatefulWidget {
  const AnaSayfasi({super.key});
  @override
  State<AnaSayfasi> createState() => _AnaSayfasiState();
}

class _AnaSayfasiState extends State<AnaSayfasi> {
  int _selectedIndex = 0;
  //antrenman kartları
  final List<Map<String, String>> newWorkouts = [
    {
      'title': 'Kalori Yakma Antrenmanı',
      'description': 'Karın Yakıcı Egzersiz',
      'duration': '11 dakika',
      'level': 'Başlangıç',
      'imageUrl': 'assets/resimler/resim1.jpg', // Arkaplan resmi
      'videoUrl': 'assets/videolar/video1.mp4',
    },
    {
      'title': 'Güç Antrenmanı',
      'description': 'Yüksek Yoğunluklu Kardiyo',
      'duration': '11 dakika',
      'level': 'Başlangıç',
      'imageUrl': 'assets/resimler/resim2.jpg', // Arkaplan resmi
      'videoUrl': 'assets/videolar/video2.mp4',
    },
    {
      'title': 'Hızlı Karın Egzersizi',
      'description': 'Bacak ve Kalça Anrenmanı',
      'duration': '10 dakika',
      'level': 'Orta',
      'imageUrl': 'assets/resimler/resim3.jpg',
      'videoUrl': 'assets/videolar/video3.mp4',
    },
    {
      'title': 'Üst Gövde Egzersizi',
      'description': 'Kol ve Sırt Anrenmanı',
      'duration': '10 dakika',
      'level': 'orta',
      'imageUrl': 'assets/resimler/resim4.jpg',
      'videoUrl': 'assets/videolar/video4.mp4',
    },
  ];

  final List<Widget> _widgetOptions = [
    const AnaSayfasi(),
    const ChallengePage(),
    const OnerilerSayfasi(),
    const ProfilSayfasi(),
  ];
  // Bottom navigation bar itemlerini ayarlamak için method
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

//kartların fonksiyonu
  void _showWorkoutDetails(Map<String, String> workout) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text(workout['title']!),
                subtitle: Text(
                    '${workout['description']!}\nSüre: ${workout['duration']!}\nSeviye: ${workout['level']!}'),
              ),
              ElevatedButton(
                onPressed: () {
                  //Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => VideoPlayerScreen(
                          videoUrl: workout['videoUrl']!,
                          onComplete: () {
                            Navigator.pop(context,
                                true); // Video bitince geri dön ve sonucu gönder
                            _onWorkoutComplete();
                          }),
                    ),
                  );
                },
                child: const Text('Antrenmana Başla'),
              ),
            ],
          );
        });
  }

  int completedCount = 0; // Tamamlanan antrenman sayısı

  void _onWorkoutComplete() {
    setState(() {
      completedCount++; // Antrenman tamamlandığında sayıyı artırıyoruz
    });
    // Video tamamlandığında ChallengePage'e geri dön
    Navigator.pop(context, true); // Sonucu true olarak geri gönderiyoruz
  }

//kartlar için ortak özellik widgeti
  Widget buildWorkoutCard(Map<String, String> workout) {
    return GestureDetector(
      onTap: () => _showWorkoutDetails(workout),
      child: AspectRatio(
        aspectRatio: 16 / 9, // Dinamik genişlik ve yükseklik oranı
        child: Container(
          margin: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            image: DecorationImage(
              image: AssetImage(workout['imageUrl']!),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.4), // Arka planı biraz karartma
                BlendMode.darken,
              ),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  workout['title']!,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  workout['description']!,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
                Text(
                  'Süre: ${workout['duration']!}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

//kartların üstündeki yazılar için widget
  Widget buildWorkoutSection(String title, List<Map<String, String>> workouts) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        Column(
          children:
              workouts.map((workout) => buildWorkoutCard(workout)).toList(),
        ),
      ],
    );
  }

//alt menünün de olduğu ana widget
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Antrenmanlar"),
      ),
      body: _selectedIndex == 0
          ? SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildWorkoutSection('Programlar', newWorkouts),
                ],
              ),
            )
          : _widgetOptions[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.fitness_center),
            label: 'Antrenmanlar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.emoji_events),
            label: 'Meydan Okuma',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.thumb_up),
            label: 'Öneriler',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.purple,
        unselectedItemColor: Colors.purple,
        onTap: _onItemTapped,
      ),
    );
  }
}
