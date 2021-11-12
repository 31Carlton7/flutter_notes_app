import 'package:canton_design_system/canton_design_system.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notes_app/src/models/note.dart';
import 'package:notes_app/src/repositories/note_repository.dart';

class NoteCreationViewHeader extends ConsumerWidget {
  const NoteCreationViewHeader({required this.note, required this.completeNoteFunction, Key? key}) : super(key: key);

  final Note note;
  final void Function(ScopedReader) completeNoteFunction;

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    return ViewHeaderTwo(
      title: NoteRepository.dateTimeString(
        note.lastEditDate ?? DateTime.now(),
      ),
      backButton: true,
      backButtonFunction: () => completeNoteFunction(watch),
    );
  }
}
