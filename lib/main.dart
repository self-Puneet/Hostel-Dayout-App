import 'package:flutter/material.dart';
// import 'package:get/get.dart';
import 'package:hostel_mgmt/core/routes/app_router.dart';
// import 'package:hostel_mgmt/core/helpers/app_refreasher_widget.dart';
// import 'package:hostel_mgmt/core/helpers/network_status_widget.dart';
import 'package:hostel_mgmt/core/theme/app_theme.dart';
import 'package:hostel_mgmt/login/login_state.dart';
import 'package:provider/provider.dart';
import 'dependency_injection.dart';
// import 'dart:ui' show lerpDouble;
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDependencies();
  await dotenv.load();

  runApp(
    ChangeNotifierProvider(create: (_) => LoginState(), child: const MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final router = AppRouter.build();

    return MaterialApp.router(
      title: "Hostel Mgmt",
      theme: AppTheme.lightTheme,
      routerConfig: router, // 👈 just pass the GoRouter here
    );
  }
}

// return GetMaterialApp(theme: AppTheme.lightTheme, initialRoute: router.initialLocation, // ⬅️ initial route from your class
//       getPages: router.routes,
//       home: StudentLayout());
//   }

// import 'package:flutter/material.dart';

// class OneUISettingsDemo extends StatelessWidget {
//   const OneUISettingsDemo({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: DefaultTabController(
//         length: 2,
//         child: NestedScrollView(
//           headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
//             return <Widget>[
//               SliverAppBar(
//                 expandedHeight: 200.0,
//                 floating: true,
//                 pinned: true,
//                 backgroundColor: Colors.blue,
//                 flexibleSpace: FlexibleSpaceBar(
//                   // centerTitle: true,
//                   title: Text(
//                     "Collapsing Toolbar",
//                     style: TextStyle(color: Colors.black, fontSize: 16.0),
//                   ),
//                 ),
//               ),
//             ];
//           },
//           body: Center(child: Text("Sample text")),
//         ),
//       ),
//     );
//   }
// }

// class CollapsingAppBarDemo extends StatelessWidget {
//   const CollapsingAppBarDemo({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: DefaultTabController(
//         length: 2,
//         child: NestedScrollView(
//           headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
//             return <Widget>[
//               SliverAppBar(
//                 expandedHeight: 200.0,
//                 floating: false,
//                 pinned: true,
//                 backgroundColor: Colors.blue,
//                 flexibleSpace: LayoutBuilder(
//                   builder: (BuildContext context, BoxConstraints constraints) {
//                     // Expanded height goes from 200 → kToolbarHeight (56 by default)
//                     final collapsed =
//                         constraints.maxHeight <= kToolbarHeight + 10;
//                     // print(collapsed);

//                     return FlexibleSpaceBar(
//                       background: Container(color: Colors.amber),
//                       titlePadding: const EdgeInsets.symmetric(
//                         horizontal: 16,
//                         vertical: 8,
//                       ),
//                       title: AnimatedAlign(
//                         duration: const Duration(milliseconds: 200),
//                         alignment: collapsed
//                             ? Alignment
//                                   .centerLeft // 👈 Left after collapse
//                             : Alignment.center, // 👈 Center when expanded
//                         child: Text(
//                           "Collapsing Toolbar",
//                           style: TextStyle(
//                             // background: Colors.amber,
//                             color: Colors.white,
//                             fontSize: collapsed
//                                 ? 16.0
//                                 : 20.0, // optional: shrink font
//                             fontWeight: FontWeight.w600,
//                           ),
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//               ),
//             ];
//           },
//           body: const Center(child: Text("Sample text")),
//         ),
//       ),
//     );
//   }
// }

// class _OneUICollapsingTitle extends StatelessWidget {
//   final String title;
//   const _OneUICollapsingTitle({required this.title});

//   @override
//   Widget build(BuildContext context) {
//     const double maxH =
//         160; // expanded height (matches SliverAppBar.expandedHeight)
//     const double minH = kToolbarHeight; // collapsed height of the toolbar

//     return LayoutBuilder(
//       builder: (context, c) {
//         // t=1 expanded, t=0 collapsed
//         final t = ((c.maxHeight - minH) / (maxH - minH)).clamp(0.0, 1.0);

//         // animate: center (expanded) -> bottomLeft (collapsed)
//         final alignment = Alignment.lerp(
//           const Alignment(0, 0.2), // near center when expanded
//           const Alignment(-1, 1), // bottom-left when collapsed
//           1 - t,
//         )!;

//         // animate font size big -> small
//         final fontSize = lerpDouble(34, 20, 1 - t)!;

//         // add left/bottom padding as it collapses (keep clear of actions on the right)
//         final padding = EdgeInsets.lerp(
//           const EdgeInsets.symmetric(horizontal: 0),
//           const EdgeInsets.only(left: 16, right: 56, bottom: 12),
//           1 - t,
//         )!;

//         return Padding(
//           padding: padding,
//           child: Align(
//             alignment: alignment,
//             child: Text(
//               title,
//               maxLines: 1,
//               overflow: TextOverflow.ellipsis,
//               style: TextStyle(
//                 fontSize: fontSize,
//                 fontWeight: FontWeight.w800,
//                 color: const Color(0xFF00BCD4), // tweak to match your theme
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
