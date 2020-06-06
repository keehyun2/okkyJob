import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

import 'detail.dart';
import 'todo.dart';

Future<Detail> fetchDetail(http.Client client, String articleId) async {
  print(articleId);
  final response =
      await client.get('https://no1-node.herokuapp.com/api/job/' + articleId);

  // compute 함수를 사용하여 parseOKKYJobs를 별도 isolate에서 수행합니다.
  return compute(parseDetail, response.body);
}

// 응답 결과를 List<OKKYJob>로 변환하는 함수.
Detail parseDetail(String responseBody) {
  final parsedJson = json.decode(responseBody);
//  print('${parsedJson.runtimeType} : $parsedJson');

  return Detail.fromJson(parsedJson);
}

class DetailScreen extends StatelessWidget {
  // Todo를 들고 있을 필드를 선언합니다.
  final Todo todo;

  // 생성자는 Todo를 인자로 받습니다.
  DetailScreen({Key key, @required this.todo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // UI를 그리기 위해 Todo를 사용합니다.
    return Scaffold(
      appBar: AppBar(
        title: Text(todo.title),
      ),
      body: FutureBuilder<Detail>(
        future: fetchDetail(http.Client(), todo.articleId),
        builder: (context, snapshot) {
          if (snapshot.hasError) print(snapshot.error);

          return snapshot.hasData
              ? SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Linkify(
                        onOpen: (link) async {
                          if (await canLaunch(link.url)) {
                            await launch(link.url);
                          } else {
                            throw 'Could not launch $link';
                          }
                        },
                        style: TextStyle(color: Colors.black),
                        linkStyle: TextStyle(color: Colors.blue),
                        text: snapshot.data.text),
                  ),
                )
              : Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
