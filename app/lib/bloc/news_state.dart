import 'package:app/api/news_api.dart';

class NewsState {
  final bool isLoading;
  final List<String> interests;
  final List<NewsSummary> recommendations;
  final Map<String, bool> skipped;
  final NewsSettings settings;

  final NewsDetailed? currentOpenNews;

  NewsState(
      {required this.isLoading,
      required this.interests,
      required this.recommendations,
      required this.skipped,
      required this.settings,
      required this.currentOpenNews});

  factory NewsState.initial() {
    return NewsState(
      isLoading: true,
      interests: [],
      recommendations: [],
      skipped: {},
      settings: NewsSettings(isGlobal: true, time: DateTime.now()),
      currentOpenNews: null,
    );
  }

  NewsState copyWith({
    bool? isLoading,
    List<String>? interests,
    List<NewsSummary>? recommendations,
    Map<String, bool>? skipped,
    NewsSettings? settings,
    NewsDetailed? currentOpenNews,
  }) {
    return NewsState(
      isLoading: isLoading ?? this.isLoading,
      interests: interests ?? this.interests,
      recommendations: recommendations ?? this.recommendations,
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
