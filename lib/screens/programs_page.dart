import 'package:flex_application/models/planned_set.dart';
import 'package:flex_application/models/program_exercise.dart';
import 'package:flutter/material.dart';

import '../models/program_summary.dart';
import 'program_detail_page.dart';

class ProgramsPage extends StatelessWidget {
  const ProgramsPage({super.key});

  static const _programs = [
    ProgramSummary(
      name: 'Upper Body',
      exercises: [
        ProgramExercise(
          name: 'Bench Press',
          restSeconds: 90,
          sets: [
            PlannedSet(targetReps: 12, targetLoadGrams: 40000),
            PlannedSet(targetReps: 10, targetLoadGrams: 45000),
            PlannedSet(targetReps: 8, targetLoadGrams: 50000),
          ],
        ),
        ProgramExercise(
          name: 'Lat Pulldown',
          restSeconds: 90,
          sets: [
            PlannedSet(targetReps: 10, targetLoadGrams: 40000),
            PlannedSet(targetReps: 10, targetLoadGrams: 45000),
            PlannedSet(targetReps: 8, targetLoadGrams: 50000),
          ],
        ),
        ProgramExercise(name: 'Shoulder Press', restSeconds: 60),
      ],
    ),
    ProgramSummary(
      name: 'Lower Body',
      exercises: [
        ProgramExercise(name: 'Squat', restSeconds: 120),
        ProgramExercise(name: 'Romanian Deadlift', restSeconds: 90),
        ProgramExercise(name: 'Leg Press', restSeconds: 90),
        ProgramExercise(name: 'Calf Raise', restSeconds: 60),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _programs.length,
      itemBuilder: (context, index) {
        final program = _programs[index];

        return Card(
          child: ListTile(
            contentPadding: const EdgeInsets.all(16),
            leading: const Icon(Icons.fitness_center),
            title: Text(program.name),
            subtitle: Text(
              '${program.exerciseCount} exercises • '
              '${program.setCount} sets',
            ),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (context) => ProgramDetailPage(program: program),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
