// core/dependencies.dart
import 'package:get/get.dart';
import 'core/network_info.dart';
import 'core/rumtime_state/login_session.dart';
import 'core/enums/enum.dart';

Future<void> initDependencies() async {
  await Get.putAsync<NetworkProvider>(() async => NetworkProvider().init());

  // Register LoginSession globally, loading from prefs if available
  final session = await LoginSession.loadFromPrefs();
  await Get.putAsync<LoginSession>(
    () async =>
        session ??
        LoginSession(
          token: "",
          username: "",
          role: TimelineActor.student,
        ), // default empty session
  );
}
