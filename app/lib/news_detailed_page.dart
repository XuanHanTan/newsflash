import 'package:flutter/material.dart';
import '/api/news_api.dart';

class NewsDetailedPage extends StatefulWidget {
  final NewsSummary news;

  NewsDetailedPage({required this.news});

  @override
  _NewsDetailedPageState createState() => _NewsDetailedPageState();
}

class _NewsDetailedPageState extends State<NewsDetailedPage> {
  late Future<NewsDetailed> detailedNews;

  @override
  void initState() {
    super.initState();
    detailedNews = widget.news.getDetailedArticle();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.news.title),
      ),
      body: FutureBuilder<NewsDetailed>(
        future: detailedNews,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return Center(child: Text('No detailed data available.'));
          }

          final detailed = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Image.network(detailed.cover, height: 200, fit: BoxFit.cover),
                SizedBox(height: 16),
                Text(
                  detailed.title,
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16),
                Text(
                  detailed.content,
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 16),
                Text(
                  'Sources:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                ...detailed.sources.map((source) => ListTile(
                      leading: source.icon != null
                          ? Image.network(source.icon!)
                          : null,
                      title: Text(source.name),
                      subtitle: Text(source.url),
                      onTap: () {
                        // Open the source URL
                      },
                    )),
              ],
            ),
          );
        },
      ),
    );
  }
}
