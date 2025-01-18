sealed class NewsEvent {}

class SetNewsSettings extends NewsEvent {
  final bool isGlobal;
  final DateTime time;

  SetNewsSettings({required this.isGlobal, required this.time});
}

class FetchInterestsEvent extends NewsEvent {}

class SetInterestsEvent extends NewsEvent {
  final List<String> interests;

  SetInterestsEvent({required this.interests});
}

class FetchNewsEvent extends NewsEvent {
  final DateTime time;

  FetchNewsEvent({required this.time});
}

class SkipNewsEvent extends NewsEvent {
  final String id;

  SkipNewsEvent({required this.id});
}

class OpenNewsEvent extends NewsEvent {
  final String id;

  OpenNewsEvent({required this.id});
}

class CloseNewsEvent extends NewsEvent {}
