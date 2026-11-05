import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:portal_frontend/core/localization/locale_provider.dart';
import 'package:portal_frontend/core/services/api_service.dart';
import 'package:portal_frontend/data/models/page_model.dart';
import 'package:portal_frontend/presentation/widgets/error_view.dart';
import 'package:portal_frontend/presentation/widgets/html_text.dart';
import 'package:portal_frontend/presentation/widgets/loading_view.dart';

class PageDetailScreen extends StatefulWidget {
  final String slug;

  const PageDetailScreen({super.key, required this.slug});

  @override
  State<PageDetailScreen> createState() => _PageDetailScreenState();
}

class _PageDetailScreenState extends State<PageDetailScreen> {
  final ApiService _apiService = ApiService();
  PageModel? _page;
  bool _isLoading = true;
  String? _errorMessage;
  String? _loadedLocale;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final currentLocale = context.watch<LocaleProvider>().locale.languageCode;
    if (_loadedLocale != currentLocale) {
      _loadedLocale = currentLocale;
      _loadPage();
    }
  }

  Future<void> _loadPage() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final page = await _apiService.getPageDetail(
        widget.slug,
        lang: _loadedLocale,
      );
      if (!mounted) return;
      setState(() {
        _page = page;
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
    final theme = Theme.of(context);

    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(),
        body: const LoadingView(),
      );
    }

    if (_errorMessage != null || _page == null) {
      return Scaffold(
        appBar: AppBar(),
        body: ErrorView(
          message: _errorMessage,
          onRetry: _loadPage,
        ),
      );
    }

    final page = _page!;

    return Scaffold(
      appBar: AppBar(
        title: Text(page.title),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (page.image != null) ...[
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Image.network(
                    page.image!,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
            Text(
              page.title,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 16),
            if (page.content != null && page.content!.isNotEmpty)
              HtmlText(
                html: page.content!,
                style: theme.textTheme.bodyLarge?.copyWith(
                  height: 1.7,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
