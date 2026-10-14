import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

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

  _DeletedSetDraft? _lastDeletedSet;

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

  void _deleteSet(int index) {
    if (_repsControllers.length <= 1) return;

    FocusScope.of(context).unfocus();

    final deletedSet = _DeletedSetDraft(
      index: index,
      weightText: _weightControllers[index].text,
      repsText: _repsControllers[index].text,
    );

    late final TextEditingController removedWeight;
    late final TextEditingController removedReps;

    setState(() {
      _lastDeletedSet = deletedSet;

      removedWeight = _weightControllers.removeAt(index);
      removedReps = _repsControllers.removeAt(index);
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      removedWeight.dispose();
      removedReps.dispose();
    });
  }

  void _undoDelete() {
    final deletedSet = _lastDeletedSet;
    if (deletedSet == null) return;

    setState(() {
      _weightControllers.insert(
        deletedSet.index,
        TextEditingController(text: deletedSet.weightText),
      );

      _repsControllers.insert(
        deletedSet.index,
        TextEditingController(text: deletedSet.repsText),
      );

      _lastDeletedSet = null;
    });
  }

  Widget _setInput(TextEditingController controller, {bool decimal = false}) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6),
        child: TextField(
          controller: controller,
          keyboardType: TextInputType.numberWithOptions(decimal: decimal),
          inputFormatters: [
            if (decimal)
              TextInputFormatter.withFunction((oldValue, newValue) {
                final pattern = RegExp(r'^\d*\.?\d{0,3}$');
                return pattern.hasMatch(newValue.text) ? newValue : oldValue;
              })
            else
              FilteringTextInputFormatter.digitsOnly,
          ],
          textAlign: TextAlign.right,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            isDense: true,
          ),
        ),
      ),
    );
  }

  Widget _buildSetRow(int index) {
    final colors = Theme.of(context).colorScheme;
    final canDelete = _repsControllers.length > 1;

    return Padding(
      key: ObjectKey(_repsControllers[index]),
      padding: const EdgeInsets.only(bottom: 8),
      child: Slidable(
        groupTag: 'sets',
        enabled: canDelete,
        endActionPane: ActionPane(
          motion: const BehindMotion(),
          extentRatio: 0.3,
          dragDismissible: false,
          children: [
            const SizedBox(width: 10),
            SlidableAction(
              onPressed: (_) => _deleteSet(index),
              backgroundColor: colors.error,
              foregroundColor: colors.onError,
              borderRadius: BorderRadius.circular(8),
              label: 'Delete',
            ),
          ],
        ),
        child: Builder(
          builder: (rowContext) {
            return ColoredBox(
              color: Theme.of(context).scaffoldBackgroundColor,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  children: [
                    SizedBox(
                      width: 48,
                      child: Tooltip(
                        message: 'Set options',
                        child: TextButton(
                          onPressed: canDelete
                              ? () {
                                  Slidable.of(rowContext)?.openEndActionPane();
                                }
                              : null,
                          child: Text('${index + 1}'),
                        ),
                      ),
                    ),
                    if (widget.exercise.usesWeight)
                      _setInput(_weightControllers[index], decimal: true),
                    _setInput(_repsControllers[index]),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
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
            SlidableAutoCloseBehavior(
              child: Column(
                children: [
                  Row(
                    children: [
                      const SizedBox(
                        width: 48,
                        child: Center(child: Text('Set')),
                      ),
                      if (exercise.usesWeight)
                        Expanded(
                          child: Center(
                            child: Text(exercise.weightColumnLabel),
                          ),
                        ),
                      const Expanded(child: Center(child: Text('Reps'))),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ...List.generate(_repsControllers.length, _buildSetRow),
                ],
              ),
            ),
          const SizedBox(height: 16),
          if (_lastDeletedSet != null)
            Row(
              children: [
                const Expanded(child: Text('Set deleted')),
                TextButton.icon(
                  onPressed: _undoDelete,
                  icon: const Icon(Icons.undo),
                  label: const Text('Undo'),
                ),
              ],
            ),
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

class _DeletedSetDraft {
  const _DeletedSetDraft({
    required this.index,
    required this.weightText,
    required this.repsText,
  });

  final int index;
  final String weightText;
  final String repsText;
}
