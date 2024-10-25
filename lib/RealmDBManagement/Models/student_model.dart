import 'package:realm/realm.dart';
part 'student_model.realm.dart';


@RealmModel()
class _Student {  
  @PrimaryKey()
  late String id;

  late String name;
  late String group;
  late List<_SessionItem> progress;
}

@RealmModel()
class _SessionItem {
  late ObjectId id;
  late String date;
  late List<int> params;
}

