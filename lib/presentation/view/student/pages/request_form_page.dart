// presentation/view/student/request_form_page.dart
import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';
import 'package:hostel_mgmt/core/enums/enum.dart';
import 'package:hostel_mgmt/core/rumtime_state/login_session.dart';
import 'package:hostel_mgmt/core/theme/app_theme.dart';
import 'package:hostel_mgmt/presentation/view/student/controllers/request_form_controller.dart';
import 'package:hostel_mgmt/presentation/view/student/state/request_form_state.dart';
import 'package:hostel_mgmt/presentation/widgets/reason_card.dart';
import 'package:provider/provider.dart';
import 'package:hostel_mgmt/presentation/widgets/restriction_card.dart';
import 'package:hostel_mgmt/presentation/widgets/type_toggle.dart';
import 'package:hostel_mgmt/presentation/widgets/date_card.dart';
import 'package:hostel_mgmt/presentation/widgets/time_card.dart';
import 'package:hostel_mgmt/core/helpers/app_refreasher_widget.dart';
import 'package:hostel_mgmt/presentation/widgets/welcome_header.dart';

// Helper for showing date picker.
Future<DateTime?> pickDate(BuildContext ctx, DateTime? initial) async {
  final today = DateTime.now();
  return showDatePicker(
    context: ctx,
    initialDate: initial ?? today,
    firstDate: DateTime(
      today.year,
      today.month,
      today.day,
    ), // today-only minimum
    lastDate: today.add(const Duration(days: 365)),
  );
}

// Helper for showing time picker.
// outing_request_form.dart (update pickTime)
Future<TimeOfDay?> pickTime(BuildContext ctx, TimeOfDay? initial) async {
  return showTimePicker(
    context: ctx,
    initialTime: initial ?? TimeOfDay.now(),
    builder: (ctx, child) => MediaQuery(
      data: MediaQuery.of(ctx).copyWith(alwaysUse24HourFormat: false),
      child: child!,
    ),
  );
}

class RequestFormPage extends StatelessWidget {
  RequestFormPage({super.key});

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;
    final padding = EdgeInsets.symmetric(
      horizontal: 31 * mediaQuery.width / 402,
    );

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<RequestFormState>(
          create: (_) => RequestFormState(),
        ),
        Provider<RequestFormController>(
          create: (ctx) {
            final state = ctx.read<RequestFormState>();
            final c = RequestFormController(state: state, context: ctx);
            WidgetsBinding.instance.addPostFrameCallback((_) {
              c.ensureBootstrapped();
            });
            return c;
          },
        ),
      ],
      // Use builder so that the child context has access to providers
      builder: (context, child) {
        final loginSession = Get.find<LoginSession>();
        print(loginSession.imageURL);
        // Use Consumer here to get the provider instance safely
        return Consumer<RequestFormState>(
          builder: (context, provider, _) => Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: mediaQuery.height * 50 / 874),
                child: Container(
                  margin: padding,
                  child: WelcomeHeader(
                    phoneNumber: loginSession.phone,
                    enrollmentNumber: loginSession.identityId,
                    hostelName: loginSession.hostels!.first,
                    roomNumber: loginSession.roomNo,
                    actor: TimelineActor.student,
                    name: loginSession.username,
                    avatarUrl: loginSession.imageURL,
                    greeting: 'Welcome,',
                  ),
                ),
              ),
              // Pass provider down or wrap below with Consumer accordingly
              const Expanded(child: _RequestFormView()),
            ],
          ),
        );
      },
    );
  }
}

class _RequestFormView extends StatelessWidget {
  const _RequestFormView();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<RequestFormState>();
    final controller = context.read<RequestFormController>();
    final mediaQuery = MediaQuery.of(context).size;
    // final padding = EdgeInsets.symmetric(
    //   horizontal: 31 * mediaQuery.width / 402,
    // );
    final padding2 = EdgeInsets.symmetric(
      horizontal: 31 * mediaQuery.width / 402,
      vertical: 18,
    );
    final textTheme = Theme.of(context).textTheme;

    return AppRefreshWrapper(
      onRefresh: () async {
        // Unfocus any focused input before showing dialog and clearing
        FocusScope.of(context).unfocus();

        final confirmed =
            await showDialog<bool>(
              context: context,
              barrierDismissible: true, // allow tap outside to close dialog
              builder: (ctx) => AlertDialog(
                title: const Text('Clear form?'),
                content: const Text(
                  'Are you sure you want to remove the entered data? This cannot be undone.',
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(ctx).pop(false),
                    child: const Text('Cancel'),
                  ),
                  FilledButton(
                    onPressed: () => Navigator.of(ctx).pop(true),
                    child: const Text('Clear & refresh'),
                  ),
                ],
              ),
            ) ??
            false;

        if (!confirmed) return;
        provider.clearState();
        await Future.wait([controller.loadRestriction()]);
        // reload rules on refresh
      },
      // onRefresh: () async {
      //   final confirmed =
      //       await showDialog<bool>(
      //         context: context,
      //         barrierDismissible: false,
      //         builder: (ctx) => AlertDialog(
      //           title: const Text('Clear form?'),
      //           content: const Text(
      //             'Are you sure you want to remove the entered data? This cannot be undone.',
      //           ),
      //           actions: [
      //             TextButton(
      //               onPressed: () => Navigator.of(ctx).pop(false),
      //               child: const Text('Cancel'),
      //             ),
      //             FilledButton(
      //               onPressed: () => Navigator.of(ctx).pop(true),
      //               child: const Text('Clear & refresh'),
      //             ),
      //           ],
      //         ),
      //       ) ??
      //       false;

      //   if (!confirmed) return;
      //   provider.clearState();
      //   await controller.loadRestriction(); // reload rules on refresh
      // },
      child: SingleChildScrollView(
        child: Container(
          margin: padding2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RestrictionCard(
                restriction: provider.restrictionWindow,
                isLoading: provider.isLoadingRestriction,
                isApplicable: provider.isDayout,
                onRetry: () => controller.loadRestriction(),
              ),
              const SizedBox(height: 20),
              Text("OUTING  TYPE", style: textTheme.h6),
              const SizedBox(height: 5),
              TypeToggle(
                selected: provider.requestType,
                onChanged: provider.setRequestType,
              ),
              const SizedBox(height: 20),

              if (provider.isDayout) ...[
                // Reason (common to both)
                const SizedBox(height: 10),
                ReasonCard(
                  value: provider.reason,
                  label: "Reason",
                  placeholder: "Write a brief reason for the request",
                  touched: provider.touchedReason,
                  error: provider.errorReason,
                  onChanged: provider.setReason,
                  maxLength: 300, // optional
                ),
                const SizedBox(height: 10),

                DateCard(
                  value: provider.dayoutDate,
                  label: "Dayout Date",
                  placeholder: "Select date",
                  touched: provider.touchedDayoutDate,
                  error: provider.errorDayoutDate,
                  onTap: () async {
                    final picked = await pickDate(context, provider.dayoutDate);
                    if (picked != null) provider.setDayoutDate(picked);
                  },
                ),
                const SizedBox(height: 10),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: TimeCard(
                        value: provider.dayoutFromTime,
                        label: "From time",
                        placeholder: "Select Time",
                        touched: provider.touchedDayoutFromTime,
                        error: provider.errorDayoutFromTime,
                        onTap: () async {
                          final picked = await pickTime(
                            context,
                            provider.dayoutFromTime,
                          );
                          if (picked != null) {
                            provider.setDayoutFromTime(picked);
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TimeCard(
                        value: provider.dayoutToTime,
                        label: "To time",
                        placeholder: "Select time",
                        touched: provider.touchedDayoutToTime,
                        error: provider.errorDayoutToTime,
                        onTap: () async {
                          final picked = await pickTime(
                            context,
                            provider.dayoutToTime,
                          );
                          if (picked != null) provider.setDayoutToTime(picked);
                        },
                      ),
                    ),
                  ],
                ),
              ],

              if (provider.isLeave) ...[
                const SizedBox(height: 10),
                ReasonCard(
                  value: provider.reason,
                  label: "Reason",
                  placeholder: "Write a brief reason for the request",
                  touched: provider.touchedReason,
                  error: provider.errorReason,
                  onChanged: provider.setReason,
                  maxLength: 300, // optional
                ),
                const SizedBox(height: 10),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: DateCard(
                        value: provider.leaveFromDate,
                        label: "From date",
                        placeholder: "Select Time",
                        touched: provider.touchedLeaveFromDate,
                        error: provider.errorLeaveFromDate,
                        onTap: () async {
                          final picked = await pickDate(
                            context,
                            provider.leaveFromDate,
                          );
                          if (picked != null) provider.setLeaveFromDate(picked);
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TimeCard(
                        value: provider.leaveFromTime,
                        label: "From time",
                        placeholder: "From time",
                        touched: provider.touchedLeaveFromTime,
                        error: provider.errorLeaveFromTime,
                        onTap: () async {
                          final picked = await pickTime(
                            context,
                            provider.leaveFromTime,
                          );
                          if (picked != null) provider.setLeaveFromTime(picked);
                        },
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: DateCard(
                        value: provider.leaveToDate,
                        label: "To date",
                        placeholder: "Select Date",
                        touched: provider.touchedLeaveToDate,
                        error: provider.errorLeaveToDate,
                        onTap: () async {
                          final picked = await pickDate(
                            context,
                            provider.leaveToDate,
                          );
                          provider.setLeaveToDate(picked);
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TimeCard(
                        value: provider.leaveToTime,
                        label: "To time",
                        placeholder: "Select Time",
                        touched: provider.touchedLeaveToTime,
                        error: provider.errorLeaveToTime,
                        onTap: () async {
                          final picked = await pickTime(
                            context,
                            provider.leaveToTime,
                          );
                          if (picked != null) provider.setLeaveToTime(picked);
                        },
                      ),
                    ),
                  ],
                ),
              ],

              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: provider.isSubmittable
                      ? () async {
                          await controller.submit();
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    backgroundColor: provider.isFormValid
                        ? Colors.indigo
                        : Colors.grey.shade400,
                  ),
                  child: provider.isSubmitting
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 3),
                        )
                      : Text(
                          provider.isDayout
                              ? "Submit Dayout Request"
                              : "Submit Leave Request",
                          style: textTheme.h5.w500.copyWith(color: greyColor),
                        ),
                ),
              ),
              Container(height: 84 + MediaQuery.of(context).viewPadding.bottom),
            ],
          ),
        ),
      ),
    );
  }
}
