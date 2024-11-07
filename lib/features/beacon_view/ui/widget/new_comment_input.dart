import 'package:flutter/material.dart';

import '../bloc/beacon_view_cubit.dart';

class NewCommentInput extends StatefulWidget {
  const NewCommentInput({super.key});

  @override
  State<NewCommentInput> createState() => _NewCommentInputState();
}

class _NewCommentInputState extends State<NewCommentInput> {
  final _textController = TextEditingController();

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 20, left: 20),
        child: Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _textController,
                decoration: const InputDecoration(
                  hintText: 'Write a comment',
                ),
                maxLines: null,
                onTapOutside: (event) => FocusScope.of(context).unfocus(),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.send),
              onPressed: () async {
                if (_textController.text.isEmpty) return;
                await context
                    .read<BeaconViewCubit>()
                    .addComment(_textController.text);
                if (context.mounted) {
                  _textController.clear();
                  FocusScope.of(context).unfocus();
                }
              },
            ),
          ],
        ),
      );
}
