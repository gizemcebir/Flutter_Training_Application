import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class OnerilerSayfasi extends StatelessWidget {
  const OnerilerSayfasi({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('metinlerr').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text('Bir hata oluştu'));
          }
          if (snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('Hiç veri yok'));
          }

          return ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              const SectionTitle(title: "Sizin İçin Öneriler"),
              const SizedBox(height: 16),
              Column(
                children: snapshot.data!.docs.map((doc) {  
                          String altBaslik = doc['altBaslik'] ?? 'Alt Başlık Yok';
                          String baslik = doc['baslik'] ?? 'Başlık Yok';
                          String metin = doc['metin'] ?? 'Metin Yok';
                          String resimYolu = getImagePath(doc.id); // Belge ID'sine göre resim yolu al

                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DetaySayfasi(
                                    title: baslik,
                                    content: metin,
                                  ),
                                ),
                              );
                            },
                            child: buildCard(altBaslik, baslik, resimYolu),
                          );
                       }).toList(),
            ),
          ],
        );
      },
    ),
  );
}

// Resim yolunu belge ID'sine göre döndür
  String getImagePath(String docId) {
    switch (docId) {
      case 'Wu9kj6mV81H1X9NYFDFY':
        return 'assets/resimler/oneriresim1.jpg';
      case 'eBlfat3ahyfufCsa9tLJ':
        return 'assets/resimler/oneriresim2.jpg';
      case 'gjPSUqYDb2Fi2C6TcirW':
        return 'assets/resimler/oneriresim3.png';
      case 'hTDvCeZo8Lpocu0V73Fb':
        return 'assets/resimler/oneriresim4.jpg';
      default:
        return 'assets/resimler/oneriresim3.png'; // Varsayılan resim
    }
  }

  // Kart yapısı
  Widget buildCard(String title, String subtitle, String imageUrl) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        alignment: Alignment.topRight,
        children: [
          Image.asset(
            imageUrl,
            height: 150,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          Positioned(
            bottom: 16,
            left: 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// SectionTitle widget'ı
class SectionTitle extends StatelessWidget {
  final String title;

  const SectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    );
  }
}

// DetaySayfasi widget'ı
class DetaySayfasi extends StatelessWidget {
  final String title;
  final String content;

  const DetaySayfasi({super.key, required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Text(
            content,
            style: const TextStyle(fontSize: 16),
          ),
        ),
      ),
    );
  }
}

