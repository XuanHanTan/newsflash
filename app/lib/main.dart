import 'package:app/bloc/news_bloc.dart';
import 'package:app/bloc/news_event.dart';
import 'package:app/pages/region_setup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Widget firstPage = RegionSetup();
  final newsBloc = NewsBloc()..add(FetchInterestsEvent());
  final newsBlocState =
      await newsBloc.stream.firstWhere((state) => !state.isLoading);
  if (newsBlocState.interests.isNotEmpty) {
    // TODO: Navigate to home page
    firstPage = RegionSetup();
  }

  runApp(
    BlocProvider<NewsBloc>(
      create: (context) => newsBloc,
      child: MaterialApp(
        home: firstPage,
      ),
    ),
  );
}

extension StringExtension on String {
    String capitalize() {
      return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
    }
}