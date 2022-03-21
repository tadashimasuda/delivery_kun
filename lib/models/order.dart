class Order {
  final int id;
  final int prefectureId;
  final num earningsIncentive;
  final num earningsBase;
  final num earningsTotal;
  final DateTime createdAt;

  Order(
      {required this.id,
        required this.prefectureId,
        required this.earningsIncentive,
        required this.earningsBase,
        required this.earningsTotal,
        required this.createdAt});

  Order.fromJson(Map<String, dynamic> json)
      : id = json['data']['id'],
        prefectureId = json['data']['prefecture_id'],
        earningsIncentive = json['data']['earnings_incentive'],
        earningsBase = json['data']['earnings_base'],
        earningsTotal = json['data']['earnings_total'],
        createdAt = json['data']['created_at'];
}