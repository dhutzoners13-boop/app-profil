import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:portal_frontend/core/localization/locale_provider.dart';
import 'package:portal_frontend/main.dart';

void main() {
  testWidgets('PublicPortalApp smoke test loads and finds title', (WidgetTester tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => LocaleProvider()),
        ],
        child: const PublicPortalApp(),
      ),
    );

    // Initial pump
    await tester.pump();
  });
}
