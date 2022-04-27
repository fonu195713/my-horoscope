import 'dart:math' show pi, sin, cos;
import 'dart:async' show Future;
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';

DateTime toSolar(DateTime clock) {
  DateTime jan1 = DateTime(clock.year, 1, 1, 0, 0);

  int N = clock.difference(jan1).inDays + 1;
  double B = 2 * pi * (N - 81) / 364;
  double E = 9.87 * sin(2 * B) - 7.53 * cos(B) - 1.5 * sin(B);

  DateTime solar = clock.add(Duration(minutes: E.round()));
  return solar;
}

Future<Map<String, dynamic>> toLunar(DateTime solar) async {
  String jsonText = await rootBundle.loadString('lib/json/lunar_calendar.json');
  Map<String, dynamic> lunar = json.decode(jsonText);
  // lunar = whole json data
  // lunar[y2000] = while 2000 yearly data
  // lunar[y2000][1] = first day in 2000

  List<int> list = List<int>.from(lunar['y${solar.year}'][1]);

  DateTime jan1 = toDateTime(list);

  if (solar.isBefore(jan1)) {
    list = List<int>.from(lunar['y${solar.year - 1}'][1]);
    jan1 = toDateTime(list);
  }

  int year = (solar.isBefore(jan1)) ? solar.year - 1 : solar.year;

  bool leap = false;
  int month = 0;
  int day = 0;
  for (int i = 1; i < lunar['y$year'].length; i++) {
    DateTime day1 = toDateTime(List<int>.from(lunar['y$year'][i]));

    if (solar.isBefore(day1)) {
      break;
    }

    int leapInfo = lunar['y$year'][0][0];
    leap = (i == leapInfo + 1 && leapInfo != 0);

    month += (i == lunar['y$year'][0][0] + 1 && leap) ? 0 : 1;
    day = solar.difference(day1).inDays + 1;
  }

  int hour = (solar.hour == 23) ? 1 : (solar.hour / 2).ceil() + 1;

  return {
    'tianGan': (year % 10 == 3) ? 10 : (year - 1863) % 10,
    'diJhih': (year % 12 == 3) ? 12 : (year - 1863) % 12,
    'leap': leap,
    'month': month,
    'day': day,
    'hour': hour,
  };
}

DateTime toDateTime(List<int> list) {
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