
class AppTransaction {
  final List<Transaction>? transactions;
  final int? total;
  final int? page;
  final int? totalPages;

  AppTransaction({
    this.transactions,
    this.total,
    this.page,
    this.totalPages,
  });

  factory AppTransaction.fromJson(Map<String, dynamic> json) {
    return AppTransaction(
      transactions: json["transactions"] == null
          ? []
          : List<Transaction>.from(
              json["transactions"].map(
                (x) => Transaction.fromJson(x),
              ),
            ),
      total: json["total"],
      page: json["page"],
      totalPages: json["totalPages"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "transactions": transactions == null
          ? []
          : List<dynamic>.from(
              transactions!.map(
                (x) => x.toJson(),
              ),
            ),
      "total": total,
      "page": page,
      "totalPages": totalPages,
    };
  }
}

class Transaction {
  final String? id;
  final double? amount;
  final String? type;
  final String? description;
  final DateTime? date;
  final String? categoryId;
  final String? userId;

  Transaction({
    this.id,
    this.amount,
    this.type,
    this.description,
    this.date,
    this.categoryId,
    this.userId,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json["id"],

      amount: json["amount"] == null
          ? null
          : double.tryParse(
              json["amount"].toString(),
            ),

      type: json["type"],
      description: json["description"],

      date: json["date"] == null
          ? null
          : DateTime.parse(
              json["date"],
            ),

      categoryId: json["category_id"],
      userId: json["user_id"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "amount": amount,
      "type": type,
      "description": description,

      "date": date == null
          ? null
          : "${date!.year.toString().padLeft(4, '0')}-"
            "${date!.month.toString().padLeft(2, '0')}-"
            "${date!.day.toString().padLeft(2, '0')}",

      "category_id": categoryId,
      "user_id": userId,
    };
  }
}

