import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:app/bloc/news_bloc.dart';
import 'package:app/bloc/news_event.dart';
import 'package:app/pages/content_page.dart';
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
  Timer? delayTimer;

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
                    previous.skipped != current.skipped ||
                    previous.isLoading != current.isLoading,
                builder: (context, state) {
                  final filteredNews = state.news
                      .where((item) => state.skipped[item.id] != true)
                      .toList();

                  if (state.isLoading) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (filteredNews.isEmpty) {
                    return Center(
                      child: Text(
                        "It's looking empty here...",
                        style: theme.textTheme.bodyMedium!
                            .copyWith(fontFamily: "Golos Text"),
                      ),
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
                          height: screenHeight * 0.7,
                          width: screenWidth * 0.9,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(20),
                            onTap: () {
                              final newsBloc = context.read<NewsBloc>();
                              newsBloc.add(OpenNewsEvent(id: news.id));
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ContentPage()),
                              );
                            },
                            child: Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Stack(
                                  children: [
                                    if (news.cover != null)
                                      Positioned.fill(
                                        child: Image.memory(
                                          news.cover!,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    Positioned(
                                      bottom: 0,
                                      left: 0,
                                      right: 0,
                                      top: news.cover != null ? null : 0,
                                      child: ClipRect(
                                        child: BackdropFilter(
                                          filter: ImageFilter.blur(
                                              sigmaX: 70.0, sigmaY: 70.0),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: news.cover != null
                                                  ? const Color.fromARGB(
                                                          255, 134, 125, 97)
                                                      .withValues(alpha: 0.5)
                                                  : const Color.fromARGB(255, 124, 116, 90),
                                            ),
                                            padding: EdgeInsets.all(20),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              spacing: 10,
                                              children: [
                                                Hero(
                                                  tag: "readtime-${news.id}",
                                                  child: Text(
                                                    "${news.readTime} MIN READ",
                                                    style: theme
                                                        .textTheme.labelSmall!
                                                        .copyWith(
                                                            color:
                                                                Colors.white),
                                                  ),
                                                ),
                                                Hero(
                                                  tag: "headline-${news.id}",
                                                  child: Text(
                                                    news.title,
                                                    style: theme.textTheme
                                                        .headlineMedium!
                                                        .copyWith(
                                                            color:
                                                                Colors.white),
                                                  ),
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
                        ),
                      );
                    },
                    /*onSwipe: (previousIndex, currentIndex, direction) {
                      final news = filteredNews[previousIndex];
                      final newsBloc = context.read<NewsBloc>();
                      newsBloc.add(SkipNewsEvent(id: news.id));
                      return true;
                    },*/
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
                          onChanged: (daysBefore) async {
                            final newsBloc = context.read<NewsBloc>();
                            final newTime = DateTime.now().subtract(Duration(
                              days: min((daysBefore * 7).toInt() - 7, 0).abs(),
                            ));

                            newsBloc.add(SetNewsSettings(
                              time: newTime,
                            ));
                            await newsBloc.stream.firstWhere(
                                (state) => state.settings.time == newTime);
                            delayTimer?.cancel();
                            delayTimer = Timer(const Duration(seconds: 1), () {
                              newsBloc.add(FetchNewsEvent());
                            });
                          },
                        ),
                        Text(
                          DateFormat("d MMM yyyy").format(time).toUpperCase(),
                          style: theme.textTheme.labelLarge!
                              .copyWith(letterSpacing: 1),
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
