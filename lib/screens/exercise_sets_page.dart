import 'package:flutter/material.dart';

import '../models/program_exercise.dart';

class ExerciseSetsPage extends StatelessWidget {
  const ExerciseSetsPage({super.key, required this.exercise});

  final ProgramExercise exercise;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(exercise.name),
        backgroundColor: Theme.of(context).colorScheme.surface,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            exercise.loadModeLabel,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'Rest between sets: ${exercise.restSeconds} seconds',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 16),
          if (exercise.sets.isEmpty)
            const Text('No sets yet')
          else
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: [
                  const DataColumn(label: Text('Set')),
                  if (exercise.usesWeight)
                    DataColumn(
                      label: Text(exercise.weightColumnLabel),
                      numeric: true,
                    ),
                  const DataColumn(label: Text('Reps'), numeric: true),
                ],
                rows: List.generate(exercise.sets.length, (index) {
                  final plannedSet = exercise.sets[index];
                  final loadGrams = plannedSet.targetLoadGrams;
                  final weightText = loadGrams == null
                      ? '—'
                      : '${loadGrams / 1000}';

                  return DataRow(
                    cells: [
                      DataCell(Text('${index + 1}')),
                      if (exercise.usesWeight) DataCell(Text(weightText)),
                      DataCell(Text('${plannedSet.targetReps}')),
                    ],
                  );
                }),
              ),
            ),
        ],
      ),
    );
  }
}
