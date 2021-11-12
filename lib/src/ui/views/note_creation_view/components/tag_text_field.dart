import 'package:canton_design_system/canton_design_system.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:notes_app/src/models/note.dart';
import 'package:notes_app/src/ui/providers/note_provider.dart';

class TagTextField extends StatelessWidget {
  const TagTextField({Key? key, required this.tags, required this.note, required this.setState}) : super(key: key);

  final List<Tag> tags;
  final Note note;
  final void Function(void Function()) setState;

  @override
  Widget build(BuildContext context) {
    final _initTags = <String>[];

    for (final tag in tags) {
      _initTags.add(tag.name!);
    }

    return CantonTagTextInput(
      maxTags: 10,
      initialTags: _initTags,
      textFieldStyler: TagTextInputStyler(
        cursorColor: Theme.of(context).primaryColor,
        hintText: 'Tags',
        textFieldFilledColor: Theme.of(context).colorScheme.secondary,
        textFieldFilled: true,
      ),
      tagsStyler: TagsStyler(
        tagCancelIcon: Icon(FeatherIcons.x, color: CantonColors.white),
        tagDecoration: ShapeDecoration(
            color: Theme.of(context).primaryColor, shape: SquircleBorder(radius: BorderRadius.circular(20))),
        tagTextStyle: Theme.of(context).textTheme.bodyText1!.copyWith(color: CantonColors.white),
      ),
      onDelete: (name) {
        tags.remove(Tag(name: name));
        setState(() {
          context.read(noteProvider.notifier).updateNote(note: note, tags: tags, lastEditDate: DateTime.now());
        });
      },
      onTag: (name) {
        tags.add(Tag(name: name));
        setState(() {
          context.read(noteProvider.notifier).updateNote(note: note, tags: tags, lastEditDate: DateTime.now());
        });
      },
    );
  }
}
