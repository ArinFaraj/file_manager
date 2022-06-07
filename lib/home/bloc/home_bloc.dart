import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(const HomeState()) {
    on<HomeInit>(_homeInit);
    on<HomeSetPath>(_setPath);
    on<HomeGoForward>(_goForward);
    on<HomeGoBackward>(_goBackward);
  }

  FutureOr<void> _homeInit(event, emit) async {
    final dir = (await getApplicationDocumentsDirectory()).path;
    emit(state.copyWith(
        panel0Path: dir,
        panel1Path: dir,
        panel0PathHistory: [...state.panel0PathHistory, dir]));
  }

  void _setPath(HomeSetPath event, Emitter<HomeState> emit) {
    if (event.panel == 0) {
      final List<String> hist = List.from(state.panel0PathHistory);
      hist.removeRange(
          state.currentPanel0History, state.panel0PathHistory.length - 1);

      hist.add(state.panel0Path);

      emit(state.copyWith(
        panel0Path: event.path,
        currentPanel0History: hist.length - 1,
        panel0PathHistory: hist,
      ));
    } else {
      emit(state.copyWith(
        panel1Path: event.path,
      ));
    }
  }

  void _goForward(HomeGoForward event, Emitter<HomeState> emit) {
    if (state.panel0PathHistory.isNotEmpty &&
        state.currentPanel0History < state.panel0PathHistory.length - 1) {
      emit(
        state.copyWith(
          currentPanel0History: state.currentPanel0History + 1,
          panel0Path: state.panel0PathHistory[state.currentPanel0History + 1],
        ),
      );
    }
  }

  void _goBackward(HomeGoBackward event, Emitter<HomeState> emit) {
    if (state.panel0PathHistory.isNotEmpty && state.currentPanel0History != 0) {
      emit(
        state.copyWith(
          currentPanel0History: state.currentPanel0History - 1,
          panel0Path: state.panel0PathHistory[state.currentPanel0History - 1],
        ),
      );
    }
  }
}
