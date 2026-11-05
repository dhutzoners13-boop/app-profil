import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:portal_frontend/core/localization/locale_provider.dart';

class LanguageSelectorButton extends StatelessWidget {
  final bool showLabel;

  const LanguageSelectorButton({
    super.key,
    this.showLabel = false,
  });

  @override
  Widget build(BuildContext context) {
    final localeProvider = context.watch<LocaleProvider>();
    final isId = localeProvider.locale.languageCode == 'id';

    return Tooltip(
      message: isId ? 'Switch to English' : 'Ganti ke Bahasa Indonesia',
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () => localeProvider.toggleLocale(),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Theme.of(context).colorScheme.outlineVariant,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                isId ? '🇮🇩 ID' : '🇬🇧 EN',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
              if (showLabel) ...[
                const SizedBox(width: 6),
                Text(
                  isId ? 'Indonesia' : 'English',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
