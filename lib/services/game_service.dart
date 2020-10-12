import 'package:lastochki/models/entities/Chapter.dart';
import 'package:lastochki/services/api_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChapterService {
  // TODO rewrite repo
  final SharedPreferences _repository;
  int currentChapter;
  int currentPid;
  ChapterService({
    SharedPreferences repository,
    this.currentChapter = 0,
    this.currentPid,
  }) : _repository = repository;

  List<Chapter> chapters;

  loadGame() {
    _repository.getString('gameInfo');
  }
}
