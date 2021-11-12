import 'package:canton_design_system/canton_design_system.dart';
import 'package:notes_app/src/models/note.dart';
import 'package:notes_app/src/ui/views/note_creation_view/note_creation_view.dart';

class TagViewHeader extends StatelessWidget {
  const TagViewHeader({required this.tag, required this.setState, Key? key}) : super(key: key);

  final Tag tag;
  final void Function(void Function()) setState;

  @override
  Widget build(BuildContext context) {
    return ViewHeaderTwo(
      title: tag.name,
      backButton: true,
      buttonTwo: CantonHeaderButton(
          icon: Icon(
            FeatherIcons.plus,
            color: Theme.of(context).primaryColor,
            size: 27,
          ),
          onPressed: () {
            CantonMethods.viewTransition(
              context,
              NoteCreationView(note: Note(tags: [tag])),
            ).then((value) => {setState(() {})});
          }),
    );
  }
}
