abstract class News {
  final String id;
  final String title;
  final String cover;

  News({required this.id, required this.title, required this.cover});
}

class NewsSummary extends News {
  final String summary;

  NewsSummary({required super.id, required super.title, required super.cover, required this.summary});

  factory NewsSummary.fromMap(Map<String, dynamic> map) {
    
  }

  static Future<List<NewsSummary>> fetchNews(List<String> interests) async {
    
  }

  Future<NewsDetailed> getDetailedArticle() async {

  }
}

class NewsDetailed extends News {
  final String content;
  final List<Source> sources;

  NewsDetailed({required super.id, required super.title, required super.cover, required this.content, required this.sources});

  factory NewsSummary.fromMap(Map<String, dynamic> map) {

  }
}

class Source {
  final String? icon;
  final String name;
  final String url;

  Source({required this.icon, required this.name, required this.url});

  factory NewsSummary.fromMap(Map<String, dynamic> map) {

  }
}