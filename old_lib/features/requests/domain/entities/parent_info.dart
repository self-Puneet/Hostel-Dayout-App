import 'package:equatable/equatable.dart';

class ParentInfo extends Equatable {
  final String name;
  final String relationship;
  final String phone;

  ParentInfo({
    required this.name,
    required this.relationship,
    required this.phone,
  });

  @override
  List<Object?> get props => [name, relationship, phone];
}
