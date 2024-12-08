import 'package:flutter/material.dart';

const String arkaRenk ="3E495B";
const String metinRenk = "7F8C99";

// Hex renk kodunu Color sınıfına dönüştüren fonksiyon
class Renk extends Color {

  static int _donustur(String hexColor){
    hexColor = hexColor.toUpperCase().replaceAll("#","");
    if(hexColor.length == 6){
      hexColor = "FF$hexColor";
    }
    return int.parse(hexColor , radix: 16 );
  }

 // Renk sınıfının yapıcı fonksiyonu
  Renk(final String renkKodu) : super(_donustur(renkKodu));
}