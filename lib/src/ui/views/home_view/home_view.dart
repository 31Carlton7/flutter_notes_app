import 'package:canton_design_system/canton_design_system.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:notes_app/src/models/note.dart';
import 'package:notes_app/src/ui/components/search_bar.dart';
import 'package:notes_app/src/ui/providers/note_provider.dart';
import 'package:notes_app/src/ui/components/note_card.dart';
import 'package:notes_app/src/ui/views/home_view/components/home_view_header.dart';
import 'package:notes_app/src/ui/views/home_view/components/tag_card.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  List<Note>? noteList;

  @override
  void initState() {
    super.initState();
    _getNotes();
  }

  void _getNotes() async {
    await context.read(noteProvider.notifier).loadData();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return CantonScaffold(
      backgroundColor: CantonMethods.alternateCanvasColor(context),
      body: _content(
        context,
        [null, []].contains(noteList) ? context.read(noteProvider) : noteList,
      ),
    );
  }

  Widget _content(BuildContext context, List<Note>? noteList) {
    return Column(
      children: [
        HomeViewHeader(setState: setState),
        SizedBox(height: 10),
        _body(context, noteList!),
      ],
    );
  }

  Widget _body(BuildContext context, List<Note>? noteList) {
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

  List<Widget> _notes(BuildContext context, List<Note> noteList) {
    bool _hasPinnedNotes = false;

    for (final note in noteList) {
      if (note.pinned == true) {
        _hasPinnedNotes = true;
      }
    }

    List<Widget> _notes = [
      SearchBar(searchNotes: _searchNotes, tagList: _listOfTags(context)),
      SizedBox(height: 10),
      _hasPinnedNotes
          ? Container(
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              child: Text('Pinned', style: Theme.of(context).textTheme.headline6))
          : Container(),
    ];

    for (int i = 0; i < noteList.length; i++) {
      var note = noteList[i];
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

    return _notes;
  }

  void _searchNotes(String query) {
    final newNoteList = context.read(noteProvider).where((note) {
      String tagsString = '';
      note.tags!.forEach((element) {
        tagsString += element.name!;
      });
      String searchText = note.title! + tagsString;
      return searchText.toLowerCase().contains(query.toLowerCase());
    }).toList();

    setState(() {
      if (newNoteList.isEmpty) {
        noteList = context.read(noteProvider);
      } else {
        noteList = newNoteList;
      }
    });
  }

  List<Widget> _listOfTags(BuildContext context) {
    List<Widget> _tagCards = [];
    List<Tag> _tags = [];

    for (var note in noteList ?? context.read(noteProvider)) {
      for (var tag in note.tags!) {
        if (!_tags.contains(tag)) _tags.add(tag);
      }
    }

    for (var tag in _tags) {
      _tagCards.add(TagCard(tag: tag, setState: setState));
      _tagCards.add(const SizedBox(width: 5));
    }

    return _tagCards;
  }
}
