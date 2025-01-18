sealed class NewsEvent {}

class SetNewsSettings extends NewsEvent {
  final bool? isGlobal;
  final DateTime? time;

  SetNewsSettings({this.isGlobal, this.time});
}

class FetchInterestsEvent extends NewsEvent {}

class SetInterestsEvent extends NewsEvent {
  final Set<String> interests;

  SetInterestsEvent({required this.interests});
}

class FetchNewsEvent extends NewsEvent {}

class SkipNewsEvent extends NewsEvent {
  final String id;

  SkipNewsEvent({required this.id});
}

class OpenNewsEvent extends NewsEvent {
  final String id;

  OpenNewsEvent({required this.id});
}

class CloseNewsEvent extends NewsEvent {}
