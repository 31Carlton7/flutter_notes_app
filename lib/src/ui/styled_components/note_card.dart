import 'package:canton_design_system/canton_design_system.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:notes_app/domain/note_repository/note_repository.dart';
import 'package:notes_app/src/models/note.dart';
import 'package:notes_app/src/ui/functions/note_card_functions/delete_note_action.dart';
import 'package:notes_app/src/ui/functions/note_card_functions/pin_note_action.dart';
import 'package:notes_app/src/ui/functions/note_card_functions/unlock_note.dart';
import 'package:notes_app/src/ui/providers/note_provider.dart';

class NoteCard extends ConsumerWidget {
  final Note note;
  const NoteCard({Key key, @required this.note}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final repo = watch(noteProvider.notifier);

    return GestureDetector(
      onTap: () => UnlockNote(context, note),
      child: Slidable(
        key: UniqueKey(),
        actionPane: SlidableDrawerActionPane(),
        actionExtentRatio: 0.25,
        dismissal: SlidableDismissal(
          child: SlidableDrawerDismissal(),
          dismissThresholds: <SlideActionType, double>{
            SlideActionType.primary: 1.0
          },
          onDismissed: (direction) {
            if (direction == SlideActionType.secondary)
              DeleteNoteAction(repo, note);
            if (direction == SlideActionType.primary) PinNoteAction(repo, note);
          },
        ),
        actions: <Widget>[
          PinNoteAction(repo, note),
        ],
        secondaryActions: <Widget>[
          DeleteNoteAction(repo, note),
        ],
        child: Card(
          elevation: 0,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
            child: _body(context),
          ),
        ),
      ),
    );
  }

  Widget _body(BuildContext context) {
    List<String> contentWordList =
        note.content.replaceAll(new RegExp(r'\s+'), ' ').split(' ');

    return Row(
      children: <Widget>[
        Column(
          children: [
            [null, false].contains(note.pinned)
                ? Container()
                : Icon(
                    CupertinoIcons.pin_fill,
                    size: 15,
                    color: CantonColors.iconTertiary,
                  ),
            note.locked ? SizedBox(height: 7) : Container(),
            [null, false].contains(note.locked)
                ? Container()
                : Icon(
                    CupertinoIcons.lock_fill,
                    size: 15,
                    color: CantonColors.iconTertiary,
                  ),
          ],
        ),
        SizedBox(width: 7),
        Expanded(
          flex: 10,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                noteTitleText(contentWordList),
                style: Theme.of(context)
                    .textTheme
                    .headline6
                    .copyWith(color: CantonColors.textPrimary),
              ),
              const SizedBox(height: 7),
              Text(
                [null, false].contains(note.locked)
                    ? noteContentText(contentWordList)
                    : 'Locked Note',
                style: Theme.of(context)
                    .textTheme
                    .bodyText1
                    .copyWith(color: CantonColors.textPrimary),
              ),
            ],
          ),
        ),
        Spacer(),
        Text(
          NoteRepository.dateTimeString(note.lastEditDate).substring(6),
          textAlign: TextAlign.right,
          style: Theme.of(context)
              .textTheme
              .bodyText2
              .copyWith(color: CantonColors.textTertiary),
        ),
      ],
    );
  }

  /// Alters the note content to display the Title and content apropriately.
  /// It works the way the Apple Notes app or Google Keep app works where
  /// the first part of the note is the title and the rest is considered the
  /// content. If the content has more than 10 words it'll cut it and follow
  /// up with "...".

  String noteTitleText(List<String> contentWordList) {
    if (note.content.trimLeft().contains('\n')) {
      if (contentWordList.length >= 10) {
        return CantonMethods.addDotsToString(
            note.content.trimLeft().substring(0, note.content.indexOf('\n')),
            10);
      } else {
        return note.content.trimLeft().substring(0, note.content.indexOf('\n'));
      }
    } else {
      if (contentWordList.length >= 10) {
        return CantonMethods.addDotsToString(note.content.trimLeft(), 10);
      } else {
        return note.content.trimLeft();
      }
    }
  }

  String noteContentText(List<String> contentWordList) {
    if (note.content.contains('\n') &&
        (contentWordList.join(' ').trim() != noteTitleText(contentWordList))) {
      String s = note.content
          .substring(note.content.indexOf('\n'))
          .trim()
          .replaceAll(new RegExp(r'\s+'), ' ');
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
