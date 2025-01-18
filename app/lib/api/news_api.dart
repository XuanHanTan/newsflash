import 'dart:convert';
import 'package:http/http.dart' as http;

abstract class News {
  final String id;
  final String title;
  final String cover;
  final DateTime time;

  static const URL = 'http://127.0.0.1:5000/news';

  News(
      {required this.id,
      required this.title,
      required this.cover,
      required this.time});
}

class NewsSummary extends News {
  final String summary;

  NewsSummary(
      {required super.id,
      required super.title,
      required super.cover,
      required super.time,
      required this.summary});

  factory NewsSummary.fromMap(Map<String, dynamic> map) {
    return NewsSummary(
      id: map['id'],
      time: DateTime.fromMillisecondsSinceEpoch(map['time']),
      title: map['title'],
      cover: map['cover'],
      summary: map['summary'],
    );
  }

  static Future<List<NewsSummary>> fetchNews(List<String> interests) async {
    final response = await http
        .get(Uri.parse('${News.URL}?interests=${interests.join(',')}'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);

      final List<dynamic> newsList = data['news'];
      return newsList.map((e) => NewsSummary.fromMap(e)).toList();
    } else {
      throw Exception('Failed to load news');
    }
  }

  Future<NewsDetailed> getDetailedArticle() async {
    final response = await http.get(Uri.parse('${News.URL}/$id'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> detailedNews = json.decode(response.body);
      return NewsDetailed.fromMap(detailedNews);
    } else {
      throw Exception('Failed to load detailed news');
    }
  }
}

class NewsDetailed extends News {
  final String content;
  final List<Source> sources;

  NewsDetailed(
      {required super.id,
      required super.title,
      required super.cover,
      required super.time,
      required this.content,
      required this.sources});

  factory NewsDetailed.fromMap(Map<String, dynamic> map) {
    return NewsDetailed(
      id: map['id'],
      time: DateTime.fromMillisecondsSinceEpoch(map['time']),
      title: map['title'],
      cover: map['cover'],
      content: map['content'],
      sources: map['sources'].map<Source>((e) => Source.fromMap(e)).toList(),
    );
  }
}

class Source {
  final String? icon;
  final String name;
  final String url;

  Source({required this.icon, required this.name, required this.url});

  factory Source.fromMap(Map<String, dynamic> map) {
    return Source(
      icon: map['icon'],
      name: map['name'],
      url: map['url'],
    );
  }
}
