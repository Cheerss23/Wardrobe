import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:wardrobe_sense/main.dart';
import 'package:wardrobe_sense/models/models.dart';
import 'package:wardrobe_sense/providers/app_state.dart';
import 'package:wardrobe_sense/screens/try_on_result_screen.dart';
import 'package:wardrobe_sense/screens/try_with_wardrobe_screen.dart';
import 'package:wardrobe_sense/screens/wardrobe_screen.dart';

// 1x1 transparent png for test mocks
final List<int> _transparentImage = [
  0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A, 0x00, 0x00, 0x00, 0x0D,
  0x49, 0x48, 0x44, 0x52, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x01,
  0x08, 0x06, 0x00, 0x00, 0x00, 0x1F, 0x15, 0xC4, 0x89, 0x00, 0x00, 0x00,
  0x0A, 0x49, 0x44, 0x41, 0x54, 0x78, 0x9C, 0x63, 0x00, 0x01, 0x00, 0x00,
  0x05, 0x00, 0x01, 0x0D, 0x0A, 0x2D, 0xB4, 0x00, 0x00, 0x00, 0x00, 0x49,
  0x45, 0x4E, 0x44, 0xAE, 0x42, 0x60, 0x82,
];

class _FakeHttpClient extends Fake implements HttpClient {
  @override
  bool autoUncompress = true;

  @override
  Future<HttpClientRequest> getUrl(Uri url) async => _FakeHttpClientRequest();

  @override
  Future<HttpClientRequest> openUrl(String method, Uri url) async => _FakeHttpClientRequest();
}

class _FakeHttpClientRequest extends Fake implements HttpClientRequest {
  @override
  final HttpHeaders headers = _FakeHttpHeaders();

  @override
  Future<HttpClientResponse> close() async => _FakeHttpClientResponse();
}

class _FakeHttpHeaders extends Fake implements HttpHeaders {
  @override
  void set(String name, Object value, {bool preserveHeaderCase = false}) {}
}

class _FakeHttpClientResponse extends Fake implements HttpClientResponse {
  @override
  int get statusCode => 200;

  @override
  int get contentLength => _transparentImage.length;

  @override
  HttpClientResponseCompressionState get compressionState =>
      HttpClientResponseCompressionState.notCompressed;

  @override
  StreamSubscription<List<int>> listen(
    void Function(List<int> event)? onData, {
    Function? onError,
    void Function()? onDone,
    bool? cancelOnError,
  }) {
    return Stream<List<int>>.fromIterable([_transparentImage]).listen(
      onData,
      onError: onError,
      onDone: onDone,
      cancelOnError: cancelOnError,
    );
  }
}

class _TestHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) => _FakeHttpClient();
}

void main() {
  setUpAll(() {
    HttpOverrides.global = _TestHttpOverrides();
  });

  testWidgets('App renders correctly smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => AppState(),
        child: const WardrobeSenseApp(),
      ),
    );

    // Verify Fitly branding is visible
    expect(find.text('FITLY'), findsWidgets);
  });

  testWidgets('TryWithWardrobeScreen renders outfit combination and compatibility', (WidgetTester tester) async {
    final appState = AppState();
    final testProduct = appState.products[0];

    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: appState,
        child: MaterialApp(
          home: TryWithWardrobeScreen(product: testProduct),
        ),
      ),
    );

    await tester.pump();

    // Verify Title and Subtitle
    expect(find.text('Complete Your Look'), findsOneWidget);
    expect(find.text('Choose items you already own'), findsOneWidget);
    expect(find.text('Your Outfit'), findsOneWidget);
    expect(find.text('AI Outfit Compatibility'), findsOneWidget);
    expect(find.text('Try This Outfit'), findsOneWidget);
  });

  testWidgets('TryOnResultScreen displays Your New Look with commerce conversion CTAs', (WidgetTester tester) async {
    final appState = AppState();
    final testProduct = appState.products[0];
    final testResult = TryOnResult(
      id: 'test_res',
      title: 'Black Oversized Jacket Look',
      originalImageUrl: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=600',
      resultImageUrl: 'https://images.unsplash.com/photo-1516257984-b1b4d707412e?w=600',
      garments: [testProduct],
      newProduct: testProduct,
      ownedPieces: [appState.wardrobe[0], appState.wardrobe[3]],
      fitScore: 94,
      recommendedSize: 'Size L',
      date: 'Today, 29 Sep',
      occasion: 'Campus',
      style: 'Smart Casual',
      weather: '28°C Sunny',
    );

    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: appState,
        child: MaterialApp(
          home: TryOnResultScreen(result: testResult),
        ),
      ),
    );

    await tester.pump();

    // Verify Title and Primary Commerce CTAs (in app bar and bottom sheet)
    expect(find.text('Your New Look'), findsOneWidget);
    expect(find.text('Buy This Look'), findsOneWidget);
    expect(find.text('Add to Cart'), findsOneWidget);

    // Scroll down to check outfit breakdown
    await tester.drag(find.byType(ListView), const Offset(0, -400));
    await tester.pumpAndSettle();

    expect(find.text('Your Outfit'), findsOneWidget);
    expect(find.text('NEW'), findsOneWidget);
  });

  testWidgets('WardrobeScreen renders owned pieces, Saran Outfit Hari Ini, and Outfit Builder', (WidgetTester tester) async {
    final appState = AppState();

    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: appState,
        child: const MaterialApp(
          home: WardrobeScreen(),
        ),
      ),
    );

    await tester.pump();

    // Verify Title
    expect(find.text('Digital Wardrobe'), findsOneWidget);

    // Verify Tab Switcher: "Pakaian Saya" vs "Cari di Toko / Katalog"
    expect(find.textContaining('Pakaian Saya'), findsOneWidget);
    expect(find.text('Cari di Toko / Katalog'), findsOneWidget);

    // Verify Saran Outfit Hari Ini
    expect(find.text('Saran Outfit Hari Ini'), findsOneWidget);
    expect(find.text('Coba Outfit Hari Ini'), findsOneWidget);

    // Verify Outfit Builder (Susun Outfit Kamu)
    expect(find.text('Susun Outfit Kamu'), findsOneWidget);
    expect(find.text('Coba Outfit Ini'), findsOneWidget);

    // Verify tab switching to store catalog discovery
    await tester.tap(find.text('Cari di Toko / Katalog'));
    await tester.pump();

    expect(find.textContaining('Cari produk baru'), findsOneWidget);
  });
}

