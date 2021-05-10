import 'package:canton_design_system/canton_design_system.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:notes_app/domain/note_repository/note_repository.dart';
import 'package:notes_app/src/models/note.dart';

class PinNoteAction extends StatelessWidget {
  final Note note;
  final NoteRepository repo;

  const PinNoteAction(this.repo, this.note);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 5, bottom: 5),
      child: Material(
        color: CantonColors.yellow,
        shape: SquircleBorder(
          radius: 35,
        ),
        child: SlideAction(
          child: Icon(
            note.pinned
                ? CupertinoIcons.pin_slash_fill
                : CupertinoIcons.pin_fill,
            size: 27,
            color: CantonColors.gray[100],
          ),
          onTap: () {
            repo.updateNote(note: note, pinned: !note.pinned);
          },
        ),
      ),
    );
  }
}
