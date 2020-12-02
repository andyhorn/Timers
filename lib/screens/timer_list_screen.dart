import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../models/timer.dart';
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
          ),
          IconButton(
            icon: Icon(Icons.help_outline),
            color: Colors.white,
            tooltip: "Help",
            onPressed: () {
              showDialog(context: context, builder: (c) {
                return AlertDialog(
                  title: Text("How Does This Work?"),
                  content: Wrap(
                    children: [
                      Text("Follow these tips to get started!",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      BulletedTextList(points: [
                        "Tap the '+' icon to create a new timer",
                        "Tap a timer to start the countdown",
                        "Tap a running timer again to pause",
                        "Press and hold a timer to reset",
                        "Swipe a row for more options"
                      ]),
                      Divider(
                        height: 50,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Icon(Icons.copyright, size: 10),
                          Text(" 2020 - Andrew Horn", style: TextStyle(
                            fontSize: 10,
                          ))
                        ],
                      )
                    ],
                  ),
                  actions: [
                    FlatButton(
                      child: Text("OK"),
                      onPressed: () {
                        Navigator.of(context).pop();
                      }
                    )
                  ],
                );
              });
            }
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
      ),
    );
  }
}

class BulletedTextList extends StatelessWidget {
  final _bullets = <Text>[];

  Text _makeBulletPoint(String item) {
    return Text("• $item", key: UniqueKey(), style: TextStyle(
      fontSize: 16,
    ));
  }

  BulletedTextList({ List<String> points }) {
    if (points == null) return;

    for (final point in points) {
      _bullets.add(_makeBulletPoint(point));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 15, left: 8),
      child: Wrap(
        children: _bullets.map((p) => Container(
            padding: EdgeInsets.symmetric(vertical: 3, horizontal: 2),
            child: p
        )).toList()
      ),
    );
  }
}