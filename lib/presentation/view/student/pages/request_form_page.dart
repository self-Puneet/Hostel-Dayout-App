import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hostel_mgmt/core/enums/request_type.dart';
import 'package:hostel_mgmt/models/outing_rule_model.dart';
import 'package:hostel_mgmt/presentation/widgets/welcome_header.dart';
import 'package:provider/provider.dart';
import '../state/request_form_state.dart';
import '../controllers/request_form_controller.dart';
import 'package:hostel_mgmt/core/rumtime_state/login_session.dart';
import 'package:intl/intl.dart';

class RequestFormPage extends StatelessWidget {
  const RequestFormPage({super.key});

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final padding = EdgeInsets.symmetric(
      horizontal: 31 * mediaQuery.size.width / 402,
    );

    return ChangeNotifierProvider<RequestFormState>(
      create: (context) {
        final s = RequestFormState();
        // Fetch outing rule once after mount
        Future.microtask(
          () => RequestFormController(
            state: s,
            context: context,
          ).fetchOutingRule(),
        );
        return s;
      },
      child: _RequestFormView(padding: padding),
    );
  }
}

class _RequestFormView extends StatelessWidget {
  const _RequestFormView({required this.padding});
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    final session = Get.find<LoginSession>();
    final mq = MediaQuery.of(context);
    print("-----------------------------------------${session.imageURL}");
    return Padding(
      padding: EdgeInsets.only(top: mq.size.height * 50 / 874),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: padding,
              child: WelcomeHeader(
                actor: session.role,
                name: session.username,
                avatarUrl: session.imageURL,
                greeting: 'Welcome back,',
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: padding,
              child: Column(
                children: const [
                  _OutingRuleBanner(),
                  SizedBox(height: 20),
                  _ReasonField(),
                  SizedBox(height: 20),
                  _FromRow(),
                  SizedBox(height: 12),
                  _ToRow(),
                  _ErrorBanner(),
                  SizedBox(height: 16),
                  _RequestTypeDropdown(),
                  SizedBox(height: 30),
                  _SubmitButton(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OutingRuleBanner extends StatelessWidget {
  const _OutingRuleBanner();

  @override
  Widget build(BuildContext context) {
    return Selector<RequestFormState, (bool, bool, OutingRule?, RequestType)>(
      selector: (_, s) => (
        s.isLoadingRules,
        s.isRestricted,
        s.loadedOutingRule,
        s.selectedType,
      ),
      builder: (_, data, __) {
        final (loading, restricted, rule, type) = data;
        if (type != RequestType.dayout) return const SizedBox.shrink();
        if (loading) {
          return const Card(
            color: Colors.white,
            child: SizedBox(
              height: 50,
              width: double.infinity,
              child: Center(),
            ),
          );
        }
        if (rule == null || rule.isUnrestricted) return const SizedBox.shrink();
        // lighter shade for red and green for cardColor
        final cardColor = restricted ? Colors.red[100] : Colors.green[100];
        final iconColor = restricted ? Colors.red : Colors.green;
        final message = restricted
            ? 'Dayout is restricted today.'
            : 'Dayout from ${OutingRule.formatDuration(rule.fromTime!)} to ${OutingRule.formatDuration(rule.toTime!)}';

        return Card(
          color: cardColor,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 12.0,
              horizontal: 12.0,
            ),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Icon(Icons.warning, color: iconColor),
                ),
                Text(
                  message,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ReasonField extends StatelessWidget {
  const _ReasonField();

  @override
  Widget build(BuildContext context) {
    return Selector<RequestFormState, (String, String?)>(
      selector: (_, s) => (s.reason, s.uiReasonError),
      builder: (_, data, __) {
        final (_, error) = data;
        return TextField(
          maxLines: 3,
          onChanged: context.read<RequestFormState>().setReason,
          decoration: InputDecoration(
            labelText: 'Reason',
            hintText: 'Describe the request...',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
            errorText: error,
            alignLabelWithHint: true,
          ),
        );
      },
    );
  }
}

class _FromRow extends StatelessWidget {
  const _FromRow();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        Expanded(child: _FromDateField()),
        SizedBox(width: 10),
        Expanded(child: _FromTimeField()),
      ],
    );
  }
}

class _ToRow extends StatelessWidget {
  const _ToRow();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        Expanded(child: _ToDateField()),
        SizedBox(width: 10),
        Expanded(child: _ToTimeField()),
      ],
    );
  }
}

class _FromDateField extends StatelessWidget {
  const _FromDateField();

  @override
  Widget build(BuildContext context) {
    return Selector<
      RequestFormState,
      (DateTime?, String?, RequestType, OutingRule?)
    >(
      selector: (_, s) =>
          (s.fromDate, s.uiFromDateError, s.selectedType, s.loadedOutingRule),
      builder: (_, data, __) {
        final (value, error, type, rule) = data;
        final helper =
            (type == RequestType.dayout && rule != null && !rule.isUnrestricted)
            ? 'Allowed: ${OutingRule.formatDuration(rule.fromTime!)} – ${OutingRule.formatDuration(rule.toTime!)}'
            : null;
        return DateField(
          label: 'From date',
          value: value,
          errorText: error,
          helperText: helper,
          onPick: () async {
            final now = DateTime.now();
            final pickedDate = await showDatePicker(
              context: context,
              initialDate: value ?? now,
              firstDate: now.subtract(const Duration(days: 365)),
              lastDate: now.add(const Duration(days: 365)),
            );
            context.read<RequestFormState>().setFromDate(pickedDate);
          },
        );
      },
    );
  }
}

class _FromTimeField extends StatelessWidget {
  const _FromTimeField();

  @override
  Widget build(BuildContext context) {
    return Selector<
      RequestFormState,
      (TimeOfDay?, String?, RequestType, OutingRule?)
    >(
      selector: (_, s) =>
          (s.fromTime, s.uiFromTimeError, s.selectedType, s.loadedOutingRule),
      builder: (_, data, __) {
        final (value, error, type, rule) = data;
        final helper =
            (type == RequestType.dayout && rule != null && !rule.isUnrestricted)
            ? 'Allowed: ${OutingRule.formatDuration(rule.fromTime!)} – ${OutingRule.formatDuration(rule.toTime!)}'
            : null;
        return TimeField(
          label: 'From time',
          value: value,
          errorText: error,
          helperText: helper,
          onPick: () async {
            final picked = await showTimePicker(
              context: context,
              initialTime: value ?? TimeOfDay.now(),
            );
            context.read<RequestFormState>().setFromTime(picked);
          },
        );
      },
    );
  }
}

class _ToDateField extends StatelessWidget {
  const _ToDateField();

  @override
  Widget build(BuildContext context) {
    return Selector<RequestFormState, (DateTime?, String?)>(
      selector: (_, s) => (s.toDate, s.uiToDateError),
      builder: (_, data, __) {
        final (value, error) = data;
        return DateField(
          label: 'To date',
          value: value,
          errorText: error,
          onPick: () async {
            final now = DateTime.now();
            final pickedDate = await showDatePicker(
              context: context,
              initialDate: value ?? now,
              firstDate: now.subtract(const Duration(days: 365)),
              lastDate: now.add(const Duration(days: 365)),
            );
            context.read<RequestFormState>().setToDate(pickedDate);
          },
        );
      },
    );
  }
}

class _ToTimeField extends StatelessWidget {
  const _ToTimeField();

  @override
  Widget build(BuildContext context) {
    return Selector<RequestFormState, (TimeOfDay?, String?)>(
      selector: (_, s) => (s.toTime, s.uiToTimeError),
      builder: (_, data, __) {
        final (value, error) = data;
        return TimeField(
          label: 'To time',
          value: value,
          errorText: error,
          onPick: () async {
            final picked = await showTimePicker(
              context: context,
              initialTime: value ?? TimeOfDay.now(),
            );
            context.read<RequestFormState>().setToTime(picked);
          },
        );
      },
    );
  }
}

class DateField extends StatelessWidget {
  const DateField({
    required this.label,
    required this.value,
    required this.onPick,
    this.errorText,
    this.helperText,
  });

  final String label;
  final DateTime? value;
  final Future<void> Function() onPick;
  final String? errorText;
  final String? helperText;

  @override
  Widget build(BuildContext context) {
    final text = value == null ? 'Pick date' : DateFormat.yMd().format(value!);
    return InkWell(
      onTap: onPick,
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          errorText: errorText,
          helperText: helperText,
          border: const OutlineInputBorder(),
          suffixIcon: const Icon(Icons.event),
        ),
        child: Text(text),
      ),
    );
  }
}

class TimeField extends StatelessWidget {
  const TimeField({
    required this.label,
    required this.value,
    required this.onPick,
    this.errorText,
    this.helperText,
  });

  final String label;
  final TimeOfDay? value;
  final Future<void> Function() onPick;
  final String? errorText;
  final String? helperText;

  @override
  Widget build(BuildContext context) {
    final display = value == null
        ? 'Pick time'
        : DateFormat(
            'h:mm a',
          ).format(DateTime(0, 1, 1, value!.hour, value!.minute));
    return InkWell(
      onTap: onPick,
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          errorText: errorText,
          helperText: helperText,
          border: const OutlineInputBorder(),
          suffixIcon: const Icon(Icons.schedule),
        ),
        child: Text(display),
      ),
    );
  }
}

class _ErrorBanner extends StatelessWidget {
  const _ErrorBanner();

  @override
  Widget build(BuildContext context) {
    return Selector<RequestFormState, String?>(
      selector: (_, s) => s.generalError,
      builder: (_, msg, __) {
        if (msg == null) return const SizedBox(height: 0);
        return Padding(
          padding: const EdgeInsets.only(top: 8.0, bottom: 16.0),
          child: Row(
            children: [
              const Icon(Icons.error, color: Colors.red, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  msg,
                  style: const TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _RequestTypeDropdown extends StatelessWidget {
  const _RequestTypeDropdown();

  @override
  Widget build(BuildContext context) {
    return Selector<RequestFormState, RequestType>(
      selector: (_, s) => s.selectedType,
      builder: (_, selected, __) {
        return DropdownButtonFormField<RequestType>(
          value: selected,
          decoration: const InputDecoration(
            labelText: 'Request type',
            border: OutlineInputBorder(),
          ),
          isExpanded: true,
          items: RequestType.values.map((t) {
            return DropdownMenuItem<RequestType>(
              value: t,
              child: Row(
                children: [
                  Icon(t.icon, color: t.color),
                  const SizedBox(width: 8),
                  Text(t.displayName),
                ],
              ),
            );
          }).toList(),
          onChanged: (v) {
            if (v != null) context.read<RequestFormState>().setRequestType(v);
          },
        );
      },
    );
  }
}

class _SubmitButton extends StatelessWidget {
  const _SubmitButton();

  @override
  Widget build(BuildContext context) {
    return Selector<RequestFormState, (bool, bool)>(
      selector: (_, s) => (s.canSubmit, s.isSubmitting),
      builder: (_, data, __) {
        final (canSubmit, isSubmitting) = data;
        return SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: (!canSubmit || isSubmitting)
                ? null
                : () async {
                    final state = context.read<RequestFormState>();
                    // Controller handles validation, API, and snackbars
                    await RequestFormController(
                      state: state,
                      context: context,
                    ).submit();
                  },
            child: isSubmitting
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
        );
      },
    );
  }
}
