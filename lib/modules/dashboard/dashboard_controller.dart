import 'package:flutter/material.dart';
import 'package:gelir_gider_app/core/base_controller.dart';
import 'package:gelir_gider_app/models/app_category.dart';
import 'package:gelir_gider_app/models/app_transaction.dart';
import 'package:gelir_gider_app/repositories/category_repository.dart';
import 'package:gelir_gider_app/repositories/transaction_repository.dart';
import 'package:get/get.dart';

class DashboardController extends BaseController {
  late final TransactionRepository _transactionRepository;
  late final CategoryRepository _categoryRepository;

  final myTransactions = <Transaction>[].obs;
  final myCategories = <AppCategory>[].obs;

  final aylikGelir = 0.0.obs;
  final aylikGider = 0.0.obs;

  @override
  void onInit() async {
    super.onInit();

    _transactionRepository = Get.find<TransactionRepository>();
    _categoryRepository = Get.find<CategoryRepository>();

    await getDashboardData();
  }

  Future<void> getDashboardData() async {
    try {
      setLoading(true);

      final transactions =
          await _transactionRepository.getTransactions();

      final categories =
          await _categoryRepository.getCategories();

      myTransactions.value = transactions;
      myCategories.value = categories;

      aylikOzet();
    } catch (e) {
      debugPrint("Dashboard hata: $e");
      showErrorSnackbar(
        message: "Veriler getirilirken hata oluştu",
      );
    } finally {
      setLoading(false);
    }
  }

  Future<void> refreshDashboard() async {
    await getDashboardData();
  }

  AppCategory? getCategory(String? categoryId) {
    if (categoryId == null) {
      return null;
    }

    try {
      return myCategories.firstWhere(
        (category) => category.id == categoryId,
      );
    } catch (e) {
      return null;
    }
  }

  void aylikOzet() {
    var simdikiTarih = DateTime.now();
    var oanKiYil = simdikiTarih.year;
    var oankiAy = simdikiTarih.month;

    aylikGelir.value = 0;
    aylikGider.value = 0;

    if (myTransactions.isNotEmpty) {
      var filteredTransaction = myTransactions.where(
        (transaction) =>
            transaction.date != null &&
            transaction.date!.year == oanKiYil &&
            transaction.date!.month == oankiAy,
      ).toList();

      for (var tr in filteredTransaction) {
        if (tr.type == 'income') {
          aylikGelir.value += tr.amount ?? 0;
        } else {
          aylikGider.value += tr.amount ?? 0;
        }
      }
    }

    debugPrint(
      "aylik gelir ${aylikGelir.value} gider: ${aylikGider.value}",
    );
  }

  Future<void> deleteTransactions(String id) async {
    try {
      final transactionResult =
          await _transactionRepository.deleteTransaction(id);

      if (transactionResult) {
        myTransactions.removeWhere(
          (element) => element.id == id,
        );

        aylikOzet();

        showSuccessSnackbar(
          message: "Transaction silindi",
        );
      } else {
        showErrorSnackbar(
          message: "Transaction silinemedi",
        );
      }
    } catch (e) {
      showErrorSnackbar(
        message: "Transaction silinemedi $e",
      );
    }
  }
}