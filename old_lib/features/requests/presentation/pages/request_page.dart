import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../lib/core/enums/actions.dart';
import '../bloc/action_mapping.dart';
import '../widgets/confirmation_dialog.dart';
import '../widgets/skeleton_loader.dart';
import '../bloc/bloc.dart';
import '../widgets/request_card.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import '../../../../../lib/core/enums/enum.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class RequestsPage extends StatefulWidget {
  const RequestsPage({super.key});

  @override
  State<RequestsPage> createState() => _RequestsPageState();
}

class _RequestsPageState extends State<RequestsPage> {
  RequestStatus? _selectedStatus; // <-- State for selected filter
  String? _searchTerm;

  @override
  void initState() {
    super.initState();
    context.read<RequestListBloc>().add(LoadRequestsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        behavior: HitTestBehavior.translucent, // ✅ allows taps to pass through
        onTap: () => FocusScope.of(context).unfocus(), // ✅ removes focus
        child: RefreshIndicator(
          onRefresh: () async {
            context.read<RequestListBloc>().add(LoadRequestsEvent());
            await Future.delayed(const Duration(seconds: 1));
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSearchTextField(),
                // const SizedBox(height: 300),
                _buildStatusFilter(),
                const SizedBox(height: 16),
                _buildRequestsCards(),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: _floatingActionButton(),
    );
  }

  // requests cards widget seperatly
  Widget _buildRequestsCards() {
    return BlocBuilder<RequestListBloc, RequestListState>(
      builder: (context, state) {
        if (state is RequestListLoading) {
          return const Column(
            children: [ShimmerCard(), ShimmerCard(), ShimmerCard()],
          );
        } else if (state is RequestListLoaded) {
          final requests = state.requests;

          if (requests.isEmpty) {
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                "No requests found",
                style: TextStyle(color: Colors.grey),
              ),
            );
          }

          return Column(
            children: requests
                .map(
                  (req) => RequestCard(
                    request: req,
                    onTap: () {
                      context.push('/requests/${req.id}');
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
                    context.read<RequestListBloc>().add(LoadRequestsEvent());
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
          return const Column(
            children: [ShimmerCard(), ShimmerCard(), ShimmerCard()],
          );
        }
      },
    );
  }

  // make a seperate widget for that search text field
  Widget _buildSearchTextField() {
    return TextField(
      // i want icon in this text field
      style: TextStyle(color: Colors.black, decoration: TextDecoration.none),
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.search, color: Colors.black),
        contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
        hintText: 'Search requests',
        filled: true,
        fillColor: Colors.transparent,

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(7),
          borderSide: BorderSide(color: Colors.black.withAlpha(100), width: 0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(7),
          borderSide: BorderSide(color: Colors.black.withAlpha(100), width: 0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(7),
          borderSide: BorderSide(color: Colors.black.withAlpha(100), width: 0),
        ),
      ),
      cursorColor: Colors.black,
      onChanged: (value) {
        _searchTerm = value;
        context.read<RequestListBloc>().add(
          LoadRequestsByFilterEvent(_selectedStatus, _searchTerm),
        );
      },
    );
  }

  Widget _floatingActionButton() {
    return BlocBuilder<RequestListBloc, RequestListState>(
      builder: (context, state) {
        if (state is RequestListLoading) {
          return FloatingActionButton(
            onPressed: null,
            backgroundColor: Colors.grey,
            child: const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2,
              ),
            ),
          );
        }

        if (state is RequestListError) {
          // Optionally show an error FAB
          return FloatingActionButton(
            onPressed: () {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.message)));
            },
            backgroundColor: Colors.red,
            child: const Icon(Icons.error),
          );
        }
        if (state is RequestListLoaded) {
          // Default: Show your SpeedDial
          return SpeedDial(
            label: const Text('Actions'),
            icon: Icons.add,
            activeIcon: Icons.close,
            backgroundColor: Colors.blue,
            overlayColor: Colors.black,
            overlayOpacity: 0.4,
            spacing: 12,
            spaceBetweenChildren: 8,
            children: [
              ...state.possibleActions.map((action) {
                return SpeedDialChild(
                  child: action.icon,
                  label: action.name,
                  backgroundColor: action.actionColor,
                  onTap: () {
                    ConfirmDialog.show(
                      context: context,
                      title: action.dialogBoxMessage.title,
                      description: action.dialogBoxMessage.description,
                      confirmText: action.dialogBoxMessage.confirmText,
                      onConfirm: () {
                        // activate a event - update
                        context.read<RequestListBloc>().add(
                          UpdateRequestsEvent(
                            ActionMapping.getStatusMappingForAction(action),
                          ),
                        );
                      },
                    );
                  },
                );
              }),
            ],
          );
        } else {
          return FloatingActionButton(
            onPressed: null,
            backgroundColor: Colors.grey,
            child: const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2,
              ),
            ),
          );
        }
      },
    );
  }

  Widget _buildStatusFilter() {
    final statuses = <RequestStatus?>[
      null, // "All"
      RequestStatus.requested,
      RequestStatus.cancelled,
      RequestStatus.referred,
      RequestStatus.parentApproved,
      RequestStatus.parentDenied,
      RequestStatus.approved,
      RequestStatus.rejected,
      RequestStatus.inactive,
    ];

    final statusLabels = {
      null: 'All',
      RequestStatus.requested: 'Requested',
      RequestStatus.cancelled: 'Cancelled',
      RequestStatus.referred: 'Referred',
      RequestStatus.parentApproved: 'Parent Approved',
      RequestStatus.parentDenied: 'Parent Denied',
      RequestStatus.approved: 'Approved',
      RequestStatus.rejected: 'Rejected',
      RequestStatus.inactive: 'Inactive',
    };

    final theme = ShadTheme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 6),
      child: ConstrainedBox(
        constraints: const BoxConstraints(minWidth: 100),
        child: ShadSelect<RequestStatus?>(
          placeholder: const Text('Filter by status'),
          options: [
            Padding(
              padding: const EdgeInsets.fromLTRB(32, 6, 6, 6),
              child: Text(
                'Statuses',
                style: theme.textTheme.muted.copyWith(
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.popoverForeground,
                ),
                textAlign: TextAlign.start,
              ),
            ),
            ...statuses.map(
              (status) => ShadOption<RequestStatus?>(
                value: status,
                child: Text(statusLabels[status]!),
              ),
            ),
          ],
          selectedOptionBuilder: (context, value) => Text(
            statusLabels[value]!,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          onChanged: (status) {
            setState(() => _selectedStatus = status);

            context.read<RequestListBloc>().add(
              LoadRequestsByFilterEvent(status, _searchTerm),
            );
          },
        ),
      ),
    );
  }
}
