import 'package:flutter/material.dart';
import 'frame_page.dart';

class BirthdayInputPage extends StatefulWidget {
  const BirthdayInputPage({Key? key}) : super(key: key);

  @override
  State<BirthdayInputPage> createState() => _BirthdayInputPageState();
}

enum Gender { boy, girl }

class _BirthdayInputPageState extends State<BirthdayInputPage> {
  String name = '';
  DateTime birthday = DateTime.now();
  String text = DateTime.now().toString();
  Gender? gender = Gender.boy;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Navigator.of(context).pop(),
      )),
      body: Center(
          child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(width: 200, child: TextFormField(onChanged: (String s) => name = s)),
          SizedBox(
              width: 200,
              child: Column(
                children: <Widget>[
                  ListTile(
                    title: const Text('boy'),
                    leading: Radio<Gender>(
                      value: Gender.boy,
                      groupValue: gender,
                      onChanged: (Gender? g) => setState(() => gender = (g ?? Gender.boy)),
                    ),
                  ),
                  ListTile(
                    title: const Text('girl'),
                    leading: Radio<Gender>(
                      groupValue: gender,
                      value: Gender.girl,
                      onChanged: (Gender? g) => setState(() => gender = (g ?? Gender.girl)),
                    ),
                  ),
                ],
              )),
          ElevatedButton(
            onPressed: () async {
              showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(1901), lastDate: DateTime(2100)).then((dt) {
                dt = dt ?? DateTime.now();
                birthday = DateTime(dt.year, dt.month, dt.day, birthday.hour, birthday.minute);
                setState(() => text = birthday.toString());
              });
            },
            child: const Text('y-m-d'),
          ),
          ElevatedButton(
            onPressed: () async {
              showTimePicker(context: context, initialTime: TimeOfDay.now()).then((tod) {
                tod = tod ?? TimeOfDay.now();
                birthday = DateTime(birthday.year, birthday.month, birthday.day, tod.hour, tod.minute);
                setState(() => text = birthday.toString());
              });
            },
            child: const Text('h-m'),
          ),
          Text(text),
          OutlinedButton(
            child: const Text('Register'),
            onPressed: () {
              Map<String, dynamic> m = {
                'name': (name == '') ? '匿名' : name,
                'isBoy': (gender == Gender.boy),
                'birthday': birthday,
              };
              Navigator.push(context, MaterialPageRoute(builder: (context) => FramePage(info: m)));
            },
          ),
        ],
      )),
    );
  }
}

/* ***
ref:
  > Navigation & Routing
  https://ithelp.ithome.com.tw/articles/10215918
  https://docs.flutter.dev/cookbook/animation/page-route-animation

  > TextFormField and its width, height
  https://stackoverflow.com/questions/50400529/how-to-change-textfields-height-and-width

  > Radio buttons
  https://api.flutter.dev/flutter/material/Radio-class.html

  > showDatePicker
  http://laomengit.com/flutter/widgets/DatePicker.html

  > showTimePicker
  https://codesinsider.com/flutter-timepicker-widget-example-tutorial/

  > variable null check
  https://flutterigniter.com/checking-null-aware-operators-dart/

*** */