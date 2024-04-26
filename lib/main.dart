import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screen/screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const Screen(),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch().copyWith(
          background: Colors.black,
        ),
        textTheme: GoogleFonts.nunitoTextTheme(
          Theme.of(context).textTheme,
        ).merge(GoogleFonts.outfitTextTheme(
          Theme.of(context).textTheme,
        )),
      ),
    );
  }
}






