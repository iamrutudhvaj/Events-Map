import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'screens/map_screen/events_map_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const EventMapApp());
}

class EventMapApp extends StatelessWidget {
  const EventMapApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Event Explorer',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        primaryColor: Colors.blue,
        colorScheme: const ColorScheme.dark(primary: Colors.blue),
        visualDensity: VisualDensity.adaptivePlatformDensity,
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1F1F1F),
          foregroundColor: Colors.white,
        ),
        scaffoldBackgroundColor: const Color(0xFF121212),
        bottomSheetTheme: const BottomSheetThemeData(
          backgroundColor: Color(0xFF262626),
        ),
        cardColor: Color(0xFF262626),
      ),
      home: const EventsMapScreen(),
    );
  }
}
