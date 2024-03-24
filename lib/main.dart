import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nfc_card_reader/view/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  runApp(
    await App.withDependency(),
  );
}
