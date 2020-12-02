import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../models/timer.dart';
import '../models/new_timer_arguments.dart';
import 'new_timer_screen.dart';

class TimerListScreen extends StatefulWidget {
  @override
  _TimerListScreenState createState() => _TimerListScreenState();
}

class _TimerListScreenState extends State<TimerListScreen> {
  final _timers = <Timer>[];

  _TimerListScreenState() {
    _timers.add(Timer("Test One", Duration(seconds: 10)));
    _timers.add(Timer("Test Two", Duration(minutes: 1)));
  }

  void _navigateAndAwaitNewTimer(BuildContext context) async {
    final Timer timer = await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => NewTimerScreen())
    );

    if (timer != null) {
      setState(() {
        _timers.add(timer);
      });
    }
  }

  void _navigateAndAwaitTimerEdit(BuildContext context, int index) async {
    final edit = _timers[index];
    final Timer timer = await Navigator.push(
      context,
      MaterialPageRoute(builder: (c) => NewTimerScreen(timer: edit))
    );

    if (timer != null) {
      setState(() {
        _timers[index] = timer;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Timers ++"),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            color: Colors.white,
            tooltip: "Add new timer",
            onPressed: () => _navigateAndAwaitNewTimer(context),
          )
        ],
      ),
      body: ListView.builder(
        itemCount: _timers.length,
        itemBuilder: (context, index) {
          return Column(
            children: [
              Slidable(
                key: UniqueKey(),
                child: _timers[index],
                actionPane: SlidableDrawerActionPane(),
                secondaryActions: [
                  IconSlideAction(
                      caption: "Delete",
                      icon: Icons.highlight_remove,
                      color: Colors.redAccent,
                      onTap: () {
                        final _dialog = AlertDialog(
                          title: Text("Delete Timer?"),
                          actions: [
                            FlatButton(
                              child: Text("Yes, delete."),
                              onPressed: () {
                                setState(() {
                                  _timers.removeAt(index);
                                });
                                Navigator.of(context).pop();
                              },
                            ),
                            FlatButton(
                              child: Text("No, keep this timer."),
                              onPressed: () {
                                Navigator.of(context).pop();
                              }
                            )
                          ],
                        );

                        showDialog(context: context, builder: (c) => _dialog);
                      }
                  ),
                  IconSlideAction(
                      caption: "Edit",
                      icon: Icons.edit,
                      color: Colors.green,
                      onTap: () => _navigateAndAwaitTimerEdit(context, index)
                  )
                ]
              ),
              Divider(
                height: 2,
                color: Colors.grey.shade400,
              )
            ],
          );
        },
      )
    );
  }
}