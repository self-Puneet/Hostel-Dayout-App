import 'package:flutter/material.dart';
import 'package:hostel_mgmt/core/theme/app_theme.dart';
import 'package:hostel_mgmt/models/expandable_stat_card_data.dart';

class ExpandableStatCard extends StatefulWidget {
  final StatCardData data;

  const ExpandableStatCard({super.key, required this.data});

  @override
  State<ExpandableStatCard> createState() => _ExpandableStatCardState();
}

class _ExpandableStatCardState extends State<ExpandableStatCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final data = widget.data;
    final hasBreakdown = data.breakdown.isNotEmpty;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      child: Material(
        color: Colors.white,
        elevation: 0,
        borderRadius: BorderRadius.circular(18),
        child: InkWell(
          splashColor: Colors.transparent,

          borderRadius: BorderRadius.circular(20),
          onTap: data.onTap, // Only your event now!
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Top row: dot and dropdown chevron
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 18,
                      height: 18,
                      decoration: BoxDecoration(
                        color: data.dotColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    if (hasBreakdown)
                      GestureDetector(
                        onTap: () {
                          setState(() => _expanded = !_expanded);
                        },
                        child: Container(
                          width: 18,
                          height: 18,
                          decoration: BoxDecoration(
                            color: Color.fromRGBO(107, 107, 107, 0.34),
                            shape: BoxShape.circle,
                          ),
                          child: Transform.rotate(
                            angle: _expanded ? 1.5708 : 0,
                            child: Icon(
                              Icons.keyboard_arrow_right_rounded,
                              color: Colors.black,
                              size: 18,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 19),
                // Always show value/label at the top
                if (!(hasBreakdown && _expanded))
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${data.value}",
                            style: textTheme.h1.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            data.valueLabel,
                            style: textTheme.h6.copyWith(
                              color: const Color.fromRGBO(79, 79, 79, 1),
                            ),
                          ),
                        ],
                      ),
                      Container(),
                    ],
                  ),
                if (hasBreakdown && _expanded)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            Text(
                              '${data.breakdown.first['value']}',
                              style: textTheme.h1.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              '${data.breakdown.first['label']}',
                              style: textTheme.h6.copyWith(
                                color: const Color.fromRGBO(79, 79, 79, 1),
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (data.breakdown.length > 1)
                        Expanded(
                          child: Column(
                            children: [
                              Text(
                                '${data.breakdown.last['value']}',
                                style: textTheme.h1.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 3),
                              Text(
                                '${data.breakdown.last['label']}',
                                style: textTheme.h6.copyWith(
                                  color: const Color.fromRGBO(79, 79, 79, 1),
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
