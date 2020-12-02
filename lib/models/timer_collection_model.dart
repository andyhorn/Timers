import 'dart:collection';
import 'package:uuid/uuid.dart';
import 'package:flutter/cupertino.dart';
import 'timer.dart';

class TimerCollectionModel extends ChangeNotifier {
  final _timerCollection = <Timer>[];

  UnmodifiableListView<Timer> get items =>
      UnmodifiableListView(_timerCollection);

  void addTimer(String name, Duration duration) {
    _timerCollection.add(Timer(name, duration));
  }

  void removeTimer(Uuid id) {
    final index = _timerCollection.indexWhere((item) => item.id == id);

    if (index != -1) {
      _timerCollection.removeAt(index);
      notifyListeners();
    }
  }

  TimerCollectionModel() {
    addTimer("Test Timer", Duration(seconds: 15));
    addTimer("Test Two", Duration(minutes: 1));
  }
}