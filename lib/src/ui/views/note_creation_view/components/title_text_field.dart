import 'package:canton_design_system/canton_design_system.dart';

import 'package:notes_app/src/models/note.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notes_app/src/ui/providers/note_provider.dart';

class TitleTextField extends StatelessWidget {
  const TitleTextField(
      {Key? key, required this.focus, required this.controller, required this.setState, required this.note})
      : super(key: key);

  final FocusNode focus;
  final TextEditingController controller;
  final void Function(void Function()) setState;
  final Note note;

  @override
  Widget build(BuildContext context) {
    return TextField(
      focusNode: focus,
      cursorColor: Theme.of(context).primaryColor,
      controller: controller,
      maxLines: null,
      scrollController: ScrollController(),
      onChanged: (title) {
        setState(() {
          context.read(noteProvider.notifier).updateNote(note: note, title: title, lastEditDate: DateTime.now());
        });
      },
      style: Theme.of(context).textTheme.headline3,
      decoration: InputDecoration(
        hintText: 'Title',
        fillColor: CantonColors.transparent,
        border: InputBorder.none,
        enabledBorder: InputBorder.none,
        errorBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
        disabledBorder: InputBorder.none,
        focusedErrorBorder: InputBorder.none,
        hintStyle:
            Theme.of(context).textTheme.headline3!.copyWith(color: Theme.of(context).colorScheme.secondaryVariant),
      ),
    );
  }
}
