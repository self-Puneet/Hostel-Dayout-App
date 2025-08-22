import 'package:hive/hive.dart';
import '../../domain/entities/parent_info.dart';

part 'parent_info_model.g.dart';

@HiveType(typeId: 5)
class ParentInfoModel extends HiveObject {
  @HiveField(0)
  final String name;
  @HiveField(1)
  final String relationship;
  @HiveField(2)
  final String phone;

  ParentInfoModel({
    required this.name,
    required this.relationship,
    required this.phone,
  });

  String encrypt(String value) => value;
  String decrypt(String value) => value;

  factory ParentInfoModel.fromJson(Map<String, dynamic> json) {
    return ParentInfoModel(
      name: json['name'],
      relationship: json['relationship'],
      phone: json['phone'],
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'relationship': relationship,
        'phone': phone,
      };

  factory ParentInfoModel.fromEntity(ParentInfo entity) {
    return ParentInfoModel(
      name: entity.name,
      relationship: entity.relationship,
      phone: entity.phone,
    );
  }

  ParentInfo toEntity() {
    return ParentInfo(
      name: name,
      relationship: relationship,
      phone: phone,
    );
  }
}
