import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:hostel_mgmt/core/enums/actions.dart';
import 'package:hostel_mgmt/core/enums/enum.dart';
import 'package:hostel_mgmt/core/helpers/app_refreasher_widget.dart';
import 'package:hostel_mgmt/core/theme/app_theme.dart';
import 'package:hostel_mgmt/core/theme/elevated_button_theme.dart';
import 'package:hostel_mgmt/core/util/input_convertor.dart';
import 'package:hostel_mgmt/models/student_profile.dart';
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
  // Optional route arguments passed via GoRouter.extra (Map<String, dynamic>)
  final StudentProfileModel? routeArgs;

  const RequestPage({
    Key? key,
    required this.actor,
    required this.requestId,
    this.routeArgs,
  }) : super(key: key);

  @override
  State<RequestPage> createState() => _RequestPageState();
}

class _RequestPageState extends State<RequestPage> {
  bool _expanded = false;
  bool _isFabVisible = true; // track FAB visibility
  late final RequestDetailController _controller;
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    final state = RequestState();
    _controller = RequestDetailController(
      state: state,
      requestId: widget.requestId,
      actor: widget.actor,
    );

    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (_scrollController.position.userScrollDirection ==
        ScrollDirection.reverse) {
      if (_isFabVisible) {
        setState(() {
          _isFabVisible = false; // hide FAB on scroll down
          _expanded = false; // collapse expanded FAB menu when hiding
        });
      }
    } else if (_scrollController.position.userScrollDirection ==
        ScrollDirection.forward) {
      if (!_isFabVisible) {
        setState(() {
          _isFabVisible = true; // show FAB on scroll up
        });
      }
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
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

    final StudentProfileModel? studentProfile = widget.routeArgs;

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
          final studentContactCard = (studentProfile != null)
              ? ContactCard(
                  name: studentProfile.name,
                  role: TimelineActor.student.displayName,
                  phoneNumber: studentProfile.phoneNo,
                  imageUrl: studentProfile.profilePic,
                )
              : ContactCard(
                  name: "Student",
                  role: 'Student',
                  phoneNumber: "phone_no",
                );
          final List<ContactCard> parentContactCard = (studentProfile != null)
              ? studentProfile.parents.map((parent) {
                  return ContactCard(
                    name: parent.name,
                    role: parent.relation,
                    phoneNumber: parent.phoneNo,
                  );
                }).toList()
              : [];

          return Scaffold(
            backgroundColor: const Color(0xFFE9E9E9),
            // floatingActionButton: fab,
            // floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
            body: AppRefreshWrapper(
              onRefresh: () async {
                await _controller.fetchRequestDetail(widget.requestId);
              },
              child: SingleChildScrollView(
                controller: _scrollController,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    checkeredDesign(
                      child: Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              req.request.requestType.displayName,
                              style: textTheme.h1.w500,
                            ),
                            SizedBox(height: 20),
                            actionButton(
                              actor: widget.actor,
                              status: req.request.status,
                              isActioning: state.isActioning,
                            ),
                          ],
                        ),
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

                          dynamicTimeline(req: req, actor: widget.actor),
                          if (widget.actor == TimelineActor.student ||
                              widget.actor == TimelineActor.parent) ...[
                            assistentWardenContactCard,
                            seniorWardenContactCard,
                          ],
                          if (widget.actor == TimelineActor.seniorWarden ||
                              widget.actor ==
                                  TimelineActor.assistentWarden) ...[
                            studentContactCard,
                            ...parentContactCard,
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

  Widget actionButton({
    required TimelineActor actor,
    required RequestStatus status,
    required bool isActioning,
  }) {
    // button widget
    print(actor);
    print(status);
    // Replace the old animatingButton with this version (no Expanded inside)
    Widget animatingButton(
      bool isActioning,
      String text,
      VoidCallback? onPressed,
    ) {
      final btnStyle = ElevatedButton.styleFrom(
        textStyle: Theme.of(context).textTheme.h5.copyWith(height: 1.0),
        minimumSize: const Size.fromHeight(48), // standard min height
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(30)),
        ),
      );

      return SizedBox(
        width: double.infinity, // force full width
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          switchInCurve: Curves.easeOut,
          switchOutCurve: Curves.easeIn,
          // keep the container full-width during transitions
          layoutBuilder: (currentChild, previousChildren) => SizedBox(
            width: double.infinity,
            child: Stack(
              alignment: Alignment.center,
              children: [
                ...previousChildren,
                if (currentChild != null) currentChild,
              ],
            ),
          ),
          child: isActioning
              ? DisabledElevatedButton(
                  key: ValueKey('disabled-$text'),
                  text: text,
                  onPressed: null,
                )
              : ElevatedButton(
                  key: ValueKey('enabled-$text'),
                  style: btnStyle,
                  onPressed: onPressed,
                  child: Text(text),
                ),
        ),
      );
    }

    void performAction(RequestAction action) async {
      final ok = await _confirmAction(context, action);
      if (!ok) return;
      await _controller.performAction(actor: widget.actor, action: action);
    }

    if (actor == TimelineActor.student) {
      if (![
        RequestStatus.parentDenied,
        RequestStatus.cancelled,
        RequestStatus.cancelledStudent,
        RequestStatus.rejected,
        RequestStatus.approved,
      ].contains(status)) {
        // Student: single full-width button
        return SizedBox(
          width: double.infinity,
          child: animatingButton(isActioning, "Cancel Request", () {
            performAction(RequestAction.cancel);
          }),
        );
      } else {
        return SizedBox.shrink();
      }
    } else if (actor == TimelineActor.parent) {
      if (status == RequestStatus.referred) {
        // Parent / SeniorWarden / AssistentWarden: two side-by-side buttons
        return Row(
          children: [
            Expanded(
              child: animatingButton(isActioning, "Reject", () {
                performAction(RequestAction.reject);
              }),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: animatingButton(isActioning, "Accept", () {
                performAction(RequestAction.approve);
              }),
            ),
          ],
        );
      } else {
        return SizedBox.shrink();
      }
    } else if (actor == TimelineActor.seniorWarden) {
      if (status == RequestStatus.parentApproved) {
        // Parent / SeniorWarden / AssistentWarden: two side-by-side buttons
        return Row(
          children: [
            Expanded(
              child: animatingButton(isActioning, "Reject", () {
                performAction(RequestAction.reject);
              }),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: animatingButton(isActioning, "Accept", () {
                performAction(RequestAction.approve);
              }),
            ),
          ],
        );
      } else {
        return SizedBox.shrink();
      }
    } else if (actor == TimelineActor.assistentWarden) {
      if (status == RequestStatus.requested) {
        // Parent / SeniorWarden / AssistentWarden: two side-by-side buttons
        return Row(
          children: [
            Expanded(
              child: animatingButton(isActioning, "Reject", () {
                performAction(RequestAction.reject);
              }),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: animatingButton(isActioning, "Accept", () {
                performAction(RequestAction.approve);
              }),
            ),
          ],
        );
      } else {
        return SizedBox.shrink();
      }
    } else {
      return SizedBox.shrink();
    }
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
            status: [RequestStatus.approved].contains(req.request.status)
                ? TimelineStatus.completed
                : [RequestStatus.rejected].contains(req.request.status)
                ? TimelineStatus.rejected
                : TimelineStatus.inProgress,
          ),

          TimelineEvent(
            title: TimelineActor.parent.displayName,
            subtitle: "Parent accepted the request",
            status:
                [
                  RequestStatus.requested,
                  RequestStatus.referred,
                ].contains(req.request.status)
                ? TimelineStatus.inProgress
                : [RequestStatus.parentDenied].contains(req.request.status)
                ? TimelineStatus.rejected
                : TimelineStatus.completed,
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
            status: [RequestStatus.requested].contains(req.request.status)
                ? TimelineStatus.inProgress
                : (req.request.status == RequestStatus.cancelled)
                ? TimelineStatus.rejected
                : TimelineStatus.completed,
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
    // Do not return an Expanded here - the caller already wraps this widget
    // in an Expanded when needed. Returning Expanded here caused nested
    // Expanded widgets which produce a ParentDataWidget conflict at runtime.
    return Column(
      mainAxisSize: MainAxisSize.min,
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
                    color: Colors.white,
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
      height: 300,
      tileSize: 40,
      child: Align(
        alignment: Alignment.bottomLeft,
        child: Container(
          height: 300,
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
                  Padding(
                    padding: EdgeInsetsGeometry.symmetric(vertical: 10),
                    child: child,
                  ),
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
