import '../function/time_convert.dart' show toSolar, toLunar;

List<String> _tianGanList = ['甲', '乙', '丙', '丁', '戊', '己', '庚', '辛', '壬', '癸'];
List<String> _diJhihList = ['子', '丑', '寅', '卯', '辰', '巳', '午', '未', '申', '酉', '戌', '亥'];
Map<String, int> _wuXingJuMap = {'木': 3, '火': 6, '土': 5, '金': 4, '水': 2};

List<List<String>> _transTable = [
  ['廉貞', '破軍', '武曲', '太陽'],
  ['天機', '天梁', '紫微', '太陰'],
  ['天同', '天機', '文昌', '廉貞'],
  ['太陰', '天同', '天機', '巨門'],
  ['貪狼', '太陰', '右弼', '天機'],
  ['武曲', '貪狼', '天梁', '文曲'],
  ['太陽', '武曲', '太陰', '天同'],
  ['巨門', '太陽', '文曲', '文昌'],
  ['天梁', '紫微', '左輔', '武曲'],
  ['破軍', '巨門', '太陰', '貪狼'],
];

class Star {
  static late Map<String, dynamic> lunarTime;
  late String name;
  late int level;
  late Map<String, bool> trans = {};

  Star(this.name, this.level) {
    trans = {
      'lu': (name == _transTable[lunarTime['tianGan'] - 1][0]),
      'ch': (name == _transTable[lunarTime['tianGan'] - 1][1]),
      'ke': (name == _transTable[lunarTime['tianGan'] - 1][2]),
      'ji': (name == _transTable[lunarTime['tianGan'] - 1][3]),
    };
  }
}

class House {
  late String name;
  late List<Star> starList;
  late String tianGan, diJhih;
  late bool isShen;
  late List<int> daYun;
  late Map<String, bool> tranSelf, transOopposite;

  House(this.diJhih, this.name);

  void setTrans(House house) {
    tranSelf = {'lu': false, 'ch': false, 'ke': false, 'ji': false};
    for (Star star in starList) {
      tranSelf['lu'] = ((tranSelf['lu']!) || (star.name == _transTable[_tianGanList.indexOf(tianGan)][0]));
      tranSelf['ch'] = ((tranSelf['ch']!) || (star.name == _transTable[_tianGanList.indexOf(tianGan)][1]));
      tranSelf['ke'] = ((tranSelf['ke']!) || (star.name == _transTable[_tianGanList.indexOf(tianGan)][2]));
      tranSelf['ji'] = ((tranSelf['ji']!) || (star.name == _transTable[_tianGanList.indexOf(tianGan)][3]));
    }

    transOopposite = {'lu': false, 'ch': false, 'ke': false, 'ji': false};
    for (Star star in house.starList) {
      transOopposite['lu'] = ((transOopposite['lu']!) || (star.name == _transTable[_tianGanList.indexOf(tianGan)][0]));
      transOopposite['ch'] = ((transOopposite['ch']!) || (star.name == _transTable[_tianGanList.indexOf(tianGan)][1]));
      transOopposite['ke'] = ((transOopposite['ke']!) || (star.name == _transTable[_tianGanList.indexOf(tianGan)][2]));
      transOopposite['ji'] = ((transOopposite['ji']!) || (star.name == _transTable[_tianGanList.indexOf(tianGan)][3]));
    }
  }
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
    Star.lunarTime = lunarTime;

    _setHousesName();
    _setShenGong();
    _setTianGan();
    _setWuXingJu();
    _setLuckOfHouse();
    _setMainStars();
    _setSecondaryStars();
    _setHousesSiHua();

    // Return the fully initialized object
    return mingPan;
  }

  static void _setHousesName() {
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
      houseList.add(House(_diJhihList[i], name[index]));
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
      ['甲', '乙', '甲', '乙', '丙', '丁', '戊', '己', '庚', '辛', '壬', '癸'],
      ['丙', '丁', '丙', '丁', '戊', '己', '庚', '辛', '壬', '癸', '甲', '乙'],
      ['戊', '己', '戊', '己', '庚', '辛', '壬', '癸', '甲', '乙', '丙', '丁'],
      ['庚', '辛', '庚', '辛', '壬', '癸', '甲', '乙', '丙', '丁', '戊', '己'],
      ['壬', '癸', '壬', '癸', '甲', '乙', '丙', '丁', '戊', '己', '庚', '辛'],
    ];

    int y = lunarTime['tianGan'] % 5;
    for (int i = 0; i < 12; i++) {
      houseList[i].tianGan = tianGan[y][i];
    }
  }

  static void _setWuXingJu() {
    int tgIndex = 0, djIndex = 0;
    for (House house in houseList) {
      if (house.name == '命') {
        tgIndex = (_tianGanList.indexOf(house.tianGan) / 2).floor();
        djIndex = (_diJhihList.indexOf(house.diJhih) / 2).floor();
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

  static void _setLuckOfHouse() {
    int index = 0;
    for (House house in houseList) {
      if (house.name == '命') {
        index = _diJhihList.indexOf(house.diJhih);
        break;
      }
    }

    bool clockwise = isBoy && lunarTime['tianGan'] % 2 == 1;
    clockwise = clockwise || (!isBoy && lunarTime['tianGan'] % 2 == 0);

    for (int i = 0; i < 12; i++) {
      houseList[index].daYun = [];
      houseList[index].daYun.add(_wuXingJuMap[wuXingJu[2]]! + i * 10 + 0);
      houseList[index].daYun.add(_wuXingJuMap[wuXingJu[2]]! + i * 10 + 9);

      if (clockwise) {
        index = (index == 11) ? 0 : index + 1;
      } else {
        index = (index == 0) ? 11 : index - 1;
      }
    }
  }

  static void _setMainStars() {
    Map<String, List<String>> ziWeiLocation = {
      '木': ['辰', '丑', '寅', '巳', '寅', '卯', '午', '卯', '辰', '未', '辰', '巳', '申', '巳', '午', '酉', '午', '未', '戌', '未', '申', '亥', '申', '酉', '子', '酉', '戌', '丑', '戌', '亥'],
      '火': ['酉', '午', '亥', '辰', '丑', '寅', '戌', '未', '子', '巳', '寅', '卯', '亥', '申', '丑', '午', '卯', '辰', '子', '酉', '寅', '未', '辰', '巳', '丑', '戌', '卯', '申', '巳', '午'],
      '土': ['午', '亥', '辰', '丑', '寅', '未', '子', '巳', '寅', '卯', '申', '丑', '午', '卯', '辰', '酉', '寅', '未', '辰', '巳', '戌', '卯', '申', '巳', '午', '亥', '辰', '酉', '午', '未'],
      '金': ['亥', '辰', '丑', '寅', '子', '巳', '寅', '卯', '丑', '午', '卯', '辰', '寅', '未', '辰', '巳', '卯', '申', '巳', '午', '辰', '酉', '午', '未', '巳', '戌', '未', '申', '午', '亥'],
      '水': ['丑', '寅', '寅', '卯', '卯', '辰', '辰', '巳', '巳', '午', '午', '未', '未', '申', '申', '酉', '酉', '戌', '戌', '亥', '亥', '子', '子', '丑', '丑', '寅', '寅', '卯', '卯', '辰'],
    };

    for (House house in houseList) {
      house.starList = [];
    }

    int ziweiIndex = _diJhihList.indexOf(ziWeiLocation[wuXingJu[2]]![lunarTime['day'] - 1]);

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

  static void _setSecondaryStars() {
    List<dynamic> location = [];
    int starIndex = -1;

    location = ['戌', '酉', '申', '未', '午', '巳', '辰', '卯', '寅', '丑', '子', '亥'];
    starIndex = _diJhihList.indexOf(location[lunarTime['hour'] - 1]);
    houseList[starIndex].starList.add(Star('文昌', 2));

    location = ['辰', '巳', '午', '未', '申', '酉', '戌', '亥', '子', '丑', '寅', '卯'];
    starIndex = _diJhihList.indexOf(location[lunarTime['hour'] - 1]);
    houseList[starIndex].starList.add(Star('文曲', 2));

    location = ['辰', '巳', '午', '未', '申', '酉', '戌', '亥', '子', '丑', '寅', '卯'];
    starIndex = _diJhihList.indexOf(location[lunarTime['month'] - 1]);
    houseList[starIndex].starList.add(Star('左輔', 2));

    location = ['戌', '酉', '申', '未', '午', '巳', '辰', '卯', '寅', '丑', '子', '亥'];
    starIndex = _diJhihList.indexOf(location[lunarTime['month'] - 1]);
    houseList[starIndex].starList.add(Star('右弼', 2));

    location = ['丑', '子', '亥', '亥', '丑', '子', '丑', '午', '卯', '卯'];
    starIndex = _diJhihList.indexOf(location[lunarTime['tianGan'] - 1]);
    houseList[starIndex].starList.add(Star('天魁', 2));

    location = ['未', '申', '酉', '酉', '未', '申', '未', '寅', '巳', '巳'];
    starIndex = _diJhihList.indexOf(location[lunarTime['tianGan'] - 1]);
    houseList[starIndex].starList.add(Star('天鉞', 2));

    location = ['卯', '辰', '午', '未', '午', '未', '酉', '戌', '子', '丑'];
    starIndex = _diJhihList.indexOf(location[lunarTime['tianGan'] - 1]);
    houseList[starIndex].starList.add(Star('擎羊', 3));

    location = ['丑', '寅', '辰', '巳', '辰', '巳', '未', '申', '戌', '亥'];
    starIndex = _diJhihList.indexOf(location[lunarTime['tianGan'] - 1]);
    houseList[starIndex].starList.add(Star('陀羅', 3));

    location = [
      ['酉', '戌', '亥', '子', '丑', '寅', '卯', '辰', '巳', '午', '未', '申'],
      ['寅', '卯', '辰', '巳', '午', '未', '申', '酉', '戌', '亥', '子', '丑'],
      ['卯', '辰', '巳', '午', '未', '申', '酉', '戌', '亥', '子', '丑', '寅'],
      ['丑', '寅', '卯', '辰', '巳', '午', '未', '申', '酉', '戌', '亥', '子'],
    ];
    starIndex = _diJhihList.indexOf(location[lunarTime['diJhih'] % 4][lunarTime['hour'] - 1]);
    houseList[starIndex].starList.add(Star('火星', 3));

    location = [
      ['戌', '亥', '子', '丑', '寅', '卯', '辰', '巳', '午', '未', '申', '酉'],
      ['戌', '亥', '子', '丑', '寅', '卯', '辰', '巳', '午', '未', '申', '酉'],
      ['戌', '亥', '子', '丑', '寅', '卯', '辰', '巳', '午', '未', '申', '酉'],
      ['卯', '辰', '巳', '午', '未', '申', '酉', '戌', '亥', '子', '丑', '寅'],
    ];
    starIndex = _diJhihList.indexOf(location[lunarTime['diJhih'] % 4][lunarTime['hour'] - 1]);
    houseList[starIndex].starList.add(Star('鈴星', 3));

    location = ['亥', '戌', '酉', '申', '未', '午', '巳', '辰', '卯', '寅', '丑', '子'];
    starIndex = _diJhihList.indexOf(location[lunarTime['hour'] - 1]);
    houseList[starIndex].starList.add(Star('地空', 3));

    location = ['亥', '子', '丑', '寅', '卯', '辰', '巳', '午', '未', '申', '酉', '戌'];
    starIndex = _diJhihList.indexOf(location[lunarTime['hour'] - 1]);
    houseList[starIndex].starList.add(Star('地劫', 3));
  }

  static void _setHousesSiHua() {
    for (int i = 0; i < 12; i++) {
      houseList[i].setTrans(houseList[(i + 6) % 12]);
    }
  }
}

/* ***
ref:
  > factory
  https://stackoverflow.com/questions/38933801/calling-an-async-method-from-component-constructor-in-dart

  > zi wei innitial setting
  https://www.youtube.com/watch?v=rpm2dhhEdyk&list=PLFkjU2k58dB6djoiA20u6Xce-eTaZpuSm
  https://timoyang.pixnet.net/blog/post/462674150
  http://www.freehoro.net/ZWDS/Tutorial/PaiPan/6-0_WuXingGu_NaYin.php

*** */
