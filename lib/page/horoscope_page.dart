import 'package:flutter/material.dart';

class HoroscopePage extends StatelessWidget {
  final String info;
  const HoroscopePage({Key? key, required this.info}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(child: Text(info));
  }
}

/* ***
ref:
  
*** */