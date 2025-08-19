import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hostel_dayout_app/core/theme/app_theme.dart';
// import 'package:hostel_dayout_app/features/auth/presentation/bloc/auth_events.dart';
import 'package:hostel_dayout_app/injection.dart' as di;
import 'package:hostel_dayout_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:hostel_dayout_app/features/requests/presentation/bloc/request_bloc.dart';

import 'package:hostel_dayout_app/core/routes/app_router.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await di.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<LoginBloc>(create: (_) => di.sl<LoginBloc>()),
        BlocProvider<RequestListBloc>(create: (_) => di.sl<RequestListBloc>()),
      ],
      child: ShadTheme(
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
      ),
    );
  }
}
