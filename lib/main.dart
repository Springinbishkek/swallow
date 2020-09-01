import 'package:flutter/material.dart';
import 'package:lastochki/services/api_client.dart';
import 'package:lastochki/services/chapter_service.dart';
import 'package:lastochki/services/note_service.dart';
import 'package:lastochki/views/screens/openline_logo_page.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  final ApiClient apiClient = ApiClient();

  @override
  Widget build(BuildContext context) {
    return Injector(
        //Inject Model instance into the widget tree.
        inject: [
          Inject(() => NoteService(repository: apiClient)),
          Inject(() => ChapterService(repository: apiClient)),
        ],
        builder: (context) => MaterialApp(
              title: 'Ласточки. Весна в Бишкеке',
              theme: ThemeData(
                fontFamily: 'SourceSansPro',
                primarySwatch: Colors.blue,
                visualDensity: VisualDensity.adaptivePlatformDensity,
              ),
              home: OpenlineLogoPage(),
            ));
  }
}
