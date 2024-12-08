import 'package:flutter/material.dart';
import 'package:flutter_application_1/sabitler/extra.dart';
import 'package:google_fonts/google_fonts.dart';

class Tema{
  inputDec(String hintText , IconData icon){
    return InputDecoration(
      border: InputBorder.none,
      hintText: hintText ,
      hintStyle: GoogleFonts.quicksand(
        color: Renk(metinRenk),
      ),
      prefixIcon: Icon(
        icon,
        color: Renk("5BA7FB"),
      ),
    );
  }

  inputBoxDec(){
    return BoxDecoration(
      color: Renk("333443"),
      borderRadius: BorderRadius.circular(20),
    );
  }
}

