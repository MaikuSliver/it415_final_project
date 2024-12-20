class Rating {
  const Rating({
    this.id,
    this.parentId,
    this.babysitterId,
    this.bookingId,
    this.rating,
    this.comment,
    this.createdAt,
    this.updatedAt,
  });

  factory Rating.fromJson(Map<String, dynamic> json) {
    final dynamic rawRating = json['rating'];
    double? parsedRating;

    if (rawRating != null) {
      if (rawRating is int) {
        parsedRating = rawRating.toDouble();
      } else if (rawRating is double) {
        parsedRating = rawRating;
      }
    }

    return Rating(
      id: json['id'] as String?,
      parentId: json['parentId'] as String,
      babysitterId: json['babysitterId'] as String,
      bookingId: json['bookingId'] as String?,
      rating: parsedRating,
      comment: json['comment'] as String?,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
    );
  }

  final String? id;
  final String? parentId;
  final String? babysitterId;
  final String? bookingId;
  final double? rating;
  final String? comment;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'parentId': parentId,
        'babysitterId': babysitterId,
        'bookingId': bookingId,
        'rating': rating,
        'comment': comment,
        'createdAt': createdAt?.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
      };

  Rating copyWith({
    String? id,
    String? parentId,
    String? babysitterId,
    String? bookingId,
    double? rating,
    String? comment,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Rating(
      id: id ?? this.id,
      parentId: parentId ?? this.parentId,
      babysitterId: babysitterId ?? this.babysitterId,
      bookingId: bookingId ?? this.bookingId,
      rating: rating ?? this.rating,
      comment: comment ?? this.comment,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
