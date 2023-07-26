import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
part 'taskModel.g.dart';

@HiveType(typeId: 1)
class Task extends HiveObject{
  @HiveField(1)
  final String id;
  @HiveField(2)
  String name;
  @HiveField(3)
  final DateTime createdAt;
  @HiveField(4)
  bool isComplated;

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
