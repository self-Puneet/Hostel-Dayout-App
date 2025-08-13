import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hostel_dayout_app/core/enums/request_state.dart';
import 'package:hostel_dayout_app/core/enums/sort_order.dart';
import '../bloc/bloc.dart';
import 'package:hostel_dayout_app/requests/presentation/widgets/request_card.dart';
import 'package:url_launcher/url_launcher.dart';

class RequestsPage extends StatefulWidget {
  const RequestsPage({super.key});

  @override
  State<RequestsPage> createState() => _RequestsPageState();
}

class _RequestsPageState extends State<RequestsPage> {
  @override
  void initState() {
    super.initState();
    context.read<RequestListBloc>().add(
      LoadRequestsEvent(
        searchQuery: RequestState.active.displayName,
        sortOrder: SortOrder.descending.displayName,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bloc = BlocBuilder<RequestListBloc, RequestListState>(
      builder: (context, state) {
        if (state is RequestListLoading) {
          return const Center(child: CircularProgressIndicator());
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
          return Center(
            child: Text(
              state.message,
              style: const TextStyle(color: Colors.red),
            ),
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
          children: [bloc],
        ),
      ),
    );
  }
}
