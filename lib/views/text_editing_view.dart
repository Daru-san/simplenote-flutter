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
      child: SplittedMarkdownFormField(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        enableToolBar: true,
        scrollController: scrollController,
        controller: textFieldController,
        toolbarBackground: Theme.of(context).scaffoldBackgroundColor,
        emojiConvert: true,
        minLines: null,
        maxLines: null,
        textCapitalization: TextCapitalization.sentences,
        decoration: InputDecoration(isDense: false),
        style: TextStyle(
          fontSize: 19,
          height: 1.5,
        ),
      ),
    );
  }
}
