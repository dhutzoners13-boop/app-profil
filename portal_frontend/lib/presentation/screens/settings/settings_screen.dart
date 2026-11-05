import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:portal_frontend/core/constants/api_constants.dart';
import 'package:portal_frontend/core/localization/app_localizations.dart';
import 'package:portal_frontend/core/localization/locale_provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final TextEditingController _urlController = TextEditingController();
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _loadUrl();
  }

  Future<void> _loadUrl() async {
    final url = await ApiConstants.getBaseUrl();
    _urlController.text = url;
  }

  Future<void> _saveUrl() async {
    setState(() => _isSaving = true);
    await ApiConstants.setBaseUrl(_urlController.text.trim());
    if (!mounted) return;
    setState(() => _isSaving = false);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('URL API berhasil disimpan')),
    );
  }

  Future<void> _resetUrl() async {
    await ApiConstants.resetBaseUrl();
    _urlController.text = ApiConstants.defaultBaseUrl;
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('URL API dikembalikan ke default')),
    );
  }

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final localeProvider = context.watch<LocaleProvider>();
    final currentCode = localeProvider.locale.languageCode;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.translate('settings')),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Section: Language
          Text(
            l10n.translate('language'),
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(height: 8),
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: theme.colorScheme.outlineVariant),
            ),
            child: Column(
              children: [
                ListTile(
                  leading: const Text('🇮🇩', style: TextStyle(fontSize: 22)),
                  title: Text(l10n.translate('language_indonesian')),
                  trailing: currentCode == 'id'
                      ? Icon(Icons.check_circle_rounded, color: theme.colorScheme.primary)
                      : null,
                  onTap: () => localeProvider.setLocale(const Locale('id')),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Text('🇬🇧', style: TextStyle(fontSize: 22)),
                  title: Text(l10n.translate('language_english')),
                  trailing: currentCode == 'en'
                      ? Icon(Icons.check_circle_rounded, color: theme.colorScheme.primary)
                      : null,
                  onTap: () => localeProvider.setLocale(const Locale('en')),
                ),
              ],
            ),
          ),

          const SizedBox(height: 28),

          // Section: API Server Connection
          Text(
            l10n.translate('server_url'),
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Sesuaikan URL server backend Laravel jika diuji di emulator, device fisik, atau hosting.',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.outline,
            ),
          ),
          const SizedBox(height: 12),
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: theme.colorScheme.outlineVariant),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  TextField(
                    controller: _urlController,
                    decoration: InputDecoration(
                      hintText: l10n.translate('server_url_hint'),
                      border: const OutlineInputBorder(),
                      prefixIcon: const Icon(Icons.link_rounded),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      OutlinedButton(
                        onPressed: _resetUrl,
                        child: Text(l10n.translate('reset')),
                      ),
                      const SizedBox(width: 10),
                      FilledButton(
                        onPressed: _isSaving ? null : _saveUrl,
                        child: Text(l10n.translate('save')),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 28),

          // App Info
          Center(
            child: Column(
              children: [
                Icon(
                  Icons.account_balance_rounded,
                  size: 40,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(height: 8),
                Text(
                  'Portal Layanan Publik v1.0.0',
                  style: theme.textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Powered by Flutter & Laravel REST API',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.outline,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
