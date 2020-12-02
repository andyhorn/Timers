import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/timer_collection_model.dart';
import 'screens/timer_list_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => TimerCollectionModel(),
      child: TimerApp(),
    )
  );
}

class TimerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          primaryColor: Colors.blueGrey,
          accentColor: Colors.black26
      ),
      title: "Timers ++",
      home: TimerListScreen(),
    );
  }
}

