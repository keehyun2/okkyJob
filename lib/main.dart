import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutterapp/detail_page.dart';
import 'package:flutterapp/todo.dart';
import 'package:http/http.dart' as http;

Future<List<OKKYJob>> fetchOKKYJobs(http.Client client) async {
  final response =
      await client.get('https://no1-node.herokuapp.com/api/job/list');

  // compute 함수를 사용하여 parseOKKYJobs를 별도 isolate에서 수행합니다.
  return compute(parseOKKYJobs, response.body);
}

// 응답 결과를 List<OKKYJob>로 변환하는 함수.
List<OKKYJob> parseOKKYJobs(String responseBody) {
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();

  return parsed.map<OKKYJob>((json) => OKKYJob.fromJson(json)).toList();
}

class OKKYJob {
  final String articleId;
  final String area;
  final String title;
  final String nickname;
  final String timeago;

  OKKYJob({this.articleId, this.area, this.title, this.nickname, this.timeago});

  factory OKKYJob.fromJson(Map<String, dynamic> json) {
    return OKKYJob(
      articleId: json['article_id'] as String,
      area: json['area'] as String,
      title: json['title'] as String,
      nickname: json['nickname'] as String,
      timeago: json['timeago'] as String,
    );
  }
}

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appTitle = 'OKKY.kr 구인 공고(서울)';

    return MaterialApp(
      title: appTitle,
      theme: ThemeData(primarySwatch: Colors.red),
      home: MyHomePage(title: appTitle),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final String title;

  MyHomePage({Key key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title), actions: <Widget>[
        IconButton(
          icon: Icon(Icons.refresh),
          onPressed: () {
            fetchOKKYJobs(http.Client());
          },
        ),
        IconButton(
          icon: Icon(Icons.alarm),
          onPressed: () {
            print(2);
          },
        ),
      ]),
      body: FutureBuilder<List<OKKYJob>>(
        future: fetchOKKYJobs(http.Client()),
        builder: (context, snapshot) {
          if (snapshot.hasError) print(snapshot.error);

          return snapshot.hasData
              ? OKKYJobsList(OKKYJobs: snapshot.data)
              : Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

class OKKYJobsList extends StatelessWidget {
  final List<OKKYJob> OKKYJobs;

  OKKYJobsList({Key key, this.OKKYJobs}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: OKKYJobs.length,
      itemBuilder: (context, index) {
        return ListTile(
          dense: false,
          leading: Container(
              width: 55.0,
              child: Text(OKKYJobs[index].area.replaceAll("서울 ", ""))),
          title: Text(OKKYJobs[index].title),
          subtitle: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                OKKYJobs[index].nickname,
                style: Theme.of(context).textTheme.caption,
              ),
              Text(
                OKKYJobs[index].timeago,
                style: Theme.of(context).textTheme.caption,
              )
            ],
          ),
          onTap: () {
            Todo param = Todo(OKKYJobs[index].articleId, OKKYJobs[index].title);
            Navigator.push(
                context,
                new MaterialPageRoute(
                    builder: (context) => DetailScreen(todo: param)));
          },
        );
      },
    );
  }
}
