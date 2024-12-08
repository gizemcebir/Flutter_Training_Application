import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/sabitler/extra.dart';
import 'package:flutter_application_1/sabitler/tema.dart';
import 'package:flutter_application_1/sayfalar/anasayfa.dart';
import 'package:flutter_application_1/sayfalar/oturum/uye_ol.dart';
import 'package:flutter_application_1/service/auth.dart';
import 'package:google_fonts/google_fonts.dart';

class GirisSayfasi extends StatefulWidget {
  const GirisSayfasi({super.key});

  @override
  State<GirisSayfasi> createState() => _GirisSayfasiState();
}

class _GirisSayfasiState extends State<GirisSayfasi> {
  final Tema tema = Tema();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String? errorMessage;
  //firebase kullanımı için
  //mount işlemi bir widget'ın hala değişip değişmediğini gösteren bool değerdir.

  Future<void> _signIn() async {
  try {
    await Auth().signIn(
      email: _emailController.text, 
      password: _passwordController.text
    );

    // Async işlemden sonra mounted kontrolü yap
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) =>  const AnaSayfasi()),
      );
    }
  } on FirebaseAuthException catch (e) {
    // Async işlemden sonra mounted kontrolü yap
    if (mounted) {
      setState(() {
        errorMessage = e.message;
      });
    }
  }
}
  // eposta ve giriş ortak tasarım özellikleri için widget oluşturduk.
  Widget _buildInputField({
    required String hintText,
    required IconData icon,
    required TextEditingController controller,
    bool obscureText = false,
    double letterSpacing = 1.0,
  }) {
    return Container(
      decoration: tema.inputBoxDec(),
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        decoration: tema.inputDec(hintText, icon),
        style: GoogleFonts.quicksand(
          color: Renk(metinRenk),
          letterSpacing: letterSpacing,
        ),
      ),
    );
  }
  //eposta için kutu yaptık.
  Widget _buildHeader() {
    return Column(
      children: [
        Container(
          width: 200,
          height: 200,
          margin: const EdgeInsets.only(top: 40),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(200),
            border: Border.all(color: Colors.white.withOpacity(0.5), width: 1),
          ),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(100),
              border: Border.all(color: Renk("202F3A"), width: 10),
            ),
            child: Icon(Icons.login, size: 60, color: Renk("202F3A")),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 30, bottom: 30),
          child: const Text(
            "GİRİŞ YAPIN",
            style: TextStyle(
              color: Colors.white,
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  //giriş yap kutusu için widget oluşturduk.
  Widget _buildSignInButton() {
    return InkWell(
      onTap: _signIn,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 60),
        width: MediaQuery.of(context).size.width,
        height: 50,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
            Renk("4E73DF"),
            Renk("224ABE"),
          ]),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Text(
            "GİRİŞ YAP",
            style: GoogleFonts.quicksand(
              color: Colors.white,
              fontSize: 20,
            ),
          ),
        ),
      ),
    );
  }

  //üye ol sayfasına yönlendiren yazı için widget oluşturduk.
  Widget _buildSignUpPrompt() {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Hesabın yok mu?",
            style: GoogleFonts.quicksand(
              color: Renk(metinRenk),
              fontSize: 16,
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SignupPage()),
              );
            },
            child: Text(
              "Üye Ol",
              style: GoogleFonts.quicksand(
                color: Renk("4E73DF"),
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(color: Renk(arkaRenk)),
          child: SingleChildScrollView(
            child: Column(
              children: [
                _buildHeader(),
                _buildInputField(
                  hintText: "E-posta adresinizi girin.",
                  icon: Icons.people_alt_outlined,
                  controller: _emailController,
                ),
                _buildInputField(
                  hintText: "Şifrenizi girin.",
                  icon: Icons.vpn_key_outlined,
                  controller: _passwordController,
                  obscureText: true,
                  letterSpacing: 5,
                ),
                _buildSignInButton(),
                _buildSignUpPrompt(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

