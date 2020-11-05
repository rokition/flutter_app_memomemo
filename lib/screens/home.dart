// 이 페이지는 프로젝트 만들면 나오는 main.dart 부분에서 class MyHomePage 부분을
// 잘라 와서 붙인 것이다.
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_memomemo/database/memo.dart';
import 'package:flutter_app_memomemo/screens/edit.dart'; // Editpage 가 있는곳
import 'package:flutter_app_memomemo/database/db.dart';
import 'package:flutter_app_memomemo/screens/view.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
// context 경로 :  Widget build(BuildContext context) -> Expanded(child: memobuilder(context)) ->
// void showAlertDialog(BuildContext context) -> Widget memobuilder(BuildContext parentContext) ->
//  return InkWell(...  showAlertDialog(parentContext);
  String deleteId = ''; // 전역변수,  void showAlertDialog 에서 삭제 기능 할수 있게
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //  AppBar 삭제 됨.

      body: Column(
        children: [
          Padding(
            //  제목 만듬
            padding: EdgeInsets.only(left: 20, top: 40, bottom: 20), // 간격
            child: Container(
              child: Text(
                '메모메모',
                style: TextStyle(fontSize: 36, color: Colors.blue),
              ),
              alignment: Alignment.centerLeft,
            ), // container  중앙 윈쪽 배치
          ),
          Expanded(child: memobuilder(context))  // Expanded: 나머지 범위 확장해서 쓴다.
          // Widget memobuilder()  들어감.
        ], // memobuilder 우클릭 -> go to -> declaration or userges
        // 하면 아래  Widget memobuilder() {} 가 생긴다.
      ),

      floatingActionButton: FloatingActionButton.extended(
        // .extended: 확장 기능 (label 가능)
        onPressed: () {
          Navigator.push(
            context,
            CupertinoPageRoute(builder: (context) => Editpage()),
          ).then((value) {
            setState(() {});
          });
          // .then((value) {setState(() {});}); --> 변경된 부분 반영함. 메모저장 것을 리스트에 표시한다.
          // ** 라우팅 할때 필수 부분 ** ( Editpage(edit.dart) 로 라우팅 함 )
          // context: 위에 Widget build(BuildContext context) 에서 받아옴.
          // context: 특정 위젯이 빌드되는 컨텍스트 이다. (부모와 상호작용함.)
          // Navigator: 터치했을때 페이지 이동하게 해준다. (.push: 페이지 위로 올라옴)
          // CupertinoPageRoute: 라우팅 방법중 하나
          //  Editpage() : edit.dart 에서 작성한다. (class Editpage)
        },
        tooltip: '메모를 추가하려면 메모 추가 버튼을 누르세요',
        label: Text('메모 추가'), // 아이콘에 글자 들어감.
        icon: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  // List<Widget> LoadMemo() {} 삭제 함.

  Future<List<Memo>> loadMemo() async {  //  Memo 를 불러오는 function. (꼭 필요함.)
    // 미래( future)에 응답(async)을 받는다.
    // Memo는 memo.dart 의 class Memo
    DBHelper sd = DBHelper(); // db.dart 의 DBhelper 호출
    return await sd.memos(); // db.dart 의 memos() function 을 써서 데이터를 불러온다.
    // 같은 형태여야 하기 때문에 await 붙인다.
  }

  Future<void> deleteMemo(String id) async {
    //  memo 를 삭제하는 function. db.dart와 이름이 같다.
    //첫행 db.dart의 deletMemo 그대로 복사함.
    DBHelper sd = DBHelper();
    await sd.deleteMemo(id); //  db.dart의 deletMemo 실행, 삭제라서 return 할수 있는게 없다. id 만 넣는다.
  }

  void showAlertDialog(BuildContext context) async {
    // 삭제 경고창 띄우는 함수
    await showDialog(  // String result = 삭제함
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('삭제 경보'),
          content: Text("정말 삭제하시겠습니까?\n삭제된 메모는 복구되지 않습니다."),
          actions: <Widget>[
            FlatButton(
              child: Text('삭제'),
              onPressed: () {
                Navigator.pop(context, "삭제"); // pop 이벤트 전달
                //  Navigator.pop: 새로운 화면으로부터 이전 화면으로 데이터를 반환
                //  작은 창을 띄우고 선택 하게 함.
                setState(() {
                  // 새로고침
                  deleteMemo(deleteId); // 길게 누르면 삭제 된다. (deleteMemo 실행)
                });
                deleteId =
                    ''; // showAlertDialog(parentContext); 가 비동기화 함수이기 때문에 여기에 쓴다.
              },
            ),
            FlatButton(
              child: Text('취소'),
              onPressed: () {
                deleteId = '';
                Navigator.pop(context, "취소");
              },
            ),
          ],
        );
      },
    );
  }

  // 여기 아래부분 widget은 검색한거 복사 해서 붙임
  // FutureBuilder 가 돌면서 future로 부터 가져온 데이터 를 ( future: loadMemo() )
  // Snap 을 통해서 전달하게 하는 구조로 되어 있다.
  Widget memobuilder(BuildContext parentContext) {
    //  memobuilder 로 이름 바꿈
    // context를 위에서 받아옴.
    return FutureBuilder(
      //   FutureBuilder 가 돌면서
      builder: (context, Snap) {
        // Snap을 따서 가져간다.
        if (Snap.data == null || Snap.data.isEmpty) {  // &&:and , ||:or
          // Snap.data == null ||  추가
          // 만약 Snap에 데이터가 없다면 (list에 데이터가 없다면)
          // list에 저장한 값이 하나도 없다는 뜻.
          //print('project snapshot data is: ${projectSnap.data}');
          return Container(
            alignment: Alignment.center, // Container 중앙 배치
            child: Text(
                '지금 바로 "메모 추가" 버튼을\n 눌러 메모를 추가해 보세요!\n\n\n\n\n\n\n', // \n: 줄바꿈
                style: TextStyle(fontSize: 15, color: Colors.blueAccent),
                textAlign: TextAlign.center //  텍스트 중앙 배치

                ),
          );
          //  \n: " "  안에서 엔터 효과 (줄바꿈),  글자가 약간 위로 올라오게 했다.
        }
        // 만약 Snap에 데이터가 있다면 아래가 실행
        return ListView.builder(
          // 메모 데이터를 리스트 형식으로 만듬
          physics: BouncingScrollPhysics(), // 리스트 뜅김효과
          padding: EdgeInsets.all(15), // 리스트 안쪽 모든 간격 ( 리스트와 컨테이너 사이 간격 )
          itemCount: Snap.data.length,
          itemBuilder: (context, index) {
            // 데이터가 들어오면 index를 통해 나열
            Memo memo = Snap.data[index]; // Memo(class) 로 이름 바꿈,
            // index에 있는 것을 memo(variable) 로 보낸다.
            return InkWell(
                // InkWell 안에 Container 넣으면 꾸밀수 있다 애니메이션 가능
                onTap: () {
                  // 터치 하면 되는 기능
                  Navigator.push(
                      parentContext,
                      CupertinoPageRoute(
                          builder: (context) => ViewPage(id: memo.id))).then((value) {
                    setState(() {});
                    // .then((value) {setState(() {});}) --> 이것을 Navigator.push() 뒤쪽에 붙이면 home 화면이 자동 새로고침.
                  });
                }, // view.dart 의 Viewpage class 로 페이지 이동 (id 변수에 memo.id 담아서 전달)
                onLongPress: () {
                  // 길게 누르면 되는 기능
                  deleteId = memo.id; // memo.Id를 deleteId 에 저장.
                  showAlertDialog(
                      parentContext); // 함수 호출 (삭제 경고), 비동기화 함수 (async)
                },
                // on... 기타 등등 기능이 있다.
                child: Container(
                  // 컨테이너를  BoxDecoration 으로 꾸민다.
                  margin: EdgeInsets.all(5), // 컨테이너 바깥쪽 모든 간격
                  padding: EdgeInsets.all(15), // 컨테이너 안쪽 내용 모든 간격
                  alignment: Alignment.center, // 컨테이너 중앙
                  height: 100, // 컨네이너 높이
                  child: Column(
                    mainAxisAlignment:
                        MainAxisAlignment.center, // (Column) 위,아래 기준 중앙
                    crossAxisAlignment: CrossAxisAlignment
                        .stretch, // (Column) 좌우 기준 늘어남 (text 왼쪽에 붙음).
                    children: [
                      Column(
                          mainAxisAlignment:
                              MainAxisAlignment.center, // (Column) 위,아래 기준 중앙
                          crossAxisAlignment: CrossAxisAlignment
                              .stretch, // (Column) 좌우 기준 늘어남 (text 왼쪽에 붙음).
                          children: [
                            Text(
                              memo.title,
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w500),
                              overflow: TextOverflow.ellipsis,  // 오버플로우 대처방법 (ellipsis: '...' 표시)
                            ),
                            Text(
                              memo.text,
                              style: TextStyle(fontSize: 15),
                              overflow: TextOverflow.ellipsis,  // 오버플로우 대처방법 (ellipsis: '...' 표시)
                            ),
                          ]),
                      Column(
                        mainAxisAlignment:
                            MainAxisAlignment.center, // (Column) 위,아래 기준 아래쪽
                        crossAxisAlignment:
                            CrossAxisAlignment.stretch, // (Column) 좌우 기준 늘어남.
                        // 여기서는 아래에 TextAlign.end 을 넣어서 text 가 오른쪽에 붙게 함.
                        children: [
                          Text(
                            "최종 수정 시간: " + memo.editTime.split('.')[0],
                            style: TextStyle(fontSize: 11),
                            textAlign: TextAlign.end,
                          )
                          // memo.editTime.split('.')[0] -> . '.' 기준으로 나눠서 첫번째만 표시
                          // 2020-10-20 12:42:07.188209 에서 앞에 2020-10-20 12:42:07 이것만 표시
                        ],
                      )
                    ],
                  ),
                  // Container 꾸민다.
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(230, 230, 230, 1),
                    border: Border.all(
                      color: Colors.blue,
                      width: 1,
                    ),
                    // 배경색 Colors.white70 (숫자는 투명도), 테두리 편집
                    // fromRGBO(230,230, 230, 1): 1은 투명도
                    boxShadow: [
                      BoxShadow(color: Colors.lightBlue, blurRadius: 4)
                    ],
                    // 박스 그림자 효과, blurRadius: 4 -> 그림자 반경
                    borderRadius: BorderRadius.circular(12), // 모서리 둥근 정도
                  ),
                ));
          },
        );
      },
      future: loadMemo(), // loadMemo 로 바꿈
    );
  }
}
