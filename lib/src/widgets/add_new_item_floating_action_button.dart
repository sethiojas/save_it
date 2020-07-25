import 'package:flutter/material.dart';
import 'package:save_it/src/widgets/add_item_dialog.dart';
import 'package:save_it/src/models/Items.dart';

class AddNewItemFloatingActionButton extends StatelessWidget {
  final Function addNewItemCallback;
  AddNewItemFloatingActionButton({this.addNewItemCallback});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
        child: IconButton(
          icon: Icon(Icons.add),
          color: Colors.white,
          onPressed: () async {
            Map newItemData = await showDialog(
                context: context, builder: (context) => AddItemDialog());

            if (newItemData['hasInfo'] == 'false') return;

            addNewItemCallback(Items(
                nameOfItem: newItemData['name'],
                amountToSave: newItemData['amount']));
          },
          iconSize: 40,
        ),
        backgroundColor: Colors.brown[900],
        onPressed: null);
  }
}
