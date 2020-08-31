import 'package:flutter/material.dart';
import 'package:lastochki/models/entities/Name.dart';

final Name loading = Name(
  ru: 'Загрузка',
  kg: 'Загрузка',
);

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double loadingValue;

  @override
  void initState() {
    super.initState();
    // loadingValue = 0.1;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/backgrounds/loading_background.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '$loading...',
                style: Theme.of(context)
                    .textTheme
                    .headline6
                    .copyWith(color: Colors.white),
              ),
              SizedBox(height: 10),
              SizedBox(
                width: 200,
                height: 10,
                child: LinearProgressIndicator(
                  value: loadingValue,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
