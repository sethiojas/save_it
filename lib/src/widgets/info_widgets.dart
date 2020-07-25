import 'package:flutter/material.dart';
import 'package:save_it/src/models/Items.dart';
import 'package:save_it/src/widgets/show_item.dart';
import 'package:save_it/src/database/db.dart';

class NameWidget extends StatelessWidget {
  final String name;
  NameWidget(this.name);
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(left: 15),
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            'Hi, $name',
            style: TextStyle(
              color: Colors.black,
              fontSize: 40,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
        ),
      ],
    );
  }
}

class TotalSavingsWidget extends StatelessWidget {
  final double savings;
  TotalSavingsWidget(this.savings);

  String formatSavings(double savings) {
    savings += 1;
    if (savings > 999999999) {
      savings /= 1000000000;
      return savings.toStringAsFixed(2) + 'B+';
    } else if (savings > 999999) {
      savings /= 1000000;
      return savings.toStringAsFixed(2) + 'M+';
    } else if (savings > 999) {
      savings /= 1000;
      return savings.toStringAsFixed(2) + 'K+';
    } else {
      return savings.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(right: 15),
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            'Total Savings: \$${formatSavings(savings)}',
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.w600,
              letterSpacing: 1,
            ),
          ),
        ),
      ],
    );
  }
}

class ItemList extends StatefulWidget {
  final ScrollController scrollController;
  final Function homeSetState;
  ItemList({this.scrollController, this.homeSetState});

  @override
  _ItemListState createState() => _ItemListState();
}

class _ItemListState extends State<ItemList> {
  Future<List<Items>> itemListFuture;

  @override
  Widget build(BuildContext context) {
    itemListFuture = DB.query();
    return Container(
      margin: EdgeInsets.all(15),
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(20),
        color: Colors.brown,
      ),
      height: MediaQuery.of(context).size.height * 0.70,
      child: FutureBuilder<List<Items>>(
        future: itemListFuture,
        builder: (
          BuildContext context,
          AsyncSnapshot<List<Items>> snapshot,
        ) {
          Widget child;
          if (snapshot.hasData) {
            if (snapshot.data.isEmpty) {
              child = Center(
                child: Text(
                  'Add Items by pressing \'+\' button',
                  style: TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
              );
            } else {
              child = ListView.builder(
                controller: widget.scrollController,
                addAutomaticKeepAlives: false,
                padding: EdgeInsets.all(5),
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: EdgeInsets.all(5),
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.brown[50],
                    ),
                    child: ListTile(
                      title: Text(
                        snapshot.data[index].nameOfItem,
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      subtitle: Text(
                        snapshot.data[index].amountToSave.toString(),
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      onTap: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) => ShowItem(
                              item: snapshot.data[index],
                              index: index,
                            ),
                          ),
                        );
                        setState(() {});
                        widget.homeSetState();
                      },
                    ),
                  );
                },
              );
            }
          } else if (snapshot.hasError) {
            child = Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Icon(
                  Icons.error_outline,
                  color: Colors.red,
                  size: 60,
                ),
                Padding(
                  padding: EdgeInsets.only(top: 16),
                  child: Text(
                    'Error Fetching Data: ${snapshot.error}',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ],
            );
          } else {
            child = Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    child: CircularProgressIndicator(),
                    width: 60,
                    height: 60,
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 16),
                    child: Text(
                      'Fetching Data',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  )
                ],
              ),
            );
          }
          return child;
        },
      ),
    );
  }
}
