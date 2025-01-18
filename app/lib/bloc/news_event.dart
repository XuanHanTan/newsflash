sealed class NewsEvent {}

class FetchInterestsEvent extends NewsEvent {}

class SetInterestsEvent extends NewsEvent {
  final List<String> interests;
  SetInterestsEvent({required this.interests});
}

class FetchNewsEvent extends NewsEvent {}

class OpenNewsEvent extends NewsEvent {
  final String id;
  
  OpenNewsEvent({required this.id});
}

class CloseNewsEvent extends NewsEvent {}