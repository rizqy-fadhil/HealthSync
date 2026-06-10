import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Pre-initialize SharedPreferences to establish the platform channel
  // before any auth calls attempt to use it.
  await SharedPreferences.getInstance();
  runApp(const App());
}

