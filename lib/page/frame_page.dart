import 'package:flutter/material.dart';
import 'ziwei_page.dart';
import 'bazi_page.dart';
import 'horoscope_page.dart';

class FramePage extends StatefulWidget {
  final Map<String, dynamic> info;
  const FramePage({Key? key, required this.info}) : super(key: key);

  @override
  State<FramePage> createState() => _FramePageState();
}

class _FramePageState extends State<FramePage> {
  late int _selectedIndex;
  late List<Widget> pageList;

  @override
  void initState() {
    super.initState();
    _selectedIndex = 0;
    pageList = [
      ZiweiPage(info: widget.info),
      BaziPage(info: widget.info),
      HoroscopePage(info: widget.info.toString()),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: pageList.elementAt(_selectedIndex)),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniStartFloat,
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.arrow_back),
        onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.apps), label: 'Zi wei'),
          BottomNavigationBarItem(icon: Icon(Icons.crop_square_sharp), label: 'Ba zi'),
          BottomNavigationBarItem(icon: Icon(Icons.circle_outlined), label: 'Horoscope'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: (int index) => setState(() => _selectedIndex = index),
      ),
    );
  }
}

/* ***
ref:
  > flutter Icons list
  https://api.flutter.dev/flutter/material/Icons-class.html

  > bottom navigation bar
  https://api.flutter.dev/flutter/material/BottomNavigationBar-class.html

*** */
