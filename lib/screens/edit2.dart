// 강의의 edit.dart

import 'package:flutter/material.dart';
import 'package:flutter_app_memomemo/database/memo.dart';
import 'package:flutter_app_memomemo/database/db.dart';

class EditPage2 extends StatefulWidget {
  EditPage2({Key key, this.id}) : super(key: key);
  final String id;

  @override
  _EditPageState createState() => _EditPageState();
}

class _EditPageState extends State<EditPage2> {
  BuildContext _context; // 외부에서도 쓸수있게 여기에도 BuildContext 선언

  String title = '';  // 변수 선언
  String text = '';
  String createTime = '';

  @override
  Widget build(BuildContext context) {
    _context = context;
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.save),
              onPressed: updateDB,  // updateDB: 덥어쓰기
            )
          ],
        ),
        body: Padding(
            padding: EdgeInsets.all(20),
            child: loadBuilder()
        ));
  }

  Future<List<Memo>> loadMemo(String id) async {  // 데이터 불러온다.
    DBHelper sd = DBHelper();
    return await sd.findMemo(id);
  }

  loadBuilder() {
    return FutureBuilder<List<Memo>>(
      future: loadMemo(widget.id),
      builder: (BuildContext context, AsyncSnapshot<List<Memo>> snapshot) {
        if (snapshot.data == null || snapshot.data == []) {
          return Container(child: Text("데이터를 불러올 수 없습니다."));
        } else {
          Memo memo = snapshot.data[0];

          var tecTitle = TextEditingController();
          // TextEditingController(): edit 할때 기존 텍스트가 나오게 한다.
          // TextField 마다 한개씩 들어가야됨.
          title = memo.title;
          tecTitle.text = title;

          var tecText = TextEditingController();
          text = memo.text;
          tecText.text = text;

          createTime = memo.createTime;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextField(
                controller: tecTitle, // title 을 edit 할때 기존 텍스트 나옴.
                maxLines: 2,
                onChanged: (String title) { // onChanged: 변경사항이 있을 때 실행
                  this.title = title;       // title 에 저장
                },
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.w500),
                //obscureText: true,
                decoration: InputDecoration(
                  //border: OutlineInputBorder(),
                  hintText: '메모의 제목을 적어주세요.',
                ),
              ),
              Padding(padding: EdgeInsets.all(10)),
              TextField(
                controller: tecText, // Text 를 edit 할때 기존 텍스트 나옴.
                maxLines: 8,
                onChanged: (String text) {  // onChanged: 변경사항이 있을 때 실행
                  this.text = text;         // text 에 저장
                },
                //obscureText: true,
                decoration: InputDecoration(
                  //border: OutlineInputBorder(),
                  hintText: '메모의 내용을 적어주세요.',
                ),
              ),
            ],
          );
        }
      },
    );
  }

  void updateDB() {  // 아래 내용의 edit.dart 의 saveDB 내용
    DBHelper sd = DBHelper();

    var fido = Memo(
      id: widget.id ,
      title: this.title,
      text: this.text,
      createTime: this.createTime,
      editTime: DateTime.now().toString(),
    );

    sd.updateMemo(fido);  // db.dart 의 updateMemo

    Navigator.pop(_context);  //  자동으로 나간다.
  }
}


