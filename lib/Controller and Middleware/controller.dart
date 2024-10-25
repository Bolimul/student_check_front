import 'dart:async';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:student_check/Controller%20and%20Middleware/middleware.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:screenshot/screenshot.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:student_check/UI/Charts%20for%20Screenshot/table_true_false_for_screenshot.dart';

class Controller {
  Controller._privateConstructor();
  static final Controller _controller = Controller._privateConstructor();
  final Middleware _middleware = Middleware();
  final List<bool> _checkboxes = [false, false, false, false];
  final List<bool> _listOfTablesCheckboxes = List.generate(22, (e) => false);
  Map<String, List<FlSpot>> _spots = {};
  Map<String, List<(String, int)>> _tableSpots = {};
  final List<String> _choosenGroupAndName = ['', ''];
  final List<DateTime> _dateTimeListFinal = [DateTime.now(),DateTime.now(), DateTime.now()];
  final ScreenshotController _scrCont = ScreenshotController();
  bool _isPlaced = true;
  final List<(String, String)> _categotyTableList = [
    ('5', "Param 5"), ('6', "Param 6"), ('7', "Param 7"), ('8', "Param 8"), ('9', "Param 9"), ('10', "Param 10"), ('11', "Param 11"),
    ('12', "Param 12"), ('13', "Param 13"), ('14', "Param 14"), ('15', "Param 15"), ('16', "Param 16"), ('17', "Param 17"), ('18', "Param 18"),
    ('19', "Param 19"), ('20', "Param 20"), ('21', "Param 21"), ('22', "Param 22"), ('23', "Param 23"), ('24', "Param 24"),('25', "Param 25"),('26', "Param 26")];

  factory Controller(){
      return _controller;
    }

  List<String> get groups => getGroupNamesUI();
  List<String> get names => _choosenGroupAndName[1].isEmpty? getStudentNamesUI() : getStudentsWithTheSameGroupUI(_choosenGroupAndName[1]);
  List<bool> get checkBoxes => _checkboxes;
  List<bool> get listOfTablesCheckboxes => _listOfTablesCheckboxes;
  Map<String, List<FlSpot>> get spots => _spots;
  Map<String, List<(String, int)>> get tableSpots => _tableSpots;
  List<(String, String)> get categotyTableList => _categotyTableList;
  String get chosenName =>  _choosenGroupAndName[0];
  String get chosenGroup => _choosenGroupAndName[1];
  set chosenName(String name) => _choosenGroupAndName[0] = name;
  set chosenGroup(String group) => _choosenGroupAndName[1] = group;
  set firstDate(DateTime date) => _dateTimeListFinal[2] = date;
  DateTime get startDate => _dateTimeListFinal.isNotEmpty? _dateTimeListFinal[0]: DateTime.now();
  DateTime get endDate => _dateTimeListFinal.length > 1? _dateTimeListFinal[1]: DateTime.now();
  DateTime get firstDate => _dateTimeListFinal[2];
  List<DateTime> get dateTimeListFinal => _dateTimeListFinal;
  ScreenshotController get scrCont => _scrCont;
  bool get isPlaced => _isPlaced;
  
  void setIsPlaced(bool res){
    _isPlaced = res;
  }

  void setCheckBox(int index, bool res){
    _checkboxes[index] = res;
  }

  void setCheckboxForListOfTables(int index, bool res){
    _listOfTablesCheckboxes[index] = res;
  }

  

  FutureOr<bool> syncDataUI(String? stList)async{
    return await _middleware.syncDataPressed(stList);
  }

  FutureOr<bool> syncAllUI(String? stList)async{
    return await _middleware.syncAllPressed(stList);
  }

  FutureOr<bool> deleteDataUI(String? stList)async{
    return await _middleware.deleteDataPressed(stList);
  }

  FutureOr<bool> deleteAllDataUI(String? stList)async{
    return await _middleware.deleteAllData();
  }

  Future<void> connectSocketUI()async{
    await _middleware.socketConnect();
  }

  void disposeSocketUI(){
    _middleware.socketDispose();
  }

  void disconnectSocketUI(){
    _middleware.socketDisconnect();
  }

  void disableListenersUI(){
    _middleware.socketDisableListeners();
  }

  // bool socketIsConnectedUI(){
  //   return _middleware.socketConnected();
  // }

  void closeDBUI(){
    _middleware.dbClose();
  }

  void socketListenersSetupUI(){
    _middleware.setupListeners();
  }

  FutureOr<bool> getSpecificStudentUI(String name, String group, DateTime startDate, DateTime endDate){
    List<(DateTime, List<int>)>? paramsList = _middleware.getFilteredStudentData(name, group, startDate, endDate);
      Map<String, List<FlSpot>> resultLineChart = {};
      Map<String, List<(String, int)>> resultTableSpot = {};
      if(paramsList != null && paramsList.isNotEmpty){
        _dateTimeListFinal[0] = paramsList.first.$1;
        _dateTimeListFinal[1] = paramsList.last.$1;
        int desiredLength = paramsList[0].$2.length;
        for (var i = 0; i < desiredLength; i++) {
          if(i < 4){
            resultLineChart[(i+1).toString()] = [];
          }
          else{
            resultTableSpot[(i+1).toString()] = [];
          }
          for (var session in paramsList) {
            var (date, info) = session;
            if(resultLineChart[(i+1).toString()] != null){
              resultLineChart[(i+1).toString()]!.add(FlSpot(date.millisecondsSinceEpoch.toDouble(), info[i].toDouble()));
            }
            else if(resultTableSpot[(i+1).toString()] != null){
              resultTableSpot[(i+1).toString()]!.add(("${date.day}/${date.month}/${date.year}", info[i]));
            }
          }
        }
        _tableSpots = resultTableSpot;
        _spots = resultLineChart;
        return true;
      }
      return false;
  }

  List<String> getGroupNamesUI(){
    return _middleware.getGroupNames();
  }

  List<String> getStudentNamesUI(){
    return _middleware.getStudentNames();
  }

  List<String> getStudentsWithTheSameGroupUI(String group){
    return _middleware.getStudentsWithTheSameGroup(group);
  }

  Future<bool> setDefaultUI()async{
    chosenName = '';
    chosenGroup = '';
    for (var i = 0; i < _checkboxes.length; i++) {
      _checkboxes[i] = false;
    }
    for (var i = 0; i < _listOfTablesCheckboxes.length; i++) {
      _listOfTablesCheckboxes[i] = false;
    }
    _spots = {};
    _tableSpots = {};
    return true;
  }

  Future<void> setTimeUI(BuildContext context)async
  {
    List<DateTime>? dateTimeList = await showOmniDateTimeRangePicker(
      context: context,
      startInitialDate: DateTime.now(),
      startFirstDate: DateTime(1600).subtract(const Duration(days: 3650)),
      startLastDate: DateTime.now().add(const Duration(days: 3650)),
      endInitialDate: DateTime.now(),
      endFirstDate: DateTime(1600).subtract(const Duration(days: 3651)),
      endLastDate: DateTime.now().add(const Duration(days: 3651)),
      is24HourMode: false,
      isForceEndDateAfterStartDate: true,
      isShowSeconds: false,
      minutesInterval: 1,
      secondsInterval: 1,
      borderRadius: const BorderRadius.all(Radius.circular(16)),
      constraints: const BoxConstraints(maxWidth: 350, maxHeight: 650),
      transitionBuilder: (context, anim1, anim2, child) {
        return FadeTransition(
          opacity: anim1.drive(
            Tween(begin: 0, end: 1)
          ),
          child: child,
        );
      },
      transitionDuration: const Duration(milliseconds: 200),
      barrierDismissible: true,
    );
    if(dateTimeList?[0] != null && dateTimeList?[1] != null)
    {
      if(dateTimeList![0].isBefore(dateTimeList[1]))
      {
        _dateTimeListFinal[0] = dateTimeList[0];
        _dateTimeListFinal[1] = dateTimeList[1];
        _dateTimeListFinal[2] = dateTimeList[0];
      }
    }
      
  }

  Future<void> makeAndDownloadImage(BuildContext context, String type) async {
    double ratio = 5;
    try {
      String downloadDir = (await getDownloadsDirectory())?.path as String;
      stdout.writeln("Download Path: $downloadDir");
      if(context.mounted){
        Uint8List? image = type != 'table'? await scrCont.capture():await scrCont.captureFromLongWidget(TableTrueFalseForScreenshot(), pixelRatio: ratio);
          final img = image!.buffer.asUint8List();
          pw.Image img1 = pw.Image(pw.MemoryImage(img));
          final pdf = pw.Document();
          pdf.addPage(pw.Page(
            pageFormat: type != 'table'? PdfPageFormat.a4.landscape : PdfPageFormat.a4.portrait,
            build: (pw.Context context) {
              return pw.Center(
                child: pw.Image(img1.image)
              );
            },
            orientation: type != 'table'? pw.PageOrientation.landscape: pw.PageOrientation.portrait
          ));
          if(context.mounted){
            String fileName = '${_choosenGroupAndName[1]}-${_choosenGroupAndName[0]}-${DateTime.now().microsecondsSinceEpoch}-chart.pdf';
            final file = File("$downloadDir/$fileName");
            if(Platform.isAndroid && await Permission.manageExternalStorage.isGranted == true){
              var res = await file.writeAsBytes(await pdf.save());
              if(res.existsSync()){
                if(context.mounted){
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Pdf was created and downloaded at: $downloadDir')));
                }
              }
              else{
                if(context.mounted){
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Pdf wasn't created and downloaded")));
                }
              }
            }
            else if(Platform.isWindows){
              var res = await file.writeAsBytes(await pdf.save());
              if(res.existsSync()){
                if(context.mounted){
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Pdf was created and downloaded at: $downloadDir')));
                }
              }
              else{
                if(context.mounted){
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Pdf wasn't created and downloaded")));
                }
              }
            }
            else{
              PermissionStatus res = await Permission.manageExternalStorage.request();
              {
                if(res.isGranted){
                  if(context.mounted){
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('You granted the permission. Press "Download" button once again')));
                  }
                }
                else{
                  if(context.mounted){
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("You didn't grant the permittion to download the chart. Chart won't be downloaded")));
                  }
                }
              }
            }
          }
      }
      
    } catch (e) {
      stderr.writeln(e.toString());
    }   
  }
}