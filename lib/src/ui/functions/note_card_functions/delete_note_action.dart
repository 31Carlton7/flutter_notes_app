import 'package:canton_design_system/canton_design_system.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:notes_app/domain/note_repository/note_repository.dart';
import 'package:notes_app/src/models/note.dart';

class DeleteNoteAction extends StatelessWidget {
  const DeleteNoteAction(this.repo, this.note);
  final NoteRepository repo;
  final Note note;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 5, bottom: 5, left: 5),
      child: Material(
        color: CantonColors.bgDangerInverse,
        shape: SquircleBorder(
          radius: 35,
        ),
        child: SlideAction(
            child: Icon(
              FeatherIcons.trash,
              size: 27,
              color: CantonColors.gray[100],
            ),
            onTap: () => repo.removeNote(note)),
      ),
    );
  }
}
