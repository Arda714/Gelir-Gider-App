import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // ---------------------------------------------------------------------------
  // GENEL FİNANSAL VE İŞLEM RENKLERİ
  // ---------------------------------------------------------------------------

  static const Color income = Color(0xFF00E676);
  static const Color incomeTeal = Color(0xFF00BFA5);
  static const Color expense = Color(0xFFFF5252);

  // ---------------------------------------------------------------------------
  // BAKİYE RENKLERİ
  // ---------------------------------------------------------------------------

  static const Color balance = Color(0xFF42A5F5);
  static const Color darkBalance = Color(0xFF90CAF9);

  // ---------------------------------------------------------------------------
  // GRADIENT RENKLERİ
  // ---------------------------------------------------------------------------

  static const List<Color> incomeGradient = [
    income,
    incomeTeal,
  ];

  static const List<Color> expenseGradient = [
    expense,
    Color(0xFFD50000),
  ];

  static const List<Color> balanceGradient = [
    balance,
    Color(0xFF1976D2),
  ];

  // ---------------------------------------------------------------------------
  // DARK TEMA GRADIENT RENKLERİ
  // ---------------------------------------------------------------------------

  static const List<Color> darkIncomeGradient = [
    Color(0xFF69F0AE),
    Color(0xFF00BFA5),
  ];

  static const List<Color> darkExpenseGradient = [
    Color(0xFFFF6B6B),
    Color(0xFFD50000),
  ];

  static const List<Color> darkBalanceGradient = [
    darkBalance,
    Color(0xFF42A5F5),
  ];

  // ---------------------------------------------------------------------------
  // 1. STANDART AÇIK (LIGHT) TEMA RENKLERİ
  // ---------------------------------------------------------------------------

  static const Color primaryLight = Color(0xFF1E88E5);

  static const Color lightBackground = Color(0xFFF4F6F8);
  static const Color lightSurface = Color(0xFFF8F9FA);
  static const Color lightCard = Colors.white;
  static const Color lightBorder = Color(0xFFE5E7EB);
  static const Color lightTextPrimary = Color(0xFF1F2937);

  // ---------------------------------------------------------------------------
  // 2. STANDART KOYU (DARK) TEMA RENKLERİ
  // ---------------------------------------------------------------------------

  static const Color primaryDark = Color(0xFF90CAF9);

  static const Color darkBackground = Color(0xFF12121A);
  static const Color darkSurface = Color(0xFF1E1E2D);
  static const Color darkCard = Color(0xFF1E1E2D);
  static const Color darkBorder = Color(0xFF2E2E3E);
  static const Color darkTextPrimary = Colors.white;

  // ---------------------------------------------------------------------------
  // 3. DARK HOT PINK TEMA RENKLERİ
  // ---------------------------------------------------------------------------

  static const Color hotPinkAccent = Color(0xFFFF4081);

  static const Color darkPinkBackground = Color(0xFF120B0F);
  static const Color darkPinkSurface = Color(0xFF1F1218);
  static const Color darkPinkBorder = Color(0xFF381E2C);
  static const Color darkPinkText = Colors.white;

  // ---------------------------------------------------------------------------
  // 4. DARK TIFFANY BLUE TEMA RENKLERİ
  // ---------------------------------------------------------------------------

  static const Color tiffanyAccent = Color(0xFF0ABAB5);

  static const Color darkTiffanyBackground = Color(0xFF0B1417);
  static const Color darkTiffanySurface = Color(0xFF101E22);
  static const Color darkTiffanyBorder = Color(0xFF1B3238);
  static const Color darkTiffanyText = Colors.white;

  static const Color tiffanyButtonText = Colors.black;

  // ---------------------------------------------------------------------------
  // UYUMLULUK / GENEL RENKLER
  // ---------------------------------------------------------------------------

  static const Color textPrimary = lightTextPrimary;

  static const Color darkIncome = income;
  static const Color darkExpense = expense;
}