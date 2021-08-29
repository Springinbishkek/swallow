import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:lastochki/services/chapter_service.dart';
import 'package:lastochki/views/theme.dart';
import 'package:lastochki/views/translation.dart';
import 'package:lastochki/views/ui/l_button.dart';
import 'dart:convert';

import 'package:lastochki/views/ui/l_info_popup.dart';
import 'package:lastochki/views/ui/l_loading.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

class Utility {
  static Image imageFromBase64String(String base64String) {
    return Image.memory(
      base64Decode(base64String),
      fit: BoxFit.fill,
    );
  }

  static Uint8List dataFromBase64String(String base64String) {
    return base64Decode(base64String);
  }

  static String base64String(Uint8List data) {
    return base64Encode(data);
  }
}

void onRestartGame(BuildContext context) async {
  bool isRestarting = await showDialog(
    context: context,
    builder: (context) {
      return LInfoPopup(
        isCloseEnable: true,
        image: alertImg,
        title: null,
        content: restartGameContent.toString(),
        actions: Column(
          children: [
            LButton(
              text: letsPlay.toString(),
              func: () => Navigator.of(context).pop(true),
            ),
            SizedBox(
              height: 16,
            ),
            LButton(
              buttonColor: whiteColor,
              text: cancel.toString(),
              func: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      );
    },
  );
  if (isRestarting != null && isRestarting) {
    restartAllGame(context);
  }
}

void restartAllGame(BuildContext context) async {
  bool isLoading = true;
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return WillPopScope(
        child: Center(
          child: LLoading(),
        ),
        onWillPop: () => Future.value(!isLoading),
      );
    },
  );
  // print('shows');
  try {
    await RM.get<ChapterService>().state.restartAllGame(context);
  } catch (e, stackTrace) {
    Future.error(e, stackTrace);
    // TODO show errors
  } finally {
    isLoading = false;
    Navigator.of(context, rootNavigator: true).maybePop();
  }
}
