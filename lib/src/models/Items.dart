import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class Items {
  final String nameOfItem;
  final double amountToSave;
  List<double> moneySaved;
  double amountSaved;
  int _id;
  int get id => _id;

  Items(
      {this.nameOfItem,
      this.amountToSave,
      List<double> transactions,
      this.amountSaved = 0.0,
      int identity}) {
    _id = identity ?? this.hashCode;
    moneySaved = transactions ?? [];
  }

  factory Items.fromMap(Map<String, dynamic> json) {
    var res = JsonDecoder().convert(json['transactions']);
    List<double> transactions = List.castFrom<dynamic, double>(res).toList();
    return new Items(
      nameOfItem: json['name'].toString(),
      amountToSave: json['amount'],
      transactions: transactions,
      amountSaved: json['amount_saved'],
      identity: json['id'],
    );
  }

  Future<void> addToSavings(double money) async {
    final prefs = await SharedPreferences.getInstance();
    double savings = prefs.getDouble('savings');
    prefs.setDouble('savings', savings + money);
  }

  void addNewEntry(double money) async {
    moneySaved.insert(0, money);
    amountSaved += money;
    await addToSavings(money);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': _id,
      'name': nameOfItem,
      'amount': amountToSave,
      'transactions': jsonEncode(moneySaved),
      'amount_saved': amountSaved,
    };
  }

  static List<Items> getTestList() {
    return [
      Items(nameOfItem: 'EarPhones', amountToSave: 2500),
      Items(nameOfItem: 'Laptop', amountToSave: 80000),
      Items(nameOfItem: 'RAM upgrades', amountToSave: 8000),
      Items(nameOfItem: 'Eminem show', amountToSave: 15000),
      Items(nameOfItem: 'Tech N9ne album', amountToSave: 2000),
      Items(nameOfItem: 'ElectroBoom Patreon', amountToSave: 100),
      Items(nameOfItem: 'Keep On Coding - Sam R. gift', amountToSave: 3000),
      Items(nameOfItem: 'New Phone', amountToSave: 30000),
      Items(nameOfItem: 'Trimmer', amountToSave: 1100),
      Items(nameOfItem: 'Hire Hitman', amountToSave: 20000),
      Items(nameOfItem: 'Questionable Stuff', amountToSave: 100000000),
    ];
  }
}
