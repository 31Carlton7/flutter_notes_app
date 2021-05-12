import 'package:canton_design_system/canton_design_system.dart';
import 'package:notes_app/src/config/constants.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notes_app/src/ui/views/home_view.dart';

Future<void> main() async {
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: kAppTitle,
      theme: cantonLightTheme().copyWith(primaryColor: CantonColors.blue),
      home: HomeView(),
    );
  }
}
