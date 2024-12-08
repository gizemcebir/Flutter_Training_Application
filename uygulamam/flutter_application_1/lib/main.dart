import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_application_1/sayfalar/alt_menuler/profil.dart';
import 'package:flutter_application_1/sayfalar/oturum/giris.dart';
import 'firebase_options.dart';

//flutterın bağlama ve çalıştığında firebase e girme işlemi
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.blue,
      ),
      //ThemeData
      initialRoute: '/giris_sayfasi', // Başlangıç rotası
      routes: {
        '/giris_sayfasi': (context) => const GirisSayfasi(), // Giriş sayfası
        '/profil_sayfasi': (context) => const ProfilSayfasi(), // Profil sayfası
      },
    );//MaterialApp
  }
}

