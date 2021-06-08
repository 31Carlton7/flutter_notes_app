import 'package:canton_design_system/canton_design_system.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notes_app/src/services/repositories/note_repository.dart';
import 'package:notes_app/src/models/note.dart';
import 'package:notes_app/src/ui/providers/note_provider.dart';

class NoteCreationView extends StatefulWidget {
  final Note? note;

  const NoteCreationView({Key? key, this.note}) : super(key: key);
  @override
  _NoteCreationViewState createState() => _NoteCreationViewState();
}

class _NoteCreationViewState extends State<NoteCreationView> {
  /// TextEditingControllers
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  var _passwordController = TextEditingController();

  /// Focus Nodes
  final _contentFocus = FocusNode();
  final _titleFocus = FocusNode();
  final _passwordFocus = FocusNode();

  /// Tags
  final _tags = [];

  void newNoteFunction() {
    if (widget.note!.id != null) {
      _titleController.text = widget.note!.title ?? '';
      _contentController.text = widget.note!.content ?? '';
      _passwordController = TextEditingController(text: widget.note!.password);
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
    FocusScope.of(context).requestFocus(_titleFocus);

    return CantonScaffold(
      body: _content(context),
    );
  }

  Widget _content(BuildContext context) {
    return Consumer(
      builder: (context, watch, child) {
        return Column(
          children: [
            _header(context, watch),
            SizedBox(height: 7),
            _body(context),
          ],
        );
      },
    );
  }

  Widget _header(BuildContext context, ScopedReader watch) {
    return ViewHeaderTwo(
      title: NoteRepository.dateTimeString(
        widget.note!.creationDate ?? DateTime.now(),
      ).substring(6),
      backButton: true,
      backButtonFunction: () => _addNoteFunction(watch),
      buttonTwo: CantonHeaderButton(
        backgroundColor: CantonColors.transparent,
        icon: Icon(
          FeatherIcons.moreVertical,
          color: Theme.of(context).primaryColor,
          size: 27.0,
        ),
        onPressed: () {
          _noteConfigurations(_passwordController);
        },
      ),
    );
  }

  Widget _body(BuildContext context) {
    return Consumer(
      builder: (context, watch, child) {
        final repo = watch(noteProvider.notifier);

        return Expanded(
          child: Column(
            children: [
              _titleTextField(context),
              _tagTextField(context),
              _contentTextField(context),
            ],
          ),
        );
      },
    );
  }

  Widget _titleTextField(BuildContext context) {
    return TextField(
      focusNode: _titleFocus,
      cursorColor: Theme.of(context).primaryColor,
      controller: _titleController,
      maxLines: null,
      scrollController: new ScrollController(),
      onChanged: (_) {},
      style: Theme.of(context).textTheme.headline3,
      decoration: InputDecoration(
        hintText: 'Title',
        fillColor: CantonColors.transparent,
        border: InputBorder.none,
        enabledBorder: InputBorder.none,
        errorBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
        disabledBorder: InputBorder.none,
        focusedErrorBorder: InputBorder.none,
        hintStyle: Theme.of(context)
            .textTheme
            .headline3!
            .copyWith(color: Theme.of(context).colorScheme.secondaryVariant),
      ),
    );
  }

  Widget _tagTextField(BuildContext context) {
    return CantonTagTextInput(
      initialTags: [],
      textFieldStyler: TagTextInputStyler(
        cursorColor: Theme.of(context).primaryColor,
        hintText: 'Tags',
        textFieldFilledColor: Theme.of(context).colorScheme.onSecondary,
        textFieldFilled: true,
        textFieldEnabledBorder: SquircleInputBorder(
          radius: BorderRadius.all(Radius.circular(35)),
          side: BorderSide(
            color: CantonColors.transparent,
            width: 1.5,
          ),
        ),
        textFieldBorder: SquircleInputBorder(
          radius: BorderRadius.all(Radius.circular(35)),
          side: BorderSide(
            color: CantonColors.transparent,
            width: 1.5,
          ),
        ),
        textFieldFocusedBorder: SquircleInputBorder(
          radius: BorderRadius.all(Radius.circular(35)),
          side: BorderSide(
            color: CantonColors.transparent,
            width: 1.5,
          ),
        ),
        textFieldDisabledBorder: SquircleInputBorder(
          radius: BorderRadius.all(Radius.circular(35)),
          side: BorderSide(
            color: CantonColors.transparent,
            width: 1.5,
          ),
        ),
      ),
      tagsStyler: TagsStyler(
        tagCancelIcon: Icon(FeatherIcons.x, color: CantonColors.white),
        tagDecoration: ShapeDecoration(
            color: Theme.of(context).primaryColor,
            shape: SquircleBorder(radius: BorderRadius.circular(20))),
        tagTextStyle: Theme.of(context)
            .textTheme
            .bodyText1!
            .copyWith(color: CantonColors.white),
      ),
      onDelete: (_) {},
      onTag: (name) {
        _tags.add(name);
      },
    );
  }

  Widget _contentTextField(BuildContext context) {
    return TextField(
      focusNode: _contentFocus,
      cursorColor: Theme.of(context).primaryColor,
      controller: _contentController,
      maxLines: null,
      scrollController: new ScrollController(),
      onChanged: (_) {},
      style: Theme.of(context).textTheme.headline6,
      decoration: InputDecoration(
        fillColor: CantonColors.transparent,
        border: InputBorder.none,
        enabledBorder: InputBorder.none,
        errorBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
        disabledBorder: InputBorder.none,
        focusedErrorBorder: InputBorder.none,
        hintText: 'Something awesome...',
      ),
    );
  }

  void _addNoteFunction(ScopedReader watch) {
    final repo = watch(noteProvider.notifier);

    if (!['', null].contains(_contentController.text) ||
        !['', null].contains(_titleController.text)) {
      // Creates a new note if the controllers
      // aren't empty. If empty, it will act as a regular
      // back button.
      if (widget.note!.id != null) {
        repo.updateNote(
          note: widget.note!,
          title: _titleController.text,
          content: _contentController.text,
          pinned: widget.note!.pinned ?? false,
          locked: widget.note!.locked ?? false,
          password: !['', null].contains(_passwordController.text)
              ? _passwordController.text
              : '',
          lastEditDate: widget.note!.lastEditDate!,
        );
      } else {
        repo.addNote(
          Note(
            id: UniqueKey().toString(),
            title: _titleController.text,
            content: _contentController.text,
            pinned: widget.note!.pinned ?? false,
            locked: widget.note!.locked ?? false,
            password: widget.note!.password ?? '',
            creationDate: DateTime.now(),
            lastEditDate: DateTime.now(),
          ),
        );
      }
    } else {
      if (widget.note!.id != null) repo.removeNote(widget.note!);
    }
  }

  Future<dynamic> _noteConfigurations(
    TextEditingController _passwordController,
  ) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: CantonColors.bgPrimary,
      elevation: 0,
      useRootNavigator: true,
      shape: SquircleBorder(radius: BorderRadius.circular(55)),
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
                          pinNoteButton(widget.note!, setState),
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
                              widget.note!.password = _passwordController.text;
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
            note.pinned = !note.pinned!;
          });
        });
  }

  Widget lockNoteButton(bool _pWordIsEmpty) {
    Widget lockedIcon = [null, false].contains(widget.note!.locked)
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
            shape: SquircleBorder(radius: BorderRadius.circular(55)),
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
                      .headline6!
                      .copyWith(color: CantonColors.textSecondary),
                ),
                SizedBox(height: 7),
                CantonTextInput(
                  obscureText: true,
                  isTextFormField: true,
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
                            .bodyText1!
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
                              ? widget.note!.locked = true
                              : widget.note!.locked = false;
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
