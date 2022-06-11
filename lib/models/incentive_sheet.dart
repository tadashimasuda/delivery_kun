class IncentiveSheetModel{
  final String id;
  final String title;
  final Map earningsIncentives;

  IncentiveSheetModel({
      required this.id,
      required this.title,
      required this.earningsIncentives,
      });

  IncentiveSheetModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        title = json['title'],
        earningsIncentives = json['earningsIncentives'];
}