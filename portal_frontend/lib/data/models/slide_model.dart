class SlideModel {
  final int id;
  final String title;
  final String? description;
  final String? image;
  final String? linkUrl;
  final int sortOrder;

  SlideModel({
    required this.id,
    required this.title,
    this.description,
    this.image,
    this.linkUrl,
    required this.sortOrder,
  });

  factory SlideModel.fromJson(Map<String, dynamic> json) {
    return SlideModel(
      id: json['id'] as int? ?? 0,
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString(),
      image: json['image']?.toString(),
      linkUrl: json['link_url']?.toString(),
      sortOrder: json['sort_order'] as int? ?? 0,
    );
  }
}

