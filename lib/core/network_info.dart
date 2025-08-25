import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';

class NetworkProvider extends GetxService {
  final Connectivity _connectivity = Connectivity();
  final RxBool isConnected = true.obs;
  Future<NetworkProvider> init() async {
    // Initial connectivity → just set value
    final initialResults = await _connectivity.checkConnectivity();
    _handleStatus(initialResults, showSnackbar: false);

    // Later changes → show snackbar
    _connectivity.onConnectivityChanged.listen((results) {
      print("Network status changed: $results");
      _handleStatus(results, showSnackbar: true);
    });

    return this;
  }

  void _handleStatus(
    List<ConnectivityResult> results, {
    bool showSnackbar = true,
  }) {
    final newStatus = results.any((r) => r != ConnectivityResult.none);
    isConnected.value = newStatus;

    if (!newStatus && showSnackbar) {}
  }
}
