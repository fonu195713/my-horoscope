import 'package:flutter/material.dart';

class BaziPage extends StatelessWidget {
  final String info;
  const BaziPage({Key? key, required this.info}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(child: Text(info));
  }
}

/* ***
ref:
  
*** */