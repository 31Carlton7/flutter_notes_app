import 'package:canton_design_system/canton_design_system.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notes_app/domain/note_repository/note_repository.dart';
import 'package:notes_app/src/models/note.dart';
import 'package:notes_app/src/ui/providers/note_provider.dart';

class NoteCreationView extends StatefulWidget {
  final Note note;

  const NoteCreationView({Key key, this.note}) : super(key: key);
  @override
  _NoteCreationViewState createState() => _NoteCreationViewState();
}

class _NoteCreationViewState extends State<NoteCreationView> {
  final TextEditingController _contentController = TextEditingController();
  TextEditingController _passwordController;

  final FocusNode _contentFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();

  void newNoteFunction() {
    if (widget.note.id != null) {
      _contentController.text = widget.note.content;
      _passwordController = TextEditingController(text: widget.note.password);
    } else {
      _passwordController = TextEditingController();
    }
  }

  @override
  void initState() {
    super.initState();

    newNoteFunction();
  }

  @override
  Widget build(BuildContext context) {
    /// Requests focus on [TextField] if id is null
    if (widget.note.id == null) {
      FocusScope.of(context).requestFocus(_contentFocus);
    }
    return CantonScaffold(
      body: _content(context),
    );
  }

  Widget _content(BuildContext context) {
    return Column(
      children: [
        _header(context),
        SizedBox(height: 7),
        _body(context),
      ],
    );
  }

  Widget _header(BuildContext context) {
    return Consumer(
      builder: (context, watch, child) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CantonBackButton(
              onPressed: () => _addNoteFunction(watch),
            ),
            Text(
              NoteRepository.dateTimeString(
                widget.note.creationDate ?? DateTime.now(),
              ).substring(6),
              style: Theme.of(context)
                  .textTheme
                  .headline5
                  .copyWith(color: CantonColors.textTertiary),
            ),
            CantonHeaderButton(
              icon: Icon(
                FeatherIcons.moreVertical,
                color: CantonColors.textTertiary,
                size: 27.0,
              ),
              onPressed: () {
                _noteConfigurations(_passwordController);
              },
            ),
          ],
        );
      },
    );
  }

  Widget _body(BuildContext context) {
    return Consumer(
      builder: (context, watch, child) {
        final repo = watch(noteProvider.notifier);

        return Expanded(
          child: Column(
            children: [
              EditableText(
                focusNode: _contentFocus,
                cursorColor: Theme.of(context).primaryColor,
                controller: _contentController,
                backgroundCursorColor: Theme.of(context).primaryColor,
                maxLines: null,
                scrollController: new ScrollController(),
                onChanged: (_) {
                  repo.updateNote(
                    note: widget.note,
                    content: _contentController.text,
                    lastEditDate: DateTime.now(),
                  );
                },
                style: Theme.of(context).textTheme.headline6,
              ),
            ],
          ),
        );
      },
    );
  }

  void _addNoteFunction(ScopedReader watch) {
    final repo = watch(noteProvider.notifier);

    if (!['', null].contains(_contentController.text)) {
      // Creates a new note if the controllers
      // aren't empty. If empty, it will act as a regular
      // back button.
      if (widget.note.id != null) {
        repo.updateNote(
          note: widget.note,
          content: _contentController.text,
          pinned: widget.note.pinned ?? false,
          locked: widget.note.locked ?? false,
          password: !['', null].contains(_passwordController.text)
              ? _passwordController.text
              : '',
          lastEditDate: widget.note.lastEditDate,
        );
      } else {
        repo.addNote(
          Note(
            id: UniqueKey().toString(),
            content: _contentController.text,
            pinned: widget.note.pinned ?? false,
            locked: widget.note.locked ?? false,
            password: widget.note.password ?? '',
            creationDate: DateTime.now(),
            lastEditDate: DateTime.now(),
          ),
        );
      }
    } else {
      if (widget.note.id != null) repo.removeNote(widget.note);
    }
    Navigator.of(context).pop();
  }

  Future<Widget> _noteConfigurations(
      TextEditingController _passwordController) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: CantonColors.bgPrimary,
      elevation: 0,
      useRootNavigator: true,
      shape: SquircleBorder(radius: 55),
      builder: (_) {
        return Consumer(
          builder: (context, watch, child) {
            bool _pWordIsEmpty = false;
            return StatefulBuilder(
              builder: (context, setState) => Padding(
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 27),
                child: FractionallySizedBox(
                  heightFactor: 0.95,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Container(
                        height: 5,
                        width: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          color: cantonGrey[300],
                        ),
                      ),
                      SizedBox(height: 15),
                      Text(
                        'Configure your Note',
                        style: Theme.of(context).textTheme.headline5,
                      ),
                      const SizedBox(height: 30),
                      Row(
                        children: [
                          pinNoteButton(widget.note, setState),
                          SizedBox(width: 7),
                          lockNoteButton(_pWordIsEmpty),
                        ],
                      ),
                      const SizedBox(height: 7),
                      Row(
                        children: [
                          CantonPrimaryButton(
                            buttonText: 'Cancel',
                            containerColor: CantonColors.bgDanger,
                            textColor: CantonColors.textDanger,
                            containerWidth:
                                MediaQuery.of(context).size.width / 2 - 54,
                            onPressed: () => Navigator.pop(context),
                          ),
                          Spacer(),
                          CantonPrimaryButton(
                            buttonText: 'Save',
                            containerColor: CantonColors.bgInverse,
                            textColor: CantonColors.bgPrimary,
                            containerWidth:
                                MediaQuery.of(context).size.width / 2 - 54,
                            onPressed: () {
                              widget.note.password = _passwordController.text;
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget pinNoteButton(Note note, void Function(void Function()) setState) {
    Widget pinnedIcon = [null, false].contains(note.pinned)
        ? Icon(
            CupertinoIcons.pin_fill,
            color: CantonColors.yellow,
          )
        : Icon(
            CupertinoIcons.pin_slash_fill,
            color: CantonColors.yellow,
          );
    return CantonHeaderButton(
        icon: pinnedIcon,
        backgroundColor: CantonColors.gray[200],
        onPressed: () {
          setState(() {
            note.pinned = !note.pinned;
          });
        });
  }

  Widget lockNoteButton(bool _pWordIsEmpty) {
    Widget lockedIcon = [null, false].contains(widget.note.locked)
        ? Icon(
            CupertinoIcons.lock_fill,
            color: CantonColors.purple,
          )
        : Icon(
            CupertinoIcons.lock_slash_fill,
            color: CantonColors.purple,
          );
    return CantonHeaderButton(
      icon: lockedIcon,
      backgroundColor: CantonColors.gray[200],
      onPressed: () {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            shape: SquircleBorder(radius: 55),
            elevation: 0,
            title: Text(
              'Configure Lock',
              style: Theme.of(context).textTheme.headline4,
            ),
            content: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'Create a password for your note',
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
                  focusNode: _passwordFocus,
                  textInputType: TextInputType.number,
                ),
                SizedBox(height: 10),
                _pWordIsEmpty
                    ? Text(
                        'Please Enter a password',
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
                      buttonText: 'Save',
                      containerColor: CantonColors.bgInverse,
                      textColor: CantonColors.bgPrimary,
                      containerWidth:
                          MediaQuery.of(context).size.width / 2 - 70,
                      onPressed: () {
                        setState(() {
                          _passwordController.text.isNotEmpty
                              ? widget.note.locked = true
                              : widget.note.locked = false;
                        });
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                Text(
                  'To remove the password Lock, simply delete the text in the text field.',
                  style: Theme.of(context).textTheme.headline6,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
