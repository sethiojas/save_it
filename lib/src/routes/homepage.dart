import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:save_it/src/widgets/info_widgets.dart';
import 'package:save_it/src/models/Items.dart';
import 'package:save_it/src/widgets/add_new_item_floating_action_button.dart';
import 'package:save_it/src/database/db.dart';

class HomePage extends StatefulWidget {
  final SharedPreferences prefs;
  HomePage(this.prefs);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _scrollController = ScrollController();

  void changeStateOfHome() {
    setState(() {});
  }

  void addItemCallback(Items newItem) async {
    await DB.insert(newItem);
    setState(() {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(0.0,
            duration: Duration(seconds: 1), curve: Curves.ease);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown[200],
      resizeToAvoidBottomPadding: false,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 5,
            ),
            NameWidget(widget.prefs.getString('name')),
            SizedBox(
              height: 15,
            ),
            TotalSavingsWidget(widget.prefs.getDouble('savings')),
            SizedBox(
              height: 20,
            ),
            Expanded(
              child: ItemList(
                scrollController: _scrollController,
                homeSetState: changeStateOfHome,
              ),
            )
          ],
        ),
      ),
      floatingActionButton: AddNewItemFloatingActionButton(
        addNewItemCallback: addItemCallback,
      ),
    );
  }
}
