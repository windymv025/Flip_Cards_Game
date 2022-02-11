import 'package:firebase_core/firebase_core.dart';
import 'package:flip_cards_game/provider/flip-game-provider.dart';
import 'package:flip_cards_game/ui/game-screen.dart';
import 'package:flip_cards_game/utils/routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => FlipGameProvider()),
      ],
      child: MaterialApp(
        title: 'Flutter Flip Cards Game',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const GameScreen(),
        routes: routes,
      ),
    );
  }
}
