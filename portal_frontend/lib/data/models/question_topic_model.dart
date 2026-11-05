class QuestionTopicModel {
  final int id;
  final String name;
  final String slug;
  final String? description;
  final String? icon;
  final int? questionsCount;
  final int? faqsCount;

  QuestionTopicModel({
    required this.id,
    required this.name,
    required this.slug,
    this.description,
    this.icon,
    this.questionsCount,
    this.faqsCount,
  });

  factory QuestionTopicModel.fromJson(Map<String, dynamic> json) {
    return QuestionTopicModel(
      id: json['id'] as int? ?? 0,
      name: json['name']?.toString() ?? '',
      slug: json['slug']?.toString() ?? '',
      description: json['description']?.toString(),
      icon: json['icon']?.toString(),
      questionsCount: json['questions_count'] as int?,
      faqsCount: json['faqs_count'] as int?,
    );
  }
}

