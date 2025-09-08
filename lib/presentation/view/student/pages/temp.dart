// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:hostel_mgmt/models/outing_rule_model.dart';
// import 'package:hostel_mgmt/presentation/widgets/welcome_header.dart';
// import 'package:provider/provider.dart';
// import '../state/request_form_state.dart';
// import '../controllers/request_form_controller.dart';
// import 'package:hostel_mgmt/core/rumtime_state/login_session.dart';
// import 'package:intl/intl.dart';

// class RequestFormPage extends StatelessWidget {
//   const RequestFormPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final mediaQuery = MediaQuery.of(context);
//     final padding = EdgeInsets.symmetric(
//       horizontal: 31 * mediaQuery.size.width / 402,
//     );

//     return ChangeNotifierProvider<RequestFormState>(
//       create: (_) {
//         final s = RequestFormState();
//         // Run fetch once, after the first frame.
//         Future.microtask(
//           () => RequestFormController(state: s).fetchOutingRule(),
//         );
//         return s;
//       },
//       child: _RequestFormView(padding: padding),
//     );
//   }
// }

// class _RequestFormView extends StatelessWidget {
//   const _RequestFormView({required this.padding});
//   final EdgeInsets padding;

//   @override
//   Widget build(BuildContext context) {
//     final session = Get.find<LoginSession>();
//     final mq = MediaQuery.of(context);
//     return Padding(
//       padding: EdgeInsets.only(top: mq.size.height * 50 / 874),
//       child: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Container(
//       margin: padding,
//       child: WelcomeHeader(
//         name: session.username,
//         avatarUrl: session.imageURL,
//         greeting: 'Welcome back,',
//       ),),
//             const SizedBox(height: 20),
//             Padding(
//               padding: padding,
//               child: Column(
//                 children: const [
//                   _OutingRuleBanner(),
//                   SizedBox(height: 20),
//                   _ReasonField(),
//                   SizedBox(height: 20),
//                   _DateTimeRow(),
//                   _ErrorBanner(),
//                   SizedBox(height: 30),
//                   _SubmitButton(),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class _OutingRuleBanner extends StatelessWidget {
//   const _OutingRuleBanner();

//   @override
//   Widget build(BuildContext context) {
//     return Selector<RequestFormState, (bool, bool, OutingRule?)>(
//       selector: (_, s) =>
//           (s.isLoadingRules, s.isRestricted, s.loadedOutingRule),
//       builder: (_, tuple, __) {
//         final (loading, restricted, rule) = tuple;
//         if (loading) {
//           return const Card(
//             color: Colors.white,
//             child: SizedBox(
//               height: 50,
//               width: double.infinity,
//               child: Center(),
//             ),
//           );
//         }
//         if (rule == null || rule.isUnrestricted) return const SizedBox.shrink();

//         final cardColor = restricted ? Colors.red[100] : Colors.green[100];
//         final iconColor = restricted ? Colors.red : Colors.green;
//         final message = restricted
//             ? 'Dayout is restricted today.'
//             : 'Dayout from ${OutingRule.formatDuration(rule.fromTime!)} to ${OutingRule.formatDuration(rule.toTime!)}';

//         return Card(
//           color: cardColor,
//           child: Padding(
//             padding: const EdgeInsets.symmetric(
//               vertical: 12.0,
//               horizontal: 12.0,
//             ),
//             child: Row(
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 5),
//                   child: Icon(Icons.warning, color: iconColor),
//                 ),
//                 Text(
//                   message,
//                   style: const TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
// }

// class _ReasonField extends StatelessWidget {
//   const _ReasonField();

//   @override
//   Widget build(BuildContext context) {
//     return Selector<RequestFormState, (String, String?)>(
//       selector: (_, s) => (s.reason, s.reasonError),
//       builder: (_, data, __) {
//         final (_, error) = data;
//         return TextField(
//           maxLines: 3,
//           onChanged: context.read<RequestFormState>().setReason,
//           decoration: InputDecoration(
//             labelText: 'Reason for Outing',
//             hintText:
//                 'Please provide a detailed reason for your outing request...',
//             border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
//             errorText: error,
//             alignLabelWithHint: true,
//           ),
//         );
//       },
//     );
//   }
// }

// class _DateTimeRow extends StatelessWidget {
//   const _DateTimeRow();

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: const [
//         Expanded(child: _FromDateTimeField()),
//         SizedBox(width: 10),
//         Expanded(child: _ToDateTimeField()),
//       ],
//     );
//   }
// }

// class _FromDateTimeField extends StatelessWidget {
//   const _FromDateTimeField();

//   @override
//   Widget build(BuildContext context) {
//     return Selector<RequestFormState, (DateTime?, String?, OutingRule?)>(
//       selector: (_, s) => (s.fromDateTime, s.fromError, s.loadedOutingRule),
//       builder: (_, data, __) {
//         final (value, error, rule) = data;
//         return DateTimeField(
//           label: 'From',
//           value: value,
//           errorText: error,
//           onPick: () async {
//             final now = DateTime.now();
//             final pickedDate = await showDatePicker(
//               context: context,
//               initialDate: value ?? now,
//               firstDate: now.subtract(const Duration(days: 365)),
//               lastDate: now.add(const Duration(days: 365)),
//             );
//             if (pickedDate == null) return;
//             final pickedTime = await showTimePicker(
//               context: context,
//               initialTime: TimeOfDay.fromDateTime(value ?? now),
//             );
//             if (pickedTime == null) return;
//             final combined = DateTime(
//               pickedDate.year,
//               pickedDate.month,
//               pickedDate.day,
//               pickedTime.hour,
//               pickedTime.minute,
//             );
//             context.read<RequestFormState>().setFromDateTime(combined);
//           },
//           helperText: (rule != null && !rule.isUnrestricted)
//               ? 'Allowed: ${OutingRule.formatDuration(rule.fromTime!)} – ${OutingRule.formatDuration(rule.toTime!)}'
//               : null,
//         );
//       },
//     );
//   }
// }

// class _ToDateTimeField extends StatelessWidget {
//   const _ToDateTimeField();

//   @override
//   Widget build(BuildContext context) {
//     return Selector<RequestFormState, (DateTime?, String?, DateTime?)>(
//       selector: (_, s) => (s.toDateTime, s.toError, s.fromDateTime),
//       builder: (_, data, __) {
//         final (value, error, from) = data;
//         final now = DateTime.now();
//         final initial =
//             value ?? (from != null && from.isAfter(now) ? from : now);
//         return DateTimeField(
//           label: 'To',
//           value: value,
//           errorText: error,
//           onPick: () async {
//             final pickedDate = await showDatePicker(
//               context: context,
//               initialDate: initial,
//               firstDate: now.subtract(const Duration(days: 365)),
//               lastDate: now.add(const Duration(days: 365)),
//             );
//             if (pickedDate == null) return;
//             final pickedTime = await showTimePicker(
//               context: context,
//               initialTime: TimeOfDay.fromDateTime(value ?? initial),
//             );
//             if (pickedTime == null) return;
//             final combined = DateTime(
//               pickedDate.year,
//               pickedDate.month,
//               pickedDate.day,
//               pickedTime.hour,
//               pickedTime.minute,
//             );
//             context.read<RequestFormState>().setToDateTime(combined);
//           },
//         );
//       },
//     );
//   }
// }

// class DateTimeField extends StatelessWidget {
//   const DateTimeField({
//     required this.label,
//     required this.value,
//     required this.onPick,
//     this.errorText,
//     this.helperText,
//   });

//   final String label;
//   final DateTime? value;
//   final Future<void> Function() onPick;
//   final String? errorText;
//   final String? helperText;

//   @override
//   Widget build(BuildContext context) {
//     final text = value == null
//         ? 'Pick date & time'
//         : DateFormat('d/M/y h:mm a').format(value!);
//     return InkWell(
//       onTap: onPick,
//       child: InputDecorator(
//         decoration: InputDecoration(
//           labelText: label,
//           errorText: errorText,
//           helperText: helperText,
//           border: const OutlineInputBorder(),
//           suffixIcon: const Icon(Icons.event),
//         ),
//         child: Text(text),
//       ),
//     );
//   }
// }

// class _ErrorBanner extends StatelessWidget {
//   const _ErrorBanner();

//   @override
//   Widget build(BuildContext context) {
//     return Selector<RequestFormState, String?>(
//       selector: (_, s) => s.generalError,
//       builder: (_, msg, __) {
//         if (msg == null) return const SizedBox(height: 0);
//         return Padding(
//           padding: const EdgeInsets.only(top: 8.0, bottom: 16.0),
//           child: Row(
//             children: [
//               const Icon(Icons.error, color: Colors.red, size: 20),
//               const SizedBox(width: 8),
//               Expanded(
//                 child: Text(
//                   msg,
//                   style: const TextStyle(
//                     color: Colors.red,
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
// }

// class _SubmitButton extends StatelessWidget {
//   const _SubmitButton();

//   @override
//   Widget build(BuildContext context) {
//     return Selector<RequestFormState, (bool, bool)>(
//       selector: (_, s) => (s.canSubmit, s.isSubmitting),
//       builder: (_, data, __) {
//         final (canSubmit, isSubmitting) = data;
//         return SizedBox(
//           width: double.infinity,
//           child: ElevatedButton(
//             onPressed: (!canSubmit || isSubmitting)
//                 ? null
//                 : () async {
//                     final state = context.read<RequestFormState>();
//                     final ok = await RequestFormController(
//                       state: state,
//                     ).submit();
//                     if (ok && context.mounted) {
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         const SnackBar(
//                           content: Text('Request submitted successfully!'),
//                         ),
//                       );
//                     }
//                   },
//             child: isSubmitting
//                 ? const SizedBox(
//                     width: 24,
//                     height: 24,
//                     child: CircularProgressIndicator(
//                       strokeWidth: 2,
//                       color: Colors.white,
//                     ),
//                   )
//                 : const Text('Submit Request'),
//           ),
//         );
//       },
//     );
//   }
// }
