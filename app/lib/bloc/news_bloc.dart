import 'package:app/api/interests_api.dart';
import 'package:app/api/news_api.dart';
import 'package:app/bloc/news_event.dart';
import 'package:app/bloc/news_state.dart';
import 'package:collection/collection.dart';
import 'package:country_ip/country_ip.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NewsBloc extends Bloc<NewsEvent, NewsState> {
  NewsBloc() : super(NewsState.initial()) {
    on<SetNewsSettings>(onSetNewsSettings);
    on<FetchInterestsEvent>(onFetchInterests);
    on<SetInterestsEvent>(onSetInterests);
    on<FetchNewsEvent>(onFetchNews);
    on<OpenNewsEvent>(onOpenNews);
    on<CloseNewsEvent>(onCloseNews);
  }

  void onSetNewsSettings(SetNewsSettings event, Emitter emit) {
    emit(state.copyWith(
        settings: state.settings
            .copyWith(isGlobal: event.isGlobal, time: event.time)));
  }

  Future<void> onFetchInterests(FetchInterestsEvent event, Emitter emit) async {
    emit(state.copyWith(isLoading: true));
    final interests = await InterestsApi.getInterests();
    emit(state.copyWith(interests: interests, isLoading: false));
  }

  Future<void> onSetInterests(SetInterestsEvent event, Emitter emit) async {
    await InterestsApi.setInterests(event.interests);
    emit(state.copyWith(interests: event.interests));
  }

  Future<void> onFetchNews(FetchNewsEvent event, Emitter emit) async {
    emit(state.copyWith(isLoading: true));
    final countryCode = (await CountryIp.find())?.countryCode;
    final news = await NewsSummary.fetchNews(
        interests: state.interests,
        time: state.settings.time,
        region: countryCode);
    emit(state.copyWith(recommendations: news, isLoading: false));
  }

  void onSkipNews(SkipNewsEvent event, Emitter emit) async {
    final newSkippedMap = {...state.skipped, event.id: true};
    emit(state.copyWith(skipped: newSkippedMap));
  }

  Future<void> onOpenNews(OpenNewsEvent event, Emitter emit) async {
    final newsItem =
        state.recommendations.firstWhereOrNull((item) => item.id == event.id);
    if (newsItem == null) throw Exception('News item not found');

    final detailedNewsItem = await newsItem.getDetailedArticle();
    emit(state.copyWith(currentOpenNews: detailedNewsItem));
  }

  Future<void> onCloseNews(CloseNewsEvent event, Emitter emit) async {
    emit(state.copyWith(currentOpenNews: null));
  }
}
