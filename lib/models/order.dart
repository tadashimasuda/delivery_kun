class Order {
  final int id;
  final int prefecture_id;
  final int earnings_incentive;
  final int earnings_base;
  final int earnings_total;
  final String created_at;

  Order(
      {required this.id,
        required this.prefecture_id,
        required this.earnings_incentive,
        required this.earnings_base,
        required this.earnings_total,
        required this.created_at});

  Order.fromJson(Map<String, dynamic> json)
      : id = json['id'] ?? '',
        prefecture_id = json['prefecture_id'] ?? '',
        earnings_incentive = json['earnings_incentive'] ?? '',
        earnings_base = json['earnings_base'] ?? '',
        earnings_total = json['earnings_total'] ?? '',
        created_at = json['created_at'] ?? '';
}
