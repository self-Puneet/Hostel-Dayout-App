// lib/presentation/components/warden_request_list_tab.dart

// Other tabs: read-only cards
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:hostel_mgmt/core/enums/enum.dart';
import 'package:hostel_mgmt/presentation/components/simple_action_request_card.dart';
import 'package:hostel_mgmt/presentation/view/warden/controller/warden_action_page_controller.dart';
import 'package:hostel_mgmt/presentation/view/warden/state/warden_action_state.dart';

Future<void> _openDialer(String number) async {
  final Uri phoneUri = Uri(scheme: 'tel', path: number);
  if (await canLaunchUrl(phoneUri)) {
    await launchUrl(phoneUri);
  } else {
    throw 'Could not open dialer for $number';
  }
}

class StatusList extends StatelessWidget {
  final TimelineActor actor;
  final WardenActionPageController stateController;
  final RequestStatus status;

  const StatusList({
    super.key,
    required this.actor,
    required this.stateController,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final horizontalPad = EdgeInsets.symmetric(
      horizontal: 31 * media.size.width / 402,
    );

    return Container(
      margin: horizontalPad,
      child: Consumer<WardenActionState>(
        builder: (context, s, _) {
          // Per-tab data is derived on demand from the master list to avoid stale carryover.
          final items = stateController.getRequestsForStatus(status);
          if (items.isEmpty) {
            final q = s.filterController.text.trim();
            return LayoutBuilder(
              builder: (context, constraints) => SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: Center(
                    child: Text(
                      q.isEmpty ? 'Nothing here yet' : 'No matches for "$q"',
                    ),
                  ),
                ),
              ),
            );
          }

          return ListView.separated(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
            itemCount: items.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, i) {
              final wrap = items[i];
              final req = wrap.request;
              final stu = wrap.student;
              final safeName = (stu.name).isEmpty ? 'Unknown' : stu.name;

              final bool isLate = req.appliedTo.isBefore(DateTime.now());

              // Read-only cards: selection/actions are disabled; acceptance dials the student.
              return SimpleActionRequestCard(
                profileImageUrl: stu.profilePic,
                reason: req.reason,
                name: safeName,
                status: req.status,
                leaveType: req.requestType,
                fromDate: req.appliedFrom,
                toDate: req.appliedTo,
                selected: false,
                isRejection: false,
                isLate: isLate,
                borderColor: isLate ? Colors.red : null,
                acceptenceIcon: Icons.phone,
                accrptenceCOlor: Colors.blue,
                onLongPress: null,
                onTap: null,
                onRejection: null,
                onAcceptence: () async {
                  await _openDialer(stu.phoneNo);
                },
              );
            },
          );
        },
      ),
    );
  }
}
