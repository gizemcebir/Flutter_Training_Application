import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';

class ProfilSayfasi extends StatefulWidget {
  const ProfilSayfasi({super.key});

  @override
  _ProfilSayfasiState createState() => _ProfilSayfasiState();
}

class _ProfilSayfasiState extends State<ProfilSayfasi> {
  TextEditingController adController = TextEditingController();
  TextEditingController soyadController = TextEditingController();
  TextEditingController dogumTarihiController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController sifreController =
      TextEditingController(text: '*******');
  bool isEditing = false;
  bool motivasyonMesajlariAl = false;

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<String> motivasyonMesajlari = [];

  Future<void> fetchUserInfo() async {
    User? user = _firebaseAuth.currentUser;

    if (user != null) {
      try {
        DocumentSnapshot userDoc =
            await _firestore.collection('users').doc(user.uid).get();

        if (userDoc.exists) {
          final data = userDoc.data() as Map<String, dynamic>?;

          if (data != null) {
            setState(() {
              adController.text = data['ad'] ?? '';
              soyadController.text = data['soyad'] ?? '';
              dogumTarihiController.text = data['dogumTarihi'] ?? '';
              emailController.text = data['email'] ?? '';
              motivasyonMesajlariAl = data.containsKey('motivasyonMesajlariAl')
                  ? data['motivasyonMesajlariAl']
                  : false;

              // Motivasyon mesajlarını al
              fetchMotivasyonMesajlari();
            });
          } else {
            print('Kullanıcı verisi boş.');
          }
        } else {
          print('Kullanıcı verisi Firestore\'da bulunamadı.');
        }
      } catch (e) {
        print('Kullanıcı bilgileri alınırken hata oluştu: $e');
      }
    }
  }

  @override
  void initState() {
    super.initState();
    fetchUserInfo();
  }

  Future<void> fetchMotivasyonMesajlari() async {
    User? user = _firebaseAuth.currentUser;

    if (user != null && motivasyonMesajlariAl) {
      try {
        QuerySnapshot mesajlar =
            await _firestore.collection('motivasyonMesajlari').get();

        if (mesajlar.docs.isNotEmpty) {
          motivasyonMesajlari.clear(); // Önceki mesajları temizle
          for (var doc in mesajlar.docs) {
            motivasyonMesajlari.add(doc['mesaj']); // Mesajları listeye ekle
          }
          print('Motivasyon mesajları alındı: $motivasyonMesajlari');

          // Sadece bir tane motivasyon mesajı göster
          showMotivasyonMesajDialog();
        } else {
          print('Motivasyon mesajı bulunamadı.');
        }
      } catch (e) {
        print('Motivasyon mesajları alınırken hata oluştu: $e');
      }
    }
  }

  Future<void> showMotivasyonMesajDialog() async {
    // Rastgele bir motivasyon mesajı seç
    String mesaj = motivasyonMesajlari.isNotEmpty
        ? motivasyonMesajlari[Random().nextInt(motivasyonMesajlari.length)]
        : "Motivasyon mesajı bulunamadı.";

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Motivasyon Mesajı"),
          content: Text(mesaj),
          actions: <Widget>[
            TextButton(
              child: const Text("Tamam"),
              onPressed: () {
                Navigator.of(context).pop(); // Diyalog kapat
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> updateUserInfo() async {
    User? user = _firebaseAuth.currentUser;

    if (user != null) {
      await _firestore.collection('users').doc(user.uid).update({
        'ad': adController.text,
        'soyad': soyadController.text,
        'dogumTarihi': dogumTarihiController.text,
        'email': emailController.text,
        'motivasyonMesajlariAl':
            motivasyonMesajlariAl, // Motivasyon mesajları durumu kaydediliyor
      });
    }
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
    Navigator.of(context).pushReplacementNamed('/giris_sayfasi');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profil Sayfası"),
      ),
      body: SingleChildScrollView(
        // Kaydırılabilir bir alan oluştur
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Ad",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            TextField(
              controller: adController,
              enabled: isEditing,
            ),
            const SizedBox(height: 8.0),
            const Text(
              "Soyad",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            TextField(
              controller: soyadController,
              enabled: isEditing,
            ),
            const SizedBox(height: 8.0),
            const Text(
              "Doğum Tarihi",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            TextField(
              controller: dogumTarihiController,
              enabled: isEditing,
            ),
            const SizedBox(height: 8.0),
            const Text(
              "E-posta",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            TextField(
              controller: emailController,
              enabled: isEditing,
            ),
            const SizedBox(height: 8.0),
            const Text(
              "Şifre",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            TextField(
              controller: sifreController,
              enabled: isEditing,
              obscureText: true,
            ),
            const SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Motivasyon mesajları al"),
                Switch(
                  value: motivasyonMesajlariAl,
                  onChanged: (bool value) {
                    setState(() {
                      motivasyonMesajlariAl = value;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  if (isEditing) {
                    await updateUserInfo();
                  }
                  setState(() {
                    isEditing = !isEditing;
                  });
                },
                child: Text(isEditing ? "Kaydet" : "Düzenle"),
              ),
            ),
            const SizedBox(height: 16.0),
            Center(
              child: ElevatedButton(
                onPressed: signOut,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
                child: const Text("Çıkış Yap"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
