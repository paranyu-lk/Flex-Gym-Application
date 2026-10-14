import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/program_exercise.dart';

class ExerciseSetsPage extends StatefulWidget {
  const ExerciseSetsPage({super.key, required this.exercise});

  final ProgramExercise exercise;

  @override
  State<ExerciseSetsPage> createState() => _ExerciseSetsPageState();
}

class _ExerciseSetsPageState extends State<ExerciseSetsPage> {
  late final List<TextEditingController> _weightControllers;
  late final List<TextEditingController> _repsControllers;
  late final TextEditingController _restSecondsControllers;

  @override
  void initState() {
    super.initState();

    _weightControllers = widget.exercise.sets.map((plannedSet) {
      final grams = plannedSet.targetLoadGrams;

      return TextEditingController(
        text: grams == null ? '' : '${grams / 1000}',
      );
    }).toList();

    _repsControllers = widget.exercise.sets.map((plannedSet) {
      return TextEditingController(text: '${plannedSet.targetReps}');
    }).toList();

    _restSecondsControllers = TextEditingController(
      text: '${widget.exercise.restSeconds}',
    );
  }

  @override
  void dispose() {
    for (final controller in _weightControllers) {
      controller.dispose();
    }

    for (final controller in _repsControllers) {
      controller.dispose();
    }

    _restSecondsControllers.dispose();

    super.dispose();
  }

  void _addSet() {
    final previousWeight = _weightControllers.isEmpty
        ? ''
        : _weightControllers.last.text;

    final previousReps = _repsControllers.isEmpty
        ? ''
        : _repsControllers.last.text;

    setState(() {
      _weightControllers.add(
        TextEditingController(
          text: widget.exercise.usesWeight ? previousWeight : '',
        ),
      );

      _repsControllers.add(TextEditingController(text: previousReps));
    });
  }

  @override
  Widget build(BuildContext context) {
    final exercise = widget.exercise;

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
          TextField(
            controller: _restSecondsControllers,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: const InputDecoration(
              labelText: 'Rest between sets',
              suffixText: 'seconds',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          if (_repsControllers.isEmpty)
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
                rows: List.generate(_repsControllers.length, (index) {
                  return DataRow(
                    cells: [
                      DataCell(Text('${index + 1}')),
                      if (exercise.usesWeight)
                        DataCell(
                          SizedBox(
                            width: 88,
                            child: TextField(
                              controller: _weightControllers[index],
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                    decimal: true,
                                  ),
                              textAlign: TextAlign.right,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                isDense: true,
                              ),
                            ),
                          ),
                        ),
                      DataCell(
                        SizedBox(
                          width: 72,
                          child: TextField(
                            controller: _repsControllers[index],
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.right,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              isDense: true,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }),
              ),
            ),
          const SizedBox(height: 16),
          OutlinedButton.icon(
            onPressed: _addSet,
            icon: const Icon(Icons.add),
            label: const Text('Add set'),
          ),
        ],
      ),
    );
  }
}
