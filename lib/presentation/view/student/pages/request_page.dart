import 'package:flutter/material.dart';
import 'package:hostel_mgmt/core/enums/actions.dart';
import 'package:hostel_mgmt/core/enums/enum.dart';
import 'package:hostel_mgmt/core/helpers/app_refreasher_widget.dart';
import 'package:hostel_mgmt/core/theme/app_theme.dart';
import 'package:hostel_mgmt/core/util/input_convertor.dart';
import 'package:hostel_mgmt/models/warden_model.dart';
import 'package:hostel_mgmt/models/request_model.dart';
import 'package:hostel_mgmt/presentation/components/contact_card.dart';
import 'package:hostel_mgmt/presentation/components/request_timeline.dart';
import 'package:hostel_mgmt/presentation/components/skeleton_loaders/request_detail_skeleton.dart';
import 'package:hostel_mgmt/presentation/components/skeleton_loaders/timeline_skeleton.dart';
import 'package:hostel_mgmt/presentation/view/student/state/request_state.dart';
import 'package:hostel_mgmt/presentation/view/student/controllers/request_detail_controller.dart';
import 'package:hostel_mgmt/presentation/widgets/liquid_glass_morphism/liquid_back_button.dart';
import 'package:hostel_mgmt/presentation/widgets/shimmer_box.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../widgets/checkered_pattern.dart';

class RequestPage extends StatefulWidget {
  final TimelineActor actor;
  final String requestId;
  const RequestPage({Key? key, required this.actor, required this.requestId})
    : super(key: key);

  @override
  State<RequestPage> createState() => _RequestPageState();
}

class _RequestPageState extends State<RequestPage> {
  bool _expanded = false;

  late final RequestDetailController _controller;
  @override
  void initState() {
    super.initState();
    final state = RequestState();
    _controller = RequestDetailController(
      state: state,
      requestId: widget.requestId,
    );
  }

  Future<bool> _confirmAction(
    BuildContext context,
    RequestAction action,
  ) async {
    final msg = action.dialogBoxMessage;
    final result = await showDialog<bool>(
      // Material dialog
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(msg.title),
        content: Text(msg.description),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(msg.confirmText),
          ),
        ],
      ),
    );
    return result == true;
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    final padding = EdgeInsets.symmetric(
      horizontal: 31 * mediaQuery.size.width / 402,
    );

    final TextTheme textTheme = Theme.of(context).textTheme;

    return ChangeNotifierProvider<RequestState>.value(
      value: _controller.state,
      child: Consumer<RequestState>(
        builder: (context, state, _) {
          // Loading/error scaffolds
          if (state.isLoading) {
            return Scaffold(
              backgroundColor: const Color(0xFFE9E9E9),
              body: skeletonLoader(),
            );
          }
          if (state.isErrored) {
            return Scaffold(
              backgroundColor: const Color(0xFFE9E9E9),
              appBar: AppBar(
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => context.go('/home'),
                ),
                title: const Text("Error"),
              ),
              body: Center(child: Text(state.errorMessage)),
            );
          }
          if (state.request == null) {
            return Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => context.go('/home'),
                ),
                title: const Text("No request found"),
              ),
              body: const Center(child: Text("No request found.")),
            );
          }

          final req = state.request!;
          final assistentWardenContactCard = ContactCard(
            name: req.assistentWarden.name,
            role: req.assistentWarden.wardenRole.displayName,
            phoneNumber: req.assistentWarden.phoneNo,
          );
          final seniorWardenContactCard = ContactCard(
            name: req.seniorWarden.name,
            role: req.seniorWarden.wardenRole.displayName,
            phoneNumber: req.seniorWarden.phoneNo,
          );
          final studentContactCard = seniorWardenContactCard;
          final parentContactCard = assistentWardenContactCard;
          // Compute actions based on actor + current status
          final statusNow = req.request.status;
          final actions = RequestActionX.actionPossibleonStatus(
            statusNow,
            widget.actor,
          );

          // Build FABs only when not loading and not empty
          Widget? fab;
          if (!state.isLoading && actions.isNotEmpty) {
            // Build the core FAB content (single or expandable group)
            final Widget coreFab = (actions.length == 1)
                ? (() {
                    final a = actions.first;
                    return FloatingActionButton.extended(
                      onPressed: state.isActioning
                          ? null
                          : () async {
                              final ok = await _confirmAction(context, a);
                              if (!ok) return;
                              await _controller.performAction(
                                actor: widget.actor,
                                action: a,
                              );
                            },
                      icon: a.icon,
                      label: Text(a.name, style: textTheme.h5.w500),
                      backgroundColor: a.actionColor,
                    );
                  })()
                : Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      AnimatedSize(
                        duration: const Duration(milliseconds: 200),
                        curve: Curves.easeInOut,
                        child: _expanded
                            ? Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: actions.map((a) {
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 10),
                                    child: FloatingActionButton.extended(
                                      heroTag:
                                          '${a.name}-${req.request.requestId}',
                                      onPressed: state.isActioning
                                          ? null
                                          : () async {
                                              final ok = await _confirmAction(
                                                context,
                                                a,
                                              );
                                              if (!ok) return;
                                              setState(() => _expanded = false);
                                              await _controller.performAction(
                                                actor: widget.actor,
                                                action: a,
                                              );
                                            },
                                      icon: a.icon,
                                      label: Text(a.name),
                                      backgroundColor: a.actionColor,
                                      isExtended: true,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      materialTapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                      elevation: 6,
                                    ),
                                  );
                                }).toList(),
                              )
                            : const SizedBox.shrink(),
                      ),
                      FloatingActionButton(
                        heroTag: 'toggle-${req.request.requestId}',
                        onPressed: state.isActioning
                            ? null
                            : () => setState(() => _expanded = !_expanded),
                        child: Icon(_expanded ? Icons.close : Icons.more_vert),
                      ),
                    ],
                  );

            // Wrap with SafeArea + Padding to add bottom/left gaps
            fab = Padding(
              // Additional fine-tuning if needed
              padding: EdgeInsets.only(
                bottom: (84 + MediaQuery.of(context).viewPadding.bottom) / 2,
                right: 16,
                left: 16,
              ),
              child: coreFab,
            );
          }

          return Scaffold(
            backgroundColor: const Color(0xFFE9E9E9),
            floatingActionButton: fab,
            floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
            body: AppRefreshWrapper(
              onRefresh: () async {
                await _controller.fetchRequestDetail(widget.requestId);
              },
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    checkeredDesign(
                      child: Text(
                        req.request.requestType.displayName,
                        style: textTheme.h1.w500,
                      ),
                      color: state.request!.request.status.minimalStatusColor,
                    ),
                    // CheckeredBackground(color: Colors.red),
                    SizedBox(height: 30),
                    Padding(
                      padding: padding,
                      child: Column(
                        children: [
                          IntrinsicHeight(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: statusCard(status: req.request.status),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  flex: 3,
                                  child: infoCard(
                                    req.request.appliedFrom,
                                    req.request.appliedTo,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 15),
                          reasonRemarkSection(
                            reason: req.request.reason,
                            parentRemark: req.request.parentRemark,
                          ),
                          if (widget.actor == TimelineActor.student)
                            dynamicTimeline(req: req, actor: widget.actor),
                          if (widget.actor == TimelineActor.student ||
                              widget.actor == TimelineActor.parent) ...[
                            assistentWardenContactCard,
                            seniorWardenContactCard,
                          ],
                          if (widget.actor == TimelineActor.seniorWarden ||
                              widget.actor ==
                                  TimelineActor.assistentWarden) ...[
                            parentContactCard,
                            studentContactCard,
                          ],

                          Container(
                            height:
                                84 + MediaQuery.of(context).viewPadding.bottom,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget dynamicTimeline({
    required RequestDetailApiResponse req,
    required TimelineActor actor,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Color.fromRGBO(246, 246, 246, 1),
        borderRadius: BorderRadius.circular(20),
      ),
      margin: EdgeInsets.symmetric(vertical: 10),
      padding: EdgeInsets.symmetric(horizontal: 22, vertical: 0),
      // padding: EdgeInsetsGeometry.symmetric(vertical: 20, horizontal: 20),
      child: RequestTimeline(
        events: [
          TimelineEvent(
            title: TimelineActor.seniorWarden.displayName,
            subtitle: "request approved",
            time: (req.request.seniorWardenAction != null)
                ? req.request.seniorWardenAction!.actionAt
                : null,
            status: (req.request.seniorWardenAction != null)
                ? RequestActionX.actionToTimelineStatus(
                    req.request.seniorWardenAction!.action,
                  )
                : TimelineStatus.inProgress,
          ),

          TimelineEvent(
            title: TimelineActor.parent.displayName,
            subtitle: "Parent accepted the request",
            status: (req.request.parentAction != null)
                ? RequestActionX.actionToTimelineStatus(
                    req.request.parentAction!.action,
                  )
                : TimelineStatus.inProgress,
            time: (req.request.parentAction != null)
                ? req.request.parentAction!.actionAt
                : null,
          ),
          TimelineEvent(
            title: TimelineActor.assistentWarden.displayName,
            subtitle: "Request Referred to Parent",
            time: (req.request.assistantWardenAction != null)
                ? req.request.assistantWardenAction!.actionAt
                : null,
            status: (req.request.assistantWardenAction != null)
                ? RequestActionX.actionToTimelineStatus(
                    req.request.assistantWardenAction!.action,
                  )
                : TimelineStatus.inProgress,
          ),
          TimelineEvent(
            title: TimelineActor.student.displayName,
            subtitle: "Request Created",
            time: req.request.appliedAt,
            status: TimelineStatus.completed,
          ),
        ],
      ),
    );
  }

  Widget reasonRemarkSection({required String reason, String? parentRemark}) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Container(
      decoration: BoxDecoration(
        color: Color.fromRGBO(246, 246, 246, 1),
        borderRadius: BorderRadius.circular(20),
      ),
      margin: EdgeInsets.symmetric(vertical: 10),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsetsGeometry.symmetric(horizontal: 6),
            child: Text("Reason", style: textTheme.h3.w500),
          ),
          SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            constraints: BoxConstraints(minWidth: double.maxFinite),
            // margin: EdgeInsets.symmetric(vertical: 40),
            padding: EdgeInsets.symmetric(horizontal: 9, vertical: 12),
            child: Text(reason, style: textTheme.h6),
          ),
          if (parentRemark != null && parentRemark != "") ...[
            SizedBox(height: 10),
            Divider(height: 0.5, color: Color.fromRGBO(117, 117, 117, 1)),
            SizedBox(height: 10),
            Padding(
              padding: EdgeInsetsGeometry.symmetric(horizontal: 6),
              child: Text("Parent Remark", style: textTheme.h3.w500),
            ),
            SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              constraints: BoxConstraints(minWidth: double.maxFinite),
              // margin: EdgeInsets.symmetric(vertical: 40),
              padding: EdgeInsets.symmetric(horizontal: 9, vertical: 12),
              child: Text(parentRemark, style: textTheme.h6),
            ),
          ],
        ],
      ),
    );
  }

  Widget statusCard({required RequestStatus status}) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: status.minimalStatusColor.withAlpha(90),
      ),
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.white.withAlpha(0), Colors.white.withAlpha(225)],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(status.minimalStatusIcon, color: status.statusColor, size: 40),
            const SizedBox(height: 8),
            Spacer(),
            Text(status.displayName, style: textTheme.h5.w500),
          ],
        ),
      ),
    );
  }

  Widget infoCard(DateTime outDateTime, DateTime inDateTime) {
    return Expanded(
      child: Column(
        children: [
          _InfoCard(
            icon: Icons.north_east,
            date: InputConverter.formatDate(outDateTime).split(",")[0],
            time: InputConverter.formatTime(outDateTime),
          ),
          SizedBox(height: 12),
          _InfoCard(
            icon: Icons.south_west,
            date: InputConverter.formatDate(inDateTime).split(",")[0],
            time: InputConverter.formatTime(inDateTime),
          ),
        ],
      ),
    );
  }

  Widget skeletonLoader() {
    final mediaQuery = MediaQuery.of(context);

    final padding = EdgeInsets.symmetric(
      horizontal: 31 * mediaQuery.size.width / 402,
    );

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          checkeredDesign(
            child: shimmerBox(width: 140, height: 50),
            color: Colors.grey,
          ),
          SizedBox(height: 30),
          Padding(
            padding: padding,
            child: Column(
              children: [
                requestDetailSkeletonLoader(),
                const SizedBox(height: 15),
                Container(
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(246, 246, 246, 1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 25),
                  child: timelineSkeletonLoader(),
                ),
                Container(
                  height: 84 + MediaQuery.of(context).viewPadding.bottom,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget checkeredDesign({required Widget child, required Color color}) {
    return CheckeredContainer(
      color: color,
      height: 200,
      tileSize: 40,
      child: Align(
        alignment: Alignment.bottomLeft,
        child: Container(
          height: 200,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            child: SafeArea(
              bottom: false,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  LiquidGlassBackButton(
                    onPressed: () => context.pop(),
                    radius: 30,
                  ),
                  child,
                ],
              ),
            ),
          ),
        ),
        //
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String date;
  final String time;

  const _InfoCard({required this.icon, required this.date, required this.time});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(color: Colors.black.withAlpha(56), blurRadius: 0.1),
        ],
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Padding(
            padding: EdgeInsetsGeometry.symmetric(horizontal: 10),
            child: Icon(icon, size: 30, color: Colors.black),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsetsGeometry.symmetric(vertical: 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsetsGeometry.symmetric(horizontal: 8),
                        child: Icon(
                          Icons.calendar_month_outlined,
                          size: 18,
                          color: Colors.black,
                        ),
                      ),
                      // const SizedBox(width: 8),
                      Text(date),
                    ],
                  ),
                ),

                Divider(color: Colors.black.withAlpha(99), thickness: 1),

                Padding(
                  padding: EdgeInsetsGeometry.symmetric(vertical: 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsetsGeometry.symmetric(horizontal: 10),
                        child: const Icon(
                          Icons.access_time,
                          size: 18,
                          color: Colors.black,
                        ),
                      ),
                      Text(time),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
