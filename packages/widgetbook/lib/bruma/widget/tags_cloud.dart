import 'package:flutter/material.dart';
import 'package:tentura/ui/utils/ui_utils.dart';

class TagsCloud extends StatelessWidget {
  const TagsCloud({super.key});

  @override
  Widget build(BuildContext context) {
    final tags = [
      '#accessibility',
      '#africa',
      '#ai-art',
      '#amm',
      '#design',
      '#flutter',
      '#darkmode',
    ];

    return SizedBox(
      height: 40,
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8, right: 4),
            child: IconButton(
              icon: const Icon(Icons.local_offer_outlined),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    final controller = TextEditingController();

                    return AlertDialog(
                      title: const Text('Новый тег'),
                      content: TextField(
                        controller: controller,
                        decoration: const InputDecoration(
                          hintText: '#введите_тег',
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text('Отмена'),
                        ),
                        TextButton(
                          onPressed: () {
                            //мок, ничего не происходит
                            Navigator.of(context).pop();
                          },
                          child: const Text('Ок'),
                        ),
                      ],
                    );
                  },
                );
              },

              tooltip: 'Новый тег',
            ),
          ),

          // Tags List
          Expanded(
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 4),
              itemCount: tags.length,
              itemBuilder: (context, index) => Chip(
                label: Text(
                  tags[index],
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
                side: BorderSide.none,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              separatorBuilder: (_, _) => const SizedBox(width: kSpacingSmall),
            ),
          ),
        ],
      ),
    );
  }
}
