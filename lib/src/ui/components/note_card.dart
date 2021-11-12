import 'package:canton_design_system/canton_design_system.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'package:notes_app/src/models/note.dart';
import 'package:notes_app/src/repositories/note_repository.dart';
import 'package:notes_app/src/ui/functions/note_card_functions/delete_note_action.dart';
import 'package:notes_app/src/ui/functions/note_card_functions/pin_note_action.dart';
import 'package:notes_app/src/ui/providers/note_provider.dart';
import 'package:notes_app/src/ui/views/note_creation_view/note_creation_view.dart';

class NoteCard extends StatelessWidget {
  const NoteCard({Key? key, required this.note, required this.noteList, required this.setState}) : super(key: key);

  final Note note;
  final List<Note> noteList;
  final void Function(void Function()) setState;

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, watch, child) {
        return GestureDetector(
          onTap: () {
            CantonMethods.viewTransition(
              context,
              NoteCreationView(note: note),
            ).then((value) => setState(() {}));
          },
          child: Slidable(
            key: UniqueKey(),
            actionPane: SlidableDrawerActionPane(),
            actionExtentRatio: 0.25,
            dismissal: SlidableDismissal(
              child: SlidableDrawerDismissal(),
              dismissThresholds: <SlideActionType, double>{SlideActionType.primary: 1.0},
              onDismissed: (direction) {
                if (direction == SlideActionType.secondary)
                  setState(() {
                    context.read(noteProvider.notifier).removeNote(note);
                  });
              },
            ),
            actions: <Widget>[PinNoteAction(note, setState)],
            secondaryActions: <Widget>[DeleteNoteAction(note, setState)],
            child: Card(
              elevation: 0,
              shape: SquircleBorder(
                side: BorderSide(color: CantonColors.borderPrimary!),
                radius: _cardRadius(),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
                child: _body(context),
              ),
            ),
          ),
        );
      },
    );
  }

  BorderRadius _cardRadius() {
    var pinnedList = noteList.where((element) => element.pinned!).toList();
    var normalList = noteList.where((element) => !element.pinned!).toList();

    if (pinnedList.isNotEmpty) {
      if (note.id == pinnedList.last.id && pinnedList.length > 1) {
        return BorderRadius.vertical(bottom: Radius.circular(33));
      } else if (note.id == pinnedList.first.id && pinnedList.length > 1) {
        return BorderRadius.vertical(top: Radius.circular(33));
      } else if (pinnedList.contains(note) && pinnedList.length == 1) {
        return BorderRadius.circular(33);
      }
    }

    if (note.id == normalList.last.id && normalList.length > 1) {
      return BorderRadius.vertical(bottom: Radius.circular(33));
    } else if (note.id == normalList.first.id && normalList.length > 1) {
      return BorderRadius.vertical(top: Radius.circular(33));
    } else if (normalList.length == 1) {
      return BorderRadius.circular(33);
    }

    return BorderRadius.zero;
  }

  String _tagName(String string) {
    if (string.length > 12 && string.length > 2) {
      return string.substring(0, 12) + '...';
    } else {
      return string;
    }
  }

  String _titleText(String string) {
    if (['', null].contains(string)) {
      return _contentText(note.content!);
    } else {
      if (string.split(' ').length > 10) {
        return CantonMethods.addDotsToString(note.title!, 10);
      } else {
        return string;
      }
    }
  }

  String _contentText(String string) {
    if (note.content!.split(' ').length > 10) {
      return CantonMethods.addDotsToString(note.content!, 10);
    } else {
      if (!(note.content! == '')) {
        return note.content!;
      } else {
        return 'No additional text';
      }
    }
  }

  Widget _body(BuildContext context) {
    // Creates tags on the note card.
    List<Widget> _tags = [];

    for (var tag in note.tags!) {
      _tags.add(
        Row(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryVariant,
                borderRadius: SmoothBorderRadius(cornerRadius: 5, cornerSmoothing: 1),
              ),
              padding: const EdgeInsets.all(4.0),
              child: Text(
                _tagName(tag.name!),
                style: Theme.of(context).textTheme.bodyText2?.copyWith(color: Theme.of(context).primaryColor),
              ),
            ),
            const SizedBox(width: 5),
          ],
        ),
      );
    }

    if (_tags.length > 3) {
      _tags.removeRange(3, _tags.length);
      _tags.add(
        Card(
          color: Theme.of(context).primaryColor,
          shape: SquircleBorder(radius: BorderRadius.circular(15)),
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Text(
              'more',
              style: Theme.of(context).textTheme.bodyText2?.copyWith(color: CantonColors.white),
            ),
          ),
        ),
      );
    }

    return Row(
      children: <Widget>[
        [null, false].contains(note.pinned)
            ? Container()
            : Icon(
                CupertinoIcons.pin_fill,
                size: 15,
                color: Theme.of(context).colorScheme.secondaryVariant,
              ),
        SizedBox(width: 7),
        Expanded(
          flex: 10,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(_titleText(note.title!), style: Theme.of(context).textTheme.headline6!),
              const SizedBox(height: 7),
              note.tags!.length > 0
                  ? Row(
                      children: _tags,
                    )
                  : Container(),
              note.tags!.length > 0 ? const SizedBox(height: 7) : Container(),
              Text(_contentText(note.content!), style: Theme.of(context).textTheme.bodyText1!),
            ],
          ),
        ),
        Spacer(),
        Text(
          NoteRepository.dateTimeString(note.lastEditDate!).substring(6),
          textAlign: TextAlign.right,
          style: Theme.of(context).textTheme.bodyText2!.copyWith(color: CantonColors.textTertiary),
        ),
      ],
    );
  }

  /// UNUSED
  ///
  /// Alters the note content to display the Title and content apropriately.
  /// It works the way the Apple Notes app or Google Keep app works where
  /// the first part of the note is the title and the rest is considered the
  /// content. If the content has more than 10 words it'll cut it and follow
  /// up with "...".
  /// This part is unused as I was hoping to integrate a rich text editor however
  /// that functionality is simply not possible in native dart/flutter code.

  // ignore: unused_element
  String _noteTitleText(List<String> contentWordList) {
    if (note.content!.trimLeft().contains('\n')) {
      if (contentWordList.length >= 10) {
        return CantonMethods.addDotsToString(note.content!.trimLeft().substring(0, note.content!.indexOf('\n')), 10);
      } else {
        return note.content!.trimLeft().substring(0, note.content!.indexOf('\n'));
      }
    } else {
      if (contentWordList.length >= 10) {
        return CantonMethods.addDotsToString(note.content!.trimLeft(), 10);
      } else {
        return note.content!.trimLeft();
      }
    }
  }

  // ignore: unused_element
  String _noteContentText(List<String> contentWordList) {
    if (note.content!.contains('\n') && (contentWordList.join(' ').trim() != _noteTitleText(contentWordList))) {
      String s = note.content!.substring(note.content!.indexOf('\n')).trim().replaceAll(new RegExp(r'\s+'), ' ');
      if (s.split(' ').length >= 10) {
        return CantonMethods.addDotsToString(s, 10);
      } else {
        return s;
      }
    } else {
      return 'No additional text';
    }
  }
}
