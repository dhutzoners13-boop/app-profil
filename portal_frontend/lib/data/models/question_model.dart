import 'question_topic_model.dart';

class QuestionAnswerModel {
  final int id;
  final String body;
  final String? answeredBy;
  final DateTime? answeredAt;

  QuestionAnswerModel({
    required this.id,
    required this.body,
    this.answeredBy,
    this.answeredAt,
  });

  factory QuestionAnswerModel.fromJson(Map<String, dynamic> json) {
    DateTime? parseDate(dynamic val) {
      if (val == null) return null;
      try {
        return DateTime.parse(val.toString());
      } catch (_) {
        return null;
      }
    }

    return QuestionAnswerModel(
      id: json['id'] as int? ?? 0,
      body: json['body']?.toString() ?? '',
      answeredBy: json['answered_by']?.toString(),
      answeredAt: parseDate(json['answered_at']),
    );
  }
}

class QuestionModel {
  final int id;
  final String name;
  final String subject;
  final String body;
  final String status;
  final QuestionTopicModel? topic;
  final List<QuestionAnswerModel> answers;
  final DateTime? createdAt;

  QuestionModel({
    required this.id,
    required this.name,
    required this.subject,
    required this.body,
    required this.status,
    this.topic,
    required this.answers,
    this.createdAt,
  });

  factory QuestionModel.fromJson(Map<String, dynamic> json) {
    DateTime? parseDate(dynamic val) {
      if (val == null) return null;
      try {
        return DateTime.parse(val.toString());
      } catch (_) {
        return null;
      }
    }

    var answersList = <QuestionAnswerModel>[];
    if (json['answers'] is List) {
      answersList = (json['answers'] as List)
          .map((a) => QuestionAnswerModel.fromJson(a as Map<String, dynamic>))
          .toList();
    }

    return QuestionModel(
      id: json['id'] as int? ?? 0,
      name: json['name']?.toString() ?? '',
      subject: json['subject']?.toString() ?? '',
      body: json['body']?.toString() ?? '',
      status: json['status']?.toString() ?? 'pending',
      topic: json['topic'] != null
          ? QuestionTopicModel.fromJson(json['topic'] as Map<String, dynamic>)
          : null,
      answers: answersList,
      createdAt: parseDate(json['created_at']),
    );
  }
}

