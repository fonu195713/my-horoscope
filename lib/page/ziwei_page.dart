import 'package:flutter/material.dart';
import '../function/to_string.dart';
import '../function/time_convert.dart';

class ZiweiPage extends StatefulWidget {
  final Map<String, dynamic> info;
  const ZiweiPage({Key? key, required this.info}) : super(key: key);

  @override
  State<ZiweiPage> createState() => _ZiweiPageState();
}

class _ZiweiPageState extends State<ZiweiPage> {
  late DateTime clockTime;
  late DateTime solarTime;

  @override
  void initState() {
    super.initState();
    clockTime = widget.info['birthday'];
    solarTime = toSolar(clockTime);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: toLunar(solarTime),
      builder: (context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return Container();

          default:
            if (snapshot.hasData) {
              return Center(child: Text(lunarToString(snapshot.data!)));
            }

            return Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Icon(Icons.error_outline, color: Colors.red, size: 60),
                Padding(padding: const EdgeInsets.only(top: 16), child: Text('Error: ${snapshot.error}')),
              ],
            ));
        }
      },
    );
  }
}

/* ***
ref:
  > FutureBuilder
  https://stackoverflow.com/questions/51983011/when-should-i-use-a-futurebuilder

*** */