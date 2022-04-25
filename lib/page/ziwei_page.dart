import 'package:flutter/material.dart';

class ZiweiPage extends StatelessWidget {
  final String info;
  const ZiweiPage({Key? key, required this.info}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(child: Text(info));
  }
}

/* ***
ref:
  
*** */