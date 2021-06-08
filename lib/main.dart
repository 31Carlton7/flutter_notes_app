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
    return CantonApp(
      title: kAppTitle,
      primaryLightColor: CantonColors.blue,
      primaryLightVariantColor: CantonColors.blue[400],
      primaryDarkColor: CantonDarkColors.blue,
      primaryDarkVariantColor: CantonDarkColors.blue[400],
      home: HomeView(),
    );
  }
}
