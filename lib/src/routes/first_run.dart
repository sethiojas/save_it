import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:save_it/src/routes/homepage.dart';

class FirstRun extends StatefulWidget {
  final SharedPreferences prefs;
  FirstRun(this.prefs);

  @override
  _FirstRunState createState() => _FirstRunState();
}

class _FirstRunState extends State<FirstRun> {
  TextEditingController _nameController;
  bool _valid = true;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: TextField(
                textCapitalization: TextCapitalization.words,
                controller: _nameController,
                decoration: InputDecoration(
                  hintText: 'John',
                  labelText: 'Enter your First Name',
                  errorText: _valid ? null : 'Enter first name Only',
                  icon: Icon(
                    Icons.person,
                    size: 40,
                    color: Colors.brown[300],
                  ),
                ),
              ),
            ),
            FlatButton(
              onPressed: () {
                print(_nameController.text);
                if (_nameController.text.isEmpty ||
                    _nameController.text.contains(' ')) {
                  setState(() {
                    _valid = false;
                  });
                } else {
                  widget.prefs.setString('name', _nameController.text);
                  widget.prefs.setDouble('savings', 0.0);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HomePage(widget.prefs),
                    ),
                  );
                }
              },
              child: Text(
                'Continue',
                style: TextStyle(
                  color: Colors.brown,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              shape: ContinuousRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: BorderSide(
                    color: Colors.brown,
                    width: 2,
                    style: BorderStyle.solid,
                  )),
            )
          ],
        ),
      ),
    );
  }
}
