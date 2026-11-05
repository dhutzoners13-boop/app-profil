import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:portal_frontend/core/constants/api_constants.dart';
import 'package:portal_frontend/data/models/setting_model.dart';
import 'package:portal_frontend/data/models/slide_model.dart';
import 'package:portal_frontend/data/models/category_model.dart';
import 'package:portal_frontend/data/models/post_model.dart';
import 'package:portal_frontend/data/models/page_model.dart';
import 'package:portal_frontend/data/models/faq_model.dart';
import 'package:portal_frontend/data/models/question_topic_model.dart';
import 'package:portal_frontend/data/models/question_model.dart';
import 'package:portal_frontend/data/models/menu_model.dart';

class ApiException implements Exception {
  final String message;
  final int? statusCode;

  ApiException(this.message, [this.statusCode]);

  @override
  String toString() => message;
}

class ApiService {
  final http.Client _client;

  ApiService({http.Client? client}) : _client = client ?? http.Client();

  Map<String, String> _buildHeaders(String? lang) {
    final headers = <String, String>{
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };
    if (lang != null && lang.isNotEmpty) {
      headers['Accept-Language'] = lang;
    }
    return headers;
  }

  Future<dynamic> _get(String path, {Map<String, String>? params, String? lang}) async {
    final baseUrl = await ApiConstants.getBaseUrl();
    var uri = Uri.parse('$baseUrl$path');
    if (params != null && params.isNotEmpty) {
      final query = Map<String, String>.from(uri.queryParameters)..addAll(params);
      uri = uri.replace(queryParameters: query);
    }

    try {
      final response = await _client
          .get(uri, headers: _buildHeaders(lang))
          .timeout(const Duration(seconds: 15));

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return json.decode(utf8.decode(response.bodyBytes));
      } else {
        throw ApiException(
          'HTTP ${response.statusCode}: ${response.reasonPhrase ?? "Error"}',
          response.statusCode,
        );
      }
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Gagal terhubung ke API: $e');
    }
  }

  Future<dynamic> _post(String path, Map<String, dynamic> body, {String? lang}) async {
    final baseUrl = await ApiConstants.getBaseUrl();
    final uri = Uri.parse('$baseUrl$path');

    try {
      final response = await _client
          .post(
            uri,
            headers: _buildHeaders(lang),
            body: json.encode(body),
          )
          .timeout(const Duration(seconds: 15));

      final decoded = json.decode(utf8.decode(response.bodyBytes));
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return decoded;
      } else {
        final msg = decoded['message'] ?? 'Gagal memproses data';
        throw ApiException(msg.toString(), response.statusCode);
      }
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Gagal mengirim data: $e');
    }
  }

  // --- SETTINGS ---
  Future<SettingModel> getSettings({String? group, String? lang}) async {
    final params = group != null ? {'group': group} : null;
    final jsonResponse = await _get('/settings', params: params, lang: lang);
    final data = jsonResponse['data'] as Map<String, dynamic>? ?? {};
    return SettingModel.fromJson(data);
  }

  // --- SLIDES ---
  Future<List<SlideModel>> getSlides({String? lang}) async {
    final jsonResponse = await _get('/slides', lang: lang);
    final list = jsonResponse['data'] as List? ?? [];
    return list.map((e) => SlideModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  // --- CATEGORIES ---
  Future<List<CategoryModel>> getCategories({String? lang}) async {
    final jsonResponse = await _get('/categories', lang: lang);
    final list = jsonResponse['data'] as List? ?? [];
    return list.map((e) => CategoryModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  // --- POSTS ---
  Future<Map<String, dynamic>> getPosts({
    int page = 1,
    int perPage = 10,
    String? category,
    String? search,
    bool? featured,
    String? lang,
  }) async {
    final params = <String, String>{
      'page': page.toString(),
      'per_page': perPage.toString(),
    };
    if (category != null && category.isNotEmpty) {
      params['category'] = category;
    }
    if (search != null && search.isNotEmpty) {
      params['search'] = search;
    }
    if (featured == true) {
      params['featured'] = '1';
    }

    final jsonResponse = await _get('/posts', params: params, lang: lang);
    final list = (jsonResponse['data'] as List? ?? [])
        .map((e) => PostModel.fromJson(e as Map<String, dynamic>))
        .toList();

    final meta = jsonResponse['meta'] as Map<String, dynamic>?;
    return {
      'posts': list,
      'currentPage': meta?['current_page'] ?? page,
      'lastPage': meta?['last_page'] ?? 1,
      'total': meta?['total'] ?? list.length,
    };
  }

  Future<PostModel> getPostDetail(String slug, {String? lang}) async {
    final jsonResponse = await _get('/posts/$slug', lang: lang);
    final data = jsonResponse['data'] as Map<String, dynamic>;
    return PostModel.fromJson(data);
  }

  // --- PAGES ---
  Future<List<PageModel>> getPages({String? lang}) async {
    final jsonResponse = await _get('/pages', lang: lang);
    final list = jsonResponse['data'] as List? ?? [];
    return list.map((e) => PageModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<PageModel> getPageDetail(String slug, {String? lang}) async {
    final jsonResponse = await _get('/pages/$slug', lang: lang);
    final data = jsonResponse['data'] as Map<String, dynamic>;
    return PageModel.fromJson(data);
  }

  // --- FAQS ---
  Future<List<FaqModel>> getFaqs({String? lang}) async {
    final jsonResponse = await _get('/faqs', lang: lang);
    final list = jsonResponse['data'] as List? ?? [];
    return list.map((e) => FaqModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  // --- QUESTION TOPICS ---
  Future<List<QuestionTopicModel>> getQuestionTopics({String? lang}) async {
    final jsonResponse = await _get('/question-topics', lang: lang);
    final list = jsonResponse['data'] as List? ?? [];
    return list
        .map((e) => QuestionTopicModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  // --- QUESTIONS ---
  Future<Map<String, dynamic>> getQuestions({
    int page = 1,
    int perPage = 10,
    String? topic,
    String? search,
    String? lang,
  }) async {
    final params = <String, String>{
      'page': page.toString(),
      'per_page': perPage.toString(),
    };
    if (topic != null && topic.isNotEmpty) {
      params['topic'] = topic;
    }
    if (search != null && search.isNotEmpty) {
      params['search'] = search;
    }

    final jsonResponse = await _get('/questions', params: params, lang: lang);
    final list = (jsonResponse['data'] as List? ?? [])
        .map((e) => QuestionModel.fromJson(e as Map<String, dynamic>))
        .toList();

    final meta = jsonResponse['meta'] as Map<String, dynamic>?;
    return {
      'questions': list,
      'currentPage': meta?['current_page'] ?? page,
      'lastPage': meta?['last_page'] ?? 1,
      'total': meta?['total'] ?? list.length,
    };
  }

  Future<QuestionModel> getQuestionDetail(int id, {String? lang}) async {
    final jsonResponse = await _get('/questions/$id', lang: lang);
    final data = jsonResponse['data'] as Map<String, dynamic>;
    return QuestionModel.fromJson(data);
  }

  Future<Map<String, dynamic>> createQuestion(
    Map<String, dynamic> body, {
    String? lang,
  }) async {
    final response = await _post('/questions', body, lang: lang);
    return response as Map<String, dynamic>;
  }

  // --- MENUS ---
  Future<MenuModel?> getMenu(String location, {String? lang}) async {
    try {
      final jsonResponse = await _get('/menus/$location', lang: lang);
      final data = jsonResponse['data'] as Map<String, dynamic>?;
      if (data != null) {
        return MenuModel.fromJson(data);
      }
    } catch (_) {}
    return null;
  }
}
