import 'package:flutter/material.dart';
import 'package:uni_life_rsvp_exam/core/routes/app_router.dart';
import 'package:uni_life_rsvp_exam/core/theme/app_theme.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      theme: AppTheme.theme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.dark,
      routerConfig: AppRouter.router,
    );
  }
}
