import 'package:flutter/material.dart';
import 'package:minggu_03/database_instance.dart';
import 'package:minggu_03/history_list.dart';
import 'package:minggu_03/history_screen.dart';
import 'package:minggu_03/item_screen.dart';
import 'package:minggu_03/my_provider.dart';
import 'package:minggu_03/shopping_list.dart';
import 'package:minggu_03/shopping_list_dialog.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Screen extends StatefulWidget {
  const Screen({Key? key}) : super(key: key);

  @override
  State<Screen> createState() => _ScreenState();
}

class _ScreenState extends State<Screen> {
  int id = 0;
  final DBhelper _dBhelper = DBhelper();

  @override
  void initState() {
    super.initState();
    _loadLastId();
  }

  _loadLastId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int lastId = prefs.getInt('lastId') ?? 0;
    setState(() {
      id = lastId;
    });
  }

  _saveLastId(int lastId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('lastId', lastId);
  }

  @override
  Widget build(BuildContext context) {
    var tmp = Provider.of<ListProductProvider>(context, listen: true);
    _dBhelper.getMyShoppingList().then(
          (value) => tmp.setShoppingList = value,
        );
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shopping List'),
        leading: IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const HistoryScreen()),
            );
          }, 
          icon: const Icon(Icons.history_outlined)
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.delete),
            tooltip: 'Delete All',
            onPressed: () {
              _showConfirmationDialog(context);
            },
          )
        ],
      ),
      body: ListView.builder(
        itemCount: tmp.getShoppingList != null ? tmp.getShoppingList.length : 0,
        itemBuilder: (BuildContext context, int index) {
          return Dismissible(
            key: Key(tmp.getShoppingList[index].id.toString()),
            onDismissed: (direction) {
              String tmpName = tmp.getShoppingList[index].name;
              int tmpId = tmp.getShoppingList[index].id;

              HistoryList historyItem = HistoryList(tmpId, tmpName, tmp.getShoppingList[index].sum, DateTime.now());
              _dBhelper.insertHistoryList(historyItem);
              
              setState(() {
                tmp.deleteById(tmp.getShoppingList[index]);
              });
              _dBhelper.deleteShoppingList(tmpId);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('$tmpName deleted'),
              ));
            },
            child: ListTile(
              title: Text(tmp.getShoppingList[index].name),
              leading: CircleAvatar(
                child: Text('${tmp.getShoppingList[index].sum}'),
              ),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) {
                  return ItemsScreen(tmp.getShoppingList[index]);
                }));
              },
              trailing: IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return ShoppingListDialog(_dBhelper).buildDialog(
                            context, tmp.getShoppingList[index], false);
                      });
                  _dBhelper
                      .getMyShoppingList()
                      .then((value) => tmp.setShoppingList = value);
                },
              ),
            )
          );
        }
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await showDialog(
              context: context,
              builder: (context) {
                return ShoppingListDialog(_dBhelper)
                    .buildDialog(context, ShoppingList(++id, "", 0), true);
              });
          _saveLastId(id);
          _dBhelper
              .getMyShoppingList()
              .then((value) => tmp.setShoppingList = value);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  _showConfirmationDialog(BuildContext context) {
    var tmp = Provider.of<ListProductProvider>(context, listen: false);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete All Items'),
          content: const Text('Are you sure want to delete all items?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                for (var item in tmp.getShoppingList) {
                  HistoryList historyItem = HistoryList(
                    item.id,
                    item.name,
                    item.sum,
                    DateTime.now(),
                  );
                  await _dBhelper.insertHistoryList(historyItem);
                }
                _dBhelper.deleteAllShoppingList();
                if(mounted) {
                  Navigator.pop(context);
                }
                tmp.setShoppingList = [];
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _dBhelper.closeDB();
    super.dispose();
  }
}
