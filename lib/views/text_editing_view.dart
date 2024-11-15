import 'package:flutter/material.dart';
import 'package:markdown_editor_plus/markdown_editor_plus.dart';

class TextEditingView extends StatelessWidget {
  final TextEditingController textFieldController;
  final ScrollController scrollController;

  const TextEditingView({
    super.key,
    required this.textFieldController,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: MarkdownAutoPreview(
        scrollController: scrollController,
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
