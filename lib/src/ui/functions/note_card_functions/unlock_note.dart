import 'package:canton_design_system/canton_design_system.dart';
import 'package:notes_app/src/models/note.dart';
import 'package:notes_app/src/ui/views/note_creation_view.dart';

// ignore: non_constant_identifier_names
Future<void> UnlockNote(BuildContext context, Note note) {
  TextEditingController _passwordController = TextEditingController();
  bool _incorrect = false;

  if (note.locked) {
    return showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: SquircleBorder(radius: 55),
        elevation: 0,
        title: Text(
          'Unlock Note',
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
                    containerWidth: MediaQuery.of(context).size.width / 2 - 70,
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
                    containerWidth: MediaQuery.of(context).size.width / 2 - 70,
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
    return CantonMethods.viewTransition(
      context,
      NoteCreationView(note: note),
    );
  }
}
