import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
    

enum NetworkState { connected, disconnected }

class NetworkCubit extends Cubit<NetworkState> {
  NetworkCubit() : super(NetworkState.connected) {
    Connectivity().onConnectivityChanged.listen((result) {
      // ignore: unrelated_type_equality_checks
      if (result == ConnectivityResult.none) {
        emit(NetworkState.disconnected);
      } else {
        emit(NetworkState.connected);
      }
    });
  }
}
