import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:portal_frontend/core/localization/app_localizations.dart';
import 'package:portal_frontend/core/localization/locale_provider.dart';
import 'package:portal_frontend/core/services/api_service.dart';
import 'package:portal_frontend/data/models/faq_model.dart';
import 'package:portal_frontend/data/models/question_topic_model.dart';
import 'package:portal_frontend/presentation/widgets/error_view.dart';
import 'package:portal_frontend/presentation/widgets/html_text.dart';
import 'package:portal_frontend/presentation/widgets/loading_view.dart';

class FaqScreen extends StatefulWidget {
  const FaqScreen({super.key});

  @override
  State<FaqScreen> createState() => _FaqScreenState();
}

class _FaqScreenState extends State<FaqScreen> {
  final ApiService _apiService = ApiService();
  final TextEditingController _searchController = TextEditingController();

  List<FaqModel> _allFaqs = [];
  List<QuestionTopicModel> _topics = [];
  int? _selectedTopicId;
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
        _apiService.getFaqs(lang: lang),
        _apiService.getQuestionTopics(lang: lang).catchError((_) => <QuestionTopicModel>[]),
      ]);

      if (!mounted) return;

      setState(() {
        _allFaqs = results[0] as List<FaqModel>;
        _topics = results[1] as List<QuestionTopicModel>;
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

  List<FaqModel> get _filteredFaqs {
    return _allFaqs.where((faq) {
      final matchesTopic =
          _selectedTopicId == null || faq.topicId == _selectedTopicId;
      final q = _searchQuery.toLowerCase();
      final matchesSearch = q.isEmpty ||
          faq.question.toLowerCase().contains(q) ||
          faq.answer.toLowerCase().contains(q);
      return matchesTopic && matchesSearch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return Scaffold(
      body: Column(
        children: [
          // Search Input
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: l10n.translate('search_faq'),
                prefixIcon: const Icon(Icons.search_rounded),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear_rounded),
                        onPressed: () {
                          setState(() {
                            _searchController.clear();
                            _searchQuery = '';
                          });
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
              onChanged: (val) {
                setState(() => _searchQuery = val.trim());
              },
            ),
          ),

          // Topic Filter Chips
          if (_topics.isNotEmpty)
            SizedBox(
              height: 48,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  ChoiceChip(
                    label: Text(l10n.translate('all_topics')),
                    selected: _selectedTopicId == null,
                    onSelected: (selected) {
                      if (selected) {
                        setState(() => _selectedTopicId = null);
                      }
                    },
                  ),
                  const SizedBox(width: 8),
                  ..._topics.map((t) {
                    final isSelected = _selectedTopicId == t.id;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: Text(t.name),
                        selected: isSelected,
                        onSelected: (selected) {
                          setState(() {
                            _selectedTopicId = selected ? t.id : null;
                          });
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
                        onRetry: _loadData,
                      )
                    : _filteredFaqs.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.help_center_outlined,
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
                              ],
                            ),
                          )
                        : RefreshIndicator(
                            onRefresh: _loadData,
                            child: ListView.builder(
                              padding: const EdgeInsets.all(16),
                              itemCount: _filteredFaqs.length,
                              itemBuilder: (context, index) {
                                final faq = _filteredFaqs[index];
                                return Card(
                                  margin: const EdgeInsets.only(bottom: 10),
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    side: BorderSide(
                                      color: theme.colorScheme.outlineVariant,
                                    ),
                                  ),
                                  child: ExpansionTile(
                                    leading: CircleAvatar(
                                      radius: 14,
                                      backgroundColor:
                                          theme.colorScheme.primaryContainer,
                                      child: Text(
                                        'Q',
                                        style: TextStyle(
                                          color: theme.colorScheme.primary,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                    title: Text(
                                      faq.question,
                                      style: theme.textTheme.bodyMedium?.copyWith(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            16, 0, 16, 16),
                                        child: HtmlText(
                                          html: faq.answer,
                                          style: theme.textTheme.bodyMedium?.copyWith(
                                            color: theme.colorScheme.onSurfaceVariant,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
          ),
        ],
      ),
    );
  }
}
