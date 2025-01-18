import 'dart:math';
import 'dart:ui';

import 'package:app/bloc/news_bloc.dart';
import 'package:app/bloc/news_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:intl/intl.dart';

import '../bloc/news_state.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();

    final newsBloc = context.read<NewsBloc>();
    newsBloc.add(FetchNewsEvent());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mediaQueryData = MediaQuery.of(context);
    final screenWidth = mediaQueryData.size.width;
    final screenHeight = mediaQueryData.size.height;

    return BlocProvider.value(
      value: context.read<NewsBloc>(),
      child: Scaffold(
        appBar: AppBar(
          title: Text("Feed"),
          actions: [
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.settings_outlined),
            ),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: BlocBuilder<NewsBloc, NewsState>(
                buildWhen: (previous, current) =>
                    previous.news != current.news ||
                    previous.skipped != current.skipped,
                builder: (context, state) {
                  final filteredNews = state.news
                      .where((item) => state.skipped[item.id] != true)
                      .toList();

                  if (filteredNews.isEmpty) {
                    return Center(
                      child: Text("It's looking empty here..."),
                    );
                  }

                  return CardSwiper(
                    numberOfCardsDisplayed: min(filteredNews.length, 5),
                    padding: EdgeInsets.zero,
                    cardsCount: filteredNews.length,
                    cardBuilder: (context, index, horizontalOffsetPercentage,
                        verticalOffsetPercentage) {
                      final news = filteredNews[index];

                      return Center(
                        child: SizedBox(
                          height: screenHeight * 0.6,
                          width: screenWidth * 0.85,
                          child: Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Stack(
                                children: [
                                  Positioned.fill(
                                    child: Image.network(news.cover,
                                        fit: BoxFit.cover),
                                  ),
                                  Positioned(
                                    bottom: 0,
                                    left: 0,
                                    right: 0,
                                    child: ClipRect(
                                      child: BackdropFilter(
                                        filter: ImageFilter.blur(
                                            sigmaX: 70.0, sigmaY: 70.0),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: const Color.fromARGB(
                                                    255, 105, 101, 89)
                                                .withValues(alpha: 0.5),
                                          ),
                                          padding: EdgeInsets.all(20),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            spacing: 10,
                                            children: [
                                              Text(
                                                "${news.readTime} MIN READ",
                                                style: theme
                                                    .textTheme.labelSmall!
                                                    .copyWith(
                                                        color: Colors.white),
                                              ),
                                              Text(
                                                news.title,
                                                style: theme
                                                    .textTheme.headlineMedium!
                                                    .copyWith(
                                                        color: Colors.white),
                                              ),
                                              Text(
                                                news.summary,
                                                style: theme
                                                    .textTheme.bodyMedium!
                                                    .copyWith(
                                                        color: Colors.white),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                    onSwipe: (previousIndex, currentIndex, direction) {
                      final news = filteredNews[previousIndex];
                      final newsBloc = context.read<NewsBloc>();
                      newsBloc.add(SkipNewsEvent(id: news.id));

                      if (previousIndex <= state.news.length - 3) {
                        newsBloc.add(FetchNewsEvent());
                      }
                      return true;
                    },
                  );
                },
              ),
            ),
            BlocBuilder<NewsBloc, NewsState>(
              buildWhen: (previous, current) =>
                  previous.settings.time != current.settings.time,
              builder: (context, state) {
                final time = state.settings.time;

                return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Slider(
                          value: min(7 + time.difference(DateTime.now()).inDays,
                                  7) /
                              7,
                          onChanged: (daysBefore) {
                            return context.read<NewsBloc>().add(SetNewsSettings(
                                  time: DateTime.now().subtract(Duration(
                                      days: min((daysBefore * 7).toInt() - 7, 0)
                                          .abs())),
                                ));
                          },
                        ),
                        Text(
                          DateFormat("d MMM yyyy").format(time).toUpperCase(),
                          style: theme.textTheme.labelLarge!.copyWith(letterSpacing: 1),
                        ),
                      ],
                    ));
              },
            ),
            SizedBox(
              height: 50,
            ),
          ],
        ),
      ),
    );
  }
}
