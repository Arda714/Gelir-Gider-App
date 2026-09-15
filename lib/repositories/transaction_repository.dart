import 'package:gelir_gider_app/models/app_transaction.dart';
import 'package:gelir_gider_app/services/api_service.dart';
import 'package:get/get.dart';

class TransactionRepository extends GetxService {
  late final ApiService _apiService;

  @override
  void onInit() {
    super.onInit();

    _apiService = Get.find<ApiService>();
  }

  Future<List<Transaction>> getTransactions() async {
    final response = await _apiService.get(
      ApiConstants.transactions,
    );

    print(
      "GET TRANSACTIONS STATUS: ${response.statusCode}",
    );

    print(
      "GET TRANSACTIONS RESPONSE: ${response.data}",
    );

    if (response.statusCode == 200) {
      final gelenListe =
          response.data['transactions'] as List;

      return gelenListe
          .map(
            (transaction) =>
                Transaction.fromJson(transaction),
          )
          .toList();
    }

    throw Exception(
      "Transactionlar getirilirken hata oluştu: "
      "${response.statusCode} - ${response.data}",
    );
  }

  Future<Transaction> createTransaction(
    Transaction transaction,
  ) async {
    final response = await _apiService.post(
      ApiConstants.transactions,
      data: transaction.toJson(),
    );

    print(
      "CREATE TRANSACTION STATUS: ${response.statusCode}",
    );

    print(
      "CREATE TRANSACTION RESPONSE: ${response.data}",
    );

    if (response.statusCode == 201) {
      return Transaction.fromJson(
        response.data,
      );
    }

    throw Exception(
      "Transaction eklenirken hata oluştu: "
      "${response.statusCode} - ${response.data}",
    );
  }

  Future<bool> deleteTransaction(String id) async {
    final response = await _apiService.delete(
      '${ApiConstants.transactions}/$id',
    );

    print(
      "DELETE TRANSACTION STATUS: ${response.statusCode}",
    );

    print(
      "DELETE TRANSACTION RESPONSE: ${response.data}",
    );

    if (response.statusCode == 200) {
      return true;
    }

    throw Exception(
      "Transaction silinemedi: "
      "${response.statusCode} - ${response.data}",
    );
  }
}