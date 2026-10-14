import 'load_mode.dart';
import 'planned_set.dart';

class ProgramExercise {
  const ProgramExercise({
    required this.name,
    required this.restSeconds,
    this.loadMode = LoadMode.externalLoad,
    this.sets = const [],
  });

  final String name;
  final int restSeconds;
  final LoadMode loadMode;
  final List<PlannedSet> sets;

  bool get usesWeight => loadMode != LoadMode.bodyweight;

  String get weightColumnLabel =>
      loadMode == LoadMode.bodyweightPlusLoad ? 'Added kg' : 'kg';

  String get loadModeLabel => switch (loadMode) {
    LoadMode.externalLoad => 'External weight',
    LoadMode.bodyweight => 'Bodyweight',
    LoadMode.bodyweightPlusLoad => 'Bodyweight + added weight',
  };
}