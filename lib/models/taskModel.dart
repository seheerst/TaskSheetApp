import 'package:uuid/uuid.dart';

class Task {
  final String id;
  final String name;
  final DateTime createdAt;
  final bool isComplated;

  Task(
      {required this.id,
      required this.name,
      required this.createdAt,
      required this.isComplated});

  factory Task.create({required String name, required DateTime createdAt}) {
    return Task(
        id: const Uuid().v1(),
        name: name,
        createdAt: createdAt,
        isComplated: false);
  }
}
