import 'dart:async';
import 'dart:io' as io;
import 'package:lastochki/models/entities/Photo.dart';
import 'package:lastochki/models/entities/Story.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DBHelper {
  static Database _db;
  static const String ID = 'id';
  static const String NAME = 'photoName';
  static const String DATA = 'imgPath';
  static const String STORY_DATA = 'story';
  static const String CHAPTER_ID = 'chapterId';
  static const String TABLE = 'PhotosTable';
  static const String TABLE_STORY = 'StoriesTable';
  static const String DB_NAME = 'photos.db';
  int _version = 10;

  Future<Database> get db async {
    if (null != _db) {
      return _db;
    }
    _db = await initDb();
    return _db;
  }

  initDb() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, DB_NAME);
    var db = await openDatabase(path,
        version: _version, onCreate: _onCreate, onUpgrade: _onUpgrade);
    return db;
  }

  get version {
    return _version;
  }

  _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // TODO
    // await db.delete('$TABLE');
    // await db.delete('$TABLE_STORY');
    if (oldVersion != newVersion) {
      print('drop tables');
      // TODO delete photos from memory
      await db.execute("DROP TABLE IF EXISTS $TABLE");
      await db.execute("DROP TABLE IF EXISTS $TABLE_STORY");
      await _onCreate(db, newVersion);
    }
  }

  _onCreate(Database db, int version) async {
    await db.execute(
        "CREATE TABLE $TABLE ($ID INTEGER, $NAME TEXT NOT NULL UNIQUE ON CONFLICT REPLACE, $CHAPTER_ID INTEGER, $DATA TEXT)");
    await db.execute(
        "CREATE TABLE $TABLE_STORY ($ID INTEGER, $CHAPTER_ID INTEGER NOT NULL UNIQUE ON CONFLICT REPLACE, $STORY_DATA TEXT)");
  }

  Future<Photo> save(Photo employee) async {
    var dbClient = await db;
    employee.id = await dbClient.insert(TABLE, employee.toMap());
    return employee;
  }

  Future<Story> saveStory(Story employee) async {
    var dbClient = await db;
    Map<String, dynamic> raw = {
      '$CHAPTER_ID': employee.chapterId,
      '$STORY_DATA': employee.toJson(),
    };
    await dbClient.insert(TABLE_STORY, raw);
    return employee;
  }
  // Future<Photo> getPhoto(String name) async {
  //   Photo employee;
  //   var dbClient = await db;
  //   employee = Photo.fromMap((await dbClient.query(TABLE, where: '')).first);
  //   return employee;
  // }

  Future<List<Photo>> getPhotos() async {
    var dbClient = await db;
    final maps =
        await dbClient.query(TABLE, columns: [ID, NAME, CHAPTER_ID, DATA]);
    List<Photo> employees = [];
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        employees.add(Photo.fromMap(maps[i]));
      }
    }
    return employees;
  }

  Future<Story> getStory(int id) async {
    var dbClient = await db;
    List<Map<String, dynamic>> maps = await dbClient.query(
      TABLE_STORY,
      columns: [ID, CHAPTER_ID, STORY_DATA],
      where: "$CHAPTER_ID = ?",
      whereArgs: [id],
    );
    Story result;
    if (maps.length > 0) {
      var m = maps.first;
      result = Story.fromJson(m['$STORY_DATA']);
    }
    return result;
  }

  Future<void> cleanChapterData(int id) async {
    var dbClient = await db;
    await dbClient.delete(
      TABLE_STORY,
      where: "$CHAPTER_ID = ?",
      whereArgs: [id],
    );
    await dbClient.delete(
      TABLE,
      where: "$CHAPTER_ID = ?",
      whereArgs: [id],
    );
  }

  Future<void> cleanChapterExcept(int id) async {
    var dbClient = await db;
    await dbClient.delete(
      TABLE_STORY,
      where: "$CHAPTER_ID != ? AND $CHAPTER_ID != 0",
      whereArgs: [id],
    );
    await dbClient.delete(
      TABLE,
      where: "$CHAPTER_ID != ? AND $CHAPTER_ID != 0",
      whereArgs: [id],
    );
  }

  Future<void> close() async {
    var dbClient = await db;
    dbClient.close();
  }
}
