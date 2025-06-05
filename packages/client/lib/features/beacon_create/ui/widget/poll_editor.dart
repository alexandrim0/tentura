import 'package:flutter/material.dart';
import 'package:tentura/ui/l10n/l10n.dart';

class PollEditor extends StatelessWidget {
  const PollEditor({
    required this.questionController,
    required this.optionControllers,
    required this.onAddOption,
    required this.onRemoveOption,
    super.key,
  });

  final TextEditingController questionController;
  final List<TextEditingController> optionControllers;
  final VoidCallback onAddOption;
  final void Function(int) onRemoveOption;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = L10n.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.pollSectionTitle, style: theme.textTheme.titleSmall),

        const SizedBox(height: 12),

        // Вопрос
        TextFormField(
          controller: questionController,
          decoration: InputDecoration(
            labelText: l10n.pollQuestionFieldLabel,
            border: const OutlineInputBorder(),
          ),
        ),

        const SizedBox(height: 16),

        // Варианты
        Text(l10n.pollOptionsLabel, style: theme.textTheme.bodyMedium),

        const SizedBox(height: 8),

        for (int i = 0; i < optionControllers.length; i++)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: optionControllers[i],
                    decoration: InputDecoration(
                      labelText: l10n.optionLabel(i + 1),
                      border: const OutlineInputBorder(),
                    ),
                  ),
                ),
                if (optionControllers.length > 2)
                  IconButton(
                    onPressed: () => onRemoveOption(i),
                    icon: const Icon(Icons.remove_circle_outline),
                  ),
              ],
            ),
          ),

        const SizedBox(height: 8),

        // Добавить вариант
        Align(
          alignment: Alignment.centerRight,
          child: TextButton.icon(
            onPressed: onAddOption,
            icon: const Icon(Icons.add),
            label: Text(l10n.addOptionButton),
          ),
        ),
      ],
    );
  }
}
