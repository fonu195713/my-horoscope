import 'package:flutter/material.dart';
import '../component/ming_pan.dart';
import 'package:spannable_grid/spannable_grid.dart';
import '../function/to_string.dart' show lunarToString;

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

              return SpannableGrid(
                columns: 4,
                rows: 4,
                cells: generateWholeCells(),
              );
          }
        });
  }

  List<SpannableGridCellData> generateWholeCells() {
    Map<String, int> row = {'子': 4, '丑': 4, '寅': 4, '卯': 3, '辰': 2, '巳': 1, '午': 1, '未': 1, '申': 1, '酉': 2, '戌': 3, '亥': 4};
    Map<String, int> col = {'子': 3, '丑': 2, '寅': 1, '卯': 1, '辰': 1, '巳': 1, '午': 2, '未': 3, '申': 4, '酉': 4, '戌': 4, '亥': 4};
    List<SpannableGridCellData> cells = [];
    cells.add(generateMiddleInfo());
    for (House house in Mingpan.houseList) {
      cells.add(SpannableGridCellData(
        column: col[house.diJhih]!,
        row: row[house.diJhih]!,
        id: house.diJhih,
        child: genetateCell(house),
      ));
    }
    return cells;
  }

  SpannableGridCellData generateMiddleInfo() {
    return SpannableGridCellData(
        id: Mingpan.name,
        column: 2,
        row: 2,
        columnSpan: 2,
        rowSpan: 2,
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${Mingpan.name},   五行局:${Mingpan.wuXingJu}'),
            Text('鐘錶時間: ${Mingpan.clockTime}'),
            Text('太陽時間: ${Mingpan.solarTime}'),
            Text('農曆生日: ${lunarToString(Mingpan.lunarTime)}'),
          ],
        )));
  }

  Widget genetateCell(House house) {
    List<TextStyle> starColor = const [
      TextStyle(color: Color.fromRGBO(205, 60, 60, 1)),
      TextStyle(color: Color.fromRGBO(150, 50, 150, 1)),
      TextStyle(color: Color.fromRGBO(0, 0, 0, 1)),
    ];

    List<Color> transColor = const [
      Color.fromRGBO(255, 255, 255, 1),
      Color.fromRGBO(55, 145, 55, 1),
      Color.fromRGBO(145, 40, 145, 1),
      Color.fromRGBO(50, 140, 250, 1),
      Color.fromRGBO(195, 35, 30, 1),
    ];

    List<Widget> starList = [];
    for (Star star in house.starList) {
      String trans = '';
      trans = (star.trans['lu']!) ? '祿' : trans;
      trans = (star.trans['ch']!) ? '權' : trans;
      trans = (star.trans['ke']!) ? '科' : trans;
      trans = (star.trans['ji']!) ? '忌' : trans;
      int transColorIndex = 0;
      transColorIndex = (star.trans['lu']!) ? 1 : transColorIndex;
      transColorIndex = (star.trans['ch']!) ? 2 : transColorIndex;
      transColorIndex = (star.trans['ke']!) ? 3 : transColorIndex;
      transColorIndex = (star.trans['ji']!) ? 4 : transColorIndex;

      starList.add(Padding(
          padding: const EdgeInsets.only(right: 3),
          child: Column(children: [
            Text('${star.name[0]}\n${star.name[1]}', style: starColor[star.level - 1]),
            Container(
              padding: const EdgeInsets.all(1.0),
              child: Text(trans,
                  style: TextStyle(
                    color: transColor[transColorIndex],
                    fontWeight: FontWeight.w500,
                  )),
            ),
          ])));
    }

    return Container(
      margin: const EdgeInsets.all(2.0),
      padding: const EdgeInsets.all(5.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[500]!),
        borderRadius: BorderRadius.circular(3.0),
      ),
      child: Column(children: [
        Expanded(
            child: Container(
          alignment: Alignment.topLeft,
          child: Row(children: starList),
        )),
        Expanded(
            child: Row(children: [
          Expanded(child: Container()),
          Expanded(child: Container()),
          Expanded(
              child: Container(
            alignment: Alignment.bottomCenter,
            child: Text(
              house.name,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Color.fromRGBO(230, 30, 30, 1),
              ),
            ),
          )),
          Expanded(
              child: Container(
            alignment: Alignment.bottomLeft,
            child: Text(
              ((house.isShen) ? '[身]' : ''),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 9,
                color: Color.fromRGBO(230, 30, 30, 1),
              ),
            ),
          )),
          Expanded(
            child: Container(
              alignment: Alignment.bottomRight,
              child: Text('${house.tianGan}\n${house.diJhih}'),
            ),
          ),
        ])),
      ]),
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
  > FutureBuilder
  https://stackoverflow.com/questions/51983011/when-should-i-use-a-futurebuilder

  > spannable grid
  https://pub.dev/packages/spannable_grid

  > decorate widget
  https://api.flutter.dev/flutter/painting/TextStyle-class.html
  https://www.fluttercampus.com/guide/144/how-to-add-padding-margin-on-text-widget-in-flutter/
  https://stackoverflow.com/questions/47423297/how-can-i-add-a-border-to-a-widget-in-flutter
  https://stackoverflow.com/questions/58350235/add-border-to-a-container-with-borderradius-in-flutter
  https://www.codegrepper.com/code-examples/whatever/flutter+center+text+in+container

*** */
