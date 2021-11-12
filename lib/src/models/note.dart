import 'dart:convert';

import 'package:canton_design_system/canton_design_system.dart';
import 'package:flutter/foundation.dart';

class Note {
  String? id;
  String? title;
  String? content;
  String? password;
  List<Tag>? tags;
  bool? pinned;
  DateTime? creationDate;
  DateTime? lastEditDate;

  Note({
    this.id,
    this.title,
    this.content,
    this.password,
    this.tags,
    this.pinned,
    this.creationDate,
    this.lastEditDate,
  });

  Note copyWith({
    String? id,
    String? title,
    String? content,
    String? password,
    List<Tag>? tags,
    bool? pinned,
    DateTime? creationDate,
    DateTime? lastEditDate,
  }) {
    return Note(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      password: password ?? this.password,
      tags: tags ?? this.tags,
      pinned: pinned ?? this.pinned,
      creationDate: creationDate ?? this.creationDate,
      lastEditDate: lastEditDate ?? this.lastEditDate,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'password': password,
      'tags': tags?.map((x) => x.toMap()).toList(),
      'pinned': pinned,
      'creationDate': creationDate?.millisecondsSinceEpoch,
      'lastEditDate': lastEditDate?.millisecondsSinceEpoch,
    };
  }

  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id'],
      title: map['title'],
      content: map['content'],
      password: map['password'],
      tags: List<Tag>.from(map['tags']?.map((x) => Tag.fromMap(x))),
      pinned: map['pinned'],
      creationDate: DateTime.fromMillisecondsSinceEpoch(map['creationDate']),
      lastEditDate: DateTime.fromMillisecondsSinceEpoch(map['lastEditDate']),
    );
  }

  String toJson() => json.encode(toMap());

  factory Note.fromJson(String source) => Note.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Note(id: $id, title: $title, content: $content, password: $password, tags: $tags, pinned: $pinned, creationDate: $creationDate, lastEditDate: $lastEditDate)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Note &&
        other.id == id &&
        other.title == title &&
        other.content == content &&
        other.password == password &&
        listEquals(other.tags, tags) &&
        other.pinned == pinned &&
        other.creationDate == creationDate &&
        other.lastEditDate == lastEditDate;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        content.hashCode ^
        password.hashCode ^
        tags.hashCode ^
        pinned.hashCode ^
        creationDate.hashCode ^
        lastEditDate.hashCode;
  }
}
