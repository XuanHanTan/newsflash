import 'package:app/api/news_api.dart';

class NewsState {
  final bool isLoading;
  final List<String> interests;
  final List<NewsSummary> recommendations;
  final Map<String, bool> skipped;

  final NewsDetailed? currentOpenNews;

  NewsState({required this.isLoading, required this.interests, required this.recommendations, required this.skipped, required this.currentOpenNews});

  factory NewsState.initial() {
    return NewsState(
      isLoading: true,
      interests: [],
      recommendations: [],
      skipped: {},
      currentOpenNews: null,
    );
  }

  NewsState copyWith({
    bool? isLoading,
    List<String>? interests,
    List<NewsSummary>? recommendations,
    Map<String, bool>? skipped,
    NewsDetailed? currentOpenNews,
  }) {
    return NewsState(
      isLoading: isLoading ?? this.isLoading,
      interests: interests ?? this.interests,
      recommendations: recommendations ?? this.recommendations,
      skipped: skipped ?? this.skipped,
      currentOpenNews: currentOpenNews ?? this.currentOpenNews,
    );
  }
}