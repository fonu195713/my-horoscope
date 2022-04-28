import 'package:flutter/material.dart';
import '../component/pillars.dart';
import 'package:spannable_grid/spannable_grid.dart';
import '../function/to_string.dart' show sexagenaryCycleToString;

class BaziPage extends StatelessWidget {
  final Map<String, dynamic> info;
  const BaziPage({Key? key, required this.info}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Bazi>(
        future: Bazi.create(info),
        builder: (context, AsyncSnapshot<Bazi> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Container();

            default:
              if (snapshot.hasError) {
                return SnapshotHasError(text: 'Error: ${snapshot.error}');
              }

              return Center(child: Text(sexagenaryCycleToString(Bazi.words)));
            // return SpannableGrid(
            //   columns: 4,
            //   rows: 4,
            //   cells: const[],
            // );
          }
        });
  }
}

class SnapshotHasError extends StatelessWidget {
  final String text;
  const SnapshotHasError({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const Icon(Icons.error_outline, color: Colors.red, size: 60),
        Padding(padding: const EdgeInsets.only(top: 16), child: Text(text)),
      ],
    ));
  }
}

/* ***
ref:
  
*** */