import 'package:app/api/interests_api.dart';
import 'package:app/api/news_api.dart';
import 'package:app/bloc/news_event.dart';
import 'package:app/bloc/news_state.dart';
import 'package:collection/collection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NewsBloc extends Bloc<NewsEvent, NewsState>{
  NewsBloc(): super(NewsState.initial()) {
    on<FetchInterestsEvent>(onFetchInterests);
    on<SetInterestsEvent>(onSetInterests);
    on<FetchNewsEvent>(onFetchNews);
    on<OpenNewsEvent>(onOpenNews);
    on<CloseNewsEvent>(onCloseNews);
  }

  Future<void> onFetchInterests(FetchInterestsEvent event, Emitter emit) async {
    final interests = await InterestsApi.getInterests();
    emit(state.copyWith(interests: interests));
  }

  Future<void> onSetInterests(SetInterestsEvent event, Emitter emit) async {
    await InterestsApi.setInterests(event.interests);
    emit(state.copyWith(interests: event.interests));
  }

  Future<void> onFetchNews(FetchNewsEvent event, Emitter emit) async {
    final news = await NewsSummary.fetchNews(state.interests);
    emit(state.copyWith(recommendations: news));
  }

  Future<void> onOpenNews(OpenNewsEvent event, Emitter emit) async {
    final newsItem = state.recommendations.firstWhereOrNull((item) => item.id == event.id);
    if (newsItem == null) throw Exception('News item not found');

    final detailedNewsItem = await newsItem.getDetailedArticle();
    emit(state.copyWith(currentOpenNews: detailedNewsItem));
  }

  Future<void> onCloseNews(CloseNewsEvent event, Emitter emit) async {
    emit(state.copyWith(currentOpenNews: null));
  }
}