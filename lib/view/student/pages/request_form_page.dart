import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/request_form_state.dart';
import '../controllers/request_form_controller.dart';
import '../../../models/outing_rule_model.dart';
// Removed third-party picker, using built-in pickers

class RequestFormPage extends StatelessWidget {
  final OutingRule outingRule;
  const RequestFormPage({super.key, required this.outingRule});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<RequestFormState>(
      create: (_) => RequestFormState(outingRule: outingRule),
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
                if (!outingRule.isUnrestricted)
                  Card(
                    color: outingRule.isRestricted
                        ? Colors.red[100]
                        : Colors.green[100],
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text(
                        outingRule.isRestricted
                            ? 'Outing is restricted today.'
                            : 'Outing allowed from ${OutingRule.formatTimeOfDay(outingRule.fromTime!)} to ${OutingRule.formatTimeOfDay(outingRule.toTime!)}',
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
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: state.isSubmitting
                        ? null
                        : () => controller.submit(),
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
