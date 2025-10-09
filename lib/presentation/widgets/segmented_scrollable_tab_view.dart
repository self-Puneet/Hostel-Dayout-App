// // lib/presentation/widgets/segmented_button.dart
// import 'package:flutter/material.dart';
// import 'package:hostel_mgmt/core/theme/app_theme.dart';

// class SegmentedTabs extends StatelessWidget {
//   final TabController controller;
//   final List<String> labels;

//   final double radius;
//   final EdgeInsetsGeometry labelPadding;
//   final Color barBackground;
//   final Color selectedPillColor;
//   final Color selectedTextColor;
//   final Color unselectedTextColor;

//   const SegmentedTabs({
//     super.key,
//     required this.controller,
//     required this.labels,
//     this.radius = 999,
//     this.labelPadding = const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
//     this.barBackground = const Color(0x14000000),
//     this.selectedPillColor = Colors.black,
//     this.selectedTextColor = Colors.white,
//     this.unselectedTextColor = Colors.black87,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final textTheme = Theme.of(context).textTheme;
//     return Container(
//       padding: const EdgeInsets.all(4),
//       decoration: BoxDecoration(
//         color: barBackground,
//         borderRadius: BorderRadius.circular(radius),
//       ),
//       child: TabBar(
//         controller: controller,
//         isScrollable: true,
//         indicatorSize: TabBarIndicatorSize.label,
//         indicator: BoxDecoration(
//           color: selectedPillColor,
//           borderRadius: BorderRadius.circular(radius),
//         ),

//         // indicatorPadding: const EdgeInsets.symmetric(horizontal: 10),
//         dividerColor: Colors.transparent,
//         labelColor: selectedTextColor,
//         unselectedLabelColor: unselectedTextColor,
//         labelPadding: labelPadding,
//         padding: EdgeInsets.zero,
//         splashBorderRadius: BorderRadius.circular(radius),
//         tabs: labels.map((t) {
//           return Padding(
//             padding: const EdgeInsets.symmetric(
//               horizontal: 10,
//               vertical: 10,
//             ), // horizontal only
//             child: Align(
//               alignment: Alignment.center,
//               heightFactor: 1,
//               child: Text(
//                 t,
//                 style: controller.index == labels.indexOf(t)
//                     ? textTheme.h7.copyWith(
//                         fontWeight: FontWeight.bold,
//                         color: selectedTextColor,
//                       )
//                     : textTheme.h7.w500,
//               ),
//             ),
//           );
//         }).toList(),
//         labelStyle: textTheme.h7.copyWith(
//           fontWeight: FontWeight.bold,a
//           color: selectedTextColor,
//         ),
//         unselectedLabelStyle: textTheme.h7.w500,
//       ),
//     );
//   }
// }

// lib/presentation/widgets/segmented_button.dart
import 'package:flutter/material.dart';
import 'package:hostel_mgmt/core/theme/app_theme.dart';

class SegmentedTabs extends StatelessWidget {
  final TabController controller;
  final List<String> labels;

  final double radius;
  final EdgeInsetsGeometry labelPadding;
  final Color barBackground;
  final Color selectedPillColor;
  final Color selectedTextColor;
  final Color unselectedTextColor;

  const SegmentedTabs({
    super.key,
    required this.controller,
    required this.labels,
    this.radius = 999,
    this.labelPadding = const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
    this.barBackground = const Color(0x14000000),
    this.selectedPillColor = Colors.black,
    this.selectedTextColor = Colors.white,
    this.unselectedTextColor = Colors.black87,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return AnimatedBuilder(
      animation: controller, // listen to controller index changes
      builder: (context, _) {
        return Container(
          padding: const EdgeInsets.only(top: 4, right: 0, bottom: 4, left: 0),
          child: TabBar(
            controller: controller,
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            indicator: const BoxDecoration(), // disable default indicator
            dividerColor: Colors.transparent,
            labelPadding: labelPadding,
            padding: EdgeInsets.zero,
            splashBorderRadius: BorderRadius.circular(radius),
            tabs: labels.map((t) {
              final isSelected = controller.index == labels.indexOf(t);
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 15,
                ),
                decoration: BoxDecoration(
                  color: isSelected ? selectedPillColor : Colors.grey.shade400,
                  borderRadius: BorderRadius.circular(10),
                  // border: Border.all(color: Colors.black, width: 1.5),
                ),
                child: Text(
                  t,
                  style: textTheme.h7.copyWith(
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                    color: isSelected ? selectedTextColor : unselectedTextColor,
                  ),
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }
}
