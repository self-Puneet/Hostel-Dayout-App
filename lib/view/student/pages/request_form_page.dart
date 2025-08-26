import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/request_form_state.dart';
import '../controllers/request_form_controller.dart';
import '../../../models/outing_rule_model.dart';
// Removed third-party picker, using built-in pickers

class RequestFormPage extends StatelessWidget {
  const RequestFormPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<RequestFormState>(
      create: (context) {
        final state = RequestFormState();
        final controller = RequestFormController(
          state: state,
          context: context,
        );
        controller.fetchOutingRule();
        return state;
      },
      child: Consumer<RequestFormState>(
        builder: (context, state, _) {
          final controller = RequestFormController(
            state: state,
            context: context,
          );
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (state.isLoadingRules)
                  const Card(
                    child: Padding(
                      padding: EdgeInsets.all(12.0),
                      child: SizedBox(
                        height: 32,
                        child: Center(child: CircularProgressIndicator()),
                      ),
                    ),
                  )
                else if (state.loadedOutingRule != null &&
                    !state.loadedOutingRule!.isUnrestricted)
                  Card(
                    color: state.loadedOutingRule!.isRestricted
                        ? Colors.red[100]
                        : Colors.green[100],
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text(
                        state.loadedOutingRule!.isRestricted
                            ? 'Outing is restricted today.'
                            : 'Outing allowed from ${OutingRule.formatTimeOfDay(state.loadedOutingRule!.fromTime!)} to ${OutingRule.formatTimeOfDay(state.loadedOutingRule!.toTime!)}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                const SizedBox(height: 300),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Reason for outing',
                  ),
                  onChanged: state.setReason,
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        style: ButtonStyle(
                          side: MaterialStateProperty.resolveWith<BorderSide>((
                            states,
                          ) {
                            if (state.fromDateTime == null ||
                                state.isFromDateTimeValid) {
                              return const BorderSide(
                                color: Colors.grey,
                                width: 2,
                              );
                            } else {
                              return const BorderSide(
                                color: Colors.red,
                                width: 2,
                              );
                            }
                          }),
                          foregroundColor:
                              MaterialStateProperty.resolveWith<Color>((
                                states,
                              ) {
                                if (state.fromDateTime == null ||
                                    state.isFromDateTimeValid) {
                                  return Colors.black;
                                } else {
                                  return Colors.red;
                                }
                              }),
                        ),
                        onPressed: () async {
                          final pickedDate = await showDatePicker(
                            context: context,
                            initialDate: state.fromDateTime ?? DateTime.now(),
                            firstDate: DateTime.now().subtract(
                              const Duration(days: 365),
                            ),
                            lastDate: DateTime.now().add(
                              const Duration(days: 365),
                            ),
                          );
                          if (pickedDate != null) {
                            final pickedTime = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.fromDateTime(
                                state.fromDateTime ?? DateTime.now(),
                              ),
                            );
                            print("Picked From Date & Time: ${state.error}");
                            if (pickedTime != null) {
                              final combined = DateTime(
                                pickedDate.year,
                                pickedDate.month,
                                pickedDate.day,
                                pickedTime.hour,
                                pickedTime.minute,
                              );
                              state.setFromDateTime(combined);
                            }
                          }
                        },
                        child: Text(
                          state.fromDateTime == null
                              ? 'Pick From Date & Time'
                              : 'From: ${_formatDateTime(state.fromDateTime!)}',
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: OutlinedButton(
                        style: ButtonStyle(
                          side: MaterialStateProperty.resolveWith<BorderSide>((
                            states,
                          ) {
                            if (state.toDateTime == null ||
                                state.isToDateTimeValid) {
                              return const BorderSide(
                                color: Colors.grey,
                                width: 2,
                              );
                            } else {
                              return const BorderSide(
                                color: Colors.red,
                                width: 2,
                              );
                            }
                          }),
                          foregroundColor:
                              MaterialStateProperty.resolveWith<Color>((
                                states,
                              ) {
                                if (state.toDateTime == null ||
                                    state.isToDateTimeValid) {
                                  return Colors.black;
                                } else {
                                  return Colors.red;
                                }
                              }),
                        ),
                        onPressed: () async {
                          final pickedDate = await showDatePicker(
                            context: context,
                            initialDate: state.toDateTime ?? DateTime.now(),
                            firstDate: DateTime.now().subtract(
                              const Duration(days: 365),
                            ),
                            lastDate: DateTime.now().add(
                              const Duration(days: 365),
                            ),
                          );
                          if (pickedDate != null) {
                            final pickedTime = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.fromDateTime(
                                state.toDateTime ?? DateTime.now(),
                              ),
                            );
                            if (pickedTime != null) {
                              final combined = DateTime(
                                pickedDate.year,
                                pickedDate.month,
                                pickedDate.day,
                                pickedTime.hour,
                                pickedTime.minute,
                              );
                              state.setToDateTime(combined);
                            }
                          }
                        },
                        child: Text(
                          state.toDateTime == null
                              ? 'Pick To Date & Time'
                              : 'To: ${_formatDateTime(state.toDateTime!)}',
                        ),
                      ),
                    ),
                  ],
                ),
                (!state.error)
                    ? const SizedBox()
                    : Padding(
                        padding: const EdgeInsets.only(top: 8.0, bottom: 16.0),
                        child: Row(
                          children: [
                            Icon(
                              state.canSubmit
                                  ? Icons.check_circle
                                  : Icons.error,
                              color: state.canSubmit
                                  ? Colors.green
                                  : Colors.red,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                state.errorReason,
                                style: TextStyle(
                                  color: state.canSubmit
                                      ? Colors.green
                                      : Colors.red,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: state.isSubmitting || !state.canSubmit
                        // state.isSubmitting || !state.canSubmit
                        ? null
                        : () => controller.submit(),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.resolveWith<Color>(
                        (states) {
                          if (state.isSubmitting ||
                              state.loadedOutingRule == null ||
                              state.loadedOutingRule!.isRestricted) {
                            return Colors.grey;
                          } else {
                            return Theme.of(context).primaryColor;
                          }
                        },
                      ),
                    ),
                    child: state.isSubmitting
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text('Submit Request'),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

String _formatDateTime(DateTime dt) {
  return '${dt.day}/${dt.month}/${dt.year} ${_formatTime(dt)}';
}

String _formatTime(DateTime dt) {
  final hour = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
  final minute = dt.minute.toString().padLeft(2, '0');
  final period = dt.hour < 12 ? 'AM' : 'PM';
  return '$hour:$minute $period';
}
