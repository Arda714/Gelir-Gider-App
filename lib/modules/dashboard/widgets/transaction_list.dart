import 'package:flutter/material.dart';
import 'package:gelir_gider_app/modules/dashboard/dashboard_controller.dart';
import 'package:gelir_gider_app/themes/app_colors.dart';
import 'package:gelir_gider_app/utils/icon_helper.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class TransactionList extends GetView<DashboardController> {
  const TransactionList({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.myTransactions.isEmpty) {
        return Card(
          margin: const EdgeInsets.all(16),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.receipt_long_outlined,
                    size: 48,
                    color: Theme.of(context).brightness ==
                            Brightness.dark
                        ? AppColors.incomeTeal.withAlpha(128)
                        : AppColors.tiffanyAccent.withAlpha(128),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "Henüz kayıtlı bir transaction yok",
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.copyWith(
                          color:
                              Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? AppColors.darkTextPrimary
                                  : AppColors.textPrimary,
                        ),
                  ),
                ],
              ),
            ),
          ),
        );
      }

      return Card(
        shape: const BeveledRectangleBorder(),
        child: ListView.separated(
          itemCount: controller.myTransactions.length,

          // Liste artık aşağı-yukarı kaydırılabilir
          physics: const AlwaysScrollableScrollPhysics(),

          separatorBuilder: (context, index) {
            return const Divider(height: 1);
          },

          itemBuilder: (context, index) {
            final oankiTransaction =
                controller.myTransactions[index];

            final category = controller.getCategory(
              oankiTransaction.categoryId,
            );

            final isIncome =
                oankiTransaction.type == 'income';

            final transactionColor =
                Theme.of(context).brightness == Brightness.dark
                    ? (isIncome
                        ? AppColors.darkIncome
                        : AppColors.darkExpense)
                    : (isIncome
                        ? AppColors.income
                        : AppColors.expense);

            return Dismissible(
              key: ValueKey(oankiTransaction.id),
              direction: DismissDirection.endToStart,

              onDismissed: (direction) {
                if (oankiTransaction.id != null) {
                  controller.deleteTransactions(
                    oankiTransaction.id!,
                  );
                }
              },

              background: Container(
                color: Colors.red,
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                ),
                child: const Icon(
                  Icons.delete,
                  color: Colors.white,
                ),
              ),

              child: ListTile(
                leading: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: transactionColor.withAlpha(25),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    category != null
                        ? getCategoryIcon(
                            iconName: category.icon ?? '',
                            isSystem:
                                category.isSystem ?? true,
                            type: category.type ?? '',
                          )
                        : Icons.category_outlined,
                    color: transactionColor,
                  ),
                ),

                title: Text(
                  category?.name ??
                      'Kategori bulunamadı',
                ),

                subtitle: Text(
                  oankiTransaction.description ?? '',
                ),

                trailing: Column(
                  mainAxisAlignment:
                      MainAxisAlignment.center,
                  crossAxisAlignment:
                      CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${isIncome ? '+' : '-'} ${NumberFormat.currency(
                        symbol: '₺',
                        decimalDigits: 2,
                      ).format(
                        oankiTransaction.amount ?? 0,
                      )}',
                      style: TextStyle(
                        color: transactionColor,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    Text(
                      oankiTransaction.date != null
                          ? DateFormat('dd/MM/yyyy')
                              .format(
                              oankiTransaction.date!,
                            )
                          : '',
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(
                            color:
                                Theme.of(context)
                                            .brightness ==
                                        Brightness.dark
                                    ? AppColors
                                        .darkTextPrimary
                                    : AppColors
                                        .textPrimary,
                          ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      );
    });
  }
}