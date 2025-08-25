// widgets/network_status_widget.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hostel_mgmt/core/helpers/app_snackbar.dart';
import 'package:hostel_mgmt/core/enums/ui_eums/snackbar_type.dart';
import '../network_info.dart';
import 'no_internet_screen.dart';

class NetworkStatusWidget extends StatelessWidget {
  final Widget connectedChild;
  final Widget? disconnectedChild;

  const NetworkStatusWidget({
    super.key,
    required this.connectedChild,
    this.disconnectedChild,
  });

  @override
  Widget build(BuildContext context) {
    final network = Get.find<NetworkProvider>();

    return Obx(() {
      final isConnected = network.isConnected.value;

      // Auto show snackbar when disconnected
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!isConnected) {
          AppSnackBar.show(
            context,
            message: "No internet connection",
            type: AppSnackBarType.error,
            icon: Icons.wifi_off,
            // duration: const Duration(days: 1),
          );
        }
      });

      if (isConnected) {
        // remove the snackbar
        AppSnackBar.dismiss(context);
        return ListView(children: [connectedChild]);
      } else {
        return disconnectedChild ?? const NoInternetScreen();
      }
    });
  }
}
