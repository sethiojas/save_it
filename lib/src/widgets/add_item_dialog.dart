import 'package:flutter/material.dart';

class AddItemDialog extends StatefulWidget {
  // This is a statefull widget to get
  // initState and dispose methods,
  // for initializing and disposing
  // TextField controllers respectively.
  @override
  _AddItemDialogState createState() => _AddItemDialogState();
}

class _AddItemDialogState extends State<AddItemDialog> {
  TextEditingController amountToSaveController;
  TextEditingController itemNameController;

  @override
  void initState() {
    super.initState();
    amountToSaveController = TextEditingController();
    itemNameController = TextEditingController();
  }

  @override
  void dispose() {
    amountToSaveController.dispose();
    itemNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      child: Dialog(
          elevation: 5,
          insetAnimationCurve: Curves.easeOutQuart,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(left: 5),
                child: TextField(
                  controller: itemNameController,
                  decoration: InputDecoration(
                    hintText: 'Name of Item',
                    border: InputBorder.none,
                    icon: Icon(Icons.shopping_basket),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 5),
                child: TextField(
                  keyboardType: TextInputType.numberWithOptions(
                      decimal: true, signed: false),
                  controller: amountToSaveController,
                  decoration: InputDecoration(
                    hintText: 'Amount to Save',
                    border: InputBorder.none,
                    icon: Icon(Icons.monetization_on),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  FlatButton(
                    onPressed: () {
                      if (itemNameController.text == '' ||
                          amountToSaveController.text == '') {
                        itemNameController.clear();
                        amountToSaveController.clear();
                        return;
                      }

                      Navigator.pop(context, {
                        'name': itemNameController.text.toString(),
                        'amount': double.tryParse(amountToSaveController.text),
                        'hasInfo': 'true',
                      });
                    },
                    child: Text(
                      'Add',
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ),
                  FlatButton(
                    onPressed: () =>
                        Navigator.pop(context, {'hasInfo': 'false'}),
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ),
                ],
              )
            ],
          )),
    );
  }
}
