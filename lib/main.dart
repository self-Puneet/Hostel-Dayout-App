import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:hostel_mgmt/core/helpers/app_refreasher_widget.dart';
// import 'package:hostel_mgmt/core/helpers/network_status_widget.dart';
import 'package:hostel_mgmt/core/theme/app_theme.dart';
import 'package:hostel_mgmt/login/login_layout.dart';
import 'package:hostel_mgmt/login/login_state.dart';
import 'package:provider/provider.dart';
import 'dependency_injection.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDependencies();

  runApp(
    ChangeNotifierProvider(create: (_) => LoginState(), child: const MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(theme: AppTheme.lightTheme, home: LoginLayout());
  }
}

// RefreshIndicator(
//         onRefresh: () async {
//           // wait for 2 seconds
//           await Future.delayed(const Duration(seconds: 1));
//         },
//         child: NetworkStatusWidget(connectedChild: LoginLayout()),
//       ),
