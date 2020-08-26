import 'package:flutter/material.dart';
import 'package:lastochki/views/screens/openline_logo_page.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ласточки. Весна в Бишкеке',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: OpenlineLogoPage(),
    );
  }
}
