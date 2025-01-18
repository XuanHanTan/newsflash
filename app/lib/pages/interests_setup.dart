import 'package:app/bloc/news_bloc.dart';
import 'package:app/bloc/news_event.dart';
import 'package:app/bloc/news_state.dart';
import 'package:app/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

const availableInterests = [
  "technology",
  "finance",
  "crypto",
  "art",
  "culture",
  "sports",
  "politics",
  "entertainment",
  "crime",
  "health",
  "business",
  "science"
];

class InterestsSetup extends StatelessWidget {
  const InterestsSetup({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocProvider.value(
      value: BlocProvider.of<NewsBloc>(context),
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
            child: BlocBuilder<NewsBloc, NewsState>(
              buildWhen: (previous, current) =>
                  previous.interests != current.interests,
              builder: (context, state) {
                return Column(
                  children: [
                    Spacer(),
                    Text(
                      "What topics are you interested in?",
                      style: theme.textTheme.displaySmall,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      alignment: WrapAlignment.center,
                      children: availableInterests
                          .map((interest) => FilterChip(
                                label: Text(interest.capitalize()),
                                labelStyle: theme.textTheme.labelLarge!
                                    .copyWith(fontSize: 16),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(100)),
                                padding: EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 12),
                                selected: state.interests.contains(interest),
                                onSelected: (isSelected) {
                                  if (isSelected) {
                                    context.read<NewsBloc>().add(
                                            SetInterestsEvent(interests: {
                                          ...state.interests,
                                          interest
                                        }));
                                  } else {
                                    context.read<NewsBloc>().add(
                                        SetInterestsEvent(
                                            interests: {...state.interests}
                                              ..remove(interest)));
                                  }
                                },
                              ))
                          .toList(),
                    ),
                    Spacer(),
                    FilledButton(
                      onPressed: state.interests.isEmpty ? null : () {},
                      child: Text("Next"),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
