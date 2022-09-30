import 'package:flutter/material.dart';
import '../component/pillars.dart';
import 'package:spannable_grid/spannable_grid.dart';

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

              return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(children: [
                      Expanded(
                          child: Container(
                              alignment: Alignment.bottomCenter,
                              child: const Text('時柱'))),
                      Expanded(
                          child: Container(
                              alignment: Alignment.bottomCenter,
                              child: const Text('日柱'))),
                      Expanded(
                          child: Container(
                              alignment: Alignment.bottomCenter,
                              child: const Text('月柱'))),
                      Expanded(
                          child: Container(
                              alignment: Alignment.bottomCenter,
                              child: const Text('年柱'))),
                    ]),
                    SpannableGrid(
                      columns: 4,
                      rows: 2,
                      cells: _generateWholeCells(),
                    )
                  ]);
          }
        });
  }

  List<SpannableGridCellData> _generateWholeCells() {
    List<SpannableGridCellData> cells = [];
    for (int i = 0; i < 8; i++) {
      bool main = (i == 4);
      cells.add(SpannableGridCellData(
        column: 4 - (i / 2).floor(),
        row: (i % 2 == 0) ? 1 : 2,
        id: i,
        child: _genetateCellInfo(Bazi.words[i], main),
      ));
    }

    return cells;
  }

  Widget _genetateCellInfo(String word, bool main) {
    List<Color> wordColor = const [
      Color.fromRGBO(25, 131, 25, 1),
      Color.fromRGBO(245, 10, 15, 1),
      Color.fromRGBO(155, 125, 90, 1),
      Color.fromRGBO(245, 135, 35, 1),
      Color.fromRGBO(20, 20, 230, 1),
    ];

    int wordIndexInTianGan = -1;
    if (word == '甲' || word == '乙' || word == '寅' || word == '卯') {
      wordIndexInTianGan = 0;
    } else if (word == '丙' || word == '丁' || word == '巳' || word == '午') {
      wordIndexInTianGan = 1;
    } else if (word == '戊' ||
        word == '己' ||
        word == '辰' ||
        word == '戌' ||
        word == '丑' ||
        word == '未') {
      wordIndexInTianGan = 2;
    } else if (word == '庚' || word == '辛' || word == '申' || word == '酉') {
      wordIndexInTianGan = 3;
    } else if (word == '壬' || word == '癸' || word == '亥' || word == '子') {
      wordIndexInTianGan = 4;
    }

    return Container(
      margin: const EdgeInsets.all(2.0),
      padding: const EdgeInsets.all(5.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[500]!),
        borderRadius: BorderRadius.circular((main) ? 999 : 10),
      ),
      child: Center(
          child: Text(
        word,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 40,
          color: wordColor[wordIndexInTianGan],
        ),
      )),
    );
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