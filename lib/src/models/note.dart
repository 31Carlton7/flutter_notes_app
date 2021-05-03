import 'dart:convert';

class Note {
  String id;
  String content;
  String password;
  bool pinned;
  bool locked;
  DateTime creationDate;
  DateTime lastEditDate;
  Note({
    this.id,
    this.content,
    this.password,
    this.pinned,
    this.locked,
    this.creationDate,
    this.lastEditDate,
  });

  Note copyWith({
    String id,
    String content,
    String password,
    bool pinned,
    bool locked,
    DateTime creationDate,
    DateTime lastEditDate,
  }) {
    return Note(
      id: id ?? this.id,
      content: content ?? this.content,
      password: password ?? this.password,
      pinned: pinned ?? this.pinned,
      locked: locked ?? this.locked,
      creationDate: creationDate ?? this.creationDate,
      lastEditDate: lastEditDate ?? this.lastEditDate,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'content': content,
      'password': password,
      'pinned': pinned,
      'locked': locked,
      'creationDate': creationDate.millisecondsSinceEpoch,
      'lastEditDate': lastEditDate.millisecondsSinceEpoch,
    };
  }

  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id'],
      content: map['content'],
      password: map['password'],
      pinned: map['pinned'],
      locked: map['locked'],
      creationDate: DateTime.fromMillisecondsSinceEpoch(map['creationDate']),
      lastEditDate: DateTime.fromMillisecondsSinceEpoch(map['lastEditDate']),
    );
  }

  String toJson() => json.encode(toMap());

  factory Note.fromJson(String source) => Note.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Note(id: $id, content: $content, password: $password, pinned: $pinned, locked: $locked, creationDate: $creationDate, lastEditDate: $lastEditDate)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Note &&
        other.id == id &&
        other.content == content &&
        other.password == password &&
        other.pinned == pinned &&
        other.locked == locked &&
        other.creationDate == creationDate &&
        other.lastEditDate == lastEditDate;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        content.hashCode ^
        password.hashCode ^
        pinned.hashCode ^
        locked.hashCode ^
        creationDate.hashCode ^
        lastEditDate.hashCode;
  }
}
