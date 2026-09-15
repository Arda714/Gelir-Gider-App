import 'package:flutter/material.dart';
import 'package:gelir_gider_app/core/base_controller.dart';
import 'package:gelir_gider_app/models/app_category.dart';
import 'package:gelir_gider_app/models/app_transaction.dart';
import 'package:gelir_gider_app/modules/dashboard/dashboard_controller.dart';
import 'package:gelir_gider_app/repositories/category_repository.dart';
import 'package:gelir_gider_app/repositories/transaction_repository.dart';
import 'package:get/get.dart';

class TransactionController extends BaseController {
  final CategoryRepository _categoryRepository =
      Get.find<CategoryRepository>();

  final TransactionRepository _transactionRepository =
      Get.find<TransactionRepository>();

  final categories = <AppCategory>[].obs;

  final selectedCategoryId = "".obs;

  final transactionType = 'expense'.obs;

  final formKey = GlobalKey<FormState>();

  final amount = 0.0.obs;

  final description = "".obs;

  final date = DateTime.now().obs;

  @override
  void onInit() {
    super.onInit();

    loadCategories();

    ever(transactionType, (callback) {
      getFirstCategory();
    });
  }

  Future createTransaction() async {
    // Form geçerli değilse devam etme
    if (!formKey.currentState!.validate()) {
      return null;
    }

    setLoading(true);

    try {
      final transaction = Transaction(
        id: '',
        amount: amount.value,
        description: description.value,
        type: transactionType.value,
        date: date.value,
        categoryId: selectedCategoryId.value,
        userId: '',
      );

      // Gönderilen veriyi terminalde görmek için
      print(
        'GONDERILEN VERI: ${transaction.toJson()}',
      );

      final result =
          await _transactionRepository.createTransaction(
        transaction,
      );

      // İşlem başarıyla oluşturulduysa
      if (result.id != null) {
        // Dashboard verilerini yenile
        await Get.find<DashboardController>()
            .refreshDashboard();

        // Transaction sayfasını kapat
        Get.back();

        // BAŞARILI MESAJI - YEŞİL
        showSuccessSnackbar(
          message: 'İşlem başarıyla eklendi',
        );
      }
    } catch (e, stackTrace) {
      // Hata detaylarını terminalde göster
      print(
        'HATA DETAYI: $e',
      );

      print(
        'STACK TRACE: $stackTrace',
      );

      // HATA MESAJI - KIRMIZI
      showErrorSnackbar(
        message: 'İşlem eklenirken bir hata oluştu',
      );
    } finally {
      setLoading(false);
    }
  }

  Future<void> loadCategories() async {
    setLoading(true);

    try {
      final result =
          await _categoryRepository.getCategories();

      categories.value = result;

      getFirstCategory();
    } catch (e) {
      showErrorSnackbar(
        message: e.toString(),
      );
    } finally {
      setLoading(false);
    }
  }

  void getFirstCategory() {
    final filteredCategories = categories
        .where(
          (category) =>
              category.type == transactionType.value,
        )
        .toList();

    if (filteredCategories.isNotEmpty) {
      selectedCategoryId.value =
          filteredCategories.first.id!;
    } else {
      selectedCategoryId.value = '';
    }
  }
}