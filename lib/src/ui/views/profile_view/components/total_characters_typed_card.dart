import 'package:canton_design_system/canton_design_system.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notes_app/src/models/note.dart';
import 'package:notes_app/src/ui/providers/note_provider.dart';

class TotalCharactersTypedCard extends StatelessWidget {
  const TotalCharactersTypedCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(0),
      shape: SquircleBorder(),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 17, vertical: 15),
        child: Row(
          children: [
            Text(
              'Total Characters Typed',
              style: Theme.of(context).textTheme.headline5,
            ),
            Spacer(),
            Consumer(
              builder: (context, watch, child) {
                final repo = watch(noteProvider);
                int totalCharacters = 0;
                for (Note note in repo) {
                  totalCharacters += note.content!.trim().replaceAll(new RegExp(r'\s+'), ' ').split('').length +
                      note.title!.trim().replaceAll(new RegExp(r'\s+'), ' ').split('').length;
                }
                return Text(
                  totalCharacters.toString(),
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
