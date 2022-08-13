class Order {
  final int id;
  final int prefectureId;
  final num earningsIncentive;
  final num earningsBase;
  final int earnings_distance_base;
  final num earnings_distance_base_type;
  final num earningsTotal;
  final DateTime orderReceivedAt;

  Order(
      {required this.id,
        required this.prefectureId,
        required this.earningsIncentive,
        required this.earningsBase,
        required this.earnings_distance_base,
        required this.earnings_distance_base_type,
        required this.earningsTotal,
        required this.orderReceivedAt});

  Order.fromJson(Map<String, dynamic> json)
      : id = json['data']['id'],
        prefectureId = json['data']['prefecture_id'],
        earningsIncentive = json['data']['earnings_incentive'],
        earningsBase = json['data']['earnings_base'],
        earnings_distance_base = json['data']['earnings_distance_base'],
        earnings_distance_base_type = json['data']['earnings_distance_base_type'],
        earningsTotal = json['data']['earnings_total'],
        orderReceivedAt = json['data']['order_received_at'];
}