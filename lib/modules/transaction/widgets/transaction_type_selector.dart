
import 'package:flutter/material.dart';
import 'package:gelir_gider_app/modules/transaction/controllers/transaction_controller.dart';
import 'package:gelir_gider_app/themes/app_colors.dart';
import  'package:get/get.dart';

class TransactionTypeSelector extends GetView<TransactionController> {
  const TransactionTypeSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => SegmentedButton<String>(
        segments: const [
          ButtonSegment<String>(
            value: 'expense',
            label: Text("Gider"),
            icon: Icon(Icons.remove_circle_outline),
          ),
          ButtonSegment<String>(
            value: 'income',
            label: Text("Gelir"),
            icon: Icon(Icons.add_circle_outline),
          ),
        ],

        selected: {
          controller.transactionType.value,
        },

        onSelectionChanged: (selection) {
          controller.transactionType.value = selection.first;
        },

        style: ButtonStyle(
          backgroundColor: WidgetStateColor.resolveWith(
            (states) {
              if (states.contains(WidgetState.selected)) {
                return AppColors.primaryDark;
              }

              return Colors.transparent;
            },
          ),
        ),
      ),
    );
  }
}

