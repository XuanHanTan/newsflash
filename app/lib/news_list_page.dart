import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'news_detailed_page.dart';
import '/api/news_api.dart';

class NewsListPage extends StatefulWidget {
  @override
  _NewsListPageState createState() => _NewsListPageState();
}

class _NewsListPageState extends State<NewsListPage> {
  late Future<List<NewsSummary>> futureNews;

  @override
  void initState() {
    super.initState();
    futureNews = NewsSummary.fetchNews(['technology', 'sports']);
    printNews();
  }

  void printNews() async {
    final news = await futureNews;
    print(news);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('News'),
      ),
      body: FutureBuilder<List<NewsSummary>>(
        future: futureNews,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No news available.'));
          }

          final newsSummaries = snapshot.data!;
          return CardSwiper(
            cardsCount: newsSummaries.length,
            cardBuilder: (context, index, horizontalOffsetPercentage,
                verticalOffsetPercentage) {
              final news = newsSummaries[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NewsDetailedPage(news: news),
                    ),
                  );
                },
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.network(
                        news.cover,
                        fit: BoxFit.cover,
                      ),
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            news.title,
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              shadows: [
                                Shadow(
                                  blurRadius: 6,
                                  color: Colors.black54,
                                  offset: Offset(2, 2),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
            numberOfCardsDisplayed: 3, // Adjust for desired effect
            isLoop: true,
            onEnd: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('You have reached the end!')),
              );
            },
          );
        },
      ),
    );
  }
}
