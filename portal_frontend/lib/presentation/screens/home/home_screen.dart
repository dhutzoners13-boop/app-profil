import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:portal_frontend/core/localization/app_localizations.dart';
import 'package:portal_frontend/core/localization/locale_provider.dart';
import 'package:portal_frontend/core/services/api_service.dart';
import 'package:portal_frontend/data/models/category_model.dart';
import 'package:portal_frontend/data/models/faq_model.dart';
import 'package:portal_frontend/data/models/post_model.dart';
import 'package:portal_frontend/data/models/setting_model.dart';
import 'package:portal_frontend/data/models/slide_model.dart';
import 'package:portal_frontend/presentation/widgets/error_view.dart';
import 'package:portal_frontend/presentation/widgets/loading_view.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService _apiService = ApiService();

  SettingModel? _settings;
  List<SlideModel> _slides = [];
  List<CategoryModel> _categories = [];
  List<PostModel> _featuredPosts = [];
  List<FaqModel> _faqs = [];

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
        _apiService.getSettings(lang: lang).catchError((_) => SettingModel(raw: {})),
        _apiService.getSlides(lang: lang).catchError((_) => <SlideModel>[]),
        _apiService.getCategories(lang: lang).catchError((_) => <CategoryModel>[]),
        _apiService
            .getPosts(featured: true, perPage: 4, lang: lang)
            .then((r) => r['posts'] as List<PostModel>)
            .catchError((_) => <PostModel>[]),
        _apiService.getFaqs(lang: lang).catchError((_) => <FaqModel>[]),
      ]);

      if (!mounted) return;

      setState(() {
        _settings = results[0] as SettingModel;
        _slides = results[1] as List<SlideModel>;
        _categories = results[2] as List<CategoryModel>;
        _featuredPosts = results[3] as List<PostModel>;
        _faqs = (results[4] as List<FaqModel>).take(3).toList();
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
      return const LoadingView();
    }

    if (_errorMessage != null && _featuredPosts.isEmpty && _settings == null) {
      return ErrorView(
        message: _errorMessage,
        onRetry: _loadData,
      );
    }

    return RefreshIndicator(
      onRefresh: _loadData,
      child: ListView(
        padding: const EdgeInsets.symmetric(vertical: 12),
        children: [
          // 1. Institution Header Banner
          _buildInstitutionHeader(theme, l10n),

          // 2. Hero Slides if available
          if (_slides.isNotEmpty) ...[
            const SizedBox(height: 16),
            _buildSlideCarousel(theme),
          ],

          const SizedBox(height: 20),

          // 3. Quick Action Cards
          _buildQuickActions(theme, l10n),

          const SizedBox(height: 24),

          // 4. Featured News Section
          _buildFeaturedNewsSection(theme, l10n),

          const SizedBox(height: 24),

          // 5. FAQ Highlights
          if (_faqs.isNotEmpty) ...[
            _buildFaqHighlights(theme, l10n),
            const SizedBox(height: 24),
          ],

          // 6. Contact Information Card
          if (_settings != null) _buildContactCard(theme, l10n),

          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildInstitutionHeader(ThemeData theme, AppLocalizations l10n) {
    final siteName = _settings?.siteName ?? l10n.translate('app_title');
    final tagline = _settings?.siteTagline ?? '';

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.primary,
            theme.colorScheme.primaryContainer,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.primary.withAlpha(50),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(50),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'PORTAL RESMI',
              style: theme.textTheme.labelSmall?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            siteName,
            style: theme.textTheme.titleLarge?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (tagline.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(
              tagline,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Colors.white.withAlpha(220),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSlideCarousel(ThemeData theme) {
    return SizedBox(
      height: 180,
      child: PageView.builder(
        itemCount: _slides.length,
        controller: PageController(viewportFraction: 0.9),
        itemBuilder: (context, index) {
          final slide = _slides[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 6),
            clipBehavior: Clip.antiAlias,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 2,
            child: Stack(
              fit: StackFit.expand,
              children: [
                if (slide.image != null)
                  Image.network(
                    slide.image!,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: theme.colorScheme.surfaceContainerHighest,
                      child: const Icon(Icons.image_not_supported_rounded, size: 48),
                    ),
                  )
                else
                  Container(
                    color: theme.colorScheme.secondaryContainer,
                  ),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.black.withAlpha(200),
                        Colors.transparent,
                      ],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 16,
                  left: 16,
                  right: 16,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        slide.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (slide.description != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          slide.description!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.white.withAlpha(200),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildQuickActions(ThemeData theme, AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.translate('quick_menu'),
            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildActionItem(
                  theme: theme,
                  icon: Icons.edit_note_rounded,
                  color: Colors.teal,
                  label: l10n.translate('ask_question'),
                  onTap: () => context.push('/questions/create'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildActionItem(
                  theme: theme,
                  icon: Icons.newspaper_rounded,
                  color: Colors.blue,
                  label: l10n.translate('posts'),
                  onTap: () => context.go('/posts'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildActionItem(
                  theme: theme,
                  icon: Icons.help_outline_rounded,
                  color: Colors.amber.shade800,
                  label: l10n.translate('faq'),
                  onTap: () => context.go('/faqs'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildActionItem(
                  theme: theme,
                  icon: Icons.info_outline_rounded,
                  color: Colors.indigo,
                  label: l10n.translate('about_us'),
                  onTap: () => context.push('/pages/tentang-kami'),
                ),
              ),
            ],
          ),
          if (_categories.isNotEmpty) ...[
            const SizedBox(height: 14),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _categories.map((c) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ActionChip(
                      avatar: const Icon(Icons.label_outline_rounded, size: 16),
                      label: Text(c.name),
                      onPressed: () => context.go('/posts'),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildActionItem({
    required ThemeData theme,
    required IconData icon,
    required Color color,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 6),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: theme.colorScheme.outlineVariant.withAlpha(120)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(10),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: color.withAlpha(30),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.labelSmall?.copyWith(fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeaturedNewsSection(ThemeData theme, AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l10n.translate('featured_news'),
                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              TextButton(
                onPressed: () => context.go('/posts'),
                child: Text(l10n.translate('view_all')),
              ),
            ],
          ),
          const SizedBox(height: 8),
          if (_featuredPosts.isEmpty)
            Card(
              elevation: 0,
              color: theme.colorScheme.surfaceContainerLow,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Center(
                  child: Text(
                    l10n.translate('no_data'),
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.outline,
                    ),
                  ),
                ),
              ),
            )
          else
            ..._featuredPosts.map((post) => _buildPostCard(theme, l10n, post)),
        ],
      ),
    );
  }

  Widget _buildPostCard(ThemeData theme, AppLocalizations l10n, PostModel post) {
    final dateFormat = DateFormat.yMMMMd(
      _loadedLocale == 'id' ? 'id_ID' : 'en_US',
    );
    final dateStr = post.publishedAt != null ? dateFormat.format(post.publishedAt!) : '';

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      clipBehavior: Clip.antiAlias,
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () => context.push('/posts/${post.slug}'),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (post.image != null)
              AspectRatio(
                aspectRatio: 16 / 9,
                child: Image.network(
                  post.image!,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: theme.colorScheme.surfaceContainerHighest,
                    child: const Icon(Icons.image_outlined, size: 40),
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(14.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (post.category != null)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      margin: const EdgeInsets.only(bottom: 8),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        post.category!.name,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.onPrimaryContainer,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  Text(
                    post.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      height: 1.3,
                    ),
                  ),
                  if (post.summary != null && post.summary!.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Text(
                      post.summary!,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today_outlined,
                        size: 13,
                        color: theme.colorScheme.outline,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        dateStr,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.outline,
                        ),
                      ),
                      const Spacer(),
                      Icon(
                        Icons.visibility_outlined,
                        size: 14,
                        color: theme.colorScheme.outline,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${post.viewCount} ${l10n.translate('views')}',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.outline,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFaqHighlights(ThemeData theme, AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'FAQ Populer',
                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              TextButton(
                onPressed: () => context.go('/faqs'),
                child: Text(l10n.translate('view_all')),
              ),
            ],
          ),
          ..._faqs.map(
            (faq) => Card(
              margin: const EdgeInsets.only(bottom: 8),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: BorderSide(color: theme.colorScheme.outlineVariant),
              ),
              child: ExpansionTile(
                title: Text(
                  faq.question,
                  style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                ),
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    child: Text(
                      faq.answer.replaceAll(RegExp(r'<[^>]*>'), ''),
                      style: theme.textTheme.bodySmall?.copyWith(height: 1.5),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactCard(ThemeData theme, AppLocalizations l10n) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.contact_support_outlined, color: theme.colorScheme.primary),
              const SizedBox(width: 8),
              Text(
                l10n.translate('contact_info'),
                style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (_settings?.contactAddress.isNotEmpty == true) ...[
            _buildContactRow(
              theme,
              Icons.location_on_outlined,
              l10n.translate('address'),
              _settings!.contactAddress,
            ),
            const SizedBox(height: 8),
          ],
          if (_settings?.contactPhone.isNotEmpty == true) ...[
            _buildContactRow(
              theme,
              Icons.phone_outlined,
              l10n.translate('phone'),
              _settings!.contactPhone,
            ),
            const SizedBox(height: 8),
          ],
          if (_settings?.contactEmail.isNotEmpty == true)
            _buildContactRow(
              theme,
              Icons.email_outlined,
              l10n.translate('email'),
              _settings!.contactEmail,
            ),
        ],
      ),
    );
  }

  Widget _buildContactRow(
    ThemeData theme,
    IconData icon,
    String label,
    String value,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: theme.colorScheme.outline),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            '$label: $value',
            style: theme.textTheme.bodySmall,
          ),
        ),
      ],
    );
  }
}
