import 'dart:async';
import 'dart:io';

import 'package:realm/realm.dart';
import 'package:student_check/RealmDBManagement/Models/student_model.dart';

final _config = Configuration.local([Student.schema, SessionItem.schema]);
class RealmDbManager {
  RealmDbManager._privateConstructor();
  final Realm _realm = Realm(_config);
  static final RealmDbManager _dbManagement = RealmDbManager._privateConstructor();
  //final Map<String, List<String>> _dataToGetDelete = {'delete':[], 'get':[]};
  final Map<String, int>_dataToGet = {};
  final List<String>_dataToDelete = [];
  final List<String>_invalidIDs = [];
  final List<String>_validIDs = [];
  final Map<String, List<String>> _dataToUpdate = {};

  Realm get realm => _realm;
  Map<String, int> get dataToGet => _dataToGet;
  List<String> get dataToDelete => _dataToDelete;
  List<String> get invalidIDs => _invalidIDs;
  List<String> get validIDs => _validIDs;
  Map<String, List<String>> get dataToUpdate => _dataToUpdate;

  factory RealmDbManager(){
    return _dbManagement;
  }

  List<String> getStudentsIdFromRealmDB(){
    return _realm.all<Student>().map((Student element) => element.id).toList();
  }

  Student getStudentDB(String id){
    return _realm.find(id) as Student;
  }

  bool checkStudentDB(String st){
    Student? fSt = _realm.find(st);
    if(fSt != null){
      return true;
    }
    return false;
  }

  void closeDB(){
    _realm.close();
  }

  void cleanDataBeforeCheckDB(){
    _dataToDelete.clear();
    _dataToGet.clear();
    _dataToUpdate.clear();
  }  

  Future<int> checkUpdateDataClientDB(dynamic data)async{
    var res = fromEJson(data[0]);
    try {
      Student? s =  _realm.find<Student>(res['id']);
      if(s != null){
        if(s.name != res['name'] || s.group != res['group'] || s.progress.length != res['sessionAmount']){
          _dataToUpdate[res['id']] = [];
          return 0;
        }
      }
      return 2;
    } catch (e) {
      stdout.writeln(e.toString());
      return 1;
    }
  }

  Future<int> checkUpdateDataSessionsClientDB(dynamic data)async{
    var res = fromEJson(data[0]);
    try {
    Student? s =  _realm.find<Student>(res['id']);
    if(s!=null){
      ObjectId objId = ObjectId.fromValues(0, 0, 0);
      SessionItem session = s.progress.firstWhere((element) => element.date == res['date'], orElse: () => SessionItem(objId, ''));
      if(session.date == ''){
        _dataToUpdate[res['id']]!.add(res['date']);
        return 0;
      }
    }
    return 2;
    } catch (e) {
      stdout.writeln(e.toString());
      return 1;
    }
  }

  Future<int> getPersonalDataClientDB(dynamic data)async{
    var res = fromEJson(data[0]);
    var type = res['type'];
    try{
      if(type == 'get'){
        Student newS = Student(res['id'],res['name'], res['group'], progress: []);
        newS = await _realm.writeAsync(() => _realm.add(newS));
        _dataToGet[res['id']] = res['sessionAmount'];
      }
      else{
        Student? s =  _realm.find<Student>(res['id']);
        if(s!=null){
          await  _realm.writeAsync((){
            s.name = res['name'];
            s.group = res['group'];
          });
          stdout.writeln(s.toString());
          if(s.name == res['name'] && s.group == res['group']){
            return 0;
          }
        }
      }
      
      return 0;
    }catch(err){
      stdout.writeln("In getDataClient: The data wasn't written to the storage. The error: ${err.toString()}");
      return 1;
    }
  }

  Future<int> getPersonalSessionClientDB(dynamic data)async{
    var res = fromEJson(data[0]);
    try {
      Student? s =  _realm.find<Student>(res['id']);
      if(s != null){
        var sl = res['params'][0];
        List<int> p = List<int>.from(sl);
        SessionItem sessionItem = SessionItem(ObjectId(),res['date'], params: p);
        await  _realm.writeAsync(() {
          s.progress.add(sessionItem);
          s.progress.sort((a,b) => a.date.compareTo(b.date));
        });
        return s.progress.contains(sessionItem)? 0:1;
      }
      return 2;
    } catch (e) {
      stdout.writeln(e.toString());
      return 1;
    }
  }

  FutureOr<int> getStudentsDB(dynamic data)async{
    var res = fromEJson(data[0]);
    try{
      var id = res['id']['_id'];
      _dataToGet[id] = 0;
    }
    catch(e){
      stdout.writeln(e.toString());
      return 1;
    }
    return _dataToGet.containsKey(res['id'])? 0: 1;
  }

  Future<int> deleteDataDB()async{
    try {
      await Future.forEach(_dataToDelete, (st)async{
        final student = _realm.find<Student>(st);
        try {
          await _realm.writeAsync(() {
            _realm.deleteMany<SessionItem>(student!.progress);
            _realm.delete<Student>(student);
          });
        } catch (e) {
          stdout.writeln(e.toString());
          return 1;
        }
      });
      _dataToDelete.clear();
      return 0;
    } catch (e) {
      stdout.writeln(e.toString());
      return 1;
    }
  }

  Future<int> deleteAllDataDB()async{
    try {
      await _realm.writeAsync((){
        _realm.deleteAll<Student>(); 
        _realm.deleteAll<SessionItem>(); 
      });
      return 0;
    } catch (e) {
      stdout.writeln(e.toString());
      return 1;
    }
  }

  List<(DateTime, List<int>)>? getStudentFromDB(String name, String group, DateTime startDateFilter, DateTime endDateFilter){
    List<(DateTime, List<int>)> progress = [];
    try {
      RealmList<SessionItem>? st = _realm.query<Student>(r'name == $0 && group == $1', [name, group]).first.progress;
      for (SessionItem element in st) {
        DateTime sessionDate = DateTime.parse(element.date).toLocal();
        if(sessionDate.isBefore(endDateFilter) && sessionDate.isAfter(startDateFilter)){
          progress.add((sessionDate, List<int>.from(element.params)));
        }  
      }
      return progress;
    } catch (e) {
      return null;
    }
  }

  List<String> getGroupNamesDB(){
    return _realm.all<Student>().map((st) => st.group).toList().toSet().toList();
  }

  List<String> getStudentNamesDB(){
    return _realm.all<Student>().map((st) => st.name).toList().toSet().toList();
  }

  List<String> getStudentsWithTheSameGroupDB(String group){
    return _realm.all<Student>().query(r'group == $0',[group]).map((st) => st.name).toList().toSet().toList();
  }
}