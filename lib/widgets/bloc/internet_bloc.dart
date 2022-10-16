import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_movie_application/widgets/utils/internet_event.dart';
import 'package:flutter_movie_application/widgets/utils/internet_state.dart';

class InternetBloc extends Bloc<InternetEvent, InternetState> {
  final Connectivity _connectivity = Connectivity();

  late StreamSubscription _connectivitySubscription;

  InternetBloc() : super(InitialInternetState()) {
    on<InternetLostEvent>(((event, emit) => emit(InternetLostState())));
    on<InternetBackEvent>(((event, emit) => emit(InternetBackState())));

    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen((event) {
      if (event == ConnectivityResult.mobile ||
          event == ConnectivityResult.wifi) {
        add(InternetBackEvent());
      } else {
        add(InternetLostEvent());
      }
    });
  }

  @override
  Future<void> close() {
    _connectivitySubscription.cancel();
    return super.close();
  }
}
