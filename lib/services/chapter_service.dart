import 'package:lastochki/models/entities/Chapter.dart';
import 'package:lastochki/models/entities/GameInfo.dart';
import 'package:lastochki/models/entities/Story.dart';
import 'package:lastochki/services/chapter_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChapterService {
  final ChapterRepository _repository;

  ChapterService({
    ChapterRepository repository,
  }) : _repository = repository;

  List<Chapter> chapters;
  Chapter currentChapter;
  GameInfo gameInfo;
  double loadingPercent;

  void onReceive(int loaded, int info, {double total}) {
    loadingPercent = loaded / (total ?? loaded);
    print(loadingPercent);
    // print('$loaded  $info $total $loadingPercent');
  }

  Chapter getCurrentChapter() {
    return currentChapter;
  }

  double getLoadingPercent() {
    return loadingPercent;
  }

  loadGame() async {
    List values = await Future.wait([
      SharedPreferences.getInstance()
          .then((value) => value.getString('gameInfo')),
      _repository.getChapters(),
    ]);
    print(values);

    chapters = values[1];

    if (values[0] == null) {
      gameInfo = GameInfo();
    } else {
      gameInfo = GameInfo.fromJson(values[0]);
    }

    await loadChapter();
  }

  loadChapter() async {
    // TODO check free space
    int currentChapterId = gameInfo.currentStep == ''
        ? gameInfo.currentChapterId + 1
        : gameInfo.currentChapterId;
    currentChapter =
        chapters.firstWhere((element) => element.number == currentChapterId);
    Story s = await _repository.getStory(
        currentChapter,
        (i, j) =>
            this.onReceive(i, j, total: currentChapter.mBytes * 1024 * 1024));
    currentChapter.story = s;
    loadingPercent = null;
  }
}
