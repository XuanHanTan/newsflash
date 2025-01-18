import 'package:app/api/news_api.dart';

class NewsState {
  final bool isLoading;
  final Set<String> interests;
  final List<NewsSummary> news;
  final Map<String, bool> skipped;
  final NewsSettings settings;

  final NewsDetailed? currentOpenNews;

  NewsState(
      {required this.isLoading,
      required this.interests,
      required this.news,
      required this.skipped,
      required this.settings,
      required this.currentOpenNews});

  factory NewsState.initial() {
    return NewsState(
      isLoading: true,
      interests: {},
      news: [],
      skipped: {},
      settings: NewsSettings(isGlobal: true, time: DateTime.now()),
      currentOpenNews: null,
    );
  }

  NewsState copyWith({
    bool? isLoading,
    Set<String>? interests,
    List<NewsSummary>? news,
    Map<String, bool>? skipped,
    NewsSettings? settings,
    NewsDetailed? currentOpenNews,
  }) {
    return NewsState(
      isLoading: isLoading ?? this.isLoading,
      interests: interests ?? this.interests,
      news: news ?? this.news,
      skipped: skipped ?? this.skipped,
      settings: settings ?? this.settings,
      currentOpenNews: currentOpenNews ?? this.currentOpenNews,
    );
  }
}

class NewsSettings {
  final bool isGlobal;
  final DateTime time;

  const NewsSettings({required this.isGlobal, required this.time});

  NewsSettings copyWith({bool? isGlobal, DateTime? time}) {
    return NewsSettings(
        isGlobal: isGlobal ?? this.isGlobal, time: time ?? this.time);
  }
}
