import 'package:flutter/material.dart';
import 'package:hostel_mgmt/core/routes/app_router.dart';
import 'package:hostel_mgmt/core/theme/app_theme.dart';
import 'package:hostel_mgmt/login/login_state.dart';
import 'package:provider/provider.dart';
import 'dependency_injection.dart';
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
