import 'dart:async';
import 'dart:io';

import 'package:student_check/RealmDBManagement/realm_db_manager.dart';
import 'package:student_check/SocketConnection/socket_manager.dart';

class Middleware {
  Middleware._privateConstructor();
  final SocketManager _socketManager = SocketManager();
  static final Middleware _middleware = Middleware._privateConstructor();
  final RealmDbManager _realmDbManager = RealmDbManager();
  
  //bool get isConnected => _socketManager.isConnected;
  
  factory Middleware(){
    return _middleware;
  }

  Future<void> socketConnect()async{
    await _socketManager.socketConnect();
  }

  void socketDispose(){
    _socketManager.socketDispose();
  }

  void socketDisconnect(){
    _socketManager.socketDisconnect();
  }

  void socketDisableListeners(){
    _socketManager.socketDisableListeners();
  }

  // bool socketConnected(){
  //   return _socketManager.socketIsConnected();
  // }

  void dbClose(){
    _realmDbManager.closeDB();
  }

  void setupListeners()
  {
    _socketManager.socketManagementSetupListeners();
  }

  Future<bool> checkForUpdateData()async{
    bool resFinal = true;
    List<String> idToUpdate = _realmDbManager.dataToUpdate.keys.toList();
    await Future.forEach(idToUpdate, (st)async {
      bool res = await _socketManager.checkForUpdateDataSocket(st);
      if(res == false){
        resFinal = false;
      }
    });
    return resFinal;
  }

  Future<bool> getData(String type)async {
    bool resFinal = true;
    List<String> studentsId = type == 'update'?_realmDbManager.dataToUpdate.keys.toList() : _realmDbManager.dataToGet.keys.toList();
    await Future.forEach(studentsId, (st)async{
      bool res = await _socketManager.getPersonalDataSocket(st, type);
      if(res == true){
        List<String>? stList = type == 'update'?_realmDbManager.dataToUpdate[st]: List.generate(_realmDbManager.dataToGet[st]!, (index) => index.toString());
        await Future.forEach<String>(stList!, (session)async {
          bool res = await _socketManager.getPersonalSessionSocket(st, session, type);
          if(res == false){
            resFinal = false;
          }
        });
      }
      else{
        resFinal == false;
      }
    });
    return resFinal;
  }

  Future<bool> deleteData()async{
    int res = await _realmDbManager.deleteDataDB();
    return res == 0? true : false;
  }

  Future<bool> deleteAllData()async{
    int res = await _realmDbManager.deleteAllDataDB();
    return res == 0? true : false;
  }

  Future<bool> deleteDataPressed(String? stList)async{
    List<String> studentsId = stList!.replaceAll(' ', '').split(',');
    await Future.forEach<String>(studentsId, (st)async {
      bool resFromLocal = _realmDbManager.checkStudentDB(st);
      bool resFromServer = await _socketManager.checkStudentIsExistsSocket(st);
      if(resFromLocal && resFromServer){
        _realmDbManager.dataToDelete.add(st);
      }
    });
    bool res = await deleteData();
    return res; 
  }

  FutureOr<bool> syncDataPressed(String? stList)async{
    _realmDbManager.cleanDataBeforeCheckDB();
    if(stList != '' && stList != null){
      await checkForIdList(stList, 'sync');
      bool res = await checkForUpdateData();
      if(res){
        bool res = await syncData();
        return res;
      }
      return res;
    }
    else{
      return false;
    }
  }

  FutureOr<bool> syncAllPressed(String? all)async{
    _realmDbManager.cleanDataBeforeCheckDB();
    await checkForIdList('', 'all');
    bool res = await checkForUpdateData();
      if(res){
        bool res = await syncData();
        return res;
      }
    return res;
  }

  Future<bool> syncData()async{
    List<bool> resList = [_realmDbManager.dataToDelete.isNotEmpty, _realmDbManager.dataToGet.isNotEmpty, _realmDbManager.dataToUpdate.isNotEmpty];
    if(resList[0]){
      resList[0] = await deleteData();
    }
    else{
      resList[0] = !resList[0];
    }
    if(resList[1]){
      resList[1] = await getData('get');
    }
    else{
      resList[1] = !resList[1];
    }
    if(resList[2]){
      resList[2] = await getData('update');
    }
    else{
      resList[2] = !resList[2];
    }
    return resList[0] && resList[1] && resList[2];
  }

  Future<void> checkForIdList(String stList, String type)async{
    List<String> studentsId = [];
    if(type == 'all'){
      bool res = await _socketManager.getStudentsIdFromServer();
      if(res == true){
        studentsId = (_realmDbManager.dataToGet.keys.toList() + _realmDbManager.getStudentsIdFromRealmDB()).toSet().toList();
        _realmDbManager.dataToGet.clear();
      }
    }
    else{
      studentsId = stList.replaceAll(' ', '').split(',');
    }
    await Future.forEach<String>(studentsId, (st)async{
      bool resFromLocal = _realmDbManager.checkStudentDB(st);
      bool resFromServer = await _socketManager.checkStudentIsExistsSocket(st);
      if(!resFromLocal && !resFromServer){
        _realmDbManager.invalidIDs.add(st);
      }
      else{
        if(resFromLocal && !resFromServer){
          _realmDbManager.dataToDelete.add(st);
        }
        else if(!resFromLocal && resFromServer){
          _realmDbManager.dataToGet[st] = 0;
        }
        else{
          _realmDbManager.dataToUpdate[st] = [];
        }
      }
    });
    stdout.writeln("delete: ${_realmDbManager.dataToDelete.toString()}");
    stdout.writeln("update: ${_realmDbManager.dataToUpdate.toString()}");
    stdout.writeln("get: ${_realmDbManager.dataToGet.toString()}");
    stdout.writeln("validID: ${_realmDbManager.validIDs.toString()}");
    stdout.writeln("invalidID: ${_realmDbManager.invalidIDs.toString()}");
  }

  List<(DateTime, List<int>)>? getFilteredStudentData(String name, String group, DateTime startDate, DateTime endDate){
    return _realmDbManager.getStudentFromDB(name, group, startDate, endDate);
  }

  List<String> getGroupNames(){
    return _realmDbManager.getGroupNamesDB();
  }

  List<String> getStudentNames(){
    return _realmDbManager.getStudentNamesDB();
  }

  List<String> getStudentsWithTheSameGroup(String group){
    return _realmDbManager.getStudentsWithTheSameGroupDB(group);
  }

}

