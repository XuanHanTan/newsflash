import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

abstract class News {
  final String id;
  final String title;
  final Uint8List? cover;
  final int readTime;

  static const url = 'https://backend-v1-175242879314.us-central1.run.app/news';

  News(
      {required this.id,
      required this.title,
      required this.cover,
      required this.readTime});
}

class NewsSummary extends News {
  final String summary;

  NewsSummary(
      {required super.id,
      required super.title,
      required super.cover,
      required super.readTime,
      required this.summary});

  factory NewsSummary.fromMap(Map<String, dynamic> map) {
    return NewsSummary(
      id: map['id'],
      readTime: (map['readTime'] / 60).toInt(),
      title: map['title'],
      cover: map['cover'] != null ? base64Decode(map['cover']): null,
      summary: map['summary'],
    );
  }

  static Future<List<NewsSummary>> fetchNews(
      {required Set<String> interests,
      required DateTime time,
      required String? region}) async {
    // TODO: test
    /*final newsList = [
      {
        'id': '1',
        'title': 'Sample News',
        'cover': 'https://picsum.photos/200/300',
        'summary':
            'This is a sample summary of the news article. It contains some important information about the topic.',
        'readTime': 5,
      },
      {
        'id': '2',
        'title': 'Sample News 2',
        'cover': 'https://picsum.photos/200/300',
        'summary':
            'This is a sample summary of the news article. It contains some important information about the topic.',
        'readTime': 5,
      }
    ];
    return newsList.map((e) => NewsSummary.fromMap(e)).toList();*/
    var url =
        '${News.url}?interests=${interests.join(',')}&time_frame=${DateFormat("yyyy-MM-dd").format(time)}';
    if (region != null) {
      url += "&region=$region";
    }
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);

      final List<dynamic> newsList = data['news'];
      return newsList.map((e) => NewsSummary.fromMap(e)).toList();
    } else {
      throw Exception('Failed to load news');
    }
  }

  Future<NewsDetailed> getDetailedArticle() async {
    /*final detailedNews = {
      'id': '1',
      'title': 'Sample News',
      'cover': 'https://picsum.photos/200/300',
      'content':
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
      'sources': [],
      'readTime': 5,
    };
    return NewsDetailed.fromMap(detailedNews);*/

    // TODO: test
    final response = await http.get(Uri.parse('${News.url}/$id'));

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
  // final List<Source> sources;

  NewsDetailed({
    required super.id,
    required super.title,
    required super.cover,
    required super.readTime,
    required this.content,
    /*required this.sources*/
  });

  factory NewsDetailed.fromMap(Map<String, dynamic> map) {
    return NewsDetailed(
      id: map['id'],
      readTime: (map['readTime'] / 60).toInt(),
      title: map['title'],
      cover: map['cover'] != null ? base64Decode(map['cover']): null,
      content: map['content'],
      // sources: map['sources'].map<Source>((e) => Source.fromMap(e)).toList(),
    );
  }
}

/*class Source {
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
}*/
