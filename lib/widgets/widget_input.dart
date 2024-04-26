import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InputWidget extends StatelessWidget {
  final String city;
  final ValueChanged<String> onChanged;
  final Color backgroundColor;
  final Color textColor;
  final double borderRadius;

  const InputWidget({
    super.key,
    required this.city,
    required this.onChanged,
    this.backgroundColor = const Color(0xFF30343B),
    this.textColor = Colors.white,
    this.borderRadius = 15.0,
  });

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final double width = screenSize.width * 0.95;
    final double height = screenSize.width * 0.15;

    return SizedBox(
      width: width,
      height: height,
      child: TextField(
        decoration: InputDecoration(
          labelText: 'Введите город',
          filled: true,
          fillColor: backgroundColor,
          labelStyle: TextStyle(color: textColor, fontFamily: 'Nunito', fontSize: 15),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          floatingLabelBehavior: FloatingLabelBehavior.never,
        ),
        style: TextStyle(color: textColor, fontFamily: 'Nunito', fontSize: 15),
        onChanged: onChanged,
        inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Zа-яА-Я\s-]+'))],
      ),
    );
  }
}

