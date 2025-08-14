import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hostel_dayout_app/requests/presentation/widgets/skeleton_loader.dart';
import '../bloc/bloc.dart';
import 'package:hostel_dayout_app/requests/presentation/widgets/request_card.dart';
import '../widgets/stats_card.dart';
import '../widgets/greeting_header.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  void initState() {
    super.initState();
    context.read<RequestListBloc>().add(LoadPriorityRequestsEvent());
  }

  @override
  void dispose() {
    // context.read<RequestListBloc>().add(LoadRequestsByStatusEvent());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = BlocBuilder<RequestListBloc, RequestListState>(
      builder: (context, state) {
        if (state is RequestListLoading) {
          return const Column(
            children: [ShimmerCard(), ShimmerCard(), ShimmerCard()],
          );
        } else if (state is RequestListLoaded) {
          final priorityRequests = state.requests.toList();

          if (priorityRequests.isEmpty) {
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                "No priority requests right now",
                style: TextStyle(color: Colors.grey),
              ),
            );
          }

          return Column(
            children: priorityRequests
                .map(
                  (req) => RequestCard(
                    request: req,
                    onTap: () {
                      // Navigate to request detail page
                    },
                    onCallTap: () async {
                      final phoneNumber = req.parent.phone;
                      final Uri uri = Uri(scheme: 'tel', path: phoneNumber);

                      if (await canLaunchUrl(uri)) {
                        await launchUrl(uri);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Could not launch dialer'),
                          ),
                        );
                      }
                    },
                  ),
                )
                .toList(),
          );
        } else if (state is RequestListError) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            ShadToaster.of(context).show(
              ShadToast.destructive(
                title: Text(state.message),
                description: null,
                action: ShadButton.destructive(
                  child: const Text('Try again'),
                  onPressed: () {
                    print('Retry action triggered');
                    ShadToaster.of(context).hide();
                  },
                ),
              ),
            );
          });

          return const Column(
            children: [ShimmerCard(), ShimmerCard(), ShimmerCard()],
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Greeting
            const GreetingHeader(wardenName: "CrashTrico"),
            const SizedBox(height: 16),

            // Stats
            Row(
              children: const [
                Expanded(
                  child: StatsCard(
                    count: 8,
                    label: "Active today",
                    onTap: null,
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: StatsCard(
                    count: 2,
                    label: "Late returns",
                    onTap: null,
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: StatsCard(count: 5, label: "Pending", onTap: null),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Priority Requests
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  "Priority requests",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                Text(
                  "View all",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.blue,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            bloc,
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: () {},
          child: const Text("Hostel Overview"),
        ),
      ),
    );
  }
}
