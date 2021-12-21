// load from db
// TODO check ichapter changes
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:lastochki/models/entities/Chapter.dart';
import 'package:lastochki/models/entities/Name.dart';
import 'package:lastochki/models/entities/Note.dart';
import 'package:lastochki/models/entities/Story.dart';
import 'package:lastochki/utils/utility.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tuple/tuple.dart';

import 'api_client.dart';
import 'persistance_exception.dart';

@immutable
class ChaptersData {
  final List<Chapter> chapters;
  final Name futureChapterText;
  final int totalChapterNumber;

  ChaptersData({
    @required this.chapters,
    @required this.futureChapterText,
    @required this.totalChapterNumber,
  });
}

@immutable
class StoryData {
  final Story story;
  final String zipPath;
  final List<Note> notes;

  StoryData({
    @required this.story,
    @required this.zipPath,
    @required this.notes,
  });
}

class ChapterRepository {
  final ApiClient _apiClient;

  ChapterRepository() : _apiClient = ApiClient();

  Future<ChaptersData> getChapters() async {
    try {
      final response = await _apiClient.getChapters();
      Map data = response.data;
      List<dynamic> chapters = data['chapters'];
      return ChaptersData(
        chapters: chapters.map((e) => Chapter.fromBackendMap(e)).toList(),
        // TODO work with lang
        futureChapterText: Name(
          ru: data['future_chapter_text'],
          kg: data['future_chapter_text_kg'],
        ),
        totalChapterNumber: data['total_chapter_number'],
      );
    } catch (e) {
      throw PersistanceException(e);
    }
  }

  Future<StoryData> getStory(Chapter chapter, Function onReceiveProgress) async {
    try {
      Directory tempDir = await getTemporaryDirectory();
      String tempFilePath = '${tempDir.path}/images.zip';
      final response = await Tuple3(
        _apiClient.loadSource(chapter.storyUri, null),
        _apiClient.loadSource(chapter.noteUri, null),
        // watch only for images loading cause it biggest
        _apiClient.downloadFiles(
            chapter.mediaUri, tempFilePath, onReceiveProgress),
      ).wait;
      Map story = response.item1.data;
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
      var chapterId = response.item2.data['chapter'];
      return StoryData(
        story: Story.fromBackendMap(story),
        zipPath: tempFilePath,
        notes: response.item2
            .data['list']
            .map<Note>((n) => Note.fromBackendMap(n, chapterId))
            .toList(),
      );
    } catch (e) {
      throw PersistanceException(e);
    }
  }

  Future<void> loadChapter(String path, Function onReceiveProgress) async {
    try {
      await _apiClient.loadSource(path, onReceiveProgress);
    } catch (e) {
      throw PersistanceException(e);
    }
  }
}
