import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stayjogja_flutter/core/theme/app_theme.dart';
import 'package:stayjogja_flutter/routes/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set status bar style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // TODO: Firebase.initializeApp()
  // TODO: setup GetIt dependency injection

  runApp(const StayJogjaApp());
}

class StayJogjaApp extends StatelessWidget {
  const StayJogjaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Stay Jogja',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      routerConfig: appRouter,
      // TODO: localizationsDelegates untuk multi-bahasa (Indonesia & Inggris)
    );
  }
}
