

class BookDetails {
  final String id;
  final String title;
  final String authorName;
  final String? coverPic;
  final double? rating;
  final String? aboutBook;
  final String? aboutAuthor;
  final DateTime createdAt;
  final DateTime updatedAt;

  BookDetails({
    required this.id,
    required this.title,
    required this.authorName,
    this.coverPic,
    this.rating,
    this.aboutBook,
    this.aboutAuthor,
    required this.createdAt,
    required this.updatedAt,
  });

  factory BookDetails.fromJson(Map<String, dynamic> json) => BookDetails(
        id: json['id'],
        title: json['title'],
        authorName: json['author_name'],
        coverPic: json['cover_pic'],
        rating: (json['rating'] as num?)?.toDouble(),
        aboutBook: json['about_book'],
        aboutAuthor: json['about_author'],
        createdAt: DateTime.parse(json['created_at']),
        updatedAt: DateTime.parse(json['updated_at']),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'author_name': authorName,
        'cover_pic': coverPic,
        'rating': rating,
        'about_book': aboutBook,
        'about_author': aboutAuthor,
        'created_at': createdAt.toIso8601String(),
        'updated_at': updatedAt.toIso8601String(),
      };
}