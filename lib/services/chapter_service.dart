import 'package:lastochki/models/entities/Chapter.dart';
import 'package:lastochki/models/entities/GameInfo.dart';
import 'package:lastochki/services/api_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChapterService {
  // TODO rewrite repo
  final ApiClient _repository;

  ChapterService({
    ApiClient repository,
  }) : _repository = repository;

  List<Chapter> chapters;
  GameInfo gameInfo;
  double loadingPercent;

  loadGame() async {
    List values = await Future.wait([
      SharedPreferences.getInstance()
          .then((value) => value.getString('gameInfo')),
      _repository.getChapters(),
    ]);
    print(values);

    // chapters =

    if (values[0] == null) {
      // gameInfo = GameInfo(currentChapterId: );
    } else {
      gameInfo = GameInfo.fromJson(values[0]);
    }

    await loadChapter();
  }

  loadChapter() async {}
}
