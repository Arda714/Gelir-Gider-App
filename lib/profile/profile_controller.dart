
import 'package:flutter/material.dart';
import 'package:gelir_gider_app/core/base_controller.dart';
import 'package:gelir_gider_app/models/app_user.dart';
import 'package:gelir_gider_app/services/auth_service.dart';
import 'package:get/get.dart';

class ProfileController extends BaseController {
  final AuthService _authService = Get.find<AuthService>();

  Rx<AppUser?> get user => _authService.currentUser;

  Future<void> updateProfile({
    required String firstName,
    required String lastName,
  }) async {
    if (firstName.trim().isEmpty || lastName.trim().isEmpty) {
      Get.snackbar(
        'Hata',
        'Ad ve soyad boş bırakılamaz',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    try {
      setLoading(true);

      final result = await _authService.updateProfile(
        firstName: firstName.trim(),
        lastName: lastName.trim(),
      );

      if (result) {
        Get.snackbar(
          'Başarılı',
          'Profil bilgileriniz güncellendi',
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        Get.snackbar(
          'Hata',
          'Profil güncellenemedi',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      debugPrint('Profil güncelleme hatası: $e');

      Get.snackbar(
        'Hata',
        'Profil güncellenirken bir hata oluştu',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      setLoading(false);
    }
  }
}