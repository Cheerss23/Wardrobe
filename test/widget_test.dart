import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:wardrobe_sense/main.dart';
import 'package:wardrobe_sense/providers/app_state.dart';

void main() {
  testWidgets('App renders correctly smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => AppState(),
        child: const WardrobeSenseApp(),
      ),
    );

    expect(find.text('Wardrobe Sense'), findsWidgets);
  });
}
