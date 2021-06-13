// ignore: import_of_legacy_library_into_null_safe
import 'package:canton_design_system/canton_design_system.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:notes_app/src/models/note.dart';
import 'package:notes_app/src/ui/providers/note_provider.dart';
import 'package:notes_app/src/ui/styled_components/note_card.dart';
import 'package:notes_app/src/ui/views/note_creation_view.dart';

class TagView extends StatefulWidget {
  const TagView(this.tag);

  final Tag tag;

  @override
  _TagViewState createState() => _TagViewState();
}

class _TagViewState extends State<TagView> {
  List<Note>? noteList;

  @override
  Widget build(BuildContext context) {
    return CantonScaffold(
      body: _content(
        context,
        [null, []].contains(noteList)
            ? context
                .read(noteProvider)
                .where((element) => element.tags!.contains(widget.tag))
                .toList()
            : noteList,
      ),
    );
  }

  Widget _content(BuildContext context, List<Note>? noteList) {
    return Column(
      children: [
        _header(context),
        SizedBox(height: 10),
        _body(context, noteList!),
      ],
    );
  }

  Widget _header(BuildContext context) {
    return ViewHeaderTwo(
      title: widget.tag.name,
      backButton: true,
      isBackButtonClear: false,
      buttonTwo: CantonHeaderButton(
        icon: Icon(
          FeatherIcons.plus,
          color: CantonColors.white,
          size: 27,
        ),
        // backgroundColor: CantonColors.transparent,
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: () => CantonMethods.viewTransition(
          context,
          NoteCreationView(note: Note(tags: [widget.tag])),
        ).then((value) => {setState(() {})}),
      ),
    );
  }

  Widget _body(BuildContext context, List<Note>? noteList) {
    List<Widget> _notes(BuildContext context, List<Note> noteList) {
      bool _hasPinnedNotes = false;

      for (final note in noteList) {
        if (note.pinned == true) {
          _hasPinnedNotes = true;
        }
      }

      List<Widget> _notes = [
        _searchBar(context),
        SizedBox(height: 10),
        _hasPinnedNotes
            ? Container(
                margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                child: Text(
                  'Pinned',
                  style: Theme.of(context).textTheme.headline6,
                ),
              )
            : Container(),
      ];

      for (final note in noteList) {
        if (note.pinned == true) {
          _notes.add(NoteCard(note, setState));
        }
      }

      _notes.add(
        _hasPinnedNotes &&
                noteList
                        .where((element) => element.pinned! == false)
                        .toList()
                        .length >
                    0
            ? Container(
                margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                child:
                    Text('Notes', style: Theme.of(context).textTheme.headline6),
              )
            : Container(),
      );

      for (final note in noteList) {
        if ([null, false].contains(note.pinned)) {
          _notes.add(NoteCard(note, setState));
        }
      }

      return _notes;
    }

    return Expanded(
      child: !(noteList?.length == 0)
          ? ListView(
              children: _notes(context, noteList!),
            )
          : Center(
              child: Text(
                'No notes',
                style: Theme.of(context).textTheme.headline4?.copyWith(
                      color: Theme.of(context).colorScheme.secondaryVariant,
                    ),
              ),
            ),
    );
  }

  Widget _searchBar(BuildContext context) {
    return Consumer(
      builder: (context, watch, child) {
        return CantonTextInput(
          obscureText: false,
          isTextFormField: false,
          hintText: 'Search notes in ${widget.tag.name}',
          prefixIcon: IconlyIcon(
            IconlyBold.Search,
            size: 20,
            color: Theme.of(context).colorScheme.secondaryVariant,
          ),
          onChanged: (string) {
            _searchNotes(string);
          },
        );
      },
    );
  }

  void _searchNotes(String query) {
    final newNoteList = context
        .read(noteProvider)
        .where((element) => element.tags!.contains(widget.tag))
        .toList()
        .where((note) {
      return note.title!.toLowerCase().contains(query.toLowerCase());
    }).toList();

    setState(() {
      if (newNoteList.isEmpty) {
        noteList = context
            .read(noteProvider)
            .where((element) => element.tags!.contains(widget.tag))
            .toList();
      } else {
        noteList = newNoteList;
      }
    });
  }
}
