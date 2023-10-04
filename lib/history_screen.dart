import 'package:flutter/material.dart';
import 'package:minggu_03/database_instance.dart';
import 'package:minggu_03/my_provider.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final DBhelper _dBhelper = DBhelper();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var tmp = Provider.of<ListProductProvider>(context, listen: true);
    _dBhelper.getMyHistoryList().then(
      (value) => tmp.setHistoryList = value,
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text('History List'),
      ),
      body: ListView.builder(
        itemCount: tmp.getHistoryList != null ? tmp.getHistoryList.length : 0,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            title: Text(tmp.getHistoryList[index].name),
            leading: CircleAvatar(
              child: Text('${tmp.getHistoryList[index].sum}'),
            ),
            trailing: Text(
              DateFormat('dd/MM/yyyy HH:mm:ss').format(tmp.getHistoryList[index].dateTime),
            ),
          );
        }
      ),
    );
  }
}