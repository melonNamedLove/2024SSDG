import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class Databasehelper{
  //싱글톤 패턴을 사용하여 단일 인스턴스를 유지

  static final Databasehelper _instance = Databasehelper._internal();

  factory Databasehelper() => _instance;

  Databasehelper._internal();

  Database? _database;

  //데이터베이스를 초기화하거나 이미 초기화된 데이터베이스를 반환

  Future<Database> get database async{
    if(_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  //데이터베이스 초기화 함수
  Future<Database> _initDatabase() async{
  //데이터베이스 파일의 경로를 가져옴
  final databasePath = await getDatabasesPath();
  final path = join(databasePath, 'messages.db');

  //데이터베이스를 열거나 생성
  return await openDatabase(
    path,
    version: 1,
    onCreate: _onCreate,
  );

  }

  //데이터베이스를 처음 생성할 때 호출되는 함수
  Future _onCreate(Database db, int version) async{
    await db.execute(
      '''
      CREATE TABLE messages(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        message TEXT
      )

      '''
    );
  }


  //메세지를 데이터베이스에 삽입하는 함수
Future<void> insertMessage(String message) async{
  final db = await database;
  await db.insert(
    'messages', 
    {
      'message': message,
    },
    conflictAlgorithm: ConflictAlgorithm.replace,
  );

}
  // 데이터베이스에서 모든 메시지를 가져오는 함수
  Future<List<Map<String, dynamic>>> fetchMessages() async {
    final db = await database;
    return await db.query('messages');
  }

}