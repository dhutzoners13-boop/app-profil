import 'question_topic_model.dart';

class FaqModel {
  final int id;
  final int? topicId;
  final String question;
  final String answer;
  final int sortOrder;
  final QuestionTopicModel? topic;

  FaqModel({
    required this.id,
    this.topicId,
    required this.question,
    required this.answer,
    required this.sortOrder,
    this.topic,
  });

  factory FaqModel.fromJson(Map<String, dynamic> json) {
    return FaqModel(
      id: json['id'] as int? ?? 0,
      topicId: json['topic_id'] as int?,
      question: json['question']?.toString() ?? '',
      answer: json['answer']?.toString() ?? '',
      sortOrder: json['sort_order'] as int? ?? 0,
      topic: json['topic'] != null
          ? QuestionTopicModel.fromJson(json['topic'] as Map<String, dynamic>)
          : null,
    );
  }
}

