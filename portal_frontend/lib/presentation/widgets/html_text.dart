import 'package:flutter/material.dart';

class HtmlText extends StatelessWidget {
  final String html;
  final TextStyle? style;

  const HtmlText({
    super.key,
    required this.html,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    final cleanText = _stripHtml(html);
    final defaultStyle = style ?? Theme.of(context).textTheme.bodyMedium;

    return SelectableText(
      cleanText,
      style: defaultStyle?.copyWith(height: 1.6),
    );
  }

  String _stripHtml(String htmlString) {
    var text = htmlString
        .replaceAll(RegExp(r'<br\s*/?>', caseSensitive: false), '\n')
        .replaceAll(RegExp(r'</p>', caseSensitive: false), '\n\n')
        .replaceAll(RegExp(r'</li>', caseSensitive: false), '\n')
        .replaceAll(RegExp(r'<li[^>]*>', caseSensitive: false), '• ')
        .replaceAll(RegExp(r'<[^>]*>'), '')
        .replaceAll('&nbsp;', ' ')
        .replaceAll('&amp;', '&')
        .replaceAll('&lt;', '<')
        .replaceAll('&gt;', '>')
        .replaceAll('&quot;', '"')
        .replaceAll('&#39;', "'");

    // Remove excessive newlines
    text = text.replaceAll(RegExp(r'\n{3,}'), '\n\n');
    return text.trim();
  }
}

