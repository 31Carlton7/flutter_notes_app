import 'package:canton_design_system/canton_design_system.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:notes_app/src/models/note.dart';
import 'package:notes_app/src/ui/components/note_card.dart';
import 'package:notes_app/src/ui/components/search_bar.dart';
import 'package:notes_app/src/ui/providers/note_provider.dart';
import 'package:notes_app/src/ui/views/tag_view/components/tag_view_header.dart';

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
      backgroundColor: CantonMethods.alternateCanvasColor(context),
      body: _content(
        context,
        [null, []].contains(noteList)
            ? context.read(noteProvider).where((element) => element.tags!.contains(widget.tag)).toList()
            : noteList,
      ),
    );
  }

  Widget _content(BuildContext context, List<Note>? noteList) {
    return Column(
      children: [
        TagViewHeader(tag: widget.tag, setState: setState),
        SizedBox(height: 10),
        _body(context, noteList!),
      ],
    );
  }

  Widget _body(BuildContext context, List<Note>? noteList) {
    bool _hasPinnedNotes = false;

    for (final note in noteList!) {
      if (note.pinned == true) {
        _hasPinnedNotes = true;
      }
    }

    List<Widget> _notes = [
      SearchBar(tag: widget.tag, searchNotes: _searchNotes),
      SizedBox(height: 10),
      _hasPinnedNotes
          ? Container(
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              child: Text('Pinned', style: Theme.of(context).textTheme.headline6))
          : Container(),
    ];

    for (int i = 0; i < noteList.length; i++) {
      final note = noteList[i];
      if (note.pinned == true) {
        _notes.add(NoteCard(note: note, noteList: noteList, setState: setState));
      }
    }

    _notes.add(
      _hasPinnedNotes && noteList.where((element) => element.pinned! == false).toList().length > 0
          ? Container(
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              child: Text('Notes', style: Theme.of(context).textTheme.headline6))
          : Container(),
    );

    for (int i = 0; i < noteList.length; i++) {
      final note = noteList[i];
      if ([null, false].contains(note.pinned)) {
        _notes.add(NoteCard(note: note, noteList: noteList, setState: setState));
      }
    }

    return Expanded(
      child: !(_notes.length == 0)
          ? ListView(children: _notes)
          : Center(
              child: Text(
                'No notes',
                style: Theme.of(context)
                    .textTheme
                    .headline4
                    ?.copyWith(color: Theme.of(context).colorScheme.secondaryVariant),
              ),
            ),
    );
  }

  void _searchNotes(String query) {
    final newNoteList =
        context.read(noteProvider).where((element) => element.tags!.contains(widget.tag)).toList().where((note) {
      return note.title!.toLowerCase().contains(query.toLowerCase());
    }).toList();

    setState(() {
      if (newNoteList.isEmpty) {
        noteList = context.read(noteProvider).where((element) => element.tags!.contains(widget.tag)).toList();
      } else {
        noteList = newNoteList;
      }
    });
  }
}
