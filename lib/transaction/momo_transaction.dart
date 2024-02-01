class Momo {
  final String phoneNumber;
  final String amount;

  Momo({required this.phoneNumber, required this.amount});

  factory Momo.fromJson(Map<String, dynamic> json) {
    return Momo(phoneNumber: json["phoneNumber"], amount: json["amount"]);
  }
  Map<String, dynamic> toJson() {
    return {"phoneNumber": phoneNumber, "amount": amount};
  }
}
