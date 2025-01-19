import 'package:app/bloc/news_bloc.dart';
import 'package:app/bloc/news_event.dart';
import 'package:app/bloc/news_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class ContentPage extends StatelessWidget {
  const ContentPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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

          return ListView(
            children: [
              SizedBox(
                height: 300,
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Image.memory(
                        currentOpenNews.cover,
                        height: 300,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      top: 20,
                      right: 20,
                      child: IconButton.filledTonal(
                        onPressed: () {
                          final newsBloc = context.read<NewsBloc>();
                          newsBloc.add(CloseNewsEvent());
                          Navigator.pop(context);
                        },
                        icon: Icon(Icons.close_outlined),
                      ),
                    ),
                  ],
                ),
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
                    MarkdownBody(
                      data: currentOpenNews.content,
                      shrinkWrap: true,
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
