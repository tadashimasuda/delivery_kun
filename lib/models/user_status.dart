class UserStatus {
  final String onlineTime;
  final int daysEarningsTotal;
  final int daysEarningsQty;
  final String vehicleModel;
  final int actualCost;

  UserStatus(
      {required this.onlineTime,
      required this.daysEarningsTotal,
      required this.daysEarningsQty,
      required this.actualCost,
      required this.vehicleModel});

  UserStatus.fromJson(Map<String, dynamic> json)
      : onlineTime = json['data']['summary']['onlineTime'] ?? '',
        daysEarningsTotal = json['data']['summary']['daysEarningsTotal'] ?? '',
        actualCost = json['data']['summary']['actualCost'] ?? '',
        daysEarningsQty = json['data']['summary']['daysEarningsQty'] ?? '',
        vehicleModel = json['data']['user']['vehicleModel'] ?? '';
}
