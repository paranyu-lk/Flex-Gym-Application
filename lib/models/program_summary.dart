import 'package:flex_application/models/program_exercise.dart';

class ProgramSummary {
  const ProgramSummary({
    required this.name,
    required this.exercises,
  });

  final String name;
  final List<ProgramExercise> exercises;

  int get exerciseCount => exercises.length;

  int get setCount {
    var total = 0;

    for (final exercise in exercises) {
      total += exercise.sets.length;
    }

    return total;
  }
}