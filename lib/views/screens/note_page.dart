import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';
import 'package:lastochki/models/entities/Name.dart';
import 'package:lastochki/views/theme.dart';
import 'package:lastochki/views/ui/l_button.dart';

class NotePage extends StatefulWidget {
  @override
  _NotePageState createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> {
  //TODO: вставить переводы
  Name title =
      Name(ru: 'Что такое Заметки и зачем они нужны для игры', kg: 'test');
  Name note = Name(
      ru: 'Более трёх четвертей территории Киргизии занимают горы. Территория страны расположена в пределах двух горных систем. Северо-восточная её часть лежит в пределах Тянь-Шаня, юго-западная — в пределах Памиро-Алая. Вся территория республики лежит выше 394 м над уровнем моря, средняя высота над уровнем моря 2750 м.\n\n'
          'Более половины её располагается на высотах от 1000 до 3000 м и примерно треть — на высотах от 3000 до 4000 м. Пик Победы является наивысшей точкой страны и самый северным семитысячником на Земле, его высота 7439 м. На востоке главные хребты Тянь-Шаня сближаются в районе Меридионального хребта, создавая мощный горный узел.\n\n'
          'На границе с Китаем и Казахстаном поднимается пик Победы (7439 м) и Хан-Тенгри (7010 м или 6995 м без учёта ледяного покрова)[27]. Западная часть Киргизии расположена в пределах Западного Тянь-Шаня.\n\n'
          'Более трёх четвертей территории Киргизии занимают горы. Территория страны расположена в пределах двух горных систем. ',
      kg: 'test');
  Name okay = Name(ru: 'Понятно', kg: 'test');
  final String bottomBG = 'assets/backgrounds/note_bottom_background.png';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        automaticallyImplyLeading: false,
        actions: <Widget>[
          IconButton(
              icon: Image.asset(
                closeIcon,
                height: 14.0,
              ),
              onPressed: () {
                Navigator.pop(context);
              })
        ],
      ),
      body: Scrollbar(
          child: ListView(
        padding: EdgeInsets.only(top: 0.0),
        children: <Widget>[
          Container(
            height: 180.0,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: NetworkImage(
                        'https://sun9-48.userapi.com/c854520/v854520307/252b21/ausgjIvyTks.jpg'),
                    fit: BoxFit.cover)),
          ),
          Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Text(
                  title.toString(),
                  style: titleTextStyle,
                ),
              ),
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Html(
                    data: note.toString(),
                    style: {
                      "body": Style(color: textColor, fontSize: FontSize(17.0))
                    },
                  ))
            ],
          ),
          Container(
            height: 175,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(bottomBG), fit: BoxFit.cover)),
            child: Center(
              child: LButton(
                  text: okay.toString(),
                  func: () {
                    debugPrint('okay');
                  }),
            ),
          )
        ],
      )),
    );
  }
}
