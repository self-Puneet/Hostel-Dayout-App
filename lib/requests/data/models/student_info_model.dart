import 'package:hive/hive.dart';
import '../../domain/entities/student_info.dart';

part 'student_info_model.g.dart';

@HiveType(typeId: 4)
class StudentInfoModel extends HiveObject {
  @HiveField(0)
  final String name;
  @HiveField(1)
  final String enrollment;
  @HiveField(2)
  final String room;
  @HiveField(3)
  final String year;
  @HiveField(4)
  final String block;

  StudentInfoModel({
    required this.name,
    required this.enrollment,
    required this.room,
    required this.year,
    required this.block,
  });

  String encrypt(String value) => value;
  String decrypt(String value) => value;

  factory StudentInfoModel.fromJson(Map<String, dynamic> json) {
    return StudentInfoModel(
      name: json['name'],
      enrollment: json['enrollment'],
      room: json['room'],
      year: json['year'],
      block: json['block'],
    );
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'enrollment': enrollment,
    'room': room,
    'year': year,
    'block': block,
  };

  factory StudentInfoModel.fromEntity(StudentInfo entity) {
    return StudentInfoModel(
      name: entity.name,
      enrollment: entity.enrollment,
      room: entity.room,
      year: entity.year,
      block: entity.block,
    );
  }

  StudentInfo toEntity() {
    return StudentInfo(
      name: name,
      enrollment: enrollment,
      room: room,
      year: year,
      block: block,
    );
  }
}
