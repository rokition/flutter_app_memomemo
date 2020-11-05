import 'package:flutter/material.dart';
import 'package:flutter_app_memomemo/screens/home.dart';  // MyHomePage 함수가 들어 있어서 연결됨.

void main() => runApp(MyApp());  // 변경


class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        
        primarySwatch: Colors.blue, primaryColor: Colors.white,),
        // 기본색깔 ( 버튼색깔: 오랜지,  배경색깔: 흰색 )

      home: MyHomePage(title: 'Flutter Demo Home Page'),
      //  MyHomePage는 import 'package:flutter_app_memomemo/screens/home.dart'; 안에 있다.
    );
  }
}
