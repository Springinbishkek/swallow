// load from db
// TODO check ichapter changes
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:lastochki/models/entities/Chapter.dart';
import 'package:lastochki/models/entities/Note.dart';
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

  Future<Map> getStory(Chapter chapter, Function onReceiveProgress) async {
    try {
      final response = await Future.wait([
        _apiClient.loadSource(chapter.storyUri, null),
        _apiClient.loadSource(chapter.noteUri, null),
        // watch only for images loading cause it biggest
        // _apiClient.downloadFiles(chapter.mediaUri, onReceiveProgress),
        // TODO
      ]);
      // onReceiveProgress(1, 1, total: 1);
      Map story = response[0].data;
      story['chapterId'] = chapter.number;
      story['firstPid'] = story['passages'][0]['pid'];
      Map<dynamic, dynamic> m = {};
      story['passages'].forEach((p) {
        m[p['pid']] = p;
      });
      story['script'] = m;
      // TODO set notes to db
      var chapterId = response[1].data['chapter'];
      return {
        'story': Story.fromBackendMap(story),
        'notes': response[1]
            .data['list']
            .map<Note>((n) => Note.fromBackendMap(n, chapterId))
            .toList(),
      };
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
