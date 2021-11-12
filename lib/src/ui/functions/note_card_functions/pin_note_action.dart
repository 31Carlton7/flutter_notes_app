import 'package:canton_design_system/canton_design_system.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notes_app/src/models/note.dart';
import 'package:notes_app/src/ui/providers/note_provider.dart';

class PinNoteAction extends ConsumerWidget {
  const PinNoteAction(this.note, this.setState);

  final Note note;
  final void Function(void Function()) setState;

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    return Container(
      margin: EdgeInsets.only(right: 10),
      child: SlideAction(
        decoration: ShapeDecoration(
          color: Theme.of(context).colorScheme.onSurface,
          shape: SquircleBorder(
            radius: BorderRadius.circular(35),
          ),
        ),
        child: Icon(
          note.pinned! ? CupertinoIcons.pin_slash_fill : CupertinoIcons.pin_fill,
          size: 27,
          color: Theme.of(context).colorScheme.surface,
        ),
        onTap: () {
          setState(() {
            watch(noteProvider.notifier).updateNote(note: note, pinned: !note.pinned!);
          });
        },
      ),
    );
  }
}
