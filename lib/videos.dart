import 'package:flutter/material.dart';
import 'package:story_view/story_view.dart';
import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<List<Video>> fetchPhotos(http.Client client) async {
  final response = await client.get(
      'http://83.33.234.183/msa/ads/1/1.mp4?token=12345678987654323456543453453452');

  // Use the compute function to run parsePhotos in a separate isolate.
  return compute(parseVideos, response.body);
}

List<Video> parseVideos(String responseBody) {
  final parsed = jsonDecode(responseBody);

  return (parsed as List).map((p) => Video.fromJson(p)).toList();
}



class Video {
  final String url;

  Video({this.url});

  factory Video.fromJson(Map<String, dynamic> json) {
    return Video(
      url: json['url'] as String,
    );
  }
}


class VideoApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.green,
        ),
        home: MoreStories());
  }
}

class MoreStories extends StatefulWidget {
  @override
  _MoreStoriesState createState() => _MoreStoriesState();
}

class _MoreStoriesState extends State<MoreStories> {
  var _result;
  final storyController = StoryController();
  List<StoryItem> f;

  @override
  void dispose() {
    storyController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    fetchPhotos(http.Client()).then((result) {
      List<StoryItem> ls = new List<StoryItem>();
      print(result.length);
      for (var i = 0; i < result.length; i++) {

        print(result.elementAt(i).url);
        StoryItem a = StoryItem.pageVideo(
          (result.elementAt(i).url),
          controller: storyController,
          duration: Duration(seconds: 20),
        );
        ls.add(a);
      }
      f=ls;
      setState(() {
        _result = result;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_result == null) {
      return new Container();
    }
    return Scaffold(
      body: StoryView(
        f,
        onStoryShow: (s) {
          print("mostrando una historia");
        },
        onComplete: () {
          print("se ha completado un ciclo");
        },
        progressPosition: ProgressPosition.bottom,
        repeat: true,
        controller: storyController,
      ),
    );
  }
}
