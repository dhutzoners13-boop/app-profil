class PageModel {
  final int id;
  final String title;
  final String slug;
  final String? content;
  final String? image;
  final String? status;
  final int sortOrder;
  final bool showInMenu;
  final DateTime? updatedAt;

  PageModel({
    required this.id,
    required this.title,
    required this.slug,
    this.content,
    this.image,
    this.status,
    required this.sortOrder,
    required this.showInMenu,
    this.updatedAt,
  });

  factory PageModel.fromJson(Map<String, dynamic> json) {
    DateTime? parseDate(dynamic val) {
      if (val == null) return null;
      try {
        return DateTime.parse(val.toString());
      } catch (_) {
        return null;
      }
    }

    return PageModel(
      id: json['id'] as int? ?? 0,
      title: json['title']?.toString() ?? '',
      slug: json['slug']?.toString() ?? '',
      content: json['content']?.toString(),
      image: json['image']?.toString(),
      status: json['status']?.toString(),
      sortOrder: json['sort_order'] as int? ?? 0,
      showInMenu: json['show_in_menu'] as bool? ?? false,
      updatedAt: parseDate(json['updated_at']),
    );
  }
}

