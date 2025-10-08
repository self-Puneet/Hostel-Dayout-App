import 'package:flutter/material.dart';
import 'package:hostel_mgmt/core/theme/app_theme.dart';
import 'package:hostel_mgmt/models/expandable_stat_card_data.dart';

class ExpandableStatCard extends StatefulWidget {
  final ExpandableStatCardData data;

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

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha((0.07 * 225).toInt()),
            blurRadius: 7,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top row: icon + value
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: data.iconBgColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                width: 44,
                height: 44,
                child: Icon(data.icon, color: data.iconColor, size: 28),
              ),
              Text(
                "${data.value}",
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // valueLabel with inline unfold button at the right
          Row(
            children: [
              Expanded(
                child: Text(
                  data.valueLabel,
                  style: textTheme.h5.copyWith(
                    color: Colors.black.withAlpha((0.7 * 225).toInt()),
                  ),
                ),
              ),
              if (hasBreakdown)
                InkWell(
                  borderRadius: BorderRadius.circular(8),
                  onTap: () => setState(() => _expanded = !_expanded),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 4,
                      vertical: 2,
                    ),
                    child: AnimatedRotation(
                      turns: _expanded ? 0.5 : 0.0, // 180° when expanded
                      duration: const Duration(milliseconds: 180),
                      child: const Icon(
                        Icons.keyboard_arrow_down_rounded,
                        size: 22,
                        color: Colors.black54,
                      ),
                    ),
                  ),
                ),
            ],
          ),

          // Breakdown section (animated fold/unfold)
          if (hasBreakdown) ...[
            const SizedBox(height: 10),

            AnimatedCrossFade(
              firstChild: const SizedBox.shrink(),
              secondChild: Padding(
                padding: const EdgeInsets.only(
                  left: 2,
                  right: 2,
                  top: 8,
                  bottom: 2,
                ),
                child: Column(
                  children: [
                    const Divider(height: 0, thickness: 1),
                    ...data.breakdown.map(
                      (entry) => Container(
                        margin: const EdgeInsets.only(top: 7),
                        decoration: BoxDecoration(
                          color: Colors.grey.withAlpha((0.10 * 225).toInt()),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 13,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              entry['label'] ?? '',
                              style: textTheme.h6.w500,
                            ),
                            Text(
                              (entry['value'] ?? '').toString(),
                              style: textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              crossFadeState: _expanded
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              duration: const Duration(milliseconds: 200),
            ),
          ],
        ],
      ),
    );
  }
}
