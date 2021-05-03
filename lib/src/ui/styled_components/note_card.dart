import 'package:canton_design_system/canton_design_system.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:notes_app/domain/note_repository/note_repository.dart';
import 'package:notes_app/src/models/note.dart';
import 'package:notes_app/src/ui/providers/note_provider.dart';
import 'package:notes_app/src/ui/views/note_creation_view.dart';

class NoteCard extends ConsumerWidget {
  final Note note;
  const NoteCard({Key key, @required this.note}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final repo = watch(noteProvider.notifier);

    return GestureDetector(
      onTap: () {
        TextEditingController _passwordController = TextEditingController();
        bool _incorrect = false;
        if (note.locked) {
          showDialog(
            context: context,
            builder: (_) => AlertDialog(
              shape: SquircleBorder(radius: 55),
              title: Text(
                'Configure Lock',
                style: Theme.of(context).textTheme.headline4,
              ),
              content: StatefulBuilder(
                builder: (context, setState) => Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Enter the password for this note',
                      style: Theme.of(context)
                          .textTheme
                          .headline6
                          .copyWith(color: CantonColors.textSecondary),
                    ),
                    SizedBox(height: 7),
                    CantonTextInput(
                      obscureText: true,
                      isTextFormField: true,
                      isTextInputTwo: true,
                      controller: _passwordController,
                      textInputType: TextInputType.number,
                      onChanged: (_) => print(_),
                    ),
                    SizedBox(height: 10),
                    _incorrect
                        ? Text(
                            'Incorrect Password',
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1
                                .copyWith(color: CantonColors.textDanger),
                          )
                        : Container(),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        CantonPrimaryButton(
                          buttonText: 'Cancel',
                          containerColor: CantonColors.bgDanger,
                          textColor: CantonColors.textDanger,
                          containerWidth:
                              MediaQuery.of(context).size.width / 2 - 70,
                          onPressed: () {
                            _passwordController = TextEditingController();
                            Navigator.pop(context);
                          },
                        ),
                        Spacer(),
                        CantonPrimaryButton(
                          buttonText: 'Done',
                          containerColor: CantonColors.bgInverse,
                          textColor: CantonColors.bgPrimary,
                          containerWidth:
                              MediaQuery.of(context).size.width / 2 - 70,
                          onPressed: () {
                            if (_passwordController.text == note.password) {
                              _incorrect = false;
                              Navigator.of(context).pop();
                              CantonMethods.viewTransition(
                                context,
                                NoteCreationView(note: note),
                              );
                            } else {
                              setState(() {
                                _incorrect = true;
                              });
                            }
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        } else {
          CantonMethods.viewTransition(
            context,
            NoteCreationView(note: note),
          );
        }
      },
      child: Slidable(
        key: UniqueKey(),
        actionPane: SlidableDrawerActionPane(),
        actionExtentRatio: 0.25,
        dismissal: SlidableDismissal(
          child: SlidableDrawerDismissal(),
          onDismissed: (direction) {
            if (direction == SlideActionType.secondary) repo.removeNote(note);
          },
        ),
        actions: [
          _pinNoteSlidableAction(repo),
        ],
        secondaryActions: <Widget>[
          _deleteNoteSlidableAction(repo),
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

  Future<Widget> unlockNoteBottomSheet(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: cantonGrey[100],
        elevation: 0,
        useRootNavigator: true,
        shape: SquircleBorder(radius: 55),
        builder: (context) {
          return;
        });
  }

  Widget _deleteNoteSlidableAction(NoteRepository repo) {
    return Container(
      margin: EdgeInsets.only(top: 5, bottom: 5, left: 5),
      child: Material(
        color: CantonColors.bgDangerInverse,
        shape: SquircleBorder(
          radius: 35,
        ),
        child: SlideAction(
            child: Icon(
              FeatherIcons.trash,
              size: 27,
              color: CantonColors.gray[100],
            ),
            onTap: () => repo.removeNote(note)),
      ),
    );
  }

  Widget _pinNoteSlidableAction(NoteRepository repo) {
    return Container(
      margin: EdgeInsets.only(top: 5, bottom: 5),
      child: Material(
        color: CantonColors.yellow,
        shape: SquircleBorder(
          radius: 35,
        ),
        child: SlideAction(
          child: Icon(
            note.pinned
                ? CupertinoIcons.pin_slash_fill
                : CupertinoIcons.pin_fill,
            size: 27,
            color: CantonColors.gray[100],
          ),
          onTap: () {
            repo.updateNote(note: note, pinned: !note.pinned);
          },
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
                [null, false].contains(note.locked)
                    ? noteTitleText(contentWordList)
                    : 'Locked',
                style: Theme.of(context)
                    .textTheme
                    .headline6
                    .copyWith(color: cantonGrey[900]),
              ),
              const SizedBox(height: 7),
              Text(
                [null, false].contains(note.locked)
                    ? noteContentText(contentWordList)
                    : 'Tap to Unlock',
                style: Theme.of(context)
                    .textTheme
                    .bodyText1
                    .copyWith(color: cantonGrey[900]),
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
              .copyWith(color: cantonGrey[600]),
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
