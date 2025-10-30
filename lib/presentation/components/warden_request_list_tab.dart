// lib/presentation/components/warden_request_list_tab.dart

// Other tabs: read-only cards
import 'package:flutter/material.dart';
import 'package:hostel_mgmt/presentation/widgets/custom_icons.dart';
import 'package:hostel_mgmt/presentation/widgets/no_request_card.dart';
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
  final bool showParent;

  const StatusList({
    super.key,
    required this.actor,
    required this.stateController,
    required this.status,
    required this.showParent,
  });

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final horizontalPad = EdgeInsets.symmetric(
      horizontal: 31 * media.size.width / 402,
    );

    final double height = 84 + MediaQuery.of(context).viewPadding.bottom;

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
                    child: EmptyQueueCard(
                      title: q.isEmpty
                          ? 'Your queue is empty.'
                          : 'No matches found.',
                      subtitle: q.isEmpty
                          ? 'All clear! No requests for now.'
                          : 'Try refining your search.',
                      minHeight: 280,
                      bottomPadding: height, // already added via padding
                    ),
                  ),
                ),
              ),
            );
          }

          return Column(
            children: [
              Expanded(
                child: ListView.separated(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.fromLTRB(0, 16, 0, height),
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
                      isLate: isLate,
                      borderColor: isLate ? Colors.red : null,
                      onLongPress: null,
                      onTap: null,

                      accrptenceCOlor: Colors.transparent,
                      acceptenceIcon: CallStudentIcon(),
                      onAcceptence: () async {
                        await _openDialer(stu.parents[0].phoneNo);
                      },

                      rejectionColor: Colors.transparent,
                      isRejection: showParent,
                      declineIcon: CallGuardianIcon(),
                      onRejection: () async {
                        await _openDialer(stu.phoneNo);
                      },
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
