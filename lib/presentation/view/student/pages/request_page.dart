import 'package:flutter/material.dart';
import 'package:hostel_mgmt/core/enums/enum.dart';
import 'package:hostel_mgmt/core/util/input_convertor.dart';
import 'package:hostel_mgmt/models/assistant_w_model.dart';
import 'package:hostel_mgmt/models/request_model.dart';
import 'package:hostel_mgmt/presentation/components/contact_card.dart';
import 'package:hostel_mgmt/presentation/components/leave_detail_card.dart';
import 'package:hostel_mgmt/presentation/components/request_timeline.dart';
import 'package:hostel_mgmt/presentation/view/student/state/request_state.dart';
import 'package:hostel_mgmt/presentation/view/student/controllers/request_detail_controller.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

class RequestPage extends StatelessWidget {
  final TimelineActor actor;
  final String requestId;
  const RequestPage({Key? key, required this.actor, required this.requestId})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<RequestState>(
      create: (_) {
        final state = RequestState();
        // Trigger fetch once state is created
        RequestDetailController(state: state, requestId: requestId);
        return state;
      },
      child: Consumer<RequestState>(
        builder: (context, state, _) {
          if (state.isLoading) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          if (state.isErrored) {
            return Scaffold(
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

          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => context.go('/home'),
              ),
              title: Text(req.request.requestType.name),
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    IntrinsicHeight(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            flex: 2,
                            child: statusCard(status: req.request.status),
                          ),
                          SizedBox(width: 18),
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
                    if (actor == TimelineActor.student)
                      dynamicTimeline(req: req, actor: actor),
                    assistentWardenContactCard,
                    seniorWardenContactCard,
                    SizedBox(height: 200),
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
          if (req.request.seniorWardenAction != null)
            TimelineEvent(
              title: TimelineActor.seniorWarden.displayName,
              subtitle: "",
              time: req.request.seniorWardenAction!.actionAt,
              status: TimelineStatus.completed,
            ),
          if (req.request.parentAction != null)
            TimelineEvent(
              title: TimelineActor.parent.displayName,
              subtitle: "Parent accepted the request",
              time: req.request.parentAction!.actionAt,
              status: TimelineStatus.completed,
            ),
          (req.request.assistantWardenAction != null)
              ? TimelineEvent(
                  title: TimelineActor.assistentWarden.displayName,
                  subtitle: "Request Referred to Parent",
                  time: req.request.assistantWardenAction!.actionAt,
                  status: TimelineStatus.completed,
                )
              : TimelineEvent(
                  title: TimelineActor.assistentWarden.displayName,
                  subtitle: "Request Referred to Parent",
                  status: TimelineStatus.inProgress,
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
            child: Text(
              "Reason",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
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
            child: Text(
              reason,
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
            ),
          ),
          if (parentRemark != null && parentRemark != "") ...[
            Divider(color: Colors.black),
            Padding(
              padding: EdgeInsetsGeometry.symmetric(horizontal: 6),
              child: Text(
                "Parent Remark",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
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
              child: Text(
                parentRemark,
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget statusCard({required RequestStatus status}) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.blue.withAlpha(90),
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
            Text(
              status.displayName,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
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
