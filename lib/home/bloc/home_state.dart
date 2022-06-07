part of 'home_bloc.dart';

class HomeState {
  final int currentPanel0History;
  final String panel0Path;
  final String panel1Path;
  Directory get panel0Dir => Directory(panel0Path);
  Directory get panel1Dir => Directory(panel1Path);
  final List<String> panel0PathHistory;

  const HomeState({
    this.currentPanel0History = 0,
    this.panel0Path = '',
    this.panel1Path = '',
    this.panel0PathHistory = const [],
  });

  HomeState copyWith({
    int? currentPanel0History,
    String? panel0Path,
    String? panel1Path,
    List<String>? panel0PathHistory,
  }) {
    return HomeState(
      currentPanel0History: currentPanel0History ?? this.currentPanel0History,
      panel0Path: panel0Path ?? this.panel0Path,
      panel1Path: panel1Path ?? this.panel1Path,
      panel0PathHistory: panel0PathHistory ?? this.panel0PathHistory,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'currentPanel0History': currentPanel0History,
      'panel0Path': panel0Path,
      'panel1Path': panel1Path,
      'panel0PathHistory': panel0PathHistory,
    };
  }

  factory HomeState.fromMap(Map<String, dynamic> map) {
    return HomeState(
      currentPanel0History: map['currentPanel0History']?.toInt() ?? 0,
      panel0Path: map['panel0Path'] ?? '',
      panel1Path: map['panel1Path'] ?? '',
      panel0PathHistory: List<String>.from(map['panel0PathHistory']),
    );
  }

  String toJson() => json.encode(toMap());

  factory HomeState.fromJson(String source) =>
      HomeState.fromMap(json.decode(source));

  @override
  String toString() {
    return 'HomeState(currentPanel0History: $currentPanel0History, panel0Path: $panel0Path, panel1Path: $panel1Path, panel0PathHistory: $panel0PathHistory)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is HomeState &&
        other.currentPanel0History == currentPanel0History &&
        other.panel0Path == panel0Path &&
        other.panel1Path == panel1Path &&
        listEquals(other.panel0PathHistory, panel0PathHistory);
  }

  @override
  int get hashCode {
    return currentPanel0History.hashCode ^
        panel0Path.hashCode ^
        panel1Path.hashCode ^
        panel0PathHistory.hashCode;
  }
}
