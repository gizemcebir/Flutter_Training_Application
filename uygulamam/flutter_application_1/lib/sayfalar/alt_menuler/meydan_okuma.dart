import 'package:flutter/material.dart';
import 'package:flutter_application_1/sayfalar/anasayfa.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChallengePage extends StatefulWidget {
  const ChallengePage({super.key});

  @override
  ChallengePageState createState() => ChallengePageState();
}

class ChallengePageState extends State<ChallengePage> {
  int completedWorkouts = 0;
  bool isLoading = true; // SharedPreferences yüklenirken gösterilecek

  @override
  void initState() {
    super.initState();
    _loadCompletedWorkouts(); // SharedPreferences'tan verileri yükle
  }

  // Tamamlanan antrenmanları SharedPreferences'tan yükle
  Future<void> _loadCompletedWorkouts() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      setState(() {
        completedWorkouts = prefs.getInt('completedWorkouts') ?? 0;
        isLoading = false; // Veriler yüklendi
      });
    } catch (e) {
      // Hata durumunda işlemi yakala ve kullanıcıya bildir
      print("SharedPreferences yüklenirken hata oluştu: $e");
      setState(() {
        isLoading = false; // Hata olsa bile yükleme tamamlandı
      });
    }
  }

  // Tamamlanan antrenmanları SharedPreferences'a kaydet
  Future<void> _saveCompletedWorkouts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('completedWorkouts', completedWorkouts);
  }

  // Yuvarlakları oluşturma widgetı
  Widget buildCircles() {
    List<Widget> circles = [];
    for (int i = 1; i <= 30; i++) {
      circles.add(
        Container(
          margin: const EdgeInsets.fromLTRB(10, 5, 5, 5),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: i <= completedWorkouts ? Colors.green : Colors.white, // Tamamlandıysa yeşil
            border: Border.all(color: Colors.black),
          ),
          width: 50,
          height: 50,
          child: Center(
            child: Text(
              '$i',
              style: TextStyle(
                color: i <= completedWorkouts ? Colors.white : Colors.black,
                fontSize: 16,
              ),
            ),
          ),
        ),
      );
    }
    return Wrap(
      alignment: WrapAlignment.center,
      children: circles,
    );
  }

  // Meydan okumaya başla butonuna tıklanınca yapılacak işlem
  void startChallenge() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AnaSayfasi(), // Antrenmanlar sayfasına yönlendir
      ),
    );

    if (result == true) {
      // Eğer antrenman tamamlandıysa yuvarlak rengini değiştir
      setState(() {
        completedWorkouts++;
      });
      _saveCompletedWorkouts(); // Güncellenen antrenman sayısını kaydet
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meydan Okuma'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator()) // Yükleniyor göstergesi
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Meydan Okuma',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                buildCircles(), // Yuvarlakları göster
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: completedWorkouts > 0 ? Colors.green : null, // Butonu sabit yeşil yapma durumu
                  ),
                  onPressed: startChallenge, // Meydan Okumaya Başla butonuna tıklanınca
                  child: const Text('Meydan Okumaya Başla'),
                ),
              ],
            ),
    );
  }
}

