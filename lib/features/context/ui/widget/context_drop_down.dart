import 'package:flutter/material.dart';

import 'package:tentura/ui/utils/ui_utils.dart';

import '../../domain/entity/context_selection.dart';
import '../bloc/context_cubit.dart';
import '../dialog/context_add_dialog.dart';
import '../dialog/context_remove_dialog.dart';

class ContextDropDown extends StatelessWidget {
  const ContextDropDown({super.key});

  @override
  Widget build(BuildContext context) {
    final contextCubit = context.read<ContextCubit>();
    final colorScheme = Theme.of(context).colorScheme;
    return BlocConsumer<ContextCubit, ContextState>(
      builder: (context, state) => DefaultTextStyle.merge(
        style: TextStyle(
          color: colorScheme.onSurface,
        ),
        child: DropdownButton<ContextSelection>(
          dropdownColor: colorScheme.surface,
          isExpanded: true,
          items: [
            const DropdownMenuItem(
              value: ContextSelectionAdd(),
              child: Text('Add new topic'),
            ),
            const DropdownMenuItem(
              value: ContextSelectionAll(),
              child: Text('All topics'),
            ),
            for (final e in state.contexts)
              DropdownMenuItem(
                value: ContextSelectionValue(e),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(e),
                    if (state.selected == e)
                      IconButton(
                        icon: const Icon(Icons.delete_forever),
                        onPressed: () async {
                          final needDelete = await ContextRemoveDialog.show(
                            context,
                            contextName: e,
                          );
                          if (needDelete ?? false) await contextCubit.delete(e);
                        },
                      ),
                  ],
                ),
              ),
          ],
          onChanged: (value) => switch (value) {
            final ContextSelectionAdd _ => ContextAddDialog.show(context).then(
                (contextName) async {
                  if (contextName != null) {
                    await contextCubit.add(contextName);
                  }
                },
              ),
            final ContextSelectionAll _ => contextCubit.select(''),
            final ContextSelectionValue c => contextCubit.select(c.name),
            null => null,
          },
          value: switch (state.selected) {
            '' => const ContextSelectionAll(),
            final c => ContextSelectionValue(c),
          },
        ),
      ),
      listenWhen: (p, c) => c.hasError,
      listener: showSnackBarError,
    );
  }
}
