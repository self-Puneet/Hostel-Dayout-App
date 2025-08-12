// lib/requests/presentation/widgets/request_card.dart
import 'package:flutter/material.dart';
import 'package:hostel_dayout_app/core/enums/request_status.dart';
import 'package:hostel_dayout_app/core/enums/request_type.dart';
import 'package:hostel_dayout_app/core/util/input_convertor.dart';
import 'package:hostel_dayout_app/requests/domain/entities/request.dart';

class RequestCard extends StatelessWidget {
  final Request request;
  final VoidCallback? onTap;
  final VoidCallback? onCallTap;

  const RequestCard({
    Key? key,
    required this.request,
    this.onTap,
    this.onCallTap,
  }) : super(key: key);

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'requested': // Student submitted
        return Colors.blue;
      case 'referred': // Sent to parent
        return Colors.orange;
      case 'cancelled': // Warden cancelled before review
        return Colors.grey;
      case 'parent approved':
        return Colors.green;
      case 'parent denied':
        return Colors.redAccent;
      case 'rejected': // Warden rejected after parent approval
        return Colors.red;
      case 'approved': // Warden approved after parent approval
        return Colors.green.shade700;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final inputConvertor = InputConverter();
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Card(
        elevation: 1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 0),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Circle avatar with initials
              CircleAvatar(
                radius: 20,
                child: Text(
                  request.student.name.isNotEmpty
                      ? request.student.name
                            .split(' ')
                            .map((e) => e[0])
                            .take(2)
                            .join()
                      : '',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(width: 12),

              // Main info column
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name & status
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                request.student.name,
                                style: Theme.of(context).textTheme.titleMedium
                                    ?.copyWith(fontWeight: FontWeight.w600),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                request.type.displayName,
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 2),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: _statusColor(
                              request.status.displayName,
                            ).withValues(alpha: 0.15),

                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            request.status.displayName.split(' ').join('\n'),
                            style: TextStyle(
                              fontSize: 12,
                              color: _statusColor(request.status.displayName),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Out: ${inputConvertor.dateFormater(request.outTime).getOrElse(() => '')} • \n'
                      'Back: ${inputConvertor.dateFormater(request.returnTime).getOrElse(() => '')}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 8),

              // Call button
              IconButton(
                onPressed: onCallTap,
                icon: const Icon(Icons.phone),
                color: Theme.of(context).primaryColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
