class HistoryList {
  int id;
  String name;
  int sum;
  DateTime dateTime;

  HistoryList(this.id, this.name, this.sum, this.dateTime);

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'sum': sum, 'dateTime': dateTime.toIso8601String()};
  }
}
