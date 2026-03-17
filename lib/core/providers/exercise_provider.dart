import 'package:flutter_riverpod/flutter_riverpod.dart';

class ExerciseNotifier extends Notifier<int> {
  @override
  int build() => 0;

  void increment() {
    state++;
  }

  void reset() {
    state = 0;
  }
}

final exerciseCompletedProvider = NotifierProvider<ExerciseNotifier, int>(
  ExerciseNotifier.new,
);
