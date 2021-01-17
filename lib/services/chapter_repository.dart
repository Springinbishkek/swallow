// load from db
// TODO check ichapter changes
import 'dart:io';
import 'package:lastochki/models/entities/Name.dart';
import 'package:path_provider/path_provider.dart';

import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:lastochki/models/entities/Chapter.dart';
import 'package:lastochki/models/entities/Note.dart';
import 'package:lastochki/models/entities/Story.dart';

import 'persistance_exception.dart';
import 'api_client.dart';

class ChapterRepository {
  final ApiClient _apiClient;
  ChapterRepository() : _apiClient = ApiClient();

  Future<Map> getChapters() async {
    try {
      final response = await _apiClient.getChapters();
      Map data = response.data;
      List<dynamic> chapters = data['chapters'];
      return {
        'chapters': chapters.map((e) => Chapter.fromBackendMap(e)).toList(),
        // TODO work with lang
        'futureChapterText': Name(
            ru: data['future_chapter_text'], kg: data['future_chapter_text_kg'])
      };
    } catch (e) {
      throw PersistanceException(e);
    }
  }

  Future<Map> getStory(Chapter chapter, Function onReceiveProgress) async {
    try {
      Directory tempDir = await getTemporaryDirectory();
      String tempFilePath = '${tempDir.path}/images.zip';
      final response = await Future.wait([
        _apiClient.loadSource(chapter.storyUri, null),
        _apiClient.loadSource(chapter.noteUri, null),
        // watch only for images loading cause it biggest
        _apiClient.downloadFiles(
            chapter.mediaUri, tempFilePath, onReceiveProgress),
      ]);
      Map story = response[0].data;
      story['chapterId'] = chapter.number;

      Map firstPassage = story['passages'].firstWhere((p) {
        List<dynamic> tags = p['tags'];
        return tags.contains('IsStartBlock:True');
      });
      story['firstPid'] = firstPassage['pid'];
      Map<dynamic, dynamic> m = {};
      story['passages'].forEach((p) {
        m[p['pid']] = p;
      });
      story['script'] = m;
      // TODO set notes to db
      var chapterId = response[1].data['chapter'];
      return {
        'story': Story.fromBackendMap(story),
        'zipPath': tempFilePath,
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
