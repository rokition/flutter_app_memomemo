// Future Builder 로 쓰인다.
class Memo {                // 5가지 column
  final String id;          // id (String으로 바꿨다.)
  final String title;       // 제목 (String)
  final String text;        // 문서
  final String createTime;  // 생성시간
  final String editTime;    // 수정시간

  Memo ({this.id, this.title, this.text, this.createTime, this.editTime});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'text': text,
      'createTime': createTime,
      'editTime': editTime,
    };
  }

  // 각 memo 정보를 보기 쉽도록 print 문을 사용하여 toString을 구현하세요
 @override
 String toString() {
    return 'Memo{id: $id, title: $title, text: $text, createTime: $createTime, editTime: $editTime}';

 }
}