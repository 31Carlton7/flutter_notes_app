import 'dart:convert';

import 'package:canton_design_system/canton_design_system.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:notes_app/src/models/note.dart';
import 'package:hive/hive.dart';

class NoteRepository extends StateNotifier<List<Note>> {
  NoteRepository() : super([]);

  /// Adds a [Note] to the note list.
  Future<void> addNote(Note note) async {
    state = [note, ...state];
    await _saveData();
  }

  /// Removes specified [Note] from note list.
  Future<void> removeNote(Note note) async {
    state = [
      for (final nNote in state)
        if (note != nNote) nNote,
    ];
    await _saveData();
  }

  /// Updates specified [Note].
  Future<void> updateNote({
    required Note note,
    String? title,
    String? content,
    List<Tag>? tags,
    bool? pinned,
    String? password,
    DateTime? lastEditDate,
  }) async {
    note.title = title ?? note.title;
    note.content = content ?? note.content;
    note.tags = tags ?? note.tags;
    note.lastEditDate = lastEditDate ?? note.lastEditDate;
    note.pinned = pinned ?? note.pinned;
    note.password = password ?? note.password;
    sortList();
    await _saveData();
  }

  /// Saves entire note list to the device.
  Future<void> _saveData() async {
    var box = Hive.box('flutter_notes_app');

    List<String> savedNoteList = state.map((note) => json.encode(note.toMap())).toList();
    await box.put('notes', savedNoteList);
  }

  /// Loads all [Note] (s) from note list stored within the device.
  Future<void> loadData() async {
    var box = Hive.box('flutter_notes_app');

    /// Removes all [Note] (s) from device.
    // box.delete('notes');

    List<String> savedNoteList = box.get('notes', defaultValue: <String>[]);
    state = savedNoteList.map((note) => Note.fromMap(json.decode(note))).toList();
  }

  /// Sorts note list by dateOfLastEdit. The [Note] with the most recent dateOfLastEdit
  /// will be the first [Note] in the note list.
  void sortList() {
    state = [...state..sort((a, b) => b.lastEditDate!.compareTo(a.lastEditDate!))];
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
    } else if ((diff.inDays) == 1 || (diff.inSeconds < 86400 && now.day != dtInLocal.day)) {
      dateString += "Yesterday";
    } else {
      var monthYearFormat = DateFormat("M/d/y");
      dateString += monthYearFormat.format(dtInLocal);
    }
    return dateString;
  }
}
