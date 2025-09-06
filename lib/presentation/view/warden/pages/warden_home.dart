import 'package:flutter/material.dart';
import 'package:hostel_mgmt/models/request_model.dart';
import 'package:provider/provider.dart';
import 'package:hostel_mgmt/presentation/view/warden/state/warden_home_state.dart';
import 'package:hostel_mgmt/presentation/view/warden/controller/warden_home_controller.dart';
import 'package:hostel_mgmt/presentation/components/simple_request_card.dart';
import 'package:hostel_mgmt/core/enums/request_status.dart';

class WardenHomePage extends StatelessWidget {
  const WardenHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<WardenHomeState>(
      builder: (context, state, _) {
        if (!state.isLoading && state.currentOnScreenRequests.isEmpty) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            WardenHomeController(state).fetchRequests();
          });
        }
        final WardenHomeController controller = WardenHomeController(state);

        if (state.isLoading) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Student Requests'),
              centerTitle: true,
            ),
            body: const Center(child: CircularProgressIndicator()),
          );
        } else if (state.isErrored) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Student Requests'),
              centerTitle: true,
            ),
            body: Center(
              child: Text(
                state.errorMessage,
                style: const TextStyle(color: Colors.red, fontSize: 16),
              ),
            ),
          );
        } else {
          final List<RequestModel> requests = state.currentOnScreenRequests;
          return Scaffold(
            appBar: AppBar(
              title: const Text('Student Requests'),
              centerTitle: true,
            ),
            body: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    controller: state.filterController,
                    decoration: InputDecoration(
                      hintText: 'Search by student name...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: state.isActioning
                                ? Colors.grey[300]
                                : Colors.red,
                            foregroundColor: state.isActioning
                                ? Colors.white
                                : Colors.black,
                          ),
                          onPressed: () => controller.acceptRequest(),
                          child: const Text('Rejected'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: state.isActioning
                                ? Colors.grey[300]
                                : Colors.green,
                            foregroundColor: state.isActioning
                                ? Colors.white
                                : Colors.black,
                          ),
                          onPressed: () => controller.rejectRequest(),
                          child: const Text('Approved'),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: requests.isEmpty
                      ? const Center(child: Text('No requests found.'))
                      : ListView.builder(
                          itemCount: requests.length,
                          itemBuilder: (context, index) {
                            final req = requests[index];
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16.0,
                                vertical: 8.0,
                              ),
                              child: SimpleRequestCard(
                                name:
                                    req.studentAction!.studentProfileModel.name,
                                requestType: req.requestType,
                                fromDate: req.appliedFrom,
                                toDate: req.appliedTo,
                                status: req.status,
                                statusDate: req.lastUpdatedAt,
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
