import 'dart:convert';

class Note {
  String? id;
  String? title;
  String? content;
  String? password;
  bool? pinned;
  bool? locked;
  DateTime? creationDate;
  DateTime? lastEditDate;
  Note({
    this.id,
    this.title,
    this.content,
    this.password,
    this.pinned,
    this.locked,
    this.creationDate,
    this.lastEditDate,
  });

  Note copyWith({
    String? id,
    String? title,
    String? content,
    String? password,
    bool? pinned,
    bool? locked,
    DateTime? creationDate,
    DateTime? lastEditDate,
  }) {
    return Note(
      id: id ?? this.id,
      title: title ?? this.title,
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
      'title': title,
      'content': content,
      'password': password,
      'pinned': pinned,
      'locked': locked,
      'creationDate': creationDate!.millisecondsSinceEpoch,
      'lastEditDate': lastEditDate!.millisecondsSinceEpoch,
    };
  }

  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id'],
      title: map['title'],
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
    return 'Note(id: $id, title: $title, content: $content, password: $password, pinned: $pinned, locked: $locked, creationDate: $creationDate, lastEditDate: $lastEditDate)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Note &&
        other.id == id &&
        other.title == title &&
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
        title.hashCode ^
        content.hashCode ^
        password.hashCode ^
        pinned.hashCode ^
        locked.hashCode ^
        creationDate.hashCode ^
        lastEditDate.hashCode;
  }
}
