import 'package:canton_design_system/canton_design_system.dart';
import 'package:notes_app/src/ui/views/profile_view/components/date_of_first_note_card.dart';
import 'package:notes_app/src/ui/views/profile_view/components/profile_view_header.dart';
import 'package:notes_app/src/ui/views/profile_view/components/total_characters_typed_card.dart';
import 'package:notes_app/src/ui/views/profile_view/components/total_notes_created_card.dart';
import 'package:notes_app/src/ui/views/profile_view/components/total_words_typed_card.dart';

class ProfileView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CantonScaffold(
      backgroundColor: CantonMethods.alternateCanvasColor(context),
      body: _content(context),
    );
  }

  Widget _content(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ProfileViewHeader(),
        CantonNullButton(),
        _body(context),
        CantonNullButton(),
        CantonNullButton(),
        CantonNullButton(),
      ],
    );
  }

  Widget _body(BuildContext context) {
    return Card(
      child: Column(
        children: [
          TotalNotesCreatedCard(),
          Divider(),
          TotalWordsTypedCard(),
          Divider(),
          TotalCharactersTypedCard(),
          Divider(),
          DateOfFirstNoteCard(),
        ],
      ),
    );
  }
}
