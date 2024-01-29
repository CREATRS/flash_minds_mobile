class Review {
  const Review({required this.id, required this.date, required this.value});

  factory Review.fromJson(Map<String, dynamic> json) => Review(
        id: json['id'],
        date: DateTime.parse(json['updatedAt']),
        value: json['value'],
      );

  final int id;
  final DateTime date;
  final int value;
}
