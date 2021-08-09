import 'package:hive/hive.dart';
import 'package:save_and_copy_text/localdb/model.dart';

class Db {
  void adddata(Data data) async {
    await Hive.openBox('info');
    var box = Hive.box('info');
    box.add(data);
  }

  void deletedata(int index) async {
    await Hive.openBox('info');
    var box = Hive.box('info');
    box.deleteAt(index);
  }
}
