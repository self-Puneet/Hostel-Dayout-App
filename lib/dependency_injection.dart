// core/dependencies.dart
import 'package:get/get.dart';
import 'core/network_info.dart';

Future<void> initDependencies() async {
  await Get.putAsync<NetworkProvider>(() async => NetworkProvider().init());
}
