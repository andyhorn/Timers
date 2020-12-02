import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../models/timer.dart';

class NewTimerScreen extends StatelessWidget {
  final Timer timer;

  NewTimerScreen({ Key key, this.timer });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("New Timer")
      ),
      body: NewTimerForm(this.timer),
    );
  }
}

class NewTimerForm extends StatefulWidget {
  final Timer _timer;

  NewTimerForm(this._timer, { Key key }) : super(key: key);

  @override
  _NewTimerFormState createState() => _NewTimerFormState(_timer);
}

class _NewTimerFormState extends State<NewTimerForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameKey = GlobalKey<FormState>();
  final _labelStyle = TextStyle(fontWeight: FontWeight.bold, fontSize: 16);
  final _textController = TextEditingController();
  String _name = "";
  Duration _duration = Duration();

  _NewTimerFormState(Timer timer) {
    if (timer != null) {
      _textController.text = timer.name;
      _duration = timer.duration;
    }

    _textController.addListener(() => setState(() {
      _name = _textController.text;
    }));
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          // Padding(padding: EdgeInsets.only(top: 50)),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Name", style: _labelStyle),
                TextFormField(
                  key: _nameKey,
                  controller: _textController,
                  autofocus: true,
                  decoration: InputDecoration(
                    hintText: "Timer Name",
                    border: UnderlineInputBorder(
                      borderSide: const BorderSide(color: Colors.black, width: 1)
                    )
                  ),
                  // onChanged: (val) => setState(() {
                  //   _name = val;
                  // }),
                ),
              ],
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Duration", style: _labelStyle),
                Container(
                  height: MediaQuery.of(context).size.height / 5,
                  alignment: Alignment.center,
                  padding: EdgeInsets.only(top: 15.0),
                  child: CupertinoTimerPicker(
                    initialTimerDuration: _duration,
                    alignment: Alignment.topCenter,
                    mode: CupertinoTimerPickerMode.hms,
                    onTimerDurationChanged: (Duration d) {
                      setState(() {
                        _duration = d;
                      });
                    },
                  )
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              alignment: Alignment.bottomCenter,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  MaterialButton(
                    child: Text("Save", style: TextStyle(color: Colors.white)),
                    color: Colors.green,
                    elevation: 5,
                    disabledElevation: 1,
                    disabledColor: Colors.grey,
                    onPressed: _duration.inSeconds > 0 && _name.isNotEmpty
                      ? () => Navigator.pop(context, Timer(_name, _duration))
                      : null
                  ),
                  MaterialButton(
                    child: Text("Cancel", style: TextStyle(color: Colors.white)),
                    color: Colors.red,
                    elevation: 5,
                    onPressed: () {
                      Navigator.pop(context, null);
                    }
                  )
                ],
              )
            ),
          )
        ],
      ),
    );
  }
}