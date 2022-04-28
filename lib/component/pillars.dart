import '../function/time_convert.dart' show toSolar, toSexagenaryCycle;

class Bazi {
  static late String name;
  static late bool isBoy;
  static late DateTime clockTime;
  static late DateTime solarTime;
  static late List<String> words;

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

    // Return the fully initialized object
    return bazi;
  }
}
