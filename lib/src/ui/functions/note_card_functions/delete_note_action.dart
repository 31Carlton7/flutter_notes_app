import 'package:canton_design_system/canton_design_system.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notes_app/src/models/note.dart';
import 'package:notes_app/src/ui/providers/note_provider.dart';

class DeleteNoteAction extends ConsumerWidget {
  const DeleteNoteAction(this.note, this.setState);

  final Note note;
  final void Function(void Function()) setState;

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    return Container(
      margin: EdgeInsets.only(left: 10),
      child: SlideAction(
        decoration: ShapeDecoration(
          color: Theme.of(context).colorScheme.onError,
          shape: SquircleBorder(
            radius: BorderRadius.circular(35),
          ),
        ),
        child: IconlyIcon(
          IconlyBold.Delete,
          size: 27,
          color: Theme.of(context).colorScheme.error,
        ),
        onTap: () {
          setState(() {
            watch(noteProvider.notifier).removeNote(note);
          });
        },
      ),
    );
  }
}
