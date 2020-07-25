import 'package:flutter/material.dart';
import 'package:save_it/src/models/Items.dart';
import 'package:save_it/src/database/db.dart';

class ShowItem extends StatefulWidget {
  final Items item;
  final int index;
  ShowItem({this.item, this.index});

  @override
  _ShowItemState createState() => _ShowItemState();
}

class _ShowItemState extends State<ShowItem> {
  var showAddMoneyField = false;
  TextEditingController _savingsEntryController;

  @override
  void initState() {
    super.initState();
    _savingsEntryController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _savingsEntryController.dispose();
  }

  void changeAddMoneyField(bool value) async {
    setState(() {
      showAddMoneyField = value;
    });
  }

  void addEntryToItem(double money) async {
    setState(() {
      widget.item.addNewEntry(money);
    });
    DB.update(widget.item);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Column(
            children: <Widget>[
              Card(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    ListTile(
                      leading: Icon(
                        Icons.shopping_basket,
                        size: 30,
                      ),
                      title: Text(
                        widget.item.nameOfItem,
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      subtitle: Text(
                        widget.item.amountToSave.toString(),
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ),
                    ButtonBar(
                      children: <Widget>[
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () async {
                            await DB.delete(widget.item);
                            Navigator.pop(context);
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.add),
                          onPressed: () {
                            setState(() {
                              showAddMoneyField = true;
                            });
                          },
                        ),
                      ],
                    )
                  ],
                ),
              ),
              if (showAddMoneyField)
                ShowNewEntryField(
                  _savingsEntryController,
                  changeAddMoneyField,
                  addEntryToItem,
                ),
              SizedBox(
                height: showAddMoneyField
                    ? MediaQuery.of(context).size.height * 0.53
                    : MediaQuery.of(context).size.height * 0.648,
                child: ShowMoneyInfo(widget.item.moneySaved),
              ),
            ],
          ),
          ShowSavings(widget.item.amountSaved),
        ],
      ),
    );
  }
}

class ShowNewEntryField extends StatelessWidget {
  final TextEditingController entryController;
  final Function changeAddMoneyField;
  final Function addEntry;
  ShowNewEntryField(
    this.entryController,
    this.changeAddMoneyField,
    this.addEntry,
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(left: 5),
          child: TextField(
            keyboardType:
                TextInputType.numberWithOptions(decimal: true, signed: false),
            controller: entryController,
            decoration: InputDecoration(
              hintText: 'Amount',
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
                if (entryController.text == '') {
                  return;
                }
                changeAddMoneyField(false);
                addEntry(double.parse(entryController.text));
                entryController.clear();
              },
              child: Text(
                'Add',
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            ),
            FlatButton(
              onPressed: () {
                changeAddMoneyField(false);
                entryController.clear();
              },
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
    );
  }
}

class ShowMoneyInfo extends StatefulWidget {
  final List<double> savedMoney;
  ShowMoneyInfo(this.savedMoney);
  @override
  _ShowMoneyInfoState createState() => _ShowMoneyInfoState();
}

class _ShowMoneyInfoState extends State<ShowMoneyInfo> {
  @override
  Widget build(BuildContext context) {
    return widget.savedMoney.isNotEmpty
        ? ListView(
            shrinkWrap: true,
            children: widget.savedMoney
                .map((elem) => ListTile(
                      title: Text(elem.toString()),
                    ))
                .toList(),
          )
        : Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'You havent saved money for this item yet!',
              style: TextStyle(fontSize: 20),
            ),
          );
  }
}

class ShowSavings extends StatelessWidget {
  final double savings;
  ShowSavings(this.savings);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Divider(
          height: 30.0,
          // thickness: 2.0,
          color: Colors.black,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.fromLTRB(0.0, 0.0, 40.0, 10.0),
              child: Text(
                'Total: $savings',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          ],
        ),
      ],
    );
  }
}
