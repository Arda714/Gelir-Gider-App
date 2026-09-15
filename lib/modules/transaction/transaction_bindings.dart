
import 'package:get/instance_manager.dart';
import 'package:gelir_gider_app/modules/transaction/controllers/transaction_controller.dart';

class TransactionBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TransactionController>(() => TransactionController());
  }
}