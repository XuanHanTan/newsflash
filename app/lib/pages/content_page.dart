import 'package:app/bloc/news_bloc.dart';
import 'package:app/bloc/news_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ContentPage extends StatelessWidget {
  const ContentPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mediaQueryData = MediaQuery.of(context);

    return Scaffold(
      body: BlocBuilder<NewsBloc, NewsState>(
        buildWhen: (previous, current) =>
            previous.currentOpenNews != current.currentOpenNews,
        builder: (context, state) {
          final currentOpenNews = state.currentOpenNews;

          if (currentOpenNews == null) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          return Stack(
            children: [
              ListView(
                children: [
                  Image.network(
                    currentOpenNews.cover,
                    height: 300,
                    fit: BoxFit.cover,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        Hero(
                          tag: "readtime-${currentOpenNews.id}",
                          child: Text(
                            "${currentOpenNews.readTime} MIN READ",
                            style: theme.textTheme.labelSmall,
                          ),
                        ),
                        const SizedBox(
                          height: 6,
                        ),
                        Hero(
                          tag: "headline-${currentOpenNews.id}",
                          child: Text(
                            currentOpenNews.title,
                            style: theme.textTheme.headlineLarge,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(currentOpenNews.content),
                      ],
                    ),
                  ),
                ],
              ),
              Positioned(
                top: mediaQueryData.padding.top + 20,
                right: 20,
                child: IconButton.filledTonal(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.close_outlined),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
