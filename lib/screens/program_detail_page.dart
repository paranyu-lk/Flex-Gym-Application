import 'package:flutter/material.dart';

import '../models/program_summary.dart';

class ProgramDetailPage extends StatelessWidget {
  const ProgramDetailPage({super.key, required this.program});

  final ProgramSummary program;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(program.name),
        backgroundColor: Theme.of(context).colorScheme.surface,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: program.exercises.length,
        itemBuilder: (context, index) {
          final exercise = program.exercises[index];

          return Card(
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              leading: const Icon(Icons.fitness_center),
              title: Text(exercise.name),
              subtitle: Text(
                '${exercise.sets.length} sets • '
                'Rest: ${exercise.restSeconds} seconds',
              ),
            ),
          );
        },
      ),
    );
  }
}
