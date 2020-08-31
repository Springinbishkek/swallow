import 'package:lastochki/models/entities/Chapter.dart';
import 'package:lastochki/services/api_client.dart';

class ChapterService {
  // TODO rewrite repo
  final ApiClient _repository;
  int currentChapter;
  int currentPid;
  ChapterService({
    ApiClient repository,
    this.currentChapter = 0,
    this.currentPid,
  }) : _repository = repository;

  List<Chapter> chapters;
}
