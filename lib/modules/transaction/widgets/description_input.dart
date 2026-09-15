import 'package:flutter/material.dart';
import 'package:gelir_gider_app/modules/transaction/controllers/transaction_controller.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class DescriptionInput extends GetView<TransactionController> {
  const DescriptionInput({super.key});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'Açıklama',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.description_outlined),
        
      ),
      maxLines: 2,
      onChanged: (value) {
        controller.description.value = value;

      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Bir açıklama giriniz";
        }
        
      },
      
    );
  }
}