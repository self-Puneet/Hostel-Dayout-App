class ParentModel {
  final String parentId;
  final String name;
  final String relation;
  final String phoneNo;
  final String? email;
  final String? languagePreference;

  ParentModel({
    required this.parentId,
    required this.name,
    required this.relation,
    required this.phoneNo,
    this.email,
    this.languagePreference,
  });

  factory ParentModel.fromJson(Map<String, dynamic> json) {
    return ParentModel(
      parentId: json['parent_id'] ?? '',
      name: json['name'] ?? '',
      relation: json['relation'] ?? '',
      phoneNo: json['phone_no'] ?? '',
      email: json['email'],
      languagePreference: json['language_preference'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'parent_id': parentId,
      'name': name,
      'relation': relation,
      'phone_no': phoneNo,
      if (email != null) 'email': email,
      if (languagePreference != null) 'language_preference': languagePreference,
    };
  }
}

