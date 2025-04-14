import 'package:cloud_firestore/cloud_firestore.dart';

class TodoModel {
  final String id;
  String title;
  String description;
  String createdBy;
  String? modifiedBy;
  DateTime? modifiedAt;
  bool isCompleted;
  List<String> sharedWith;

  TodoModel({
    required this.id,
    required this.title,
    required this.description,
    required this.createdBy,
    this.modifiedBy,
    this.modifiedAt,
    this.isCompleted = false,
    this.sharedWith = const [],
  });

  factory TodoModel.fromMap(Map<String, dynamic> map, String docId) {
    return TodoModel(
      id: docId,
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      createdBy: map['createdBy'] ?? '',
      modifiedBy: map['modifiedBy'],
      modifiedAt: map['modifiedAt'] != null
          ? (map['modifiedAt'] as Timestamp).toDate()
          : null,
      isCompleted: map['isCompleted'] ?? false,
      sharedWith: List<String>.from(map['sharedWith'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'createdBy': createdBy,
      'modifiedBy': modifiedBy,
      'modifiedAt': modifiedAt != null ? Timestamp.fromDate(modifiedAt!) : null,
      'isCompleted': isCompleted,
      'sharedWith': sharedWith,
    };
  }

  TodoModel copyWith({
    String? title,
    String? description,
    bool? isCompleted,
    String? modifiedBy,
    DateTime? modifiedAt,
    List<String>? sharedWith,
  }) {
    return TodoModel(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
      createdBy: createdBy,
      modifiedBy: modifiedBy ?? this.modifiedBy,
      modifiedAt: modifiedAt ?? this.modifiedAt,
      sharedWith: sharedWith ?? this.sharedWith,
    );
  }
}
