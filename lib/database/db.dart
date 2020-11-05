import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter_app_memomemo/database/memo.dart'; // import 경로 최상위 폴더는 프로젝트 명.

// pubspec.yaml 에
// 아래 부분에서
//dependencies:
//flutter:
//sdk: flutter
// 여기 밑에 부분 추가 시켜야함.
//sqflite: ^1.1.6
//path_provider: ^1.2.0
//path: ^1.6.2
// 다 적고 나서 여기서 위쪽 노란줄에 get denpendencise, upgrade dependencies  클릭
//
final String TableName = 'memos'; // 테이블 이름

class DBHelper {
  var _db;
  // 데이터를 요청 할때마다 _db 돌린다.
  Future<Database> get database async {
    // Future: 결과값을 나중에 받기로 약속 (비동기 처리)
    // async 와 await는 한 쌍,  함수명() async{ await 작업함수(); }
    // await는 비동기(async) 함수 내에서만 사용할 수 있는 키워드.
    // await가 붙은 작업은 해당작업이 끝날 때까지 다음 작업으로 안 넘어가고 기다린다.

    if (_db != null) return _db;
    _db = openDatabase(
      // 데이터베이스 경로를 지정합니다. 참고: `path` 패키지의 `join` 함수를 사용하는 것이
      // 각 플랫폼 별로 경로가 제대로 생성됐는지 보장할 수 있는 가장 좋은 방법입니다.
      join(await getDatabasesPath(), 'memos.db'),
      // 데이터베이스가 처음 생성될 때, dog를 저장하기 위한 테이블을 생성합니다.
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE memos(id TEXT PRIMARY KEY, title TEXT, text TEXT, createTime TEXT, editTime TEXT)",
        ); // id 뒤에 TEXT 로 바꿈.
      },
      // 버전을 설정하세요. onCreate 함수에서 수행되며 데이터베이스 업그레이드와 다운그레이드를
      // 수행하기 위한 경로를 제공합니다.
      version: 1,
    );
    return _db;
  }

  Future<void> insertMemo(Memo memo) async {
    final db = await database;
    // Memo를 올바른 테이블에 추가하세요. 또한
    // `conflictAlgorithm`을 명시할 것입니다. 본 예제에서는
    // 만약 동일한 memo가 여러번 추가되면, 이전 데이터를 덮어쓸 것입니다.
    await db.insert(
      TableName,
      memo.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Memo>> memos() async {
    // Memo는 memo.dart 의 class Memo
    final db = await database;

    // 모든 Memo를 얻기 위해 테이블에 질의합니다.
    final List<Map<String, dynamic>> maps = await db.query('memos');

    // List<Map<String, dynamic>를 List<Memo>으로 변환합니다.
    return List.generate(maps.length, (i) {
      return Memo(
        id: maps[i]['id'],
        title: maps[i]['title'],
        text: maps[i]['text'],
        createTime: maps[i]['createTime'],
        editTime: maps[i]['editTime'],
      );
    });
  }

  Future<void> updateMemo(Memo memo) async {
    final db = await database;

    // 주어진 Memo를 수정합니다.
    await db.update(
      TableName,
      memo.toMap(),
      // Memo의 id가 일치하는 지 확인합니다.
      where: "id = ?",
      // Memo의 id를 whereArg로 넘겨 SQL injection을 방지합니다.
      whereArgs: [memo.id],
    );
  }

  Future<void> deleteMemo(String id) async {
    final db = await database;

    // 데이터베이스에서 Memo를 삭제합니다.
    await db.delete(
      TableName,
      // 특정 memo를 제거하기 위해 `where` 절을 사용하세요
      where: 'id = ?',
      // Memo의 id를 where의 인자로 넘겨 SQL injection을 방지합니다.
      whereArgs: [id],
    );
  }

  // memos 와 같은데 다른점은 id를 받는다. 특정 id 받기 위함.
  Future<List<Memo>> findMemo(String id) async {
    // Memo는 memo.dart 의 class Memo
    final db = await database;

    // 모든 Memo를 얻기 위해 테이블에 질의합니다.
    final List<Map<String, dynamic>> maps =
        await db.query('memos', where: 'id = ? ', whereArgs: [id]);
    // where 는 조건이다.  [id] : list
    // where: 'id=? ', whereArgs: [id] -> ('id' column 이 [id] 와 동일 해야 된다.)

    // List<Map<String, dynamic>를 List<Memo>으로 변환합니다.
    return List.generate(maps.length, (i) {
      return Memo(
        id: maps[i]['id'],
        title: maps[i]['title'],
        text: maps[i]['text'],
        createTime: maps[i]['createTime'],
        editTime: maps[i]['editTime'],
      );
    });
  }
}
