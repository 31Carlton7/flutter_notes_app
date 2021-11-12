import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:canton_design_system/canton_design_system.dart';
import 'package:notes_app/src/repositories/note_repository.dart';
import 'package:notes_app/src/ui/providers/note_provider.dart';

class DateOfFirstNoteCard extends StatelessWidget {
  const DateOfFirstNoteCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(0),
      shape: SquircleBorder(
        radius: BorderRadius.vertical(bottom: Radius.circular(45)),
        side: BorderSide(
          color: CantonColors.transparent,
          width: 1.5,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 17, vertical: 15),
        child: Row(
          children: [
            Text(
              'Date of first note',
              style: Theme.of(context).textTheme.headline5,
            ),
            Spacer(),
            Consumer(
              builder: (context, watch, child) {
                final repo = watch(noteProvider);

                if (repo.isNotEmpty) {
                  context.read(noteProvider).sort((a, b) => b.creationDate!.compareTo(a.creationDate!));

                  String date = NoteRepository.dateTimeString(
                          context.read(noteProvider)[context.read(noteProvider).length - 1].creationDate!)
                      .substring(6);

                  return Text(
                    date,
                    style: Theme.of(context).textTheme.headline5,
                  );
                } else {
                  return Text(
                    '😢',
                    style: Theme.of(context).textTheme.headline5,
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
