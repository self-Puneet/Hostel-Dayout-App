// Other tabs: read-only cards
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hostel_mgmt/core/enums/actions.dart';
import 'package:hostel_mgmt/core/enums/enum.dart';
import 'package:hostel_mgmt/core/routes/app_route_constants.dart';
import 'package:hostel_mgmt/presentation/components/simple_action_request_card.dart';
import 'package:hostel_mgmt/presentation/view/warden/controller/warden_action_page_controller.dart';
import 'package:hostel_mgmt/presentation/view/warden/state/warden_action_state.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

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
          final List<OnScreenRequest> reqeusts = stateController
              .getRequestByStatus(status_: status);
          if (reqeusts.isEmpty) {
            final q = s.filterController.text.trim();
            return LayoutBuilder(
              builder: (context, constraints) => SingleChildScrollView(
                physics:
                    const AlwaysScrollableScrollPhysics(), // ✅ enables pull-to-refresh even when empty
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight, // ✅ fill available height
                  ),
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
            padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
            itemCount: reqeusts.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, i) {
              final wrap = reqeusts[i];
              final req = wrap.request;
              final stu = wrap.student;
              final selected = wrap.isSelected;
              final safeName = (stu.name).isEmpty ? 'Unknown' : stu.name;

              return SimpleActionRequestCard(
                profileImageUrl: stu.profilePic,
                reason: req.reason,
                name: safeName,
                status: req.status,
                leaveType: req.requestType,
                fromDate: req.appliedFrom,
                toDate: req.appliedTo,
                selected: selected,
                isRejection: false,
                isLate: req.appliedTo.isBefore(DateTime.now()),
                borderColor: req.appliedTo.isBefore(DateTime.now())
                    ? Colors.red
                    : null,
                acceptenceIcon: Icons.phone,
                accrptenceCOlor: Colors.blue,
                onLongPress: (!s.isActioning && !s.hasSelection)
                    ? () => s.toggleSelectedById(req.requestId)
                    : null,
                onTap: (!s.isActioning && s.hasSelection)
                    ? () => s.toggleSelectedById(req.requestId)
                    : null,
                onRejection: (!s.hasSelection && !s.isActioning)
                    ? () async {
                        await stateController.actionRequestById(
                          action: actor == TimelineActor.assistentWarden
                              ? RequestAction.cancel
                              : RequestAction.reject,
                          requestId: req.requestId,
                        );
                        if (context.mounted) {
                          context.goNamed(
                            AppRoutes.wardenHome,
                            queryParameters: {
                              'ts': DateTime.now().millisecondsSinceEpoch
                                  .toString(),
                            },
                          );
                        }
                      }
                    : null,
                onAcceptence: (!s.hasSelection && !s.isActioning)
                    ? () async {
                        _openDialer(stu.phoneNo);
                      }
                    : null,
                // rejectionColor: Colors.red,
              );
            },
          );
        },
      ),
    );
  }
}
