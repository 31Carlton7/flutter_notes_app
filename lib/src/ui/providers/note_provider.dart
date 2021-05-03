import 'package:notes_app/domain/note_repository/note_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notes_app/src/models/note.dart';

final noteProvider = StateNotifierProvider<NoteRepository, List<Note>>(
    (ref) => NoteRepository());
