class BlockedDateModel {
  final String date;
  final String startTime;
  final String endTime;  


  final String? id;  

  BlockedDateModel( {
    this.id,
    required this.date,
    required this.startTime,
    required this.endTime,
  });

  // Convert JSON to BlockedDateModel
  factory BlockedDateModel.fromJson(Map<String, dynamic> json) {
    return BlockedDateModel(
      id: json['id'] ?? '',
      date: json['date'] ?? '',
      startTime: json['startTime'] ?? '',
      endTime: json['endTime'] ?? '',
    );
  }

  // Convert BlockedDateModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date,
      'startTime': startTime,
      'endTime': endTime,
    };
  }
}
