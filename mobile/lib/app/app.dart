import 'package:flutter/material.dart';

import '../core/constants/app_constants.dart';
import 'home_shell.dart';
import 'theme/app_theme.dart';

class AtlasOneApp extends StatelessWidget {
  const AtlasOneApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      // O tema escuro já está pronto, mas o aplicativo abre no tema claro.
      themeMode: ThemeMode.light,
      home: const HomeShell(),
    );
  }
}
