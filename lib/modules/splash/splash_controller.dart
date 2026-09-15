import 'package:gelir_gider_app/core/base_controller.dart';
import 'package:gelir_gider_app/routes/app_pages.dart';
import 'package:gelir_gider_app/services/api_service.dart';
import 'package:gelir_gider_app/services/auth_service.dart';
import 'package:gelir_gider_app/services/storage_service.dart';
import 'package:get/instance_manager.dart';
import 'package:get/route_manager.dart';
import 'package:get/state_manager.dart';

class SplashController extends BaseController {
  @override
  void onReady() async {
    super.onReady();

    await waitForServices();
    await checkTokenAndRedirect();
  }

  Future<void> waitForServices() async {
    while (
      !Get.isRegistered<StorageService>() ||
      !Get.isRegistered<ApiService>() ||
      !Get.isRegistered<AuthService>()
    ) {
      await Future.delayed(
        const Duration(seconds: 1),
      );
    }
  }

  Future<void> checkTokenAndRedirect() async {
    final authService = Get.find<AuthService>();

    final isAuthenticated = await authService.isAuthenticated();

    if (isAuthenticated) {
      Get.offAllNamed(AppRoutes.HOME);
    } else {
      Get.offAllNamed(AppRoutes.LOGIN);
    }
  }
}