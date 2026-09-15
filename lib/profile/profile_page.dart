import 'package:flutter/material.dart';
import 'package:gelir_gider_app/services/auth_service.dart';
import 'package:gelir_gider_app/services/theme_service.dart';
import 'package:get/get.dart';
import 'package:gelir_gider_app/routes/app_pages.dart';

import 'profile_controller.dart';

class ProfilePage extends GetView<ProfileController> {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthService authService = Get.find<AuthService>();

    return Scaffold(
      body: Obx(
        () => SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(
                  controller.user.value?.profilePhoto ?? '',
                ),
              ),

              const SizedBox(height: 24),

              InfoCard(
                title: 'Adı',
                value: controller.user.value?.firstName ?? '',
                onEdit: () {
                  _showEditProfileDialog(
                    context,
                    firstName: true,
                  );
                },
              ),

              InfoCard(
                title: 'Soyadı',
                value: controller.user.value?.lastName ?? '',
                onEdit: () {
                  _showEditProfileDialog(
                    context,
                    firstName: false,
                  );
                },
              ),

              InfoCard(
                title: 'Mail',
                value: controller.user.value?.email ?? '',
              ),

              const SizedBox(height: 10),

              SettingsCard(),

              const SizedBox(height: 10),

              // Çıkış Yap
              Card(
                child: ListTile(
                  leading: const Icon(
                    Icons.logout,
                    color: Colors.red,
                  ),
                  title: const Text(
                    'Çıkış Yap',
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  onTap: () async {
                    final result = await Get.dialog<bool>(
                      AlertDialog(
                        title: const Text('Çıkış Yap'),
                        content: const Text(
                          'Çıkış yapmak istediğinizden emin misiniz?',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Get.back(result: false);
                            },
                            child: const Text('İptal'),
                          ),
                          TextButton(
                            onPressed: () {
                              Get.back(result: true);
                            },
                            child: const Text(
                              'Çıkış Yap',
                              style: TextStyle(
                                color: Colors.red,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );

                    if (result == true) {
                      await authService.signOut();

                      // Çıkış yaptıktan sonra Login sayfasına dön
                      Get.offAllNamed(AppRoutes.LOGIN);
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showEditProfileDialog(
    BuildContext context, {
    required bool firstName,
  }) {
    final currentValue = firstName
        ? controller.user.value?.firstName ?? ''
        : controller.user.value?.lastName ?? '';

    final TextEditingController textController =
        TextEditingController(
      text: currentValue,
    );

    Get.dialog(
      AlertDialog(
        title: Text(
          firstName ? 'Adını Düzenle' : 'Soyadını Düzenle',
        ),
        content: TextField(
          controller: textController,
          autofocus: true,
          textCapitalization: TextCapitalization.words,
          decoration: InputDecoration(
            labelText: firstName ? 'Ad' : 'Soyad',
            border: const OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
            },
            child: const Text('İptal'),
          ),
          Obx(
            () => TextButton(
              onPressed: controller.isLoading
                  ? null
                  : () async {
                      final yeniDeger =
                          textController.text.trim();

                      if (yeniDeger.isEmpty) {
                        Get.snackbar(
                          'Hata',
                          'Alan boş bırakılamaz',
                          snackPosition:
                              SnackPosition.BOTTOM,
                        );
                        return;
                      }

                      final mevcutAd =
                          controller.user.value?.firstName ?? '';

                      final mevcutSoyad =
                          controller.user.value?.lastName ?? '';

                      await controller.updateProfile(
                        firstName: firstName
                            ? yeniDeger
                            : mevcutAd,
                        lastName: firstName
                            ? mevcutSoyad
                            : yeniDeger,
                      );

                      if (!controller.isLoading) {
                        Get.back();
                      }
                    },
              child: controller.isLoading
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                      ),
                    )
                  : const Text('Kaydet'),
            ),
          ),
        ],
      ),
    );
  }
}

class InfoCard extends StatelessWidget {
  final String title;
  final String value;
  final VoidCallback? onEdit;

  const InfoCard({
    super.key,
    required this.title,
    required this.value,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        trailing: onEdit != null
            ? IconButton(
                onPressed: onEdit,
                icon: const Icon(Icons.edit),
              )
            : null,
      ),
    );
  }
}

class SettingsCard extends StatelessWidget {
  SettingsCard({super.key});

  final ThemeService themeService =
      Get.find<ThemeService>();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: const Icon(Icons.brightness_6),
        title: const Text('Tema'),
        trailing: Obx(
          () => Switch(
            value: themeService.isDarkMode,
            onChanged: (_) {
              themeService.toggleTheme();
            },
          ),
        ),
      ),
    );
  }
}