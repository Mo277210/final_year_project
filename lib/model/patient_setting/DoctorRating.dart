class DoctorRating {
  final double rating;
  final double newRating;

  DoctorRating({
    required this.rating,
    required this.newRating,
  });

  factory DoctorRating.fromJson(Map<String, dynamic> json) {
    return DoctorRating(
      rating: json['rateing']?.toDouble() ?? 0.0,
      newRating: json['new_rateing']?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'rateing': rating,
    };
  }
}