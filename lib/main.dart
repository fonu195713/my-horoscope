import 'package:flutter/material.dart';
import 'page/birthday_input_page.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(body: MyHomePage()),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ElevatedButton(
          child: const Text('Register'),
          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const BirthdayInputPage())),
        ),
      ],
    ));
  }
}

/* ***
ref:
  > RaisedButton
  https://stackoverflow.com/questions/53531830/the-methods-raisedbutton-isnt-defined
  
  > column height
  https://stackoverflow.com/questions/41845693/how-can-i-tightly-wrap-a-column-of-widgets-inside-a-card

  > Navigation & Routing
  https://ithelp.ithome.com.tw/articles/10215918
  https://stackoverflow.com/questions/49672706/flutter-navigation-pop-to-index-1
  https://docs.flutter.dev/cookbook/animation/page-route-animation

*** */