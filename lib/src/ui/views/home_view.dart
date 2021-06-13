// ignore: import_of_legacy_library_into_null_safe
import 'package:canton_design_system/canton_design_system.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:notes_app/src/models/note.dart';
import 'package:notes_app/src/ui/providers/note_provider.dart';
import 'package:notes_app/src/ui/styled_components/note_card.dart';
import 'package:notes_app/src/ui/views/note_creation_view.dart';
import 'package:notes_app/src/ui/views/profile_view.dart';
import 'package:notes_app/src/ui/views/tag_view.dart';

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
      body: _content(
        context,
        [null, []].contains(noteList) ? context.read(noteProvider) : noteList,
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
      title: 'Notes',
      backButton: false,
      buttonOne: CantonHeaderButton(
        backgroundColor: CantonColors.transparent,
        icon: IconlyIcon(
          IconlyBold.Profile,
          color: Theme.of(context).primaryColor,
          size: 27,
        ),
        onPressed: () => CantonMethods.viewTransition(
          context,
          ProfileView(),
        ),
      ),
      buttonTwo: CantonHeaderButton(
        icon: Icon(
          FeatherIcons.plus,
          color: Theme.of(context).primaryColor,
          size: 27,
        ),
        backgroundColor: CantonColors.transparent,
        onPressed: () => CantonMethods.viewTransition(
          context,
          NoteCreationView(note: Note()),
        ).then((value) => {setState(() {})}),
      ),
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
      _searchBar(context),
      SizedBox(height: 10),
      _hasPinnedNotes
          ? Container(
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              child:
                  Text('Pinned', style: Theme.of(context).textTheme.headline6))
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
                  Text('Notes', style: Theme.of(context).textTheme.headline6))
          : Container(),
    );

    for (final note in noteList) {
      if ([null, false].contains(note.pinned)) {
        _notes.add(NoteCard(note, setState));
      }
    }

    return _notes;
  }

  Widget _searchBar(BuildContext context) {
    return Consumer(
      builder: (context, watch, child) {
        return Column(
          children: [
            CantonTextInput(
              obscureText: false,
              isTextFormField: false,
              hintText: 'Search notes',
              radius: _listOfTags(context).isNotEmpty
                  ? const BorderRadius.vertical(
                      top: const Radius.circular(45),
                    )
                  : null,
              prefixIcon: IconlyIcon(
                IconlyBold.Search,
                size: 20,
                color: Theme.of(context).colorScheme.secondaryVariant,
              ),
              onChanged: (string) {
                _searchNotes(string);
              },
            ),
            _listOfTags(context).isNotEmpty
                ? Container(
                    decoration: ShapeDecoration(
                      color: Theme.of(context).colorScheme.secondary,
                      shape: SquircleBorder(
                        radius: const BorderRadius.vertical(
                          bottom: const Radius.circular(45),
                        ),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: SizedBox(
                        height: 26,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: _listOfTags(context),
                        ),
                      ),
                    ),
                  )
                : Container(),
          ],
        );
      },
    );
  }

  void _searchNotes(String query) {
    final newNoteList = context.read(noteProvider).where((note) {
      String tagsString = '';
      note.tags!.forEach((element) {
        tagsString += element.name;
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

    for (var tag in _tags) _tagCards.add(_tagCard(context, tag));

    return _tagCards;
  }

  Widget _tagCard(BuildContext context, Tag tag) {
    return GestureDetector(
      onTap: () => CantonMethods.viewTransition(context, TagView(tag))
          .then((value) => setState(() {})),
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 5),
        color: Theme.of(context).primaryColor,
        shape: SquircleBorder(radius: BorderRadius.circular(15)),
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Text(
            tag.name,
            style: Theme.of(context)
                .textTheme
                .bodyText2
                ?.copyWith(color: CantonColors.white),
          ),
        ),
      ),
    );
  }
}
