List<String> tianGan = ['', '甲', '乙', '丙', '丁', '戊', '己', '庚', '辛', '壬', '癸'];
List<String> diJhih = ['', '子', '丑', '寅', '卯', '辰', '巳', '午', '未', '申', '酉', '戌', '亥'];

String lunarToString(Map<String, dynamic> lunar) {
  List<String> month = ['', '正', '二', '三', '四', '五', '六', '七', '八', '九', '十', '冬', '臘'];
  List<String> day = ['', '一', '二', '三', '四', '五', '六', '七', '八', '九', '十'];
  String result = '';

  result += '${tianGan[lunar['tianGan']]}${diJhih[lunar['diJhih']]}年 ';

  result += lunar['leap'] ? '閏' : '';

  result += '${month[lunar['month']]}月 ';

  if (lunar['day'] <= 10) {
    result += '初${day[lunar['day']]} ';
  } else if (lunar['day'] <= 19) {
    result += '十${day[lunar['day'] % 10]}日 ';
  } else if (lunar['day'] == 20) {
    result += '廿十日 ';
  } else if (lunar['day'] <= 29) {
    result += '廿${day[lunar['day'] % 10]}日 ';
  } else {
    result += '三十日 ';
  }

  result += '${diJhih[lunar['hour']]}時';

  return result;
}

String sexagenaryCycleToString(List<String> bazi) {
  String result = '';
  List<String> list = ['', '年 ', '', '月 ', '', '日 ', '', '時'];
  for (int i = 0; i < bazi.length; i++) {
    result += bazi[i] + list[i];
    result += (i % 2 == 1 && i != 7) ? ' ' : '';
  }
  return result;
}
