import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

// import '../models/timer_collection_model.dart';
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
    final NewTimerArguments args = await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => NewTimerScreen())
    );

    if (args != null) {
      setState(() {
        _timers.add(Timer(args.name, args.duration));
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
                child: _timers[index],
                actionPane: SlidableDrawerActionPane(),
                secondaryActions: [
                  IconSlideAction(
                      caption: "Delete",
                      icon: Icons.highlight_remove,
                      color: Colors.redAccent,
                      onTap: () => setState(() {
                        _timers.removeAt(index);
                      })
                  ),
                  IconSlideAction(
                      caption: "Edit",
                      icon: Icons.edit,
                      color: Colors.green,
                      onTap: () {}
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