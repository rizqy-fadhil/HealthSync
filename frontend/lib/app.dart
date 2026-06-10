import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'core/theme/neubrutalism_theme.dart';
import 'presentation/pages/main_page.dart';
import 'package:frontend/presentation/pages/auth/login_page.dart'; // <--- CONTOH (Sesuaikan dengan struktur foldermu)

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    // Force light status bar icons (dark icons on yellow bg)
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ));

    return MaterialApp(
      title: 'HealthSync',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: NeuColors.background,
        textTheme: GoogleFonts.spaceGroteskTextTheme(),
        colorScheme: const ColorScheme.light(
          primary: NeuColors.yellow,
          secondary: NeuColors.pink,
          tertiary: NeuColors.mint,
          surface: NeuColors.background,
        ),
        splashFactory: NoSplash.splashFactory,
        highlightColor: Colors.transparent,
      ),
      home: LoginPage(),
    );
  }
}
