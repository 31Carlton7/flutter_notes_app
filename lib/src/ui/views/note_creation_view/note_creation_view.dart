import 'package:canton_design_system/canton_design_system.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notes_app/src/models/note.dart';
import 'package:notes_app/src/ui/providers/note_provider.dart';
import 'package:notes_app/src/ui/views/note_creation_view/components/content_text_field.dart';
import 'package:notes_app/src/ui/views/note_creation_view/components/note_creation_view_header.dart';
import 'package:notes_app/src/ui/views/note_creation_view/components/tag_text_field.dart';
import 'package:notes_app/src/ui/views/note_creation_view/components/title_text_field.dart';

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
      backgroundColor: CantonMethods.alternateCanvasColor(context),
      body: _content(context),
    );
  }

  Widget _content(BuildContext context) {
    return Consumer(
      builder: (context, watch, child) {
        return Column(
          children: [
            NoteCreationViewHeader(note: widget.note!, completeNoteFunction: _completeNoteFunction),
            SizedBox(height: 7),
            _body(context),
          ],
        );
      },
    );
  }

  Widget _body(BuildContext context) {
    return Consumer(
      builder: (context, watch, child) {
        return Expanded(
          child: Column(
            children: [
              TitleTextField(focus: _titleFocus, controller: _titleController, setState: setState, note: widget.note!),
              TagTextField(note: widget.note!, tags: _tags!, setState: setState),
              ContentTextField(
                  focus: _contentFocus, controller: _contentController, setState: setState, note: widget.note!),
            ],
          ),
        );
      },
    );
  }

  void _completeNoteFunction(ScopedReader watch) {
    final repo = watch(noteProvider.notifier);

    if (!['', null].contains(_contentController.text) || !['', null].contains(_titleController.text)) {
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
