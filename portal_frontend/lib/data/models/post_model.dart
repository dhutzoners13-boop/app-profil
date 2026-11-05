import 'category_model.dart';

class AuthorModel {
  final String? name;
  final String? avatar;

  AuthorModel({this.name, this.avatar});

  factory AuthorModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) return AuthorModel();
    return AuthorModel(
      name: json['name']?.toString(),
      avatar: json['avatar']?.toString(),
    );
  }
}

class PostModel {
  final int id;
  final String title;
  final String slug;
  final String? summary;
  final String? content;
  final String? image;
  final String? status;
  final int viewCount;
  final bool isFeatured;
  final DateTime? publishedAt;
  final CategoryModel? category;
  final AuthorModel? author;
  final DateTime? createdAt;

  PostModel({
    required this.id,
    required this.title,
    required this.slug,
    this.summary,
    this.content,
    this.image,
    this.status,
    required this.viewCount,
    required this.isFeatured,
    this.publishedAt,
    this.category,
    this.author,
    this.createdAt,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    DateTime? parseDate(dynamic val) {
      if (val == null) return null;
      try {
        return DateTime.parse(val.toString());
      } catch (_) {
        return null;
      }
    }

    return PostModel(
      id: json['id'] as int? ?? 0,
      title: json['title']?.toString() ?? '',
      slug: json['slug']?.toString() ?? '',
      summary: json['summary']?.toString(),
      content: json['content']?.toString(),
      image: json['image']?.toString(),
      status: json['status']?.toString(),
      viewCount: json['view_count'] as int? ?? 0,
      isFeatured: json['is_featured'] as bool? ?? false,
      publishedAt: parseDate(json['published_at']),
      category: json['category'] != null
          ? CategoryModel.fromJson(json['category'] as Map<String, dynamic>)
          : null,
      author: AuthorModel.fromJson(json['author'] as Map<String, dynamic>?),
      createdAt: parseDate(json['created_at']),
    );
  }
}

