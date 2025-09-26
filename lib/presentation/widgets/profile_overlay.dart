import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hostel_mgmt/core/routes/app_route_constants.dart';

class ProfileOverlay extends StatelessWidget {
  final String name;
  final String subtitle;
  final String? avatarUrl;
  final String? enrollmentNumber;
  final String? hostelName;
  final String? roomNo;
  final String? phoneNumber;
  final VoidCallback onEditProfile;
  final VoidCallback onLogout;
  final VoidCallback onClose;

  const ProfileOverlay({
    super.key,
    required this.name,
    required this.subtitle,
    this.avatarUrl,
    this.enrollmentNumber,
    this.hostelName,
    this.roomNo,
    this.phoneNumber,
    required this.onEditProfile,
    required this.onLogout,
    required this.onClose,
  });

  String getInitials() {
    if (name.trim().isEmpty) return "";
    List<String> parts = name.trim().split(" ");
    if (parts.length == 1) {
      return parts[0][0].toUpperCase();
    } else {
      return (parts[0][0] + parts[1][0]).toUpperCase();
    }
  }

  @override
  Widget build(BuildContext context) {
    // fixedWidth can be tuned for your longest label plus icon
    const double fixedWidth = 115;

    return GestureDetector(
      onTap: onClose, // tap outside closes
      child: Material(
        color: Colors.black54, // dim background
        child: Center(
          child: GestureDetector(
            onTap: () {}, // absorb taps inside card
            child: Container(
              width: 320,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 12,
                    offset: Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Header Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Profile Details",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: onClose,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Avatar
                  CircleAvatar(
                    radius: 36,
                    backgroundImage: avatarUrl != null
                        ? NetworkImage(avatarUrl!)
                        : null,
                    backgroundColor: Colors.blue.shade100,
                    child: avatarUrl == null
                        ? Text(
                            getInitials(),
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          )
                        : null,
                  ),
                  const SizedBox(height: 12),

                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                  ),

                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 8),
                  if (enrollmentNumber != null &&
                      enrollmentNumber!.trim().isNotEmpty)
                    _AlignedInfoRow(
                      icon: Icons.badge_outlined,
                      label: 'Enrollment No',
                      value: enrollmentNumber!,
                      fixedLabelWidth: fixedWidth,
                    ),
                  if (enrollmentNumber != null &&
                      enrollmentNumber!.trim().isNotEmpty)
                    const SizedBox(height: 8),
                  if (hostelName != null && hostelName!.trim().isNotEmpty)
                    _AlignedInfoRow(
                      icon: Icons.home_outlined,
                      label: 'Hostel',
                      value: hostelName!,
                      fixedLabelWidth: fixedWidth,
                    ),
                  if (hostelName != null && hostelName!.trim().isNotEmpty)
                    const SizedBox(height: 8),
                  if (roomNo != null && roomNo!.trim().isNotEmpty)
                    _AlignedInfoRow(
                      icon: Icons.meeting_room_outlined,
                      label: 'Room No',
                      value: roomNo!,
                      fixedLabelWidth: fixedWidth,
                    ),
                  if (roomNo != null && roomNo!.trim().isNotEmpty)
                    const SizedBox(height: 8),
                  if (phoneNumber != null && phoneNumber!.trim().isNotEmpty)
                    _AlignedInfoRow(
                      icon: Icons.phone_outlined,
                      label: 'Phone',
                      value: phoneNumber!,
                      fixedLabelWidth: fixedWidth,
                    ),
                  const SizedBox(height: 20),

                  // Buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            context.push(AppRoutes.profile);
                            Navigator.pop(context);
                          },
                          icon: const Icon(Icons.person),
                          label: const Text(
                            "View Profile",
                            style: TextStyle(color: Colors.black),
                          ),
                          style: OutlinedButton.styleFrom(
                            iconColor: Colors.black,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: onLogout,
                          icon: const Icon(Icons.logout),
                          label: const Text("Logout"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.redAccent,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _AlignedInfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final double fixedLabelWidth;

  const _AlignedInfoRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.fixedLabelWidth,
  });

  @override
  Widget build(BuildContext context) {
    final labelStyle = TextStyle(
      fontSize: 14,
      color: Colors.grey.shade700,
      fontWeight: FontWeight.w500,
    );
    const valueStyle = TextStyle(fontSize: 14, fontWeight: FontWeight.w600);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: Colors.grey.shade700),
        const SizedBox(width: 10),
        SizedBox(
          width: fixedLabelWidth,
          child: Text('$label:', style: labelStyle, textAlign: TextAlign.left),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            value,
            style: valueStyle,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
