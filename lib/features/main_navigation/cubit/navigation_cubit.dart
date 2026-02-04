

import 'package:flutter_bloc/flutter_bloc.dart';

part 'navigation_state.dart';

// class NavigationCubit extends Cubit<NavigationState> {
//   NavigationCubit() : super(NavigationInitial());
// }
 class MainNavigationCubit extends Cubit<int> {
  MainNavigationCubit() : super(0);

  void changeTab(int index) {
    emit(index);
  }
}