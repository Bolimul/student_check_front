import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:student_check/RealmDBManagement/realm_db_manager.dart';


class SocketManager {
  SocketManager._privateConstructor();
  final Socket _socket = io(dotenv.env['SOCKET_API_LINK'], OptionBuilder().setTransports(['websocket']).disableAutoConnect().build());
  final RealmDbManager _realmDbManager = RealmDbManager();
  static final SocketManager _socketManagement = SocketManager._privateConstructor();
  final List responseDict = [true, false, null];

  factory SocketManager(){
    return _socketManagement;
  }

  Future<void> socketConnect()async{
    _socket.connect();
    sleep(const Duration(seconds: 5));
  }

  void socketDispose(){
    _socket.dispose();
  }

  void socketDisconnect(){
    _socket.disconnect();
  }

  void socketDisableListeners(){
    _socket.clearListeners();
  }

  bool socketIsConnected(){
    return _socket.connected;
  }

  void socketManagementSetupListeners(){
    _socket.onConnect((socket) {
      stdout.writeln("Socket Connected");
    });
    _socket.onConnectError((error){
      stdout.writeln(error.toString());
    });
    _socket.onDisconnect((socket) {
      stdout.writeln("Socket Disconnected");
    });
    _socket.on('GetPersonalDataClient', (data)async {
      final ack = data.last as Function;
      int res = await _realmDbManager.getPersonalDataClientDB(data);
      ack(responseDict[res]);
    });
    _socket.on('GetPersonalSessionClient', (data)async {
      final ack = data.last as Function;
      int res = await _realmDbManager.getPersonalSessionClientDB(data);
      ack(responseDict[res]);
    });
    _socket.on('checkUpdateDataClient', (data)async{
      final ack = data.last as Function;
      int res = await _realmDbManager.checkUpdateDataClientDB(data);
      ack(responseDict[res]);
    });
    _socket.on('checkUpdateDataSessionsClient', (data)async{
      final ack = data.last as Function;
      int res = await _realmDbManager.checkUpdateDataSessionsClientDB(data);
      ack(responseDict[res]);
    });
    _socket.on('getStudentsIdClient', (data)async{
      final ack = data.last as Function;
      int res = await _realmDbManager.getStudentsDB(data);
      ack(responseDict[res]);
    });
  }


  Future<bool> checkForUpdateDataSocket(String id)async{
    bool res = await _socket.emitWithAckAsync('checkUpdateDataServer', {'id': id});
    return res;
  }

  Future<bool> getPersonalDataSocket(String id, String type)async{
    bool res = await _socket.emitWithAckAsync('GetPersonalDataServer', {'id': id, 'type': type});
    return res;
  }

  Future<bool> getPersonalSessionSocket(String id, String sessionIdentifier, String type)async{
    bool res = await _socket.emitWithAckAsync('GetPersonalSessionServer', {'id': id, 'sessionIdentifier': sessionIdentifier, 'type': type});
    return res;
  }

  Future<bool> getStudentsIdFromServer()async{
    bool res = await _socket.emitWithAckAsync('getStudentsId', '');
    return res;
  }

  Future<bool> checkStudentIsExistsSocket(String studentId)async{
    bool res = await _socket.emitWithAckAsync('checkStudentIsExistsServer', {'id': studentId});
    return res;
  }
  

}