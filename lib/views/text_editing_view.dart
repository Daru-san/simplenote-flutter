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
    return Container(
      height: MediaQuery.of(context).size.height,
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: MarkdownAutoPreview(
        enableToolBar: true,
        scrollController: scrollController,
        controller: textFieldController,
        emojiConvert: true,
        maxLines: null,
        textCapitalization: TextCapitalization.sentences,
        decoration: InputDecoration(),
        style: TextStyle(
          fontSize: 19,
          height: 1.5,
        ),
      ),
    );
  }
}
