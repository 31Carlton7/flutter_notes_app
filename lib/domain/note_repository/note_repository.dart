import 'dart:convert';

import 'package:canton_design_system/canton_design_system.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:notes_app/src/models/note.dart';

class NoteRepository extends StateNotifier<List<Note>> {
  NoteRepository() : super([]);

  /// Adds a [Note] to the note list.
  Future<void> addNote(Note note) async {
    state = [...state, note];
    saveData();
  }

  /// Removes specified [Note] from note list.
  Future<void> removeNote(Note note) async {
    state = [
      for (final nNote in state)
        if (note != nNote) nNote,
    ];
    saveData();
  }

  /// Updates specified [Note].
  Future<void> updateNote({
    @required Note note,
    String content,
    bool pinned,
    bool locked,
    String password,
    DateTime lastEditDate,
  }) async {
    note.content = content ?? note.content;
    note.lastEditDate = lastEditDate ?? note.lastEditDate;
    note.pinned = pinned ?? note.pinned;
    note.locked = locked ?? note.locked;
    note.password = password ?? note.password;
    sortList();
    saveData();
  }

  /// Saves entire note list to the device.
  void saveData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    List<String> savedNoteList =
        state.map((note) => json.encode(note.toMap())).toList();
    prefs.setStringList('note_list', savedNoteList);
  }

  /// Loads all [Note] (s) from note list stored within the device.
  void loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    /// Removes all [Note] (s) from device.
    // prefs.remove('note_list');

    List<String> savedNoteList = prefs.getStringList('note_list');
    state =
        savedNoteList.map((note) => Note.fromMap(json.decode(note))).toList();
  }

  /// Sorts note list by dateOfLastEdit. The [Note] with the most recent dateOfLastEdit
  /// will be the first [Note] in the note list.
  Future<void> sortList() async {
    state = [
      ...state..sort((a, b) => b.lastEditDate.compareTo(a.lastEditDate))
    ];
  }

  /// Creates custom string for dateTime elements.
  static String dateTimeString(DateTime dt) {
    var dtInLocal = dt.toLocal();
    var now = DateTime.now().toLocal();
    var dateString = "Saved ";

    var diff = now.difference(dtInLocal);

    if (now.day == dtInLocal.day) {
      // Creates format like: 12:35 PM,
      var todayFormat = DateFormat("h:mm a");
      dateString += todayFormat.format(dtInLocal);
    } else if ((diff.inDays) == 1 ||
        (diff.inSeconds < 86400 && now.day != dtInLocal.day)) {
      dateString += "Yesterday";
    } else {
      var monthYearFormat = DateFormat("M/d/y");
      dateString += monthYearFormat.format(dtInLocal);
    }
    return dateString;
  }
}
