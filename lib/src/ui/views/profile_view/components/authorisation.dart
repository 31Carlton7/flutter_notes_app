import 'package:canton_design_system/canton_design_system.dart';
import 'package:notes_app/src/ui/views/profile_view/profile_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:local_auth/local_auth.dart';

class Authorisation extends StatelessWidget {
  const Authorisation({Key? key}) : super(key: key);

  Future<bool> authStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('auth') == null || prefs.getBool('auth') == false ? false : true;
  }

  void changeAuthStatus(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    try {
      var localAuth = LocalAuthentication();
      var authenticate = await localAuth.authenticate(
        localizedReason: 'Authenticate to configure Locking',
        useErrorDialogs: true,
        // stickyAuth: true,
      );
      authenticate
          ? prefs.getBool('auth') == true
              ? prefs.setBool('auth', false)
              : prefs.setBool('auth', true)
          : ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text("Check device or configured lock"),
              duration: Duration(seconds: 1),
            ));
      Navigator.pop(context);
      CantonMethods.viewTransition(context, ProfileView());
    } on Exception catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(0),
      shape: SquircleBorder(
        radius: BorderRadius.vertical(bottom: Radius.circular(45)),
        side: BorderSide(
          color: CantonColors.transparent,
          width: 1.5,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 17, vertical: 15),
        child: Row(
          children: [
            FutureBuilder(
              future: authStatus(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  return snapshot.data == true
                      ? Text(
                          'Unlock Notes',
                          style: Theme.of(context).textTheme.headline5,
                        )
                      : Text(
                          'Lock Notes',
                          style: Theme.of(context).textTheme.headline5,
                        );
                }
              },
            ),
            Spacer(),
            FutureBuilder(
                future: authStatus(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (!snapshot.hasData) {
                    // while data is loading:
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    return CantonActionButton(
                      icon: snapshot.data == true ? Icon(Icons.lock_open) : Icon(Icons.lock),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: snapshot.data == true ? Text("Notes is now unlocked") : Text("Notes is now locked"),
                          duration: Duration(seconds: 1),
                        ));
                        changeAuthStatus(context);
                      },
                    );
                  }
                })
          ],
        ),
      ),
    );
  }
}
