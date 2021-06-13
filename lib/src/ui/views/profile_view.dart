// ignore: import_of_legacy_library_into_null_safe
import 'package:canton_design_system/canton_design_system.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notes_app/src/models/note.dart';
import 'package:notes_app/src/services/repositories/note_repository.dart';
import 'package:notes_app/src/ui/providers/note_provider.dart';

class ProfileView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CantonScaffold(
      body: _content(context),
    );
  }

  Widget _content(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _header(context),
        _body(context),
        CantonHeaderButton(
          backgroundColor: CantonColors.transparent,
        ),
      ],
    );
  }

  Widget _header(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      CantonBackButton(
        isClear: true,
      ),
      Text(
        'Profile',
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.headline5!.copyWith(
              color: Theme.of(context).primaryColor,
            ),
      ),
      CantonHeaderButton(
        backgroundColor: CantonColors.transparent,
        icon: Container(),
        onPressed: () {},
      ),
    ]);
  }

  Widget _body(BuildContext context) {
    return Card(
      child: Column(
        children: [
          _totalNotesCreated(context),
          Divider(),
          _totalWordsTyped(context),
          Divider(),
          _totalCharactersTyped(context),
          Divider(),
          _dateOfFirstNote(context),
        ],
      ),
    );
  }

  // ignore: unused_element
  Widget _profile(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(backgroundColor: CantonColors.bgBackdrop, radius: 50),
        SizedBox(height: 7),
        Text('USER NAME', style: Theme.of(context).textTheme.headline4),
      ],
    );
  }

  Widget _totalNotesCreated(BuildContext context) {
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

  Widget _totalWordsTyped(BuildContext context) {
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
                  totalWords += note.content!
                      .trim()
                      .replaceAll(new RegExp(r'\s+'), ' ')
                      .split(' ')
                      .length;
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

  Widget _totalCharactersTyped(BuildContext context) {
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
                  totalCharacters += note.content!
                          .trim()
                          .replaceAll(new RegExp(r'\s+'), ' ')
                          .split('')
                          .length +
                      note.title!
                          .trim()
                          .replaceAll(new RegExp(r'\s+'), ' ')
                          .split('')
                          .length;
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

  Widget _dateOfFirstNote(BuildContext context) {
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
                  context.read(noteProvider).sort(
                      (a, b) => b.creationDate!.compareTo(a.creationDate!));

                  String date = NoteRepository.dateTimeString(context
                          .read(noteProvider)[
                              context.read(noteProvider).length - 1]
                          .creationDate!)
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
