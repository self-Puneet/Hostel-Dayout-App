import 'package:equatable/equatable.dart';

class StudentInfo extends Equatable {
  final String name;
  final String enrollment;
  final String room;
  final String year;
  final String block;

  StudentInfo({
    required this.name,
    required this.enrollment,
    required this.room,
    required this.year,
    required this.block,
  });

  @override
  List<Object?> get props => [name, enrollment, room, year, block];
}
