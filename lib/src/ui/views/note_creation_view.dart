// ignore: import_of_legacy_library_into_null_safe
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

  /// Focus Nodes
  final _contentFocus = FocusNode();
  final _titleFocus = FocusNode();

  /// Tags
  List<Tag>? _tags = [];

  @override
  void initState() {
    super.initState();
    _editNoteFunction();
  }

  void _editNoteFunction() {
    if (widget.note?.id != null) {
      _titleController.text = widget.note?.title ?? '';
      _contentController.text = widget.note?.content ?? '';
      _tags = widget.note?.tags;
    } else if (widget.note?.tags != null) {
      _tags = widget.note?.tags;
    }
  }

  @override
  Widget build(BuildContext context) {
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
        widget.note!.lastEditDate ?? DateTime.now(),
      ),
      backButton: true,
      backButtonFunction: () => _completeNoteFunction(watch),
    );
  }

  Widget _body(BuildContext context) {
    return Consumer(
      builder: (context, watch, child) {
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
      onChanged: (title) {
        setState(() {
          context.read(noteProvider.notifier).updateNote(
                note: widget.note!,
                title: title,
                lastEditDate: DateTime.now(),
              );
        });
      },
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
    final _initTags = <String>[];

    for (final tag in _tags!) {
      _initTags.add(tag.name!);
    }

    return CantonTagTextInput(
      maxTags: 99,
      initialTags: _initTags,
      textFieldStyler: TagTextInputStyler(
        cursorColor: Theme.of(context).primaryColor,
        hintText: 'Tags',
        textFieldFilledColor: Theme.of(context).colorScheme.secondary,
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
      onDelete: (name) {
        _tags?.remove(Tag(name: name));
        setState(() {
          context.read(noteProvider.notifier).updateNote(
              note: widget.note!, tags: _tags, lastEditDate: DateTime.now());
        });
      },
      onTag: (name) {
        _tags?.add(Tag(name: name));
        setState(() {
          context.read(noteProvider.notifier).updateNote(
              note: widget.note!, tags: _tags, lastEditDate: DateTime.now());
        });
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
      onChanged: (content) {
        setState(() {
          context.read(noteProvider.notifier).updateNote(
                note: widget.note!,
                content: content,
                lastEditDate: DateTime.now(),
              );
        });
      },
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

  void _completeNoteFunction(ScopedReader watch) {
    final repo = watch(noteProvider.notifier);

    if (!['', null].contains(_contentController.text) ||
        !['', null].contains(_titleController.text)) {
      // Creates a new note if the controllers
      // aren't empty. If empty, it will act as a regular
      // back button.
      if (widget.note!.id == null) {
        repo.addNote(
          Note(
            id: UniqueKey().toString(),
            title: _titleController.text,
            content: _contentController.text,
            tags: _tags,
            pinned: widget.note!.pinned ?? false,
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
}
