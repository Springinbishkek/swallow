import 'package:lastochki/models/entities/Chapter.dart';
import 'package:lastochki/services/api_client.dart';

class ChapterService {
  final ApiClient _repository;
  int currentChapter;
  ChapterService({
    ApiClient repository,
    this.currentChapter = 0,
  }) : _repository = repository;

  List<Chapter> chapters;
}
