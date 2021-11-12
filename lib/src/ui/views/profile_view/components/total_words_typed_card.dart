import 'package:canton_design_system/canton_design_system.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notes_app/src/models/note.dart';
import 'package:notes_app/src/ui/providers/note_provider.dart';

class TotalWordsTypedCard extends StatelessWidget {
  const TotalWordsTypedCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(0),
      shape: SquircleBorder(
        radius: BorderRadius.circular(0),
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
              'Total Words Typed',
              style: Theme.of(context).textTheme.headline5,
            ),
            Spacer(),
            Consumer(
              builder: (context, watch, child) {
                final repo = watch(noteProvider);
                int totalWords = 0;
                for (Note note in repo) {
                  totalWords += note.content!.trim().replaceAll(new RegExp(r'\s+'), ' ').split(' ').length;
                }
                return Text(
                  totalWords.toString(),
                  style: Theme.of(context).textTheme.headline5,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
