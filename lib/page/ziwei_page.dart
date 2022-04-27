import 'package:flutter/material.dart';
import '../component/ming_pan.dart';
// import 'package:spannable_grid/spannable_grid.dart';

class ZiweiPage extends StatelessWidget {
  final Map<String, dynamic> info;
  const ZiweiPage({Key? key, required this.info}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Mingpan>(
        future: Mingpan.create(info),
        builder: (context, AsyncSnapshot<Mingpan> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Container();

            default:
              if (snapshot.hasError) {
                return SnapshotHasError(text: 'Error: ${snapshot.error}');
              }

              Mingpan mingpan = snapshot.data!;
              mingpan.showAll();
              return Container();
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
  > FutureBuilder
  https://stackoverflow.com/questions/51983011/when-should-i-use-a-futurebuilder

  > spannable grid
  https://pub.dev/packages/spannable_grid

*** */