import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uuid/uuid.dart';
import 'dart:async' as da;
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';

class Timer extends StatefulWidget {
  final String name;
  final Duration duration;
  final Uuid id = Uuid();

  Timer(this.name, this.duration);

  @override
  _TimerState createState() => _TimerState(this.name, this.duration);
}

class _TimerState extends State<Timer> {
  final String _name;
  final Duration _duration;
  final TextStyle _largeText = TextStyle(fontSize: 18);
  final Duration _interval = Duration(seconds: 1);
  final FlutterRingtonePlayer _player = FlutterRingtonePlayer();
  Duration _timeRemaining;
  String _state;
  bool _isRunning;
  da.Timer _intervalFunc;

  _TimerState(this._name, this._duration);

  @override
  void initState() {
    super.initState();
    _timeRemaining = _duration;
    _state = "stopped";
    _isRunning = false;
  }

  @override
  void dispose() {
    if (_intervalFunc != null) {
      _intervalFunc.cancel();
      _intervalFunc = null;
    }

    super.dispose();
  }

  String _printDuration(Duration d) =>
    d.toString().split('.').first.padLeft(8, "0");

  Color _getStateColor() {
    switch (_state) {
      case "running":
        return Colors.green;
      case "paused":
        return Colors.yellowAccent;
      case "expired":
        return Colors.red;
      case "stopped":
      default:
        return Colors.white12;
    }
  }

  void _startTimer() {
    _intervalFunc = da.Timer.periodic(_interval, (t) {
      if (_timeRemaining.inSeconds > 1) {
        setState(() {
          _timeRemaining -= Duration(seconds: 1);
        });
      } else {
        setState(() {
          _timeRemaining = Duration.zero;
          _isRunning = false;
          _state = "expired";
          FlutterRingtonePlayer.playAlarm();
        });
        t.cancel();
      }
    });

    setState(() {
      _isRunning = true;
      _state = "running";
    });
  }

  void _pauseTimer() {
    if (_intervalFunc != null) {
      _intervalFunc.cancel();
      _intervalFunc = null;
    }

    setState(() {
      _isRunning = false;
      _state = "paused";
    });
  }

  void _resetTimer() {
    if (_intervalFunc != null) {
      _intervalFunc.cancel();
      _intervalFunc = null;
    }

    FlutterRingtonePlayer.stop();

    setState(() {
      _isRunning = false;
      _state = "stopped";
      _timeRemaining = _duration;
    });
  }

  void _handleTap() {
    if (_isRunning) {
      _pauseTimer();
    } else {
      _startTimer();
    }
  }

  Widget build(BuildContext context) {
    return Container(
      color: _getStateColor(),
      child:
        ListTile(
          title: Text(_name, style: _largeText),
          subtitle: Text(_state),
          trailing: Text(_printDuration(_timeRemaining), style: _largeText),
          onTap: () => _handleTap(),
          onLongPress: () => _resetTimer(),
        )
    );
  }
}