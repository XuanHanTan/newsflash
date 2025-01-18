import 'package:app/bloc/news_bloc.dart';
import 'package:app/bloc/news_event.dart';
import 'package:app/bloc/news_state.dart';
import 'package:app/pages/interests_setup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegionSetup extends StatelessWidget {
  const RegionSetup({super.key});

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
                  previous.settings.isGlobal != current.settings.isGlobal,
              builder: (context, state) {
                final navigator = Navigator.of(context);

                return Column(
                  children: [
                    Spacer(),
                    Text(
                      "Where should your news come from?",
                      style: theme.textTheme.displaySmall,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    FilterChip(
                      label: Text("Local"),
                      labelStyle:
                          theme.textTheme.labelLarge!.copyWith(fontSize: 16),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100)),
                      padding:
                          EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                      selected: !state.settings.isGlobal,
                      onSelected: (isSelected) {
                        context
                            .read<NewsBloc>()
                            .add(SetNewsSettings(isGlobal: !isSelected));
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    FilterChip(
                      label: Text("Global"),
                      labelStyle:
                          theme.textTheme.labelLarge!.copyWith(fontSize: 16),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100)),
                      padding:
                          EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                      selected: state.settings.isGlobal,
                      onSelected: (isSelected) {
                        context
                            .read<NewsBloc>()
                            .add(SetNewsSettings(isGlobal: isSelected));
                      },
                    ),
                    Spacer(),
                    FilledButton(
                      onPressed: () {
                        navigator.push(MaterialPageRoute(
                            builder: (context) => InterestsSetup()));
                      },
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
