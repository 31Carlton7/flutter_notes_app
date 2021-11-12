import 'package:canton_design_system/canton_design_system.dart';
import 'package:notes_app/src/models/note.dart';
import 'package:notes_app/src/ui/views/note_creation_view/note_creation_view.dart';
import 'package:notes_app/src/ui/views/profile_view/profile_view.dart';

class HomeViewHeader extends StatelessWidget {
  const HomeViewHeader({required this.setState, Key? key}) : super(key: key);

  final void Function(void Function()) setState;

  @override
  Widget build(BuildContext context) {
    return ViewHeaderTwo(
      title: 'Notes',
      backButton: false,
      buttonOne: CantonHeaderButton(
        backgroundColor: CantonColors.transparent,
        icon: Icon(
          Iconsax.user,
          color: Theme.of(context).primaryColor,
          size: 27,
        ),
        onPressed: () => CantonMethods.viewTransition(context, ProfileView()),
      ),
      buttonTwo: CantonHeaderButton(
          icon: Icon(
            FeatherIcons.plus,
            color: Theme.of(context).primaryColor,
            size: 27,
          ),
          backgroundColor: CantonColors.transparent,
          onPressed: () {
            CantonMethods.viewTransition(
              context,
              NoteCreationView(note: Note()),
            ).then((value) => {setState(() {})});
          }),
    );
  }
}
