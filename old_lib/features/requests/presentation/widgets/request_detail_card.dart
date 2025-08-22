import 'package:flutter/material.dart';
import '../../../../../lib/core/util/input_convertor.dart';

class RequestDetailCard extends StatelessWidget {
  final String type;
  final DateTime outTime;
  final DateTime returnTime;
  final String reason;
  final DateTime requestedOn;

  const RequestDetailCard({
    Key? key,
    required this.type,
    required this.outTime,
    required this.returnTime,
    required this.reason,
    required this.requestedOn,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final inputConverter = InputConverter();
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
              text: TextSpan(
                style: Theme.of(context).textTheme.bodyMedium,
                children: [
                  const TextSpan(
                    text: 'Type: ',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: type),
                ],
              ),
            ),
            const SizedBox(height: 4),
            RichText(
              text: TextSpan(
                style: Theme.of(context).textTheme.bodyMedium,
                children: [
                  const TextSpan(
                    text: 'Out: ',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text: inputConverter
                        .dateFormater(outTime)
                        .getOrElse(() => ''),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 4),
            RichText(
              text: TextSpan(
                style: Theme.of(context).textTheme.bodyMedium,
                children: [
                  const TextSpan(
                    text: 'Return: ',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text: inputConverter
                        .dateFormater(returnTime)
                        .getOrElse(() => ''),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 4),
            RichText(
              text: TextSpan(
                style: Theme.of(context).textTheme.bodyMedium,
                children: [
                  const TextSpan(
                    text: 'Reason: ',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: reason),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Requested on ${inputConverter.dateFormater(returnTime).getOrElse(() => '')}',
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }
}
