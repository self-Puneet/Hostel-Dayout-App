import 'package:flutter/material.dart';
import 'package:hostel_mgmt/models/branch_model.dart';
import 'package:hostel_mgmt/models/parent_model.dart';
import 'package:hostel_mgmt/models/student_profile.dart';
import 'package:provider/provider.dart';
// import '../../../models/hostels_model.dart';
import '../state/profile_state.dart';
import '../controllers/profile_controller.dart';
import '../../../services/profile_service.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late final ProfileState state;
  late final ProfileController controller;
  late final ProfileService service;

  // Controllers for editable fields
  late TextEditingController roomNoController;
  String? selectedHostel;
  String? selectedBranch;
  int? selectedSemester;
  String? selectedRelation;

  @override
  void initState() {
    super.initState();
    state = ProfileState();
    service = ProfileService();
    controller = ProfileController(state: state, service: service);
    controller.initialize();
    roomNoController = TextEditingController();
  }

  @override
  void dispose() {
    roomNoController.dispose();
    super.dispose();
  }

  void _enterEditMode() {
    final profile = state.profile;
    if (profile != null) {
      roomNoController.text = profile.roomNo;
      selectedHostel = profile.hostelName;
      selectedBranch = profile.branch;
      selectedSemester = profile.semester;
      // Use first parent for now (can be improved for multiple parents)
      if (profile.parents.isNotEmpty) {
        selectedRelation = profile.parents[0].relation;
      }
    }
    controller.toggleEdit();
  }

  void _onConfirm() {
    final profile = state.profile;
    if (profile == null) return;
    // Update first parent only (can be improved for multiple parents)
    List<ParentModel> updatedParents = profile.parents.isNotEmpty
        ? [
            ParentModel(
              parentId: profile.parents[0].parentId,
              name: profile.parents[0].name,
              relation: selectedRelation ?? profile.parents[0].relation,
              phoneNo: profile.parents[0].phoneNo,
              email: profile.parents[0].email,
              languagePreference: profile.parents[0].languagePreference,
            ),
          ]
        : [];
    final updated = StudentProfileModel(
      studentId: profile.studentId,
      enrollmentNo: profile.enrollmentNo,
      name: profile.name,
      email: profile.email,
      phoneNo: profile.phoneNo,
      profilePic: profile.profilePic,
      hostelName: selectedHostel ?? '',
      roomNo: roomNoController.text,
      semester: selectedSemester ?? 0,
      branch: selectedBranch ?? '',
      parents: updatedParents,
    );
    controller.confirmEdit(updated);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: state,
      child: Consumer<ProfileState>(
        builder: (context, state, _) {
          if (state.isLoading || state.profile == null) {
            return const Center(child: CircularProgressIndicator());
          }
          final profile = state.profile!;
          final isEditing = state.isEditing;
          final branches = state.branches;
          final hostels = state.hostels;
          final branchModel = branches.firstWhere(
            (b) => b.branchId == (selectedBranch ?? profile.branch),
            orElse: () => branches.isNotEmpty
                ? branches[0]
                : BranchModel(branchId: '', name: '', maxSemester: 0),
          );

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (!isEditing)
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: _enterEditMode,
                  ),
                _ProfilePicSection(profile: profile),
                const SizedBox(height: 16),
                _sectionTitle('Student Info'),
                _infoRow('Enrollment No', profile.enrollmentNo),
                _infoRow('Name', profile.name),
                _infoRow('Email', profile.email),
                _infoRow('Phone No', profile.phoneNo),
                _dropdownOrText(
                  label: 'Hostel',
                  value: isEditing ? selectedHostel : profile.hostelName,
                  items: hostels.map((h) => h.hostelName).toList(),
                  enabled: isEditing,
                  onChanged: (v) => setState(() => selectedHostel = v),
                ),
                _textOrField(
                  label: 'Room No',
                  value: profile.roomNo,
                  controller: roomNoController,
                  enabled: isEditing,
                ),
                _dropdownOrText(
                  label: 'Branch',
                  value: isEditing ? selectedBranch : profile.branch,
                  items: branches.map((b) => b.branchId).toList(),
                  enabled: isEditing,
                  onChanged: (v) {
                    setState(() {
                      selectedBranch = v;
                      selectedSemester = null;
                    });
                  },
                ),
                _dropdownOrText(
                  label: 'Semester',
                  value: isEditing
                      ? (selectedSemester?.toString() ?? '')
                      : profile.semester.toString(),
                  items: selectedBranch == null && !isEditing
                      ? []
                      : List.generate(
                          branchModel.maxSemester,
                          (i) => (i + 1).toString(),
                        ),
                  enabled: isEditing && selectedBranch != null,
                  onChanged: (v) =>
                      setState(() => selectedSemester = int.tryParse(v ?? '')),
                ),
                const SizedBox(height: 24),
                _sectionTitle('Parent Info'),
                _infoRow(
                  'Name',
                  profile.parents.isNotEmpty ? profile.parents[0].name : '',
                ),
                _dropdownOrText(
                  label: 'Relation',
                  value: isEditing
                      ? selectedRelation
                      : (profile.parents.isNotEmpty
                            ? profile.parents[0].relation
                            : ''),
                  items: const ['Father', 'Mother', 'Guardian'],
                  enabled: isEditing,
                  onChanged: (v) => setState(() => selectedRelation = v),
                ),
                _infoRow(
                  'Phone No',
                  profile.parents.isNotEmpty ? profile.parents[0].phoneNo : '',
                ),
                if (state.validationError != ProfileValidationError.none)
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Text(
                      _validationMessage(state.validationError),
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                if (isEditing)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => controller.cancelEdit(context),
                        child: const Text('Cancel'),
                      ),
                      ElevatedButton(
                        onPressed: _onConfirm,
                        child: const Text('Confirm'),
                      ),
                    ],
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _sectionTitle(String title) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: Text(
      title,
      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
    ),
  );

  Widget _infoRow(String label, String value) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(
      children: [
        SizedBox(width: 120, child: Text(label)),
        Expanded(child: Text(value)),
      ],
    ),
  );

  Widget _dropdownOrText({
    required String label,
    required String? value,
    required List<String> items,
    required bool enabled,
    ValueChanged<String?>? onChanged,
  }) {
    if (!enabled) {
      return _infoRow(label, value ?? '');
    }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(width: 120, child: Text(label)),
          Expanded(
            child: DropdownButton<String>(
              value: value?.isNotEmpty == true ? value : null,
              items: items
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: onChanged,
              isExpanded: true,
              hint: Text('Select $label'),
              disabledHint: Text('Select branch first'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _textOrField({
    required String label,
    required String value,
    required TextEditingController controller,
    required bool enabled,
  }) {
    if (!enabled) {
      return _infoRow(label, value);
    }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(width: 120, child: Text(label)),
          Expanded(
            child: TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(hintText: 'Enter $label'),
            ),
          ),
        ],
      ),
    );
  }

  String _validationMessage(ProfileValidationError error) {
    switch (error) {
      case ProfileValidationError.emptyHostel:
        return 'Hostel cannot be empty.';
      case ProfileValidationError.emptyRoomNo:
        return 'Room No cannot be empty.';
      case ProfileValidationError.invalidRoomNo:
        return 'Room No must be a positive number.';
      case ProfileValidationError.emptySemester:
        return 'Semester cannot be empty.';
      case ProfileValidationError.emptyBranch:
        return 'Branch cannot be empty.';
      case ProfileValidationError.emptyParentRelation:
        return 'Parent relation cannot be empty.';
      default:
        return '';
    }
  }
}

class _ProfilePicSection extends StatelessWidget {
  final StudentProfileModel profile;
  const _ProfilePicSection({required this.profile});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircleAvatar(
        radius: 48,
        backgroundImage: profile.profilePic.isNotEmpty
            ? NetworkImage(profile.profilePic)
            : null,
        child: profile.profilePic.isEmpty
            ? const Icon(Icons.person, size: 48)
            : null,
      ),
    );
  }
}
