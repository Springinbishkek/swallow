import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:lastochki/services/analytics.dart';
import 'package:lastochki/views/theme.dart';
import 'package:lastochki/views/ui/l_appbar.dart';
import 'package:lastochki/views/ui/l_button.dart';
import 'package:package_info/package_info.dart';
import 'package:states_rebuilder/states_rebuilder.dart';
import 'package:url_launcher/url_launcher.dart';

import '../translation.dart';

class AboutPage extends StatefulWidget {
    @override
    _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
    String version = '';

    @override
    void initState() {
        super.initState();
        loadVersion();
    }

    void loadVersion() async {
        PackageInfo packageInfo = await PackageInfo.fromPlatform();
        String osInfo = '';
        if (Platform.isAndroid) {
            var androidInfo = await DeviceInfoPlugin().androidInfo;
            var release = androidInfo.version.release;
            var sdkInt = androidInfo.version.sdkInt;
            var manufacturer = androidInfo.manufacturer;
            var model = androidInfo.model;
            osInfo = 'Android $release (SDK $sdkInt), $manufacturer $model';
            print(osInfo);
            // Android 9 (SDK 28), Xiaomi Redmi Note 7
        }

        if (Platform.isIOS) {
            var iosInfo = await DeviceInfoPlugin().iosInfo;
            var systemName = iosInfo.systemName;
            var version = iosInfo.systemVersion;
            var name = iosInfo.name;
            var model = iosInfo.model;
            osInfo = '$systemName $version, $name $model';
            // iOS 13.1, iPhone 11 Pro Max iPhone
        }

        setState(() {
            version = 'v ${packageInfo.version} $osInfo';
        });
    }

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: scaffoldBgColor,
            appBar: lAppbar(
                title: aboutGame.toString(),
                func: () {
                    Navigator.pop(context);
                }),
            body: Padding(
                padding: const EdgeInsets.all(20),
                child: ListView(
                    children: [
                        Text(
                            '${aboutUsTitle.toString()}\n',
                            style: titleTextStyle,
                        ),
                        Text(
                            aboutUsContent.toString(),
                            style: noteTextStyle,
                        ),
                        SizedBox(height: 30),
                        Column(
                            mainAxisSize: MainAxisSize.min,
                            // crossAxisAlignment: CrossAxisAlignment.baseline,
                            children: [
                                LButton(
                                    text: gameInst.toString(),
                                    iconOnRightSide: false,
                                    icon: instagramIcon,
                                    func: () {
                                        //АНАЛИТИКА переход в инстаграм
                                        RM.get<Analytics>().state.log('InstagramSite');
                                        return launch(
                                        'https://instagram.com/vesna_v_bishkeke?igshid=1w94jf7ztsgsg');
                                    },
                                    buttonColor: whiteColor,
                                ),
                                LButton(
                                    text: aboutOpenline.toString(),
                                    icon: infoIcon,
                                    iconOnRightSide: false,
                                    func: () {
                                        //АНАЛИТИКА переход на сайт открытой линии
                                        RM.get<Analytics>().state.log('OpenLine');
                                      return launch('https://openline.kg/new/');
                                    },
                                    buttonColor: whiteColor,
                                ),
                            ],
                        ),
                        SizedBox(height: 20),
                        RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                                style: Theme.of(context).textTheme.bodyText2,
                                text: '${politics.toString()}\n',
                                children: [
                                    TextSpan(
                                        text: conditions.toString(),
                                        recognizer: TapGestureRecognizer()
                                            ..onTap = () {
                                                launch(
                                                    'https://docs.google.com/document/d/1RIXCksmaxQ-zwyw6bkKugJblbMjIHg1Yj4WgGME0AD0/edit?usp=drivesdk');
                                            },
                                    ),
                                ],
                            ),
                        ),
                        SizedBox(height: 20),
                        Text(
                            version,
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .bodyText2
                                .copyWith(color: Colors.grey[600]),
                        ),
                    ],
                ),
            ),
        );
    }
}
