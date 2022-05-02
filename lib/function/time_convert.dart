import 'dart:math' show pi, sin, cos;
import 'dart:async' show Future;
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert' show json;

DateTime toSolar(DateTime clock) {
  DateTime jan1 = DateTime(clock.year, 1, 1, 0, 0);

  int N = clock.difference(jan1).inDays + 1;
  double B = 2 * pi * (N - 81) / 364;
  double E = 9.87 * sin(2 * B) - 7.53 * cos(B) - 1.5 * sin(B);

  DateTime solar = clock.add(Duration(minutes: E.round()));
  return solar;
}

Future<Map<String, dynamic>> toLunar(DateTime birthday) async {
  String jsonText = await rootBundle.loadString('lib/json/lunar_calendar.json');
  Map<String, dynamic> lunar = json.decode(jsonText);
  // lunar = whole json data
  // lunar[y2000] = while 2000 yearly data
  // lunar[y2000][1] = first day in 2000

  List<int> list = List<int>.from(lunar['y${birthday.year}'][1]);

  DateTime jan1 = toDateTime(list);

  if (birthday.isBefore(jan1)) {
    list = List<int>.from(lunar['y${birthday.year - 1}'][1]);
    jan1 = toDateTime(list);
  }

  int year = (birthday.isBefore(jan1)) ? birthday.year - 1 : birthday.year;

  bool leap = false;
  int month = 0;
  int day = 0;
  for (int i = 1; i < lunar['y$year'].length; i++) {
    DateTime day1 = toDateTime(List<int>.from(lunar['y$year'][i]));

    if (birthday.isBefore(day1)) {
      break;
    }

    int leapInfo = lunar['y$year'][0][0];
    leap = (i == leapInfo + 1 && leapInfo != 0);

    month += (i == lunar['y$year'][0][0] + 1 && leap) ? 0 : 1;
    day = birthday.difference(day1).inDays + 1;
  }

  int hour = (birthday.hour == 23) ? 1 : (birthday.hour / 2).ceil() + 1;

  return {
    'tianGan': (year % 10 == 3) ? 10 : (year - 1863) % 10,
    'diJhih': (year % 12 == 3) ? 12 : (year - 1863) % 12,
    'leap': leap,
    'month': month,
    'day': day,
    'hour': hour,
  };
}

Future<List<String>> toSexagenaryCycle(DateTime birthday) async {
  List<String> tgList = ['甲', '乙', '丙', '丁', '戊', '己', '庚', '辛', '壬', '癸'];
  List<String> djList = ['子', '丑', '寅', '卯', '辰', '巳', '午', '未', '申', '酉', '戌', '亥'];

  String jsonText = await rootBundle.loadString('lib/json/solar_term.json');
  Map<String, dynamic> cycle = json.decode(jsonText);
  // cycle = whole json data
  // cycle[y2000] = while 2000 yearly data
  // cycle[y2000][0] = first day in 2000

  List<int> list = List<int>.from(cycle['y${birthday.year}'][0]);
  List<String> bazi = [];

  DateTime jan1 = toDateTime(list);

  if (birthday.isBefore(jan1)) {
    list = List<int>.from(cycle['y${birthday.year - 1}'][0]);
    jan1 = toDateTime(list);
  }

  int year = (birthday.isBefore(jan1)) ? birthday.year - 1 : birthday.year;
  bazi.add(tgList[(year - 1864) % 10]);
  bazi.add(djList[(year - 1864) % 12]);

  int month = 0;
  for (int i = 0; i < cycle['y$year'].length; i++) {
    DateTime day1 = toDateTime(List<int>.from(cycle['y$year'][i]));

    if (birthday.isBefore(day1)) {
      break;
    }

    month += 1;
  }
  month = (year - 1898) * 12 + (month - 11);
  bazi.add(tgList[month % 10]);
  bazi.add(djList[month % 12]);

  int day = birthday.difference(DateTime(1899, 12, 22)).inDays;
  bazi.add(tgList[day % 10]);
  bazi.add(djList[day % 12]);

  int hour = birthday.difference(DateTime(1899, 12, 26, 23, 00)).inHours;
  hour = (hour / 2).floor();
  bazi.add(tgList[hour % 10]);
  bazi.add(djList[hour % 12]);

  return bazi;
}

DateTime toDateTime(List<dynamic> ld) {
  List<int> list = List<int>.from(ld);

  if (list.length == 3) {
    return DateTime(list[0], list[1], list[2], 0, 0);
  } else {
    return DateTime(list[0], list[1], list[2], list[3], list[4]);
  }
}

/* ***
ref:
  > equation of time
  https://en.wikipedia.org/wiki/Equation_of_time

  > DateTime add
  https://api.flutter.dev/flutter/dart-core/DateTime/add.html

  > read json from asset
  https://flutter-tutorial.com/flutter-read-local-json-file-from-assets

*** */