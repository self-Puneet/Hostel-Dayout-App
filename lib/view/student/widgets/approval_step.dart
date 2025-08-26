import 'package:flutter/material.dart';

enum StepStatus { pending, completed, rejected }

class ApprovalStep {
  final String title;
  final StepStatus status;

  ApprovalStep({required this.title, this.status = StepStatus.pending});
}

class ApprovalTimeline extends StatelessWidget {
  final List<ApprovalStep> steps;

  const ApprovalTimeline({super.key, required this.steps});

  @override
  Widget build(BuildContext context) {
    // find last completed/rejected index
    // final lastMarkedIndex = steps.lastIndexWhere(
    //   (step) => step.status != StepStatus.pending,
    // );

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      width: double.infinity,
      child: Column(
        children: [
          // ================== Timeline ==================
          Stack(
            alignment: Alignment.center,
            children: [
              // Background Line with Gradient
              // Container(
              //   height: 4,
              //   margin: const EdgeInsets.symmetric(horizontal: 16),
              //   decoration: BoxDecoration(
              //     gradient: LinearGradient(
              //       begin: Alignment.centerLeft,
              //       end: Alignment.centerRight,
              //       colors: [
              //         // left side
              //         if (lastMarkedIndex == -1)
              //           Colors.grey.shade400
              //         else
              //           (steps[lastMarkedIndex].status == StepStatus.rejected
              //               ? Colors.red
              //               : Colors.green),

              //         // middle
              //         if (lastMarkedIndex == -1)
              //           Colors.grey.shade400
              //         else
              //           (steps[lastMarkedIndex].status == StepStatus.rejected
              //               ? Colors.red
              //               : Colors.green),

              //         // right side
              //         Colors.grey.shade400,
              //       ],
              //       stops: [
              //         if (lastMarkedIndex == -1)
              //           0.0
              //         else
              //           (lastMarkedIndex + 1) / steps.length,

              //         if (lastMarkedIndex == -1)
              //           0.5
              //         else
              //           (lastMarkedIndex + 1.01) / steps.length,

              //         1.0,
              //       ],
              //     ),
              //   ),
              // ),

              // Dots
              Row(
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (int i = 0; i < steps.length; i++) ...[
                    Expanded(
                      child: Align(
                        alignment: Alignment.center,
                        child: Container(
                          width: 34,
                          height: 34,
                          decoration: BoxDecoration(
                            color: steps[i].status == StepStatus.completed
                                ? Colors.green
                                : steps[i].status == StepStatus.rejected
                                ? Colors.red
                                : Colors.grey.shade400,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            steps[i].status == StepStatus.completed
                                ? Icons.check
                                : steps[i].status == StepStatus.rejected
                                ? Icons.close
                                : Icons.circle,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),

          const SizedBox(height: 12),

          // ================== Labels ==================
          Row(
            children: [
              for (int i = 0; i < steps.length; i++) ...[
                Expanded(
                  child: Text(
                    steps[i].title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      color: steps[i].status == StepStatus.rejected
                          ? Colors.red
                          : Colors.black87,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
