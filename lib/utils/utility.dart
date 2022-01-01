import 'package:flutter/material.dart';
import 'package:lastochki/services/chapter_service.dart';
import 'package:lastochki/views/theme.dart';
import 'package:lastochki/views/translation.dart';
import 'package:lastochki/views/ui/l_button.dart';
import 'package:lastochki/views/ui/l_info_popup.dart';
import 'package:lastochki/views/ui/l_loading.dart';
import 'package:states_rebuilder/states_rebuilder.dart';
import 'package:tuple/tuple.dart';

extension Tuple2FX<T1, T2> on Tuple2<Future<T1>, Future<T2>> {
  Future<Tuple2<T1, T2>> get wait =>
      Future.wait([item1, item2]).then((it) => Tuple2.fromList(it));
}

extension Tuple3FX<T1, T2, T3> on Tuple3<Future<T1>, Future<T2>, Future<T3>> {
  Future<Tuple3<T1, T2, T3>> get wait =>
      Future.wait([item1, item2, item3]).then((it) => Tuple3.fromList(it));
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
