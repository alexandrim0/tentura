import 'package:flutter/material.dart';

class TagsCloud extends StatelessWidget {
  const TagsCloud({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      height: 40,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IconButton(
            tooltip: 'Новый тег',
            icon: const Icon(Icons.local_offer_outlined),
            onPressed: () => showDialog<void>(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Новый тег'),
                content: const TextField(
                  decoration: InputDecoration(
                    hintText: '#введите_тег',
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: Navigator.of(context).pop,
                    child: const Text('Отмена'),
                  ),
                  TextButton(
                    onPressed: Navigator.of(context).pop,
                    child: const Text('Ок'),
                  ),
                ],
              ),
            ),
          ),

          // Tags List
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _tags.length,
              itemBuilder: (_, i) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Chip(
                  label: Text(
                    _tags[i],
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  side: BorderSide.none,
                  backgroundColor: theme.colorScheme.surfaceContainer,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  static const _tags = [
    '#accessibility',
    '#africa',
    '#ai-art',
    '#amm',
    '#design',
    '#flutter',
    '#darkmode',
  ];
}
