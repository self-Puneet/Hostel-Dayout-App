import 'package:flutter/material.dart';
import 'package:hostel_dayout_app/core/routes/app_router.dart';
import 'package:hostel_dayout_app/core/theme/app_theme.dart';
import 'package:hostel_dayout_app/injection.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'core/enums/enum.dart';
import 'requests/data/models/model.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(RequestStatusAdapter());
  Hive.registerAdapter(RequestTypeAdapter());
  Hive.registerAdapter(TimelineActorAdapter());
  Hive.registerAdapter(RequestModelAdapter());
  Hive.registerAdapter(ParentInfoModelAdapter());
  Hive.registerAdapter(StudentInfoModelAdapter());
  Hive.registerAdapter(TimelineEventModelAdapter());
  // await Hive.deleteBoxFromDisk('requests');
  await Hive.openBox<RequestModel>('requests');
  await init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ShadTheme(
      data: ShadThemeData(
        brightness: Brightness.light,
        colorScheme: const ShadZincColorScheme.light(),
      ),
      child: MaterialApp.router(
        title: 'Hostel Dayout App',
        debugShowCheckedModeBanner: false,
        routerConfig: AppRouter.router,
        theme: AppTheme.lightTheme,
      ),
    );
  }
}
