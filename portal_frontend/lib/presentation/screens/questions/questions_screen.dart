import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:portal_frontend/core/localization/app_localizations.dart';
import 'package:portal_frontend/core/localization/locale_provider.dart';
import 'package:portal_frontend/core/services/api_service.dart';
import 'package:portal_frontend/data/models/question_model.dart';
import 'package:portal_frontend/data/models/question_topic_model.dart';
import 'package:portal_frontend/presentation/widgets/error_view.dart';
import 'package:portal_frontend/presentation/widgets/loading_view.dart';

class QuestionsScreen extends StatefulWidget {
  const QuestionsScreen({super.key});

  @override
  State<QuestionsScreen> createState() => _QuestionsScreenState();
}

class _QuestionsScreenState extends State<QuestionsScreen> {
  final ApiService _apiService = ApiService();
  final TextEditingController _searchController = TextEditingController();

  List<QuestionTopicModel> _topics = [];
  List<QuestionModel> _questions = [];
  String? _selectedTopicSlug;
  String _searchQuery = '';

  bool _isLoading = true;
  String? _errorMessage;
  String? _loadedLocale;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final currentLocale = context.watch<LocaleProvider>().locale.languageCode;
    if (_loadedLocale != currentLocale) {
      _loadedLocale = currentLocale;
      _loadData();
    }
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final lang = _loadedLocale;

    try {
      final results = await Future.wait([
        _apiService.getQuestionTopics(lang: lang).catchError((_) => <QuestionTopicModel>[]),
        _apiService.getQuestions(
          topic: _selectedTopicSlug,
          search: _searchQuery,
          lang: lang,
        ),
      ]);

      if (!mounted) return;

      setState(() {
        _topics = results[0] as List<QuestionTopicModel>;
        final qData = results[1] as Map<String, dynamic>;
        _questions = qData['questions'] as List<QuestionModel>;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _filterQuestions() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final qData = await _apiService.getQuestions(
        topic: _selectedTopicSlug,
        search: _searchQuery,
        lang: _loadedLocale,
      );

      if (!mounted) return;

      setState(() {
        _questions = qData['questions'] as List<QuestionModel>;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final submitted = await context.push<bool>('/questions/create');
          if (submitted == true) {
            _filterQuestions();
          }
        },
        icon: const Icon(Icons.add_comment_rounded),
        label: Text(l10n.translate('ask_question')),
      ),
      body: Column(
        children: [
          // Search Box
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: l10n.translate('search_questions'),
                prefixIcon: const Icon(Icons.search_rounded),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear_rounded),
                        onPressed: () {
                          _searchController.clear();
                          _searchQuery = '';
                          _filterQuestions();
                        },
                      )
                    : null,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: theme.colorScheme.surfaceContainerHighest.withAlpha(120),
              ),
              onSubmitted: (val) {
                _searchQuery = val.trim();
                _filterQuestions();
              },
            ),
          ),

          // Topic Chips
          if (_topics.isNotEmpty)
            SizedBox(
              height: 48,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  ChoiceChip(
                    label: Text(l10n.translate('all_topics')),
                    selected: _selectedTopicSlug == null,
                    onSelected: (selected) {
                      if (selected) {
                        setState(() => _selectedTopicSlug = null);
                        _filterQuestions();
                      }
                    },
                  ),
                  const SizedBox(width: 8),
                  ..._topics.map((t) {
                    final isSelected = _selectedTopicSlug == t.slug;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: Text(t.name),
                        selected: isSelected,
                        onSelected: (selected) {
                          setState(() {
                            _selectedTopicSlug = selected ? t.slug : null;
                          });
                          _filterQuestions();
                        },
                      ),
                    );
                  }),
                ],
              ),
            ),

          const Divider(height: 1),

          // List
          Expanded(
            child: _isLoading
                ? const LoadingView()
                : _errorMessage != null
                    ? ErrorView(
                        message: _errorMessage,
                        onRetry: _filterQuestions,
                      )
                    : _questions.isEmpty
                        ? Center(
                            child: Padding(
                              padding: const EdgeInsets.all(24.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.chat_bubble_outline_rounded,
                                    size: 64,
                                    color: theme.colorScheme.outline,
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    l10n.translate('no_results'),
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: theme.colorScheme.outline,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  FilledButton.tonal(
                                    onPressed: () => context.push('/questions/create'),
                                    child: Text(l10n.translate('ask_question')),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : RefreshIndicator(
                            onRefresh: _filterQuestions,
                            child: ListView.builder(
                              padding: const EdgeInsets.fromLTRB(16, 12, 16, 80),
                              itemCount: _questions.length,
                              itemBuilder: (context, index) {
                                final item = _questions[index];
                                return _buildQuestionCard(theme, l10n, item);
                              },
                            ),
                          ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionCard(
    ThemeData theme,
    AppLocalizations l10n,
    QuestionModel item,
  ) {
    final dateFormat = DateFormat.yMMMMd(
      _loadedLocale == 'id' ? 'id_ID' : 'en_US',
    );
    final dateStr = item.createdAt != null ? dateFormat.format(item.createdAt!) : '';

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: theme.colorScheme.outlineVariant),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => context.push('/questions/${item.id}'),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  if (item.topic != null)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.secondaryContainer,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        item.topic!.name,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.onSecondaryContainer,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: item.status == 'answered'
                          ? Colors.green.shade50
                          : Colors.orange.shade50,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: item.status == 'answered'
                            ? Colors.green.shade300
                            : Colors.orange.shade300,
                      ),
                    ),
                    child: Text(
                      item.status == 'answered'
                          ? l10n.translate('status_answered')
                          : l10n.translate('status_pending'),
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: item.status == 'answered'
                            ? Colors.green.shade800
                            : Colors.orange.shade800,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                item.subject,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  height: 1.3,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                item.body,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(Icons.person_outline, size: 14, color: theme.colorScheme.outline),
                  const SizedBox(width: 4),
                  Text(
                    item.name,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.outline,
                    ),
                  ),
                  const Spacer(),
                  Icon(Icons.access_time, size: 13, color: theme.colorScheme.outline),
                  const SizedBox(width: 4),
                  Text(
                    dateStr,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.outline,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
