import 'package:canton_design_system/canton_design_system.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notes_app/src/ui/providers/note_provider.dart';

class TotalNotesCreatedCard extends StatelessWidget {
  const TotalNotesCreatedCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(0),
      shape: SquircleBorder(
        radius: BorderRadius.vertical(top: Radius.circular(45)),
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
              'Total Notes Created',
              style: Theme.of(context).textTheme.headline5,
            ),
            Spacer(),
            Consumer(
              builder: (context, watch, child) {
                final repo = watch(noteProvider);
                return Text(
                  repo.length.toString(),
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
