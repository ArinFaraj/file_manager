part of 'home_bloc.dart';

@immutable
abstract class HomeEvent {
  const HomeEvent();
}

class HomeInit extends HomeEvent {
  const HomeInit();
}

class HomeGoBackward extends HomeEvent {
  final int panel;
  const HomeGoBackward(this.panel);
}

class HomeGoForward extends HomeEvent {
  final int panel;
  const HomeGoForward(this.panel);
}

class HomeSetPath extends HomeEvent {
  final int panel;
  final String path;
  const HomeSetPath(this.panel, this.path);
}
