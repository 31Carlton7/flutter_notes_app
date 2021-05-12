import 'package:canton_design_system/canton_design_system.dart';
import 'package:notes_app/src/models/note.dart';
import 'package:notes_app/src/ui/providers/note_provider.dart';
import 'package:notes_app/src/ui/styled_components/note_card.dart';
import 'package:notes_app/src/ui/views/note_creation_view.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notes_app/src/ui/views/profile_view.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  void initState() {
    super.initState();
    context.read(noteProvider.notifier).loadData();
  }

  @override
  Widget build(BuildContext context) {
    return CantonScaffold(
      body: _content(context),
    );
  }

  Widget _content(BuildContext context) {
    return Column(
      children: [
        _header(context),
        SizedBox(height: 10),
        Consumer(
          builder: (context, watch, child) {
            final noteList = watch(noteProvider);
            context.read(noteProvider.notifier).sortList();
            return _body(context, noteList);
          },
        ),
      ],
    );
  }

  Widget _header(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Text(
              'Notes',
              textAlign: TextAlign.end,
              style: Theme.of(context).textTheme.headline1.copyWith(
                    color: Theme.of(context).primaryColor,
                  ),
            ),
            Spacer(),
            CantonHeaderButton(
              icon: IconlyIcon(
                IconlyBold.Profile,
                color: CantonColors.iconTertiary,
                size: 27,
              ),
              onPressed: () => CantonMethods.viewTransition(
                context,
                ProfileView(),
              ),
            ),
            SizedBox(width: 10),
            CantonHeaderButton(
              icon: Icon(
                FeatherIcons.plus,
                color: CantonColors.bgPrimary,
                size: 27,
              ),
              backgroundColor: Theme.of(context).primaryColor,
              onPressed: () => CantonMethods.viewTransition(
                context,
                NoteCreationView(note: Note()),
              ),
            ),
          ],
        ),
        SizedBox(height: 7),
        Consumer(builder: (context, watch, child) {
          return CantonTextInput(
            isTextInputTwo: true,
            obscureText: false,
            hintText: 'Search notes',
            onChanged: (string) => _searchNotes(string, watch),
          );
        }),
      ],
    );
  }

  void _searchNotes(String query, ScopedReader watch) {
    setState(() {
      final newNoteList = watch(noteProvider).where((note) {
        String noteTitleText() {
          if (note.content.trimLeft().contains('\n')) {
            return note.content
                .trimLeft()
                .substring(0, note.content.indexOf('\n'));
          } else {
            if (note.content.split(' ').length >= 10) {
              return CantonMethods.addDotsToString(note.content.trimLeft(), 10);
            } else {
              return note.content.trimLeft().toLowerCase();
            }
          }
        }

        return noteTitleText().toLowerCase().contains(query);
      }).toList();
      _body(context, newNoteList);
    });
  }

  Widget _body(BuildContext context, List<Note> noteList) {
    context.read(noteProvider.notifier).sortList();
    List<Widget> notes = [];
    for (Note note in noteList) {
      ![null, false].contains(note.pinned)
          ? notes.insert(0, NoteCard(note: note))
          : notes.add(NoteCard(note: note));
    }
    return Expanded(
      child: noteList.length > 0
          ? ListView.builder(
              itemCount: notes.length,
              itemBuilder: (context, index) => notes[index],
            )
          : Center(
              child: Text(
                'No Notes',
                style: Theme.of(context)
                    .textTheme
                    .headline4
                    .copyWith(color: CantonColors.textTertiary),
              ),
            ),
    );
  }
}
