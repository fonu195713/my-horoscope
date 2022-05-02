import '../function/time_convert.dart' show toSolar, toSexagenaryCycle;
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert' show json;
import '../function/time_convert.dart' show toDateTime;

class Bazi {
  static late String name;
  static late bool isBoy;
  static late DateTime clockTime;
  static late DateTime solarTime;
  static late List<String> words;
  static late String mainWord;
  static late Map<String, String> tenLords;
  static late DateTime luckStart;

  // Private constructor
  Bazi._create(Map<String, dynamic> info) {
    // Do most of your initialization here, that's what a constructor is for
    name = info['name'];
    isBoy = info['isBoy'];
    clockTime = info['birthday'];
    solarTime = toSolar(clockTime);
  }

  // Public factory
  static Future<Bazi> create(Map<String, dynamic> info) async {
    // Call the private constructor
    Bazi bazi = Bazi._create(info);

    // Do initialization that requires async
    words = await toSexagenaryCycle(solarTime);
    mainWord = words[4];

    _setTenLords();
    await _countLuckStart();

    // Return the fully initialized object
    return bazi;
  }

  static void _setTenLords() {
    List<Map<String, String>> lordsTable = [
      {'甲': '比肩', '乙': '劫財', '丙': '食神', '丁': '傷官', '戊': '偏財', '己': '正財', '庚': '七殺', '辛': '正官', '壬': '偏印', '癸': '正印'},
      {'甲': '劫財', '乙': '比肩', '丙': '傷官', '丁': '食神', '戊': '正財', '己': '偏財', '庚': '正官', '辛': '七殺', '壬': '正印', '癸': '偏印'},
      {'甲': '偏印', '乙': '正印', '丙': '比肩', '丁': '劫財', '戊': '食神', '己': '傷官', '庚': '偏財', '辛': '正財', '壬': '七殺', '癸': '正官'},
      {'甲': '正印', '乙': '偏印', '丙': '劫財', '丁': '比肩', '戊': '傷官', '己': '食神', '庚': '正財', '辛': '偏財', '壬': '正官', '癸': '七殺'},
      {'甲': '七殺', '乙': '正官', '丙': '偏印', '丁': '正印', '戊': '比肩', '己': '劫財', '庚': '食神', '辛': '傷官', '壬': '偏財', '癸': '正財'},
      {'甲': '正官', '乙': '七殺', '丙': '正印', '丁': '偏印', '戊': '劫財', '己': '比肩', '庚': '傷官', '辛': '食神', '壬': '正財', '癸': '偏財'},
      {'甲': '比肩', '乙': '劫財', '丙': '七殺', '丁': '正官', '戊': '偏印', '己': '正印', '庚': '比肩', '辛': '劫財', '壬': '食神', '癸': '傷官'},
      {'甲': '劫財', '乙': '比肩', '丙': '正官', '丁': '七殺', '戊': '正印', '己': '偏印', '庚': '劫財', '辛': '比肩', '壬': '傷官', '癸': '食神'},
      {'甲': '食神', '乙': '傷官', '丙': '偏財', '丁': '正財', '戊': '七殺', '己': '正官', '庚': '偏印', '辛': '正印', '壬': '比肩', '癸': '劫財'},
      {'甲': '傷官', '乙': '食神', '丙': '正財', '丁': '偏財', '戊': '正官', '己': '七殺', '庚': '正印', '辛': '偏印', '壬': '劫財', '癸': '比肩'},
    ];

    tenLords = lordsTable[['甲', '乙', '丙', '丁', '戊', '己', '庚', '辛', '壬', '癸'].indexOf(mainWord)];
  }

  static Future<void> _countLuckStart() async {
    String jsonText = await rootBundle.loadString('lib/json/solar_term.json');
    Map<String, dynamic> cycle = json.decode(jsonText);

    List<dynamic> solarTermsData = [];
    solarTermsData = List.from(solarTermsData)..addAll(cycle['y${solarTime.year - 1}']);
    solarTermsData = List.from(solarTermsData)..addAll(cycle['y${solarTime.year + 0}']);
    solarTermsData = List.from(solarTermsData)..addAll(cycle['y${solarTime.year + 1}']);

    DateTime lastSolarTerm = DateTime.now();
    DateTime nextSolarTerm = DateTime.now();

    for (int i = 0; i < solarTermsData.length; i++) {
      if (!toDateTime(solarTermsData[i]).isAfter(solarTime) && toDateTime(solarTermsData[i + 1]).isAfter(solarTime)) {
        lastSolarTerm = toDateTime(solarTermsData[i + 0]);
        nextSolarTerm = toDateTime(solarTermsData[i + 1]);
        break;
      }
    }
    print(lastSolarTerm);
    print(nextSolarTerm);

    List<String> tianGan = ['甲', '乙', '丙', '丁', '戊', '己', '庚', '辛', '壬', '癸'];
    bool clockwise = false;
    clockwise = (tianGan.indexOf(words[0]) % 2 == 0) && isBoy;
    clockwise = clockwise || ((tianGan.indexOf(words[0]) % 2 == 1) && !isBoy);
    print(clockwise);

    if (clockwise) {
      int h = nextSolarTerm.difference(solarTime).inMinutes * 2;
      luckStart = solarTime.add(Duration(hours: h));
    } else {
      int h = solarTime.difference(lastSolarTerm).inMinutes * 2;
      luckStart = solarTime.add(Duration(hours: h));
    }

    print(luckStart);
  }
}
