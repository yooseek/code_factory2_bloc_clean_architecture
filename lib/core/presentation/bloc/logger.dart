import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Logger extends BlocObserver {

  @override
  void onChange(BlocBase bloc, Change change) {
    debugPrint('[Bloc Change] Bloc : $bloc / Change : $change');
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    debugPrint('[Bloc Transition] Bloc : $bloc / Transition : $transition');
  }

  @override
  void onCreate(BlocBase bloc) {
    debugPrint('[Bloc Create] Bloc : $bloc / Value : ${bloc.state}');
  }
}