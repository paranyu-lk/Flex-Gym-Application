import 'planned_set.dart';

class ProgramExercise {
  const ProgramExercise({
    required this.name,
    required this.restSeconds,
    this.sets = const [],
  });

  final String name;
  final int restSeconds;
  final List<PlannedSet> sets;
}