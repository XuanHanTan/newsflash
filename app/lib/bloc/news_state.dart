import 'package:app/api/news_api.dart';

class NewsState {
  final bool isLoading;
  final List<String> interests;
  final List<NewsSummary> recommendations;

  final NewsDetailed? currentOpenNews;

  NewsState({required this.isLoading, required this.interests, required this.recommendations, required this.currentOpenNews});

  factory NewsState.initial() {
    return NewsState(
      isLoading: true,
      interests: [],
      recommendations: [],
      currentOpenNews: null,
    );
  }

  NewsState copyWith({
    bool? isLoading,
    List<String>? interests,
    List<NewsSummary>? recommendations,
    NewsDetailed? currentOpenNews,
  }) {
    return NewsState(
      isLoading: isLoading ?? this.isLoading,
      interests: interests ?? this.interests,
      recommendations: recommendations ?? this.recommendations,
      currentOpenNews: currentOpenNews ?? this.currentOpenNews,
    );
  }
}