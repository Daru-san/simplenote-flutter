import 'package:flutter/material.dart';
import 'package:markdown_editor_plus/markdown_editor_plus.dart';

class TextEditingView extends StatelessWidget {
  final TextEditingController textFieldController;

  const TextEditingView({super.key, required this.textFieldController});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: MarkdownAutoPreview(
        controller: textFieldController,
        emojiConvert: true,
        maxLines: null,
        textCapitalization: TextCapitalization.sentences,
        decoration: InputDecoration(),
        toolbarBackground: Theme.of(context).cardColor,
        style: TextStyle(
          fontSize: 19,
          height: 1.5,
        ),
      ),
    );
  }
}
