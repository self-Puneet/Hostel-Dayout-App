import 'package:flutter/material.dart';
import 'package:hostel_mgmt/core/enums/enum.dart';
import 'package:hostel_mgmt/core/util/string_extensions.dart';
import 'package:hostel_mgmt/models/assistant_w_model.dart';
import 'package:hostel_mgmt/models/request_model.dart';
import 'package:hostel_mgmt/presentation/components/contact_card.dart';
import 'package:hostel_mgmt/presentation/components/leave_detail_card.dart';
import 'package:hostel_mgmt/presentation/view/student/controllers/request_timeline.dart';
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
          final SeniorWardenContactCard = ContactCard(
            name: req.assistentWarden.name,
            role: req.seniorWarden.wardenRole.displayName,
            phoneNumber: req.seniorWarden.phoneNo,
          );

          return Scaffold(
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
                    LeaveDetailCard(
                      outDateTime: req.request.appliedFrom,
                      inDateTime: req.request.appliedTo,
                      reason: req.request.reason,
                      parentRemark: req.request.parentRemark,
                    ),
                    const SizedBox(height: 15),
                    // Text(,),
                    Text(
                      "Request Contacts",
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500, // Medium weight
                        fontSize: 24,
                      ),
                    ),
                    assistentWardenContactCard,
                    SeniorWardenContactCard,
                    Text(
                      "Timeline",
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500, // Medium weight
                        fontSize: 24,
                      ),
                    ),
                    // SizedBox(height: 200),
                    if (actor == TimelineActor.student)
                      dynamicTimeline(req, actor),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget dynamicTimeline(RequestDetailApiResponse req, TimelineActor actor) {
    return Padding(
      padding: EdgeInsetsGeometry.symmetric(vertical: 20),
      child: RequestTimeline(
        events: [
          // TimelineEvent(
          //   title: "Assistent Warden Referred Request to Parent",
          //   subtitle: "",
          //   time: req.request.assistantWardenAction!.actionAt,
          //   profilePicUrl: req.assistentWarden.profilePicUrl,
          //   initials: req.assistentWarden.name.initials,
          //   onTap: () {
          //     debugPrint("RW avatar clicked ✅");
          //   },
          // ),
          // TimelineEvent(
          //   title: "Assistent Warden Referred Request to Parent",
          //   subtitle: "",
          //   time: req.request.assistantWardenAction!.actionAt,
          //   profilePicUrl: req.assistentWarden.profilePicUrl,
          //   initials: req.assistentWarden.name.initials,
          //   onTap: () {
          //     debugPrint("RW avatar clicked ✅");
          //   },
          // ),
          if (req.request.seniorWardenAction != null)
            TimelineEvent(
              title: "Senior Warden Accepted",
              subtitle: "",
              time: req.request.seniorWardenAction!.actionAt,
              profilePicUrl: req.seniorWarden.profilePicUrl,
              initials: req.seniorWarden.name.initials,
              onTap: () {
                debugPrint("RW avatar clicked ✅");
              },
            ),
          if (req.request.parentAction != null)
            TimelineEvent(
              title: "Parent Accepted",
              subtitle: "",
              time: req.request.parentAction!.actionAt,
              initials: req.studentId.parents.first.name.initials,
              onTap: () {
                debugPrint("DP avatar clicked ✅");
              },
            ),
          (req.request.assistantWardenAction != null)
              ? TimelineEvent(
                  title: "Assistent Warden Referred Request to Parent",
                  subtitle: "",
                  time: req.request.assistantWardenAction!.actionAt,
                  profilePicUrl: req.assistentWarden.profilePicUrl,
                  initials: req.assistentWarden.name.initials,
                  onTap: () {
                    debugPrint("RW avatar clicked ✅");
                  },
                )
              : TimelineEvent(
                  title: "Assistent Warden Referred Request to Parent",
                  subtitle: "",
                  icon: Icons.hourglass_top,
                  onTap: () {
                    debugPrint("RW avatar clicked ✅");
                  },
                ),

          TimelineEvent(
            title: "Request Created",
            subtitle: "",
            time: req.request.appliedAt,
            profilePicUrl: req.studentId.profilePic,
            initials: req.studentId.name.initials,
            onTap: () {
              debugPrint("LT avatar clicked ✅");
            },
          ),
        ],
      ),
    );
  }
}
