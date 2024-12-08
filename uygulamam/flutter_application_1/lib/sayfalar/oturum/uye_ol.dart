//import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/service/auth.dart';
import 'package:google_fonts/google_fonts.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();

  String? errorMessage;

  // TextEditingController'lar
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();

  Future<void> createUser() async {
  try {
    await Auth().createUser(
      email: _emailController.text,
      password: _passwordController.text,
      ad: _firstNameController.text,      // Adı
      soyad: _lastNameController.text,    // Soyadı
      dogumTarihi: _dobController.text,   // Doğum tarihi
    );

    // Kayıt başarılı olursa
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Kayıt başarılı!')),
    );
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Hata: $e')),
    );
  }
}

  // Şifre görünürlüğünü yönetmek için
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Üye Ol", style: GoogleFonts.quicksand()),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child:
                Column(mainAxisAlignment: MainAxisAlignment.start, children: [
              Text(
                "ÜYE OLUN",
                style: GoogleFonts.quicksand(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                //adı
                controller: _firstNameController,
                decoration: const InputDecoration(labelText: "Adı"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Lütfen adınızı giriniz';
                  }
                  return null;
                },
              ),
              TextFormField(
                //soyadı
                controller: _lastNameController,
                decoration: const InputDecoration(labelText: "Soyadı"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Lütfen soyadınızı giriniz';
                  }
                  return null;
                },
              ),
              TextFormField(
                //e posta
                controller: _emailController,
                decoration: const InputDecoration(labelText: "E-posta"),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Lütfen e-posta adresinizi giriniz';
                  } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    return 'Geçerli bir e-posta adresi giriniz';
                  }
                  return null;
                },
              ),
              TextFormField(
                //şifre
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: "Şifre",
                  suffixIcon: IconButton(
                    icon: Icon(_obscurePassword
                        ? Icons.visibility
                        : Icons.visibility_off),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                ),
                obscureText: _obscurePassword,
                validator: (value) {
                  //şifre düzenleme kısmı
                  if (value == null || value.isEmpty) {
                    return 'Lütfen şifrenizi giriniz';
                  } else if (value.length < 8) {
                    return 'Şifre en az 8 karakter olmalıdır';
                  }
                  return null;
                },
              ),
              TextFormField(
                //doğum tarihi ayarlama
                controller: _dobController,
                decoration: const InputDecoration(
                  labelText: "Doğum Tarihi",
                  hintText: "Gün/Ay/Yıl",
                ),
                onTap: () async {
                  FocusScope.of(context).requestFocus(FocusNode());
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now(),
                  );
                  if (pickedDate != null) {
                    setState(() {
                      _dobController.text =
                          "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
                    });
                  }
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Lütfen doğum tarihinizi giriniz';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Formu doğruladıktan sonra yapılacak işlemler burada
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content:
                              Text('Kayıt Başarılı! Giriş Yapabilirsiniz. ')),
                    );
                  }
                  createUser();
                },
                child: Text("Hesap Oluştur", style: GoogleFonts.quicksand()),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
