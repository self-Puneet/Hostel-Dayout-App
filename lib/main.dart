import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hostel_dayout_app/features/auth/presentation/bloc/auth_events.dart';
// import 'package:hostel_dayout_app/features/auth/presentation/bloc/auth_state.dart';
import 'package:hostel_dayout_app/injection.dart' as di;
import 'package:hostel_dayout_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:hostel_dayout_app/features/auth/presentation/pages/login_page.dart';
import 'package:hostel_dayout_app/features/requests/presentation/bloc/request_bloc.dart';

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
        BlocProvider<LoginBloc>(
          create: (_) => di.sl<LoginBloc>()..add(AutoLoginRequested()),
        ),
        BlocProvider<RequestListBloc>(create: (_) => di.sl<RequestListBloc>()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Hostel Dayout App',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: const LoginPage(), // Start with login
      ),
    );
  }
}
