import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'flutter_flow/flutter_flow_util.dart';
import 'dart:convert';

class FFAppState extends ChangeNotifier {
  static FFAppState _instance = FFAppState._internal();

  factory FFAppState() {
    return _instance;
  }

  FFAppState._internal();

  static void reset() {
    _instance = FFAppState._internal();
  }

  Future initializePersistedState() async {
    prefs = await SharedPreferences.getInstance();
    _safeInit(() {
      _module1Complete =
          prefs.getBool('ff_module1Complete') ?? _module1Complete;
    });
    _safeInit(() {
      _module2Complete =
          prefs.getBool('ff_module2Complete') ?? _module2Complete;
    });
    _safeInit(() {
      _mod1GameCompleted =
          prefs.getBool('ff_mod1GameCompleted') ?? _mod1GameCompleted;
    });
    _safeInit(() {
      _mod2GameCompleted =
          prefs.getBool('ff_mod2GameCompleted') ?? _mod2GameCompleted;
    });
  }

  void update(VoidCallback callback) {
    callback();
    notifyListeners();
  }

  late SharedPreferences prefs;

  /// a list of strings (26 items, one per letter cell).
  ///
  /// Initialize all as ""
  List<String> _gridCells = [];
  List<String> get gridCells => _gridCells;
  set gridCells(List<String> value) {
    _gridCells = value;
  }

  void addToGridCells(String value) {
    gridCells.add(value);
  }

  void removeFromGridCells(String value) {
    gridCells.remove(value);
  }

  void removeAtIndexFromGridCells(int index) {
    gridCells.removeAt(index);
  }

  void updateGridCellsAtIndex(
    int index,
    String Function(String) updateFn,
  ) {
    gridCells[index] = updateFn(_gridCells[index]);
  }

  void insertAtIndexInGridCells(int index, String value) {
    gridCells.insert(index, value);
  }

  /// a JSON string (or a list of custom data types) storing each clue's number,
  /// direction, text, answer, and starting grid position.
  List<dynamic> _clues = [
    jsonDecode(
        '{\"number\":1,\"direction\":\"down\",\"clue\":\"Measure of association\",\"answer\":\"ODDSRATIO\",\"startRow\":0,\"startCol\":8}'),
    jsonDecode(
        '{\"number\":2,\"direction\":\"across\",\"clue\":\"Type of diseases best suited for case-control\",\"answer\":\"RARE\",\"startRow\":1,\"startCol\":5}'),
    jsonDecode(
        '{\"number\":3,\"direction\":\"down\",\"clue\":\"Bias reduced by matching\",\"answer\":\"INDIVIDUAL\",\"startRow\":2,\"startCol\":4}'),
    jsonDecode(
        '{\"number\":4,\"direction\":\"across\",\"clue\":\"Direction of case-control studies\",\"answer\":\"BACKWARD\",\"startRow\":3,\"startCol\":1}'),
    jsonDecode(
        '{\"number\":5,\"direction\":\"down\",\"clue\":\"Type of matching done one-to-one\",\"answer\":\"PAIRMATCHING\",\"startRow\":3,\"startCol\":6}'),
    jsonDecode(
        '{\"number\":6,\"direction\":\"across\",\"clue\":\"Common source of both cases and controls\",\"answer\":\"EXPOSURE\",\"startRow\":4,\"startCol\":6}'),
    jsonDecode(
        '{\"number\":7,\"direction\":\"across\",\"clue\":\"Bias due to improper sampling\",\"answer\":\"SELECTIONBIAS\",\"startRow\":6,\"startCol\":0}'),
    jsonDecode(
        '{\"number\":8,\"direction\":\"across\",\"clue\":\"Bias due to hospital admission patterns\",\"answer\":\"BERKSON\",\"startRow\":7,\"startCol\":1}'),
    jsonDecode(
        '{\"number\":9,\"direction\":\"down\",\"clue\":\"Bias where cases remember exposures better\",\"answer\":\"RECALL\",\"startRow\":7,\"startCol\":2}')
  ];
  List<dynamic> get clues => _clues;
  set clues(List<dynamic> value) {
    _clues = value;
  }

  void addToClues(dynamic value) {
    clues.add(value);
  }

  void removeFromClues(dynamic value) {
    clues.remove(value);
  }

  void removeAtIndexFromClues(int index) {
    clues.removeAt(index);
  }

  void updateCluesAtIndex(
    int index,
    dynamic Function(dynamic) updateFn,
  ) {
    clues[index] = updateFn(_clues[index]);
  }

  void insertAtIndexInClues(int index, dynamic value) {
    clues.insert(index, value);
  }

  /// integer, starts at 0.
  int _hintsUsed = 0;
  int get hintsUsed => _hintsUsed;
  set hintsUsed(int value) {
    _hintsUsed = value;
  }

  /// boolean, starts at false.
  bool _gameComplete = false;
  bool get gameComplete => _gameComplete;
  set gameComplete(bool value) {
    _gameComplete = value;
  }

  bool _module1Complete = false;
  bool get module1Complete => _module1Complete;
  set module1Complete(bool value) {
    _module1Complete = value;
    prefs.setBool('ff_module1Complete', value);
  }

  bool _module2Complete = false;
  bool get module2Complete => _module2Complete;
  set module2Complete(bool value) {
    _module2Complete = value;
    prefs.setBool('ff_module2Complete', value);
  }

  bool _mod1GameCompleted = false;
  bool get mod1GameCompleted => _mod1GameCompleted;
  set mod1GameCompleted(bool value) {
    _mod1GameCompleted = value;
    prefs.setBool('ff_mod1GameCompleted', value);
  }

  bool _mod2GameCompleted = false;
  bool get mod2GameCompleted => _mod2GameCompleted;
  set mod2GameCompleted(bool value) {
    _mod2GameCompleted = value;
    prefs.setBool('ff_mod2GameCompleted', value);
  }
}

void _safeInit(Function() initializeField) {
  try {
    initializeField();
  } catch (_) {}
}

Future _safeInitAsync(Function() initializeField) async {
  try {
    await initializeField();
  } catch (_) {}
}
