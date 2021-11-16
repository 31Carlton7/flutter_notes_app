import 'dart:io';

import 'package:canton_design_system/canton_design_system.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:local_auth/local_auth.dart';

import 'package:notes_app/src/config/constants.dart';
import 'package:notes_app/src/ui/views/home_view/home_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  await Hive.openBox('flutter_notes_app');

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]).then((_) {
    runApp(ProviderScope(child: MyApp()));
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CantonApp(
      title: kAppTitle,
      primaryLightColor: CantonColors.blue,
      primaryLightVariantColor: CantonColors.blue[200]!,
      primaryDarkColor: CantonDarkColors.blue,
      primaryDarkVariantColor: CantonDarkColors.blue[200]!,
      home: HomeView(),
    );
  }
}
