import '../function/time_convert.dart' show toSolar, toLunar;

class Star {
  late String name;
  late int level;

  Star(this.name, this.level);
}

class House {
  late String name;
  late List<Star> starList;
  late String tianGan, diJhih;
  late bool isShen;

  House(this.diJhih, this.name);
}

class Mingpan {
  static late String name;
  static late bool isBoy;
  static late String wuXingJu;
  static late DateTime clockTime;
  static late DateTime solarTime;
  static late Map<String, dynamic> lunarTime;
  static late List<House> houseList;

  // Private constructor
  Mingpan._create(Map<String, dynamic> info) {
    // Do most of your initialization here, that's what a constructor is for
    name = info['name'];
    isBoy = info['isBoy'];
    clockTime = info['birthday'];
    solarTime = toSolar(clockTime);
  }

  // Public factory
  static Future<Mingpan> create(Map<String, dynamic> info) async {
    // Call the private constructor
    Mingpan mingPan = Mingpan._create(info);

    // Do initialization that requires async
    lunarTime = await toLunar(solarTime);

    // create houseList, houseList[0] = 'zi'
    _setHousesName();
    print('ok 1');
    // set Shen Gong location
    _setShenGong();
    print('ok 2');
    // set 'tian gan'
    _setTianGan();
    print('ok 3');
    // set 'wu xing ju'
    _setWuXingJu();
    print('ok 4');
    // set 14 major stars
    _setMainStars();
    print('ok 5');

    // Return the fully initialized object
    return mingPan;
  }

  static void _setHousesName() {
    List<String> diJhih = ['子', '丑', '寅', '卯', '辰', '巳', '午', '未', '申', '酉', '戌', '亥'];
    List<String> name = ['命', '兄', '夫', '子', '財', '疾', '遷', '奴', '官', '田', '福', '父'];

    List<List<String>> ziName = [
      ['夫', '兄', '命', '父', '福', '田', '官', '奴', '遷', '疾', '財', '子'],
      ['子', '夫', '兄', '命', '父', '福', '田', '官', '奴', '遷', '疾', '財'],
      ['財', '子', '夫', '兄', '命', '父', '福', '田', '官', '奴', '遷', '疾'],
      ['疾', '財', '子', '夫', '兄', '命', '父', '福', '田', '官', '奴', '遷'],
      ['遷', '疾', '財', '子', '夫', '兄', '命', '父', '福', '田', '官', '奴'],
      ['奴', '遷', '疾', '財', '子', '夫', '兄', '命', '父', '福', '田', '官'],
      ['官', '奴', '遷', '疾', '財', '子', '夫', '兄', '命', '父', '福', '田'],
      ['田', '官', '奴', '遷', '疾', '財', '子', '夫', '兄', '命', '父', '福'],
      ['福', '田', '官', '奴', '遷', '疾', '財', '子', '夫', '兄', '命', '父'],
      ['父', '福', '田', '官', '奴', '遷', '疾', '財', '子', '夫', '兄', '命'],
      ['命', '父', '福', '田', '官', '奴', '遷', '疾', '財', '子', '夫', '兄'],
      ['兄', '命', '父', '福', '田', '官', '奴', '遷', '疾', '財', '子', '夫'],
    ];

    int index = name.indexOf(ziName[lunarTime['month'] - 1][lunarTime['hour'] - 1]);

    houseList = [];
    for (int i = 0; i < 12; i++) {
      houseList.add(House(diJhih[i], name[index]));
      index = (index == 0) ? 11 : index - 1;
    }
  }

  static void _setShenGong() {
    List<List<String>> shenLocation = [
      ['寅', '卯', '辰', '巳', '午', '未', '申', '酉', '戌', '亥', '子', '丑'],
      ['卯', '辰', '巳', '午', '未', '申', '酉', '戌', '亥', '子', '丑', '寅'],
      ['辰', '巳', '午', '未', '申', '酉', '戌', '亥', '子', '丑', '寅', '卯'],
      ['巳', '午', '未', '申', '酉', '戌', '亥', '子', '丑', '寅', '卯', '辰'],
      ['午', '未', '申', '酉', '戌', '亥', '子', '丑', '寅', '卯', '辰', '巳'],
      ['未', '申', '酉', '戌', '亥', '子', '丑', '寅', '卯', '辰', '巳', '午'],
      ['申', '酉', '戌', '亥', '子', '丑', '寅', '卯', '辰', '巳', '午', '未'],
      ['酉', '戌', '亥', '子', '丑', '寅', '卯', '辰', '巳', '午', '未', '申'],
      ['戌', '亥', '子', '丑', '寅', '卯', '辰', '巳', '午', '未', '申', '酉'],
      ['亥', '子', '丑', '寅', '卯', '辰', '巳', '午', '未', '申', '酉', '戌'],
      ['子', '丑', '寅', '卯', '辰', '巳', '午', '未', '申', '酉', '戌', '亥'],
      ['丑', '寅', '卯', '辰', '巳', '午', '未', '申', '酉', '戌', '亥', '子'],
    ];

    String shenDiJhih = shenLocation[lunarTime['month'] - 1][lunarTime['hour'] - 1];
    for (House house in houseList) {
      house.isShen = (house.diJhih == shenDiJhih) ? true : false;
    }
  }

  static void _setTianGan() {
    List<List<String>> tianGan = [
      ['丙', '丁', '丙', '丁', '戊', '己', '庚', '辛', '壬', '癸', '甲', '乙'],
      ['戊', '己', '戊', '己', '庚', '辛', '壬', '癸', '甲', '乙', '丙', '丁'],
      ['庚', '辛', '庚', '辛', '壬', '癸', '甲', '乙', '丙', '丁', '戊', '己'],
      ['壬', '癸', '壬', '癸', '甲', '乙', '丙', '丁', '戊', '己', '庚', '辛'],
      ['甲', '乙', '甲', '乙', '丙', '丁', '戊', '己', '庚', '辛', '壬', '癸'],
    ];

    int y = lunarTime['tianGan'] - 1;
    for (int i = 0; i < 12; i++) {
      houseList[i].tianGan = tianGan[y][i];
    }
  }

  static void _setWuXingJu() {
    List<String> tianGan = ['甲', '乙', '丙', '丁', '戊', '己', '庚', '辛', '壬', '癸'];
    List<String> diJhih = ['子', '丑', '寅', '卯', '辰', '巳', '午', '未', '申', '酉', '戌', '亥'];

    int tgIndex = 0, djIndex = 0;
    for (House house in houseList) {
      if (house.name == '命') {
        tgIndex = (tianGan.indexOf(house.tianGan) / 2).floor();
        djIndex = (diJhih.indexOf(house.diJhih) / 2).floor();
        break;
      }
    }

    List<List<String>> wuXingJuList = [
      ['海中金', '大溪水', '覆燈火', '砂中金', '泉中水', '山頭火'],
      ['澗下水', '爐中火', '砂中土', '天河水', '山下火', '屋上土'],
      ['霹靂火', '城頭土', '大林木', '天上火', '大驛土', '平地木'],
      ['壁上土', '松柏木', '白蠟金', '路傍土', '石榴木', '釵釧金'],
      ['桑拓木', '金箔金', '長流水', '楊柳木', '劍鋒金', '大海水'],
    ];

    wuXingJu = wuXingJuList[tgIndex][djIndex];
  }

  static void _setMainStars() {
    List<String> diJhih = ['子', '丑', '寅', '卯', '辰', '巳', '午', '未', '申', '酉', '戌', '亥'];
    List<String> wuXing = ['木', '火', '土', '金', '水'];
    List<List<String>> ziWeiLocation = [
      ['辰', '丑', '寅', '巳', '寅', '卯', '午', '卯', '辰', '未', '辰', '巳', '申', '巳', '午', '酉', '午', '未', '戌', '未', '申', '亥', '申', '酉', '子', '酉', '戌', '丑', '戌', '亥'],
      ['酉', '午', '亥', '辰', '丑', '寅', '戌', '未', '子', '巳', '寅', '卯', '亥', '申', '丑', '午', '卯', '辰', '子', '酉', '寅', '未', '辰', '巳', '丑', '戌', '卯', '申', '巳', '午'],
      ['午', '亥', '辰', '丑', '寅', '未', '子', '巳', '寅', '卯', '申', '丑', '午', '卯', '辰', '酉', '寅', '未', '辰', '巳', '戌', '卯', '申', '巳', '午', '亥', '辰', '酉', '午', '未'],
      ['亥', '辰', '丑', '寅', '子', '巳', '寅', '卯', '丑', '午', '卯', '辰', '寅', '未', '辰', '巳', '卯', '申', '巳', '午', '辰', '酉', '午', '未', '巳', '戌', '未', '申', '午', '亥'],
      ['丑', '寅', '寅', '卯', '卯', '辰', '辰', '巳', '巳', '午', '午', '未', '未', '申', '申', '酉', '酉', '戌', '戌', '亥', '亥', '子', '子', '丑', '丑', '寅', '寅', '卯', '卯', '辰'],
    ];

    for (House house in houseList) {
      house.starList = [];
    }

    int ziweiIndex = diJhih.indexOf(ziWeiLocation[wuXing.indexOf(wuXingJu[2])][lunarTime['day'] - 1]);

    int starIndex = ziweiIndex;
    houseList[starIndex].starList.add(Star('紫微', 1));
    starIndex = (starIndex < 1) ? 12 + starIndex - 1 : starIndex - 1;
    houseList[starIndex].starList.add(Star('天機', 1));
    starIndex = (starIndex < 2) ? 12 + starIndex - 2 : starIndex - 2;
    houseList[starIndex].starList.add(Star('太陽', 1));
    starIndex = (starIndex < 1) ? 12 + starIndex - 1 : starIndex - 1;
    houseList[starIndex].starList.add(Star('武曲', 1));
    starIndex = (starIndex < 1) ? 12 + starIndex - 1 : starIndex - 1;
    houseList[starIndex].starList.add(Star('天同', 1));
    starIndex = (starIndex < 3) ? 12 + starIndex - 3 : starIndex - 3;
    houseList[starIndex].starList.add(Star('廉貞', 1));

    starIndex = (ziweiIndex <= 4) ? 4 - ziweiIndex : 16 - ziweiIndex;
    houseList[starIndex].starList.add(Star('天府', 1));
    starIndex = (starIndex + 1 > 11) ? starIndex - 12 + 1 : starIndex + 1;
    houseList[starIndex].starList.add(Star('太陰', 1));
    starIndex = (starIndex + 1 > 11) ? starIndex - 12 + 1 : starIndex + 1;
    houseList[starIndex].starList.add(Star('貪狼', 1));
    starIndex = (starIndex + 1 > 11) ? starIndex - 12 + 1 : starIndex + 1;
    houseList[starIndex].starList.add(Star('巨門', 1));
    starIndex = (starIndex + 1 > 11) ? starIndex - 12 + 1 : starIndex + 1;
    houseList[starIndex].starList.add(Star('天相', 1));
    starIndex = (starIndex + 1 > 11) ? starIndex - 12 + 1 : starIndex + 1;
    houseList[starIndex].starList.add(Star('天梁', 1));
    starIndex = (starIndex + 1 > 11) ? starIndex - 12 + 1 : starIndex + 1;
    houseList[starIndex].starList.add(Star('七殺', 1));
    starIndex = (starIndex + 4 > 11) ? starIndex - 12 + 4 : starIndex + 4;
    houseList[starIndex].starList.add(Star('破軍', 1));
  }

  void showAll() {
    Map<String, dynamic> m = {
      'name': name,
      'isBoy': isBoy,
      'clockTime': clockTime,
      'solarTime': solarTime,
      'lunarTime': lunarTime,
    };
    print(m.toString());

    for (House house in houseList) {
      print('{${house.name}, ${house.tianGan}${house.diJhih}}${(house.isShen) ? '(身)' : ''}');
      for (Star star in house.starList) {
        print(star.name);
      }
    }
  }
}

/* ***
ref:
  > factory
  https://stackoverflow.com/questions/38933801/calling-an-async-method-from-component-constructor-in-dart

  > zi wei innitial setting
  https://timoyang.pixnet.net/blog/post/462674150
  http://www.freehoro.net/ZWDS/Tutorial/PaiPan/6-0_WuXingGu_NaYin.php

*** */
