class BranchModel {
  final String branchId;
  final String name;
  final int maxSemester;

  BranchModel({
    required this.branchId,
    required this.name,
    required this.maxSemester,
  });

  factory BranchModel.fromJson(Map<String, dynamic> json) {
    return BranchModel(
      branchId: json['branch_id'] as String,
      name: json['name'] as String,
      maxSemester: json['max_semester'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'branch_id': branchId,
      'name': name,
      'max_semester': maxSemester,
    };
  }
}

class BranchResponse {
  final String message;
  final List<BranchModel> branches;

  BranchResponse({
    required this.message,
    required this.branches,
  });

  factory BranchResponse.fromJson(Map<String, dynamic> json) {
    return BranchResponse(
      message: json['message'] as String,
      branches: (json['branches'] as List<dynamic>)
          .map((b) => BranchModel.fromJson(b as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'branches': branches.map((b) => b.toJson()).toList(),
    };
  }
}
