import 'package:flutter/material.dart';
import 'package:hostel_mgmt/core/enums/request_type.dart';
import 'package:hostel_mgmt/presentation/components/contact_card.dart';
import 'package:provider/provider.dart';
import 'package:hostel_mgmt/presentation/components/leave_detail_card.dart';
import 'package:hostel_mgmt/presentation/view/student/state/request_state.dart';
import 'package:hostel_mgmt/presentation/view/student/controllers/request_detail_controller.dart';
import 'package:go_router/go_router.dart';

class RequestPage extends StatelessWidget {
  final String requestId;
  const RequestPage({Key? key, required this.requestId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<RequestState>(
      create: (_) => RequestState(),
      child: Consumer<RequestState>(
        builder: (context, state, _) {
          return FutureBuilder<void>(
            future: RequestDetailController(
              state,
            ).fetchRequestDetail(requestId),
            builder: (context, snapshot) {
              if (state.isLoading) {
                return Scaffold(
                  appBar: AppBar(
                    leading: IconButton(
                      icon: Icon(Icons.arrow_back),
                      onPressed: () => context.go('/home'),
                    ),
                    title: Text("Loading..."),
                  ),
                  body: Center(child: CircularProgressIndicator()),
                );
              }
              if (state.isErrored) {
                return Scaffold(
                  appBar: AppBar(
                    leading: IconButton(
                      icon: Icon(Icons.arrow_back),
                      onPressed: () => context.go('/home'),
                    ),
                    title: Text("Error"),
                  ),
                  body: Center(child: Text(state.errorMessage)),
                );
              }
              if (state.request == null) {
                return Scaffold(
                  appBar: AppBar(
                    leading: IconButton(
                      icon: Icon(Icons.arrow_back),
                      onPressed: () => context.go('/home'),
                    ),
                    title: Text("No request found"),
                  ),
                  body: Center(child: Text("No request found.")),
                );
              }
              return Scaffold(
                appBar: AppBar(
                  leading: IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: () => context.go('/home'),
                  ),
                  title: Text(
                    state.request?.requestType.name ?? RequestType.dayout.name,
                  ),
                ),
                body: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Column(
                    children: [
                      LeaveDetailCard(
                        outDateTime: state.request!.appliedFrom,
                        inDateTime: state.request!.appliedTo,
                        reason: state.request!.reason,
                        // parentRemark: state.request!.parentRemark,
                      ),
                      ContactCard(
                        name:
                            state
                                .request!
                                .assistantWardenAction
                                ?.assistantWardenModel
                                .name ??
                            'Unknown',
                        role: "Direct Supervisor",
                        onCall: () {
                          print("Calling Sarah Chen...");
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
