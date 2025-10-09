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
    this.radius = 3,
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
            splashFactory: NoSplash.splashFactory,

            // 👇 Make overlay transparent
            overlayColor: WidgetStateProperty.all(Colors.transparent),

            controller: controller,
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            indicator: const BoxDecoration(),
            dividerColor: Colors.transparent,
            labelPadding: labelPadding,
            padding: EdgeInsets.only(bottom: 4),
            splashBorderRadius: BorderRadius.circular(radius),
            tabs: labels.map((t) {
              final isSelected = controller.index == labels.indexOf(t);
              return Stack(
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 4,
                      vertical: 0,
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 15,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE9E9E9),
                      // color: Colors.amber,
                      borderRadius: BorderRadius.circular(radius),
                    ),
                    child: Center(
                      child: Text(
                        t,
                        style: textTheme.h6.copyWith(
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.w500,
                          color: isSelected
                              ? Colors.black
                              : unselectedTextColor,
                        ),
                      ),
                    ),
                  ),

                  if (isSelected)
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(5),
                            bottom: Radius.circular(0),
                          ),
                        ),
                      ),
                    ),
                ],
              );
            }).toList(),
          ),
        );
      },
    );
  }
}
