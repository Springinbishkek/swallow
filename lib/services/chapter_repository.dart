// load from db
// TODO check ichapter changes
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:lastochki/models/entities/Chapter.dart';
import 'package:lastochki/models/entities/Story.dart';

import 'persistance_exception.dart';
import 'api_client.dart';

class ChapterRepository {
  final ApiClient _apiClient;
  ChapterRepository() : _apiClient = ApiClient();

  Future<List> getChapters() async {
    try {
      final response = await _apiClient.getChapters();
      Map data = response.data;
      List<dynamic> chapters = data['chapters'];
      print(chapters[0]);
      return chapters.map((e) => Chapter.fromMap(e)).toList();
    } catch (e) {
      throw PersistanceException(e);
    }
  }

  Future<Story> getStory(Chapter chapter, Function onReceiveProgress) async {
    try {
      final response = await Future.wait([
        _apiClient.loadSource(chapter.storyUri, null),
        // watch only for images loading cause it biggest
        _apiClient.downloadFiles(chapter.mediaUri, onReceiveProgress),
        // TODO
        _apiClient.loadSource(chapter.noteUri, null),
      ]);
      // onReceiveProgress(1, 1, total: 1);
      Map story = response[0].data;
      story['chapterId'] = chapter.number;
      return Story.fromMap(story);
    } catch (e) {
      throw PersistanceException(e);
    }
  }

  Future<void> loadChapter(String path, Function onReceiveProgress) async {
    try {
      final response = await _apiClient.loadSource(path, onReceiveProgress);
    } catch (e) {
      throw PersistanceException(e);
    }
  }
}
