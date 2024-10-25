import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:student_check/Controller%20and%20Middleware/controller.dart';

class UserProvider extends ChangeNotifier{
  final Controller _controller = Controller();
  List<String> _groups = [];
  List<String> _names = [];
  Map<String, List<FlSpot>> _spots = {};
  Map<String, List<(String, int)>> _tableSpots = {};
  final List<bool> _checkboxes = [false, false, false, false];
  final List<bool> _listOfTablesCheckboxes = List.generate(22, (e) => false);
  final List<String> _choosenGroupAndName = ['', ''];
  final List<DateTime> _dateTimeListFinal = [DateTime.now(),DateTime.now()];
  bool _isConnected = true;

  List<String> get groups => _groups;
  List<String> get names => _names;
  DateTime get startDate => _dateTimeListFinal[0];
  DateTime get endDate => _dateTimeListFinal[1];
  String get studentName => _choosenGroupAndName[0];
  String get groupName => _choosenGroupAndName[1];
  List<bool> get checkBoxes => _checkboxes;
  List<bool> get listOfTablesCheckboxes => _listOfTablesCheckboxes;
  Map<String, List<FlSpot>> get spots => _spots;
  Map<String, List<(String, int)>> get tableSpots => _tableSpots;
  bool get isConnected => _isConnected;
  List<(String, String)> get categotyTableList => _controller.categotyTableList;

  void setCheckbox(int index, bool? res){
    _controller.setCheckBox(index, res ?? false);
    _checkboxes[index] = res ?? false;
      for (var i = 0; i < _listOfTablesCheckboxes.length; i++) {
        _controller.setCheckboxForListOfTables(i, false);
        _listOfTablesCheckboxes[i] = false;
      }
    notifyListeners();
  }

  void setCheckboxForListOfTables(int index, bool? res){
    _controller.setCheckboxForListOfTables(index, res ?? false);
    _listOfTablesCheckboxes[index] = res ?? false;
    for (var i = 0; i < _checkboxes.length; i++) {
      _controller.setCheckBox(i, false);
      _checkboxes[i] = false;
    }
    notifyListeners();
  }

  void setGroups(){
    _groups = _controller.getGroupNamesUI();
    notifyListeners();
  }

  void setNames(){
    _names = _choosenGroupAndName[1] == ''? _controller.getStudentNamesUI(): _controller.getStudentsWithTheSameGroupUI(_choosenGroupAndName[1]);
    notifyListeners(); 
  }

  void setStudentName(String name){
    _controller.chosenName = name;
    _choosenGroupAndName[0] = name;
    notifyListeners();
  }

  void setGroupName(String groupName){
    _controller.chosenGroup = groupName;
    _choosenGroupAndName[1] = groupName;
    notifyListeners();
  }

  void setStartAndEndDate(){
    _dateTimeListFinal[0] = _controller.startDate;
    _dateTimeListFinal[1] = _controller.endDate;
    notifyListeners();
  }

  void setListOfSpots()async{
    // ignore: unnecessary_null_comparison
    if(_choosenGroupAndName[0] != '' && _choosenGroupAndName[1] != '' && _choosenGroupAndName[0] != null && _choosenGroupAndName[1] != null){
      await _controller.getSpecificStudentUI(studentName, groupName, startDate, endDate);
    }
    _tableSpots = _controller.tableSpots;
    _spots = _controller.spots;
    notifyListeners();
  }

  void setConnection(bool switcher){
    _isConnected = switcher;
    notifyListeners();
  }

  void setDefault()async{
   await _controller.setDefaultUI();
   for (var i = 0; i < _checkboxes.length; i++) {
      _checkboxes[i] = false;
    }
    for (var i = 0; i < _listOfTablesCheckboxes.length; i++) {
      _listOfTablesCheckboxes[i] = false;
    }
  }
}