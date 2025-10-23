import 'package:get/get.dart';
import 'core/network_info.dart';
import 'core/rumtime_state/login_session.dart';
import 'core/enums/enum.dart';

Future<void> initDependencies() async {
  await Get.putAsync<NetworkProvider>(() async => NetworkProvider().init());

  // Register LoginSession globally, loading from prefs if available
  final loader = LoginSession(
    token: "", username: "", role: TimelineActor.student,
  );
  final session = await loader.loadFromPrefs();
  print("Session loaded from prefs: $session");
  await Get.putAsync<LoginSession>(
    () async =>
      session ??
      loader, // use the loader instance as default
  );
}
