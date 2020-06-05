import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<List<okkyJob>> fetchokkyJobs(http.Client client) async {
  final response =
      await client.get('https://no1-node.herokuapp.com/api/job/list');

  // compute 함수를 사용하여 parseokkyJobs를 별도 isolate에서 수행합니다.
  return compute(parseokkyJobs, response.body);
}

// 응답 결과를 List<okkyJob>로 변환하는 함수.
List<okkyJob> parseokkyJobs(String responseBody) {
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();

  return parsed.map<okkyJob>((json) => okkyJob.fromJson(json)).toList();
}

class okkyJob {
  final String articleId;
  final String area;
  final String title;
  final String nickname;
  final String timeago;

  okkyJob({this.articleId, this.area, this.title, this.nickname, this.timeago});

  factory okkyJob.fromJson(Map<String, dynamic> json) {
    return okkyJob(
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
    final appTitle = 'okky.kr 구인 공고';

    return MaterialApp(
      title: appTitle,
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
      appBar: AppBar(
        title: Text(title),
      ),
      body: FutureBuilder<List<okkyJob>>(
        future: fetchokkyJobs(http.Client()),
        builder: (context, snapshot) {
          if (snapshot.hasError) print(snapshot.error);

          return snapshot.hasData
              ? okkyJobsList(okkyJobs: snapshot.data)
              : Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

class okkyJobsList extends StatelessWidget {
  final List<okkyJob> okkyJobs;

  okkyJobsList({Key key, this.okkyJobs}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: okkyJobs.length,
      itemBuilder: (context, index) {
//        return Image.network(okkyJobs[index].thumbnailUrl);
        return ListTile(
          dense: false,
          leading: Hero(
            child: Text(okkyJobs[index].articleId),
            tag: "zxc",
          ),
          title: Text(okkyJobs[index].title),
          subtitle: Text(
            okkyJobs[index].area,
            style: Theme.of(context).textTheme.caption,
          ),
          onTap: () {
            print(okkyJobs[index].articleId);

//            var response = http.Client().get("https://okky.kr/recruit/721063");

//            songData.setCurrentIndex(index);
//            Navigator.push(
//                context,
//                new MaterialPageRoute(
//                    builder: (context) => new NowPlaying(songData, s)));
          },
        );
      },
    );
  }
}
