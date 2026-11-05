import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:portal_frontend/core/localization/app_localizations.dart';
import 'package:portal_frontend/core/localization/locale_provider.dart';
import 'package:portal_frontend/core/services/api_service.dart';
import 'package:portal_frontend/data/models/post_model.dart';
import 'package:portal_frontend/presentation/widgets/error_view.dart';
import 'package:portal_frontend/presentation/widgets/html_text.dart';
import 'package:portal_frontend/presentation/widgets/loading_view.dart';

class PostDetailScreen extends StatefulWidget {
  final String slug;

  const PostDetailScreen({super.key, required this.slug});

  @override
  State<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  final ApiService _apiService = ApiService();
  PostModel? _post;
  bool _isLoading = true;
  String? _errorMessage;
  String? _loadedLocale;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final currentLocale = context.watch<LocaleProvider>().locale.languageCode;
    if (_loadedLocale != currentLocale) {
      _loadedLocale = currentLocale;
      _loadPost();
    }
  }

  Future<void> _loadPost() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final post = await _apiService.getPostDetail(
        widget.slug,
        lang: _loadedLocale,
      );
      if (!mounted) return;
      setState(() {
        _post = post;
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
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(),
        body: const LoadingView(),
      );
    }

    if (_errorMessage != null || _post == null) {
      return Scaffold(
        appBar: AppBar(),
        body: ErrorView(
          message: _errorMessage,
          onRetry: _loadPost,
        ),
      );
    }

    final post = _post!;
    final dateFormat = DateFormat.yMMMMd(
      _loadedLocale == 'id' ? 'id_ID' : 'en_US',
    );
    final dateStr = post.publishedAt != null ? dateFormat.format(post.publishedAt!) : '';

    return Scaffold(
      appBar: AppBar(
        title: Text(
          post.category?.name ?? l10n.translate('posts'),
          style: const TextStyle(fontSize: 16),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Featured Image
            if (post.image != null)
              AspectRatio(
                aspectRatio: 16 / 9,
                child: Image.network(
                  post.image!,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: theme.colorScheme.surfaceContainerHighest,
                    child: const Icon(Icons.image_outlined, size: 48),
                  ),
                ),
              ),

            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category tag & views
                  Row(
                    children: [
                      if (post.category != null)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primaryContainer,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            post.category!.name,
                            style: theme.textTheme.labelMedium?.copyWith(
                              color: theme.colorScheme.onPrimaryContainer,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      const Spacer(),
                      Icon(Icons.visibility_outlined,
                          size: 16, color: theme.colorScheme.outline),
                      const SizedBox(width: 4),
                      Text(
                        '${post.viewCount} ${l10n.translate('views')}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.outline,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Title
                  Text(
                    post.title,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Author & Date
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 16,
                        backgroundColor: theme.colorScheme.primaryContainer,
                        child: Text(
                          (post.author?.name?.isNotEmpty == true)
                              ? post.author!.name![0].toUpperCase()
                              : 'A',
                          style: TextStyle(
                            color: theme.colorScheme.onPrimaryContainer,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            post.author?.name ?? 'Admin',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
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

                  const SizedBox(height: 20),
                  const Divider(),
                  const SizedBox(height: 16),

                  // Summary Callout
                  if (post.summary != null && post.summary!.isNotEmpty) ...[
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surfaceContainerHighest.withAlpha(120),
                        borderRadius: BorderRadius.circular(10),
                        border: Border(
                          left: BorderSide(
                            color: theme.colorScheme.primary,
                            width: 4,
                          ),
                        ),
                      ),
                      child: Text(
                        post.summary!,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontStyle: FontStyle.italic,
                          height: 1.5,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],

                  // Content
                  if (post.content != null && post.content!.isNotEmpty)
                    HtmlText(
                      html: post.content!,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        height: 1.7,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
