import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
class AppTextStyle{
  static TextStyle headerTextStyle (BuildContext context){
    return GoogleFonts.rubik(fontSize: 15,
    fontWeight: FontWeight.bold,
    color:  Colors.black 
     );
  
  }
  
  static TextStyle aboutMeTextstyle (BuildContext context){
    return GoogleFonts.rubik(fontSize: 15,
    fontWeight: FontWeight.w500,
    color: Theme.of(context).brightness == Brightness.light ? Colors.black : Colors.white,
     );
  
  }
}