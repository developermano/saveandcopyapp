import 'package:hive/hive.dart';

part 'model.g.dart';

@HiveType(typeId: 0)
class Data extends HiveObject {
  @HiveField(0)
  String data;

  Data(this.data);
}
